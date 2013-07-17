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
				if (sprite.active == true) myStage.addChild(sprite.bitmap);
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
				//////////////////////////////////////////
				case AGMode.D_EXPLOSION_SPRITE:
				
				
				//i = spriteNum;
				var x:int, y:int ;
				var wait:int = 20;
				y = sprite.y - 32;
				x = sprite.x;
		
				//trace("boom start");
				
		
				add = 0;
		
				if(scrollx < sprite.x + 64*2) {
					add = 0;
				}
				else if (scrollx >= sprite.x ) {
					add = myMode.myHoriz * 16;
				}
				
				//
				if (sprite.timerDone() ){// ||  sprite.timer.started == false) {
		
					//LOGE("explosion %d ", flyer_explosion);
		
					switch (sprite.quality_3) {
					case 0:
						
						//drawSprite_64(explosion_a, x + add, y, scrollx, scrolly, PAINT_TRANSPARENT, 0);
						sprite.bitmap = myRes[AGResources.NAME_EXPLOSION_A];
						break;
					case 1:
						//drawSprite_64(explosion_b, x + add, y, scrollx, scrolly, PAINT_TRANSPARENT, 0);
						sprite.bitmap = myRes[AGResources.NAME_EXPLOSION_B];

						break;
		
					case 2:
						//drawSprite_64(explosion_c, x + add, y, scrollx, scrolly, PAINT_TRANSPARENT, 0);
						sprite.bitmap = myRes[AGResources.NAME_EXPLOSION_C];
		
						break;
					case 3:
						//drawSprite_64(explosion_d, x + add, y, scrollx, scrolly, PAINT_TRANSPARENT, 0);
						sprite.bitmap = myRes[AGResources.NAME_EXPLOSION_D];
						
						break;
					case 4:
						//drawSprite_64(explosion_e, x + add, y, scrollx, scrolly, PAINT_TRANSPARENT, 0);
						sprite.bitmap = myRes[AGResources.NAME_EXPLOSION_E];
						
						break;
					case 5:
						//drawSprite_64(explosion_f, x + add, y, scrollx, scrolly, PAINT_TRANSPARENT, 0);
						sprite.bitmap = myRes[AGResources.NAME_EXPLOSION_F];
						
						break;
		
					case 6:
						//drawSprite_64(explosion_g, x + add, y, scrollx, scrolly, PAINT_TRANSPARENT, 0);
						sprite.bitmap = myRes[AGResources.NAME_EXPLOSION_G];
						
						break;
					case 7:
						//drawSprite_64(explosion_h, x + add, y, scrollx, scrolly, PAINT_TRANSPARENT, 0);
						//sprite[i].active = FALSE;
						sprite.bitmap = myRes[AGResources.NAME_EXPLOSION_H];
						//myMode.game_death = true;
						
						break;
					}
					
					sprite.bitmap.x = x - scrollx + add;
					sprite.bitmap.y = y - scrolly;
					myStage.addChild(sprite.bitmap);
					
					
					if (sprite.quality_3 > 7) {
						//sprite[i].quality_3 = -1;
						//endlevel = TRUE;
						//gamedeath = TRUE;
						sprite.active = false;
						//sprite.sprite_type = AGMode.S_NONE;
						myMode.game_death = true;
					}
					sprite.quality_3 ++;
					sprite.timerStart( wait/1000 );/// 100);
					//}
				}
				
				break;
				///////////
				case AGMode.D_CLOUD:
		
					if(scrollx < sprite.x + 80) {
						
				  		sprite.bitmap = new Bitmap( 
									myRes[AGResources.NAME_CLOUD_PNG].bitmapData.clone());//
								sprite.bitmap.x =  sprite.x - scrollx;
								sprite.bitmap.y = sprite.y - scrolly;
								//
				  
				  }
				  else {//if (scrollx >= sprite.x ) {
						
						sprite.bitmap = new Bitmap( 
									myRes[AGResources.NAME_CLOUD_PNG].bitmapData.clone());//
								sprite.bitmap.x = (myMode.myHoriz * 16 ) + sprite.x - scrollx;
								sprite.bitmap.y = sprite.y - scrolly;
								//
				  }
					
					myStage.addChild(sprite.bitmap);
					
				break;
				case AGMode.D_LINE_1:
				
					myStage.addChild(sprite.shape);
				break;
				
				case AGMode.D_BUBBLE_1:
				case AGMode.D_BUBBLE_2:
				case AGMode.D_BUBBLE_3:
					if (scrollx < sprite.x + (sprite.radius * 2)) {
						sprite.bitmap.x = sprite.x - scrollx - (sprite.limit * 2);
					}
					else {
						sprite.bitmap.x = sprite.x - scrollx - (sprite.limit * 2) + (myMode.myHoriz * 16);
					}
					sprite.bitmap.y = sprite.y - (sprite.limit * 2) - scrolly;
					myStage.addChild(sprite.bitmap);
				break;
				case AGMode.D_RING:
					if (scrollx < sprite.x + (16)) {
						sprite.bitmap.x = (sprite.x - scrollx );
					}
					else {
						sprite.bitmap.x = sprite.x - scrollx  + (myMode.myHoriz * 16);
					}
					sprite.bitmap.y = sprite.y - scrolly;
					myStage.addChild(sprite.bitmap);
				break;
				
				case AGMode.D_TORPEDO:
					if (myMode.xx > 0) sprite.quality_0 = AGMode.X_MOVE * sprite.quality_1;
					else if (myMode.xx < 0 ) sprite.quality_0 = - (AGMode.X_MOVE * sprite.quality_1);
					else sprite.quality_0 = 0;
					if (scrollx < sprite.x + (8)) {
						sprite.bitmap.x = (sprite.x - scrollx ) + sprite.quality_0 ;
					}
					else {
						sprite.bitmap.x = sprite.x - scrollx  + (myMode.myHoriz * 16) + sprite.quality_0;
					}
					sprite.bitmap.y = sprite.y - scrolly + AGMode.LASER_GUN;
					myStage.addChild(sprite.bitmap);
					
					//sprite.pruneSprite();
				break;
				
			}
		}

	}
	
}
