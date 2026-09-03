# Detaillierter Bug-Report & Entwickler-Prompt: UI-Skalierungsfehler beim Neustart (Replay) in der Ticket-Tamer-App

## 1. Executive Summary & Kontext
In der Immersive- / XR-Anwendung **"Ticket Tamer"** tritt ein reproduzierbarer UI-Layout- und Skalierungsfehler auf. Während der initiale Programmstart (Cold Start / First Run) alle Bedienelemente, Schieberegler und Dialogboxen maßstabsgetreu, scharf und vollständig rendert, führt das Auslösen der Funktion **"Erneut spielen"** (Replay-Loop) zu einer fehlerhaften, stark verkleinerten Darstellungsgeometrie. Dieser Fehler zieht sich durch alle darauffolgenden Phasen (Startbildschirm, Prioritätszuweisung, Teamzuweisung).

---

## 2. Genaue Beschreibung der visuellen Diskrepanzen (Vorher vs. Nachher)

### A. Initialer Start (Erwarteter Zustand)
* **Startbildschirm:**
  * Der Haupttitel „Ticket Tamer“ und der Beschreibungstext werden in voller Lesetypografie und korrekter Box-Größe dargestellt.
  * Der horizontale **Schieberegler ("Anzahl Tickets")** besitzt eine adäquate, breite Ausdehnung mit klar erkennbaren Minusz-/Plus-Buttons und einem gut greifbaren Daumenregler sowie zentrierter numerischer Anzeige (z. B. 6).
  * Der Button „Spiel starten“ ist proportional stimmig eingebettet.
* **Prioritätszuweisung:**
  * Die drei Prioritätsboxen (**Normal**, **Wichtig**, **Kritisch**) erscheinen in großzügiger, gut greifbarer Kachelform im virtuellen Raum bzw. auf dem UI-Canvas.
* **Teamzuweisung:**
  * Die vier Team-Kacheln (**Netzwerk**, **Konto**, **Software**, **Hardware**) sind gleichmäßig skaliert und bieten ausreichend Platz für Beschriftung und Icons.

### B. Nach Klick auf „Erneut spielen“ (Fehlerhafter Zustand)
* **Startbildschirm (Replay):**
  * Der **Schieberegler** schrumpft massiv in seiner Breite und Skalierung zusammen. Die Elemente wirken gestaucht.
  * Der begleitende Text wird unvollständig gerendert oder bricht visuell ab.
* **Prioritätszuweisung (Replay):**
  * Die Dimensionen der **Prioritätsboxen** verändern sich sprunghaft (sie werden deutlich kleiner oder unproportioniert skaliert).
* **Teamzuweisung (Replay):**
  * Auch die **Team-Kacheln** übernehmen die fehlerhafte, geschrumpfte Skalierung, was zu einem inkonsistenten User Experience (UX)-Eindruck führt.

---

## 3. Technischer Analyse-Fokus für Entwickler

Mögliche Ursachen im Quellcode, die geprüft werden müssen:
1. **State-Reset & DOM-/Canvas-Re-initialisierung:** Werden beim Übergang von „Spiel beendet“ zurück zum Startbildschirm globale Transformationsmatrizen, Viewport-Skalierungen oder CSS-Container-Größen nicht vollständig zurückgesetzt?
2. **Event-Listener & Resize-Observer:** Löst der Replay-Trigger fehlerhafte Neuberechnungen (`ResizeObserver`, `window.devicePixelRatio`, XR-Layer-Skalierung) aus, die sich auf akkumulierte Skalierungsfaktoren (`scale()`) auswirken?
3. **Komponenten-Wiederverwendung (Mount/Unmount Lifecycle):** Wird die UI-Komponente beim Neustart lediglich neu gerendert (Re-render), ohne dass die initialen Layout-Bounding-Boxes oder CSS-Klassen neu initialisiert werden, wodurch Style-Kaskaden oder Inline-Styles (z. B. transform-scale) fehlerhaft akkumulieren?

---

## 4. Ausformulierter Prompt für die KI / Entwicklung

> **Kontext:** 
> Ich entwickle die XR-/Web-Applikation **"Ticket Tamer"**, in der Support-Tickets bearbeitet, priorisiert und Teams zugeordnet werden.
> 
> **Fehlerbeschreibung:** 
> Beim initialen Start verhalten sich alle UI-Elemente korrekt: Der Schieberegler auf dem Startbildschirm sowie die Boxen in den Phasen „Priorität zuordnen“ und „Team zuordnen“ haben die richtige Größe und sind vollständig lesbar. 
> Wenn der Nutzer jedoch das Spiel durchläuft, den Endbildschirm erreicht und auf **„Erneut spielen“** klickt, bricht das Layout ein: Der Schieberegler auf dem Startbildschirm schrumpft drastisch zusammen (Text unvollständig). In den darauffolgenden Schritten behalten auch die Prioritäts- und Team-Boxen diese fehlerhafte, zu kleine Skalierung bei.
> 
> **Deine Aufgabe als Entwickler:**
> 1. Analysiere den Lifecycle, den State-Management-Store sowie die Reset-Logik (`handleRestart` / Replay-Trigger) der App.
> 2. Identifiziere, warum sich die CSS-Transformationen, Canvas-Skalierungen oder Layout-Container beim zweiten Durchlauf verändern (Verdacht auf akkumulierende Skalierungsfaktoren, fehlende Reset-States oder fehlerhaftes Re-mounting).
> 3. Implementiere eine robuste Lösung, die sicherstellt, dass beim Klick auf „Erneut spielen“ sämtliche UI-Komponenten (Schieberegler, Texte, Boxen) exakt in derselben initialen, sauberen Skalierung und Darstellung gerendert werden wie beim allerersten Start.
