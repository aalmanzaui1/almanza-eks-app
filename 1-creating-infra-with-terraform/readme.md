# Deploy Infraestructure with terraform

```bash
cd 1-creating-infra-with-terraform
terraform apply -var="deploy-name=almanza-app-lab-a" -var="env=dev" -var="ip-eks-access=["0.0.0.0/0"]"
```

