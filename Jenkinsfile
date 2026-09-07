pipeline {
    agent any

    options {
        skipDefaultCheckout(true)
    }

    stages {

        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Validate HTML') {
            steps {
                echo 'Validating index.html'
                sh 'test -f index.html'
            }
        }

        stage('Docker Build') {
            steps {
                script {
                    env.APP_VERSION = sh(
                        script: "grep -oE 'Version: [0-9.]+' index.html | head -1 | cut -d' ' -f2",
                        returnStdout: true
                    ).trim()

                    env.IMAGE_NAME = "devops-demo:${env.APP_VERSION}"

                    echo "Building Docker image: ${env.IMAGE_NAME}"

                    sh 'docker build -t "$IMAGE_NAME" .'
                }
            }
        }

        stage('Deploy to EC2') {
            steps {
                echo "Deploying ${env.IMAGE_NAME} to Web EC2"

                sh '''
                    docker save "$IMAGE_NAME" | gzip > "devops-demo-${APP_VERSION}.tar.gz"
                '''

                sshagent(credentials: ['web-server-ssh-key']) {
                    sh '''
                        scp "devops-demo-${APP_VERSION}.tar.gz" \
                            scripts/deploy.sh \
                            ubuntu@172.31.3.37:/tmp/

                        ssh ubuntu@172.31.3.37 "
                            gunzip -c /tmp/devops-demo-${APP_VERSION}.tar.gz | docker load &&
                            chmod +x /tmp/deploy.sh &&
                            /tmp/deploy.sh ${IMAGE_NAME}
                        "
                    '''
                }
            }
        }

        stage('Health Check') {
            steps {
                echo 'Checking application health'
                sh 'curl --fail http://172.31.3.37/'
            }
        }
    }

    post {
        always {
            echo 'Cleaning temporary deployment files'
            sh 'rm -f devops-demo-*.tar.gz || true'
        }
    }
}