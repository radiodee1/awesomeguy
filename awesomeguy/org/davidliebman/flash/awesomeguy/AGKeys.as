package  org.davidliebman.flash.awesomeguy {
	import flash.display.*;
	import flash.events.KeyboardEvent;
	import flash.events.*;
	
	public class AGKeys extends Sprite {
	
	var KEY_VAL_LEFT:KeyValue = new KeyValue();
	var KEY_VAL_RIGHT:KeyValue = new KeyValue();
	var KEY_VAL_UP:KeyValue = new KeyValue();
	var KEY_VAL_DOWN:KeyValue = new KeyValue();
	var KEY_VAL_SHOOT:KeyValue = new KeyValue();
	var KEY_VAL_JUMP:KeyValue = new KeyValue();
	var KEY_VAL_PAUSE:KeyValue = new KeyValue();
	
	var array:Array =  new Array( KEY_VAL_LEFT, KEY_VAL_RIGHT, KEY_VAL_UP, 
								 KEY_VAL_DOWN, KEY_VAL_SHOOT , KEY_VAL_JUMP,
								 KEY_VAL_PAUSE );

	static var BUTTON_LEFT:int = 0;
	static var BUTTON_RIGHT:int = 1;
	static var BUTTON_UP:int = 2;
	static var BUTTON_DOWN:int = 3;
	static var BUTTON_SHOOT:int = 4;
	static var BUTTON_JUMP:int = 5;
	static var BUTTON_PAUSE:int = 6;

	var KEY_LEFT:Boolean = false;
	var KEY_RIGHT:Boolean = false;
	var KEY_UP:Boolean = false;
	var KEY_DOWN:Boolean = false;
	var KEY_SHOOT:Boolean = false;
	var KEY_JUMP:Boolean = false;
	var KEY_PAUSE:Boolean = false;

	var keycodeLeft:int = 37;
	var keycodeRight:int = 39;
	var keycodeUp:int = 38;
	var keycodeDown:int = 40;
	var keycodeShoot:int = 16;
	var keycodeJump:int = 32;
	var keycodePause:int = 80;
	
	var myScreen:Stage;

		public function AGKeys(mystage:Stage) {
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
			if (event.keyCode == keycodeLeft) KEY_LEFT = true;
			if (event.keyCode == keycodeRight) KEY_RIGHT = true;
			if (event.keyCode == keycodeUp) KEY_UP = true;
			if (event.keyCode == keycodeDown) KEY_DOWN = true;
			if (event.keyCode == keycodeShoot) KEY_SHOOT = true;
			if (event.keyCode == keycodeJump) KEY_JUMP = true;
			if (event.keyCode == keycodePause) KEY_PAUSE = true;

			setAllKeys();

			//trace("Key Code DOWN: " + event.keyCode);
		}
		
		public function keyboardUpHandler(event:KeyboardEvent):void{
			// Start your custom code
			if (event.keyCode == keycodeLeft) KEY_LEFT = false;
			if (event.keyCode == keycodeRight) KEY_RIGHT = false;
			if (event.keyCode == keycodeUp) KEY_UP = false;
			if (event.keyCode == keycodeDown) KEY_DOWN = false;
			if (event.keyCode == keycodeShoot) KEY_SHOOT = false;
			if (event.keyCode == keycodeJump) KEY_JUMP = false;
			if (event.keyCode == keycodePause) KEY_PAUSE = false;

			setAllKeys();

			trace("Key Code UP: " + event.keyCode);

		}
		
		public function setAllKeys():void {
			 KEY_VAL_LEFT.setValBool(KEY_LEFT);
			 KEY_VAL_RIGHT.setValBool(KEY_RIGHT);
			 KEY_VAL_UP.setValBool(KEY_UP);
			 KEY_VAL_DOWN.setValBool(KEY_DOWN);
			 KEY_VAL_SHOOT.setValBool(KEY_SHOOT);
			 KEY_VAL_JUMP.setValBool(KEY_JUMP);
			 KEY_VAL_PAUSE.setValBool(KEY_PAUSE);
		}
		
		public function launchNextPhase():void {
			var resources:AGResources = new AGResources(myScreen, array);
			//trace("next phase...");
		}

	}
	
}
