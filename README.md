### Workflow: 
- Rohdaten von TRENDY-, CMIP-, FLUXCOM-, P.-Modellen - , die aufgrund der umfangreichen Dateigrössen hier nicht verfügbar sind (intern: "data_2/scratch/ttrinidad/data/") - wurden mit den entsprechenden Skripts in \src temporal und räumlich aggregiert und detrendet. 
	> Folgende "Zwischenprodukte" sind ebenfalls lokal verfügbar: 
		- Annual Totals
		- Global Annual Totals
		- Detrended Global Annual Totals

- IAV Detrended Global Annual Totals liegen für die genannten Modellreihen als csv/txt in \data vor. 
- Für MsTMIP-Modelle konnte auf bereits aggregierte Outputs zurückgegriffen werden. IAV Detrended Global Annual Totals sind in \data abgelegt. 
- Mit "\R\GET_GCB_S3.R "  wird GCB SLAND mit E(LUC) verrechnet (äquivalent zu Trendy S3).  Outputdaten sind in "\data-raw" abgelegt. Auf Grundlage dieser wird mit "\R\get_iavar_GCB.R" IAV Detrended Global Annual Totals berechnet, abgelegt in "\data"
- Graphiken in \figures bauen auf Skripts in \analysis\figures auf. Diese greifen zuvor erwähnte IAV-Outputs abgelegt in "\data" auf. Ausreisser-Definition ist hergeleitet in \analysis\outliers_detection_beni.R
