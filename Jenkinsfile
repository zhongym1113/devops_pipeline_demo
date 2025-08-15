pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "devops_pipeline_demo"
        DOCKER_TAG   = "${env.BUILD_NUMBER}"
        CONTAINER_PORT = "8088"
        HOST_PORT      = "8088"
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'master', url: 'https://github.com/zhongym1113/devops_pipeline_demo.git'
            }
        }

        stage('Maven Build') {
            steps {
                dir('java_web_code'){
                sh 'mvn clean package -DskipTests'
                }
            }
        }

        stage('Docker Build') {
            steps {
                sh """
                docker build -t $DOCKER_IMAGE:$DOCKER_TAG .
                """
            }
        }

        stage('Run Container for Test') {
            steps {
                sh """
                docker rm -f $DOCKER_IMAGE || true
                docker run -d --name $DOCKER_IMAGE -p $HOST_PORT:$CONTAINER_PORT $DOCKER_IMAGE:$DOCKER_TAG
                """
            }
        }
    }

    post {
        success {
            echo "✅ 构建成功，已在本地运行容器：$DOCKER_IMAGE:$DOCKER_TAG"
            echo "访问地址：http://localhost:$HOST_PORT"
        }
        failure {
            echo "❌ 构建失败，请检查日志"
        }
    }
}
