pipeline {
    agent any
    
    environment {
        // Define environment variables
        REPO_URL = 'https://github.com/shruthick99/springboot.git'  // Replace with your GitHub repo URL
        BRANCH = 'main'  // Replace with the branch you want to deploy from
        EC2_USER = 'ec2-user'  // The SSH user for your EC2 instance
        EC2_HOST = '3.144.226.43'  // Replace with your EC2 public IP or DNS
        SSH_KEY_ID = '7551dc5b-481f-442c-987b-c190316488ce'  // The ID of the SSH key in Jenkins credentials
    }

    stages {
        stage('Checkout Code') {
            steps {
                // Clone the repository from GitHub
                git branch: "${BRANCH}", url: "${REPO_URL}"
            }
        }

        stage('Build Spring Boot Application') {
            steps {
                script {
                    // Install dependencies and build the Spring Boot application
                    sh './mvnw clean package -DskipTests'
                }
            }
        }

        stage('Deploy to EC2') {
            steps {
                script {
                    // Use SSH to copy the jar file to the EC2 instance and run it
                    sshagent(credentials: [SSH_KEY_ID]) {
                        // Copy the generated jar to EC2 instance
                        sh "scp -o StrictHostKeyChecking=no target/your-app.jar ${EC2_USER}@${EC2_HOST}:/home/${EC2_USER}/"

                        // SSH into the EC2 instance and run the Spring Boot application
                        sh "ssh -o StrictHostKeyChecking=no ${EC2_USER}@${EC2_HOST} 'nohup java -jar /home/${EC2_USER}/your-app.jar &'"
                    }
                }
            }
        }
    }

    post {
        success {
            echo 'Deployment successful!'
        }
        failure {
            echo 'Deployment failed!'
        }
    }
}
