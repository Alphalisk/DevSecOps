# Instructies: VS Code Instellen voor Huiswerkopdrachten in Markdown en Koppelen aan een GitHub Repository

Deze instructies helpen je om Visual Studio Code in te stellen voor het schrijven van documenten in Markdon, en deze te kopellen aan een git repository.

---

## Stap 1: Installeer Visual Studio Code en Git
1. **Installeer Visual Studio Code** via de [officiële website](https://code.visualstudio.com/).
2. **Installeer Git** als dit nog niet is gebeurd, via de [Git-website](https://git-scm.com/).

## Stap 2: Open een Nieuwe Map in Visual Studio Code
1. Open Visual Studio Code.
2. Ga naar **File > Open Folder...** en selecteer of maak een nieuwe map voor je huiswerk, bijvoorbeeld een map `DevSecOps-DT`.

## Stap 4: Zet Git en Markdown in Visual Studio Code
1. **Activeer de ingebouwde Git-functionaliteit** van VS Code. VS Code ondersteunt Git standaard, dus er is geen extra installatie nodig.
2. **Installeer een Markdown Preview-extensie** (optioneel). Ga naar de **Extensions** zijbalk (icoontje met vier blokjes) en zoek naar **Markdown Preview Enhanced** of **MArkdown All in one** om je Markdown-bestanden gemakkelijk te kunnen bekijken in VS Code.

## Stap 5: Verbind VS Code met de GitHub-repository
1. Open een terminal in VS Code via **View > Terminal**.
2. Navigeer naar de map als je nog niet in de juiste map bent:
   ```powershell
   cd pad/naar/jouw/map
   ```
   > je kunt ook met de rechter muisknop op je huiswerk OS linux map klikken en kies `Open in Integrated Terminal`
3. Initialiseer de map als Git-repository:
   ```powershell
   git init
   ```
> **Let op:** Controleer op de net aangemaakt lokale repo `main` gebruikt als default branch naam. Dit kun je doen met `git branch`. Als deze anders is dan `main` kun je een nieuwe branch aanmaken met: ```git branch -M main```
4. Verbind de lokale repository met jouw reposiroty. Vervang YOUR_REPO_URL met de URL van jouw repository (te vinden op de landings-pagina van de repository):
   ```
   git remote add origin YOUR_REPO_URL
   ```
   Voorbeeld:
   ```
   git remote add origin {https://github.com/jouwgebruikersnaam/RepoName}
   ```

## Stap 6: Maak een Nieuw Markdown-bestand
1. Klik met de rechtermuisknop op de zijbalk en selecteer **New File**.
2. Noem het bestand `documentatie.md`.
3. Schrijf je documentatie in Markdown, bijvoorbeeld met koppen, lijsten en tekst.

## Stap 7: Sla Je Werk Op en Push naar GitHub
1. Voeg alle wijzigingen toe aan de Git-staging area:
   ```powershell
   git add *
   ```
2. Maak een commit met een beschrijving van je wijzigingen:
   ```powershell
   git commit -m "Eerste versie van Documentatie"
   ```
3. Push je werk naar GitHub:
   ```powershell
   git push -u origin main
   ```

## Stap 8: Bekijk je Markdown 
- Om je Markdown-bestand als preview te bekijken, open documentatie.md, klik met de rechtermuisknop en kies Open Preview.

**Tips:**
> Voor elke nieuwe wijziging herhaal je de volgende stappen: `git add .` > `git commit -m "jouw commit message"` > `git push` om je werk bij te werken in GitHub.

> Als je ooit een andere branch gebruikt, vervang main in de push-commando’s met de naam van die branch. Je kunt ook de ingebouwde git GUI in VS Code gebruiken.