pipeline {
    agent any

    environment {
        DOCKER_USER = 'vigneshmarimuthu06'
        CREDENTIAL_ID = 'dockerhub'
        // Define a variable to hold the actual branch name, defaulting to env.BRANCH_NAME or a Git lookup
        // This is done in the stages below to ensure it runs *after* checkout
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
                // Use 'expression' to perform a robust check that handles a null BRANCH_NAME
                expression {
                    def currentBranch = env.BRANCH_NAME
                    if (currentBranch == null) {
                        currentBranch = sh(script: "git rev-parse --abbrev-ref HEAD", returnStdout: true).trim()
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
                // Use 'expression' for a robust check against 'main'
                expression {
                    def currentBranch = env.BRANCH_NAME
                    if (currentBranch == null) {
                        currentBranch = sh(script: "git rev-parse --abbrev-ref HEAD", returnStdout: true).trim()
                    }
                    echo "Checking branch for Prod deployment: ${currentBranch}"
                    // You might use 'main' or 'master' depending on your Git setup
                    return currentBranch == 'main' 
                }
            }
            steps {
                // The steps would go here for building and deploying the Prod image
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
                            docker run -d --name prod -p 8080:80 $DOCKER_USER/prod:latest
                        '''
                    }
                }
            }
        }
    }

    post {
        always {
            echo "Pipeline finished for branch: ${env.BRANCH_NAME ?: sh(script: 'git rev-parse --abbrev-ref HEAD', returnStdout: true).trim()}"
        }
    }
}
