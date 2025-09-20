pipeline {
    agent any

     environment {
       
        RENDER_DEPLOY_HOOK = "https://api.render.com/deploy/srv-d37am57fte5s73b43850?key=XK7WYEmqmgA" // ton deploy hook
    }

    options {
        timestamps()
    }



    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build with Maven') {
           steps {

                       sh 'mvn clean package'


               }
        }

        stage('Build & Push Docker Image') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'docker-hub', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                    script {
                        def appName = 'demo' // Nom de l'application
                        def branchName = env.BRANCH_NAME ?: env.GIT_BRANCH ?: 'latest'
                        def safeTag = branchName.replaceAll('[^A-Za-z0-9._-]', '-')
                        def dockerImage = "${DOCKER_USER}/${appName}:${safeTag}"

                        sh """
                            set -e
                            echo "Building Docker image e: ${dockerImage}"
                            docker build -t "${dockerImage}" .

                            echo "Logging into Docker Hub..."
                            echo "${DOCKER_PASS}" | docker login -u "${DOCKER_USER}" --password-stdin

                            echo "Pushing Docker image: ${dockerImage}"
                            docker push "${dockerImage}"
                        """
                    }
                }
            }
        }

         stage('Deploy to Render') {
             steps {
        sh 'curl -X POST "$RENDER_DEPLOY_HOOK"'
    }
        } 
    }

    post {
        always {
            cleanWs()
        }
    }
}