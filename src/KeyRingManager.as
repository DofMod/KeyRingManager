package {
	import d2api.BindsApi;
	import d2api.InventoryApi;
	import d2api.PlayedCharacterApi;
	import d2api.StorageApi;
	import d2api.SystemApi;
	import d2api.TimeApi;
	import d2api.UiApi;
	import d2data.ContextMenuData;
	import d2data.EffectInstance;
	import d2data.EffectInstanceInteger;
	import d2data.ItemWrapper;
	import d2hooks.InventoryContent;
	import d2hooks.ObjectModified;
	import d2hooks.OpeningContextMenu;
	import flash.display.Sprite;
	import flash.utils.Dictionary;
	import flash.utils.getQualifiedClassName;
	import ui.KeyRingUi;
	
	/**
	 * @author Relena
	 */
	public class KeyRingManager extends Sprite
	{
		//::////////////////////////////////////////////////////////////////////
		//::// Properties
		//::////////////////////////////////////////////////////////////////////
		
		// Include UI
		private static var linkages:Array = [KeyRingUi];
		
		// APIs
		public var sysApi : SystemApi;
		public var uiApi : UiApi;
		public var inventApi : InventoryApi;
		public var playerApi : PlayedCharacterApi;
		public var storageApi : StorageApi;
		public var timeApi : TimeApi;
		public var bindApi : BindsApi;
		
		// Modules
		[Module (name="Ankama_ContextMenu")]
		public var modContextMenu : Object;
		
		[Module (name="Ankama_Common")]
		public var modCommon : Object;
		
		// Constants
		private static const WEEKTIME : Number = 1000 * 60 * 60 * 24 * 7;
		private static const KEYRINGGID : int = 10207;
		private static const KEYRINGUI : String = "keyringui";
		private static const OPEN_SHORTCUT:String = "openKeyringManager";
		
		// Properties
		private var keyring : ItemWrapper;
		private var keyringKeys : Dictionary;
				
		//::////////////////////////////////////////////////////////////////////
		//::// Public Methods
		//::////////////////////////////////////////////////////////////////////
		
		public function main() : void
		{
			init();
			
			sysApi.addHook(InventoryContent, onInventoryContent);
			sysApi.addHook(OpeningContextMenu, onOpeningContextMenu);
			sysApi.addHook(ObjectModified, onObjectModified);
			
			uiApi.addShortcutHook(OPEN_SHORTCUT, onShortcut);
			
			modCommon.addOptionItem("module_keyring", "Module - Keyring manager", "c'est nul et ça sert a rien", "KeyRingManager::keyringconfig");
		}
		
		//::////////////////////////////////////////////////////////////////////
		//::// Private Methods
		//::////////////////////////////////////////////////////////////////////
		
		private function init() : void
		{
			keyring = null;

			// inits the keys
			keyringKeys = new Dictionary();
			keyringKeys[1568] = null;
			keyringKeys[1569] = null;
			keyringKeys[1570] = null;
			keyringKeys[6884] = null;
			keyringKeys[7309] = null;
			keyringKeys[7310] = null;
			keyringKeys[7311] = null;
			keyringKeys[7312] = null;
			keyringKeys[7511] = null;
			keyringKeys[7557] = null;
			keyringKeys[7908] = null;
			keyringKeys[7918] = null;
			keyringKeys[7924] = null;
			keyringKeys[7926] = null;
			keyringKeys[7927] = null;
			keyringKeys[8073] = null;
			keyringKeys[8135] = null;
			keyringKeys[8139] = null;
			keyringKeys[8142] = null;
			keyringKeys[8143] = null;
			keyringKeys[8156] = null;
			keyringKeys[8307] = null;
			keyringKeys[8342] = null;
			keyringKeys[8343] = null;
			keyringKeys[8436] = null;
			keyringKeys[8437] = null;
			keyringKeys[8438] = null;
			keyringKeys[8439] = null;
			keyringKeys[8545] = null;
			keyringKeys[8917] = null;
			keyringKeys[8972] = null;
			keyringKeys[8977] = null;
			keyringKeys[9247] = null;
			keyringKeys[9248] = null;
			keyringKeys[9254] = null;
			keyringKeys[8320] = null;
			keyringKeys[8329] = null;
			keyringKeys[8971] = null;
			keyringKeys[8975] = null;
			keyringKeys[8432] = null;
			keyringKeys[11175] = null;
			keyringKeys[11174] = null;
			keyringKeys[11176] = null;
			keyringKeys[11177] = null;
			keyringKeys[11178] = null;
			keyringKeys[11179] = null;
			keyringKeys[11180] = null;
			keyringKeys[11181] = null;
			keyringKeys[11798] = null;
			keyringKeys[11799] = null;
			keyringKeys[12017] = null;
			keyringKeys[12073] = null;
			keyringKeys[12152] = null;
			keyringKeys[12151] = null;
			keyringKeys[12150] = null;
			keyringKeys[12351] = null;
		}
		
		private function appToItemModule(data:ContextMenuData, ...items) : void
		{
			var itemModule:* = null;
			
			for each(var item:* in data.content)
			{
				if (getQualifiedClassName(item) ==
						"contextMenu::ContextMenuItem")
				{
					if (item.label == "Modules")
					{
						itemModule = item;
						break;
					}
				}
			}
					
			if (itemModule == null)
			{
				itemModule = modContextMenu.createContextMenuItemObject(
						"Modules",  	// Item label
						null,			// No callback
						null,			// No callback arguments
						false,			// Item enable
						new Array());	// Create empty subitems list
				data.content.push(itemModule);
			}
			
			itemModule.child = itemModule.child.concat(items);
		}
		
		private function openCloseUI() : void
		{
			if (uiApi.getUi(KEYRINGUI) == null)
			{
				var params:Object = new Object();
				params.keyring = keyring;
				params.keyringKeys = keyringKeys;
				
				uiApi.loadUi(KEYRINGUI, KEYRINGUI, params);
			}
			else
			{
				uiApi.unloadUi(KEYRINGUI);
			}
		}
		
		private function findKeyring(items:Object) : ItemWrapper
		{
			for each (var item:ItemWrapper in items)
			{
				if (item.objectGID == KEYRINGGID)
				{
					return item;
				}
			}
			
			return null;
		}
		
		//::////////////////////////////////////////////////////////////////////
		//::// Events
		//::////////////////////////////////////////////////////////////////////
		
		private function onShortcut(name:String) : Boolean
		{
			if (name == OPEN_SHORTCUT)
			{
				openCloseUI();
				
				return true;
			}
			
			return false;
		}
		
		private function onObjectModified(item:ItemWrapper) : void
		{
			if (item.objectGID != KEYRINGGID)
			{
				sysApi.log(2, "objec modifier != trousseau");
				return;
			}else {
				traceDofus("modification du trousseau");
			}
			
			for (var idString:String in keyringKeys)
			{
				var id:int = int(idString);
				
				var keyFound:Boolean = false;
				for each (var effect:EffectInstance in item.effects) {
					if (effect is EffectInstanceInteger) {
						if ((effect as EffectInstanceInteger).value == id)
						{
							keyFound = true;
							break;
						}
					}
				}
					
				if (keyFound == true)
				{
					if (keyringKeys[idString].present == false)
					{
						traceDofus("clef a reaparu: " + idString);
						
						keyringKeys[idString].time += WEEKTIME;
						keyringKeys[idString].valid = true;
						keyringKeys[idString].present = true;
						
						sysApi.setData("key" + idString, keyringKeys[idString]);
					}
					
					continue;
				}
				
				if (keyringKeys[idString].present == true)
				{
					traceDofus("clef supprimé: " + idString);
					
					keyringKeys[idString].time = timeApi.getTimestamp();
					keyringKeys[idString].valid = true;
					keyringKeys[idString].present = false;
					
					sysApi.setData("key" + idString, keyringKeys[idString]);
				}
			}
		}
		
		private function onOpeningContextMenu(data:Object) : void
		{
			if(data && !(data is Array))
			{
				if(data.makerName == "world")
				{
					var newItem1:* = modContextMenu.createContextMenuItemObject(
							"Keyring manager",					// Item label
							openCloseUI,						// Callback
							null,								// Callback args
							false,								// Is disabled ?
							null,								// Children
							(uiApi.getUi(KEYRINGUI) != null));	// Is checked ?
					
					appToItemModule(
						(data as ContextMenuData),
						newItem1);
				}
				else
				{
					sysApi.log(2, "makerName : " + data.makerName);
				}
			}
			else
			{
				sysApi.log(2, "Array menu not supported");
			}
		}
		
		private function onInventoryContent(items:Object, kamas:int) : void
		{
			if (keyring == null)
			{
				keyring = findKeyring(items);
				
				if (keyring != null)
				{
					var timestamp : Number = timeApi.getTimestamp();
					var value : Object;
					var id : int;
					for (var idString:String in keyringKeys)
					{
						id = int(idString);
						
						var keyFound : Boolean = false;
						for each(var effect:EffectInstance in keyring.effects)
						{
							if (effect is EffectInstanceInteger)
							{
								if ((effect as EffectInstanceInteger).value == id)
								{
									keyFound = true;
									break;
								}
							}
						}
						
						value = sysApi.getData("key" + idString);
						/*
						 * value : Object
						 * value.time : int        // last time update
						 * value.valid : boolean   // is time value valid ?
						 * value.present : boolean // key present
						 */
						
						if(value == null)
						{
							value = new Object();
							value.time = timestamp;
							value.valid = false;
							value.present = keyFound;
							
							sysApi.setData("key" + idString, value);
							
							keyringKeys[idString] = value;
							
							printObj(id, value);
							
							continue;
						}else
							printObj(id, value);
						
						if (value.present == true)
						{
							if (keyFound == false)
							{
								traceDofus("le module a ete etein");
								value.time = timestamp;
								value.valid = false;
								value.present = false;
							
								sysApi.setData("key" + idString, value);
							}
							
							keyringKeys[idString] = value;
							
							continue
						}
						
						if (keyFound == true)
						{
							traceDofus("la clef deviens valide");
							if (value.valid == true)
							{
								value.time += WEEKTIME;
							}
							else
							{
								value.time == timestamp;
							}
							
							value.present = true;
							
							sysApi.setData("key" + idString, value);
						}
						else if (value.time + WEEKTIME < timestamp)
						{
							traceDofus("update time");
							value.time = timestamp;
							value.valid = false;
							value.present = false;
							
							sysApi.setData("key" + idString, value);
						}
						
						keyringKeys[idString] = value;
					}
				}
			}
			
			// Debug
			if (keyring != null)
			{
				for each (var e:EffectInstance in keyring.effects)
				{
					if (e is EffectInstanceInteger)
					{
						var eInt:EffectInstanceInteger =
								e as EffectInstanceInteger;
						if (keyringKeys[eInt.value] === undefined)
						{
							sysApi.log(2, "!!!New keys : " + eInt.value + " / " + keyringKeys[eInt.value]);
						}
					}
				}
			}
		}
			
		// a supprimer
		
		private function traceDofus(str:String) : void
		{
			sysApi.log(2, str);
		}
		
		private function printObj(val:int, obj:Object):void
		{
			traceDofus("[" + val + "] time: " + obj.time + " valid: " + obj.valid + " present: " + obj.present);
		}
	}
}
