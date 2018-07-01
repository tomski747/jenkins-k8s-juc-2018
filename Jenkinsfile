pipeline {
  agent {
    kubernetes {
      label env.BUILD_TAG
      containerTemplate {
        name 'docker'
        image 'docker'
        ttyEnabled true
        command 'cat'
      }
    }
  }
  environment {
    foo = 'bar'
  }
  stages {
    stage('Docker Build') {
      steps {
        sh 'docker ps'
      }
    }
  }
}