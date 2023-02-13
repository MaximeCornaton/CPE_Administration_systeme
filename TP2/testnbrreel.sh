#!/bin/bash


function is_number()
{
	re='^[+-]?[0-9]+([.][0-9]+)?$'
	if ! [[ $1 =~ $re ]] ; then
		return 1
	else
		return 0
	fi
}


if is_number "$1"; then 
	echo "Le paramêtre est un nombre"
else
	echo "Erreur: le paramêtre n'est pas un nombre réel"
fi

