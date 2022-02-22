library identifier: 'neom-jenkins-sharedlib-helm-charts_nix@master', retriever: modernSCM([$class: 'GitSCMSource',
remote: 'https://github.com/NEOM-KSA/neom-jenkins-sharedlib-helm-charts_nix.git',
credentialsId: 'github_token'])

library identifier: 'neom-jenkins-sharedlib-sonarQube_multi@master', retriever: modernSCM([$class: 'GitSCMSource',
remote: 'https://github.com/NEOM-KSA/neom-jenkins-sharedlib-sonarQube_multi.git',
credentialsId: 'github_token'])

library identifier: 'neom-jenkins-sharedlib-dockerbuild@master', retriever: modernSCM([$class: 'GitSCMSource',
   remote: 'https://github.com/NEOM-KSA/neom-jenkins-sharedlib-dockerbuild.git',
   credentialsId: 'github_token'])

library identifier: 'neom-jenkins-sharedlib-changelog@master', retriever: modernSCM([$class: 'GitSCMSource',
   remote: 'https://github.com/NEOM-KSA/neom-jenkins-sharedlib-changelog.git',
   credentialsId: 'github_token'])

library identifier: 'neom-jenkins-sharedlib-owasp-zap-scan-jenkins-sharedlib@master', retriever: modernSCM([$class: 'GitSCMSource',
remote: 'https://github.com/NEOM-KSA/neom-jenkins-sharedlib-owasp-zap-scan-jenkins-sharedlib.git',
credentialsId: 'github_token'])

pipeline {
  agent {
    kubernetes {
      yaml '''
        apiVersion: v1
        kind: Pod
        spec:
          containers:
          - name: ubuntu
            image: swr.ap-southeast-3.myhuaweicloud.com/neom-jenkins-images/ubuntu:latest
            command:
            - cat
            tty: true
          - name: git
            image: swr.ap-southeast-3.myhuaweicloud.com/neom-jenkins-images/git:latest
            command:
            - cat
            tty: true
          - name: build
            image: swr.ap-southeast-3.myhuaweicloud.com/neom-jenkins-images/gradlejdk11:latest
            command:
            - cat
            tty: true 
          - name: helm
            image: swr.ap-southeast-3.myhuaweicloud.com/neom-jenkins-images/helm:latest
            command:
            - cat
            tty: true
          - name: owasp-zap
            image: swr.ap-southeast-3.myhuaweicloud.com/fss-sbx-01-npay-swr-apse3-baseimages/zap:0.1.0
            command:
            - cat
            tty: true
          - name: changelog
            image: swr.ap-southeast-3.myhuaweicloud.com/fss-sbx-01-npay-swr-apse3-baseimages/changlog:0.1.0
            command:
            - cat
            tty: true
          - name: docker
            image: swr.ap-southeast-3.myhuaweicloud.com/neom-jenkins-images/dockerwithtrivy:latest
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
          imagePullSecrets:
          - name: default-secret
        '''
    }
  }
  environment{
    access_key = credentials('accesskey')
    login_key = credentials('loginkey')

    def environmentName = 'sandbox'

    def projectName = 'neom-fss-neompay-otp-api'
    def releaseName = 'neom-fss-neompay-otp-api'
    def namespace = "neompay"
  }
  stages {
    stage('Checkout Code') {
      steps {
       script{
        container('git') {
          checkout scm
	  (version,flag) = semverVersion()
	 }
        }
      }
    }
    stage('Sonar Qube') {
      steps {
        container('build') {
            withSonarQubeEnv('sonar-server') {
          sh '''
            ./gradlew clean jacocoTestReport sonarqube
          '''
          }
        }
      }
    }
    /*stage('Quality Gate') {
      steps {
        container('ubuntu') {
            qualityGates()
        }
      }
    }*/
    stage('Code Build') {
      steps {
        container('build') {
          sh "./gradlew build"
        }
      }
    }
    stage('Docker Image Build') {
//      when{
// 	branch 'master'
//       }
      steps {
        script{
               container('docker') {
               dockerBuild("swr.ap-southeast-3.myhuaweicloud.com", "neom-backend-starter", "neom-fss-neompay-otp-api", "${version}")
               }
            }
        }
    }
//     stage('Docker Image scan') {
//      when{
// 		branch 'master'
//       }
//       steps {
//         script{
//                container('docker') {
//                trivyScan("swr.ap-southeast-3.myhuaweicloud.com", "neom-backend-starter", "neom-fss-neompay-otp-api", "${version}")
//                }
//             }
//         }
//     }
    stage('Docker Image Push') {
     when{
	branch 'master'
      }
      steps {
        script{
               container('docker') {
               dockerPush("swr.ap-southeast-3.myhuaweicloud.com", "neom-backend-starter", "neom-fss-neompay-otp-api", "${version}")
               }
            }
        }
    }
    stage('Starting Zap Proxy') {
	 when{
	   branch 'master'
         }                    
                    steps {
                        echo "*********************** Starting ZAP proxy ***********************************"
                        script {
                            container("owasp-zap")  {
                                runOwaspZapProxy()
                            }
                        }
                    }
                }
   stage('Deploy') {
    when{
	branch 'master'
      }
      steps {
        container('helm') {
          withKubeCredentials(kubectlCredentials: [[caCertificate: '', clusterName: 'sbx-domain', contextName: 'sbx-domain', credentialsId: 'sandbox', namespace: '', serverUrl: '']]) {
		        dir("helm"){
	  	          upgradeReleaseV3(
	  	          chartName: "${projectName}",
	  	          releaseName: "${releaseName}",
	  	          namespace: "${namespace}",
	  	          options: "--set image.tag=${version}"
	  	          )
        	  }

	       }
     	     }
    	  }
  	}
 /* stage('Zap Proxy') {
           when{
	     branch 'master'
     	   }      
                    steps {
                        echo "*********************** ZAP proxy scanning ***********************************"
                        script {
                            container("owasp-zap")  {
                                runActivescan()
                              generateHtmlReport()
                             
                            }
                        }
                    }
                }*/
	stage('Changelog') {
         when {
           expression { flag == true }
           branch 'master'
         }
         steps {
          script{
           container('changelog') {
             changeLog("${version}","$BRANCH_NAME")
          }
        }
      }
    }
	  
    }
}

