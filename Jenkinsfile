pipeline {
    agent any

    environment {
        GIT_CREDENTIALS = 'GITHUB_CREDS'
        SSH_CREDENTIALS = 'EC2_SSH'

        // Env file secrets (per service)
        ENV_ADMIN_PORTAL     = 'admin-portal-env-file'
        ENV_API_GATEWAY      = 'api-gateway-env-file'
        ENV_AUTH_SERVICE     = 'auth-service-env-file'
        ENV_CLIENT_SERVICE   = 'client-store-service-env-file'
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

        stage('Prepare Env Files') {
            steps {
                script {
                    // Ensure workspace permissions
                    sh '''
                    sudo chown -R jenkins:jenkins ${WORKSPACE}
                    sudo chmod -R 775 ${WORKSPACE}
                    '''

                    // Services list
                    def services = [
                        ['env': 'admin-portal-env-file', 'path': 'admin-portal'],
                        ['env': 'api-gateway-env-file', 'path': 'api-gateway'],
                        ['env': 'auth-service-env-file', 'path': 'service/auth-service'],
                        ['env': 'client-store-service-env-file', 'path': 'service/client-store-service'],
                        ['env': 'rider-service-env-file', 'path': 'service/rider-service'],
                        ['env': 'vehicle-service-env-file', 'path': 'service/vehicle-service'],
                        ['env': 'spare-parts-service-env-file', 'path': 'service/spare-parts-service']
                    ]

                    // Copy/overwrite env files
                    services.each { s ->
                        sh "mkdir -p ${s.path} && chmod 775 ${s.path}"
                        withCredentials([file(credentialsId: "${s.env}", variable: 'ENV_FILE')]) {
                            sh "cp -f \$ENV_FILE ${s.path}/.env"
                        }
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
                                        admin-portal|api-gateway|services/auth-service|services/client-store-service|services/rider-service|services/vehicle-service|services/spare-parts-service)
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
