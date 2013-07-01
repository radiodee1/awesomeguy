package  org.davidliebman.flash.awesomeguy {
	
	public class Game {

	var K_LEFT:Boolean = false;
	var K_RIGHT:Boolean = false;
	var K_UP:Boolean = false;
	var K_DOWN:Boolean = false;		
		
		public function Game() {
			trace ("import worked. " );
			var getter:AGResources = new AGResources();
		}

		public function setKeyValues(left:Boolean, right:Boolean, up:Boolean, down:Boolean) {
			K_LEFT = left;
			K_RIGHT = right;
			K_UP = up;
			K_DOWN = down;
		}
		
		public function doAnimation() {
			//trace ("down " + K_DOWN);
		}
	}
	
}
