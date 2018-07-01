pipeline {
  agent {
    kubernetes {
      label 'mypod'
      containerTemplate {
        name 'docker'
        image 'docker'
        ttyEnabled true
        command 'cat'
      }
    }
  }
  stages {
    stage('MyStage') {
      steps {
        sh 'ls -la'
      }
    }
  }
  environment {
    foo = 'bar'
  }
}