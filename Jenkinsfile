pipeline {
    agent any
    tools {
        maven "M3"
    }
    stages {
        stage('Build') {
            steps {
                git 'https://github.com/tapishrawat/sample-may-1.git'
                sh "mvn clean install"
            }
            post {
                success {
                    archiveArtifacts 'target/*.war'
                }
            }
        }
	stage('Deploy') {
            steps {
                sh "cp target/my-webapp.war ~/tomcat/webapps/tapish.war"
            }
         }
    }
}
