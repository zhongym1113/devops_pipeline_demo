pipeline {
    agent any

    stages {

        stage('Checkout') {
            steps {
                git branch: 'master', url: 'https://github.com/zhongym1113/devops_pipeline_demo.git'
                // 打印目录确认 Dockerfile 是否存在
                sh 'pwd && ls -la'
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

        stage('Check Docker') {
            steps {
                echo "..... Checking Docker Environment :: ......"
                sh '''
                    set -x
                    which docker
                    docker version
                    docker ps
                '''
            }
        }

        stage('Provisioning - Build Docker Image') {
            steps {
                echo "..... Provisioning Phase Started :: Building Docker Container :: ......"
                script {
                    // 清理临时目录
                    sh 'rm -rf /tmp/docker_build || true'
                    // 拷贝 docker 文件夹到 /tmp
                    sh 'cp -r docker /tmp/docker_build'

                    dir('/tmp/docker_build') {
                        sh '''
                            set -x
                            echo "Building Docker image from /tmp/docker_build..."
                            docker build --progress=plain -t devops_pipeline_demo . > docker_build.log 2>&1 || true
                            cat docker_build.log
                        '''
                    }

                    // 构建完成后可选择清理临时目录
                    sh 'rm -rf /tmp/docker_build'
                }
            }
        }

        stage('Deployment - Run Docker Container') {
            steps {
                script {
                    def container = "devops_pipeline_demo"
                    def isRunning = sh(
                        script: "sudo docker inspect --format='{{ .State.Running }}' ${container} 2>/dev/null || true",
                        returnStdout: true
                    ).trim()

                    if (isRunning) {
                        echo "Stopping and removing existing container: ${container}"
                        sh "sudo docker rm -f ${container} || true"
                    }

                    echo "..... Deployment Phase Started :: Running Docker Container :: ......"
                    sh "sudo docker run -d -p 8088:8080 --name ${container} ${container}"
                }
            }
        }
    }

    post {
        always {
            echo "--------------------------------------------------------"
            echo "View App deployed here: http://server-ip:8088/sample.txt"
            echo "--------------------------------------------------------"
        }
    }
}
