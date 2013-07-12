package utils
{
	import enums.ItemIdEnum;
	
	/**
	 * Keys utils.
	 * 
	 * @author Relena
	 */
	public class KeyUtils
	{
		public static function cantBeOnKeyring(keyId:int):Boolean
		{
			switch (keyId)
			{
				case ItemIdEnum.FIRST_PART_OF_THE_DRAGON_PIG_S_MAZE_KEY:
				case ItemIdEnum.SECOND_PART_OF_THE_DRAGON_PIG_S_MAZE_KEY:
				case ItemIdEnum.COPY_OF_THE_BANDIT_HIDEOUT_KEY:
				case ItemIdEnum.FIRST_SPHINCTER_DUNGEON_KEY:
				case ItemIdEnum.SECOND_SPHINCTER_DUNGEON_KEY:
				case ItemIdEnum.BUCK_ANEAR_S_BUNCH_OF_KEYS:
				case ItemIdEnum.COCO_KEY_FRAGMENT:
				case ItemIdEnum.INDIGO_KEY_FRAGMENT:
				case ItemIdEnum.MORELLO_CHERRY_KEY_FRAGMENT:
				case ItemIdEnum.PIPPIN_KEY_FRAGMENT:
					return true;
			}
			
			return false;
		}
	}
}