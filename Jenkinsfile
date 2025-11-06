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

    stage('Build, Push, and Deploy Prod') {
        steps {
            script {
                withCredentials([usernamePassword(credentialsId: CREDENTIAL_ID, usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
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

post {
    always {
        echo "Pipeline finished for branch: ${env.BRANCH_NAME}"
    }
}


}
