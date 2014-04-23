package org.davidliebman.flash.awesomeguy {
	import flash.display.*;
	import flash.geom.Rectangle;
	
	
	public class AGStageHelper {

		public var myStage:Sprite = new Sprite();
		
		public var SCREEN_HEIGHT:int = (512 * 3/4 );// - 64;
		public var SCREEN_WIDTH:int = 512;
	
		public function AGStageHelper() {
			// constructor code
			myStage.cacheAsBitmap = true;
		}
		
		public function addChild(myChild:Sprite):void {
			myStage.addChild(myChild);
		}
		
		public function getStage():Sprite {
			
			myStage.scrollRect = new Rectangle(0,0,512, (512 * 3/4));
			return myStage;
		}

	}
	
}
