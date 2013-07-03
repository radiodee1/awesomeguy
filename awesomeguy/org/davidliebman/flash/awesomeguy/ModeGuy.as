package org.davidliebman.flash.awesomeguy {
	
	public class ModeGuy extends AGMode{

		public function ModeGuy() {
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
