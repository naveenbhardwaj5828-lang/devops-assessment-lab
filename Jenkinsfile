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
    }
}