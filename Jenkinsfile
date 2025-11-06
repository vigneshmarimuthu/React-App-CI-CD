pipeline {
agent any


environment {
    DOCKER_USER = 'vigneshmarimuthu06'
    DOCKER_PASS = credentials('dockerhub') // Jenkins credential ID for Docker password
}

stages {
    stage('Checkout') {
        steps {
            checkout([$class: 'GitSCM',
                branches: [[name: 'dev']],
                userRemoteConfigs: [[
                    url: 'https://github.com/vigneshmarimuthu/React-App-CI-CD.git',
                    credentialsId: 'dockerhub'
                ]]
            ])
        }
    }

    stage('Build and Push to Dev') {
        steps {
            script {
                echo '--- Building and Pushing to Dev Repo ---'
                withCredentials([string(credentialsId: 'dockerhub', variable: 'DOCKER_PASS')]) {
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

    stage('Build, Push, and Deploy to Prod') {
        when {
            branch 'main'
        }
        steps {
            script {
                echo '--- Building and Pushing to Prod Repo ---'
                withCredentials([string(credentialsId: 'dockerhub', variable: 'DOCKER_PASS')]) {
                    sh '''
                    echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin
                    docker build -t $DOCKER_USER/prod:latest .
                    docker push $DOCKER_USER/prod:latest
                    docker logout
                    '''
                }
                echo 'Deploy to production steps go here (if needed)'
            }
        }
    }
}

post {
    always {
        echo 'Pipeline finished. Cleaning up...'
    }
}


}
