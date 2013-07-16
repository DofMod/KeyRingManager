KeyRingManager
==============

By *Relena*

Ce module à pour but d'augmenter la visibilité des clef du trousseau, en affichant leur date de réapparition.

!["Interface du module"](http://imageshack.us/a/img812/750/crp.png "Interface du module")

!["Interface du module, utilisation du champ de recherche"](http://imageshack.us/a/img855/5485/6sc5.png "Interface du module, utilisation du champ de recherche")

Une vidéo de présentation du module est visualisable sur la chaine Youtube [DofusModules](https://www.youtube.com/user/dofusModules "Youtube, DofusModules"):

[Lien vers la vidéo](https://www.youtube.com/watch?v=M6ORLW1s28k "Vidéo de présentation du module")

Download + Compile:
-------------------

1. Install Git
2. git clone --recursive https://github.com/Dofus/KeyRingManager.git
3. cd KeyRingManager/dmUtils
4. compile library (see README)
5. cd ..
6. mxmlc -output KeyRingManager.swf -compiler.library-path+=./modules-library.swc -compiler.library-path+=./dmUtils/dmUtils.swc -source-path src -keep-as3-metadata Api Module DevMode -- src/KeyRingManager.as

Installation:
-------------

1. Create a new *KeyRingManager* folder in the *ui* folder present in your Dofus instalation folder. (i.e. *ui/KeyRingManager*)
2. Copy the following files in this new folder:
    * xml/
    * lang/
    * shortcuts.xml
    * KeyRingManager.swf
    * Relena_KeyRingManager.dm
    * icon.png
3. Launch Dofus
4. Enable the module in your config menu.
5. Restart Dofus.
6. ...
7. Profit!

