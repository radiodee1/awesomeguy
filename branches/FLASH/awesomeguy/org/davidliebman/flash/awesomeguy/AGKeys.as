﻿package  org.davidliebman.flash.awesomeguy {
	import flash.display.*;
	import flash.events.KeyboardEvent;
	import flash.events.*;
	import flash.system.MessageChannel;
	import flash.system.WorkerDomain;
	import flash.system.Worker;
	//import flash.text.TextField;
	
	public class AGKeys extends Sprite {
	
	public var mainToWorker:MessageChannel;
	public var workerToMain:MessageChannel;
	public var worker:Worker;
	
	public var prefix:String = new String("");
	public var build_type:String = new String("");
	var keys:Array = new Array();

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
	
	var lastCode:int ;
	
	var myScreen:Stage;

		public function AGKeys(mystage:Stage) {
			keys = new Array();
			for(var x:int = 0; x <= keycodeAny; x ++) {
				if (x == keycodeQuiet) {
					keys.push(new KeyValue(KeyValue.ENUM_TOGGLE));
				}
				else keys.push(new KeyValue());
			}
			
			myScreen = mystage;
			this.addEventListener(Event.ADDED_TO_STAGE, setCallbacks);
			//setCallbacks();
			this.build_type = "web";
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
			// 
			
			//trace("Key Code DOWN: " + event.keyCode);

			keys[event.keyCode].setValBool(true);
			keys[this.keycodeAny].setValBool(true);
			
			

		}
		
		public function keyboardUpHandler(event:KeyboardEvent):void{
			// 
			keys[event.keyCode].setValBool(false);
			keys[this.keycodeAny].setValBool(false);
			
			

			//trace("Key Code UP: " + event.keyCode);

		}
		
		
		public function launchNextPhase():void {
			var resources:AGResources = new AGResources(myScreen, this, keys);
			//trace("next phase...");
		}

	}
	
}
