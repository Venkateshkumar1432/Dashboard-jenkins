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
                "admin-portal": "ENV_ADMIN",
                "api-gateway": "ENV_API_GATEWAY",
                "service/auth-service": "ENV_AUTH_SERVICE",
                "service/client-store-service": "ENV_CLIENT_SERVICE",
                "service/rider-service": "ENV_RIDER_SERVICE",
                "service/vehicle-service": "ENV_VEHICLE_SERVICE",
                "service/spare-parts-service": "ENV_SPARE_SERVICE"
            ]


                    // Copy/overwrite env files
                services.each { dir, credId ->
                sh "mkdir -p ${dir} && chmod 775 ${dir}"
                withCredentials([file(variable: 'ENV_FILE', credentialsId: credId)]) {
                    sh "cp -f \$ENV_FILE ${dir}/.env"
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

                            # Run prisma commands in all backend services
                            for service in auth-service client-store-service rider-service vehicle-service spare-parts-service; do
                                cd services/$service
                                npx prisma db push
                                npx prisma db seed
                                npx tsx prisma/seed
                                cd -
                            done
                        "
                    '''
                } else {
                    echo "🔄 Subsequent build → deploy changed services only"
                    sh '''
                        rsync -avz --delete -e "ssh -o StrictHostKeyChecking=no" ./ ubuntu@3.110.103.89:~/Dashboard-jenkins

                        ssh -o StrictHostKeyChecking=no ubuntu@3.110.103.89 "
                            set -e
                            cd ~/Dashboard-jenkins

                            # Find changed directories from last commit
                            CHANGED_DIRS=$(git diff --name-only HEAD~1 HEAD | grep -E '^(admin-portal|api-gateway|services/)' | cut -d/ -f1-2 | sort -u)
                            echo "Changed directories: $CHANGED_DIRS"

                            echo \"$CHANGED_DIRS\" | while read dir; do
                                case \"$dir\" in
                                    admin-portal)
                                        echo \"Building and restarting admin-portal...\"
                                        docker-compose up -d --build admin-portal
                                        ;;
                                    api-gateway)
                                        echo \"Building and restarting api-gateway...\"
                                        docker-compose up -d --build api-gateway
                                        ;;
                                    services/auth-service)
                                        echo \"Building and restarting auth-service...\"
                                        docker-compose up -d --build auth-service
                                        if git diff --name-only HEAD~1 HEAD | grep \"$dir/prisma/schema.prisma\"; then
                                            cd services/auth-service && npx prisma db push && npx prisma db seed && npx tsx prisma/seed
                                            cd -
                                        fi
                                        ;;
                                    services/client-store-service)
                                        echo \"Building and restarting client-store-service...\"
                                        docker-compose up -d --build client-store-service
                                        if git diff --name-only HEAD~1 HEAD | grep \"$dir/prisma/schema.prisma\"; then
                                            cd services/client-store-service && npx prisma db push && npx prisma db seed && npx tsx prisma/seed
                                            cd -
                                        fi
                                        ;;
                                    services/rider-service)
                                        echo \"Building and restarting rider-service...\"
                                        docker-compose up -d --build rider-service
                                        if git diff --name-only HEAD~1 HEAD | grep \"$dir/prisma/schema.prisma\"; then
                                            cd services/rider-service && npx prisma db push && npx prisma db seed && npx tsx prisma/seed
                                            cd -
                                        fi
                                        ;;
                                    services/vehicle-service)
                                        echo \"Building and restarting vehicle-service...\"
                                        docker-compose up -d --build vehicle-service
                                        if git diff --name-only HEAD~1 HEAD | grep \"$dir/prisma/schema.prisma\"; then
                                            cd services/vehicle-service && npx prisma db push && npx prisma db seed && npx tsx prisma/seed
                                            cd -
                                        fi
                                        ;;
                                    services/spare-parts-service)
                                        echo \"Building and restarting spare-parts-service...\"
                                        docker-compose up -d --build spare-parts-service
                                        if git diff --name-only HEAD~1 HEAD | grep \"$dir/prisma/schema.prisma\"; then
                                            cd services/spare-parts-service && npx prisma db push && npx prisma db seed && npx tsx prisma/seed
                                            cd -
                                        fi
                                        ;;
                                    *)
                                        echo \"Skipping $dir\"
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
