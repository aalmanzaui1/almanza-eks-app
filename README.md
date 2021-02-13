# almanza-eks-app

# WATCH THE VIDEO


[![WATCH](http://img.youtube.com/vi/DxyJ7GSNeZY/0.jpg)](http://www.youtube.com/watch?v=DxyJ7GSNeZY)



# Table of Contents
1. [Introduction](#Introduction )
2. [Tasks](#Tasks)
3. [How-to-deploy](#How-to-deploy)



# Introduction


This project pretends to demonstrate how to deploy an application using infrastructure as a code inside AWS cloud provider with Terraform, create an AWS EKS cluster to use Kubernetes as an orchestration tool, and implement and application to be expose using Traefik ingress controller

# Tasks
1. Create a Terraform project with the following elements:
    1. AWS VPC and its network elements (route tables, subnets, NatGW IGW)
    2. Create and ECR repository
    3. Create EKS Cluster
2. Create two docker containers with two simple applications. (I'm using Python)
3. Deploy the container in the EKS Cluster
4. Install traefik Helm chart
5. Deploy ingress file
6. Set route 53 to the traefik Load balancer ingress.



# How-to-deploy

## PRE-REQUISITES

1. AWS cli v2
2. kubectl
3. helm3

## Create Infra as a code


(check the variable.tf file in order to change any parameter that you need, by default it has been set to work but may be will be good idea modified the variable "ip-eks-access" to restrict the access to the api eks cluster and this ip also allows the sg to the incoming traffic.)

(the terraform backend has been commented to avoid the creation of the s3 bucket, if you wish, you can create it and save the tf state in that container.)

access to "1-creating-infra-with-terraform" and execute the command:

```bash
cd 1-creating-infra-with-terraform
terraform apply -var="deploy-name=almanza-app-lab-a" -var="env=dev"

```

The terraform will create all the infraestructura and will create a deployment and service inside of the cluster with the container applications

## Deploy Traefik Helm chart:

from root project folder execute: 

```bash

helm install traefik 4-traefik/traefik

```

The helm chart create the schema to deploy the ingress controller

## Deploy ingress file:

(you will have to modified the host parameter to match with the public domain to test it)
from root project folder execute: 


```bash

kubectl apply -f 4-traefik/ingress/ingress.yaml

```

The helm chart create the schema to deploy the ingress controller


## Set Route 53 record:

using aws console create the record in the same way that you set it in the ingress file host variable.

## Destroy the stack:

IMPORTANT: delete first the helm chart to avoid errors in the terraform destroy, this chart create a hardware link elements with the service k8s that could avoid the destroy

Destroy in the backwards order that you deploy

## More info:

Additional, you will see a file called "deploy.groovy" is a declarative Jenkins Pipeline if you want to deploy using jenkins. This jenkins must have:

1. the pre-requisites
2. proper aws credentials
3. proper aws - kubernetes kubeconfig