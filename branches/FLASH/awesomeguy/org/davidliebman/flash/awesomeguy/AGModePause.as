package org.davidliebman.flash.awesomeguy {
	import flash.display.Bitmap;
	import flash.events.TouchEvent;
	import flash.ui.*;
	
	public class AGModePause  extends AGMode {

		public function AGModePause() {
			// constructor code
		}
		
		
		public override function doOnce():void {
			showSign();
		}
		public override function componentsInOrder():void {
			showSign();
		}

		public function showSign():void {
			super.componentsInOrder();
			var sign:Bitmap = myRes[AGResources.NAME_START_PAUSE_PNG];
			sign.x = 64;
			sign.y = 64;
			myStage.addChild(sign);
			
			if (this.myGame.myKeyStage.build_type == "android") {
				Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT;
				sign.addEventListener(TouchEvent.TOUCH_TAP, touchHandler);
			}
		}
		
		public function touchHandler(evt:TouchEvent):void {
			this.myGame.gameMode = AGGame.MODE_FLYER;
		}

	}
	
}
