pipeline {
    agent any

    environment {
        IMAGE_NAME = 'my-node-app'
        IMAGE_TAG = 'latest'
    }

    stages {
        stage('Checkout Code') {
            steps {
                checkout scm
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    dockerImage = docker.build("${IMAGE_NAME}:${IMAGE_TAG}")
                }
            }
        }

        stage('Run Container') {
            steps {
                script {
                    // Stop and remove any running container with the same name
                    sh "docker rm -f ${IMAGE_NAME}-container || true"

                    // Run the container in detached mode
                    sh "docker run -d --name ${IMAGE_NAME}-container -p 3000:3000 ${IMAGE_NAME}:${IMAGE_TAG}"
                }
            }
        }

        stage('Archive Artifacts') {
            steps {
                // Adjust the path to what you want to archive (e.g., build output, logs)
                archiveArtifacts artifacts: '**/dist/**', allowEmptyArchive: true
            }
        }
    }

    post {
        cleanup {
            // Optional: Clean up Docker artifacts after the job
            sh "docker rmi ${IMAGE_NAME}:${IMAGE_TAG} || true"
        }

        always {
            echo "Pipeline finished"
        }
    }
}
