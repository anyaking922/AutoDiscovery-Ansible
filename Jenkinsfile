pipeline {
  agent any
  tools {
  maven 'maven'
}

  stages {
    stage('Pull Source Code from GitHub') {
      steps {
        git branch: 'main',
          credentialsId: 'GitCred',
          url: 'https://github.com/anyaking922/PAC_W_S'
      }
    }

    stage('Code Analysis') {
      steps {
        withSonarQubeEnv('sonarQube') {
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
          sh 'scp -o StrictHostKeyChecking=no /var/lib/jenkins/workspace/petadoption/target/spring-petclinic-2.4.2.war ec2-user@52.30.52.243:/home/ubuntu/Docker'
        }
      }
    }
    stage('Deploy Application') {
      steps {
        sshagent(['ansible-prv-key']) {
          sh 'ssh -o strictHostKeyChecking=no ec2-user@52.30.52.243 "cd /home/ubuntu/Ansible && ansible-playbook playbook-dockerimage.yaml && ansible-playbook playbook-container.yaml && ansible-playbook playbook-newrelic.yaml"'
        }
      }
    }
  }
}

