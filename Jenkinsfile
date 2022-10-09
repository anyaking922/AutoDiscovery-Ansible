pipeline {
  agent any
  tools {
  maven 'maven'
  }
  stages {
    stage('Pull Source Code from GitHub') {
      steps {
        git branch: 'main', credentialsId: 'Gitcred', 
        url: 'https://github.com/anyaking922/PAC_W_S.git'
      }
    }
    stage('Code Analysis') {
      steps {
        withSonarQubeEnv('sonarQube') {
          sh "mvn sonar:sonar"
        }
      }

    stage('Build Code') {
      steps {
         sh 'mvn package -Dmaven.test.skip' 
      }

    stage('Send Artifacts') {
      steps {
        sshagent(['jenkinskey']) {
          sh 'scp -o StrictHostKeyChecking=no /var/lib/jenkins/petadoptopn/target/spring-petclinic-2.4.2.war ec2-user@3.252.143.29:/opt/docker'
        }
      }
    }
    }
    }
  }
}
