#!/bin/bash

nombre=$1
resultat=1

for ((i=1; i<=nombre; i++)); do
  resultat=$((resultat * i))
done

echo "La factorielle de l'entier naturel $nombre est $resultat."

