pipeline {
    agent any 
        environment { 
        //gitRepo = 'data'
        dirRepos = '/var/repos'
    }
    parameters {
        string(name: 'deploy-name', defaultValue: '', description: 'Name of the platform and eks cluster important to tagging the vpc resources correctly')
        choice(name: 'enviroment', choices: ['dev','prod'], description: 'size of the platform and the cluster eks nodes')
    }
    stages {
        stage('Deploy infra') {
            steps{
                sh(script:"""\
                 cd /var/repos/basic-eks-app/1-creating-infra-with-terraform
                 terraform apply -auto-approve -var="deploy-name=${param.deploy-name}" -var="env=${param.enviroment}"
                 """)
            }
        }
        stage('Deploy init k8s conf') {
            steps{
                sh(script:"""\
                 cd /var/repos/basic-eks-app/
                 echo "" > ~/.kube/config && aws eks update-kubeconfig --name "${param.deploy-name}"
                 kubectl apply -f 2-k8s-init-config
                 """)
            }
        }
        stage('Deploy helm charts') {
            steps{
                sh(script:"""\
                 cd /var/repos/basic-eks-app/
                 helm install --namespace istio-system istio-base 3-k8s-deploy-helm/istio-1.8.2/manifests/charts/base
                 helm install --namespace istio-system istiod 3-k8s-deploy-helm/istio-1.8.2/manifests/charts/istio-control/istio-discovery --set global.hub="docker.io/istio" --set global.tag="1.8.2"
                 helm install --namespace istio-system istio-ingress 3-k8s-deploy-helm/istio-1.8.2/manifests/manifests/charts/gateways/istio-ingress --set global.hub="docker.io/istio" --set global.tag="1.8.2"
                 helm install prometheus --namespace monitoring 3-k8s-deploy-helm/prometheus
                 helm install grafana --namespace monitoring 3-k8s-deploy-helm/grafana
                 helm install spinnaker --namespace continuousdelivery 3-k8s-deploy-helm/spinnaker
                 """)
            }
        }
        stage('Deploy addons') {
            steps{
                sh(script:"""\
                 cd /var/repos/basic-eks-app/
                 kubectl apply -f 4-k8s-addons   
                 """)
            }

        }
        stage('Deploy APP') {
            steps{
                sh(script:"""\
                 cd /var/repos/basic-eks-app/
                 kubectl apply -f 5-k8s-deploy-application   
                 """)
            }
        }
        stage('Get istio ingress endpoint') {
            steps {
                ENDPOINT = sh(script:"""\
                kubectl get svc -n istio-system -o=jsonpath='{.items[0].status.loadBalancer.ingress[0].hostname}'
                 """,returnStdout: true)

                sh(script:"""\
                 curl -vi ${ENDPOINT}
                 """)
            }
        }
    }
}