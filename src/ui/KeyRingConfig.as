package ui
{
	import d2api.SystemApi;
	import d2api.UiApi;
	import d2components.ButtonContainer;
	import d2enums.ComponentHookList;
	
	/**
	 * @author Relena
	 */
	public class KeyRingConfig
	{
		//::////////////////////////////////////////////////////////////////////
		//::// Properties
		//::////////////////////////////////////////////////////////////////////
		
		// APIs
		public var sysApi : SystemApi
		public var uiApi : UiApi;
		
		// Components
		public var btn_reset:ButtonContainer;
		
		// Constants
		
		// Proterties
		
		//::////////////////////////////////////////////////////////////////////
		//::// Public Methods
		//::////////////////////////////////////////////////////////////////////
		
		public function main(params:Object) : void
		{
			uiApi.addComponentHook(btn_reset, ComponentHookList.ON_RELEASE);
		}
		
		public function unload() : void
		{
		}
		
		//::////////////////////////////////////////////////////////////////////
		//::// Private Methods
		//::////////////////////////////////////////////////////////////////////
		
		//::////////////////////////////////////////////////////////////////////
		//::// Events
		//::////////////////////////////////////////////////////////////////////
		
		public function onRelease(target:Object):void
		{
			switch(target)
			{
				case btn_reset:
					// Reset data
					sysApi.log(8, "Data reset.");
					
					break;
			}
		}
	}
}