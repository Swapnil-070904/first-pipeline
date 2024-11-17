pipeline {
    agent any
    environment {
        DOCKER_HUB_REPO = 'ak6805002/my-app'
        IMAGE_TAG = "latest" // Replace with a versioning system like `BUILD_NUMBER` if needed
        DOCKER_CREDENTIALS = 'Docker' // Jenkins credential ID for Docker
    }

    stages {
        stage('Checkout Code') {
            steps {
                git branch: 'main', url: 'https://github.com/Swapnil-070904/first-pipeline.git'
            }
        }

        stage('Build and Push Docker Image') {
            steps {
                withCredentials([usernamePassword(credentialsId: DOCKER_CREDENTIALS, 
                                                 usernameVariable: 'DOCKER_USERNAME', 
                                                 passwordVariable: 'DOCKER_PASSWORD')]) {
                    sh """
                    echo "Logging in to Docker Hub..."
                    docker login -u $DOCKER_USERNAME -p $DOCKER_PASSWORD
                    echo "Building Docker image..."
                    docker build -t ${DOCKER_HUB_REPO}:${IMAGE_TAG} .
                    echo "Pushing Docker image to Docker Hub..."
                    docker push ${DOCKER_HUB_REPO}:${IMAGE_TAG}
                    docker logout
                    """
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                withCredentials([file(credentialsId: 'minikube', variable: 'KUBECONFIG')]) {
                    sh """
                    echo "Creating deployments"
                    kubectl apply -f k8s/deployments.yml
                    echo "Creating service"
                    kubectl apply -f k8s/service.yml
                    echo "Creating ingress"
                    kubectl apply -f k8s/ingress.yml
                    """
                }
        }
    }

    post {
        always {
            cleanWs() // Cleanup the workspace after job completion
        }
    }
}