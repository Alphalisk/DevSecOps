# Begeleidende Verantwoording – Cloud Computing - Docker

## Inleiding

In dit verslag verantwoord ik mijn werkzaamheden binnen het vak **DevSecOps**, onderdeel van de **HBO-ICT** module **Operations Engineering**.  

## Opdrachten van het project

De basis onderdelen van je Bouwstraat:
1. Een self-hosted installatie van Gitea. Dit mag zowel in op de Proxmox omgeving van het vak Cloud,
in de public Cloud of self-hosted op een home lab. Documenteer deze instalatie zover dat je dit kun
automatiseren met b.v. ansible.
2. Een fasering in je pipeline waar in ieder geval een opdeling in een Build en een Deploy stap. Bepaal
zelf hoe deze fasering gebeurt, leg je keuzes hierin uit, heb je b.v. meerdere fases of één fase
opgedeeld in meerdere stappen(en natuurlijk waarom je deze keuzes hebt gemaakt). Kies hierin zelf
op je een standalone CI applicatie neemt(Hierin adviseer ik Drone CI) of Gitea actions.
3. Een gehoste en door jouw pipeline automatisch gedeployde webapplicatie naar keuze. kies een
applicatie die gebuild moet worden. Dit kan b.v. een NodeJs applicatie zijn. Kijk b.v. op de github
awesome selfhosted list voor inspiratie als je zelf niks weet.

Aanvullende onderdelen of concepten geïntegreerd in je bouwstraat.
- Geautomatiseerd opbouwen van een SBOM (Software bill of materials)
- Monitoring van de infrastructuur (dus de machine waar Gitea op runt, de build server en de
productieserver).
- Monitoring van de webapplicatie (dit is tooling die de status van de gehoste applicatie kan
monitoren, denk aan uptime en responsetijden van server requests).
- Alerting
- Caching
- Immutable infrastructure
- ChatOps
- Automated fuzzing
- Security testing
- Vulnerability scans
- Static Application Security Testing (SAST)
- Dynamic Application Security Testing (DAST)
- Interactive Application Security Testing (IAST)
- Run-time Application Security Protection (RASP)
- Load testing
- Infrastructure orchestration
- Automated/manual roll-back
- Configuration validation
- Containerisatie
- Eigen inbreng (in overleg met docent)


### Basisopdracht 1 - Maak een VM voor je Gitea server (Self-hosted Git)

Voor deze opdracht wordt gebruik gemaakt van het ProxMox cluster van het vak *Cloud Computing*.  

De netwerkconfiguratie is als volgt:

**Netwerkconfiguratie:**
|nodenaam|IP intern    |Type node    |IP Tailscale  |
|--------|-------------|-------------|--------------|
|pve00   |10.24.13.100 |control node |100.94.185.45 |
|pve01   |10.24.13.101 |managed node |100.104.126.78|
|pve02   |10.24.13.102 |managed node |100.84.145.8  |




Met het script is het gelukt om:
- automatisch een VM te maken + verbinden met tailgate
- Ubuntu, Docker/Docker Compose en gitae te installeren. 

Hierbij het resultaat in de browser:
![alt text](Screenshots\gitae-online.png)

Gitea succesvol geinstalleerd:

![alt text](Screenshots\Opdracht2\installgitae.png)

---

### Basisopdracht 2

1) instellen van gitea (Op de VM 166)

