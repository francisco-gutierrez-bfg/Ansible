Documentación para Implementar y Desplegar Playbook de Kubernetes con Ansible

Introducción
Este playbook de Ansible está diseñado para configurar un clúster de Kubernetes en un entorno de Linux, utilizando herramientas como kubeadm, containerd, flannel, metallb, e ingress-nginx. El playbook cubre desde la instalación de las dependencias necesarias hasta la configuración de redes y servicios esenciales para el funcionamiento de Kubernetes.

El playbook está dividido en varias secciones que configuran el sistema operativo, instalan los paquetes necesarios, configuran Kubernetes y sus dependencias, y finalmente despliegan los servicios de red y balanceo de carga. A continuación, se describe el contenido y la función de cada parte del playbook.

Tabla de Contenidos
 Introducción
 Requisitos Previos
 Desglose del Playbook de Despliegue de Kubernetes
  Configuración Inicial del Sistema
  Instalación de Kubernetes y sus Componentes
  Configuración de Flannel
Desglose de Playbook de MetalLB
  Despliegue de Balanceador de Carga MetalLB
  Despliegue de NGINX Ingress Controller
  Comandos para Aplicar el Playbook
Consideraciones Finales


Requisitos Previos
Antes de ejecutar este playbook, se deben cumplir los siguientes requisitos:

Tener acceso a un servidor con una distribución de Linux (Red Hat, CentOS, o similar).
Acceso root o privilegios de sudo para realizar cambios en el sistema.
Tener configurado un inventario de Ansible con los nodos de Kubernetes divididos en grupos masters y workers.
Tener configurado ansible en el sistema de administración.


Desglose del Playbook de Despliegue de Kubernetes  (k8s.yaml)

1. Configuración Inicial del Sistema
En esta primera parte del playbook se configuran los parámetros básicos del sistema para asegurar que el entorno sea adecuado para la instalación de Kubernetes.

Deshabilitar SELinux

- name: Deshabilitar SELinux permanentemente
  shell: |
    setenforce 0
    sed -i 's/^SELINUX=.*/SELINUX=disabled/' /etc/selinux/config

Objetivo: Deshabilitar SELinux, que puede interferir con el funcionamiento de contenedores y Kubernetes.

Deshabilitar el Firewall

- name: Deshabilitar firewalld permanentemente
  service:
    name: firewalld
    state: stopped
    enabled: no

Objetivo: Detener y deshabilitar firewalld para evitar conflictos con las reglas de red de Kubernetes.

Deshabilitar Swap

- name: Deshabilitar swap permanentemente
  shell: |
    swapoff -a
    sed -i '/swap/d' /etc/fstab

Objetivo: Deshabilitar la partición swap, que puede causar problemas con Kubernetes si está habilitada.

Cargar Módulos del Kernel

- name: Cargar módulos del kernel necesarios
  modprobe:
    name: "{{ item }}"
    state: present
  with_items:
    - br_netfilter
    - overlay

Objetivo: Cargar módulos del kernel necesarios para que Kubernetes pueda funcionar correctamente.

Configurar Parámetros de Sysctl

- name: Configurar parámetros de sysctl para Kubernetes networking
  sysctl:
    name: "{{ item.key }}"
    value: "{{ item.value }}"
    sysctl_set: yes
    state: present
    reload: yes
  with_items:
    - { key: "net.bridge.bridge-nf-call-iptables", value: "1" }
    - { key: "net.bridge.bridge-nf-call-ip6tables", value: "1" }
    - { key: "net.ipv4.ip_forward", value: "1" }

Objetivo: Configurar parámetros de red necesarios para la comunicación entre los nodos del clúster.

2. Instalación de Kubernetes y sus Componentes
Esta sección cubre la instalación de Kubernetes y sus dependencias principales.

Agregar Repositorio de Kubernetes

- name: Agregar repositorio de Kubernetes
  yum_repository:
    name: kubernetes
    description: Kubernetes Repository
    baseurl: https://pkgs.k8s.io/core:/stable:/v{{ kube_version }}/rpm/
    gpgcheck: yes
    enabled: yes
    gpgkey: https://pkgs.k8s.io/core:/stable:/v{{ kube_version }}/rpm/repodata/repomd.xml.key

