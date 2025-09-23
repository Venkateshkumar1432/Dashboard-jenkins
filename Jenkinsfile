pipeline {
  agent any

  environment {
    GIT_CREDENTIALS = 'GITHUB_CREDS'        // Jenkins Git credential ID
    EC2_KEY = 'EC2_SSH'                // Jenkins SSH private key credential
    EC2_HOST = 'ubuntu@3.110.103.89'        // Replace with your EC2 host
    EC2_PATH = '/home/ubuntu/microservices'
  }

  stages {
    stage('Checkout') {
      steps {
        git(credentialsId: "${GIT_CREDENTIALS}", url: 'https://github.com/Venkateshkumar1432/Dashboard-jenkins.git', branch: 'main')
      }
    }

    stage('Inject .env files') {
      steps {
        // 🔑 Ensure Jenkins has ownership + write permission on all files in workspace
        sh '''
            sudo chown -R jenkins:jenkins ${WORKSPACE}
            sudo chmod -R 775 ${WORKSPACE}
        '''
        // Example for one service; repeat for each service with its credential id
        withCredentials([file(credentialsId: 'auth-service-env-file', variable: 'AUTH_ENV')]) {
          sh 'cp $AUTH_ENV services/auth-service/.env'
        }
        withCredentials([file(credentialsId: 'api-gateway-env-file', variable: 'GATEWAY_ENV')]) {
          sh 'cp $GATEWAY_ENV api-gateway/.env'
        }
        withCredentials([file(credentialsId: 'admin-portal-env-file', variable: 'ADMIN_ENV')]) {
          sh 'cp $ADMIN_ENV admin-portal/.env'
        }
        withCredentials([file(credentialsId: 'client-store-service-env-file', variable: 'CLIENT_ENV')]) {
          sh 'cp $CLIENT_ENV services/client-store-service/.env'
        }
        withCredentials([file(credentialsId: 'rider-service-env-file', variable: 'RIDER_ENV')]) {
          sh 'cp $RIDER_ENV services/rider-service/.env'
        }
        withCredentials([file(credentialsId: 'vehicle-service-env-file', variable: 'VEHICLE_ENV')]) {
          sh 'cp $VEHICLE_ENV services/vehicle-service/.env'
        }
        withCredentials([file(credentialsId: 'spare-parts-service-env-file', variable: 'SPARE_ENV')]) {
          sh 'cp $SPARE_ENV services/spare-parts-service/.env'
        }
      }
    }

    stage('Send to EC2') {
      steps {
        sshagent(credentials: [EC2_KEY]) {
          sh """
            tar czf app.tar.gz .
            scp -o StrictHostKeyChecking=no app.tar.gz ${EC2_HOST}:/tmp/
            ssh -o StrictHostKeyChecking=no ${EC2_HOST} '
              mkdir -p ${EC2_PATH} &&
              tar xzf /tmp/app.tar.gz -C ${EC2_PATH} &&
              rm /tmp/app.tar.gz
            '
          """
        }
      }
    }

    stage('Deploy on EC2') {
      steps {
        sshagent(credentials: [EC2_KEY]) {
          sh """ 
            ssh -o StrictHostKeyChecking=no ${EC2_HOST} '
                cd ${EC2_PATH} &&
                chmod +x deploy.sh &&
                bash deploy.sh
            '
        """
        }
      }
    }
  }
}
