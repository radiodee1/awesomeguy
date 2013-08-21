package  org.davidliebman.flash.awesomeguy {
	import flash.display.*;
	
	public class AGDrawFlyer extends AGDraw {
		var TILE_HEIGHT:int = 16;
		var TILE_WIDTH:int = 16;
		var mysprite:Sprite;
		var anim:int = 0; // for flyer rings
		var max_rings:int = 0;// for flyer rings

		var add:int, add_radar:int, z:int;
		var scrollx:int =0;
		var scrolly:int = 0;
		var anim_speed:int = 5;
		var sprite:AGSprite = new AGSprite(null, 0);
		var xx:int = 0;
		var yy:int = 0;
		var facingRight:Boolean = false;
		var kind:int, animate:int;

		public override function AGDrawFlyer(mode:AGMode, myres:Array, mystage:Stage, mybackground:Bitmap) {
			// constructor code
			super(mode,myres,mystage,mybackground);
		}
		
		public override function drawBasicSprite(sprite:AGSprite, kind:int):void {
			
			try {
				drawRes(sprite, sprite.x, sprite.y, sprite.facingRight, kind, sprite.animate);
			}
			catch(err:Error) {
				trace("null pointer error??");
			}
		}
		
		public override function drawRes(sprite:AGSprite, xx:int, yy:int, facingRight:Boolean, kind:int, animate:int):void {
			// all drawing goes here!!
			
			this.sprite = sprite;
			this.xx = xx;
			this.yy = yy;
			this.facingRight = facingRight;
			this.animate = animate;
			this.kind = kind;
			
			// init some vars here
			//var add:int, add_radar:int, z:int;
			
			scrollx = myMode.scrollBGX;
			scrolly = myMode.scrollBGY;
			anim_speed = 5;
			
			switch (kind) {
				case AGMode.D_NONE:
					break;
				case AGMode.D_FLYER:
					drawFlyer();
				
				
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
				case AGMode.D_EXPLOSION:
				
				drawExplosion();
				
				
				
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
					
					if (sprite.active == true && sprite != null && sprite.bitmap != null) {
					//trace("before");
						myStage.addChild(sprite.bitmap);
					//trace("after");
					}
					
					//myStage.addChild(sprite.bitmap);
				break;
				case AGMode.D_RING:
					if (scrollx < sprite.x + (16)) {
						sprite.bitmap.x = (sprite.x - scrollx );
					}
					else {
						sprite.bitmap.x = sprite.x - scrollx  + (myMode.myHoriz * 16);
					}
					sprite.bitmap.y = sprite.y - scrolly;
					if (sprite.active == true && sprite != null && sprite.bitmap != null) {
					//trace("before");
						myStage.addChild(sprite.bitmap);
					//trace("after");
					}
					
					//myStage.addChild(sprite.bitmap);
				break;
				
				case AGMode.D_TORPEDO:
					if (sprite == null || sprite.bitmap == null ) return;
					
					if (sprite.facingRight) sprite.quality_2 = myMode.spriteWidth;
					else sprite.quality_2 = 0;
					
					if (scrollx < sprite.x + (8)) {
						sprite.bitmap.x = (sprite.x - scrollx ) - sprite.quality_2 ;
					}
					else {
						sprite.bitmap.x = sprite.x - scrollx  + (myMode.myHoriz * 16) - sprite.quality_2;
					}
					
					sprite.bitmap.y = sprite.y - scrolly + AGMode.LASER_GUN;
					if (sprite.active == true && sprite != null && sprite.bitmap != null) {
					//trace("before");
						myStage.addChild(sprite.bitmap);
					//trace("after");
					}
					
					//myStage.addChild(sprite.bitmap);
					
					//sprite.pruneSprite();
				break;
				
				case AGMode.D_INVADER_1:
					if (sprite.animate == 0) {
						sprite.bitmap = new Bitmap( 
									myRes[AGResources.NAME_ROLLEE_A_PNG].bitmapData.clone());//
					}
					else if (sprite.animate == 1) {
						sprite.bitmap = new Bitmap( 
									myRes[AGResources.NAME_ROLLEE_B_PNG].bitmapData.clone());//				
					}
									
					if (scrollx < sprite.x + (16)) {
						sprite.bitmap.x = (sprite.x - scrollx )  ;
					}
					else {
						sprite.bitmap.x = sprite.x - scrollx  + (myMode.myHoriz * 16) ;
					}
					sprite.bitmap.y = sprite.y - scrolly ;
					//myStage.addChild(sprite.bitmap);
					if (sprite.active == true && sprite != null && sprite.bitmap != null) {
					//trace("before");
						myStage.addChild(sprite.bitmap);
					//trace("after");
					}
					
					
				break;
				
				case AGMode.D_INVADER_2:
					if (!sprite.facingRight) {
						sprite.bitmap = new Bitmap( 
									myRes[AGResources.NAME_INV2_L_PNG].bitmapData.clone());//
					}
					else if (sprite.facingRight) {
						sprite.bitmap = new Bitmap( 
									myRes[AGResources.NAME_INV2_R_PNG].bitmapData.clone());//				
					}
									
					if (scrollx < sprite.x + (16)) {
						sprite.bitmap.x = (sprite.x - scrollx )  ;
					}
					else {
						sprite.bitmap.x = sprite.x - scrollx  + (myMode.myHoriz * 16) ;
					}
					sprite.bitmap.y = sprite.y - scrolly ;
					myStage.addChild(sprite.bitmap);
					
				break;
				case AGMode.D_EXPLOSION_SPRITE:
				
				try {
					
				var x:int, y:int ;
				var wait:int = 20;
				
				//i = spriteNum;
				//var x:int, y:int ;
				wait = 20;
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
						//sprite.bitmap = myRes[AGResources.NAME_EXPLOSION_A];
						sprite.bitmap = new Bitmap( 
									myRes[AGResources.NAME_EXPLOSION_A].bitmapData.clone());
						break;
					case 1:
						//drawSprite_64(explosion_b, x + add, y, scrollx, scrolly, PAINT_TRANSPARENT, 0);
						//sprite.bitmap = myRes[AGResources.NAME_EXPLOSION_B];
						sprite.bitmap = new Bitmap( 
									myRes[AGResources.NAME_EXPLOSION_B].bitmapData.clone());
						break;
		
					case 2:
						//drawSprite_64(explosion_c, x + add, y, scrollx, scrolly, PAINT_TRANSPARENT, 0);
						//sprite.bitmap = myRes[AGResources.NAME_EXPLOSION_C];
						sprite.bitmap = new Bitmap( 
									myRes[AGResources.NAME_EXPLOSION_C].bitmapData.clone());		
						break;
					case 3:
						//drawSprite_64(explosion_d, x + add, y, scrollx, scrolly, PAINT_TRANSPARENT, 0);
						//sprite.bitmap = myRes[AGResources.NAME_EXPLOSION_D];
						sprite.bitmap = new Bitmap( 
									myRes[AGResources.NAME_EXPLOSION_D].bitmapData.clone());
						break;
					case 4:
						//drawSprite_64(explosion_e, x + add, y, scrollx, scrolly, PAINT_TRANSPARENT, 0);
						//sprite.bitmap = myRes[AGResources.NAME_EXPLOSION_E];
						sprite.bitmap = new Bitmap( 
									myRes[AGResources.NAME_EXPLOSION_E].bitmapData.clone());
						break;
					case 5:
						//drawSprite_64(explosion_f, x + add, y, scrollx, scrolly, PAINT_TRANSPARENT, 0);
						//sprite.bitmap = myRes[AGResources.NAME_EXPLOSION_F];
						sprite.bitmap = new Bitmap( 
									myRes[AGResources.NAME_EXPLOSION_F].bitmapData.clone());
						break;
		
					case 6:
						//drawSprite_64(explosion_g, x + add, y, scrollx, scrolly, PAINT_TRANSPARENT, 0);
						//sprite.bitmap = myRes[AGResources.NAME_EXPLOSION_G];
						sprite.bitmap = new Bitmap( 
									myRes[AGResources.NAME_EXPLOSION_G].bitmapData.clone());
						break;
					case 7:
						//drawSprite_64(explosion_h, x + add, y, scrollx, scrolly, PAINT_TRANSPARENT, 0);
						//sprite[i].active = FALSE;
						//sprite.bitmap = myRes[AGResources.NAME_EXPLOSION_H];
						//myMode.game_death = true;
						sprite.bitmap = new Bitmap( 
									myRes[AGResources.NAME_EXPLOSION_H].bitmapData.clone());
						break;
					}
					
					sprite.bitmap.x = x - scrollx + add;
					sprite.bitmap.y = y - scrolly;
					//myStage.addChild(sprite.bitmap);
					if (sprite.active == true && sprite != null && sprite.bitmap != null) {
					//trace("before");
						myStage.addChild(sprite.bitmap);
					//trace("after");
					}
					
					if (sprite.quality_3 > 7) {
						//sprite[i].quality_3 = -1;
						//endlevel = TRUE;
						//gamedeath = TRUE;
						sprite.active = false;
						sprite.visible = false;
						//sprite.sprite_type = AGMode.S_NONE;
						
					}
					sprite.quality_3 ++;
					sprite.timerStart( wait/1000 );/// 100);
					//}
					
				}
				
				} catch (err:Error) {
					trace("sprite explosion disaster");
					return;
				}
				
				break;
				
				case AGMode.D_FLYER_RINGS:
				
					if (myMode.myChallenge[myMode.myGame.gameChallenge] == null) {
						trace("array disaster");
						return;
					}
				
				
					max_rings = myMode.myChallenge[myMode.myGame.gameChallenge].total_held_rings;
					
					if(max_rings == 0) return;
					//sprite.bitmap = new Bitmap();
					
					anim = myMode.animate;
					if (anim > 8) anim = 0;
					if (anim == 0 || anim == 1 || anim == 8 ) {
						sprite.bitmap = myMode.cutTile(myMode.myRes[AGResources.NAME_TILES1_PNG],
													   AGModeFlyer.B_PRIZE,AGMode.TILE_TOP);
						//cutTile(tiles_a, square, B_PRIZE - levelcheat );
						//trace(anim);
					}
					else if (anim == 2 || anim == 4 || anim == 6) {
						sprite.bitmap = myMode.cutTile(myMode.myRes[AGResources.NAME_TILES2_PNG],
													   AGModeFlyer.B_PRIZE,AGMode.TILE_TOP);

						//cutTile(tiles_b, square, B_PRIZE - levelcheat);
					}
					else if (anim == 3 || anim == 7) {
						sprite.bitmap = myMode.cutTile(myMode.myRes[AGResources.NAME_TILES3_PNG],
													   AGModeFlyer.B_PRIZE,AGMode.TILE_TOP);
			
						//cutTile(tiles_c, square, B_PRIZE -levelcheat);
					}
					else if (anim == 5) {
						sprite.bitmap = myMode.cutTile(myMode.myRes[AGResources.NAME_TILES4_PNG],
													   AGModeFlyer.B_PRIZE,AGMode.TILE_TOP);
			
						//cutTile(tiles_d, square, B_PRIZE - levelcheat);
					}
			
			
					add = 0;
			
					if(scrollx < myMode.xpos  ) {
						add = 0;
					}
					else if (scrollx >= myMode.xpos  ) {
						add = myMode.myHoriz * 16;
					}
			
					if (max_rings > 3) max_rings = 3;
			
					for (var xx:int = 0; xx < max_rings; xx ++ ) {
						var bits:Bitmap = new Bitmap(sprite.bitmap.bitmapData.clone());
						bits.x = myMode.xpos + add + (xx * 17) - scrollx;
						bits.y = myMode.ypos + myMode.agflyer.bottomBB  - 3 - scrolly;
						
						if ( bits != null) {
							//trace("before");
							myStage.addChild(bits);
							//trace("after");
						}
						//
						//drawTile_8(square, flyer.x + add + ( x * 9), flyer.y + flyer.bottomBB - 3 ,
						//		scrollx , scrolly, PAINT_TRANSPARENT, 0);
					}

				break;
				
				case AGMode.D_GOAL:
					if (scrollx < sprite.x + (16)) {
						sprite.bitmap.x = (sprite.x - scrollx );
					}
					else {
						sprite.bitmap.x = sprite.x - scrollx  + (myMode.myHoriz * 16);
					}
					sprite.bitmap.y = sprite.y - scrolly;
					//myStage.addChild(sprite.bitmap);
					if (sprite.active == true && sprite != null && sprite.bitmap != null) {
					//trace("before");
						myStage.addChild(sprite.bitmap);
					//trace("after");
					}
					
				break;
				
				case AGMode.D_PYRAMID:
				
				try {
					if (sprite.animate == 0) {
						sprite.bitmap = new Bitmap( 
									myRes[AGResources.NAME_PYRAMID_0_PNG].bitmapData.clone());//
					}
					if (sprite.animate == 1) {
						sprite.bitmap = new Bitmap( 
									myRes[AGResources.NAME_PYRAMID_1_PNG].bitmapData.clone());//
					}
					if (sprite.animate == 2) {
						sprite.bitmap = new Bitmap( 
									myRes[AGResources.NAME_PYRAMID_2_PNG].bitmapData.clone());//
					}
					if (sprite.animate == 3) {
						sprite.bitmap = new Bitmap( 
									myRes[AGResources.NAME_PYRAMID_3_PNG].bitmapData.clone());//
					}
					if (sprite.animate == 4) {
						sprite.bitmap = new Bitmap( 
									myRes[AGResources.NAME_PYRAMID_4_PNG].bitmapData.clone());//
					}
									
					if (scrollx < sprite.x + ( 8 * 16)) {
						sprite.bitmap.x = (sprite.x - scrollx )  ;
					}
					else {
						sprite.bitmap.x = sprite.x - scrollx  + (myMode.myHoriz * 16) ;
					}
					sprite.bitmap.y = sprite.y - scrolly - ( 7 * 16) ;
					//myStage.addChild(sprite.bitmap);
					
					if (sprite.active == true && sprite != null && sprite.bitmap != null) {
					//trace("before");
						myStage.addChild(sprite.bitmap);
					//trace("after");
					}
					
				} catch (err:Error) {
					trace("pyramid disaster");
					return;
				}
				break;
				
				case AGMode.D_BUNKER :
					drawBunker();
				break;
				case AGMode.D_ASTROGATE:
					drawAstrogate();
				break;
			}
		}

		public function drawExplosion():void {
			
				
				try {
				
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
						if (sprite.active == true && sprite != null && sprite.bitmap != null) {
						//trace("before");
							myStage.addChild(sprite.bitmap);
						//trace("after");
						}
						
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
				
				} catch (err:Error) {
					trace("flyer disaster averted");
					return;
				}// catch
				
				return;
		}

		public function drawFlyer():void {
			
				try {
					add = 0;
					add_radar = 0;
	
					
					if (scrollx >= xx  ) {
						add = myMode.myHoriz * TILE_WIDTH;
						add_radar =  (xx - scrollx) - xx ;
					}
					
					if (facingRight) {
						if (myMode.is_blinking) {
							sprite.bitmap = myRes[AGResources.NAME_FLYER_WHITE_R];
						}
						
						else if (animate %2 == 1 ) {
							sprite.bitmap = myRes[AGResources.NAME_FLYER_R0_PNG];
	
						}
						else {
							sprite.bitmap = myRes[AGResources.NAME_FLYER_R1_PNG];
		
						}
					}
					else {
						if (myMode.is_blinking) {
							sprite.bitmap = myRes[AGResources.NAME_FLYER_WHITE_L];
						}
						else if (animate %2 == 1) {
							sprite.bitmap = myRes[AGResources.NAME_FLYER_L0_PNG];
	
						}
						else {
							sprite.bitmap = myRes[AGResources.NAME_FLYER_L1_PNG];
		
						}
					}
					sprite.bitmap.x = add + xx - scrollx;
					sprite.bitmap.y = yy - scrolly;
					if (sprite.active == true && sprite != null && sprite.bitmap != null) {
						//trace("before");
						myStage.addChild(sprite.bitmap);
						//trace("after");
					}
					myMode.flyersprite = sprite.bitmap;
				}catch (err:Error) {
					trace("draw flyer!!!!!!!!!!!!!!!");
				}
				return;
		}

		public function drawBunker():void {
			add = 0;
			add_radar = 0;

			
			if (scrollx >= xx  ) {
				add = myMode.myHoriz * TILE_WIDTH;
				add_radar =  (xx - scrollx) - xx ;
			}
			sprite.bitmap.x = add + xx - scrollx;
			sprite.bitmap.y = yy - scrolly;
			if (sprite.active == true && sprite != null && sprite.bitmap != null) {
				//trace("before");
				myStage.addChild(sprite.bitmap);
				//trace("after");
			}
		}
		public function drawAstrogate():void {
			add = 0;
			add_radar = 0;

			
			if (scrollx >= xx  ) {
				add = myMode.myHoriz * TILE_WIDTH;
				add_radar =  (xx - scrollx) - xx ;
			}
			sprite.bitmap.x = add + xx - scrollx;
			sprite.bitmap.y = yy - scrolly;
			if (sprite.active == true && sprite != null && sprite.bitmap != null) {
				//trace("before");
				myStage.addChild(sprite.bitmap);
				//trace("after");
			}

		}
	}
	
}
