pipeline {
    agent any

    environment {
        DOCKER_IMAGE = 'shruthick99/my-spring-boot-app'
        DOCKER_TAG = 'latest'
        DOCKER_REGISTRY = 'docker.io'
        EC2_PUBLIC_IP = '18.116.30.8'  // Replace with your EC2's public IP
        RECIPIENTS = 'shrubuddy99@gmail.com'  // Add your email address here
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
                    withCredentials([sshUserPrivateKey(credentialsId: 'pipeline-ssh-key', keyFileVariable: 'SSH_PRIVATE_KEY')]) {
                        sh """
                            ssh -o StrictHostKeyChecking=no -i \$SSH_PRIVATE_KEY ec2-user@${EC2_PUBLIC_IP} ' \
                            docker pull ${DOCKER_REGISTRY}/${DOCKER_IMAGE}:${DOCKER_TAG} && \
                            docker ps -q --filter "name=spring-boot-app" | xargs -r docker stop && \
                            docker ps -a -q --filter "name=spring-boot-app" | xargs -r docker rm && \
                            docker run -d --name spring-boot-app -p 8081:8081 ${DOCKER_REGISTRY}/${DOCKER_IMAGE}:${DOCKER_TAG} '
                        """
                    }
                }
            }
        }
    }

    post {
        success {
            echo "Deployment to EC2 was successful!"
            
            // Send email on success
            emailext (
                subject: "Deployment Success: ${currentBuild.fullDisplayName}",
                body: "The deployment of ${currentBuild.fullDisplayName} to EC2 was successful.",
                to: "${env.RECIPIENTS}",
                charset: 'UTF-8'
            )
        }
        failure {
            echo "Deployment to EC2 failed."
            
            // Send email on failure
            emailext (
                subject: "Deployment Failed: ${currentBuild.fullDisplayName}",
                body: "The deployment of ${currentBuild.fullDisplayName} to EC2 failed. Please check the logs for details.",
                to: "${env.RECIPIENTS}",
                charset: 'UTF-8'
            )
        }
        always {
            // Optionally, you can add a notification for every build (success or failure)
            emailext (
                subject: "Build Summary: ${currentBuild.currentResult} ${currentBuild.fullDisplayName}",
                body: "The build ${currentBuild.fullDisplayName} finished with status ${currentBuild.currentResult}.",
                to: "${env.RECIPIENTS}",
                charset: 'UTF-8'
            )
        }
    }
}
