#!/usr/bin/env bash

json="decp.json"

dir=`dirname "$0"`

if [[ ! -f $json ]]
then
    wget -nv https://www.data.gouv.fr/fr/datasets/r/16962018-5c31-4296-9454-5998585496d2 -O $json
fi

#head -n 1 $dir/../exemples/exemple-valide.csv
echo "id,rootId,seq,uid,acheteur.id,acheteur.nom,nature,objet,codeCPV,procedure,lieuExecution.code,lieuExecution.typeCode,lieuExecution.nom,dureeMois,dateNotification,datePublicationDonnees,montant,formePrix,titulaire.id,titulaire.typeIdentifiant,titulaire.denominationSociale,objetModification,donneesActuelles,anomalies" > decp.csv

now=`date +"%Y-%m-%dT%H:%M:%SZ"`
jq -f $dir/detect-anomalies.jq $json | jq -f $dir/decp-to-csv.jq --arg now "$now"  | jq -r '@csv' >> decp.csv
