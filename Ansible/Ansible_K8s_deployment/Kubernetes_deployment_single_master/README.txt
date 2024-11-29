# Configuración de Cluster Kubernetes con Ansible
# Autor: Francisco Javier Gutierrez | Unix/Linux Architect & Cloud Engineer

## Introducción:
Este proyecto contiene un conjunto de playbooks de Ansible para configurar un clúster de Kubernetes con 1 nodo master y 3 nodos workers, 
El proyecto tiene como objetivo automatizar el despliegue de un clúster de Kubernetes en Red Hat 9.5 utilizando Ansible. 
Se instalarán las dependencias esenciales, se configurará containerd como el runtime de contenedores y se instalarán los componentes de Kubernetes. 
Además, se instalarán los complementos Flannel, MetalLB y NGINX Ingress.


## Estructura del Proyecto
El proyecto está organizado de la siguiente manera:

ansible-kubernetes-cluster/
├── inventory.ini
├── playbook.yml
└── README.txt


## Inventory
Hosts que componen el cluster

[masters]
master1 ansible_host=172.16.1.91
master2 ansible_host=172.16.1.92
master3 ansible_host=172.16.1.93

[workers]
worker1 ansible_host=172.16.1.94
worker2 ansible_host=172.16.1.95
worker3 ansible_host=172.16.1.96

## Playbooks

# Descripción del Playbook:
El playbook se encuentra en 'playbook.yml' y contiene los pasos necesarios para configurar el sistema, instalar dependencias e instalar Kubernetes y sus complementos asociados.

# Instrucciones para Ejecutar el Playbook:
  - Actualizar el archivo 'inventory.ini' con las direcciones IP correctas de los nodos.
  - Ejecutar el playbook utilizando el siguiente comando:
    ansible-playbook -i inventory.ini playbook.yml

# Verificación del Despliegue del Clúster:
Una vez completada la ejecución, verificar el estado del clúster ejecutando los siguientes comandos:
  kubectl get nodes
  kubectl get pods --all-namespaces

#### Archivos Importantes:
Files:
- `kubeadm-config.yam`: Archivo de configuración para Kubeadm.
group_vars:
- `vars.yml`: Variables que almacenarán datos necesarios para el despliegue del cluster y paquetes necesarios.



