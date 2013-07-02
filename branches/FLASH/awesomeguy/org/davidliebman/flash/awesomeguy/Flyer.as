package org.davidliebman.flash.awesomeguy {
	
	public class Flyer extends AGMode{

		public function Flyer() {
			// constructor code
		}
		
		public override function componentsInOrder():void {
			myStage.addChild(myRes[0]);
		}
	}
	
}
