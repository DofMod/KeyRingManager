package ui
{
	import d2api.DataApi;
	import d2api.SystemApi;
	import d2api.TimeApi;
	import d2api.UiApi;
	import d2components.ButtonContainer;
	import d2components.GraphicContainer;
	import d2components.Grid;
	import d2components.Input;
	import d2data.ItemWrapper;
	import d2enums.ComponentHookList;
	import d2enums.LocationEnum;
	import d2hooks.KeyUp;
	import enums.AreaIdEnum;
	import enums.ConfigEnum;
	import enums.LangEnum;
	import flash.events.TimerEvent;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	import flash.utils.Timer;
	import managers.LangManager;
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
		public var btn_resetSearch:ButtonContainer;
		public var inp_search:Input;
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
		private static const DEFAULT_AREA:int = -1;
		
		// Proterties
		private var _langManager:LangManager;
		private var _searchTimer:Timer;
		private var _ctn_empty:String;
		private var _ctn_title:String;
		private var _ctn_key:String;
		private var _keyring:ItemWrapper;
		private var _keyringKeys:Dictionary;
		private var _selectedArea:int;
		
		//::////////////////////////////////////////////////////////////////////
		//::// Public Methods
		//::////////////////////////////////////////////////////////////////////
		
		public function main(params:Object):void
		{
			_searchTimer = new Timer(500, 1);
			_searchTimer.addEventListener(TimerEvent.TIMER_COMPLETE, onTimeOut);
			
			_ctn_empty = uiApi.me().getConstant("emptyName");
			_ctn_title = uiApi.me().getConstant("titleName");
			_ctn_key = uiApi.me().getConstant("keyName");
			
			_langManager = params.langManager;
			_keyring = params.keyring;
			_keyringKeys = params.keyringKeys;
			_selectedArea = DEFAULT_AREA;
			
			var position:Array = sysApi.getData(ConfigEnum.POSITION);
			if (position)
			{
				ctn_main.x = position[0];
				ctn_main.y = position[1];
			}
			
			initGrid(_keyring, _keyringKeys);
			
			uiApi.addShortcutHook("closeUi", onShortcut);
			
			sysApi.addHook(KeyUp, onKeyUp);
			
			uiApi.addComponentHook(ctn_main, ComponentHookList.ON_PRESS);
			uiApi.addComponentHook(btn_close, ComponentHookList.ON_PRESS);
			uiApi.addComponentHook(btn_config, ComponentHookList.ON_PRESS);
			uiApi.addComponentHook(btn_resetSearch, ComponentHookList.ON_PRESS);
			uiApi.addComponentHook(inp_search, ComponentHookList.ON_PRESS);
			
			uiApi.addComponentHook(ctn_main, ComponentHookList.ON_RELEASE);
			uiApi.addComponentHook(btn_close, ComponentHookList.ON_RELEASE);
			uiApi.addComponentHook(btn_config, ComponentHookList.ON_RELEASE);
			uiApi.addComponentHook(btn_resetSearch, ComponentHookList.ON_RELEASE);
			
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
					
					componentsRef.btn_title.value = data.areaId;
					
					uiApi.addComponentHook(componentsRef.btn_title, ComponentHookList.ON_PRESS); // Hack to disable the drag/drop
					uiApi.addComponentHook(componentsRef.btn_title, ComponentHookList.ON_RELEASE);
					
					break;
				case _ctn_key:
					componentsRef.lb_name.text = data.label;
					
					componentsRef.tx_key.uri = dataApi.getItemWrapper(data.dataKey.id).iconUri;
					
					if (data.dataKey.present == true)
					{
						componentsRef.tx_present.visible = true;
						componentsRef.lb_time.visible = false;
						
						uiApi.addComponentHook(componentsRef.tx_present, ComponentHookList.ON_ROLL_OVER);
						uiApi.addComponentHook(componentsRef.tx_present, ComponentHookList.ON_ROLL_OUT);
						
						return;
					}
					
					componentsRef.tx_present.visible = false;
					componentsRef.lb_time.visible = true;
					
					componentsRef.lb_time.cssClass = data.dataKey.valid ? "p0" : "p2";
					
					var time:Number = WEEKTIME - (timeApi.getTimestamp() - data.dataKey.time);
					if (time > DAYTIME)
					{
						componentsRef.lb_time.text = _langManager.getText(LangEnum.TIME_DAYS, (((time - (time % DAYTIME)) + DAYTIME) / DAYTIME));
					}
					else if (time > HOURTIME)
					{
						componentsRef.lb_time.text = _langManager.getText(LangEnum.TIME_HOURS, (((time - (time % HOURTIME)) + HOURTIME) / HOURTIME));
					}
					else if (time > MINUTETIME)
					{
						componentsRef.lb_time.text = _langManager.getText(LangEnum.TIME_MINUTES, (((time - (time % MINUTETIME)) + MINUTETIME) / MINUTETIME));
					}
					else
					{
						componentsRef.lb_time.text = _langManager.getText(LangEnum.TIME_SECONDS, (time % MINUTETIME));
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
			_searchTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, onTimeOut);
			_searchTimer.stop();
			_searchTimer = null;
		}
		
		//::////////////////////////////////////////////////////////////////////
		//::// Private Methods
		//::////////////////////////////////////////////////////////////////////
		
		private function initGrid(keyring:ItemWrapper, keyringKeys:Dictionary, selectedAreaId:int = -1, search:String = null):void
		{
			if (keyring == null)
			{
				ctn_grid.visible = false;
				ctn_nokeyring.visible = true;
				
				return;
			}
			
			var displayedInfos:Array = [];
			var keyId:String;
			
			// Select keys with search
			if (selectedAreaId == -1 && search != null)
			{
				for (keyId in keyringKeys)
				{
					var name:String = dataApi.getItemWrapper(int(keyId)).name;
					
					if (name && name.toLowerCase().indexOf(search.toLowerCase()) != -1)
					{
						displayedInfos.push(new DisplayInfo(name, -1, keyringKeys[keyId]));
					}
				}
				
				grid_keys.dataProvider = displayedInfos;
				
				return;
			}
			
			// Select keys with categories
			for each (var areaId:int in KeyUtils.getDungeonAreas())
			{
				displayedInfos.push(new DisplayInfo(areaId == KeyUtils.NO_AREA ? _langManager.getText(LangEnum.OTHERS) : dataApi.getArea(areaId).name, areaId));
				
				if (areaId == selectedAreaId)
				{
					for (keyId in keyringKeys)
					{
						if (KeyUtils.getDungeonArea(int(keyId)) == areaId)
						{
							displayedInfos.push(new DisplayInfo(dataApi.getItemWrapper(int(keyId)).name, -1, keyringKeys[keyId]));
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
			switch (target)
			{
				case btn_close:
					uiApi.unloadUi(uiApi.me().name);
					
					break;
				case btn_config:
					modCommon.openOptionMenu(false, "module_keyring");
					
					break;
				case ctn_main:
					dragUiStop();
					
					sysApi.setData(ConfigEnum.POSITION, [ctn_main.x, ctn_main.y]);
					
					break;
				case btn_resetSearch:
					inp_search.text = "";
					
					initGrid(_keyring, _keyringKeys, _selectedArea);
					
					break;
				default:
					if (target.name.indexOf("btn_title") != -1)
					{
						_selectedArea = (target.value == _selectedArea) ? DEFAULT_AREA : target.value;
						
						initGrid(_keyring, _keyringKeys, _selectedArea);
					}
					
					break;
			}
		}
		
		public function onReleaseOutside(target:Object):void
		{
			if (target == ctn_main)
			{
				dragUiStop();
				
				sysApi.setData(ConfigEnum.POSITION, [ctn_main.x, ctn_main.y]);
			}
		}
		
		public function onRollOver(target:Object):void
		{
			switch (target)
			{
				default:
					if (target.name.indexOf("tx_present") != -1)
					{
						uiApi.showTooltip(uiApi.textTooltipInfo(_langManager.getText(LangEnum.KEY_PRESENT)), target, false, "standard", LocationEnum.POINT_BOTTOM, LocationEnum.POINT_TOP, 3, null, null, null, "TextInfo");
					}
					
					break;
			}
		}
		
		public function onRollOut(target:Object):void
		{
			uiApi.hideTooltip();
		}
		
		public function onKeyUp(target:Object, keyCode:uint):void
		{
			if (inp_search.haveFocus)
			{
				_searchTimer.reset();
				_searchTimer.start();
			}
		}
		
		public function onTimeOut(event:TimerEvent):void
		{
			if (inp_search.text.length == 0)
			{
				initGrid(_keyring, _keyringKeys, _selectedArea);
			}
			else if (inp_search.text.length > 2)
			{
				initGrid(_keyring, _keyringKeys, -1, inp_search.text);
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
	public var areaId:int;
	
	public function DisplayInfo(label:String, areaId:int = -1, dataKey:DataKey = null)
	{
		this.label = label;
		this.isTitle = areaId != -1;
		this.dataKey = dataKey;
		this.areaId = areaId;
	}
}