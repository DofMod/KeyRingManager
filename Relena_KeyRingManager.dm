<?xml version="1.0" ?><module>

	<header>
		<name>KeyRingManager</name>
		<version>1.0</version>
		<dofusVersion>2.11</dofusVersion>
		<author>Relena</author>
		<shortDescription>A new interface to manage the 'Bunch of keys'</shortDescription>
		<description>A new interface to manage the 'Bunch of keys'</description>
	</header>

	<!-- Liste des interfaces du module, avec nom de l'interface, nom du fichier squelette .xml et nom de la classe script d'interface -->
	<uis>
		<ui class="ui::KeyRingUi" file="xml/KeyRingUi.xml" name="keyringui"/>
		<ui class="ui::KeyRingConfig" file="xml/KeyRingConfig.xml" name="keyringconfig"/>
	</uis>

	<shortcuts>shortcuts.xml</shortcuts>
	<script>KeyRingManager.swf</script>
</module>