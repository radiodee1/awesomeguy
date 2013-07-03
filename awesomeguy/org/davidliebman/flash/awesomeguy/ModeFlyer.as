package org.davidliebman.flash.awesomeguy {
	
	public class ModeFlyer extends AGMode{

		public function ModeFlyer() {
			// constructor code
		}
		
		public override function componentsInOrder():void {
			myStage.addChild(myRes[0]);
		}
	}
	
}
