pipeline {
    agent any

    environment {
        DOCKER_USER = 'vigneshmarimuthu06'
        CREDENTIAL_ID = 'dockerhub'
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        // --- DEV STAGE (Runs ONLY on the 'dev' branch) ---
        stage('Build, Push, and Deploy to Dev') {
            when {
                // Use 'expression' with the more reliable 'git symbolic-ref --short HEAD' command
                expression {
                    def currentBranch = env.BRANCH_NAME
                    if (currentBranch == null) {
                        // Use git symbolic-ref to correctly resolve the branch name from HEAD
                        currentBranch = sh(script: "git symbolic-ref --short HEAD || echo 'UNKNOWN'", returnStdout: true).trim()
                    }
                    echo "Checking branch for Dev deployment: ${currentBranch}"
                    return currentBranch == 'dev'
                }
            }
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: env.CREDENTIAL_ID, usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                        echo "🔧 Building, pushing, and deploying Dev image..."
                        sh '''
                            echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin
                            docker build -t $DOCKER_USER/dev:latest .
                            docker push $DOCKER_USER/dev:latest
                            docker logout
                            
                            # Deployment steps for Dev
                            docker stop dev || true
                            docker rm dev || true
                            docker run -d --name dev -p 80:80 $DOCKER_USER/dev:latest
                        '''
                    }
                }
            }
        }

        // --- PROD STAGE (Runs ONLY on the 'main' branch) ---
        stage('Build, Push, and Deploy to Prod') {
            when {
                // Apply the same robust branch checking logic for 'main'
                expression {
                    def currentBranch = env.BRANCH_NAME
                    if (currentBranch == null) {
                        currentBranch = sh(script: "git symbolic-ref --short HEAD || echo 'UNKNOWN'", returnStdout: true).trim()
                    }
                    echo "Checking branch for Prod deployment: ${currentBranch}"
                    return currentBranch == 'main'
                }
            }
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: env.CREDENTIAL_ID, usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                        echo "✅ Building, pushing, and deploying Prod image..."
                        sh '''
                            echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin
                            docker build -t $DOCKER_USER/prod:latest .
                            docker push $DOCKER_USER/prod:latest
                            docker logout
                            
                            # Deployment steps for Prod
                            docker stop prod || true
                            docker rm prod || true
                            docker run -d --name prod -p 8080:80 $DOCKER_USER/prod:latest
                        '''
                    }
                }
            }
        }
    }

    post {
        always {
            // Also update the post-stage echo for clarity
            echo "Pipeline finished for branch: ${env.BRANCH_NAME ?: sh(script: 'git symbolic-ref --short HEAD || echo UNKNOWN', returnStdout: true).trim()}"
        }
    }
}
