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

### Opmerking vooraf

Om de bouwstraat te maken komen er geen pushes naar de main. Op de acceptatie-omgving en/of test omgeving worden nieuwe features ontwikkeld.
Een succesvol geteste complete oplevering gaat vervolgens mergen met de main.

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

### Basisopdracht 2

instellen van gitea (Op de VM 166)

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


installeren van de app.

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

Installeren van drone op een andere VM (165)

![alt text](Screenshots\Opdracht2\droneinstall.png)

De Drone is gekoppeld met gitea.

![alt text](Screenshots\Opdracht2\Drone_gekoppeld_demo.png)