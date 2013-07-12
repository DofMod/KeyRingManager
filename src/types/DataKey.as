package types
{
	
	/**
	 * Keys data.
	 * 
	 * @author Relena
	 */
	public class DataKey
	{
		public var time:Number;
		public var present:Boolean;
		public var valid:Boolean;
		
		public function DataKey(time:Number, present:Boolean, valid:Boolean)
		{
			this.time = time;
			this.present = present;
			this.valid = valid;
		}
	}
}