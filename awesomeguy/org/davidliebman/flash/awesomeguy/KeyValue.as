package  org.davidliebman.flash.awesomeguy {
	
	public class KeyValue {

		public static var FALSE:int = 0;
		public static var TRUE:int = 1;

		var val:int = 0;

		public function KeyValue(v:Boolean = false) {
			// constructor code
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
			if (v) {
				val = TRUE;
			}
			else {
				val = FALSE;
			}
		}
	}
	
}
