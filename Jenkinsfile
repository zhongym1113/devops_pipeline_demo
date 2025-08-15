pipeline {
    agent any

    tools {
        maven 'M3'  // 先去 Jenkins 全局工具配置 Maven
    }

    stages {
        stage('Checkout') {
            steps {
                git 'https://github.com/prasanjit-/devops_pipeline_demo.git'
            }
        }

        stage('Build WAR') {
            steps {
                dir('java_web_code') {
                    sh 'mvn clean package'
                }
            }
        }

        stage('Docker Build') {
            steps {
                dir('docker/images') {
                    sh 'docker build -t devops-demo-app .'
                }
            }
        }

        stage('Deploy Container') {
            steps {
                sh '''
                docker rm -f devops-demo-app || true
                docker run -d --name devops-demo-app -p 8081:8080 devops-demo-app
                '''
            }
        }
    }
}
