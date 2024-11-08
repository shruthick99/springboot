pipeline {
    agent any
    environment {
        DOCKER_IMAGE = 'shruthick99/springboot:v1.0.0'
        DOCKER_USERNAME = 'shruthick99'
        DOCKER_PASSWORD = 'Dockerhub@123'
    }
    stages {
        stage('Checkout SCM') {
            steps {
                checkout scm
            }
        }
        
        stage('Login to Docker Hub') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub-creds', usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')]) {
                    script {
                        // Perform docker login using the provided credentials
                        sh "echo $DOCKER_PASSWORD | docker login -u $DOCKER_USERNAME --password-stdin"
                    }
                }
            }
        }
        
        stage('Pull Docker Image') {
            steps {
                script {
                    // Pull the specified Docker image from Docker Hub
                    sh "docker pull ${DOCKER_IMAGE}"
                }
            }
        }
        
        stage('Stop and Remove Old Container') {
            steps {
                script {
                    // Stop and remove any existing containers named 'springboot'
                    sh "docker ps -q --filter name=springboot | xargs -r docker stop"
                    sh "docker ps -a -q --filter name=springboot | xargs -r docker rm"
                }
            }
        }
        
        stage('Run Docker Container') {
            steps {
                script {
                    // Run the Docker container on a different external port (e.g., 8081 to avoid conflict with Jenkins)
                    sh "docker run -d -p 8081:8080 --name springboot ${DOCKER_IMAGE}"
                }
            }
        }
    }
    post {
        always {
            echo 'Pipeline finished.'
        }
        failure {
            echo 'Pipeline failed. Please check the logs.'
        }
    }
}
