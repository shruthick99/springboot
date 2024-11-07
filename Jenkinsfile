pipeline {
    agent any

    environment {
        HEROKU_API_KEY = credentials('heroku-api-key')  // Ensure you have a Heroku API key in Jenkins credentials
    }

    stages {
        stage('Checkout') {
            steps {
                git 'https://github.com/shruthick99/springboot.git'
            }
        }

        stage('Build') {
            steps {
                script {
                    // Run Maven build (clean install)
                    sh './mvnw clean install'
                }
            }
        }

        stage('Deploy to Heroku') {
            steps {
                script {
                    // Ensure the Heroku CLI is in the PATH
                    sh '''
                    export PATH=/usr/bin:/bin:/usr/sbin:/sbin:/opt/homebrew/bin:$PATH
                    echo "Using Heroku CLI at: $(which heroku)"

                    # Remove the existing Heroku remote if it exists
                    git remote remove heroku || true

                    # Add the Heroku remote again
                    git remote add heroku https://git.heroku.com/springboot-demo-app.git

                    # Deploy to Heroku
                    git push heroku main
                    '''
                }
            }
        }
    }
    
    post {
        success {
            echo "Deployment to Heroku was successful!"
        }
        failure {
            echo "Deployment to Heroku failed."
        }
    }
}
