pipeline{
    agent{
        label "thalt"
    }

    tools{
        jdk 'Java17'
        maven 'Maven3'
    }
    stages{
        stage("Cleanup Workspace"){
            steps{
                cleanWs()
            }
        }
        stage("Checkout from SCM"){
            steps{
                git branch: 'main', credentialsId: 'github' , url: 'https://github.com/tnubeo1111/learn-jenkins-app'
            }
        }
        stage("variables"){
            steps{
                sh "alias maven='/home/jenkins/tools/hudson.tasks.Maven_MavenInstallation/Maven3/bin/mvn'"
            }
        }
        stage("Build application"){
            steps{
                sh 'maven clean install -DskipTests=true'
            }
        }
    }
}