```bash
Dockeradmin@vm-gitea:~/gitea/demo-app$ git init
hint: Using 'master' as the name for the initial branch. This default branch name
hint: is subject to change. To configure the initial branch name to use in all
hint: of your new repositories, which will suppress this warning, call:
hint: 
hint:   git config --global init.defaultBranch <name>
hint: 
hint: Names commonly chosen instead of 'master' are 'main', 'trunk' and
hint: 'development'. The just-created branch can be renamed via this command:
hint: 
hint:   git branch -m <name>
Initialized empty Git repository in /home/Dockeradmin/gitea/demo-app/.git/
Dockeradmin@vm-gitea:~/gitea/demo-app$ git checkout -b main
Switched to a new branch 'main'
Dockeradmin@vm-gitea:~/gitea/demo-app$ git add .
Dockeradmin@vm-gitea:~/gitea/demo-app$ git commit -m "🎉 Eerste commit"
On branch main

Initial commit

nothing to commit (create/copy files and use "git add" to track)
Dockeradmin@vm-gitea:~/gitea/demo-app$ touch initial.txt
Dockeradmin@vm-gitea:~/gitea/demo-app$ git add *
Dockeradmin@vm-gitea:~/gitea/demo-app$ git commit -m "🎉 Eerste commit"
[main (root-commit) a8a24f9] 🎉 Eerste commit
 1 file changed, 0 insertions(+), 0 deletions(-)
 create mode 100644 initial.txt
Dockeradmin@vm-gitea:~/gitea/demo-app$ git remote add origin http://100.85.133.118:3000/Dockeradmin/demo-app.git
Dockeradmin@vm-gitea:~/gitea/demo-app$ git push -u origin main
Username for 'http://100.85.133.118:3000': Richard
Password for 'http://Richard@100.85.133.118:3000': 
remote: Verify
fatal: Authentication failed for 'http://100.85.133.118:3000/Dockeradmin/demo-app.git/'
Dockeradmin@vm-gitea:~/gitea/demo-app$ git push -u origin main
Username for 'http://100.85.133.118:3000': Dockeradmin
Password for 'http://Dockeradmin@100.85.133.118:3000':
Enumerating objects: 3, done.
Counting objects: 100% (3/3), done.
Writing objects: 100% (3/3), 225 bytes | 112.00 KiB/s, done.
Total 3 (delta 0), reused 0 (delta 0), pack-reused 0
remote: . Processing 1 references
remote: Processed 1 references in total
To http://100.85.133.118:3000/Dockeradmin/demo-app.git
 * [new branch]      main -> main
Branch 'main' set up to track remote branch 'main' from 'origin'.
Dockeradmin@vm-gitea:~/gitea/demo-app$
```

installeren van de Hello world `demo-app`.

```bash
Dockeradmin@vm-gitea:~/gitea/demo-app$ ls -l
total 4
-rw-rw-r-- 1 Dockeradmin Dockeradmin    0 Apr  5 13:58 initial.txt
-rw-rw-r-- 1 Dockeradmin Dockeradmin 1185 Apr  5 14:06 setup-demo-app.sh
Dockeradmin@vm-gitea:~/gitea/demo-app$ chmod +x setup-demo-app.sh 
Dockeradmin@vm-gitea:~/gitea/demo-app$ ./setup-demo-app.sh 
📁 Maak package.json
📝 Maak server.js
🐳 Maak Dockerfile
🤖 Voeg .drone.yml toe
✅ Demo app en Drone pipeline zijn klaar!
Dockeradmin@vm-gitea:~/gitea/demo-app$ 
```

2) Installeren van drone op een andere VM (165)

![alt text](Screenshots\Opdracht2\droneinstall.png)

De Drone is gekoppeld met gitea.

![alt text](Screenshots\Opdracht2\Drone_gekoppeld_demo.png)

De stappen werken tot de build fase:

![alt text](Screenshots\Opdracht2\werkt_tot_build.png)

De build fase werkt nu ook:

![alt text](Screenshots\Opdracht2\werkt_tot_build.png)

Alle fasen werken:

![alt text](Screenshots\Opdracht2\bouwstraatgereed.png)

3) De derde VM maken bedoeld als productie omgeving. (VM167)

