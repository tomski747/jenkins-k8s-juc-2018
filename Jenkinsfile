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
        stage('Docker Build') {
            steps {
                script {
                    dockerImageTag = "tkdemo/${JOB_BASE_NAME}:${BUILD_NUMBER}"
                }
                container('builder') {
                    sh "echo docker build  -t ${dockerImageTag} ."
                }
            }
        }

        stage('Test') {
            steps {
                container('builder') {
                    sh "echo docker run --rm -it ${dockerImageTag} npm test "
                    sh "env"
                }
            }
        }

        stage('Publish'){
            steps{
                container('builder'){
                    sh "docker login -u ${DOCKERHUB_USR} -p ${DOCKERHUB_PSW}"
                }
            }
        }
        stage('Deploy') {
            steps{
                container('deployer'){
                    dir('helm-charts/hello-jenkins')
                    sh "echo helm upgrade --install ${BRANCH_NAME}"
                }
            }
        }
    }
}