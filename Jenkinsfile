pipeline {
    agent {
        docker {
            image 'jenkins-docker-maven:latest'
            args '-v /var/run/docker.sock:/var/run/docker.sock' // 支持 Docker-in-Docker
        }
    }

    environment {
        MAVEN_OPTS = '-Dmaven.repo.local=/var/jenkins_home/.m2/repository'
    }

    options {
        skipDefaultCheckout() // 避免重复 checkout
        buildDiscarder(logRotator(numToKeepStr: '10')) // 保留最近 10 次构建
        timeout(time: 30, unit: 'MINUTES')
    }

    stages {

        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/zhongym1113/devops_pipeline_demo.git'
            }
        }

        stage('Build') {
            steps {
                // 使用 Maven 构建项目，指定参数
                sh 'mvn clean install -DskipTests'
            }
        }

        stage('Test') {
            steps {
                // 可选单元测试阶段
                sh 'mvn test'
            }
        }

        stage('Docker Build & Push') {
            steps {
                script {
                    // 构建 Docker 镜像
                    def imageName = "my-app:${env.BUILD_NUMBER}"
                    sh "sudo docker build -t ${imageName} ."
                    // 推送到私有仓库或 Docker Hub（如已配置登录）
                    // sh "sudo docker push ${imageName}"
                }
            }
        }
    }

    post {
        success {
            echo "Build and Docker process completed successfully!"
        }
        failure {
            echo "Build failed. Please check logs."
        }
    }
}
