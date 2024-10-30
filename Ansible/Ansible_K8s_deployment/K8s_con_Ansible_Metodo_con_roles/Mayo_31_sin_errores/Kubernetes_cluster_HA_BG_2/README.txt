# Configuración de Cluster Kubernetes con Ansible
# Autor: Francisco Javiuer Gutierrez | Unix/Linux Architect & Cloud Engineer

## Introducción:
Este proyecto contiene un conjunto de playbooks de Ansible para configurar un clúster de Kubernetes de alta disponibilidad con 3 nodos master y 4 nodos workers, 
utilizando HAProxy y Keepalived para la alta disponibilidad.

## Estructura del Proyecto
El proyecto está organizado de la siguiente manera:

kubernetes_ansible/
├── bg.yml
└── roles/
    └── kubernetes_cluster/
        ├── tasks/
        │   ├── main.yml
        │   ├── install_dependencies.yml
        │   ├── configure_kubernetes.yml
        │   ├── configure_containerd.yml
        │   ├── configure_firewall.yml
        │   ├── initialize_master.yml
        │   ├── join_nodes.yml
        │   ├── configure_haproxy.yml
        │   └── configure_keepalived.yml
        ├── files/
        │   └── containerd-config.toml
        ├── templates/
        │   ├── haproxy.cfg.j2
        │   └── keepalived.conf.j2
        ├── handlers/
        │   └── main.yml
        └── vars/
            └── main.yml


## Roles

### kubernetes_cluster
Este role se encarga de instalar y configurar un clúster de Kubernetes de alta disponibilidad con HAProxy y Keepalived.

#### Tareas Principales:

- `install_dependencies.yml`: Instala las dependencias necesarias.
- `configure_kubernetes.yml`: Configura Kubernetes.
- `configure_containerd.yml`: Instala y configura Containerd.
- `configure_firewall.yml`: Configura las reglas del firewall.
- `initialize_master.yml`: Inicializa los nodos maestros de Kubernetes.
- `join_nodes.yml`: Une los nodos al clúster de Kubernetes.
- `configure_haproxy.yml`: Configura y asegura HAProxy.
- `configure_keepalived.yml`: Configura y asegura Keepalived.

#### Archivos Importantes:

- `containerd-config.toml`: Archivo de configuración para Containerd.
- `haproxy.cfg.j2`: Plantilla para configurar HAProxy.
- `keepalived.conf.j2`: Plantilla para configurar Keepalived.

## Ejecución
1. Asegúrese de tener Ansible instalado
2. Asegúrese de que todos los nodos están configurados correctamente en el archivo `inventory`.
3. Ejecute el playbook principal desde el directorio raíz del proyecto:
   ansible-playbook -i inventory bg.yml



