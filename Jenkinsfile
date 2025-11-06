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
                // Use 'expression' to check env.GIT_BRANCH and strip 'origin/'
                expression {
                    def currentBranch = env.BRANCH_NAME ?: env.GIT_BRANCH // Prioritize BRANCH_NAME, fallback to GIT_BRANCH
                    
                    if (currentBranch != null) {
                        // Clean the branch name (e.g., changes 'origin/dev' to 'dev')
                        currentBranch = currentBranch.replace('origin/', '')
                    } else {
                        currentBranch = 'UNKNOWN' // Fallback if no variable is set
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
                    def currentBranch = env.BRANCH_NAME ?: env.GIT_BRANCH

                    if (currentBranch != null) {
                        currentBranch = currentBranch.replace('origin/', '')
                    } else {
                        currentBranch = 'UNKNOWN'
                    }
                    
                    echo "Checking branch for Prod deployment: ${currentBranch}"
                    return currentBranch == 'main' // Change to 'master' if that is your production branch
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
                            # Using port 8080 for Prod to avoid conflict with Dev on port 80
                            docker run -d --name prod -p 9090:80 $DOCKER_USER/prod:latest
                        '''
                    }
                }
            }
        }
    }

    post {
        always {
            script {
                // Final echo, ensuring the correct, clean branch name is displayed
                def finalBranch = env.BRANCH_NAME ?: env.GIT_BRANCH ?: 'UNKNOWN'
                finalBranch = finalBranch.replace('origin/', '')
                echo "Pipeline finished for branch: ${finalBranch}"
            }
        }
    }
}
