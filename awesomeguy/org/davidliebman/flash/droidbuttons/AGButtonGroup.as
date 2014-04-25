package  org.davidliebman.flash.droidbuttons{
	import flash.display.*;
	import flash.events.KeyboardEvent;
	import flash.events.*;
	import org.davidliebman.flash.awesomeguy.*;
	import org.davidliebman.flash.droidbuttons.*;
	import flash.geom.Rectangle;
	
	public class AGButtonGroup extends AGKeys {

		var keys:Array = new Array();
		/*
		public var keycodeLeft:int = 37;
		public var keycodeRight:int = 39;
		public var keycodeUp:int = 38;
		public var keycodeDown:int = 40;
		public var keycodeShoot:int = 90;// z 16 shift ;
		public var keycodeJump:int = 88;// x 32 space ;
		public var keycodePause:int = 80;
		public var keycodeRestart:int = 82;
		public var keycodeQuiet:int = 81;
		public var keycodeAny:int = 250;// highest
		public var keycodeControls:int = 191;// question mark
		*/
		var lastCode:int ;
	
		var myScreen:Stage;

		//public var keyObject:AGKeysForAndroid ;

		public function AGButtonGroup(mystage:Stage) {
			// constructor code
			super(mystage);
			mystage.align = flash.display.StageAlign.TOP;
			mystage.scaleMode = flash.display.StageScaleMode.EXACT_FIT;
			//mystage.fullScreenSourceRect = new Rectangle(0,0, 512, (512* 3/4));
			//mystage.displayState = flash.display.StageDisplayState.FULL_SCREEN;
			
			//mystage.fullScreenWidth = 512;
			//mystage.fullScreenHeight = (512 * 3/4);
			//trace(mystage.width, mystage.height);
			//mystage.height = 480;
			//mystage.scaleX = mystage.scaleY;
			
			prefix = "awesomeguy/";//"app:/";
			keys = new Array();
			for(var x:int = 0; x <= keycodeAny; x ++) {
				if (x == keycodeQuiet) {
					keys.push(new KeyValue(KeyValue.ENUM_TOGGLE));
				}
				else keys.push(new KeyValue());
			}
			
			myScreen = mystage;
			//keyObject = new AGKeysForAndroid(myScreen);

			this.addEventListener(Event.ADDED_TO_STAGE, setCallbacks);

			
		}

		public override function setCallbacks(e:Event):void {
			
			myScreen.addEventListener(KeyboardEvent.KEY_DOWN, keyboardDownHandler);
			myScreen.addEventListener(KeyboardEvent.KEY_UP, keyboardUpHandler);
			myScreen.removeEventListener(Event.ADDED_TO_STAGE, setCallbacks);
			//trace("callbacks...");
			launchNextPhase();
		}
		
		public override function keyboardDownHandler(event:KeyboardEvent):void {
			// 
			
			//trace("Key Code DOWN: " + event.keyCode);

			keys[event.keyCode].setValBool(true);
			keys[this.keycodeAny].setValBool(true);
			
			

		}
		
		public override function keyboardUpHandler(event:KeyboardEvent):void{
			// 
			keys[event.keyCode].setValBool(false);
			keys[this.keycodeAny].setValBool(false);
			
			

			//trace("Key Code UP: " + event.keyCode);

		}
		

		public override function launchNextPhase():void {
			var resources:AGButtonResources = new AGButtonResources(myScreen, this, keys);
			trace("next phase...");
			
			keys[this.keycodeAny].setValBool(true);
			keys[this.keycodeAny].setValBool(false);
			
		}

	}
	
}
