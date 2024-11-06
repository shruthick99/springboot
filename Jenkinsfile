pipeline {
    agent any
    
    environment {
        // Define environment variables here
        EC2_PRIVATE_KEY_PATH = "/var/lib/jenkins/.ssh/jenkins.pem"  // Path to your EC2 private key
        EC2_USER = "ec2-user"  // EC2 user
        EC2_HOST = "3.145.195.58"  // EC2 instance IP address
        APP_NAME = "demo"  // Application name
        TARGET_PORT = "8081"  // Target port for your Spring Boot app
    }

    stages {
        stage('Checkout') {
            steps {
                // Checkout the code from Git repository
                git branch: 'main', url: 'https://github.com/shruthick99/springboot.git'
            }
        }

        stage('Build with Maven') {
            steps {
                // Clean and build the Spring Boot application
                sh 'mvn clean package'
            }
        }

        stage('Deploy Application to EC2') {
            steps {
                script {
                    // Update the Spring Boot application's application.properties or application.yml
                    // to use the desired port
                    sh "echo 'server.port=${TARGET_PORT}' >> src/main/resources/application.properties"

                    // SSH into EC2 and deploy
                    sh """
                    ssh -o StrictHostKeyChecking=no -i ${EC2_PRIVATE_KEY_PATH} ${EC2_USER}@${EC2_HOST} '
                        # Stop existing application if running
                        sudo pkill -f demo || true

                        # Copy the built JAR to EC2 (using SCP)
                        scp -i ${EC2_PRIVATE_KEY_PATH} target/${APP_NAME}-0.0.1-SNAPSHOT.jar ${EC2_USER}@${EC2_HOST}:/home/${EC2_USER}/${APP_NAME}.jar

                        # Start the Spring Boot app on the specified port
                        nohup java -jar /home/${EC2_USER}/${APP_NAME}.jar > /home/${EC2_USER}/app.log 2>&1 &
                    '
                    """
                }
            }
        }
    }

    post {
        always {
            echo "Deployment finished."
        }

        failure {
            echo "Build or deployment failed!"
        }
    }
}
