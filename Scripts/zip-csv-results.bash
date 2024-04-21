#!/bin/bash
MONTH=$1
EXTRACT_DATE=$2

PAT='/mnt/c/Users/NizarAjroud/NZSPCE/OPERATIONAL/TECH_DOCS/PROJECTS/Woopen/WOOPEN-CONFIGS/CSV_CMS_Database_Query_Results/'


cp -R $PAT/$MONTH $PAT/../woopenDrive_Exports/cms-data-sql-scripts-output-"$EXTRACT_DATE"
cd $PAT/../woopenDrive_Exports
zip   cms-data-sql-scripts-output-$EXTRACT_DATE.zip  cms-data-sql-scripts-output-$EXTRACT_DATE/*.csv

rm -Rf $PAT/../woopenDrive_Exports/cms-data-sql-scripts-output-$EXTRACT_DATE
cd "$OLDPWD" 
open-path $PAT/../woopenDrive_Exports/
open https://drive.google.com/drive/u/0/folders/104cRfvRt3v0sjgTbaGstwtrp0AHqxoet

#Shared drives\TECH\Documents Partagés\CMS Database Query Results