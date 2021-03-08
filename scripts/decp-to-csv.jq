[.marches[] | select(._type == "Marché" and (.titulaires? | length) > 0)] | map(
. as $m |

(reduce .modifications[] as $mod ({};
{
    "objetModification": ($mod.objetModification // .objetModification),
    "dureeMois": ($mod.dureeMois // .dureeMois),
    "montant": ($mod.montant // .montant),
    "titulaires": ($mod.titulaires // .titulaires)
})) as $modifications
     |
 ($modifications.titulaires // .titulaires) | map (
    {
        "id": $m.id?,
        "uid": $m.uid?,
        "acheteur.id": $m.acheteur.id?,
        "acheteur.nom": $m.acheteur.nom?,
        "nature": $m.nature?,
        "objet": $m.objet?,
        "codeCPV": $m.codeCPV?,
        "procedure": $m.procedure?,
        "lieuExecution.code": $m.lieuExecution.code?,
        "lieuExecution.typeCode": $m.lieuExecution.typeCode?,
        "lieuExecution.nom": $m.lieuExecution.nom?,
        "dureeMois": ($modifications.dureeMois // $m.dureeMois?),
        "dateNotification": $m.dateNotification?,
        "datePublicationDonnees": (if $m.modifications[0] then $modifications.datePublicationDonneesModification else $m.datePublicationDonnees end),
        "montant": $m.montant?,
        "formePrix": $m.formePrix?,
        "titulaire.id": .id?,
        "titulaire.typeIdentifiant": .typeIdentifiant?,
        "titulaire.denominationSociale": .denominationSociale?,
        "objetModification": $modifications.objetModification,
        #"anomalies": ($m.anomalies | length)
        "donneesActuelles": 0,
        #"modifications": $modifications,
        "anomalies": (if ($m.anomalies) then $m.anomalies | join(";") else "" end)
    }
)
|
map ( [to_entries[] | .value]) | .[]
)
| .[]
