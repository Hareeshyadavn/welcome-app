pipeline {
    agent { label 'jenins-agent'}
    environment {
	        APP_NAME = "welcome-app"
            RELEASE = "1.0.0"
            DOCKER_USER = "yadavn1692"
            DOCKER_PASS = 'dockerhub'
            IMAGE_NAME = "${DOCKER_USER}" + "/" + "${APP_NAME}"
            IMAGE_TAG = "${RELEASE}-${BUILD_NUMBER}"
	     JENKINS_API_TOKEN = credentials("JENKINS_API_TOKEN")
    }
    stages{
        stage ("cleanup workspace"){
            steps {
                cleanWs()
            }
        }
        stage ("Checkout from SCM"){
            steps {
                git branch: 'main', credentialsId: 'Hareeshyadavan', url: 'https://github.com/Hareeshyadavn/welcome-app.git'
            }
        }

        stage("Build & Push Docker Image") {
            steps {
                script {
                    docker.withRegistry('',DOCKER_PASS) {
                        docker_image = docker.build "${IMAGE_NAME}"
                    }

                    docker.withRegistry('',DOCKER_PASS) {
                        docker_image.push("${IMAGE_TAG}")
                        docker_image.push('latest')
                    }
                }
            }

       }

       stage ('Cleanup Artifacts') {
           steps {
               script {
                    sh "docker rmi ${IMAGE_NAME}:${IMAGE_TAG}"
                    sh "docker rmi ${IMAGE_NAME}:latest"
               }
          }
       }
	stage("Trigger CD Pipeline") {
            steps {
                script {
                    sh "curl -v -k --user hareesh:${JENKINS_API_TOKEN} -X POST -H 'cache-control: no-cache' -H 'content-type: application/x-www-form-urlencoded' --data 'IMAGE_TAG=${IMAGE_TAG}' 'ec2-43-205-242-219.ap-south-1.compute.amazonaws.com:8080/job/cd-job/buildWithParameters?token=gitops-token'"
                }
            }
       }
    }
}
