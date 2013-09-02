package  org.davidliebman.flash.awesomeguy{
	import flash.display.Bitmap;
	
	public class AGModeControls extends AGMode {

		public function AGModeControls() {
			// constructor code
		}

		public override function doOnce():void {
			showSign();
		}
		public override function componentsInOrder():void {
			showSign();
		}

		public function showSign():void {
			super.componentsInOrder();
			var sign:Bitmap = myRes[AGResources.NAME_START_CONTROLS_PNG];
			sign.x = 0;
			sign.y = 0;
			myStage.addChild(sign);
			
		}

	}
	
}
