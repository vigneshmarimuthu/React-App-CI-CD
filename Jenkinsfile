pipeline {
agent any


environment {
    DOCKER_USER = 'vigneshmarimuthu06'
    CREDENTIAL_ID = 'dockerhub' // Jenkins DockerHub credentials ID
}

stages {

    stage('Checkout') {
        steps {
            checkout scm
        }
    }

    stage('Build and Push Dev Image') {
        when {
            branch 'dev'
        }
        steps {
            script {
                echo "🔧 Branch is dev — Building and pushing Dev image..."
                withCredentials([usernamePassword(credentialsId: CREDENTIAL_ID, usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                    sh '''
                    echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin
                    docker build -t $DOCKER_USER/dev:latest .
                    docker push $DOCKER_USER/dev:latest
                    docker logout
                    '''
                }
            }
        }
    }

    stage('Build, Push, and Deploy Prod Image') {
        when {
            branch 'main'
        }
        steps {
            script {
                echo "🚀 Branch is main — Building and pushing Prod image..."
                withCredentials([usernamePassword(credentialsId: CREDENTIAL_ID, usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                    sh '''
                    echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin
                    docker build -t $DOCKER_USER/prod:latest .
                    docker push $DOCKER_USER/prod:latest
                    docker logout
                    '''
                }
                echo "✅ Deploying Prod container..."
                // Example deployment to Docker container (replace with your actual deployment)
                sh '''
                docker stop prod-container || true
                docker rm prod-container || true
                docker run -d --name prod-container -p 80:80 $DOCKER_USER/prod:latest
                '''
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
