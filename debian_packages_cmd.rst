=========================================================
Commandes utiles pour l'administration des paquets Debian
=========================================================

.. raw:: latex

    \newpage

.. Conventions typographiques de ce document sont calquées sur
.. https://wiki.debian.org/fr/AptTools et https://wiki.debian.org/fr/AptCLI

Ce document liste quelques commandes utiles pour l'administration des paquets
Debian.
Ces commandes s'appliquent aux système Gnu/Linux Debian_ et à ses dérivés tels
qu'Ubuntu_, `Linux Mint`_ ou encore Raspbian_ [#]_.

Les commandes de base sont brièvement décrites dans la première partie de
l'article. La seconde partie présente des commandes plus "avancées".

.. Prérequis: suppose que vous connaissez les bases
.. Le but de ce ... n'est pas de présenter les bases de l'administration de
.. paquets Debian mais de fournir quelques commandes "avancées"

Avant-propos
============

Les morceaux de texte écrits en police à espacement fixe comme

::

    apt-cache search <motif>

ou

::

    sudo apt-get install <paquets>

doivent être tapés dans un terminal_; 
``<paquet>`` doit être remplacé par le nom d'un paquet (par exemple ``vlc``),
``<paquets>`` par le nom d'un ou plusieurs paquets (séparés par des espaces) et
``<motif>`` par un motif de recherche (par exemple un simple terme tel que
``python`` ou une `expression régulière`_ telle que ``^lib.*``).
Les commandes préfixées par le mot ``sudo`` sont uniquement accessibles en mode
administrateur_.


Rappel des commandes de base
============================

Rechercher le nom d'un paquet
-----------------------------

La plupart du temps, on ne connait pas le nom exacte du paquet que l'on souhaite
installer ou supprimer.
Heureusement il est souvent facile de retrouver le nom d'un paquet à partir de
mots clés grâce à l'outil de recherche ``apt-cache search``.

On peut ainsi afficher la liste des paquets contenant un mot clé donné dans
leur nom avec la commande::

    apt-cache search -n <motif>

Par exemple, si je veux installer la bibliothèque ``numpy`` pour Python3 sur un
système Debian 8, je sais avec à la commande::

    apt-cache search -n numpy

que le paquet à installer s'appelle ``python3-numpy``.

On peut aussi supprimer l'option ``-n`` pour étendre la recherche du motif à la
description des paquets.
Par exemple, pour chercher tous les paquets contenant le mot *mp3* dans leur
nom ou leur champ de description, on utilise la commande::

    apt-cache search mp3

La liste retournée est probablement trop longue pour être vraiment utile. Dans ce cas, on peut
affiner la recherche en utilisant plusieurs mots clés::

    apt-cache search mp3 encoder

ou en utilisant des motifs plus sophistiqués tels que::

    apt-cache search ^lib.*mp3

Dans le dernier exemple, ``^lib.*mp3`` est ce qu'on appelle une *expression
régulière* (ou *expression rationnelle*). La présentation des expressions
régulières dépasse le cadre de cet article.
Pour en savoir plus, je vous invite à consulter
`l'article correspondant sur wikipedia<https://fr.wikipedia.org/wiki/Expression_rationnelle>`_
ainsi que les livres *Expressions régulières, le guide de survie* de Bernard
Desgraupes aux éditions Pearson et *Les expressions régulières par l'exemple*
de Vincent Fourmond aux éditions H&K.

.. Avant d'effectuer une recherche dans la liste des paquets disponibles, il est
.. recommandé de mettre à jours cette liste avec la commande::
.. 
..     sudo apt-get update


Afficher les informations disponibles sur un paquet
---------------------------------------------------

On peut afficher les informations relatives à un paquet (version, taille,
description, auteurs, dépendances, etc.) avec::

    apt-cache show <paquets>

Par exemple::

    apt-cache show vlc


Installer un ou plusieurs paquets
---------------------------------

Avant d'installer un paquet, il est recommandé de mettre à jours la liste des
paquets disponibles avec la commande::

    sudo apt-get update

On installe ensuite un ou plusieurs paquets avec::

    sudo apt-get install <paquets>

Par exemple, pour installer VLC_::

    sudo apt-get install vlc

Pour installer VLC_ et `Libre Office`_::

    sudo apt-get install vlc libreoffice


