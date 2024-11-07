pipeline {
    agent any

    environment {
        HEROKU_API_KEY = credentials('heroku-api-key')  // Fetch Heroku API key from Jenkins credentials store
        HEROKU_APP_NAME = 'springboot-demo-app'         // Replace with your Heroku app name
        HEROKU_PATH = '/opt/homebrew/bin'                 // Path where Heroku CLI is installed
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
                    // Add Heroku CLI path to the system PATH
                    sh '''
                    export PATH=$PATH:$HEROKU_PATH
                    echo "Using Heroku CLI at: $(which heroku)"
                    heroku auth:token
                    git remote add heroku https://git.heroku.com/$HEROKU_APP_NAME.git
                    git push heroku main
                    '''
                }
            }
        }
    }
}
