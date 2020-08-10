
pipeline {
  agent any
  stages {
    stage('Lint') {
      steps {
        sh 'make setup'
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
        withCredentials([string(credentialsId: 'dockerhub', variable: 'dockerhubpwd')]) {
          sh 'docker login -u kabalasu -p ${dockerhubpwd}'
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