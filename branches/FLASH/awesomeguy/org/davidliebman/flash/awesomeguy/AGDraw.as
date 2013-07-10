package org.davidliebman.flash.awesomeguy {
	import flash.display.Bitmap;
	import flash.display.*;
	
	public class AGDraw {

		public var myMode:AGMode;
		public var myRes:Array;// sprites and picture resources
		public var myStage:Stage;// primary bitmap that holds rock tiles
		public var myBackground:Bitmap;// secondary bitmap for bubbles etc.

		public function AGDraw(mode:AGMode, myres:Array, mystage:Stage, mybackground:Bitmap) {
			// constructor code
			myMode = mode;
			myRes = myres;
			myStage = mystage;
			myBackground = mybackground;
			
		}
		
		public function drawRes(sprite:AGSprite, xx:int, yy:int, facingRight:Boolean, kind:int, animate:int):void {
			// all drawing goes here!!
		}

	}
	
}
