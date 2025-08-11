pipeline {

	agent any
	
	environment {
		GPU_IP = credentials('gpuIP')
		GPU_USER = credentials('gpuUser')
		GPU_PASSWD = credentials('gpuPasswd')
		
		APP_PATH = '/home/fcr-dev/face-recognition'
		APP_SERVICE = 'fcr-dev.service'

        PORT = '9010'
	}
	
	options {
		buildDiscarder(logRotator(artifactNumToKeepStr: '15', numToKeepStr: '15'))
		skipDefaultCheckout(true)  // Skip the default checkout
	}

    parameters {
        booleanParam(name: 'sonarTest', defaultValue: false, description: 'SonarQube test for code')
        booleanParam(name: 'deployGPU', defaultValue: true, description: 'Auto changes for ocr')
    }

	stages {

        stage("Clean Workspace") {
            steps {
                deleteDir()  // Clean the workspace
            }
        }

		stage('SonarQube Analysis') {
			when {
				expression {
					params.sonarTest
				}
			}
			steps {
    	    	withSonarQubeEnv(credentialsId: 'Sonarqube', installationName: 'SonarQube') {
      				sh "./mvnw clean verify sonar:sonar -Dmaven.test.skip=true -Dsonar.projectKey=$SONAR_PROJECT_KEY"
    			}
			}
		}

		stage('Git pull in GPU') {
			when {
				expression {
					params.deployGPU
				}
			}
            steps {
                sh '''
                    sshpass -p "$GPU_PASSWD" ssh "$GPU_USER@$GPU_IP" bash -c "'./auto-deployment.sh $APP_PATH $APP_SERVICE'"
                '''
			}
		}

		stage('GPU test') {
            steps {
                sh 'sleep 5'
                sh 'cd /var/lib/jenkins/gpu_test/ && ./fcr_test.sh $PORT'
                sh 'sleep 5'
                sh 'cd /var/lib/jenkins/gpu_test/ && ./fcr_test.sh $PORT'
			}
		}
	}

    post {
        always {
    		cleanWs();
		}
    }
}
