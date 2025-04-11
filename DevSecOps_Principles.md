# DevSecOps Principes in mijn Bouwstraat

In mijn DevSecOps bouwstraat heb ik bewust verschillende principes toegepast om beveiliging, automatisering en samenwerking te integreren in het ontwikkelproces. Hieronder beschrijf ik welke principes ik heb toegepast, hoe, en verwijs ik naar bewijsstukken uit mijn verslag.

---

## 1. Shift Left Security

Beveiliging wordt vroeg in het ontwikkelproces geïntegreerd door een `npm audit` scan toe te voegen aan de pipeline. Zo worden kwetsbaarheden in dependencies al tijdens de build-fase ontdekt.

**Toegepast via:**
```yaml
- name: security scan
  image: node:18
  commands:
    - npm audit --audit-level=moderate
```

---

## 2. Collaboration

De inrichting van de bouwstraat brengt ontwikkelaars, operations (VM's, containers, deployment) en beveiligingschecks samen. Alles is gedocumenteerd en gedistribueerd over meerdere rollen en machines.

**Toegepast via:**
- Zelf geconfigureerde Gitea-server (collaboratie via Git)
- Pipelines met verschillende fases (build, deploy, monitoring)
- Discord-notificaties als communicatiemiddel (ChatOps)

---

## 3. Automation

Alle belangrijke processen zijn geautomatiseerd:
- CI/CD via Drone
- Container builds en restarts
- SAST scan
- Deployment via SCP + SSH
- Monitoring alerts

**Toegepast via:**
- `.drone.yml` pipeline met alle stappen geautomatiseerd
- Shell scripts voor monitoring setup

---

## 4. Continuous Security

Elke push naar `main` triggert automatisch de hele pipeline inclusief security scan, build en deployment. Beveiliging is dus continu onderdeel van de ontwikkelcyclus.

**Toegepast via:**
- `npm audit` check bij elke build
- Monitoring tools (Uptime Kuma & Netdata) draaien 24/7

---

## 5. Immutable Infrastructure

De oude containers worden automatisch gestopt en verwijderd, waarna een volledig nieuwe container wordt aangemaakt. Er wordt dus niet "gepatcht" in een bestaande omgeving.

**Toegepast via:**
```bash
docker stop demo-container || true
docker rm demo-container || true
docker build -t demo-app .
docker run -d --name demo-container -p 8080:8080 demo-app
```

---

## 6. Infrastructure as Code (IaC)

De infrastructuur en applicaties zijn volledig geconfigureerd met `docker-compose.yml` en shell scripts. Dit zorgt voor reproduceerbaarheid en versiebeheer van de infrastructuur.

**Toegepast via:**
- `docker-compose.yml` bestanden voor Gitea en Drone
- Setup scripts voor Netdata en de demo-app

---

## 7. Threat Modeling

Threat Modeling wordt nog niet toegepast in de bouwstraat.  
Dit is het vooraf anteciperen op gevaar door kwaadwillenden als hackers. 

---

## 8. Container Security

Alle applicaties draaien in containers. De containers worden telkens vers gebouwd, en zijn niet persistent, wat risico’s minimaliseert. Alleen de laatst gebouwde image wordt ingezet.

**Toegepast via:**
- Docker container builds in `.drone.yml`
- Volledige redeployment bij elke wijziging

---

## 9. Compliance as Code

Compliance as Code is nog niet expliciet geïmplementeerd in deze bouwstraat.  
Bij een grotere of productiegerichte omgeving zouden hier security policies als code geschreven kunnen worden (bijvoorbeeld voor GDPR, ISO27001 of NEN7510).

**Toekomstige uitbreiding:**
- Regelmatige scans op loginstellingen, datalogs, en back-up routines
- Tools als Open Policy Agent (OPA) of custom Drone plugins

---

## 10. Microservices Security

Mijn demo-app is op dit moment een monolithische Node.js applicatie, en geen microservices-gebaseerde architectuur. Hierdoor is specifieke microservice-beveiliging niet van toepassing.

**Toekomstige uitbreiding:**
- Gebruik van API-gateways en authenticatie per microservice
- Rate limiting en scoped access tokens per service

---

## 11. Education and Training

Tijdens dit project heb ik mezelf verdiept in:
- Het opzetten van een CI/CD pipeline met Drone
- Het beveiligen van Node.js applicaties met `npm audit`
- Monitoring & alerting tools zoals Uptime Kuma en Netdata
- Werken met containerisatie (Docker)
- Het beveiligen van infrastructuur via poortbeheer en SSH

**Toegepast via:**
- Zelfstudie van officiële documentatie (Gitea, Drone, Kuma, Netdata)
- Hands-on ervaring op een eigen Proxmox-cluster
- Feedbackrondes en begeleiding vanuit de opleiding


---

## 12. Continuous Monitoring and Incident Response

Elke VM (Gitea, Drone, Productie) is voorzien van Netdata voor realtime infrastructuur monitoring. Daarnaast controleert Uptime Kuma constant of de demo-app beschikbaar is.

**Toegepast via:**
- Netdata setup scripts
- Uptime Kuma installatie + monitor configuratie
- Discord alert bij downtime

---
