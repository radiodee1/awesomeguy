package org.davidliebman.flash.awesomeguy {
	
	public class AG {

		public static var XML_MAZE_ENTRANCE:String = "XML_MAZE_ENTRANCE";
		//followed by x-flyer-tiles, y-flyer-tiles, new-maze-number
		
		public static var XML_MAZE_ENTRANCE_BUNKER:String = "XML_MAZE_ENTRANCE_BUNKER";
		//followed by x-flyer-tiles, y-flyer-tiles, new-maze-number
		
		public static var XML_MAZE_CONNECT:String = "XML_MAZE_CONNECT";
		//followed by x-maze-tiles, y-maze-tiles, new-maze-number

		public static var XML_MAZE_START_REGULAR:String = "XML_MAZE_START_REGULAR";
		//followed by x-maze-tiles, y-maze-tiles
		public static var XML_MAZE_EXIT:String = "XML_MAZE_EXIT";
		//followed by x-maze-tiles, y-maze-tiles (back to surface)
		
		public static var XML_MAZE_START_SPECIAL:String = "XML_MAZE_START_SPECIAL";
		public static var XML_TEST:String = "XML_TEST";

		public static var XML_TEXT_TIME_BEFORE_START:String = "XML_TEXT_TIME_BEFORE_START";
		//followed by seconds -- not used
		public static var XML_TEXT_TIME_PERIOD:String = "XML_TEXT_TIME_PERIOD";
		//followed by seconds -- not used
		
		public static var XML_TEXT_MAZE_BEFORE_COMPLETE:String = "XML_TEXT_MAZE_BEFORE_COMPLETE";
		//followed by message-number
		public static var XML_TEXT_MAZE_AFTER_COMPLETE:String = "XML_TEXT_MAZE_AFTER_COMPLETE";
		//followed by message-number
		public static var XML_TEXT_PLANET_BEFORE_COMPLETE:String = "XML_TEXT_PLANET_BEFORE_COMPLETE";
		//followed by message-number
		public static var XML_TEXT_PLANET_AFTER_COMPLETE:String = "XML_TEXT_PLANET_AFTER_COMPLETE";
		//followed by message-number

		

		public function AG() {
			// constructor code
		}

	}
	
}
