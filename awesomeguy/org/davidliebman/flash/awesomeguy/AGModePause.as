package org.davidliebman.flash.awesomeguy {
	import flash.display.Bitmap;
	import flash.events.TouchEvent;
	import flash.ui.*;
	import flash.display.Sprite;
	
	public class AGModePause  extends AGMode {

		public function AGModePause() {
			// constructor code
		}
		
		
		public override function doOnce():void {
			//showSign();
			this.innerGameLoop();
			showSign();

		}
		public override function componentsInOrder():void {
			//showSign();
		}

		public function showSign():void {
			
			var sign:Bitmap = myRes[AGResources.NAME_START_PAUSE_PNG];
			var sign2:Sprite = new Sprite();
			sign2.addChild(sign);
			sign2.x = 64;
			sign2.y = 64;
			//myStage.addChild(sign2);
			
			
			if (this.myGame.myKeyStage.build_type == "android") {
				//trace("right");
				Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT;
				sign2.addEventListener(TouchEvent.TOUCH_TAP, touchHandler);
			}
			
			myStage.addChild(sign2);
		}
		
		public function touchHandler(evt:TouchEvent):void {
			trace("right3");
			//this.myGame.gameMode = AGGame.MODE_FLYER;
			this.myGame.myModeStack.push(AGGame.MODE_FLYER);
			this.myGame.doAnimation();
			//this.innerGameLoop();
		}

	}
	
}
