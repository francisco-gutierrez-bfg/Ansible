# Autor: Francisco Javier Gutierrez | Unix/Linux Architect & Cloud Engineer

Proyecto Ansible para Desplegar Nginx como Balanceador de Carga en Kubernetes
=============================================================================

Descripción
------------
Este proyecto de Ansible está diseñado para desplegar y configurar Nginx como un balanceador de carga para aplicaciones y APIs en un clúster Kubernetes que ejecuta Red Hat 9.3. 
Importante: La configuración se aplica específicamente a los nodos worker.

Estructura del Proyecto
-----------------------
El proyecto está estructurado de la siguiente manera:

ansible-nginx-lb/
├── inventory
├── roles/
│   ├── nginx/
│   │   ├── tasks/
│   │   │   └── main.yaml
│   │   ├── handlers/
│   │   │   └── main.yaml
│   │   └── templates/
│   │       ├── nginx.conf.j2
│   │       └── default.conf.j2
└── playbook.yaml

Archivos y Directorios
----------------------
1. `inventory`: Archivo de inventario que define los nodos worker del clúster.
2. `roles/nginx/tasks/main.yml`: Tareas de Ansible para instalar y configurar Nginx.
3. `roles/nginx/handlers/main.yml`: Handlers para reiniciar Nginx cuando la configuración cambia.
4. `roles/nginx/templates/nginx.conf.j2`: Template de la configuración principal de Nginx.
5. `roles/nginx/templates/default.conf.j2`: Template de la configuración de balanceo de carga de Nginx.
6. `nginx_bg.yml`: Playbook principal que aplica el rol de Nginx a los nodos worker.

Configuración del Inventario
----------------------------
El archivo `inventory.yml` debe contener los detalles de los nodos worker en el clúster:
---
all:
  children:
    workers:
      hosts:
        worker1:
          ansible_host: worker1.example.com
        worker2:
          ansible_host: worker2.example.com
        worker3:
          ansible_host: worker3.example.com
        worker4:
          ansible_host: worker4.example.com

Asegúrese de reemplazar los nombres o IP de cada nodo en el inventario con los nombres de host o direcciones IP reales.

Despliegue
----------
Para desplegar Nginx como balanceador de carga en los nodos worker, ejecute los siguientes pasos:

 - Asegúrese de tener Ansible instalado en la máquina de control.
 - Sitúese dentro el directorio del proyecto.
 - Ejecute el playbook con el siguiente comando:
   ansible-playbook -i inventory playbook.yml

Esto aplicará la configuración de Nginx a los nodos worker especificados en tu archivo de inventario.

Configuraciones
---------------
roles/nginx/templates/nginx.conf.j2
Este archivo contiene la configuración principal de Nginx y directivas globales.

roles/nginx/templates/default.conf.j2
Este archivo contiene la configuración específica del balanceador de carga, incluyendo los upstreams para las APIs y aplicaciones.

Notas:
------
Asegúrese de que los nombres de los servicios (api1-service.default.svc.cluster.local, app1-service.default.svc.cluster.local, etc.) en el archivo default.conf sean correctos y existan en el clúster Kubernetes.
Personalice los archivos de configuración según las necesidades específicas del entorno.