pipeline {
    agent any

    environment {
        DOCKER_IMAGE = 'shruthick99/my-spring-boot-app'
        DOCKER_TAG = 'latest'
        DOCKER_REGISTRY = 'docker.io'
        EC2_PUBLIC_IP = '13.58.196.90'  // Replace with your EC2's public IP
        RECIPIENTS = 'shrubuddy99@gmail.com'
        DOCKER_REGISTRY_CREDS = 'docker-hub-creds'  // Docker Hub credentials
        PROMETHEUS_CONFIG = '/home/ec2-user/prometheus.yml'  // Path to Prometheus config on EC2
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
                    withCredentials([usernamePassword(credentialsId: "${DOCKER_REGISTRY_CREDS}", usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')]) {
                        sh "echo \$DOCKER_PASSWORD | docker login -u \$DOCKER_USERNAME --password-stdin"
                    }
                    sh "docker push ${DOCKER_REGISTRY}/${DOCKER_IMAGE}:${DOCKER_TAG}"
                }
            }
        }

        stage('Deploy Spring Boot App to EC2') {
            steps {
                script {
                    withCredentials([sshUserPrivateKey(credentialsId: 'pipeline-ssh-key', keyFileVariable: 'SSH_PRIVATE_KEY')]) {
                        sh """
                            ssh -o StrictHostKeyChecking=no -i \$SSH_PRIVATE_KEY ec2-user@${EC2_PUBLIC_IP} ' \
                            docker pull ${DOCKER_REGISTRY}/${DOCKER_IMAGE}:${DOCKER_TAG} && \
                            docker ps -q --filter "name=spring-boot-app" | xargs -r docker stop && \
                            docker ps -a -q --filter "name=spring-boot-app" | xargs -r docker rm && \
                            docker run -d --name spring-boot-app -p 8080:8080 ${DOCKER_REGISTRY}/${DOCKER_IMAGE}:${DOCKER_TAG} '
                        """
                    }
                }
            }
        }

        stage('Deploy Prometheus') {
            steps {
                script {
                    withCredentials([sshUserPrivateKey(credentialsId: 'pipeline-ssh-key', keyFileVariable: 'SSH_PRIVATE_KEY')]) {
                        sh """
                            ssh -o StrictHostKeyChecking=no -i \$SSH_PRIVATE_KEY ec2-user@${EC2_PUBLIC_IP} ' \
                            docker run -d --name prometheus -p 9090:9090 \
                            -v ${PROMETHEUS_CONFIG}:/etc/prometheus/prometheus.yml prom/prometheus:latest '
                        """
                    }
                }
            }
        }

        stage('Deploy Grafana') {
            steps {
                script {
                    withCredentials([sshUserPrivateKey(credentialsId: 'pipeline-ssh-key', keyFileVariable: 'SSH_PRIVATE_KEY')]) {
                        sh """
                            ssh -o StrictHostKeyChecking=no -i \$SSH_PRIVATE_KEY ec2-user@${EC2_PUBLIC_IP} ' \
                            docker run -d --name grafana -p 3000:3000 grafana/grafana:latest '
                        """
                    }
                }
            }
        }
    }

    post {
        success {
            echo "Deployment to EC2 was successful!"
            emailext(
                subject: "Deployment Success: ${currentBuild.fullDisplayName}",
                body: "The deployment of ${currentBuild.fullDisplayName} to EC2 was successful.",
                to: "${env.RECIPIENTS}"
            )
        }
        failure {
            echo "Deployment to EC2 failed."
            emailext(
                subject: "Deployment Failed: ${currentBuild.fullDisplayName}",
                body: "The deployment of ${currentBuild.fullDisplayName} to EC2 failed. Please check the logs for details.",
                to: "${env.RECIPIENTS}"
            )
        }
    }
}
