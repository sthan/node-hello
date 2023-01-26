pipeline {
  environment {
        registry = "shubhashish"
        app_name = "helloworld"
        GIT_TAG = sh(returnStdout: true, script: 'git log -n 1 --pretty=format:"%h"').trim()
        GIT_REPO_URL = "https://github.com/shubhasish/node-hello.git"
        GIT_REPO_BRANCH = "development"
        cache = "false"
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
          - name: kaniko
            image: gcr.io/kaniko-project/executor:debug-v1.2.0
            imagePullPolicy: Always
            command:
            - cat
            tty: true
            volumeMounts:
              - name: docker-config
                mountPath: /kaniko/.docker
            securityContext:
              allowPrivilegeEscalation: true
              runAsUser: 0
          volumes:
          - name: docker-config
            projected:
              sources:
              - secret:
                  name: regcred
                  items:
                    - key: .dockerconfigjson
                      path: config.json
        '''
    }
  }
  stages {
    stage('Docker build') {
      steps {
        container(name: 'kaniko', shell: '/busybox/sh') {
          //  git branch: "${GIT_REPO_BRANCH}", changelog: false, poll: false, url: "GIT_REPO_URL"
              sh """
                    echo ${GIT_TAG} 
                    #!/busybox/sh
                    /kaniko/executor --cleanup --verbosity info  -f Dockerfile -c `pwd` --cache=${cache} --destination=${registry}/${app_name}:${GIT_TAG}
                    echo "Tag=${GIT_TAG}" > build.properties  
                """
        }
      }
    }
  }
  post {
    always {
      archiveArtifacts artifacts: 'build.properties', fingerprint: true
    }  
  }
}