Objetivo: Agregar el repositorio de Kubernetes para poder instalar los paquetes kubelet, kubeadm, y kubectl.

Instalar Dependencias Necesarias

- name: Instalar dependencias necesarias
  dnf:
    name:
      - conntrack
      - ipvsadm
      - ipset
      - jq
      - socat
      - ebtables
      - ethtool
      - kubelet
      - kubeadm
      - kubectl
    state: latest
    update_cache: yes

Objetivo: Instalar las dependencias necesarias para Kubernetes y las herramientas de red requeridas.

Configurar Kubelet

- name: Configurar kubelet para utilizar configuración correcta
  block:
    - name: Ensure kubelet config file contains required parameters
      blockinfile:
        path: /var/lib/kubelet/config.yaml
        block: |
          cgroupDriver: systemd
          containerRuntimeEndpoint: unix:///var/run/containerd/containerd.sock
          imagePullProgressDeadline: 2m
          runtimeRequestTimeout: 15m
          podInfraContainerImage: registry.k8s.io/pause:3.9
        create: yes
        marker: "# {mark} ANSIBLE MANAGED BLOCK - kubelet configuration"

Objetivo: Configurar kubelet con los parámetros adecuados para que se ejecute correctamente.

3. Configuración de Flannel
Flannel es el CNI (Container Network Interface) utilizado para la red de los pods, y MetalLB es utilizado como balanceador de carga para Kubernetes.

Instalar Flannel CNI

- name: Instalar Flannel CNI
  when: "'masters' in group_names"
  shell: kubectl apply -f https://github.com/flannel-io/flannel/releases/download/{{ flannel_version }}/kube-flannel.yml

Objetivo: Instalar Flannel como el CNI para gestionar la red de los pods.


Desglose de Playbook de MetalLB (metallb.yaml)

Instalar MetalLB

    - name: Instalar MetalLB
      block:
        - name: Crear namespace e instalar MetalLB
          shell: >
            kubectl create namespace metallb-system &&
            kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/{{ metallb_version }}/config/manifests/metallb-native.yaml

        - name: Eliminar posibles conflictos con los webhooks
          shell: kubectl delete ValidatingWebhookConfiguration metallb-webhook-configuration || true
          register: delete_webhook_result
          changed_when: "'not found' not in delete_webhook_result.stderr"

        - name: Configurar MetalLB
          copy:
            dest: /tmp/metallb-config.yaml
            content: |
              apiVersion: metallb.io/v1beta1
              kind: IPAddressPool
              metadata:
                name: default-pool
                namespace: metallb-system
              spec:
                addresses:
                - {{ metallb_ip }}
              ---
              apiVersion: metallb.io/v1beta1
              kind: L2Advertisement
              metadata:
                name: default
                namespace: metallb-system
              spec:
                ipAddressPools:
                - default-pool
          notify: Aplicar configuración de MetalLB

  handlers:
    - name: Aplicar configuración de MetalLB
      shell: kubectl apply -f /tmp/metallb-config.yaml

Objetivo: Instalar MetalLB para proporcionar un balanceador de carga en el clúster.

4. Despliegue de NGINX Ingress Controller
El controlador Ingress de NGINX permite gestionar el acceso HTTP y HTTPS a las aplicaciones desplegadas en Kubernetes.

- name: Instalar Ingress NGINX
  when: "'masters' in group_names"
  shell: kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/cloud/deploy.yaml

  Objetivo: Instalar y configurar NGINX como controlador Ingress para gestionar las solicitudes entrantes.

Comandos para Aplicar los Playbooks
Para aplicar los playbook de Ansible, puede seguir estos pasos:

Configura tu inventario de Ansible para que contenga los nodos masters y workers.
Ejecute el playbook utilizando el siguiente comando:

Para despliegue de Kubernetes:
 ansible-playbook -i inventario k8s.yaml 

Para despliegue de MetalLB:
 ansible-playbook -i inventario metallb.yaml

Estos comandos aplicarán los playbook en los nodos definidos en el archivo inventario

Consideraciones Finales
Los playbook proporcionan una forma automatizada de configurar un clúster de Kubernetes en un entorno Linux, incluyendo la instalación de herramientas y la configuración de redes. Asegúrese de revisar la configuración del entorno, especialmente la dirección IP de MetalLB, para garantizar que no haya conflictos en tu red.
