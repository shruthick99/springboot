pipeline {
    agent any

    environment {
        // Docker Image details
        DOCKER_IMAGE = 'shruthick99/my-spring-boot-app:latest'
        // EC2 Instance details
        EC2_INSTANCE = 'ec2-user@3.137.212.65'  // Update with your EC2 public IP
        EC2_KEY_ID = 'ec2-ssh-key'  // Use the Jenkins credential ID for SSH access
    }

    stages {
        stage('Checkout') {
            steps {
                script {
                    // Checkout the latest code from the master branch
                    git branch: 'master', url: 'https://github.com/shruthick99/springboot.git'
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    // Build the Docker image using the Dockerfile
                    sh 'docker build -t $DOCKER_IMAGE .'
                }
            }
        }

        stage('Push Docker Image to Docker Hub') {
            steps {
                script {
                    // Login to Docker Hub (use your Docker Hub credentials)
                    withCredentials([usernamePassword(credentialsId: 'dockerhub-creds', passwordVariable: 'DOCKER_PASSWORD', usernameVariable: 'DOCKER_USERNAME')]) {
                        sh 'docker login -u $DOCKER_USERNAME -p $DOCKER_PASSWORD'

                        // Push the image to Docker Hub
                        sh 'docker push $DOCKER_IMAGE'
                    }
                }
            }
        }

        stage('Deploy to EC2') {
            steps {
                script {
                    // SSH into EC2 and deploy the Docker container
                    withCredentials([sshUserPrivateKey(credentialsId: "$EC2_KEY_ID", keyFileVariable: 'SSH_KEY')]) {
                        sh """
                            echo "Deploying Docker container to EC2..."

                            # SSH into EC2 and perform the actions
                            ssh -i \$SSH_KEY $EC2_INSTANCE '
                                # Stop and remove any existing container
                                docker stop my-spring-boot-app || true && \
                                docker rm my-spring-boot-app || true && \
                                
                                # Pull the latest Docker image from Docker Hub
                                docker pull $DOCKER_IMAGE && \

                                # Run the Docker container on EC2
                                docker run -d --name my-spring-boot-app -p 8081:8081 $DOCKER_IMAGE
                            '
                        """
                    }
                }
            }
        }
    }

    post {
        success {
            echo 'Deployment was successful!'
        }
        failure {
            echo 'Deployment failed!'
        }
    }
}
