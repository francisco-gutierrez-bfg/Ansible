# Configuración de Cluster Kubernetes con Ansible
# Autor: Francisco Javiuer Gutierrez | Unix/Linux Architect & Cloud Engineer

## Introducción:
Este proyecto contiene un conjunto de playbooks de Ansible para configurar un clúster de Kubernetes de alta disponibilidad con 3 nodos master y 4 nodos workers, 
utilizando HAProxy y Keepalived para la alta disponibilidad.

## Estructura del Proyecto
El proyecto está organizado de la siguiente manera:

kubernetes_ansible/
├── bg.yml
└── playbooks/
     ├── main.yml
     │   ├── instalar_dependencias.yml
     │   ├── configurar_containerd.yml
     │   ├── configurar_firewalld.yml
     │   ├── configurar_haproxy.yml
     │   ├── configurar_keepalived.yml
     │   ├── configurar_kubernetes.yml
     │   ├── configurar_metallb.yml
     │   └── limpiar_kubernetes.yml   <--- Este playbook limpia configuraciones de Kubernetes con el fin de inicializar una nueva configuración
     ├── files/
     │   └── containerd-config.toml
     └── templates/
         ├── haproxy.cfg.j2
         └── keepalived.conf.j2


## Playbooks

Estos playbooks se encargan de instalar y configurar un clúster de Kubernetes de alta disponibilidad con HAProxy y Keepalived.

#### Tareas Principales:

- `instalar_dependencias.yml`: Instala las dependencias necesarias.
- `configurar_containerd.yml`: Instala y configura Containerd.
- `configurar_firewall.yml`: Configura las reglas del firewall.
- `configure_haproxy.yml`: Configura y asegura HAProxy (Alta disponibilidad).
- `configure_keepalived.yml`: Configura y asegura Keepalived.
- `configurar_kubernetes.yml`: Configurar Kubernetes, inicializar nodos, instalar CNI y unir nodos al cluster
- `configurar_metallb.yml`: Configurar el balanceador de carga de las aplicaciones/deployments.
- `limpiar_kubernetes.yml`: Reset de las configuraciones cn el fin de inicializasr una nueva.


#### Archivos Importantes:

- `containerd-config.toml`: Archivo de configuración para Containerd.
- `haproxy.cfg.j2`: Plantilla para configurar HAProxy.
- `keepalived.conf.j2`: Plantilla para configurar Keepalived.

## Ejecución
1. Asegúrese de tener Ansible instalado
2. Asegúrese de que todos los nodos están configurados correctamente en el archivo `inventory`.
3. Ejecute el playbook principal desde el directorio raíz del proyecto:
   ansible-playbook -i inventory bg.yml
4. Es recomendable ejecutar cada playbook individualmente con el fin de tener un mayor control y seguimiento del proceso, 
   para ello ejecute los playbooks de la siguiente manera:
    ansible-´playbook -i ansible-playbook -i inventory playbooks/<playbook.yml>
   Ejemplo:
    ansible-´playbook -i inventory playbooks/instalar_dependencias.yml
    




