#!/bin/bash

random_number=$(((RANDOM % 1000) + 1))

while true; do
  read -p "Devinez le nombre : " guess
  if [[ $guess -lt $random_number ]]; then
    echo "C'est plus"
  elif [[ $guess -gt $random_number ]]; then
    echo "C'est moins"
  else
    echo "Gagné!"
    break
  fi
done

