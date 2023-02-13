# **RENDU TP 5 - Systèmes de fichiers, partitions et disques** - *Maxime CORNATON*

## *Exercice 1. Disques et partitions*


### **1.**


Dans l’interface de configuration de notre VM Oracle, on créer un second disque dur, de 5 Go dynamiquement alloués ;


### **2.**

On vérifie que ce nouveau disque dur est bien détecté par le système

```bash
sudo fdisk -l
```

On voit bien que le nouveau disque dur est bien détecté par le système, il est nommé "/dev/sdb".

```bash Disk /dev/sdb: 5 GiB, 5368709120 bytes, 10485760 sectors
Disk model: VBOX HARDDISK   
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
```

### **3.**

On partitionne ce disque en utilisant fdisk : on créer une première partition de 2 Go de type Linux (n°83), et une seconde partition de 3 Go en NTFS (n°7)

```bash
sudo fdisk /dev/sdb
```
- On appuie sur "n" pour créer une nouvelle partition
- On appuie sur "p" pour une partition primaire
Entrez 1 pour la première partition et 2 pour la seconde partition
- On entre les secteurs de début et de fin souhaités pour chaque partition
/!\ Sa taille est défine par son nombre de secteurs, on utilise + pour definir sa taille directement en Mo.
- On appuie sur "t" pour changer le type de partition et entrez 83 pour la première partition et 7 pour la seconde partition
- On appuie sur "w" pour écrire les modifications et quitter fdisk.

Pour verifier que les deux partitions ont bien été créées:

```bash
sudo fdisk -l
```

```bash Disk /dev/sdb: 5 GiB, 5368709120 bytes, 10485760 sectors
Disk model: VBOX HARDDISK   
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disklabel type: dos
Disk identifier: 0xf67efa4c

Device     Boot   Start      End Sectors Size Id Type
/dev/sdb1          2048  4196351 4194304   2G 83 Linux
/dev/sdb2       4196352 10485759 6289408   3G  7 HPFS/NTFS/exFAT
```

### **4.**


A ce stade, les partitions ont été créées, mais elles n’ont pas été formatées avec leur système de fichiers.

Pour formater les deux partitions, on execute les commandes suivantes :

```bash
sudo mkfs -t ext4 /dev/sdb1
sudo mkfs -t ntfs /dev/sdb2
```

```bash mke2fs 1.46.5 (30-Dec-2021)
Creating filesystem with 524288 4k blocks and 131072 inodes
Filesystem UUID: d51d3454-b43b-4cd0-8ca8-5b68d0383d98
Superblock backups stored on blocks: 
	32768, 98304, 163840, 229376, 294912

Allocating group tables: done                            
Writing inode tables: done                            
Creating journal (16384 blocks): done
Writing superblocks and filesystem accounting information: done 

Cluster size has been automatically set to 4096 bytes.
Initializing device with zeroes: 100% - Done.
Creating NTFS volume structures.
mkntfs completed successfully. Have a nice day.
```

### **5.**

La commande "df -T", qui aﬀiche le type de système de fichier des partitions, ne fonctionne pas sur notre disque car les deux partitions ne sont pas encore montées, elles ne sont donc pas visibles dans le système de fichiers.


### **6.**

Pour faire en sorte que les deux partitions créées soient montées automatiquement au démarrage de la machine, respectivement dans les points de montage /data et /win, on va modifier le fichier "/etc/fstab" :

On ouvre le fichier "/etc/fstab" :

```bash
sudo mkdir /data
sudo mkdir /win
sudo nano /etc/fstab
```

et on ajoute les lignes suivantes :

```bash
/dev/sdb1 /data ext4 defaults 0 0
/dev/sdb2 /win ntfs defaults 0 0
```

### **7.**

Exécutez la commande "mount -a" pour valider la configuration et monter toutes les partitions listées dans "/etc/fstab", puis redémarrez la machine pour valider la configuration.

```bash
sudo mount -a
sudo reboot
```

On verifie que les deux partitions sont bien montées :

```bash
df -T
```
```bash
Filesystem                        Type    1K-blocks    Used Available Use% Mounted on
[...]
/dev/sdb1                         ext4      1992552      24   1871288   1% /data
/dev/sdb2                         fuseblk   3144700   16264   3128436   1% /win
```


### **8.**

Pour créer un dossier partagé entre la machine virtuelle et le système hôte, dans l'interface de VirtualBox on parametre un dossier partagé.
- On clique sur "Paramètres" puis "Dossiers partagés"
- On clique sur le "+" pour ajouter un dossier partagé
- On donne un nom au dossier partagé (par exemple "partage_VM")
- On donne le chemin du dossier partagé (par exemple "/home/etudiant/partage_VM")
- On coche la case "Lecture seule" si on veut que le dossier soit accessible en lecture seule depuis la machine virtuelle
- On coche la case "Auto montage" pour que le dossier soit monté automatiquement au démarrage de la machine virtuelle


```bash
sudo mkdir ~/partage_VM
```


## *Exercice 2. Partitionnement LVM*

Dans cet exercice, on aborde le partitionnement LVM, beaucoup plus flexible pour manipuler les disques et les partitions.

### **1.**

On va réutiliser le disque de 5 Gio de l’exercice précédent. On démonte les systèmes de fichiers montés dans /data et /win et on supprime les lignes correspondantes du fichier /etc/fstab

