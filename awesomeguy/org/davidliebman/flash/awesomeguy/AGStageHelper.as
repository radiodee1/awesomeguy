package org.davidliebman.flash.awesomeguy {
	import flash.display.*;
	
	public class AGStageHelper {

		public var myStage:Sprite = new Sprite();
		
		public function AGStageHelper() {
			// constructor code
		}
		
		public function addChild(myChild:Sprite):void {
			myStage.addChild(myChild);
		}
		
		public function getStage():Sprite {
			return myStage;
		}

	}
	
}
