#!/bin/bash

if [ $# -eq 0 ]; then
  echo "Utilisation : $(basename $0)nom_utilisateur"
  exit 1
fi

username=$1

if id "$username" &>/dev/null; then
  echo "L'utilisateur $username existe."
else
  echo "L'utilisateur $username n'existe pas."
fi

