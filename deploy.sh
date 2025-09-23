#!/bin/bash
set -e
cd /home/ubuntu/microservices

# First time: build all services
if [ ! -f ".first_deploy_done" ]; then
  echo "Running first-time setup..."
  docker-compose up -d --build

  # run prisma only on backend services
  for svc in services/*; do
    if [ -d "$svc/prisma" ]; then
      sname=$(basename $svc)
      docker-compose run --rm $sname npx prisma db push
      docker-compose run --rm $sname npx prisma db seed || true
      docker-compose run --rm $sname npx tsx prisma/seed || true
    fi
  done

  touch .first_deploy_done
else
  echo "Updating existing deployment..."
  git fetch origin main
  changed=$(git diff --name-only HEAD..origin/main || true)
  git reset --hard origin/main

  if echo "$changed" | grep -q "prisma"; then
    echo "Prisma schema changed -> running migrations"
    for svc in services/*; do
      if [ -d "$svc/prisma" ]; then
        sname=$(basename $svc)
        docker-compose run --rm $sname npx prisma db push
        docker-compose run --rm $sname npx prisma db seed || true
        docker-compose run --rm $sname npx tsx prisma/seed || true
      fi
    done
  fi

  if echo "$changed" | grep -q "services/"; then
    svc=$(echo "$changed" | grep "services/" | head -1 | cut -d'/' -f2)
    echo "Restarting $svc"
    docker-compose build $svc
    docker-compose up -d $svc
  else
    echo "No service-specific changes, rebuilding all"
    docker-compose up -d --build
  fi
fi
