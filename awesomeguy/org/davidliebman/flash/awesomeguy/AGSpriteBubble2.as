package org.davidliebman.flash.awesomeguy {
	
	public class AGSpriteBubble2 extends AGSpriteBubble1{

		public function AGSpriteBubble2(mode:AGMode, kind:int) {
			// constructor code
			super(mode,kind);
			
		}


		public override function updateSprite():void {
			this.color = 0xff00ff00;
			this.limit = 125;
			super.updateSprite();
			trace("here");
			
			
		}
	}
	
}
