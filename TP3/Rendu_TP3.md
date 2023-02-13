# **RENDU TP3** - _Maxime CORNATON_

## _Exercice 1. Gestion des utilisateurs et des groupes_

### **1.**

Pour créer 2 groupes _dev_ et _infra_ on utilise les commandes :

```bash
sudo groupadd dev
sudo groupadd infra
```

Pour verifier:

```bash
cat /etc/group
```

### **2.**

Pour créer 4 utilisateurs en demandant la creation de leur dossier personnel et avec bash pour shell :

```bash
sudo useradd -m -s /bin/bash alice
sudo useradd -m -s /bin/bash bob
sudo useradd -m -s /bin/bash charlie
sudo useradd -m -s /bin/bash dave
```

Pour verifier:

```bash
cat /etc/passwd
```

### **3.**

Pour ajouter les utilisateurs dans les groupes créés:

```bash
sudo usermod -a -G dev alice
sudo usermod -a -G dev bob
sudo usermod -a -G dev dave
sudo usermod -a -G infra bob
sudo usermod -a -G infra charlie
sudo usermod -a -G infra dave
```

Pour verifier:

```bash
groups dave
```

### **4.**

Deux moyens d’aﬀicher les membres de infra sont:

```bash
cat /etc/group | grep infra
getent group infra
```

### **5.**

Pour faire de dev le groupe propriétaire des répertoires /home/alice et /home/bob et de infra le groupe propriétaire de /home/charlie et /home/dave :

```bash
sudo chgrp -R dev /home/alice
sudo chgrp -R dev /home/bob
sudo chgrp -R infra /home/charlie
sudo chgrp -R infra /home/dave
```

### **6.**

Pour remplacer le groupe primaire des utilisateurs :

- dev pour alice et bob
- infra pour charlie et dave

```bash
sudo usermod -g dev alice
sudo usermod -g dev bob
sudo usermod -g infra charlie
sudo usermod -g infra dave
```

### **7.**

Pour créer deux répertoires /home/dev et /home/infra pour le contenu commun aux membres de chaque
groupe, et mettez en place les permissions leur permettant d’écrire dans ces dossiers :

```bash
sudo mkdir /home/dev
sudo mkdir /home/infra
sudo chgrp dev /home/dev
sudo chgrp infra /home/infra
sudo chmod 770 /home/dev
sudo chmod 770 /home/infra
```

Pour verifier:

```bash
ls /home
```

### **8.**

Le sticky bit (t) indique que dans ce dossier seul le propriétaire d’un fichier ait le droit de renommer ou supprimer ce fichier.

```bash
chmod +t /home/dev
chmod +t /home/infra
```

### **9.**

Non nous ne pouvons pas ouvrir une session en tant que _alice_, car le compte est désactivé.

### **10.**

On definit un mot de passe à alice :

```bash
sudo passwd alice
```

On se connecte avec la commande :

```bash
su alice
```

### **11.**

Pour obtenir l’uid et le gid de alice :

```bash
id alice
```

### **12.**

Pour retrouver l’utilisateur dont l’uid est 1003 :

```bash
getent passwd 1003 | cut -d: -f1
```

ou simplement :

```bash
id 1003
```

### **13.**

Pour obtenir l’id du groupe dev :

```bash
getent group dev | cut -d: -f3
```

### **14.**

Pour connaitre le groupe qui a pour gid 1002 :
Attention si un groupe s'appelle 1002 cela ne fonctionne pas :

```bash
getent group 1002 | cut -d: -f1
```

On peut utiliser quelque chose de ce type:

```bash
getent group | grep -E ":1002" | cut -d: -f1
```

Mais là encore il ne faut pas le le groupe porte le nom ":1002"...

### **15.**

Pour retirez l’utilisateur charlie du groupe infra :

```bash
sudo gpasswd -d charlie infra
```

Le prolème est que infra est le seul groupe de charlie, il est impossible qu'un utilisateur n'appartienne a aucun groupe... Ainsi, charlie reste dans le groupe infra.

### **16.**

Pour modifier le compte de dave de sorte que :
— il expire au 1er juin 2021
— il faut changer de mot de passe avant 90 jours
— il faut attendre 5 jours pour modifier un mot de passe
— l’utilisateur est averti 14 jours avant l’expiration de son mot de passe
— le compte sera bloqué 30 jours après expiration du mot de passe

```bash
sudo chage -E 2021-06-01 -M 90 -m 5 -W 14 -I 30 dave
```

### **17.**

L’interpréteur de commandes (Shell) par défaut pour l'utilisateur root est /bin/bash

```bash
grep root /etc/passwd
```

### **18.**

L'utilisateur nobody est un compte utilisé pour certaines choses ou l'identification ou l'autorisation n'est pas obligaoire.

### **19.**

Le mot de passe de sudo est conservé pendant 15 minutes par défault. La commande pour forcer sudo à oublier notre mot de passe est:

```bash
sudo -k
```

## _Exercice 2. Gestion des permissions_

### **1.**

Pour créer un dossier test et un fichier fichier dans le répertoire HOME, les commandes seraient les suivantes :

```bash
mkdir ~/test
cd ~/test
echo "On ecrit quelques lignes de texte" > fichier
```

### **2.**

Les droits sur test et fichier peuvent être vus avec la commande ls -l qui affichera une ligne pour chaque fichier/dossier avec les informations de permissions, propriétaire, etc.

Pour retirer tous les droits sur le fichier, on peut utiliser la commande :

