package org.davidliebman.flash.awesomeguy {
	
	public class AGSpriteGuy  extends AGSprite{


		var isPunching:Boolean; 
		var isClimbing:Boolean;
		var isJumping:Boolean;

		public function AGSpriteGuy(mymode:AGMode, kind:int) {
			super(mymode,kind);
			// constructor code
		}

		public override function updateSprite():void {
			super.updateSprite();
		}

	}
	
}
