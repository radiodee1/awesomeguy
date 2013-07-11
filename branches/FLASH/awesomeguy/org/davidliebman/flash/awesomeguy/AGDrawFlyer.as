package  org.davidliebman.flash.awesomeguy {
	import flash.display.*;
	
	public class AGDrawFlyer extends AGDraw {
		
		var mysprite:Sprite;
		
		public override function AGDrawFlyer(mode:AGMode, myres:Array, mystage:Stage, mybackground:Bitmap) {
			// constructor code
			super(mode,myres,mystage,mybackground);
		}
		
		public override function drawBasicSprite(sprite:AGSprite, kind:int):void {
			drawRes(sprite, sprite.x, sprite.y, sprite.facingRight, kind, sprite.animate);
		}
		
		public override function drawRes(sprite:AGSprite, xx:int, yy:int, facingRight:Boolean, kind:int, animate:int):void {
			// all drawing goes here!!
		
		
			// init some vars here
			var add:int, add_radar:int, z:int;
			var scrollx:int = myMode.scrollBGX;
			var scrolly:int = myMode.scrollBGY;
			var anim_speed:int = 5;
			
			switch (kind) {
				case AGMode.D_NONE:
					break;
				case AGMode.D_FLYER:
					
				add = 0;
				add_radar = 0;

				
				if (scrollx >= xx  ) {
					add = myMode.myHoriz * myMode.TILE_WIDTH;
					add_radar =  (xx - scrollx) - xx ;
				}
				
				if (facingRight) {
					if (animate %2 == 1 ) {
						sprite.bitmap = myRes[AGResources.NAME_FLYER_R0_PNG];

					}
					else {
						sprite.bitmap = myRes[AGResources.NAME_FLYER_R1_PNG];
	
					}
				}
				else {
					if (animate %2 == 1) {
						sprite.bitmap = myRes[AGResources.NAME_FLYER_L0_PNG];

					}
					else {
						sprite.bitmap = myRes[AGResources.NAME_FLYER_L1_PNG];
	
					}
				}
				sprite.bitmap.x = add + xx - scrollx;
				sprite.bitmap.y = yy - scrolly;
				myStage.addChild(sprite.bitmap);
				myMode.flyersprite = sprite.bitmap;
				break;
				
				case AGMode.D_GATOR:
		
		
				sprite.animate ++;
				if (sprite.animate > (anim_speed * 4) ) sprite.animate=0;
				if (sprite.animate > anim_speed * 2) z = 1;
				else z = 0;
				
		
				if(sprite.visible == true) {
					if (scrollx < sprite.x + 32 ) {
						//trace (sprite.animate);
						if(sprite.facingRight == true) {
							if(z == 0) {
								
								sprite.bitmap = new Bitmap( 
									myRes[AGResources.NAME_MONSTER_R0_PNG].bitmapData.clone());
								sprite.bitmap.x = sprite.x - scrollx;
								sprite.bitmap.y = sprite.y - scrolly;
								myStage.addChild(sprite.bitmap);
		
							}
							else if (z == 1 ) {
								
								sprite.bitmap = new Bitmap( 
									myRes[AGResources.NAME_MONSTER_R1_PNG].bitmapData.clone());//
								sprite.bitmap.x = sprite.x - scrollx;
								sprite.bitmap.y = sprite.y - scrolly;
								myStage.addChild(sprite.bitmap);
							}
						}
						else if (!sprite.facingRight == true) {
							if(z == 0) {
		
								sprite.bitmap = new Bitmap( 
									myRes[AGResources.NAME_MONSTER_L0_PNG].bitmapData.clone());//
								sprite.bitmap.x = sprite.x - scrollx;
								sprite.bitmap.y = sprite.y - scrolly;
								myStage.addChild(sprite.bitmap);
							}
							else if (z == 1) {
		
								sprite.bitmap = new Bitmap( 
									myRes[AGResources.NAME_MONSTER_L1_PNG].bitmapData.clone());//
								sprite.bitmap.x = sprite.x - scrollx;
								sprite.bitmap.y = sprite.y - scrolly;
								myStage.addChild(sprite.bitmap);
							}
						}
					}
					else if (scrollx >= sprite.x  ) {
						//trace(sprite.animate);
						if(sprite.facingRight == true) {
							if(z == 0) {
		
								sprite.bitmap = new Bitmap( 
									myRes[AGResources.NAME_MONSTER_R0_PNG].bitmapData.clone());//
								sprite.bitmap.x = (myMode.myHoriz * 16 ) + sprite.x - scrollx;
								sprite.bitmap.y = sprite.y - scrolly;
								myStage.addChild(sprite.bitmap);
							}
							else if (z == 1 ) {
		
								sprite.bitmap = new Bitmap( 
									myRes[AGResources.NAME_MONSTER_R1_PNG].bitmapData.clone());//
								sprite.bitmap.x = (myMode.myHoriz * 16 ) + sprite.x - scrollx;
								sprite.bitmap.y = sprite.y - scrolly;
								myStage.addChild(sprite.bitmap);
							}
						}
						else if (!sprite.facingRight == true) {
							if(z == 0) {
		
								sprite.bitmap = new Bitmap( 
									myRes[AGResources.NAME_MONSTER_L0_PNG].bitmapData.clone());//
								sprite.bitmap.x = (myMode.myHoriz * 16 ) + sprite.x - scrollx;
								sprite.bitmap.y = sprite.y - scrolly;
								myStage.addChild(sprite.bitmap);
							}
							else if (z == 1 ) {
		
								sprite.bitmap = new Bitmap( 
									myRes[AGResources.NAME_MONSTER_L1_PNG].bitmapData.clone());//
								sprite.bitmap.x = (myMode.myHoriz * 16 ) + sprite.x - scrollx;
								sprite.bitmap.y = sprite.y - scrolly;
								myStage.addChild(sprite.bitmap);
							}
						}
					}
				}
				//
				break;
			}
		}

	}
	
}