Pour démonter les systèmes de fichiers montés dans "/data" et "/win":

```bash
sudo umount /data
sudo umount /win
```

Pour supprimer les lignes correspondantes au disque de 5 Gio du fichier "/etc/fstab" :

```bash
sudo nano /etc/fstab
```

On sauvegarde le fichier et on quitte nano. On vérifie que les deux partitions sont bien démontées :

```bash
df -T
```

### **2.**

On veut supprimer les deux partitions du disque, et créer une partition unique de type LVM
> La création d’une partition LVM n’est pas indispensable, mais vivement recommandée quand
on utilise LVM sur un disque entier. En effet, elle permet d’indiquer à d’autres OS ou logiciels de
gestion de disques (qui ne reconnaissent pas forcément le format LVM) qu’il y a des données sur
ce disque.

> Attention à ne pas supprimer la partition système !

Pour supprimer les deux partitions du disque, exécutez les commandes suivantes :

```bash
sudo fdisk /dev/sdb
```

- On supprime les deux partitions avec la commande "d"

- On créer une partition de type LVM avec la commande "n" 
- On change son type pour "8E" (Linux LVM) puis on quitte fdisk avec la commande "w".

On execute mount -a pour monter les partitions.

On affcihe les partitions et on observe bien qu'elles n'existent plus :

```bash
sudo fdisk -l
```

```bash
Disk /dev/sdb: 5 GiB, 5368709120 bytes, 10485760 sectors
Disk model: VBOX HARDDISK   
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disklabel type: dos
Disk identifier: 0xf67efa4c

Device     Boot Start      End  Sectors Size Id Type
/dev/sdb1        2048 10485759 10483712   5G 8e Linux LVM
```

### **3.**

Pour créer un volume physique LVM: 

```bash
sudo pvcreate /dev/sdb1
```

```bash
Physical volume "/dev/sdb1" successfully created.
```

On vérifie la création du volume physique :

```bash
sudo pvdisplay
```

```bash
"/dev/sdb1" is a new physical volume of "<5,00 GiB"
  --- NEW Physical volume ---
  PV Name               /dev/sdb1
  VG Name               
  PV Size               <5,00 GiB
  Allocatable           NO
  PE Size               0   
  Total PE              0
  Free PE               0
  Allocated PE          0
  PV UUID               wN5oTw-r0Rh-gq3c-S2m4-12M6-mMVD-aGnvGY
```


> Toutes les commandes concernant les volumes physiques commencent par pv. Celles concernant les groupes de volumes commencent par vg, et celles concernant les volumes logiques par lv.



### **4.**

On veut créer un groupe de volumes, qui pour l’instant ne contiendra que
le volume physique créé à l’étape précédente. 

> Par convention, on nomme généralement les groupes de volumes vgxx (où xx représente l’indice du groupe de volume, en commençant par 00, puis 01...)

Pour créer un groupe de volumes, exécutez les commandes suivantes :

```bash
sudo vgcreate vg00 /dev/sdb1
```

Pour vérifier la création du groupe de volumes :
```bash
vgdisplay
```


### **5.**

Pour créer un volume logique appelé lvData occupant l’intégralité de l’espace disque disponible.
> On peut renseigner la taille d’un volume logique soit de manière absolue avec l’option -L (par exemple -L 10G pour créer un volume de 10 Gio), soit de manière relative avec l’option -l : -l 60%VG pour utiliser 60% de l’espace total du groupe de volumes, ou encore -l 100%FREE pour utiliser la totalité de l’espace libre.

Pour créer un volume logique :

```bash
sudo lvcreate -l 100%FREE -n lvData vg00
```

Pour vérifier la création du volume logique :

```bash
lvdisplay
```


### **6.**


Dans ce volume logique, on créer une partition que vous qu'on va formater en ext4, puis procéder comme dans l’exercice 1 pour qu’elle soit montée automatiquement, au démarrage de la machine, dans /data.
> A ce stade, l’utilité de LVM peut paraître limitée. Il trouve tout son intérêt quand on veut par exemple agrandir une partition à l’aide d’un nouveau disque

Pour formater la partition dans le volume logique en ext4, on utilise la commande :

```bash
mkfs.ext4 /dev/vg00/lvData
```

Pour monter la partition dans /data au démarrage de la machine, on ajoute la ligne suivante dans le fichier /etc/fstab :

```bash
/dev/vg00/lvData /data ext4 defaults 0 0
```


### **7.**

A présent, on éteint la VM pour ajouter un second disque. On redémarre la VM, et on vérifie que le disque est bien présent. Puis, on répete les questions 2 et 3 sur ce nouveau disque.


### **8.**


Pour ajouter un nouveau disque au groupe de volumes, on utilise la commande suivante :

```bash
vgextend vg01 /dev/<nom_partition_nouveau_disque>
```


### **9.**


Pour agrandir le volume logique, on utilise la commande lvresize (ou lvextend). Enfin, il ne faut pas oublier de redimensionner le système de fichiers à l’aide de la commande resize2fs.

Pour agrandir le volume logique, utilisez la commande suivante :
```bash
lvresize -l +100%FREE /dev/vg01/lvData 
```

Pour redimensionner le système de fichiers :
```bash
resize2fs /dev/vg01/lvData
```

