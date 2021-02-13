# how to deploy traefik

helm install traefik 4-traefik/traefik

# how to deploy the ingress for expose the services
 kubectl apply -f 4-traefik/ingress/ingress.yaml