Supprimer un ou plusieurs paquets
---------------------------------

On peut supprimer un ou plusieurs paquets avec::

    sudo apt-get remove <paquets>

La suppression d'un paquet avec ``apt-get remove`` laisse ses fichiers de
configuration sur le système.

Pour supprimer un paquet et les fichiers de configuration qu'il a généré, tapez::

    sudo apt-get purge <paquets>

ou

::

    sudo apt-get remove --purge <paquets>

Pour supprimer les dépendances paquet devenues inutiles sur le système (i.e.
utilisées par aucun autre paquet installé), utilisez la commande::

    sudo apt-get autoremove

ou dans la commande ``apt-get remove``::

    sudo apt-get remove --auto-remove <paquets>


Mettre à jour tous les paquets du système
-----------------------------------------

Les paquets sont régulièrement mis à jours pour corriger d'éventuels bugs ou
failles de sécurités. La commande ``apt-get upgrade`` permet d'appliquer toutes
les mises à jours disponibles pour les paquets installés sur le système::

    sudo apt-get update
    sudo apt-get upgrade

Comme pour ``apt-get install``, il est recommandé de mettre à jours la liste
des paquets disponibles au préalable avec ``apt-get update``.


Nettoyer le cache d'apt
-----------------------

Lorsque l'on utilise les commandes ``apt``, des fichier temporaires plus ou
moins volumineux sont parfois créés.
Ces fichiers peuvent être supprimés sans problème avec la commande::

    sudo apt-get clean


La commande ``aptitude`` 
------------------------

La commande aptitude_ est une alternative efficace [#]_ aux commandes ``apt``.
Elle est installée par défaut sur Debian mais pas sur Ubuntu.
Vous pouvez l'installer avec la commande suivante::

    sudo apt-get install <paquets>

Le tableau qui suit résume les principales équivalences entre les commandes
``apt`` et ``aptitude``.

=================================  ==========================
**apt-get**                        **aptitude**
=================================  ==========================
apt-get update                     aptitude update
apt-get upgrade                    aptitude safe-upgrade
apt-get install <paquets>          aptitude install <paquets>
apt-get remove <paquets>           aptitude remove <paquets>
apt-get remove --purge <paquets>   aptitude purge <paquets>
apt-get clean                      aptitude clean
apt-cache search <motif>           aptitude search <motif>
apt-cache show <paquets>           aptitude show <paquets>
=================================  ==========================


Commandes plus "avancées"
=========================

Télécharger un paquet sans l'installer
--------------------------------------

On peut télécharger un paquet Debian sans l'installer avec ``apt-get``::

    apt-get download <paquet>

ou avec ``aptitude``::

    aptitude download <paquet>

Le paquet téléchargé est placé dans le répertoire courant (fichier ``.deb``).


Extraire le contenu d'un paquet téléchargé
------------------------------------------

Pour extraire le contenu d'un fichier ``.deb`` (téléchargé avec ``apt-get
download`` ou ``aptitude download``), tapez::

    ar -x <paquet.deb>


Télécharger le code source d'un paquet
--------------------------------------

On peut très facilement étudier le code source de n'importe quel paquet Debian
à l'aide de la commande suivante::

    apt-get source <paquet>

Le code source est placé dans le répertoire courant.

Il n'existe pas d'équivalent à cette commande pour aptitude.


Découvrir à quel paquet appartient un fichier installé sur le système
---------------------------------------------------------------------

On peut retrouver le nom du paquet qui a installé un fichier présent sur le
système avec::

    dpkg -S /usr/bin/vlc

Par exemple::

    dpkg -S /usr/bin/vlc


Pour découvrir directement à quel paquet appartient une commande du système,
tapez::

    dpkg -S $( which <commande> )

Par exemple::

    dpkg -S $( which vlc )


Afficher la liste des fichiers installés par un paquet
------------------------------------------------------

On peut afficher la liste des fichiers installés par un paquet avec::

    dpkg -L <paquet>


La commande apt-file
--------------------

Les commandes ``dpkg -L`` et ``dpkg -S`` ne tiennent compte que des paquets
déjà installés sur le système.

Dans certains cas il peut être utile d'effectuer ces recherches sur l'ensemble
des paquets disponibles et non pas seulement sur les paquets installés. C'est
ce que permet la commande ``apt-file``.

