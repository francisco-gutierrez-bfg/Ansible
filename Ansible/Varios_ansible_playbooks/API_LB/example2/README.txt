Despliegue de Balanceador de Carga para Múltiples APIs en Kubernetes
Este proyecto utiliza Kubernetes y Ansible para implementar y gestionar un balanceador de carga para múltiples APIs. Los archivos de configuración de Kubernetes definen los despliegues y servicios para cada API, y un recurso Ingress gestiona el enrutamiento del tráfico.

Requisitos
 - Kubernetes cluster configurado.
 - Controlador Ingress (por ejemplo, NGINX Ingress Controller) instalado en el clúster de Kubernetes.
 - Ansible instalado y configurado en tu máquina local o nodo de control.
 - Acceso al archivo kubeconfig de tu clúster de Kubernetes.

## Estructura de directorioa y archivos:
api-lb/
├── k8s-manifests/
│   ├── api1-deployment.yaml
│   ├── api1-service.yaml
│   ├── api2-deployment.yaml
│   ├── api2-service.yaml
│   └── ingress.yaml
├── despliegue-apis.yaml
└── README.md

## Descripción:
Descripción de los archivos y directorios:
api-lb/: Directorio raíz del proyecto.
  k8s-manifests/: Directorio que contiene los archivos de configuración YAML de Kubernetes.
    api1-deployment.yaml: Archivo YAML que define el despliegue de la API 1.
    api1-service.yaml: Archivo YAML que define el servicio de la API 1.
    api2-deployment.yaml: Archivo YAML que define el despliegue de la API 2.
    api2-service.yaml: Archivo YAML que define el servicio de la API 2.
    ingress.yaml: Archivo YAML que define el recurso Ingress para enrutar el tráfico a las APIs.
despliegue-apis.yaml: Playbook de Ansible para desplegar las APIs y el recurso Ingress en el clúster de Kubernetes.

Nota: Puede agregar las APIs que dese, solo debe crear el deployment y service de cada una, adicionalmente debe referenciarlas en el archivo ingress.yaml
