pipeline {
    agent any

    environment {
        DOCKER_REGISTRY = "docker.io"
        DOCKER_IMAGE_NAME = "shruthick99/springboot"
        DOCKER_TAG = "v1.0.0"
    }

    stages {
        stage('Checkout') {
            steps {
                // Checkout the code from your GitHub repo
                git 'https://github.com/shruthick99/springboot.git'
            }
        }

        stage('List Files') {
            steps {
                // List files in the current directory to check if Dockerfile exists
                sh 'pwd'
                sh 'ls -l'
            }
        }

        stage('Build Spring Boot Application') {
            steps {
                // Build the Spring Boot app using Maven
                // This step will create the target directory and the JAR file
                sh 'mvn clean install -DskipTests'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    // Build Docker image from the Dockerfile
                    // Make sure the path to the Dockerfile is correct
                    sh "docker build -t ${DOCKER_IMAGE_NAME}:${DOCKER_TAG} ."
                }
            }
        }

        stage('Login to Docker Hub') {
            steps {
                script {
                    // Login to Docker Hub using credentials
                    withCredentials([usernamePassword(credentialsId: 'dockerhub-credentials', usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')]) {
                        sh "echo ${DOCKER_PASSWORD} | docker login -u ${DOCKER_USERNAME} --password-stdin"
                    }
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                script {
                    // Push the built Docker image to Docker Hub
                    sh "docker push ${DOCKER_IMAGE_NAME}:${DOCKER_TAG}"
                }
            }
        }

        stage('Cleanup') {
            steps {
                script {
                    // Optionally remove the local Docker image
                    sh "docker rmi ${DOCKER_IMAGE_NAME}:${DOCKER_TAG}"
                }
            }
        }
    }

    post {
        always {
            // Clean up Docker Hub login session
            sh "docker logout"
        }

        success {
            echo 'Pipeline completed successfully!'
        }

        failure {
            echo 'Pipeline failed!'
        }
    }
}
