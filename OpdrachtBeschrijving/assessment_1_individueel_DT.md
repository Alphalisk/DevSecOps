# Oplevering DevSecOps DT: 

Voor de oplevering maken jullie een implementatie van een DSO-bouwstraat. 

Tijdens de oplevering verwacht ik een live demonstratie van je geïmplementeerde DSO-bouwstraat.


Er komt een oplever schema op BB. Wees op tijd om (verdere) uitloop te voorkomen.
(Neem ook de opname van de DSO-bouwstraat mee naar de oplevering mocht de live demo niet werken)

## Inleveren

De volgende onderdelen moeten op BB worden ingeleverd ***voor*** het einde je assessment. Wanneer wie hun assessment komt op BB in de opdracht beschrijving te staan.

- Een opname waar je jouw gerealiseerde pipeline demonstreren.

  > Applicatie in productie -> commit change naar main -> monitor bouw proces -> build stage -> test stage -> deploy naar productie -> aangepaste applicatie in productie. 
  Demonstreer hier ook de werking van de optionele onderdelen of concepten.

- Configuratie bestanden. Dit zijn vaak de YAML-files. (een zip van de gehele repo is goed)

- Beschrijving van je implementatie

- Beschrijf in een document per concepten hoe dit is geïmplementeerd, inclusief bewijsstukken dat deze zijn geïmplementeerd. Hier verwacht ik een lijst van alle punten en DevOps princiepes die je hebt gerealiseerd.

  > Schijf deze bijvoorbeeld ook in [Markdown](https://www.markdownguide.org/getting-started/) en bewaar deze op je repository.

Met bewijsstukken bedoel ik zaken zoals screenshots, configuraties, logfiles en je ervaring met het geïmplementeerde concept. 

## Grading

Je wordt beoordeeld op basis van je gecreëerde bouwstraat. De verplichte onderdelen samen resulteren in een 5.0. 
Om een 6.0 te behalen zal er minstends 1 van de aanvullende onderdelen/concepten moeten worden geimplementeerd.

Hierna is het uitgangspunt één extra punt per volledig correct geimplementeerd concept. Niet elke uitbreiding is even gemakkelijk te realiseren, uiteindelijk bepaald de docent hoeveel elke uitbreiding waard is op basis van complexiteit en uitvoering.

De lijst met aanvullende concepten is niet uitputtend, als je zelf ideeën overleg deze dan met je docent of dit ook mee telt.

<br>

<br>

## Onderdelen van je Bouwstraat
### De basis onderdelen van je Bouwstraat:
1. Een self-hosted installatie van [Gitea](https://about.gitea.com/). Dit mag zowel in op de Proxmox omgeving van het vak Cloud, in de public Cloud of self-hosted op een home lab. Documenteer deze instalatie zover dat je dit kun automatiseren met b.v. ansible.

2. Een fasering in je pipeline waar in ieder geval een opdeling in een Build en een Deploy stap. Bepaal zelf hoe deze fasering gebeurt, leg je keuzes hierin uit, heb je b.v. meerdere fases of één fase opgedeeld in meerdere stappen(en natuurlijk waarom je deze keuzes hebt gemaakt). Kies hierin zelf op je een standalone CI applicatie neemt(Hierin adviseer ik Drone CI) of Gitea actions.

3. Een gehoste en door jouw pipeline automatisch gedeployde webapplicatie naar keuze. kies een applicatie die gebuild moet worden. Dit kan b.v. een NodeJs applicatie zijn. Kijk b.v. op de [github awesome selfhosted list](https://github.com/awesome-selfhosted/awesome-selfhosted/tree/master) voor inspiratie als je zelf niks weet.

### Aanvullende onderdelen of concepten geïntegreerd in je bouwstraat.
- Geautomatiseerd opbouwen van een SBOM (Software bill of materials)

- Monitoring van de infrastructuur (dus de machine waar Gitea op runt, de build server en de productieserver).

- Monitoring van de webapplicatie (dit is tooling die de status van de gehoste applicatie kan monitoren, denk aan uptime en responsetijden van server requests).

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