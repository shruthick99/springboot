pipeline {
    agent any

    environment {
        DOCKER_IMAGE = 'my-spring-boot-app'  // Name for the Docker image
        DOCKER_TAG = 'latest'               // Tag for the image
        DOCKER_REGISTRY = 'docker.io'       // Docker registry (e.g., Docker Hub)
    }

    stages {
        stage('Checkout') {
            steps {
                // Checkout the code from the 'master' branch of your repository
                git branch: 'master', url: 'https://github.com/shruthick99/springboot.git'
            }
        }

        stage('Build') {
            steps {
                // Run Maven build to package the Spring Boot app, skipping tests
                sh './mvnw clean package -DskipTests'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    // Build Docker image
                    sh "docker build -t ${DOCKER_REGISTRY}/${DOCKER_IMAGE}:${DOCKER_TAG} ."
                }
            }
        }

        stage('Push to Docker Registry') {
            steps {
                script {
                    // Log in to Docker Hub (you can also use AWS ECR or other registry)
                    withCredentials([usernamePassword(credentialsId: 'docker-hub-credentials', usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')]) {
                        sh "echo $DOCKER_PASSWORD | docker login -u $DOCKER_USERNAME --password-stdin"
                    }

                    // Push the Docker image to the registry
                    sh "docker push ${DOCKER_REGISTRY}/${DOCKER_IMAGE}:${DOCKER_TAG}"
                }
            }
        }

        stage('Deploy to EC2') {
            steps {
                script {
                    // SSH into EC2 instance and pull the latest image, then run it
                    sh """
                        ssh -o StrictHostKeyChecking=no ec2-user@your-ec2-public-ip ' \
                        docker pull ${DOCKER_REGISTRY}/${DOCKER_IMAGE}:${DOCKER_TAG} && \
                        docker ps -q -f name=spring-boot-app && \
                        docker stop spring-boot-app && \
                        docker rm spring-boot-app || true && \
                        docker run -d --name spring-boot-app -p 8081:8081 ${DOCKER_REGISTRY}/${DOCKER_IMAGE}:${DOCKER_TAG}'
                    """
                }
            }
        }
    }
}
