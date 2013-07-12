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
	import ui.KeyRingConfig;
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
		private static var linkages:Array = [KeyRingUi, KeyRingConfig];
		
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
		private var _keyring : ItemWrapper;
		private var _keyringKeys : Dictionary;
				
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
			
			modCommon.addOptionItem("module_keyring", "(M) Keyring", "Options du module KeyringManager", "KeyRingManager::keyringconfig");
		}
		
		//::////////////////////////////////////////////////////////////////////
		//::// Private Methods
		//::////////////////////////////////////////////////////////////////////
		
		private function init() : void
		{
			_keyring = null;

			// inits the keys
			_keyringKeys = new Dictionary();
			_keyringKeys[1568] = null;
			_keyringKeys[1569] = null;
			_keyringKeys[1570] = null;
			_keyringKeys[6884] = null;
			_keyringKeys[7309] = null;
			_keyringKeys[7310] = null;
			_keyringKeys[7311] = null;
			_keyringKeys[7312] = null;
			_keyringKeys[7511] = null;
			_keyringKeys[7557] = null;
			_keyringKeys[7908] = null;
			_keyringKeys[7918] = null;
			_keyringKeys[7924] = null;
			_keyringKeys[7926] = null;
			_keyringKeys[7927] = null;
			_keyringKeys[8073] = null;
			_keyringKeys[8135] = null;
			_keyringKeys[8139] = null;
			_keyringKeys[8142] = null;
			_keyringKeys[8143] = null;
			_keyringKeys[8156] = null;
			_keyringKeys[8307] = null;
			_keyringKeys[8342] = null;
			_keyringKeys[8343] = null;
			_keyringKeys[8436] = null;
			_keyringKeys[8437] = null;
			_keyringKeys[8438] = null;
			_keyringKeys[8439] = null;
			_keyringKeys[8545] = null;
			_keyringKeys[8917] = null;
			_keyringKeys[8972] = null;
			_keyringKeys[8977] = null;
			_keyringKeys[9247] = null;
			_keyringKeys[9248] = null;
			_keyringKeys[9254] = null;
			_keyringKeys[8320] = null;
			_keyringKeys[8329] = null;
			_keyringKeys[8971] = null;
			_keyringKeys[8975] = null;
			_keyringKeys[8432] = null;
			_keyringKeys[11175] = null;
			_keyringKeys[11174] = null;
			_keyringKeys[11176] = null;
			_keyringKeys[11177] = null;
			_keyringKeys[11178] = null;
			_keyringKeys[11179] = null;
			_keyringKeys[11180] = null;
			_keyringKeys[11181] = null;
			_keyringKeys[11798] = null;
			_keyringKeys[11799] = null;
			_keyringKeys[12017] = null;
			_keyringKeys[12073] = null;
			_keyringKeys[12152] = null;
			_keyringKeys[12151] = null;
			_keyringKeys[12150] = null;
			_keyringKeys[12351] = null;
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
				params.keyring = _keyring;
				params.keyringKeys = _keyringKeys;
				
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
			}
			else
			{
				traceDofus("modification du trousseau");
			}
			
			for (var idString:String in _keyringKeys)
			{
				var id:int = int(idString);
				
				var keyFound:Boolean = false;
				for each (var effect:EffectInstance in item.effects)
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
					
				if (keyFound == true)
				{
					if (_keyringKeys[idString].present == false)
					{
						traceDofus("clef a reaparu: " + idString);
						
						_keyringKeys[idString].time += WEEKTIME;
						_keyringKeys[idString].valid = true;
						_keyringKeys[idString].present = true;
						
						sysApi.setData("key" + idString, _keyringKeys[idString]);
					}
					
					continue;
				}
				
				if (_keyringKeys[idString].present == true)
				{
					traceDofus("clef supprimé: " + idString);
					
					_keyringKeys[idString].time = timeApi.getTimestamp();
					_keyringKeys[idString].valid = true;
					_keyringKeys[idString].present = false;
					
					sysApi.setData("key" + idString, _keyringKeys[idString]);
				}
			}
		}
		
		private function onOpeningContextMenu(data:Object) : void
		{
			if(data && (data is ContextMenuData))
			{
				var menuData:ContextMenuData = data as ContextMenuData;
				if(menuData.makerName == "world")
				{
					var newItem1:* = modContextMenu.createContextMenuItemObject(
							"Keyring manager",					// Item label
							openCloseUI,						// Callback
							null,								// Callback args
							false,								// Is disabled ?
							null,								// Children
							(uiApi.getUi(KEYRINGUI) != null));	// Is checked ?
					
					appToItemModule(menuData, newItem1);
				}
			}
		}
		
		private function onInventoryContent(items:Object, kamas:int) : void
		{
			if (_keyring == null)
			{
				_keyring = findKeyring(items);
				
				if (_keyring != null)
				{
					var timestamp : Number = timeApi.getTimestamp();
					var value : Object;
					var id : int;
					for (var idString:String in _keyringKeys)
					{
						id = int(idString);
						
						var keyFound : Boolean = false;
						for each(var effect:EffectInstance in _keyring.effects)
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
							
							_keyringKeys[idString] = value;
							
							printObj(id, value);
							
							continue;
						}
						else
						{
							printObj(id, value);
						}
						
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
							
							_keyringKeys[idString] = value;
							
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
						
						_keyringKeys[idString] = value;
					}
				}
			}
			
			// Debug
			if (_keyring != null)
			{
				for each (var e:EffectInstance in _keyring.effects)
				{
					if (e is EffectInstanceInteger)
					{
						var eInt:EffectInstanceInteger =
								e as EffectInstanceInteger;
						if (_keyringKeys[eInt.value] === undefined)
						{
							sysApi.log(2, "!!!New keys : " + eInt.value + " / " + _keyringKeys[eInt.value]);
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
