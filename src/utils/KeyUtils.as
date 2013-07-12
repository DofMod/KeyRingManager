package utils
{
	import enums.ItemIdEnum;
	import enums.KeyGroup;
	
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
		
		public static function getKeyGroup(keyId:int):int
		{
			switch (keyId)
			{
				case ItemIdEnum.KEY_TO_THE_ROYAL_MASTOGOB_S_GREENHOUSE:
				case ItemIdEnum.PINGWIN_KEY:
				case ItemIdEnum.KEY_TO_THE_HESPERUS:
				case ItemIdEnum.KEY_TO_THE_OBSIDEMON_S_HYPOGEUM:
				case ItemIdEnum.KEY_TO_THE_SNOWFOUX_DEN:
				case ItemIdEnum.KEY_TO_KORRIANDER_S_LAIR:
				case ItemIdEnum.KEY_TO_KOLOSSO_S_CAVERNS:
				case ItemIdEnum.KEY_TO_THE_BEARBARIAN_ANTICHAMBER:
				case ItemIdEnum.MISSIZ_FREEZZ_S_FROSTFORGE_KEY:
				case ItemIdEnum.SYLARGH_S_CARRIER_KEY:
				case ItemIdEnum.KLIME_S_PRIVATE_SUITE_KEY:
				case ItemIdEnum.NILEZA_S_LABORATORY_KEY:
				case ItemIdEnum.COUNT_HAREBOURG_S_DUNGEON_KEY:
					return KeyGroup.FRIGOST;
					
				case ItemIdEnum.SECRET_ROYAL_TOFU_HOUSE_KEY:
				case ItemIdEnum.BLACKSMITH_DUNGEON_KEY:
				case ItemIdEnum.SKELETON_DUNGEON_KEY:
				case ItemIdEnum.TOFU_HOUSE_KEY:
				case ItemIdEnum.KEY_TO_THE_RAT_DUNGEON_AT_AMAKNA_CASTLE:
				case ItemIdEnum.SCARALEAF_DUNGEON_KEY:
				case ItemIdEnum.AL_HOWIN_S_STEWPOT_KEY:
				case ItemIdEnum.DRAGON_PIG_S_MAZE_KEY:
				case ItemIdEnum.DRAGON_PIG_S_DEN_KEY:
				case ItemIdEnum.CRACKLER_DUNGEON_KEY:
				case ItemIdEnum.BWORK_DUNGEON_KEY:
				case ItemIdEnum.KEY_TO_THE_KWAKWA_S_NEST:
				case ItemIdEnum.DREGGONS__SANCTUARY_KEY:
				case ItemIdEnum.DREGGON_DUNGEON_KEY:
					return KeyGroup.AMAKNA;
					
				case ItemIdEnum.PANDIKAZE_DUNGEON_KEY:
				case ItemIdEnum.KITSOUNE_DUNGEON_KEY:
				case ItemIdEnum.BULB_DUNGEON_KEY:
				case ItemIdEnum.FIREFOUX_DUNGEON_KEY:
				case ItemIdEnum.DAGGERO_S_LAIR_KEY:
					return KeyGroup.PANDALA;
					
				case ItemIdEnum.LORD_CROW_S_LIBRARY_KEY:
				case ItemIdEnum.CANIDAE_DUNGEON_KEY:
				case ItemIdEnum.BLOP_DUNGEON_KEY:
				case ItemIdEnum.RAINBOW_BLOP_LAIR_KEY:
				case ItemIdEnum.HAUNTED_HOUSE_KEY:
					return KeyGroup.CANIA;
					
				case ItemIdEnum.GROTTO_HESQUE_KEY:
				case ItemIdEnum.OTOMAI_S_ARK_KEY:
				case ItemIdEnum.BHERB_S_GULLY_KEY:
				case ItemIdEnum.TYNRIL_LAB_KEY:
				case ItemIdEnum.KIMBO_S_CANOPY_KEY:
					return KeyGroup.OTOMAI;
					
				case ItemIdEnum.KEY_TO_BRUMEN_TINCTORIAS_S_LABORATORY:
				case ItemIdEnum.FUNGUS_DUNGEON_KEY:
				case ItemIdEnum.BWORKER_DUNGEON_KEY:
					return KeyGroup.SIDIMOTE;
					
				case ItemIdEnum.TREECHNID_DUNGEON_KEY:
				case ItemIdEnum.SOFT_OAK_DUNGEON_KEY:
					return KeyGroup.TREECHNID;
					
				case ItemIdEnum.SKEUNK_S_HIDEOUT_KEY:
				case ItemIdEnum.KOOLICH_CAVERN_KEY:
					return KeyGroup.KOALAK;
					
				case ItemIdEnum.LABYRINTH_OF_THE_MINOTOROR_KEY:
				case ItemIdEnum.MINOTOT_ROOM_KEY:
					return KeyGroup.MINOTOROR;
					
				case ItemIdEnum.SAND_DUNGEON_KEY:
				case ItemIdEnum.FIELD_DUNGEON_KEY:
					return KeyGroup.ASTRUB;
					
				case ItemIdEnum.KWISMAS_DUNGEON_KEY:
				case ItemIdEnum.KWISMAS_CAVERN_KEY:
				case ItemIdEnum.FATHER_KWISMAS_S_HOUSE_KEY:
					return KeyGroup.KWISMAS;
					
				case ItemIdEnum.GOBBALL_DUNGEON_KEY: // Tainela
				case ItemIdEnum.INCARNAM_DUNGEON_KEY: // Incarnam
				case ItemIdEnum.SAKAI_MINE_KEY: // Sakai
				case ItemIdEnum.BONTA_RAT_DUNGEON_KEY: // Bonta
				case ItemIdEnum.BRAKMAR_RAT_DUNGEON_KEY: // Brakmar
				case ItemIdEnum.KANNIBALL_DUNGEON_KEY: // Moon
					return KeyGroup.OTHER;
			}
			
			return KeyGroup.OTHER;
		}
	}
}