![alt text](Screenshots\Opdracht2\ProxMoxVM's.png)

Op pve02 zijn er 3 VM's met Ubuntu en docker-compose geinstalleerd.

- Gitea
intern:      `http://10.24.13.166`
tailscale:   `http://100.85.133.118:3000/`

- Drone
intern:      `http://10.24.13.165`
tailscale:   `http://100.80.163.27:8080/`

- Productie
intern:      `http://10.24.13.167`
tailscale:   `http://100.122.151.29:8080`

---

### ✅ Basisopdracht 3 – Werkende Pipeline

De gehele DevSecOps pipeline is succesvol opgezet voor de **Hello World demo-app**. De werking hiervan is vastgelegd in de video `Basisbouwstraat_werkend.mp4`.

Onderstaand de gebruikte `.drone.yml` configuratie in de demo-app:

```yaml
kind: pipeline
type: docker
name: default

steps:
  - name: install & build
    image: node:18
    commands:
      - npm install

  - name: upload
    image: appleboy/drone-scp
    settings:
      host: 10.24.13.167
      username: Dockeradmin
      port: 22
      source: "./"
      target: "/home/Dockeradmin/deploy"
      key:
        from_secret: ssh_key

  - name: deploy
    image: appleboy/drone-ssh
    settings:
      host: 10.24.13.167
      username: Dockeradmin
      port: 22
      key:
        from_secret: ssh_key
      script:
        - cd /home/Dockeradmin/deploy
        - echo "🛑 Stop oude container"
        - docker stop demo-container || true
        - docker rm demo-container || true
        - echo "🐳 Build nieuwe container"
        - docker build -t demo-app .
        - echo "🚀 Start nieuwe container"
        - docker run -d --name demo-container -p 8080:8080 demo-app
```

Onderstaand de gebruikte `docker-compose.yml` configuratie in Gitea:
```yml
version: '3'

services:
  gitea:
    image: gitea/gitea:latest
    container_name: gitea
    environment:
      - USER_UID=1000
      - USER_GID=1000
      - GITEA__server__ROOT_URL=http://100.85.133.118:3000/
      - GITEA__server__SSH_DOMAIN=100.85.133.118
      - GITEA__server__DOMAIN=100.85.133.118
    volumes:
      - ./gitea:/data
    ports:
      - "3000:3000"
      - "2222:22"
    restart: always
```

Onderstaand de gebruikte `docker-compose.yml` configuratie in drone:

```yml
version: '3'

services:
  drone-server:
    image: drone/drone:2
    container_name: drone
    ports:
      - 8080:80
    volumes:
      - drone-data:/data
    restart: always
    environment:
      DRONE_GITEA_SERVER: http://100.85.133.118:3000
      DRONE_GITEA_CLIENT_ID: 63aba40a-ada0-459a-9247-19b0e86fe9ce
      DRONE_GITEA_CLIENT_SECRET: gto_3uuq3sbkhw7xtx4sahtovsiugdmzgd767lsxqiwamglddovjvkzq
      DRONE_RPC_SECRET: supersekret123
      DRONE_SERVER_HOST: 100.80.163.27:8080
      DRONE_SERVER_PROTO: http
      DRONE_USER_CREATE: username=Dockeradmin,admin=true
      DRONE_LOGS_DEBUG: true
      DRONE_LOGS_TRACE: true

  drone-runner:
    image: drone/drone-runner-docker:1
    container_name: drone-runner
    depends_on:
      - drone-server
    restart: always
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
    environment:
      DRONE_RPC_PROTO: http
      DRONE_RPC_HOST: drone-server
      DRONE_RPC_SECRET: supersekret123
      DRONE_RUNNER_CAPACITY: 2
      DRONE_RUNNER_NAME: runner-01

volumes:
  drone-data:

```

#### 📦 Uitleg van de pipeline:

De bouwstraat bestaat uit **3 stappen**:

1. **Installatie en build**  
   - De benodigde dependencies worden geïnstalleerd met `npm install`.

2. **Upload naar productieomgeving**  
   - De inhoud van de applicatiemap wordt via **SCP** overgezet naar de map `/home/Dockeradmin/deploy` op de productie-VM (`10.24.13.167`).

3. **Deployment via SSH**  
   - Via een remote script worden de volgende acties uitgevoerd op de productie-VM:
     - Stoppen en verwijderen van de bestaande container (`demo-container`)
     - Bouwen van een nieuwe Docker image op basis van de geuploade code
     - Starten van een nieuwe container die de applicatie draait op poort `8080`


---

### Extra functionaliteiten:

---
#### **Containerisatie met docker compose**

Dit is al uitgevoerd op de basis installatie!

---
#### **Monitoring van de infrastructuur**

De volgende script is gebruikt om de VM's te kunnen monitoren:

```bash
# # purge old netdata
# ssh Dockeradmin@10.24.13.165 << 'EOF'
# sudo systemctl stop netdata || true
# sudo pkill netdata || true
# sudo apt purge --yes netdata netdata-core netdata-web netdata-plugins-* || true
# sudo rm -rf /etc/netdata /var/lib/netdata /var/cache/netdata /opt/netdata /usr/lib/netdata /usr/sbin/netdata
# sudo rm -f /etc/systemd/system/netdata.service
# EOF

# clean install Netdata
ssh Dockeradmin@10.24.13.165 << 'EOF'
echo 'nameserver 1.1.1.1' | sudo tee /etc/resolv.conf
bash <(curl -SsL https://my-netdata.io/kickstart.sh) --dont-wait
EOF

# Firewall
ssh Dockeradmin@10.24.13.165 << 'EOF'
echo 'nameserver 1.1.1.1' | sudo tee /etc/resolv.conf
sudo ufw allow 19999/tcp comment 'Allow Netdata'
sudo systemctl restart netdata
EOF

# Externe toegang instellen
ssh Dockeradmin@10.24.13.165 << 'EOF'
sudo mkdir -p /etc/netdata
sudo sed -i 's/^  bind to = localhost/  bind to = 0.0.0.0/' /etc/netdata/netdata.conf
sudo systemctl restart netdata
EOF
```

![alt text](Screenshots\Extra_opdrachten\MonitoringVM-prod.png)

Elke VM (productie, drone en gitea) heeft netdata monitoring gekregen.
De monitoring is vastgelegd in de video `Monitoring_Infrastructuur.mp4`.

---

#### Monitoring van de webapplicatie

Om de beschikbaarheid en prestaties van mijn gehoste demo-applicatie te monitoren, heb ik [Uptime Kuma](https://github.com/louislam/uptime-kuma) ingezet.  
Uptime Kuma is een gebruiksvriendelijke monitoringtool die uptime, responstijden en storingen inzichtelijk maakt via een eigen webinterface.

Uptime Kuma is geïnstalleerd op mijn monitoring-VM met behulp van Docker:

```bash
mkdir -p ~/uptime-kuma
cd ~/uptime-kuma
```

```yml
version: '3'

services:
  uptime-kuma:
    image: louislam/uptime-kuma:latest
    container_name: uptime-kuma
    ports:
      - "3001:3001"   # Je kunt dit aanpassen als je 3001 al gebruikt
    volumes:
      - ./data:/app/data
    restart: always
```

```bash
sudo ufw allow 8080/tcp comment 'Allow demo-app access'
docker compose up -d
```

De webinterface is bereikbaar op: `http://100.122.151.29:3001`

### 🖥️ Monitoringconfiguratie

Er is een HTTP-monitor toegevoegd voor de demo-applicatie op de productie-VM:

- **Naam:** Demo App
- **URL:** http://10.24.13.167:8080
- **Interval:** 30 seconden
- **Timeout:** 5 seconden

Uptime Kuma voert periodiek een check uit op de applicatie en registreert:
- Beschikbaarheidspercentage (uptime)
- Gemiddelde responstijd
- Grafieken van status over tijd

Hieronder zie je een screenshot van de werkende monitoring:

![alt text](Screenshots\Extra_opdrachten\App-monitor.png)


---

#### Alerting

In de Uptime Kuma app zijn nu automatische notificaties ingesteld.
Zodra de productie app Hello World down is komt er een automatisch alert naar discord. `http://100.122.151.29:8080/`

![alt text](Screenshots\Extra_opdrachten\Discord_alert.png)

---

#### Static Application Security Testing (SAST)

Er wordt nu een SAST scan toegevoegd aan de pipeline:
```yaml
- name: security scan
    image: node:18
    commands:
      - npm audit --audit-level=moderate
```

Hierbij de complete `.drone` file:

```yaml
kind: pipeline
type: docker
name: default

steps:
  - name: install & build
    image: node:18
    commands:
      - npm install

  - name: security scan
    image: node:18
    commands:
      - npm audit --audit-level=moderate

  - name: upload
    image: appleboy/drone-scp
    settings:
      host: 10.24.13.167
      username: Dockeradmin
      port: 22
      source: "./"
      target: "/home/Dockeradmin/deploy"
      key:
        from_secret: ssh_key

  - name: deploy
    image: appleboy/drone-ssh
    settings:
      host: 10.24.13.167
      username: Dockeradmin
      port: 22
      key:
        from_secret: ssh_key
      script:
        - cd /home/Dockeradmin/deploy
        - echo "🛑 Stop oude container"
        - docker stop demo-container || true
        - docker rm demo-container || true
        - echo "🐳 Build nieuwe container"
        - docker build -t demo-app .
        - echo "�� Start nieuwe container"
        - docker run -d --name demo-container -p 8080:8080 demo-app
```

![alt text](Screenshots\Extra_opdrachten\SAST_stap_pipeline.png)