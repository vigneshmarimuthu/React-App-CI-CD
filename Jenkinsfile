pipeline {
    agent any

    environment {
        DOCKER_USER = 'vigneshmarimuthu06'
        // Jenkins credential ID for DockerHub (Username + Password or PAT)
        CREDENTIAL_ID = 'dockerhub'
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build and Push Image') {
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: CREDENTIAL_ID, usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                        
                        // Determine branch
                        def branchName = env.BRANCH_NAME ?: sh(script: "git rev-parse --abbrev-ref HEAD", returnStdout: true).trim()

                        if (branchName == "dev") {
                            echo "🔧 Detected branch: dev — Building and pushing Dev image..."
                            sh '''
                                echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin
                                docker build -t $DOCKER_USER/dev:latest .
                                docker push $DOCKER_USER/dev:latest
                                docker logout
                            '''
                        } else if (branchName == "main" || branchName == "master") {
                            echo "🚀 Detected branch: main/master — Building and pushing Prod image..."
                            sh '''
                                echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin
                                docker build -t $DOCKER_USER/prod:latest .
                                docker push $DOCKER_USER/prod:latest
                                docker logout
                            '''
                        } else {
                            echo "⚠️ Branch '${branchName}' not configured for Docker push. Skipping image push."
                        }
                    }
                }
            }
        }
    }

    post {
        always {
            echo "✅ Pipeline finished for branch: ${env.BRANCH_NAME}"
        }
    }
}
