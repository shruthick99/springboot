pipeline {
    agent any

    environment {
        EC2_IP = "18.220.197.208"  // Your EC2 instance public IP address
        PROJECT_DIR = "/home/ec2-user"  // Directory on EC2 instance where the JAR will be deployed
        JAR_NAME = "demo-0.0.1-SNAPSHOT.jar"  // Update with the actual JAR name if needed
        GIT_BRANCH = "master"  // Using the master branch
    }

    stages {
        stage('Clone GitHub Repository') {
            steps {
                script {
                    // Clone the GitHub repository from the specified branch (master)
                    git branch: "${GIT_BRANCH}", url: 'https://github.com/shruthick99/springboot.git'
                }
            }
        }

        stage('Build with Maven') {
            steps {
                script {
                    // Build the project using Maven
                    sh './mvnw clean install -DskipTests'
                }
            }
        }

        stage('Deploy to EC2') {
            steps {
                script {
                    // Use the Jenkins credentials to securely retrieve the private key and set the SSH_KEY_PATH variable
                    withCredentials([sshUserPrivateKey(credentialsId: 'ba61a69e-415e-4257-a8d5-a4d639e9841c', keyFileVariable: 'SSH_KEY_PATH', usernameVariable: 'EC2_USER')]) {

                        // Use SCP to copy the JAR file from Jenkins to EC2
                        sh """
                        scp -i ${SSH_KEY_PATH} target/${JAR_NAME} ${EC2_USER}@${EC2_IP}:${PROJECT_DIR}
                        """

                        // SSH into the EC2 instance and run the JAR
                        sh """
                        ssh -i ${SSH_KEY_PATH} ${EC2_USER}@${EC2_IP} 'nohup java -jar ${PROJECT_DIR}/${JAR_NAME} > /dev/null 2>&1 &'
                        """
                    }
                }
            }
        }
    }

    post {
        success {
            echo 'Deployment to EC2 was successful!'
        }
        failure {
            echo 'Deployment failed.'
        }
    }
}
