pipeline {
    agent any

    environment {
        DOCKER_IMAGE = 'shruthick99/my-spring-boot-app'
        DOCKER_TAG = 'latest'
        DOCKER_REGISTRY = 'docker.io'
        EC2_PUBLIC_IP = '34.213.22.11'  // Replace with your EC2's public IP
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'master', url: 'https://github.com/shruthick99/springboot.git'
            }
        }

        stage('Build') {
            steps {
                sh './mvnw clean package -DskipTests'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    sh "docker build -t ${DOCKER_REGISTRY}/${DOCKER_IMAGE}:${DOCKER_TAG} ."
                }
            }
        }

        stage('Push to Docker Registry') {
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: 'docker-hub-creds', usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')]) {
                        sh "echo $DOCKER_PASSWORD | docker login -u $DOCKER_USERNAME --password-stdin"
                    }
                    sh "docker push ${DOCKER_REGISTRY}/${DOCKER_IMAGE}:${DOCKER_TAG}"
                }
            }
        }

        stage('Deploy to EC2') {
            steps {
                script {
                    sh """
                        ssh -o StrictHostKeyChecking=no ec2-user@${EC2_PUBLIC_IP} \\
                        'docker pull ${DOCKER_REGISTRY}/${DOCKER_IMAGE}:${DOCKER_TAG} && \\
                        docker stop spring-boot-app || true && \\
                        docker rm spring-boot-app || true && \\
                        docker run -d --name spring-boot-app -p 8081:8081 ${DOCKER_REGISTRY}/${DOCKER_IMAGE}:${DOCKER_TAG}'
                    """
                }
            }
        }
    }
}