On peut installer ``apt-file`` et mettre à jours sa base de données avec::

    sudo apt-get install apt-file
    apt-file update

On peut ensuite découvrir à quel paquet appartiendrait un fichier installé sur
le système avec::

    apt-file search -F <paquets>

et afficher la liste des fichiers qui seraient installés par un paquet avec::

    apt-file list -F <paquets>

``apt-file`` nécessite d'être mis à jours régulièrement avec ``apt-file
update`` pour tenir compte des modifications opérées sur les dépôts de paquets.


Lister les paquets installés triés par taille croissante [TODO]
---------------------------------------------------------------

::

    dpkg-query -Wf '${Installed-Size}\t${Package}\n' | sort -n

Ou avec wajig (``sudo apt-get install wajig``)::

    wajig large


Générer une liste des paquets installés sur le système [TODO]
-------------------------------------------------------------

::

    dpkg -l

::

    dpkg --get-selections > LIST_FILE

::

    dpkg --set-selections < LIST_FILE
    ...



Afficher la liste des dépendances d'un paquet [TODO]
----------------------------------------------------

::

    apt-cache dotty apache2 | dot -T png | display


Supprimer le serveur X et toutes ses dépendances [TODO]
-------------------------------------------------------

::

    sudo apt-get remove --auto-remove --purge "libx11-.*"


Apt-rdepends [TODO]
-------------------

...


Deborphan [TODO]
----------------

...


Convertir un paquet RPM en paquet Debian [TODO]
-----------------------------------------------

::

    alien -d <paquet.rpm>


.. Lister les priorités [TODO]
.. ---------------------------
.. 
.. .. apt-get purge $(aptitude search '~i!~M!~prequired!~pimportant!~R~prequired!~R~R~prequired!~R~pimportant!~R~R~pimportant!busybox!grub!initramfs-tools' | awk '{print $2}')
.. .. 
.. .. You could also do more and see which packages that you have installed are not important nor required:
.. .. 
.. .. aptitude search '?and(~i, !~pimportant, !~prequired)'
.. .. 
.. .. (the above search means: search for installed package that are not important nor required)
.. 
.. Qu'est-ce que les priorités ? \url{http://www.debian.org/doc/debian-policy/ch-archive.html#s-priorities}
.. 
.. ::
.. 
..     aptitude search '~pstandard'
.. 
..     aptitude search '~pimportant'
.. 
..     aptitude search '~prequired'
.. 
..     aptitude search '?essential'
..     aptitude search '~E'


À lire également
================

La documentation de référence: http://www.debian.org/doc/manuals/debian-reference/ch02.fr.html


License
=======


|Licence Creative Commons|_

*Commandes utiles pour l'administration des paquets Debian* de `Jérémie Decock`_ est mis à
disposition selon les termes de la `licence Creative Commons Attribution - Partage dans les Mêmes Conditions 4.0 International`_. 


.. [#] Le système officiel du RaspberryPi_.
.. [#] ``aptitude`` est notamment réputé mieux gérer les conflits de
       dépendances qu'``apt``.

.. _Debian: https://www.debian.org/
.. _Ubuntu: http://www.ubuntu.com/
.. _Linux Mint: http://www.linuxmint.com/
.. _Raspbian: https://www.raspberrypi.org/downloads/raspbian/
.. _RaspberryPi: https://www.raspberrypi.org/
.. _terminal: https://wiki.debian.org/fr/terminal
.. _référence: http://www.debian.org/doc/manuals/debian-reference/ch02.fr.html
.. _administrateur: http://doc.ubuntu-fr.org/sudo
.. _expression régulière: https://fr.wikipedia.org/wiki/Expression_rationnelle
.. _aptitude: https://wiki.debian.org/fr/Aptitude
.. _VLC: http://www.videolan.org/vlc/
.. _Libre Office: https://fr.libreoffice.org/
.. _Jérémie Decock: http://www.jdhp.org/
.. _licence Creative Commons Attribution - Partage dans les Mêmes Conditions 4.0 International: http://creativecommons.org/licenses/by-sa/4.0/

.. |Licence Creative Commons| image:: https://i.creativecommons.org/l/by-sa/4.0/80x15.png
.. _Licence Creative Commons: http://creativecommons.org/licenses/by-sa/4.0/

