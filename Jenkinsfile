pipeline {
    agent any

    environment {
        DOCKER_USER = 'vigneshmarimuthu06'
        CREDENTIAL_ID = 'dockerhub' // DockerHub credential ID in Jenkins
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
                        echo "🚀 Building and pushing image to DockerHub (prod)..."

                        sh '''
                            echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin
                            docker build -t $DOCKER_USER/prod:latest .
                            docker push $DOCKER_USER/prod:latest
                            docker logout
                        '''
                    }
                }
            }
        }

        stage('Deploy Container') {
            steps {
                script {
                    echo "📦 Deploying container from DockerHub image..."
                    sh '''
                        docker rm -f myapp || true
                        docker pull $DOCKER_USER/prod:latest
                        docker run -d -p 80:80 --name myapp $DOCKER_USER/prod:latest
                    '''
                }
            }
        }
    }

    post {
        always {
            echo "✅ Pipeline completed successfully. Image deployed: ${DOCKER_USER}/prod:latest"
        }
    }
}
