# DevSecOps
Repository voor huiswerk en opdrachten DevSecOps.

Inventaris:
- Het verantwoordingsverslag voor de opdrachten wordt in het bestand *Verantwoordingsverslag.md* bijgehouden.
- De map screenhots bevat bewijsvoering
- De map Scripts bevat bash scripts
- De map Playbooks bevat de .yml files

**Netwerkconfiguratie:**
|nodenaam|IP intern    |Type node    |IP Tailscale  |
|--------|-------------|-------------|--------------|
|pve00   |10.24.13.100 |control node |100.94.185.45 |
|pve01   |10.24.13.101 |managed node |100.104.126.78|
|pve02   |10.24.13.102 |managed node |100.84.145.8  |

## Gebruikersinstructie `GoldenImage_maak_vm_ubuntu_tailscale`

- Het script moet een IP bevatten die nog niet in gebruik is! En voor tailscale ook niet in gebruik is geweest.
- daarna kan het afgetrapt worden. 
- Op het eind wil de compose-up niet altijd werken. het einde opnieuw aftrappen doet het dan vaak wel.

## Gitea, Drone en productie

Hoe in te loggen:

- Gitea
  `http://100.85.133.118:3000`
- Drone
  `http://100.80.163.27:8080`
- productie
  `http://100.122.151.29:xxx`



