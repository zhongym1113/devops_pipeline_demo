  pipeline {
    agent any

    stages {

        stage('Checkout') {
            steps {
                git branch: 'master', url: 'https://github.com/zhongym1113/devops_pipeline_demo.git'
            }
        }

        stage('Build') {
            steps {
                echo "..... Build Phase Started :: Compiling Source Code :: ......"
                dir('java_web_code') {
                    sh 'mvn install'
                }
            }
        }

        stage('Test') {
            steps {
                echo "..... Test Phase Started :: Testing via Automated Scripts :: ......"
                dir('integration-testing') {
                    sh 'mvn clean verify -P integration-test'
                }
            }
        }

        stage('Provisioning - Copy Artifacts') {
            steps {
                echo "..... Integration Phase Started :: Copying Artifacts :: ......"
                dir('java_web_code') {
                    sh 'cp target/wildfly-spring-boot-sample-1.0.0.war ../docker/'
                }
            }
        }

        stage('Provisioning - Build Docker Image') {
            steps {
                echo "..... Provisioning Phase Started :: Building Docker Container :: ......"
                dir('docker') {
                    sh 'docker build -t devops_pipeline_demo .'
                }
            }
        }

        stage('Deployment - Run Docker Container') {
            steps {
                script {
                    def container = "devops_pipeline_demo"
                    def isRunning = sh(
                        script: "docker inspect --format='{{ .State.Running }}' ${container} 2>/dev/null || true",
                        returnStdout: true
                    ).trim()

                    if (isRunning) {
                        echo "Stopping and removing existing container: ${container}"
                        sh "docker rm -f ${container} || true"
                    }

                    echo "..... Deployment Phase Started :: Running Docker Container :: ......"
                    sh "docker run -d -p 8180:8080 --name ${container} ${container}"
                }
            }
        }
    }

    post {
        always {
            echo "--------------------------------------------------------"
            echo "View App deployed here: http://server-ip:8180/sample.txt"
            echo "--------------------------------------------------------"
        }
    }
}