```bash
chmod 000 fichier
```

Si on essaie de le modifier ou de l'afficher en tant que root, c'est possible meme si root n'a pas les permissions nécessaires...

### **3.**

Pour redonner les droits en écriture et exécution sur le fichier, on peut utiliser la commande

```bash
chmod +wx fichier
```

La commande

```bash
echo "echo Hello" > fichier
```

remplace le contenu du fichier. Les droits ne sont pas impactés.

Sans les droits d'écriture on a pu écrire dans le fichier...

### **4.**

On utilise

```bash
./fichier
```

pour executer le fichier.

Je ne parviens pas à executer le fichier...
Si on utilise sudo, le fichier est exécuté en tant que root et les restrictions liées aux droits ne s'appliquent plus.

### **5.**

Pour retirer le droit en lecture sur le répertoire test:

```bash
chmod -r ~/test
```

On obtient une erreur si on execute ou affiche le contenu du fichier _fichier_, car l'utilisateur n'a plus le droit en lecture sur ce répertoire.

Si on rétablit le droit en lecture il est possible de realiser ces actions.

### **6.**

Pour créer dans test un fichier nouveau ainsi qu’un répertoire sstest :

```bash
touch nouveau
mkdir sstest
```

Pour retirer les droits en écriture sur le fichier nouveau et le répertoire test :

```bash
chmod -w ~/test/nouveau
chmod -w ~/test
```

Si on essaie de modifier le fichier _nouveau_, on obteint une erreur car l'utilisateur n'a plus le droit en écriture.
Si on rétablit le droit en écriture sur le répertoire _test_ avec

```bash
chmod +w ~/test
```

il est possible de modifier le fichier et de le supprimer.

### **7.**

Pour retirer le droit d'exécution sur le répertoire _test_:

```bash
cd ~
chmod a-x test
```

Lorsqu'on tente de créer, supprimer ou modifier un fichier dans ce répertoire, on obtient une erreur car nous n'avons plus les permissions nécessaires pour le faire.
Si nous essayons de nous déplacer dans ce répertoire, on a également une erreur car nous n'avons plus le droit d'exécution sur ce répertoire.
Ainsi le droit d'exécution sur un répertoire est nécessaire pour y effectuer des actions.

### **8.**

Pour rétablir le droit d'exécution sur le répertoire test et se placer à l'intérieur:

```bash
chmod a+x test
cd test
```

Nous ne pouvons plus nous y déplacer ni y effectuer d'actions.
Ainsi nous devons avoir le droit d'exécution sur le répertoire courant pour effectuer des actions dessus.

"cd .." fonctionne toujours car ce n'est pas une action sur le répertoire lui-même, mais sur le répertoire parent.

### **9.**

Pour rétablir le droit d'exécution sur le répertoire _test_ et donner les droits suﬀisants pour qu’une autre personne de mon groupe puisse y accéder en lecture, mais pas en écriture :

```bash
chmod a+x test
cd test
chmod 664 fichier
```

### **10.**

Pour définir un umask très restrictif qui interdit à quiconque à part vous l’accès en lecture ou en écriture, ainsi que la traversée de mes répertoires :

```bash
umask 077
```

Cela signifie que les permissions par défaut pour les nouveaux fichiers seront 700 (rwx------) et les permissions par défaut pour les nouveaux répertoires seront 700 (rwx------).
On peut vérifier cela en créant un nouveau fichier ou répertoire et en affichant ses permissions.

### **11.**

Pour définir un umask très permissif, on peut utiliser la commande suivante :

```bash
umask 022
```

Cela signifie que les permissions par défaut pour les nouveaux fichiers seront 644 (rw-r--r--) et les permissions par défauts pour les nouveaux répertoires seront 755 (rwxr-xr-x).

### **12.**

Pour définir un umask équilibré qui m'autorise un accès complet et autorise un accès en lecture aux membres de mon groupe :

```bash
umask 002
```

Pour vérifier que les permissions du nouveau fichier et du nouveau répertoire sont correctes:

```bash
touch testfile
mkdir testdir
ls -l
```

### **13.**

La notation classique à la notation octale :

```
chmod u=rx,g=wx,o=r fic -> chmod 534 fic
chmod uo+w,g-rx fic -> chmod 602 fic en sachant que les droits initiaux de fic sont r--r-x---
```

La notation octale à la notation classique :

```
chmod 653 fic -> chmod u=rw-,g=r-x,o=-wx fic en sachant que les droits initiaux de fic sont 711
chmod u+x,g=w,o-r fic -> chmod 520 fic en sachant que les droits initiaux de fic sont r--r-x---
```

Pour vérifier on peut utiliser :

```bash
stat -c "%a %A" fic
```

qui nous indique les autorisations de _fic_ aussi bien en notation classique qu'en notation octale.

### **14.**

Pour afficher les droits sur le programme passwd :

```bash
ls -l /usr/bin/passwd
```

Le programme passwd a les permissions rwsr-xr-x, ce qui signifie que le propriétaire peut lire, écrire et exécuter le programme, et que les autres utilisateurs peuvent uniquement exécuter le programme.

Le fichier /etc/passwd est utilisé pour gérer les informations sur les utilisateurs du système, et le programme passwd est utilisé pour modifier ces informations.

Il est important de s'assurer que le propriétaire du programme passwd (généralement root) peut le modifier en toute sécurité, tandis que les autres utilisateurs ne peuvent exécuter le programme que pour changer leur propre mot de passe.

<Maxime CORNATON>
