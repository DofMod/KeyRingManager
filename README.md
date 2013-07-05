KeyRingManager
==============

By *Relena*

Ce module à pour but d'augmenter la visibilité des clef du trousseau, en affichant leur date de réapparition.

!["Interface du module"](http://img607.imageshack.us/img607/6034/image1lid.png "Interface du module")
!["Interface du module sous le thème black"](http://img202.imageshack.us/img202/2544/image2td.png "Interface du module sous le thème black")

Une vidéo de présentation du module est visualisable sur la chaine Youtube [DofusModules](https://www.youtube.com/user/dofusModules "Youtube, DofusModules"):

[Lien vers la vidéo](https://www.youtube.com/watch?v=M6ORLW1s28k "Vidéo de présentation du module")

Download + Compile:
-------------------

1. Install Git
2. git clone https://github.com/Dofus/KeyRingManager.git
3. mxmlc -output KeyRingManager.swf -compiler.library-path+=./modules-library.swc -source-path src -keep-as3-metadata Api Module DevMode -- src/KeyRingManager.as

Installation:
-------------

1. Create a new *KeyRingManager* folder in the *ui* folder present in your Dofus instalation folder. (i.e. *ui/KeyRingManager*)
2. Copy the following files in this new folder:
    * xml/
    * shortcuts.xml
    * KeyRingManager.swf
    * Relena_KeyRingManager.dm
    * icon.png
3. Launch Dofus
4. Enable the module in your config menu.
5. Restart Dofus.
6. ...
7. Profit!

