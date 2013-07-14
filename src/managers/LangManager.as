package managers
{
	import d2api.FileApi;
	import d2api.SystemApi;
	import d2enums.LanguageEnum;
	import flash.utils.Dictionary;
	
	/**
	 * ...
	 * @author Relena
	 */
	public class LangManager
	{
		private var _sysApi:SystemApi;
		private var _fileApi:FileApi;
		
		private var _dico:Dictionary;
		private var _init:Boolean;
		
		public function LangManager(sysApi:SystemApi, fileApi:FileApi, lang:String = LanguageEnum.LANG_FR)
		{
			_sysApi = sysApi;
			_fileApi = fileApi;
			
			_dico = new Dictionary();
			_init = false;
			
			try
			{
				_fileApi.loadXmlFile("lang/" + lang + ".xml", loadSuccess, loadError);
			}
			catch (err:Error)
			{
				_sysApi.log(16, err.getStackTrace());
			}
		}
		
		private function loadSuccess(root:XML):void
		{
			for each (var child:XML in root.elements())
			{
				_dico[child.localName()] = child.toString();
			}
			
			_init = true;
		}
		
		private function loadError(... args):void
		{
			_sysApi.log(8, args.length);
			_sysApi.log(8, args);
			
			_init = true;
		}
		
		public function getText(key:String):String
		{
			if (!_init)
			{
				return "[NOT_INIT]";
			}
			
			if (_dico[key])
			{
				return _dico[key];
			}
			
			return "[UNKOWN_KEY_" + key + "]";
		}
		
		public function isInit():Boolean
		{
			return _init;
		}
	}
}