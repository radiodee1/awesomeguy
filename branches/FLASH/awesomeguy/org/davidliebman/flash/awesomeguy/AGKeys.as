package  org.davidliebman.flash.awesomeguy {
	import flash.display.*;
	import flash.events.KeyboardEvent;
	import flash.events.*;
	//import flash.text.TextField;
	
	public class AGKeys extends Sprite {
	
	
	var KEY_VAL_LEFT:KeyValue = new KeyValue();
	var KEY_VAL_RIGHT:KeyValue = new KeyValue();
	var KEY_VAL_UP:KeyValue = new KeyValue();
	var KEY_VAL_DOWN:KeyValue = new KeyValue();
	var KEY_VAL_SHOOT:KeyValue = new KeyValue();
	var KEY_VAL_JUMP:KeyValue = new KeyValue();
	var KEY_VAL_PAUSE:KeyValue = new KeyValue();
	
	var KEY_VAL_RESTART:KeyValue = new KeyValue();
	var KEY_VAL_QUIET:KeyValue = new KeyValue(KeyValue.ENUM_TOGGLE);
	
	var KEY_VAL_ANY:KeyValue = new KeyValue();
	
	var array:Array =  new Array( KEY_VAL_LEFT, KEY_VAL_RIGHT, KEY_VAL_UP, 
								 KEY_VAL_DOWN, KEY_VAL_SHOOT , KEY_VAL_JUMP,
								 KEY_VAL_PAUSE, KEY_VAL_ANY, KEY_VAL_RESTART, 
								 KEY_VAL_QUIET);
	var keys:Array = new Array();

	static var BUTTON_LEFT:int = 0;
	static var BUTTON_RIGHT:int = 1;
	static var BUTTON_UP:int = 2;
	static var BUTTON_DOWN:int = 3;
	static var BUTTON_SHOOT:int = 4;
	static var BUTTON_JUMP:int = 5;
	static var BUTTON_PAUSE:int = 6;
	static var BUTTON_ANY:int = 7;
	static var BUTTON_RESTART:int = 8;
	static var BUTTON_QUIET:int = 9;
	

	var KEY_LEFT:Boolean = false;
	var KEY_RIGHT:Boolean = false;
	var KEY_UP:Boolean = false;
	var KEY_DOWN:Boolean = false;
	var KEY_SHOOT:Boolean = false;
	var KEY_JUMP:Boolean = false;
	var KEY_PAUSE:Boolean = false;
	var KEY_ANY:Boolean = false;
	var KEY_RESTART:Boolean = false;
	var KEY_QUIET:Boolean = false;

	public var keycodeLeft:int = 37;
	public var keycodeRight:int = 39;
	public var keycodeUp:int = 38;
	public var keycodeDown:int = 40;
	public var keycodeShoot:int = 16;
	public var keycodeJump:int = 32;
	public var keycodePause:int = 80;
	public var keycodeRestart:int = 82;
	public var keycodeQuiet:int = 81;
	public var keycodeAny:int = 105;
	
	var lastCode:int ;
	
	var myScreen:Stage;

		public function AGKeys(mystage:Stage) {
			keys = new Array();
			for(var x:int = 0; x <= 130; x ++) {
				if (x == keycodeQuiet) {
					keys.push(new KeyValue(KeyValue.ENUM_TOGGLE));
				}
				else keys.push(new KeyValue());
			}
			
			myScreen = mystage;
			this.addEventListener(Event.ADDED_TO_STAGE, setCallbacks);
			//setCallbacks();
			
			//trace("constructor...");
		}
		
		public function setCallbacks(e:Event):void {
			
			myScreen.addEventListener(KeyboardEvent.KEY_DOWN, keyboardDownHandler);
			myScreen.addEventListener(KeyboardEvent.KEY_UP, keyboardUpHandler);
			myScreen.removeEventListener(Event.ADDED_TO_STAGE, setCallbacks);
			//trace("callbacks...");
			launchNextPhase();
		}
		
		public function keyboardDownHandler(event:KeyboardEvent):void {
			// Start your custom code
			keys[event.keyCode].setValBool(true);
			keys[this.keycodeAny].setValBool(true);
			
			if (event.keyCode == keycodeLeft) KEY_LEFT = true;
			if (event.keyCode == keycodeRight) KEY_RIGHT = true;
			if (event.keyCode == keycodeUp) KEY_UP = true;
			if (event.keyCode == keycodeDown) KEY_DOWN = true;
			if (event.keyCode == keycodeShoot) KEY_SHOOT = true;
			if (event.keyCode == keycodeJump) KEY_JUMP = true;
			if (event.keyCode == keycodePause) KEY_PAUSE = true;
			if (event.keyCode == keycodeRestart) KEY_RESTART = true;
			if (event.keyCode == keycodeQuiet) KEY_QUIET = true;
			if (event.keyCode != keycodePause) KEY_ANY = true;
			lastCode = event.keyCode;
			setAllKeys();

			trace("Key Code DOWN: " + event.keyCode);
		}
		
		public function keyboardUpHandler(event:KeyboardEvent):void{
			// Start your custom code
			keys[event.keyCode].setValBool(false);
			keys[this.keycodeAny].setValBool(false);
			
			if (event.keyCode == keycodeLeft) KEY_LEFT = false;
			if (event.keyCode == keycodeRight) KEY_RIGHT = false;
			if (event.keyCode == keycodeUp) KEY_UP = false;
			if (event.keyCode == keycodeDown) KEY_DOWN = false;
			if (event.keyCode == keycodeShoot) KEY_SHOOT = false;
			if (event.keyCode == keycodeJump) KEY_JUMP = false;
			if (event.keyCode == keycodePause) KEY_PAUSE = false;
			if (event.keyCode == keycodeRestart) KEY_RESTART = false;
			if (event.keyCode == keycodeQuiet) KEY_QUIET = false;
			if (lastCode == event.keyCode) KEY_ANY = false;
			setAllKeys();

			//trace("Key Code UP: " + event.keyCode);

		}
		
		public function setAllKeys():void {
			 KEY_VAL_LEFT.setValBool(KEY_LEFT);
			 KEY_VAL_RIGHT.setValBool(KEY_RIGHT);
			 KEY_VAL_UP.setValBool(KEY_UP);
			 KEY_VAL_DOWN.setValBool(KEY_DOWN);
			 KEY_VAL_SHOOT.setValBool(KEY_SHOOT);
			 KEY_VAL_JUMP.setValBool(KEY_JUMP);
			 KEY_VAL_PAUSE.setValBool(KEY_PAUSE);
			 KEY_VAL_ANY.setValBool(KEY_ANY);
			 KEY_VAL_RESTART.setValBool(KEY_RESTART);
			 KEY_VAL_QUIET.setValBool(KEY_QUIET);
		}
		
		public function launchNextPhase():void {
			var resources:AGResources = new AGResources(myScreen, this, keys);
			//trace("next phase...");
		}

	}
	
}
