package org.davidliebman.flash.awesomeguy {
	import flash.display.Bitmap;
	
	public class AGModePause  extends AGMode {

		public function AGModePause() {
			// constructor code
		}
		//public override function setValues(mystage:Stage, mybuttons:Array, myresources:Array, mygame:AGGame):void {
			//super.setValues(mystage, mybuttons, myresources,mygame);
			//super.setValues(mystage,mybuttons,myresources,mygame);
		//}
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
		}

	}
	
}
