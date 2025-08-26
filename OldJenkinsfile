pipeline {
    agent any

    tools{
        maven 'Maven'
    }
    stages {

        stage('App code Checkout') {
            steps {
                git branch: 'master', url: 'https://github.com/zhongym1113/devops_pipeline_demo.git'
                // 打印目录确认 Dockerfile 是否存在
                sh 'pwd && ls -la'
            }
        }

        stage('MVN compile Build') {
            steps {
                echo "..... Build Phase Started :: Compiling Source Code :: ......"
                dir('java_web_code') {
                    sh 'mvn install'
                }
            }
        }

        stage('Intergration Test') {
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

        // stage('Check Docker') {
        //    steps {
        //        echo "..... Checking Docker Environment :: ......"
        //        sh '''
        //            set -x
        //            which docker
        //            docker version
        //            docker ps
        //        '''
        //    }
        // }

        stage('Provisioning - Build Docker Image') {
            steps {
                script {
                    // 获取 git commit 短 hash
                    def shortCommit = sh(script: "git rev-parse --short HEAD", returnStdout: true).trim()
                    // Jenkins 内置的构建号
                    def buildVersion = "${env.BUILD_NUMBER}"
                    // 镜像版本号规则：build号+commit
                    env.IMAGE_TAG = "${buildVersion}-${shortCommit}"
                    env.IMAGE_NAME = "devops_pipeline_demo"

                    echo "..... Provisioning Phase Started :: Building Docker Container :: ......"
                    echo "Building Image Tag: ${IMAGE_NAME}:${IMAGE_TAG}"

                    // 清理临时目录
                    sh 'rm -rf /home/docker_build || true'
                    // 拷贝 docker 文件夹到 /home
                    sh 'cp -r docker /home/docker_build'

                    dir('/home/docker_build') {
                        sh """
                            set -x
                            echo "Building Docker image from /home/docker_build..."
                            /usr/local/bin/docker build --progress=plain -t ${IMAGE_NAME}:${IMAGE_TAG} . > docker_build.log 2>&1
                            /usr/local/bin/docker tag ${IMAGE_NAME}:${IMAGE_TAG} ${IMAGE_NAME}:latest
                            cat docker_build.log
                        """
                    }

                    // 构建完成后可选择清理临时目录
                    // sh 'rm -rf /home/docker_build'
                }
            }
        }

        stage('Deployment - Run Docker Container') {
            steps {
                script {
                    def container = "devops_pipeline_demo"
                    sh "sudo /usr/local/bin/docker rm -f ${container} || true"
                    echo "..... Deployment Phase Started :: Running Docker Container :: ......"
                    sh "sudo /usr/local/bin/docker run -d -p 8088:8080 --name ${container} ${container}:latest"
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
