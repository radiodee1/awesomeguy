package  org.davidliebman.flash.awesomeguy {
	import flash.display.*;
	
	public class AGDrawFlyer extends AGDraw {
		
		var mysprite:Sprite;
		
		public override function AGDrawFlyer(mode:AGMode, myres:Array, mystage:Stage, mybackground:Bitmap) {
			// constructor code
			super(mode,myres,mystage,mybackground);
		}
		
		public override function drawRes(sprite:AGSprite, xx:int, yy:int, facingRight:Boolean, kind:int, animate:int):void {
			// all drawing goes here!!
		//}

		//public function drawBasicSprite(spriteNum:int, kind:int):void {
			// init some vars here
			var add:int, add_radar:int;
			var scrollx:int = myMode.scrollBGX;
			var scrolly:int = myMode.scrollBGY;
			
			switch (kind) {
				case AGMode.S_FLYER:
					
				add = 0;
				add_radar = 0;

				
				if (scrollx >= xx  ) {
					add = myMode.myHoriz * myMode.TILE_WIDTH;
					add_radar =  (xx - scrollx) - xx ;
				}
				
				if (facingRight) {
					if (animate %2 == 1 ) {
						sprite.sprite = myRes[AGResources.NAME_FLYER_R0_PNG];

					}
					else {
						sprite.sprite = myRes[AGResources.NAME_FLYER_R1_PNG];
	
					}
				}
				else {
					if (animate %2 == 1) {
						sprite.sprite = myRes[AGResources.NAME_FLYER_L0_PNG];

					}
					else {
						sprite.sprite = myRes[AGResources.NAME_FLYER_L1_PNG];
	
					}
				}
				sprite.sprite.x = add + xx - scrollx;
				sprite.sprite.y = yy - scrolly;
				myStage.addChild(sprite.sprite);
			
				break;
			}
		}

	}
	
}
