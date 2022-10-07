pipeline {
  agent any
  tools {
  maven 'maven'
  }
  stages {
    stage('Pull Source Code from GitHub') {
      steps {
        git branch: 'main',
        credentialsId: 'git-credentials: 'a4bbb2f8-40f7-4235-aba3-4a358baa8fea',
         url: 'https://github.com/anyaking922/PAC_W_S.git'
      }
    }
    stage('Code Analysis') {
      steps {
        withSonarQubeEnv('SonarENV') {
          sh "mvn sonar:sonar"
        }
      }
    }
    stage('Build Code') {
      steps {
        sh 'mvn -B -DskipTests clean package'
      }
    }
    stage('Send Artifacts') {
      steps {
        sshagent(['ansible-prv-key']) {
          sh 'scp -o StrictHostKeyChecking=no /var/lib/jenkins/workspace/pac-project/target/spring-petclinic-2.4.2.war ubuntu@3.252.93.176:/home/ubuntu/Docker'
        }
      }
    }
    stage('Deploy Application') {
      steps {
        sshagent(['ansible-prv-key']) {
          sh 'ssh -o strictHostKeyChecking=no ubuntu@3.252.93.176 "cd /home/ubuntu/Ansible && ansible-playbook playbook-dockerimage.yaml && ansible-playbook playbook-container.yaml && ansible-playbook playbook-newrelic.yaml"'
        }
      }
    }
  }
}
