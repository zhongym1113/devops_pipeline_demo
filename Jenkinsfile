pipeline {
  agent any

  environment {
    APP_NAME = "devops-demo-app"
    WAR_DIR = "java_web_code"
    DOCKER_IMAGE = "${APP_NAME}:latest"
    DOCKER_CONTEXT = "docker/images"
    HTTP_PORT = 8081
    CONTAINER_PORT = 8080
  }

  stages {
    stage('Checkout') {
      steps {
        git url: 'https://github.com/zhongym1113/devops_pipeline_demo.git', branch: 'master'
      }
    }

    stage('Build & Test') {
      agent {
        docker {
          image 'maven:3.8.5-openjdk-17'
          args '-v $HOME/.m2:/root/.m2'  // 缓存 Maven 依赖
        }
      }
      steps {
        dir("${WAR_DIR}") {
          sh 'mvn clean package'
        }
      }
    }

    stage('Docker Build') {
      steps {
        dir("${DOCKER_CONTEXT}") {
          sh "docker build -t ${DOCKER_IMAGE} ."
        }
      }
    }

    stage('Deploy') {
      steps {
        sh """
          docker rm -f ${APP_NAME} || true
          docker run -d --name ${APP_NAME} -p ${HTTP_PORT}:${CONTAINER_PORT} ${DOCKER_IMAGE}
        """
      }
    }
  }

  post {
    success {
      echo "✅ Build & Deploy succeeded! App running at http://localhost:${HTTP_PORT}"
    }
    failure {
      echo "❌ Pipeline failed. Check the logs."
    }
  }
}
