#!/bin/bash

if [ $# -ne 1 ]; then 
	echo "Usage : $(basename $0) username"
	exit 1
fi

username = $1
if id "$username" >/dev/null 2>&1; then
	echo "Utlisateur '$username' existe."
else 
	exho "Erreur: Utilisateur '$username'  n'existe pas.	
	exit 1
fi
