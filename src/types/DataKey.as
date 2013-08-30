package types
{
	
	/**
	 * Keys data.
	 * 
	 * @author Relena
	 */
	public class DataKey
	{
		/**
		 * id : Identifier of the key
		 * isPresent : The key is present
		 * dateOfUse : Date's timestamp of use
		 * isDateReliable : The 'timestamp' is reliable (if the key disapeared when the module was disabled, the can't be sure of the date of use).
		 */
		public var id:int;
		public var isPresent:Boolean;
		public var dateOfUse:Number;
		public var isDateReliable:Boolean;
		
		public function DataKey(id:int, dateOfUse:Number, isPresent:Boolean, isDateRelisable:Boolean)
		{
			this.id = id;
			this.dateOfUse = dateOfUse;
			this.isPresent = isPresent;
			this.isDateReliable = isDateRelisable;
		}
		
		public function toString():String
		{
			return "keyId = " + id + ", date of use = " + dateOfUse + ", key is present = " + isPresent + ", date is reliable = " + isDateReliable;
		}
	}
}