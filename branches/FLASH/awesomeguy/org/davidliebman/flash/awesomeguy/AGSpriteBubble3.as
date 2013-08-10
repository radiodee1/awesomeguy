package org.davidliebman.flash.awesomeguy {
	
	public class AGSpriteBubble3 extends AGSpriteBubble1 {

		public function AGSpriteBubble3(mode:AGMode, kind:int) {
			// constructor code
			super(mode,kind);
			this.color = 0xff0000ff;
			this.limit = 130;
		}

		public override function updateSprite():void {
			//this.color = 0xff0000ff;
			//this.limit = 130;
			
			
			//trace("blue");
			if (this.sprite_type == AGMode.S_BUBBLE_MAZE && this.radius >= this.limit) {
				//start maze
				
				this.myMode.myGame.gameMaze = this.sprite_link;
				
				if (!AGModeFlyer(this.myMode).animate_return_to_planet) {
					this.myMode.game_advance_maze = true;
				}
			}
			super.updateSprite();

		}

	}
	
}
