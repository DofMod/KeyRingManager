package ui
{
	import d2api.DataApi;
	import d2api.InventoryApi;
	import d2api.SystemApi;
	import d2api.TimeApi;
	import d2api.UiApi;
	import d2components.ButtonContainer;
	import d2components.GraphicContainer;
	import d2components.Grid;
	import d2components.Label;
	import d2components.TextArea;
	import d2components.Texture;
	import d2data.Effect;
	import d2data.EffectInstance;
	import d2data.EffectInstanceInteger;
	import d2data.EffectsWrapper;
	import d2data.Item;
	import d2data.ItemWrapper;
	import d2enums.ComponentHookList;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	import flash.utils.getQualifiedClassName;
	
	/**
	 * @author Relena
	 */
	public class KeyRingUi
	{
		//::////////////////////////////////////////////////////////////////////
		//::// Properties
		//::////////////////////////////////////////////////////////////////////
		
		// APIs
		public var sysApi : SystemApi
		public var uiApi : UiApi;
		public var inventApi : InventoryApi;
		public var dataApi : DataApi;
		public var timeApi : TimeApi;
		
		// Components
		public var btn_close : ButtonContainer;
		public var btn_config : ButtonContainer;
		public var grid_keys : Grid;
		public var ctn_grid : GraphicContainer;
		public var ctn_main : GraphicContainer;
		public var ctn_nokeyring : GraphicContainer;
		
		[Module (name="Ankama_Common")]
		public var modCommon : Object;
		
		// Constants
		private static const MINUTETIME : Number = 1000 * 60;
		private static const HOURTIME : Number = MINUTETIME * 60;
		private static const DAYTIME : Number = HOURTIME * 24;
		private static const WEEKTIME : Number = DAYTIME * 7;
		
		// Proterties
		
		//::////////////////////////////////////////////////////////////////////
		//::// Public Methods
		//::////////////////////////////////////////////////////////////////////
		
		public function main(params:Object) : void
		{
			var keyring:ItemWrapper = params.keyring;
			var keyringKeys:Dictionary = params.keyringKeys;
			
			uiApi.addComponentHook(ctn_main, ComponentHookList.ON_PRESS);
			uiApi.addComponentHook(btn_close, ComponentHookList.ON_PRESS);
			uiApi.addComponentHook(btn_config, ComponentHookList.ON_PRESS);
			
			uiApi.addComponentHook(ctn_main, ComponentHookList.ON_RELEASE);
			uiApi.addComponentHook(btn_close, ComponentHookList.ON_RELEASE);
			uiApi.addComponentHook(btn_config, ComponentHookList.ON_RELEASE);
			
			uiApi.addComponentHook(ctn_main, ComponentHookList.ON_RELEASE_OUTSIDE);
			
			uiApi.addShortcutHook("closeUi", onShortcut);
			
			if (keyring == null)
			{
				ctn_grid.visible = false;
				ctn_nokeyring.visible = true;
			}
			else
			{
				//var keyring:ItemWrapper = inventApi.getItem(keyring.objectUID);
				var keys:Array = new Array();
				var key:Object;
				for (var keyId:String in keyringKeys)
				{
					key = new Object();
					key.time = keyringKeys[keyId].time;
					key.valid = keyringKeys[keyId].valid;
					key.present = keyringKeys[keyId].present;
					key.name = dataApi.getItemWrapper(int(keyId)).name;
					keys.push(key);
				}
			
				grid_keys.dataProvider = keys;
			}
		}
		
		public function updateEntry(data : *, componentsRef : *, selected : Boolean) : void
		{
			if(data)
			{
				componentsRef.name.text = data.name;
				
				if (data.present == true)
				{
					componentsRef.key_present.visible = true;
					componentsRef.time.visible = false;
				}
				else
				{
					componentsRef.key_present.visible = false;
					componentsRef.time.visible = true;
					
					if(data.valid == false)
					{
						componentsRef.time.cssClass = "p2";
					}
					else
					{
						componentsRef.time.cssClass = "p0";
					}
					
					var time:Number = WEEKTIME - (timeApi.getTimestamp() - data.time);
					if(time > DAYTIME)
					{
						componentsRef.time.text = (((time - (time % DAYTIME)) + DAYTIME) / DAYTIME) + "jours";
					}
					else if (time > HOURTIME)
					{
						componentsRef.time.text = (((time - (time % HOURTIME)) + HOURTIME) / HOURTIME) + "heurs";
					}
					else if (time > MINUTETIME)
					{
						componentsRef.time.text = (((time - (time % MINUTETIME)) + MINUTETIME) / MINUTETIME) + "minutes";
					}
					else
					{
						componentsRef.time.text = (time % MINUTETIME) + "secondes";
					}
				}
			}
			else
			{
				componentsRef.name.text = "Unknow object.";
				
				componentsRef.key_present.visible = false;
				componentsRef.time_good.visible = false;
				componentsRef.time_unknow.visible = true;
				componentsRef.time_unknow.text = "XXX";
			}
		}
		
		public function unload() : void
		{
		}
		
		//::////////////////////////////////////////////////////////////////////
		//::// Private Methods
		//::////////////////////////////////////////////////////////////////////
		
		private function dragUiStart() : void
		{
			ctn_main.startDrag(
					false,
					new Rectangle(
							0,
							0,
							uiApi.getStageWidth() - this.ctn_main.width,
							uiApi.getStageHeight() - this.ctn_main.height - 160)
					);
		}
		
		private function dragUiStop() : void
		{
			ctn_main.stopDrag();
		}
		
		//::////////////////////////////////////////////////////////////////////
		//::// Events
		//::////////////////////////////////////////////////////////////////////
		
		private function onShortcut(name:String) : Boolean
		{
			if (name == "closeUi")
			{
				uiApi.unloadUi(uiApi.me().name);
				
				return true;
			}
			
			return false;
		}
		
		public function onPress(target : Object) : void
		{
			if (target == ctn_main)
			{
				dragUiStart();
			}
		}
		
		public function onRelease(target:Object) : void
		{
			if (target == btn_close)
			{
				uiApi.unloadUi(uiApi.me().name);
			}
			else if (target == btn_config)
			{
				modCommon.openOptionMenu(false, "module_keyring");
			}
			else if (target == ctn_main)
			{
				dragUiStop();
			}
		}
		
		public function onReleaseOutside(target:Object) :  void
		{
			if (target == ctn_main)
			{
				dragUiStop();
			}
		}
	}
}