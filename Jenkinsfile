pipeline {
    agent any

    stages {
        stage('Who am I') {
            steps {
                echo "Building branch1: ${env.BRANCH_NAME}"
                sh 'terraform -version'
                sh 'aws sts get-caller-identity'
            }
        }
    }
}