pipeline {
    agent any

    stages {
        stage('Clone Repo') {
            steps {
                echo "📥 Cloning repository..."
                git branch: 'main', url: 'https://github.com/Venkateshkumar1432/Dashboard-jenkins.git'
            }
        }

        stage('Setup .env files') {
            steps {
                echo "⚙️ Setting up .env files from Jenkins secret files..."
                withCredentials([
                    file(credentialsId: 'auth-service-env-file', variable: 'AUTH_FILE'),
                    file(credentialsId: 'client-store-service-env-file', variable: 'CLIENT_FILE'),
                    file(credentialsId: 'spare-parts-service-env-file', variable: 'SPARE_FILE'),
                    file(credentialsId: 'vehicle-service-env-file', variable: 'VEHICLE_FILE'),
                    file(credentialsId: 'rider-service-env-file', variable: 'RIDER_FILE'),
                    file(credentialsId: 'api-gateway-env-file', variable: 'API_FILE'),
                    file(credentialsId: 'admin-portal-env-file', variable: 'ADMIN_FILE')
                ]) {
                    sh '''
                    cp $AUTH_FILE services/auth-service/.env
                    cp $CLIENT_FILE services/client-store-service/.env
                    cp $SPARE_FILE services/spare-parts-service/.env
                    cp $VEHICLE_FILE services/vehicle-service/.env
                    cp $RIDER_FILE services/rider-service/.env
                    cp $API_FILE api-gateway/.env
                    cp $ADMIN_FILE admin-portal/.env
                    '''
                }
            }
        }

        stage('Detect Changes') {
    steps {
        script {
            def changedServices = []

            // Check if first build
            def firstBuild = sh(script: "git rev-parse HEAD~1 || echo 'first'", returnStdout: true).trim()
            if (firstBuild == "first") {
                echo "📌 First build detected, will rebuild all services."
                changedServices = ["auth-service","client-store-service","spare-parts-service","vehicle-service","rider-service","api-gateway","admin-portal"]
            } else {
                def changedFiles = sh(script: "git diff --name-only HEAD~1 HEAD", returnStdout: true).trim()
                echo "📝 Changed files:\n${changedFiles}"

                if (changedFiles.contains("services/auth-service/")) changedServices << "auth-service"
                if (changedFiles.contains("services/client-store-service/")) changedServices << "client-store-service"
                if (changedFiles.contains("services/spare-parts-service/")) changedServices << "spare-parts-service"
                if (changedFiles.contains("services/vehicle-service/")) changedServices << "vehicle-service"
                if (changedFiles.contains("services/rider-service/")) changedServices << "rider-service"
                if (changedFiles.contains("api-gateway/")) changedServices << "api-gateway"
                if (changedFiles.contains("admin-portal/")) changedServices << "admin-portal"
            }

            env.CHANGED_SERVICES = changedServices.join(" ")
            echo "➡️ Services to rebuild: ${env.CHANGED_SERVICES}"
        }
    }
}


        stage('Build & Deploy Changed Services') {
            when {
                expression { return env.CHANGED_SERVICES?.trim() }
            }
            steps {
                sh '''
                for service in $CHANGED_SERVICES
                do
                  echo "🚀 Rebuilding and restarting $service..."
                  docker-compose build $service
                  docker-compose up -d $service

                  if echo "$CHANGED" | grep -q "$service/prisma/"; then
                    echo "🔄 Prisma schema changed in $service, running migrations and seed..."
                    docker-compose run --rm $service npx prisma db push
                    docker-compose run --rm $service npx prisma db seed
                    docker-compose run --rm $service npx tsx prisma/seed
                  fi
                done
                '''
            }
        }

        stage('Skip If No Relevant Changes') {
            when {
                expression { return !env.CHANGED_SERVICES?.trim() }
            }
            steps {
                echo "✅ No service changes detected, skipping build."
            }
        }
    }
}
