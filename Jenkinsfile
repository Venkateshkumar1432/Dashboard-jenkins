pipeline {
    agent any

    environment {
        GIT_CREDENTIALS = 'GITHUB_CREDS'
        SSH_CREDENTIALS = 'EC2_SSH'

        // Env file secrets (per service)
        ENV_ADMIN_PORTAL     = 'admin-portal-env-file'
        ENV_API_GATEWAY      = 'api-gateway-env-file'
        ENV_AUTH_SERVICE     = 'auth-service-env-file'
        ENV_CLIENT_SERVICE   = 'client-service-env-file'
        ENV_RIDER_SERVICE    = 'rider-service-env-file'
        ENV_VEHICLE_SERVICE  = 'vehicle-service-env-file'
        ENV_SPARE_SERVICE    = 'spare-parts-service-env-file'
    }

    stages {
        stage('Clone Repo') {
            steps {
                git branch: 'main',
                    credentialsId: "${GIT_CREDENTIALS}",
                    url: 'https://github.com/Venkateshkumar1432/Dashboard-jenkins.git'
            }
        }

        stage('Copy Env Files') {
            steps {
                script {
                    withCredentials([file(credentialsId: "${ENV_ADMIN_PORTAL}", variable: 'ADMIN_ENV')]) {
                        sh 'cp $ADMIN_ENV admin-portal/.env'
                    }
                    withCredentials([file(credentialsId: "${ENV_API_GATEWAY}", variable: 'GATEWAY_ENV')]) {
                        sh 'cp $GATEWAY_ENV api-gateway/.env'
                    }
                    withCredentials([file(credentialsId: "${ENV_AUTH_SERVICE}", variable: 'AUTH_ENV')]) {
                        sh 'cp $AUTH_ENV service/auth-service/.env'
                    }
                    withCredentials([file(credentialsId: "${ENV_CLIENT_SERVICE}", variable: 'CLIENT_ENV')]) {
                        sh 'cp $CLIENT_ENV service/client-store-service/.env'
                    }
                    withCredentials([file(credentialsId: "${ENV_RIDER_SERVICE}", variable: 'RIDER_ENV')]) {
                        sh 'cp $RIDER_ENV service/rider-service/.env'
                    }
                    withCredentials([file(credentialsId: "${ENV_VEHICLE_SERVICE}", variable: 'VEHICLE_ENV')]) {
                        sh 'cp $VEHICLE_ENV service/vehicle-service/.env'
                    }
                    withCredentials([file(credentialsId: "${ENV_SPARE_SERVICE}", variable: 'SPARE_ENV')]) {
                        sh 'cp $SPARE_ENV service/spare-parts-service/.env'
                    }
                }
            }
        }

        stage('Deploy to EC2') {
            steps {
                sshagent([SSH_CREDENTIALS]) {
                    script {
                        def firstBuild = currentBuild.getPreviousBuild() == null

                        if (firstBuild) {
                            echo "🚀 First build → build all services + prisma setup"
                            sh '''
                            rsync -avz --delete -e "ssh -o StrictHostKeyChecking=no" ./ ubuntu@3.110.103.89:~/Dashboard-jenkins

                            ssh -o StrictHostKeyChecking=no ubuntu@3.110.103.89 "
                                set -e
                                cd ~/Dashboard-jenkins
                                docker-compose down || true
                                docker-compose up -d --build

                                # Run prisma commands in backend services
                                cd ../auth-service && npx prisma db push && npx prisma db seed && npx tsx prisma/seed
                                cd ../client-store-service && npx prisma db push && npx prisma db seed && npx tsx prisma/seed
                                cd ../rider-service && npx prisma db push && npx prisma db seed && npx tsx prisma/seed
                                cd ../vehicle-service && npx prisma db push && npx prisma db seed && npx tsx prisma/seed
                                cd ../spare-parts-service && npx prisma db push && npx prisma db seed && npx tsx prisma/seed
                            "
                            '''
                        } else {
                            echo "🔄 Subsequent build → deploy changed services only"
                            sh '''
                            rsync -avz --delete -e "ssh -o StrictHostKeyChecking=no" ./ ubuntu@3.110.103.89:~/Dashboard-jenkins

                            ssh -o StrictHostKeyChecking=no ubuntu@3.110.103.89 "
                                set -e
                                cd ~/Dashboard-jenkins

                                # Find changed dirs from last commit
                                CHANGED_DIRS=$(git diff --name-only HEAD~1 HEAD | cut -d/ -f1-2 | sort -u)
                                echo Changed directories: $CHANGED_DIRS

                                for dir in $CHANGED_DIRS; do
                                    case $dir in
                                        admin-portal|api-gateway|service/auth-service|service/client-store-service|service/rider-service|service/vehicle-service|service/spare-parts-service)
                                            echo Building and restarting $dir ...
                                            docker-compose up -d --build $dir

                                            # If schema.prisma changed, run prisma commands
                                            if git diff --name-only HEAD~1 HEAD | grep "$dir/prisma/schema.prisma"; then
                                                echo "Schema changed in $dir → running prisma db push/seed"
                                                cd $dir && npx prisma db push && npx prisma db seed && npx tsx prisma/seed
                                                cd -
                                            fi
                                            ;;
                                    esac
                                done
                            "
                            '''
                        }
                    }
                }
            }
        }
    }
}
