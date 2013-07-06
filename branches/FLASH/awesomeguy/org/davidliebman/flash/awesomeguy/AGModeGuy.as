package org.davidliebman.flash.awesomeguy {
	
	public class AGModeGuy extends AGMode{

		public function AGModeGuy() {
			// constructor code
		}
		
		public override function componentsInOrder():void {
			
		}
		
		public override function doOnce():void {
			myStage.addChild(myRes[AGResources.NAME_TEST2_PNG]);
		}
		
		public override function prepTiles():void {
			
		}
	}
	
}
