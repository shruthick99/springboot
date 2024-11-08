pipeline {
    agent any

    environment {
        DOCKER_IMAGE_NAME = "shruthick99/springboot:v1.0.0"
        CONTAINER_NAME = "springboot"
        DOCKERHUB_CREDENTIALS = "dockerhub-creds" // This is the ID of your credentials
    }

    stages {
        stage('Checkout SCM') {
            steps {
                checkout scm
            }
        }

        stage('Login to Docker Hub') {
            steps {
                script {
                    // Use the credentials stored in Jenkins
                    withCredentials([usernamePassword(credentialsId: DOCKERHUB_CREDENTIALS, usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                        // Login to Docker Hub using the credentials
                        sh "docker login -u $DOCKER_USER -p $DOCKER_PASS"
                    }
                }
            }
        }

        stage('Pull Docker Image') {
            steps {
                script {
                    // Pull the Docker image from Docker Hub
                    sh "docker pull ${DOCKER_IMAGE_NAME}"
                }
            }
        }

        stage('Stop and Remove Old Container') {
            steps {
                script {
                    sh '''
                        docker ps -q --filter "name=${CONTAINER_NAME}" | xargs -r docker stop
                        docker ps -a -q --filter "name=${CONTAINER_NAME}" | xargs -r docker rm
                    '''
                }
            }
        }

        stage('Run Docker Container') {
            steps {
                script {
                    sh "docker run -d -p 8080:8080 --name ${CONTAINER_NAME} ${DOCKER_IMAGE_NAME}"
                }
            }
        }
        
        stage('Post Actions') {
            steps {
                echo "Deployment completed successfully."
            }
        }
    }

    post {
        failure {
            echo "Pipeline failed. Please check the logs for details."
        }
    }
}
