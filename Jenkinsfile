
pipeline {
  agent any
  stages {
    stage('Lint') {
      steps {
        sh 'make install'
        sh 'make lint'
      }
    }
    stage('Build Database') {
      steps {
        sh 'make db-build'
      }
    }
    stage('Build App') {
      steps {
        sh 'make app-build'
      }
    }
    stage('Login to dockerhub') {
      steps {
        withCredentials([string(credentialsId: 'dockerhub', variable: 'DOCKERHUBPWD')]) {
          sh 'docker login -u kabalasu -p $DOCKERHUBPWD'
        }
      }
    }
    stage('Upload Image') {
      steps {
        sh 'make upload'
      }
    }
  }
}