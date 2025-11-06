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
            expression {
                def branch = (env.BRANCH_NAME ?: env.GIT_BRANCH)?.replace('origin/', '') ?: 'UNKNOWN'
                echo "Checking branch for Dev: ${branch}"
                return branch == 'dev'
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

                        # Stop & remove old container
                        docker stop dev || true
                        docker rm dev || true

                        # Run Dev on port 8080
                        docker run -d --name dev -p 8080:80 $DOCKER_USER/dev:latest
                    '''
                }
            }
        }
    }

    // --- PROD STAGE (Runs ONLY on the 'main' branch) ---
    stage('Build, Push, and Deploy to Prod') {
        when {
            expression {
                def branch = (env.BRANCH_NAME ?: env.GIT_BRANCH)?.replace('origin/', '') ?: 'UNKNOWN'
                echo "Checking branch for Prod: ${branch}"
                return branch == 'main'
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

                        # Stop & remove old container
                        docker stop prod || true
                        docker rm prod || true

                        # Run Prod on port 80
                        docker run -d --name prod -p 80:80 $DOCKER_USER/prod:latest
                    '''
                }
            }
        }
    }
}

post {
    always {
        script {
            def branch = (env.BRANCH_NAME ?: env.GIT_BRANCH)?.replace('origin/', '') ?: 'UNKNOWN'
            echo "Pipeline finished for branch: ${branch}"
        }
    }
}


}
