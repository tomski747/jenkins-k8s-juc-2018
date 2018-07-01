pipeline {
  agent any
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