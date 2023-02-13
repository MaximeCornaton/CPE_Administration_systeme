#!/bin/bash

function is_integer()
{
local number=$1
local re='^[+-]?[0-9]+$'
if ! [[ $number =~ $re ]] ; then 
	echo "Les nombres ne sont pas des entiers!"
	return 1
fi
return 0
}

function is_valid()
{
if ! (is_integer $1); then
        return 1
fi

if ! [[ $1 -gt -100  &&  $1 -lt 100 ]]; then 
	echo "Les nombres ne sont pas compris entre -100 et 100"
	return 1
fi
return 0
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

tableau=()
read -p 'Saisissez une premiere valeur : ' last_val
while (is_valid $last_val); do
	tableau["${#tableau[@]}+1"]=$last_val
	echo ${tableau[@]}
	read -p 'Saisissez une valeur : ' last_val
done

for val in ${tableau[@]}
do
	is_tested $val
done

if [ ${#tableau[@]} -gt 0 ];then
	moyenne=$(echo "$somme/${#tableau[@]}" | bc -l) 

	echo "Minimum = $min - Maximum = $max - Moyenne = $moyenne" 
fi
