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

