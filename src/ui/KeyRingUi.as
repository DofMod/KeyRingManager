package ui
{
	import d2api.DataApi;
	import d2api.SystemApi;
	import d2api.TimeApi;
	import d2api.UiApi;
	import d2components.ButtonContainer;
	import d2components.GraphicContainer;
	import d2components.Grid;
	import d2data.ItemWrapper;
	import d2enums.ComponentHookList;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	import utils.KeyUtils;
	
	/**
	 * @author Relena
	 */
	public class KeyRingUi
	{
		//::////////////////////////////////////////////////////////////////////
		//::// Properties
		//::////////////////////////////////////////////////////////////////////
		
		// APIs
		public var sysApi:SystemApi
		public var uiApi:UiApi;
		public var dataApi:DataApi;
		public var timeApi:TimeApi;
		
		// Components
		public var btn_close:ButtonContainer;
		public var btn_config:ButtonContainer;
		public var grid_keys:Grid;
		public var ctn_grid:GraphicContainer;
		public var ctn_main:GraphicContainer;
		public var ctn_nokeyring:GraphicContainer;
		
		[Module(name="Ankama_Common")]
		public var modCommon:Object;
		
		// Constants
		private static const MINUTETIME:Number = 1000 * 60;
		private static const HOURTIME:Number = MINUTETIME * 60;
		private static const DAYTIME:Number = HOURTIME * 24;
		private static const WEEKTIME:Number = DAYTIME * 7;
		private static const BANNER_HEIGHT:int = 160;
		
		// Proterties
		private var _ctn_empty:String;
		private var _ctn_title:String;
		private var _ctn_key:String;
		private var _keyring:ItemWrapper;
		private var _keyringKeys:Dictionary;
		
		//::////////////////////////////////////////////////////////////////////
		//::// Public Methods
		//::////////////////////////////////////////////////////////////////////
		
		public function main(params:Object):void
		{
			_ctn_empty = uiApi.me().getConstant("emptyName");
			_ctn_title = uiApi.me().getConstant("titleName");
			_ctn_key = uiApi.me().getConstant("keyName");
			
			_keyring = params.keyring;
			_keyringKeys = params.keyringKeys;
			
			initGrid(_keyring, _keyringKeys);
			
			uiApi.addShortcutHook("closeUi", onShortcut);
			
			uiApi.addComponentHook(ctn_main, ComponentHookList.ON_PRESS);
			uiApi.addComponentHook(btn_close, ComponentHookList.ON_PRESS);
			uiApi.addComponentHook(btn_config, ComponentHookList.ON_PRESS);
			
			uiApi.addComponentHook(ctn_main, ComponentHookList.ON_RELEASE);
			uiApi.addComponentHook(btn_close, ComponentHookList.ON_RELEASE);
			uiApi.addComponentHook(btn_config, ComponentHookList.ON_RELEASE);
			
			uiApi.addComponentHook(ctn_main, ComponentHookList.ON_RELEASE_OUTSIDE);
		}
		
		/**
		 * Update grid line.
		 * 
		 * @param	data	Data associated to the grid line.
		 * @param	componentsRef	Link to the components of the grid line.
		 * @param	selected	Is the line selected ?
		 * @param	param4	(no idea what is that)
		 */
		public function updateEntry(data:Object, componentsRef:Object, selected:Boolean, param4:uint) : void
		{
			switch (getLineType(data, param4))
			{
				case _ctn_empty:
					break;
				case _ctn_title:
					componentsRef.lb_title.text = data.label;
					
					break;
				case _ctn_key:
					componentsRef.lb_name.text = data.label;
					
					if (data.dataKey.present == true)
					{
						componentsRef.tx_present.visible = true;
						componentsRef.lb_time.visible = false;
						
						return;
					}
					
					componentsRef.tx_present.visible = false;
					componentsRef.lb_time.visible = true;
					
					componentsRef.lb_time.cssClass = data.dataKey.valid ? "p0" : "p2";
					
					var time:Number = WEEKTIME - (timeApi.getTimestamp() - data.dataKey.time);
					if (time > DAYTIME)
					{
						componentsRef.lb_time.text = (((time - (time % DAYTIME)) + DAYTIME) / DAYTIME) + "jours";
					}
					else if (time > HOURTIME)
					{
						componentsRef.lb_time.text = (((time - (time % HOURTIME)) + HOURTIME) / HOURTIME) + "heurs";
					}
					else if (time > MINUTETIME)
					{
						componentsRef.lb_time.text = (((time - (time % MINUTETIME)) + MINUTETIME) / MINUTETIME) + "minutes";
					}
					else
					{
						componentsRef.lb_time.text = (time % MINUTETIME) + "secondes";
					}
			}
		}
		
		/**
		 * Select the containe to display in the grid line.
		 * 
		 * @param	data	Data of the line (Info).
		 * @param	param2	(no idea what is that).
		 * @return	The name of the container use.
		 */
		public function getLineType(data:Object, param2:uint):String
		{
			if (!data)
			{
				return _ctn_empty;
			}
			else if (data.isTitle)
			{
				return _ctn_title;
			}
			else
			{
				return _ctn_key;
			}
		}
		
		public function unload():void
		{
		}
		
		//::////////////////////////////////////////////////////////////////////
		//::// Private Methods
		//::////////////////////////////////////////////////////////////////////
		
		private function initGrid(keyring:ItemWrapper, keyringKeys:Dictionary, selectedAreaId:int = -1):void
		{
			if (keyring == null)
			{
				ctn_grid.visible = false;
				ctn_nokeyring.visible = true;
				
				return;
			}
			
			var displayedInfos:Array = [];
			for each (var areaId:int in KeyUtils.getDungeonAreas())
			{
				displayedInfos.push(new DisplayInfo(areaId == KeyUtils.NO_AREA ? "Others" : dataApi.getArea(areaId).name));
				
				if (areaId == selectedAreaId)
				{
					for (var keyId:String in keyringKeys)
					{
						if (KeyUtils.getDungeonArea(int(keyId)) == areaId)
						{
							displayedInfos.push(new DisplayInfo(dataApi.getItemWrapper(int(keyId)).name, false, keyringKeys[keyId]));
						}
					}
				}
			}
			
			grid_keys.dataProvider = displayedInfos;
		}
		
		private function dragUiStart():void
		{
			ctn_main.startDrag(
					false,
					new Rectangle(
							0,
							0,
							uiApi.getStageWidth() - this.ctn_main.width,
							uiApi.getStageHeight() - this.ctn_main.height - BANNER_HEIGHT
							)
					);
		}
		
		private function dragUiStop():void
		{
			ctn_main.stopDrag();
		}
		
		//::////////////////////////////////////////////////////////////////////
		//::// Events
		//::////////////////////////////////////////////////////////////////////
		
		private function onShortcut(name:String):Boolean
		{
			if (name == "closeUi")
			{
				uiApi.unloadUi(uiApi.me().name);
				
				return true;
			}
			
			return false;
		}
		
		public function onPress(target:Object):void
		{
			if (target == ctn_main)
			{
				dragUiStart();
			}
		}
		
		public function onRelease(target:Object):void
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
		
		public function onReleaseOutside(target:Object):void
		{
			if (target == ctn_main)
			{
				dragUiStop();
			}
		}
	}
}
import types.DataKey;


class DisplayInfo
{
	public var label:String;
	public var isTitle:Boolean;
	public var dataKey:DataKey;
	
	public function DisplayInfo(label:String, isTitle:Boolean = true, dataKey:DataKey = null)
	{
		this.label = label;
		this.isTitle = isTitle;
		this.dataKey = dataKey;
	}
}