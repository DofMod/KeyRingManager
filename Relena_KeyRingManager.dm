<module>

    <!-- Information sur le module -->
    <header>
        <!-- Nom affiché dans la liste des modules -->
        <name>Keyring manager</name>
        <!-- Version du module -->
        <version>0.1</version>
        <!-- Dernière version de dofus pour laquelle ce module fonctionne -->
        <dofusVersion>2.3.3</dofusVersion>
        <!-- Auteur du module -->
        <author>Relena</author>
        <!-- Courte description -->
        <shortDescription>Gerez votre trousseau de clef.</shortDescription>
        <!-- Description détaillée -->
        <description>Ce module vous permet de savoir quand on été utilise les clef de votre trousseau.</description>
		<icon>icon.png</icon>
	</header>

    <!-- Liste des interfaces du module, avec nom de l'interface, nom du fichier squelette .xml et nom de la classe script d'interface -->
    <uis>
        <ui name="keyringui" file="xml/KeyRingUi.xml" class="ui::KeyRingUi" />
		<ui name="keyringconfig" file="xml/KeyRingConfig.xml" class="ui::KeyRingConfig" />
    </uis>
	
    <shortcuts>shortcuts.xml</shortcuts>
    <script>KeyRingManager.swf</script>

</module>
