package types
{
	
	/**
	 * Keys data.
	 * 
	 * @author Relena
	 */
	public class DataKey
	{
		public var id:int;
		public var time:Number;
		public var present:Boolean;
		public var valid:Boolean;
		
		public function DataKey(id:int, time:Number, present:Boolean, valid:Boolean)
		{
			this.id = id;
			this.time = time;
			this.present = present;
			this.valid = valid;
		}
		
		public function toString():String
		{
			return "keyId = " + id + ", time = " + time + ", present = " + present + ", valid = " + valid; 
		}
	}
}