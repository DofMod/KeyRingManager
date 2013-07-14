package
{
	import d2api.DataApi;
	import d2api.FileApi;
	import d2api.StorageApi;
	import d2api.SystemApi;
	import d2api.TimeApi;
	import d2api.UiApi;
	import d2data.ContextMenuData;
	import d2data.EffectInstance;
	import d2data.EffectInstanceInteger;
	import d2data.Item;
	import d2data.ItemWrapper;
	import d2enums.LanguageEnum;
	import d2hooks.InventoryContent;
	import d2hooks.ObjectModified;
	import d2hooks.OpeningContextMenu;
	import enums.EffectIdEnum;
	import enums.ItemIdEnum;
	import enums.ItemTypeIdEnum;
	import enums.MenuMakerEnum;
	import enums.ViewContentEnum;
	import flash.display.Sprite;
	import flash.utils.Dictionary;
	import flash.utils.getQualifiedClassName;
	import managers.LangManager;
	import types.DataKey;
	import ui.KeyRingConfig;
	import ui.KeyRingUi;
	import utils.KeyUtils;
	
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
		public var sysApi:SystemApi;
		public var uiApi:UiApi;
		public var dataApi:DataApi;
		public var timeApi:TimeApi;
		public var storageApi:StorageApi;
		public var fileApi:FileApi;
		
		// Modules
		[Module(name="Ankama_ContextMenu")]
		public var modContextMenu:Object;
		
		[Module(name="Ankama_Common")]
		public var modCommon:Object;
		
		// Constants
		private static const WEEKTIME:Number = 1000 * 60 * 60 * 24 * 7;
		private static const CONFIG_PREFIX:String = "key_";
		private static const KEYRINGUI:String = "keyringui";
		private static const OPEN_SHORTCUT:String = "openKeyringManager";
		
		// Properties
		private var _langManager:LangManager;
		private var _keyringInit:Boolean;
		private var _keyring:ItemWrapper;
		private var _keyringKeys:Dictionary;
		
		//::////////////////////////////////////////////////////////////////////
		//::// Public Methods
		//::////////////////////////////////////////////////////////////////////
		
		public function main():void
		{
			init();
			initKeyring(storageApi.getViewContent(ViewContentEnum.STORAGE_QUEST));
			
			sysApi.addHook(InventoryContent, onInventoryContent);
			sysApi.addHook(OpeningContextMenu, onOpeningContextMenu);
			sysApi.addHook(ObjectModified, onObjectModified);
			
			uiApi.addShortcutHook(OPEN_SHORTCUT, onShortcut);
			
			modCommon.addOptionItem("module_keyring", "(M) Keyring", "Options du module KeyringManager", "KeyRingManager::keyringconfig");
		}
		
		//::////////////////////////////////////////////////////////////////////
		//::// Private Methods
		//::////////////////////////////////////////////////////////////////////
		
		private function init():void
		{
			_langManager = new LangManager(sysApi, fileApi, sysApi.getCurrentLanguage());
			
			_keyringInit = false;
			_keyring = null;
			_keyringKeys = new Dictionary();
		}
		
		private function appToItemModule(data:ContextMenuData, ... items):void
		{
			var itemModule:* = null;
			
			for each (var item:* in data.content)
			{
				if (getQualifiedClassName(item) == "contextMenu::ContextMenuItem")
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
				itemModule = modContextMenu.createContextMenuItemObject("Modules", // Item label
					null, // No callback
					null, // No callback arguments
					false, // Item enable
					new Array()); // Create empty subitems list
				data.content.push(itemModule);
			}
			
			itemModule.child = itemModule.child.concat(items);
		}
		
		private function openCloseUI():void
		{
			if (uiApi.getUi(KEYRINGUI) == null)
			{
				var params:Object = new Object();
				params.langManager = _langManager;
				params.keyring = _keyring;
				params.keyringKeys = _keyringKeys;
				
				uiApi.loadUi(KEYRINGUI, KEYRINGUI, params);
			}
			else
			{
				uiApi.unloadUi(KEYRINGUI);
			}
		}
		
		private function findKeyring(items:Object):ItemWrapper
		{
			for each (var item:ItemWrapper in items)
			{
				if (item.objectGID == ItemIdEnum.KEYRING)
				{
					return item;
				}
			}
			
			return null;
		}
		
		//::////////////////////////////////////////////////////////////////////
		//::// Events
		//::////////////////////////////////////////////////////////////////////
		
		private function onShortcut(name:String):Boolean
		{
			if (name == OPEN_SHORTCUT)
			{
				openCloseUI();
				
				return true;
			}
			
			return false;
		}
		
		private function onObjectModified(item:ItemWrapper):void
		{
			if (item.objectGID != ItemIdEnum.KEYRING)
			{
				return;
			}
			
			for (var idString:String in _keyringKeys)
			{
				var id:int = int(idString);
				
				var keyFound:Boolean = false;
				for each (var effect:EffectInstance in item.effects)
				{
					if (effect.effectId == EffectIdEnum.KEY)
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
						_keyringKeys[idString].time += WEEKTIME;
						_keyringKeys[idString].valid = true;
						_keyringKeys[idString].present = true;
						
						sysApi.setData(CONFIG_PREFIX + idString, _keyringKeys[idString]);
					}
					
					continue;
				}
				
				if (_keyringKeys[idString].present == true)
				{
					_keyringKeys[idString].time = timeApi.getTimestamp();
					_keyringKeys[idString].valid = true;
					_keyringKeys[idString].present = false;
					
					sysApi.setData(CONFIG_PREFIX + idString, _keyringKeys[idString]);
				}
			}
		}
		
		private function onOpeningContextMenu(data:Object):void
		{
			if (data && (data is ContextMenuData))
			{
				var menuData:ContextMenuData = data as ContextMenuData;
				if (menuData.makerName == MenuMakerEnum.WORLD)
				{
					var newItem1:* = modContextMenu.createContextMenuItemObject("Keyring manager", // Item label
						openCloseUI, // Callback
						null, // Callback args
						false, // Is disabled ?
						null, // Children
						(uiApi.getUi(KEYRINGUI) != null)); // Is checked ?
					
					appToItemModule(menuData, newItem1);
				}
			}
		}
		
		private function onInventoryContent(items:Object, kamas:int):void
		{
			initKeyring(items);
		}
		
		private function initKeyring(items:Object):void
		{
			if (_keyringInit == true)
			{
				return;
			}
			
			_keyring = findKeyring(items);
			
			if (_keyring == null)
			{
				return;
			}
			
			_keyringInit = true;
			
			var keysId:Object = dataApi.queryEquals(Item, "typeId", ItemTypeIdEnum.KEY);
			var timestamp:Number = timeApi.getTimestamp();
			var dataKey:DataKey = null;
			var dataKeySave:Object = null;
			
			for each (var keyId:int in keysId)
			{
				if (KeyUtils.cantBeOnKeyring(keyId))
				{
					continue;
				}
				
				var keyFound:Boolean = false;
				for each (var effect:EffectInstance in _keyring.effects)
				{
					if (effect.effectId == EffectIdEnum.KEY)
					{
						if ((effect as EffectInstanceInteger).value == keyId)
						{
							keyFound = true;
							
							break;
						}
					}
				}
				
				dataKeySave = sysApi.getData(CONFIG_PREFIX + keyId);
				
				// The key is unknow, save a new timestamp
				if (dataKeySave == null)
				{
					dataKey = new DataKey(keyId, timestamp, false, keyFound);
					
					sysApi.setData(CONFIG_PREFIX + keyId, dataKey);
					
					_keyringKeys[keyId] = dataKey;
					
					continue;
				}
				else
				{
					dataKey = new DataKey(keyId, dataKeySave.time, dataKeySave.valid, dataKeySave.present);
				}
				
				if (dataKey.present == true)
				{
					if (keyFound == false)
					{
						dataKey.time = timestamp;
						dataKey.valid = false;
						dataKey.present = false;
						
						sysApi.setData(CONFIG_PREFIX + keyId, dataKey);
					}
					
					_keyringKeys[keyId] = dataKey;
					
					continue
				}
				
				if (keyFound == true)
				{
					if (dataKey.valid == true)
					{
						dataKey.time += WEEKTIME;
					}
					else
					{
						dataKey.time == timestamp;
					}
					
					dataKey.present = true;
					
					sysApi.setData(CONFIG_PREFIX + keyId, dataKey);
				}
				else if (dataKey.time + WEEKTIME < timestamp)
				{
					dataKey.time = timestamp;
					dataKey.valid = false;
					dataKey.present = false;
					
					sysApi.setData(CONFIG_PREFIX + keyId, dataKey);
				}
				
				_keyringKeys[keyId] = dataKey;
			}
			
			// Debug
			for each (var e:EffectInstance in _keyring.effects)
			{
				if (e.effectId == EffectIdEnum.KEY)
				{
					var effectValue:int = (e as EffectInstanceInteger).value;
					if (_keyringKeys[effectValue] === undefined)
					{
						sysApi.log(4, "[KeyRingManager] Unknow key : " + effectValue);
					}
				}
			}
		}
	}
}
