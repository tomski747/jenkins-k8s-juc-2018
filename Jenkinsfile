pipeline {
  agent {
    kubernetes {
      label 'mypod'
      containerTemplate {
        name 'maven'
        image 'maven:3.3.9-jdk-8-alpine'
        ttyEnabled true
        command 'cat'
      }
    }
  }
  stages {
    stage('MyStage') {
      steps {
        sh 'uptime'
      }
    }
  }
  environment {
    foo = 'bar'
  }
}