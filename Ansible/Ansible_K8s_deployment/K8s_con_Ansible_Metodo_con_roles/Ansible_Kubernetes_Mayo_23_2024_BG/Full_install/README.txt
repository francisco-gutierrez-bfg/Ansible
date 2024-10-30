# Instalación y Configuración de un Cluster Kubernetes de Alta Disponibilidad con Ansible

Este proyecto automatiza la instalación y configuración de un clúster de Kubernetes de alta disponibilidad con 3 nodos master y 4 nodos worker utilizando Ansible. 
La configuración con Containerd, la instalación y configuración de HAProxy para balanceo de carga, Keepalived para la alta disponibilidad, y reglas de firewalld, 
además de la activación del reenvío de IP.

## Prerrequisitos
 - Componentes:
   3 nodos master
   4 nodos worker

 - Sistema Operativo: 
   Red Hat Enterprise Linux 9.3

 - Conectividad:
   Todos los nodos deben poder comunicarse entre sí.

 - Acceso SSH:
   Configurar el acceso SSH sin contraseña entre el controlador de Ansible y los nodos.


## Inventario de Ansible:
Crear un archivo de inventario inventory.ini con el siguiente contenido:
---
[masters]
master1 ansible_host=172.16.0.91
master2 ansible_host=172.16.1.92
master3 ansible_host=172.16.1.93

[workers]
worker1 ansible_host=172.16.1.94
worker2 ansible_host=172.16.1.95
worker3 ansible_host=172.16.1.96
worker4 ansible_host=172.16.1.97

[all:vars]
ansible_user=tu_usuario


## Estructura del Proyecto

kubernetes-cluster-setup/
├── README.txt
├── inventory
├── site.yml
└── roles/
    ├── haproxy/
    │   ├── tasks/
    │   │   └── main.yml
    │   └── templates/
    │       └── haproxy.cfg.j2
    └── keepalived/
        ├── tasks/
        │   └── main.yml
        └── templates/
            ├── check_haproxy.sh.j2
            └── keepalived.conf.j2

- site.yml: 
 - roles/: Directorio que contiene los roles de Ansible.
 -  └──haproxy/: Rol para la instalación y configuración de HAProxy.
        └──
 -  └──keepalived/: Rol para la instalación y configuración de Keepalived.
        └──

## Roles:
Los roles permitirán la instalación de componentes adicionales del cluster.

bg:
---
- Playbook principal de Ansible.
- Instala paquetes requeridos: 
  - firewalld
  - iptables-services
  - ntp
  - wget
  - curl
  - containerd.io
- Configura firewalld para abrir los puertos necesarios.
- Configura el reenvío de IP y otros parámetros de red.

haproxy:
--------
- Instala HAProxy.
- Configura HAProxy para balancear la carga entre los nodos master.

keepalived:
-----------
- Instala Keepalived.
- Configura Keepalived para monitorear HAProxy y asegurar la alta disponibilidad utilizando una IP virtual.

## Cómo Ejecutar el Playbook de Ansible:
ansible-playbook -i inventory.ini bg.yml

Consideraciones:
----------------
Swap: Asegurarse de que el swap esté deshabilitado en todos los nodos.
Red: Verificar que el módulo br_netfilter esté cargado y configurado.

Información de Contacto:
------------------------
Para cualquier duda o soporte, por favor contacta a: francisco.gutierrez@globallogic.com