pipeline {
    agent any

    environment {
        EC2_KEY_PATH = "~/.ssh/jenkins.pem"   // Path to your PEM file
        EC2_USER = 'ec2-user'                 // EC2 user (for Amazon Linux)
        EC2_IP = '3.144.226.43'               // Your EC2 instance's public IP
        DEPLOY_DIR = '/home/ec2-user/deploy'  // Deployment directory on the EC2 instance
        GIT_REPO_URL = 'git@github.com:shruthick99/springboot.git' // Git repository SSH URL
    }

    stages {
        stage('Checkout') {
            steps {
                // Clone the repository from the Git URL using SSH
                git branch: 'master', url: "${GIT_REPO_URL}"
            }
        }

        stage('Build') {
            steps {
                // Build the project using Maven
                script {
                    def mvnExists = fileExists('./mvnw')
                    if (!mvnExists) {
                        error "Maven wrapper (mvnw) not found, please check your repository."
                    }
                    sh './mvnw clean install'  // Assuming you're using Maven; adjust for your build tool
                }
            }
        }

        stage('Deploy to EC2') {
            steps {
                script {
                    def jarFile = 'target/your-app.jar'
                    def jarExists = fileExists(jarFile)
                    if (!jarExists) {
                        error "Built artifact ${jarFile} not found, deployment aborted."
                    }
                    // Copy the built artifact to the EC2 instance
                    sh """
                        scp -i ${EC2_KEY_PATH} -o StrictHostKeyChecking=no ${jarFile} ${EC2_USER}@${EC2_IP}:${DEPLOY_DIR}
                    """
                    // Run the application on EC2
                    sh """
                        ssh -i ${EC2_KEY_PATH} -o StrictHostKeyChecking=no ${EC2_USER}@${EC2_IP} 'java -jar ${DEPLOY_DIR}/your-app.jar'
                    """
                }
            }
        }
    }

    post {
        failure {
            // Notify on failure (can be customized)
            echo "Pipeline failed! Please check the logs for more details."
        }
    }
}
