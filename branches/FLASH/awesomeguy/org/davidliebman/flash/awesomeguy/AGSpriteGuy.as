package org.davidliebman.flash.awesomeguy {
	
	public class AGSpriteGuy  extends AGSprite{


		var state:int = 0;
		
		var cheatx_climb:int = 0;
		var cheaty_climb:int = 0;
		var cheatx_punch:int = 0;
		var cheaty_punch:int = 0;
		var cheatx_step:int = 0;
		var cheaty_step:int = 0;
		
		public function AGSpriteGuy(mymode:AGMode, kind:int) {
			super(mymode,kind);
			// constructor code
		}

		public override function updateSprite():void {
			super.updateSprite();
		}

	}
	
}
