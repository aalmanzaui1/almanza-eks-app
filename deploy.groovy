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
                 cd /var/repos/almanza-eks-app/1-creating-infra-with-terraform
                 terraform apply -auto-approve -var="deploy-name=${param.deploy-name}" -var="env=${param.enviroment}"
                 """)
            }
        }
        stage('Deploy traefik') {
            steps{
                sh(script:"""\
                 cd /var/repos/almanza-eks-app/
                 helm install traefik 4-traefik/traefik
                 """)
            }
        }
        stage('Deploy ingress file') {
            steps{
                sh(script:"""\
                 cd /var/repos/almanza-eks-app/
                kubectl apply -f 4-traefik/ingress/ingress.yaml
                 """)
            }
        }
    }
}