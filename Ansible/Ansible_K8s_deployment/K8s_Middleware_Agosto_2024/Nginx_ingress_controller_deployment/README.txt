# Configuración de Cluster Kubernetes con Ansible
# Autor: Francisco Javier Gutierrez | Unix/Linux Architect & Cloud Engineer

## Despliegue de NGINX Ingress en Kubernetes con Ansible
Este proyecto utiliza Ansible para desplegar el controlador de NGINX Ingress en un clúster de Kubernetes. El despliegue se realiza aplicando manifests YAML a través de kubectl.

### Estructura del Proyecto

Nginx_ingress_controller_deployment/
├── inventory
├── nginx_deployment.yml
└── files/
    ├── namespace.yaml
    ├── rbac.yaml
    ├── deployment.yaml
    └── service.yaml

### Detalles de la estructura:
inventory/hosts: Archivo de inventario de Ansible.
nginx_deployment.yml: Playbook de Ansible para desplegar NGINX Ingress.
files/: Carpeta que contiene los manifests YAML para los recursos de Kubernetes.

### Prerrequisitos
Ansible: Debes tener Ansible instalado en tu máquina local.
Kubectl: Asegúrese de tener kubectl configurado y que puedas acceder al clúster de Kubernetes desde la máquina donde ejecutarás Ansible.
Acceso al Clúster de Kubernetes: La máquina desde la que se ejecuta Ansible debe tener acceso a tu clúster de Kubernetes.

### Archivos de Manifests
namespace.yaml: Define el namespace ingress-nginx.
rbac.yaml: Configura los roles y permisos necesarios para el controlador de Ingress.
deployment.yaml: Despliega el controlador de NGINX Ingress.
service.yaml: Expone el controlador de Ingress como un servicio tipo LoadBalancer.

### Instrucciones de Uso
Configurar el Inventario: El archivo inventory/hosts está configurado para ejecutar Ansible en localhost. 
                          Asegúrese de que el entorno tiene acceso a kubectl.

Ejecutar el Playbook: Ir al directorio del proyecto y ejecute el siguiente comando:
 ansible-playbook -i inventory/hosts playbook.yml
Este comando aplicará los manifests YAML en el clúster de Kubernetes utilizando kubectl.

### Verificación
Después de ejecutar el playbook, puede verificar el estado del despliegue usando los siguientes comandos de kubectl:

### Verificar los pods del controlador de NGINX Ingress:
 kubectl get pods -n ingress-nginx -o wide

### Verificar el servicio expuesto:
 kubectl get svc -n ingress-nginx

### Notas
RBAC: El archivo rbac.yaml configura roles y permisos necesarios para el controlador de Ingress. 
Asegúrese de que estos roles y permisos sean adecuados para el entorno de Kubernetes.
Servicio de Tipo LoadBalancer: El servicio se configura como LoadBalancer. 
Si está en un entorno que no soporta LoadBalancer, considere cambiar el tipo de servicio a NodePort y ajustar las configuraciones de red según sea necesario.
