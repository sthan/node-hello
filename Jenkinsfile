pipeline {
  environment {
        registry = "cronsprod.azurecr.io"
        GIT_TAG = sh(returnStdout: true, script: 'git log -n 1 --pretty=format:"%h"').trim()
        GIT_REPO_URL = "https://github.com/shubhasish/node-hello.git"
        GIT_REPO_BRANCH = "development"
    }
    
  agent {
    kubernetes {
      yaml '''
        apiVersion: v1
        kind: Pod
        metadata:
            name: docker
        spec:
          containers:
          - name: docker
            image: docker:latest
            command:
            - cat
            tty: true
            volumeMounts:
             - mountPath: /var/run/docker.sock
               name: docker-sock
          volumes:
          - name: docker-sock
            hostPath:
              path: /var/run/docker.sock  
        '''
    }
  }
  stages {
    stage('Docker build') {
      steps {
        container('docker') {
          //  git branch: "${GIT_REPO_BRANCH}", changelog: false, poll: false, url: "GIT_REPO_URL"
          sh "docker build -t hello-world:${GIT_TAG} ."
        }
      }
    }  
  }
}