
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
        withCredentials([[$class: 'UsernamePasswordMultiBinding', credentialsId: 'dockerhub',
                    usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD']]) {
          sh 'docker login -u $USERNAME -p $PASSWORD'
        }
      }
    }
    stage('Upload Image') {
      steps {
        sh 'make upload'
      }
    }
    stage('Start kubernetes cluster using ansible playbook') {
      steps {
        sh 'ansible-playbook -i ~/kubernetes_ansible/inventory ~/kubernetes_ansible/main.yaml'
      }
    }
  }
}