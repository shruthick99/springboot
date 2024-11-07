pipeline {
    agent any

    environment {
        HEROKU_API_KEY = credentials('heroku-api-key')  // Use Jenkins secret for Heroku API key
        HEROKU_APP_NAME = 'springboot-demo-app'         // Replace with your Heroku app name
    }

    stages {
        stage('Checkout') {
            steps {
                git 'https://github.com/shruthick99/springboot.git'
            }
        }

        stage('Build') {
            steps {
                sh './mvnw clean install'
            }
        }

        stage('Deploy to Heroku') {
            steps {
                script {
                    // Login to Heroku CLI using the API key
                    sh 'echo $HEROKU_API_KEY | heroku auth:token'

                    // Deploy the app to Heroku
                    sh 'git remote add heroku https://git.heroku.com/$HEROKU_APP_NAME.git'
                    sh 'git push heroku main'
                }
            }
        }
    }
}
