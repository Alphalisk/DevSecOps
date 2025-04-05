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

# Gebruikersinstructie `GoldenImage_maak_vm_ubuntu_tailscale`

- De parameters moeten een IP bevatten die nog neit in gebruik is!
- te wijzigen 5 parameters voor gebruik (alles met `Dit aanpassen`!)
  ![alt text](Screenshots\WijzigInstellingen.png)
- daarna kan het afgetrapt worden. 
- Bij de eerste aftrap kan de melding komen halverwege dat de SSH key public key indien IP eerder gebruikt en verwijderd.
- Los dit op met `ssh-keygen -f "/home/beheerder/.ssh/known_hosts" -R "10.24.13.xxx"` xxx = de gebruikte IP *(kan ook automatisch in script)*
- daarna kan het opnieuw vanaf dat punt verder afgetrapt worden.