pipeline {
    agent any

    environment {
        REPO_URL = 'https://github.com/shruthick99/springboot.git' // Replace with your GitHub repo URL
        APP_NAME = 'spring-boot-hello-world'
        APP_JAR = 'target/${demo}-0.0.1-SNAPSHOT.jar' // Update this with your actual JAR naming convention
        EC2_USER = 'ec2-user' // Your EC2 instance's SSH username (could be ec2-user, ubuntu, etc.)
        EC2_HOST = '18.219.234.36' // Public IP or DNS of your EC2 instance
        EC2_PRIVATE_KEY_PATH = '/path/to/your/private-key.pem' // Path to your private key
        TARGET_PORT = '8082' // Desired port for Spring Boot app
    }

    stages {
        stage('Clone Repository') {
            steps {
                git url: "${REPO_URL}", branch: 'main' // Specify your branch
            }
        }

        stage('Build with Maven') {
            steps {
                // Run Maven to build the application
                sh 'mvn clean package'
            }
        }

        stage('Deploy Application to EC2') {
            steps {
                script {
                    // Update the Spring Boot application's application.properties or application.yml
                    // to use port 8082
                    sh "echo 'server.port=${TARGET_PORT}' >> src/main/resources/application.properties"

                    // SSH into EC2 and deploy
                    sh """
                    ssh -o StrictHostKeyChecking=no -i ${EC2_PRIVATE_KEY_PATH} ${EC2_USER}@${EC2_HOST} '
                        # Stop existing application if running
                        pkill -f ${APP_NAME} || true
                        
                        # Copy the built JAR to EC2 (using SCP)
                        scp -i ${EC2_PRIVATE_KEY_PATH} target/${APP_NAME}-0.0.1-SNAPSHOT.jar ${EC2_USER}@${EC2_HOST}:/home/${EC2_USER}/${APP_NAME}.jar

                        # Start the Spring Boot app on port 8082
                        nohup java -jar /home/${EC2_USER}/${APP_NAME}.jar > /home/${EC2_USER}/app.log 2>&1 &
                    '
                    """
                }
            }
        }
    }

    post {
        always {
            echo 'Deployment finished.'
        }
        success {
            echo 'Build and deployment succeeded!'
        }
        failure {
            echo 'Build or deployment failed!'
        }
    }
}
