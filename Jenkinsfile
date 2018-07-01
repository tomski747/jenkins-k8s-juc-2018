pipeline {
    agent {
        kubernetes {
            label env.BUILD_TAG
            defaultContainer 'jnlp'
            yaml """
apiVersion: v1
kind: Pod
spec:
  volumes:
    - name: docker-sock
      hostPath:
        path: /var/run/docker.sock
  containers:
    - name: builder
      image: docker
      command:
        - cat
      tty: true
      volumeMounts:
        - name: docker-sock
          mountPath: /var/run/docker.sock
    - name: deployer
      image: lachlanevenson/k8s-helm:v2.8.2
      command:
        - cat
      tty: true            
"""
        }
    }

    environment {
        DOCKERHUB = credentials('dockerhub')
    }

    stages {

        stage('Checkout') {
            steps {
                echo "Setting docker image name variables"
                script {
                    jobBaseName = JOB_NAME.split('/').first()
                    dockerImageRepository = "tkdemo/${jobBaseName}"
                    dockerImageTag = "${BRANCH_NAME}-${BUILD_NUMBER}"
                    dockerImageFullName = "${dockerImageRepository}:${dockerImageTag}"
                    helmReleaseName = "${jobBaseName}-${BRANCH_NAME}"
                }
            }
        }

        stage('Docker Build') {
            steps {

                container('builder') {
                    sh "docker build  -t ${dockerImageFullName} ."
                }
            }
        }

        stage('Test') {
            steps {
                container('builder') {
                    sh "docker run --rm ${dockerImageFullName} npm test "
                }
            }
        }

        stage('Publish') {
            steps {
                container('builder') {
                    sh "docker login -u ${DOCKERHUB_USR} -p ${DOCKERHUB_PSW}"
                    sh "docker push ${dockerImageFullName}"
                }
            }
        }

        stage('Deploy') {
            steps {
                container('deployer') {
                    dir('helm-charts') {
                        sh """
                            helm upgrade ${helmReleaseName} ./juc2018-demo-app\
                                --install \
                                --set nameOverride=${helmReleaseName}
                                --set image.repository=${dockerImageRepository},\
                                --set image.tag=${dockerImageTag}
                           """
                    }
                }
            }
        }
    }
}