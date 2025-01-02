pipeline{
    agent{
        label "thalt"
    }

    tools{
        jdk 'Java17'
        maven 'Maven3'
    }
    environment{
        APP_NAME = "learn-jenkins-app"
        RELEASE = "1.0.0"
        DOCKER_USER = "thanhtha"
        DOCKER_PASS = "dockerhub"
        IMAGE_NAME  = "${DOCKER_USER}" + "/" + "${APP_NAME}"
        IMAGE_TAG   = "${RELEASE}" + "-" + "${BUILD_NUMBER}"
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
        stage("env Maven") {
            steps {
                withEnv(['PATH+MAVEN=/home/jenkins/tools/hudson.tasks.Maven_MavenInstallation/Maven3/bin']) {
                }
            }   
        }
        stage("Build application"){
            steps{
                sh 'mvn clean install -DskipTests=true'
            }
        }
        stage("Test File exists"){
            steps{
                sh '''
                    FILE=/home/jenkins/.m2/repository/org/example/org.example.codegen/0.0.1-SNAPSHOT/org.example.codegen-0.0.1-SNAPSHOT.jar
                    if [ -f "$FILE" ]; then
                        echo "$FILE exists."
                    else 
                        echo "$FILE does not exist."
                    fi
                '''
            }
        }
        stage("Sonarqube Analisis"){
            steps{
                script {
                    withSonarQubeEnv(credentialsId: 'jenkins-sonarqube-token') {
                        sh 'mvn sonar:sonar'
                    }
                }
            }
        }
        stage("Quality Gate"){
            steps{
                script {
                    waitForQualityGate abortPipeline: false, credentialsId: 'jenkins-sonarqube-token'
                }
            }
        }
        stage("Build & Push Docker Image"){
            steps{
                script {
                    docker.withRegistry('',DOCKER_PASS){
                        docker_image = docker.build "${IMAGE_NAME}"
                    }
                    docker.withRegistry('',DOCKER_PASS){
                        docker_image.push("$IMAGE_TAG")
                        docker_image.push('latest')
                    }
                }
            }
        }
    }
}