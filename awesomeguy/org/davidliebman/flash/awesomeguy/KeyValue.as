package  org.davidliebman.flash.awesomeguy {
	
	public class KeyValue {

		public static var FALSE:int = 0;
		public static var TRUE:int = 1;

		public static var ENUM_PRESS:int = 1;
		public static var ENUM_TOGGLE:int = 2;

		var val:int = 0;
		var toggle:int = 1;
		var oldv:Boolean = false;

		public function KeyValue(enum:int = 1 ,v:Boolean = false) {
			// constructor code
			
			toggle = enum;
			
			if (v) {
				val = TRUE;
			}
			else {
				val = FALSE;
			}
		}
		public function getVal():int {
			return val;
		}

		public function setVal(v:int):void {
			val = v;
		}
		public function getValBool():Boolean {
			
			
			if (val == TRUE) {
				return true;
			}
			else if (val == FALSE) {
				return false;
			}
			return false;
		}
		public function setValBool(v:Boolean):void {
			switch (toggle) {
				case ENUM_PRESS:
				
					if (v) {
						val = TRUE;
					}
					else {
						val = FALSE;
					}
				
				break;
				case ENUM_TOGGLE:
					
					if (v  && val == FALSE && v != oldv) {
						val = TRUE;
						
					}
					else if (v  && val == TRUE && v != oldv) {
						val = FALSE;
						
					}
					oldv = v;
					
					
				break;
			}
			
			
			
		}
	}
	
}
