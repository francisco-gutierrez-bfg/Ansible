Instalar Nginx Ingress Controller
---------------------------------
 Agregar el repositorio de Helm de Ingress Nginx:
  helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
  helm repo update

Instalar el Ingress Controller:
-------------------------------
 helm install my-ingress-nginx ingress-nginx/ingress-nginx

Esto instalará el Ingress Controller en tu clúster. Puedes verificar su estado con:
-----------------------------------------------------------------------------------
 kubectl get pods -n default -l app.kubernetes.io/name=ingress-nginx

Crear Servicios y Deployments
------------------------------
Definir los servicios y deployments para los APIs.
Cree tantos deployments (APIs) y servicios como sean necesarios 

Aquí hay un ejemplo básico para tres APIs.

api1.yaml:
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: api1
spec:
  replicas: 2
  selector:
    matchLabels:
      app: api1
  template:
    metadata:
      labels:
        app: api1
    spec:
      containers:
      - name: api1
        image: myregistry/api1:latest
        ports:
        - containerPort: 80

api1_service.yaml:
---
apiVersion: v1
kind: Service
metadata:
  name: api1
spec:
  selector:
    app: api1
  ports:
    - protocol: TCP
      port: 80
      targetPort: 80

api2_service.yaml:
---
apiVersion: v1
kind: Service
metadata:
  name: api2
spec:
  selector:
    app: api2
  ports:
    - protocol: TCP
      port: 80
      targetPort: 80

api1_service.yaml:
---
apiVersion: v1
kind: Service
metadata:
  name: api2
spec:
  selector:
    app: api2
  ports:
    - protocol: TCP
      port: 80
      targetPort: 80

api3_service.yaml:
---
apiVersion: v1
kind: Service
metadata:
  name: api3
spec:
  selector:
    app: api3
  ports:
    - protocol: TCP
      port: 80
      targetPort: 80

** Repetir para api<x> cambiando los nombres y las etiquetas. **

Crear un Ingress Resource
-------------------------
Definir un Ingress Resource para manejar el tráfico hacia los servicios API.

ingress.yaml:
---
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: api-ingress
  annotations:
    nginx.ingress.kubernetes.io/rewrite-target: /
spec:
  rules:
  - host: example.com
    http:
      paths:
      - path: /api1
        pathType: Prefix
        backend:
          service:
            name: api1
            port:
              number: 80
      - path: /api2
        pathType: Prefix
        backend:
          service:
            name: api2
            port:
              number: 80
      - path: /api3
        pathType: Prefix
        backend:
          service:
            name: api3
            port:
              number: 80

Configurar HTTPS (Opcional pero Recomendado)
--------------------------------------------
Configurar HTTPS es crucial para la seguridad. Puede usar Let's Encrypt para obtener certificados SSL gratuitos.

Crear un ClusterIssuer:
---
apiVersion: cert-manager.io/v1
kind: ClusterIssuer
metadata:
  name: letsencrypt-prod
spec:
  acme:
    server: https://acme-v02.api.letsencrypt.org/directory
    email: your-email@example.com
    privateKeySecretRef:
      name: letsencrypt-prod
    solvers:
    - http01:
        ingress:
          class: nginx

Aplicar el issuer:
------------------
 kubectl apply -f cluster_issuer_letsencrypt.yaml

Aplicar las Configuraciones:
----------------------------
 Aplicar las configuraciones de deployment, service e ingress:
  kubectl apply -f api1-deployment.yaml
  kubectl apply -f api1-service.yaml
  kubectl apply -f api2-deployment.yaml
  kubectl apply -f api2-service.yaml
  kubectl apply -f api2-deployment.yaml
  kubectl apply -f api2-service.yaml
  kubectl apply -f api_ingress_http_tres_apis.yaml

Verificar el Ingress:
*********************
kubectl get ingress
Asegúrarse de que el Ingress tenga una IP externa asignada.

Actualizar DNS:
---------------
Apuntar el dominio (por ejemplo, example.com) a la IP externa del Ingress.

Probar Acceso:
--------------
Usar un navegador o una herramienta como curl para probar el acceso a tus APIs:

 curl http://example.com/api1
 curl http://example.com/api2

Aplicar un Ingress para HTTPS:
---
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: api-ingress
  annotations:
    nginx.ingress.kubernetes.io/rewrite-target: /
    cert-manager.io/cluster-issuer: "letsencrypt-prod"
spec:
  tls:
  - hosts:
    - example.com
    secretName: example-com-tls
  rules:
  - host: example.com
    http:
      paths:
      - path: /api1
        pathType: Prefix
        backend:
          service:
            name: api1
            port:
              number: 80
      - path: /api2
        pathType: Prefix
        backend:
          service:
            name: api2
            port:
              number: 80

Aplicar el Ingress actualizado:
-------------------------------
 kubectl apply -f ingress.yaml

Conclusión
----------
Siguiendo estos pasos, habrás configurado un balanceador de carga en tu clúster de Kubernetes utilizando Nginx Ingress Controller para gestionar el tráfico hacia tus APIs, con la opción de HTTPS para mayor seguridad.