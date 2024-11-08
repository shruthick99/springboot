pipeline {
    agent any

    environment {
        DOCKER_HUB_CREDENTIALS = 'dockerhub-creds'  // The ID of your Docker Hub credentials in Jenkins
        IMAGE_NAME = 'shruthick99/springboot'       // Docker image name
        IMAGE_TAG = 'v1.0.1'                        // The new tag for your image
    }

    stages {
        stage('Checkout SCM') {
            steps {
                // Checkout your Git repository
                checkout scm
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    // Build Docker image with the new tag
                    docker.build("${IMAGE_NAME}:${IMAGE_TAG}")
                }
            }
        }

        stage('Login to Docker Hub') {
            steps {
                script {
                    // Docker login using credentials stored in Jenkins
                    withCredentials([usernamePassword(credentialsId: DOCKER_HUB_CREDENTIALS, usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')]) {
                        sh "echo $DOCKER_PASSWORD | docker login -u $DOCKER_USERNAME --password-stdin"
                    }
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                script {
                    // Push the Docker image to Docker Hub
                    sh "docker push ${IMAGE_NAME}:${IMAGE_TAG}"
                }
            }
        }

        stage('Deploy on EC2') {
            steps {
                script {
                    // Run Docker commands directly on the EC2 instance (Jenkins is already running on EC2)
                    sh """
                    docker pull ${IMAGE_NAME}:${IMAGE_TAG}
                    docker stop springboot || true
                    docker rm springboot || true
                    docker run -d -p 8081:8081 --name springboot ${IMAGE_NAME}:${IMAGE_TAG}
                    """
                }
            }
        }
    }

    post {
        success {
            echo 'Pipeline completed successfully!'
        }
        failure {
            echo 'Pipeline failed. Please check the logs.'
        }
    }
}
