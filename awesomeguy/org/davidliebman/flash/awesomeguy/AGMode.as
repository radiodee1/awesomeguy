package  org.davidliebman.flash.awesomeguy {
	import flash.display.Stage;
	import flash.events.Event;
	
	public class AGMode {

	var K_LEFT:Boolean = false;
	var K_RIGHT:Boolean = false;
	var K_UP:Boolean = false;
	var K_DOWN:Boolean = false;		
	var K_SHOOT:Boolean = false;
	var K_JUMP:Boolean = false;
	
	var myStage:Stage;
	var myButtons:Array;
	var myRes:Array;
	

		public function AGMode() {
			// constructor code
		}
		
		public function setValues(mystage:Stage, mybuttons:Array, myresources:Array) {
			
			myStage = mystage;
			myButtons = mybuttons;
			myRes = myresources;
			
		}
		
		public function setKeys() {
			setKeyValues(myButtons[AGKeys.BUTTON_LEFT].getValBool() , myButtons[AGKeys.BUTTON_RIGHT].getValBool(),
						 myButtons[AGKeys.BUTTON_UP].getValBool(), myButtons[AGKeys.BUTTON_DOWN].getValBool(), 
						 myButtons[AGKeys.BUTTON_SHOOT].getValBool(), myButtons[AGKeys.BUTTON_JUMP].getValBool());
		}

		public function setKeyValues(left:Boolean, right:Boolean, up:Boolean, down:Boolean, shoot:Boolean, jump:Boolean) {
			K_LEFT = left;
			K_RIGHT = right;
			K_UP = up;
			K_DOWN = down;
			K_JUMP = jump;
			K_SHOOT = shoot;
			//doAnimation();
		}
		
		public function innerGameLoop() {
			setKeys();
			componentsInOrder();
		}
		public function componentsInOrder():void {
			
		}
	}
	
}
