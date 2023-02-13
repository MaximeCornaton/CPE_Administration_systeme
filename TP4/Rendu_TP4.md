# **RENDU TP4** - _Maxime CORNATON_

## _Exercice 1. Commandes de base_

### **1.**

Pour mettre à jour le système :

```bash
sudo apt update
sudo apt upgrade
```

### **2.**

Pour un alias “maj” de la ou des commande(s) de la question précédente. :

```bash
alias maj='sudo apt update && sudo apt upgrade'
```

Pour que cet alias ne soit pas perdu au prochain redémarrage, il faut enregistrer cet alias dans ~/.bashrc ou ~/.bash_aliases

Pour verifier que l'alias enregistré pour les prochains demarrage fonctionne bien :

```bash
source ~/.bashrc
tp@serveur:~$ maj
```

### **3.**

Pour obtenir les 5 derniers paquets installés sur la machine :

```bash
tail -n 5 /var/log/dpkg.log
```

Pour obternir seulement les noms :

```bash
tail -n 5 /var/log/dpkg.log | cut -d " " -f 5
```

> initramfs-tools:all

> initramfs-tools:all

> 5.15.0-58.64

> linux-image-5.15.0-58-generic:amd64

> linux-image-5.15.0-58-generic:amd64

### **4.**

Pour lister les derniers paquets qui ont été installés explicitement avec la commande apt install :

```bash
cat /var/log/dpkg.log | grep "install" | tail -n 5
```

Pour obternir seulement les noms :

```bash
cat /var/log/dpkg.log | grep "install" | tail -n 5 | cut -d " " -f 5
```

> ufw:all

> man-db:amd64

> ca-certificates:all

> initramfs-tools:all

> linux-image-5.15.0-58-generic:amd64

### **5.**

Pour compter de deux manières différentes le nombre de total de paquets installés sur la machine :

```bash
dpkg -l | wc -l

apt list --installed | wc -l
```

> 618

> 614

La petite différence de comptage peut être due à des paquets non gérés par apt.

### **6.**

Pour connaître le nombre de paquets disponibles sur les dépôts Ubuntu, utiliser la commande :

```bash
apt-cache stats
```

et plus précisement :

```bash
apt-cache stats | grep "total de paquets"
```

> Nombre total de paquets : 118395 (3 315 k)

### **7.**

Glances est un outil de surveillance système. Il permet de surveiller les ressources système en temps réel. Il est installé avec la commande :

```bash
sudo apt install glances
```

tldr est un outil de documentation simplifiée pour les commandes en ligne de commande. Il est installé avec la commande :

```bash
sudo apt install tldr
```

hollywood est un outil d'installation d'effets de terminal. Il est installé avec la commande :

```bash
sudo apt install hollywood
```

Ou tous en une seule commande :

```bash
sudo apt install glances tldr hollywood
```

### **8.**

Les paquets qui proposent de jouer au soduku trouvables avec la commande :

```bash
apt search sudoku
```

## _Exercice 2._

Pour savoir d'où provient la commande ls:

```bash
dpkg -S $(which -a ls)
```

Cela retourne le nom du paquet qui a installé le fichier exécutable associé à la commande ls.
On a des erreurs mais on peut voir que le paquet coreutils est celui qui a installé la commande ls.

On écrit un script appelé origine-commande prenant en argument le nom d’une commande, et indiquant quel paquet l’a installé.
On fait en sorte de ne pas considérer les erreurs de la commande dpkg -S.

```bash
#!/bin/bash

dpkg -S $(which -a $1) 2> /dev/null
```

2> /dev/null permet de ne pas afficher les erreurs en les redirigean vers un trou noir, vers rien.

Pour recuperer le script de la VM:

```bash
scp -P 2222 tp@localhost:/home/tp/origine-commande /script
```

## _Exercice 3._

Ecrire une commande qui aﬀiche “INSTALLÉ” ou “NON INSTALLÉ” selon le nom et le statut du package spécifié dans cette commande.

```bash
#!/bin/bash

if [ "$#" -ne 1 ]; then
    echo "Entrez un nom de package a tester!"
    exit 1
fi

package_info=$(dpkg -S $(which -a $1) 2> /dev/null)

if [ -z "$package_info" ]; then
    echo "INSTALLÉ"
else
    echo "NON INSTALLÉ"
fi

```

## _Exercice 4._

Coreutils est un paquet dans le système d'exploitation Debian et ses dérivés, y compris Ubuntu, qui fournit une série de programmes utilitaires de base. Vous pouvez lister les programmes livrés avec coreutils en utilisant la commande suivante :

```bash
dpkg -L coreutils
```

Cela retourne la liste des fichiers installés par le paquet coreutils.

Le programme [ se nomme "test de condition" et est utilisé pour tester la condition de différentes façons, telles que tester l'existence d'un fichier ou la valeur d'une variable.
Il est souvent utilisé dans des scripts shell pour vérifier les conditions avant de prendre une action.

## _Exercice 5._

Pour installer l'installation des paquets emacs et lynx en utilisant la version graphique d'aptitude :

```bash
sudo app install aptitude
```

Cele ouvre la version graphique d'aptitude. Ensuite, on cherche les paquets emacs et lynx en utilisant la barre de recherche '(\)' et on installe les paquets avec + puis en appuyant sur g.

Astuce: ^pour le debut et $ pour la fin.

Emacs est un éditeur de texte avec de nombreuses fonctionnalités, telles que la coloration syntaxique, la gestion des macros et le support des plugins. Il est utile pour éditer du code source, des fichiers de configuration, etc.

Lynx est un navigateur web en ligne de commande. Il est utile pour naviguer sur le Web sans avoir besoin d'une interface graphique. Il est également utile pour télécharger des fichiers depuis le Web.

## _Exercice 6. Installation d’un paquet par PPA_

Pour installer la version Oracle ”oﬀicielle” de Java sur votre système en utilisant le ”dépôt personnel” (PPA) on ajoute le PPA :

```bash
sudo add-apt-repository ppa:linuxuprising/java
```

Ensuite, on met à jour votre liste des paquets disponibles :

```bash
sudo apt update
```

Enfin, on installe la version Oracle de Java :

```bash
sudo apt install oracle-java17-installer
```

Après avoir ajouté le PPA, un nouveau fichier a été créé dans le répertoire /etc/apt/sources.list.d :

```bash
ls /etc/apt/sources.list.d
```

> linuxuprising-ubuntu-java-jammy.list

Il contient les informations sur le PPA pour le paquet oracle-java17-installer.

## _Exercice 7. Installation d’un logiciel à partir du code source_

<Maxime CORNATON>
