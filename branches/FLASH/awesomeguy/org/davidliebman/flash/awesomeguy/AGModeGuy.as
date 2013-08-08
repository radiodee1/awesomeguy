package org.davidliebman.flash.awesomeguy {
	
	public class AGModeGuy extends AGMode{

		public function AGModeGuy() {
			// constructor code
		}
		
		public override function componentsInOrder():void {
			myStage.addChild(myRes[AGResources.NAME_START_PAUSE_PNG]);

		}
		
		public override function doOnce():void {
		}
		
		public override function prepTiles():void {
			
		}
	}
	
}
