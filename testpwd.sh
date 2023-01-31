#!/bin/bash

password="mdp"

test_password(){
read -sp 'Entrez votre mot de passe : ' password_w
while [ "$password_w" != "$password" ]
do
	read -sp 'Mauvais mot de passe : ' password_w
done
}


test_password
echo "Bienvenue $USER"
