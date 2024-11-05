pipeline {
    agent any

    environment {
        REPO_URL = 'https://github.com/shruthick99/springboot.git' // Replace with your GitHub repo URL
        APP_NAME = 'spring-boot-hello-world'
        APP_JAR = 'target/${demo}-0.0.1-SNAPSHOT.jar' // Update this with your actual JAR naming convention
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

        stage('Deploy Application') {
            steps {
                script {
                    // Stop existing application if running
                    sh "pkill -f ${APP_NAME} || true"

                    // Run the Spring Boot application
                    sh "nohup java -jar ${APP_JAR} > app.log 2>&1 &" // Runs in background
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
