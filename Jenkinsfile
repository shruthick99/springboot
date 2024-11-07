pipeline {
    agent any

    environment {
        HEROKU_API_KEY = credentials('heroku-api-key')  // Fetch Heroku API key from Jenkins credentials store
        HEROKU_APP_NAME = 'your-heroku-app-name'         // Replace with your Heroku app name
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

        stage('Install Heroku CLI') {
            steps {
                script {
                    // Install Heroku CLI if it's not already installed
                    sh 'curl https://cli-assets.heroku.com/install.sh | sh'
                }
            }
        }

        stage('Deploy to Heroku') {
            steps {
                script {
                    // Authenticate with Heroku using the API key
                    sh 'echo $HEROKU_API_KEY | heroku auth:token'

                    // Add Heroku remote and push code to Heroku
                    sh 'git remote add heroku https://git.heroku.com/$HEROKU_APP_NAME.git'
                    sh 'git push heroku main'
                }
            }
        }
    }
}
