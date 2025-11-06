pipeline {
agent any


environment {
    DOCKER_USER = 'vigneshmarimuthu06'
    CREDENTIAL_ID = 'dockerhub'  // Jenkins credential ID
}

stages {
    stage('Checkout') {
        steps {
            checkout scm
        }
    }

    stage('Build, Push, and Deploy') {
        steps {
            script {
                withCredentials([usernamePassword(credentialsId: CREDENTIAL_ID, usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                    
                    // Get branch name
                    def branchName = env.BRANCH_NAME ?: sh(script: "git rev-parse --abbrev-ref HEAD", returnStdout: true).trim()
                    echo "Current branch: ${branchName}"

                    if (branchName == "dev") {
                        echo "🔧 Building and pushing Dev image..."
                        sh '''
                            echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin
                            docker build -t $DOCKER_USER/dev:latest .
                            docker push $DOCKER_USER/dev:latest
                            docker logout
                        '''
                        echo "🚀 Deploying Dev container..."
                        sh '''
                            docker stop dev || true
                            docker rm dev || true
                            docker run -d --name dev -p 80:80 $DOCKER_USER/dev:latest
                        '''
                    } else {
                        echo "🚀 Building and pushing Prod image..."
                        sh '''
                            echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin
                            docker build -t $DOCKER_USER/prod:latest .
                            docker push $DOCKER_USER/prod:latest
                            docker logout
                        '''
                        echo "✅ Deploying Prod container..."
                        sh '''
                            docker stop prod || true
                            docker rm prod || true
                            docker run -d --name prod -p 80:80 $DOCKER_USER/prod:latest
                        '''
                    }
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
