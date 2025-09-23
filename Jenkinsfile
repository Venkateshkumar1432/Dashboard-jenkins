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
                TMP_DIR=tmp_deploy
                mkdir -p \$TMP_DIR

                # Copy project files
                cp -r admin-portal api-gateway services docker-compose.yml deploy.sh \$TMP_DIR/

                # Copy .env files
                cp services/auth-service/.env \$TMP_DIR/services/auth-service/.env
                cp services/client-store-service/.env \$TMP_DIR/services/client-store-service/.env
                cp services/rider-service/.env \$TMP_DIR/services/rider-service/.env
                cp services/vehicle-service/.env \$TMP_DIR/services/vehicle-service/.env
                cp services/spare-parts-service/.env \$TMP_DIR/services/spare-parts-service/.env
                cp api-gateway/.env \$TMP_DIR/api-gateway/.env
                cp admin-portal/.env \$TMP_DIR/admin-portal/.env

                # Copy nginx.conf explicitly
                cp nginx.conf \$TMP_DIR/nginx.conf

                # Create tar.gz package
                tar czf ../app.tar.gz -C \$TMP_DIR .

                # Clean temporary folder
                rm -rf \$TMP_DIR

                # Send tar.gz to EC2
                scp -o StrictHostKeyChecking=no ../app.tar.gz ${EC2_HOST}:/tmp/

                # Extract on EC2
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
