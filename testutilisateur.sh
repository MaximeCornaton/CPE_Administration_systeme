#!/bin/bash

if [ $# -eq 0 ]; then
  echo "Utilisation : $(basename $0)nom_utilisateur"
  exit 1
fi

nom_utilisateur=$1

if id "$nom_utilisateur" &>/dev/null; then
  echo "L'utilisateur $nom_utilisateur existe."
else
  echo "L'utilisateur $nom_utilisateur n'existe pas."
fi

