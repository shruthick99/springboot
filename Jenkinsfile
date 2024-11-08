pipeline {
    agent any

    environment {
        DOCKER_IMAGE = 'shruthick99/spring-boot-app:latest'
        EC2_HOST = '52.15.191.224'  // Replace with your EC2 IP
    }

    stages {
        stage('Build Docker Image') {
            steps {
                script {
                    // Build Docker image
                    sh 'docker build -t $DOCKER_IMAGE .'
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                script {
                    // Push Docker image to Docker Hub
                    sh 'docker push $DOCKER_IMAGE'
                }
            }
        }

        stage('Deploy to EC2') {
            steps {
                script {
                    // Pull Docker image and run on EC2 using PEM from Jenkins Credentials
                    withCredentials([file(credentialsId: 'ec2-pem', variable: 'PEM_FILE')]) {
                        sh """
                            ssh -i \$PEM_FILE -o StrictHostKeyChecking=no ec2-user@$EC2_HOST << 'EOF'
                            docker pull $DOCKER_IMAGE
                            docker run -d -p 8081:8080 $DOCKER_IMAGE
                            EOF
                        """
                    }
                }
            }
        }
    }
}
