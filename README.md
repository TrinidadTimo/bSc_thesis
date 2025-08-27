Dieses Repositorium stellt die Daten-Files und Prozess-Skripts meiner Bachelor-Arbeit zur Verfügung. Es folgt der folgenden inhaltlichen Organisationsstruktur: 

- Rohdaten von TRENDY-, CMIP-, FLUXCOM-, P.-Modellen - , die aufgrund der umfangreichen Dateigrössen hier nicht verfügbar sind (intern: "data_2/scratch/ttrinidad/data/") - wurden mit den entsprechenden Bash-Skripts im Ordner "/src" vorprozessiert (temporal und räumlich aggregiert und detrendet). Neben den Rohdaten sind folgende "Zwischenprodukte" ebenfalls lokal verfügbar:
  - Annual Totals
  - Global Annual Totals
  - Detrended Global Annual Totals
 Rohdaten mit geringerer Dateigrösse sind im Ordner "data-raw/" abgelegt.

- Der "/data"-Ordner führt prozessierte Daten im tidy-Format auf (globale Absolutwerte, Variationskoeffizienten, IAV-Werte, jeweils nach Ensemble-Gruppen) sowie R-Plot-Objekte, die in verschiedenen Skripts aufgerufen werden und somit einfacher verfügbar gemacht werden.
  
- Unter "analysis" sind R-Files zur Daten-Vorprozessierung, -Prozessierung (GCB), Erstellung von Graphen, für deskriptive Statistik, zur Berechnung der Bootstrapping-Verteilung und für Sanity-Checks abgelegt.
  
- Unter "/figures" sind Bilder (.png) der im Paper angeführten sowie weiterführenden Graphen abgelegt.
  

