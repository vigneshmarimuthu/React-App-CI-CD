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
                // Condition: Execute this stage only if the current branch is 'dev'
                branch 'dev' 
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

        // --- PROD STAGE (Runs ONLY on the 'main' or 'master' branch) ---
        stage('Build, Push, and Deploy to Prod') {
            when {
                // Condition: Execute this stage only if the current branch is 'main'
                // NOTE: Use 'master' if that's your production branch name
                branch 'main' 
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
            echo "Pipeline finished for branch: ${env.BRANCH_NAME}"
        }
    }
}
