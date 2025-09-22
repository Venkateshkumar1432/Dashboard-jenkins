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
