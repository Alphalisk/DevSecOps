#!/bin/bash

# === Drone installatie op dezelfde VM als Gitea ===
DRONE_HOST="http://10.24.13.163"  
GITEA_SERVER="http://10.24.13.163"  
GITEA_CLIENT_ID="__GITEA_CLIENT_ID__"
GITEA_CLIENT_SECRET="__GITEA_CLIENT_SECRET__"

# 1. Maak Docker network aan voor Drone
docker network create drone || true

# 2. Start Drone server
docker run -d \
  --volume=/var/lib/drone:/data \
  --env=DRONE_GITEA_SERVER=${GITEA_SERVER} \
  --env=DRONE_GITEA_CLIENT_ID=${GITEA_CLIENT_ID} \
  --env=DRONE_GITEA_CLIENT_SECRET=${GITEA_CLIENT_SECRET} \
  --env=DRONE_RPC_SECRET=supersecretrpc \
  --env=DRONE_SERVER_HOST=${DRONE_HOST#http://} \
  --env=DRONE_SERVER_PROTO=http \
  --env=DRONE_USER_CREATE=username:Dockeradmin,admin:true \
  --publish=8080:80 \
  --restart=always \
  --name=drone \
  --network=drone \
  drone/drone:2

# 3. Drone Runner (nodig om builds uit te voeren)
docker run -d \
  --volume=/var/run/docker.sock:/var/run/docker.sock \
  --env=DRONE_RPC_PROTO=http \
  --env=DRONE_RPC_HOST=${DRONE_HOST#http://} \
  --env=DRONE_RPC_SECRET=supersecretrpc \
  --env=DRONE_RUNNER_CAPACITY=2 \
  --env=DRONE_RUNNER_NAME=drone-runner \
  --publish=3000:3000 \
  --restart=always \
  --name=drone-runner \
  --network=drone \
  drone/drone-runner-docker:1

echo "✅ Drone CI is gestart op: ${DRONE_HOST}:8080"
echo "👉 Log in met je Gitea-account (Dockeradmin)"
echo "ℹ️ Vergeet niet om je Gitea OAuth App aan te maken met:"
echo "   Redirect URI: ${DRONE_HOST}:8080/login"
