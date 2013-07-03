package org.davidliebman.flash.awesomeguy {
	
	public class ModeFlyer extends AGMode{

		public function ModeFlyer() {
			// constructor code
		}
		
		public override function componentsInOrder():void {
			//myStage.addChild(myRes[AGResources.NAME_TEST_PNG]);
			
		}
		
		public override function doOnce():void {
			myStage.addChild(myRes[AGResources.NAME_TEST2_PNG]);
			//myRes[AGResources.NAME_EXPLOSION_MP3].play();
		}
	}
	
}
