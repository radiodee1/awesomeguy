package org.davidliebman.flash.awesomeguy {
	
	public class AGSpriteBubble3 extends AGSpriteBubble1 {

		public function AGSpriteBubble3(mode:AGMode, kind:int) {
			// constructor code
			super(mode,kind);
		}

		public override function updateSprite():void {
			this.color = 0xff0000ff;
			this.limit = 130;
			super.updateSprite();
			trace("blue");
			
			
		}

	}
	
}
