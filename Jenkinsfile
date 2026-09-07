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
    }
}