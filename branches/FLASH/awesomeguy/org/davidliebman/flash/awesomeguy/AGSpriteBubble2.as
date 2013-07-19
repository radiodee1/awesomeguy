package org.davidliebman.flash.awesomeguy {
	
	public class AGSpriteBubble2 extends AGSpriteBubble1{

		public function AGSpriteBubble2(mode:AGMode, kind:int) {
			// constructor code
			super(mode,kind);
			myMode.myChallenge[myMode.myGame.gameChallenge].total_bubble_2 ++;
			myMode.myChallenge[myMode.myGame.gameChallenge].total_placed_bubble_2 ++;

		}


		public override function updateSprite():void {
			this.color = 0xff00ff00;
			this.limit = 120;
			super.updateSprite();
			//trace("here");
			
			
		}
	}
	
}
