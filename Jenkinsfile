pipeline {
    agent any

    environment {
        EC2_KEY_PATH = "~/.ssh/jenkins.pem"   // Path to your PEM file
        EC2_USER = 'ec2-user'                 // EC2 user (for Amazon Linux)
        EC2_IP = '3.144.226.43'               // Your EC2 instance's public IP
        DEPLOY_DIR = '/home/ec2-user/deploy'  // Deployment directory on the EC2 instance
        GIT_REPO_URL = 'https://github.com/shruthick99/springboot.git' // Git repository URL
    }

    stages {
        stage('Checkout') {
            steps {
                // Clone the repository from the Git URL
                git branch: 'main', url: "${GIT_REPO_URL}"
            }
        }

        stage('Build') {
            steps {
                // Build the project (adjust according to your build tool)
                sh './mvnw clean install'  // Assuming you're using Maven; adjust for your build tool
            }
        }

        stage('Deploy to EC2') {
            steps {
                script {
                    // Copy the built artifact to the EC2 instance
                    sh """
                        scp -i ${EC2_KEY_PATH} -o StrictHostKeyChecking=no target/your-app.jar ${EC2_USER}@${EC2_IP}:${DEPLOY_DIR}
                    """
            
