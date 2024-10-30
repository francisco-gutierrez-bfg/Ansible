# Despliegue de Múltiples APIs en Kubernetes con Ansible

Este repositorio contiene un ejemplo de cómo desplegar múltiples APIs en un clúster de Kubernetes utilizando Ansible. Cada API se desplegará con su propio Deployment y Service para ser balanceadas por un balanceador de carga de tipo LoadBalancer.

## Requisitos

- Ansible instalado en el nodo de control.
- Un clúster de Kubernetes configurado y accesible desde el nodo de control.
- Imágenes Docker preparadas para cada API.

## Estructura del Repositorio

api_load_balancer.yml # Playbook de Ansible para desplegar APIs
templates/
 ├── api1-deployment.yaml.j2 # Plantilla Jinja2 para Deployment de API1
 ├── api1-service.yaml.j2 # Plantilla Jinja2 para Service de API1
 ├── api2-deployment.yaml.j2 # Plantilla Jinja2 para Deployment de API2
 ├── api2-service.yaml.j2 # Plantilla Jinja2 para Service de API2
 ├── api3-deployment.yaml.j2 # Plantilla Jinja2 para Deployment de API3
 └── api3-service.yaml.j2 # Plantilla Jinja2 para Service de API3


## Uso

1. **Modificar las Plantillas Jinja2**:
   - Modificar las plantillas `api*-deployment.yaml.j2` y `api*-service.yaml.j2` en el directorio `templates/` según los requisitos de las API y segun la cantidad de APIs que sean necesarias.

2. **Ejecutar el Playbook de Ansible**:
   ```sh
   ansible-playbook deploy_api_load_balancer.yml \
     -e "api1_image=your-api1-image:latest" \
     -e "api2_image=your-api2-image:latest" \
     -e "api3_image=your-api3-image:latest"

Reemplazar your-api1-image:latest, your-api2-image:latest y your-api3-image:latest, etc, con los nombres de imagen reales de las APIs.

Obtener las direcciones IP externas de los Services en caso de que se haya utilizado "type: LoadBalancer:"

kubectl get svc api1-service
kubectl get svc api2-service
kubectl get svc api3-service
