#!/bin/bash

function is_integer()
{
local number=$1
local re='^[+-]?[0-9]+$'
if ! [[ $number =~ $re ]] ; then 
	echo "Les nombres ne sont pas des entiers!"
	exit 1
fi
}

function is_valid()
{
local number=$1
is_integer $1
if ! [[ $1 -gt -100  &&  $1 -lt 100 ]]; then 
	echo "Les nombres ne sont pas compris entre -100 et 100"
	exit 1
fi
}


function is_tested()
{
is_valid $1
somme=$(($somme+$1))
if [ $1 -lt $min ];then
	min=$1
elif [ $1 -gt $max ];then 
	max=$1
fi 
}


max=-101
min=101
moyenne=0
somme=0
nombre_param=$#

while (("$#")); do
is_tested $1
shift
done

if [ $nombre_param -gt 0 ];then
	moyenne=$(echo "$somme/$nombre_param" | bc -l) 

	echo "Minimum = $min - Maximum = $max - Moyenne = $moyenne" 
else
	echo "Veuillez entrer des parametres"

fi
