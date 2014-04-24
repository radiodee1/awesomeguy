package org.davidliebman.flash.awesomeguy {
	import flash.display.Bitmap;
	import flash.display.Stage;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	
	public class AGDrawGuy extends AGDraw{
		var biteffect:AGBitEffect = new AGBitEffect();
		var biteffect_enable:Boolean = false;

		var cheatx_climb:int = 0;
		var cheaty_climb:int = 0;
		var cheatx_punch:int = 0;
		var cheaty_punch:int = 0;
		var cheatx_step:int = 8;
		var cheaty_step:int = 0;
		
		var sprite:AGSprite;
		
		var scrollx:int;// = myMode.scrollBGX;
		var scrolly:int;// = myMode.scrollBGY;
		
		var guywidth:int;
		var guyheight:int;

		public function AGDrawGuy(mode:AGMode, myres:Array, mystage:Stage, mybackground:Bitmap) {
			// constructor code
			
			super(mode,myres,mystage,mybackground);
		}

		public override function drawBasicSprite(sprite:AGSprite, kind:int):void {
			stageHelper = new Sprite();
			drawRes(sprite, sprite.x, sprite.y, sprite.facingRight, kind, sprite.animate);
			stageHelper.scrollRect = new Rectangle(0,0,512, (512 * 3/4));
			myStage.addChild(stageHelper);
		}

		public override function drawRes(sprite:AGSprite, xx:int, yy:int, facingRight:Boolean, kind:int, animate:int):void {
			// all drawing goes here!!
			
			var add:int, add_radar:int, z:int;
			scrollx = myMode.scrollBGX;
			scrolly = myMode.scrollBGY;
			var anim_speed:int = 5;
			var guyx:int, guyy:int;
			
			this.sprite = sprite;
			
			switch(kind) {
				case AGMode.D_GUY:
					
					switch(sprite.quality_0) {
						case AGModeGuy.GUY_CLIMB:
							if (sprite.animate % 2 == 1) {
								sprite.bitmap = myRes[AGResources.NAME_G_CLIMB1_PNG];
							}
							else {
								sprite.bitmap = myRes[AGResources.NAME_G_CLIMB2_PNG];
							}
						
						break;
						case AGModeGuy.GUY_PUNCH:
							if (sprite.facingRight) {
								if (sprite.animate %2 == 1) {
									sprite.bitmap = myRes[AGResources.NAME_G_PUNCHR1_PNG];
								}
								else {
									sprite.bitmap = myRes[AGResources.NAME_G_PUNCHR2_PNG];
								}
							}
							else {
								if(sprite.animate %2 == 1) {
									sprite.bitmap = myRes[AGResources.NAME_G_PUNCHL1_PNG];
								}
								else {
									sprite.bitmap = myRes[AGResources.NAME_G_PUNCHL2_PNG];
								}
							}
						break;
						case AGModeGuy.GUY_SHOOT:
							if (sprite.facingRight) {
								if (sprite.animate %2 == 1) {
									sprite.bitmap = myRes[AGResources.NAME_G_SHOOTR1_PNG];
								}
								else {
									sprite.bitmap = myRes[AGResources.NAME_G_SHOOTR2_PNG];
								}
							}
							else {
								if(sprite.animate %2 == 1) {
									sprite.bitmap = myRes[AGResources.NAME_G_SHOOTL1_PNG];
								}
								else {
									sprite.bitmap = myRes[AGResources.NAME_G_SHOOTL2_PNG];
								}
							}
						break;
						
						case AGModeGuy.GUY_STEP:
							if (sprite.facingRight) {
								if (sprite.animate %8 == 0 ) {
									sprite.bitmap = myRes[AGResources.NAME_G_STEPR1_PNG];
									//guyx = this.cheatx_step;
								}
								else if (sprite.animate %8 == 1) {
									sprite.bitmap = myRes[AGResources.NAME_G_STEPR2_PNG];
								}
								else if (sprite.animate %8 == 2) {
									sprite.bitmap = myRes[AGResources.NAME_G_STEPR3_PNG];
									//guyx = this.cheatx_step
								}
								else if (sprite.animate %8 == 3) {
									sprite.bitmap = myRes[AGResources.NAME_G_STEPR4_PNG];
								}
								else if (sprite.animate %8 == 4 ) {
									sprite.bitmap = myRes[AGResources.NAME_G_STEPR5_PNG];
									//guyx = this.cheatx_step;
								}
								else if (sprite.animate %8 == 5) {
									sprite.bitmap = myRes[AGResources.NAME_G_STEPR6_PNG];
								}
								else if (sprite.animate %8 == 6) {
									sprite.bitmap = myRes[AGResources.NAME_G_STEPR7_PNG];
									//guyx = this.cheatx_step
								}
								else if (sprite.animate %8 == 7) {
									sprite.bitmap = myRes[AGResources.NAME_G_STEPR8_PNG];
									
								}
							}
							else {
								if (sprite.animate %8 == 0 ) {
									sprite.bitmap = myRes[AGResources.NAME_G_STEPL1_PNG];
									//guyx = this.cheatx_step;
								}
								else if (sprite.animate %8 == 1) {
									sprite.bitmap = myRes[AGResources.NAME_G_STEPL2_PNG];
								}
								else if (sprite.animate %8 == 2) {
									sprite.bitmap = myRes[AGResources.NAME_G_STEPL3_PNG];
									//guyx = this.cheatx_step
								}
								else if (sprite.animate %8 == 3) {
									sprite.bitmap = myRes[AGResources.NAME_G_STEPL4_PNG];
								}
								else if (sprite.animate %8 == 4 ) {
									sprite.bitmap = myRes[AGResources.NAME_G_STEPL5_PNG];
									//guyx = this.cheatx_step;
								}
								else if (sprite.animate %8 == 5) {
									sprite.bitmap = myRes[AGResources.NAME_G_STEPL6_PNG];
								}
								else if (sprite.animate %8 == 6) {
									sprite.bitmap = myRes[AGResources.NAME_G_STEPL7_PNG];
									//guyx = this.cheatx_step
								}
								else if (sprite.animate %8 == 7) {
									sprite.bitmap = myRes[AGResources.NAME_G_STEPL8_PNG];
								}
							}
						break;
						case AGModeGuy.GUY_STILL:
							//trace("still", sprite.animate);
						break;
						case AGModeGuy.GUY_CROUCH:
							
							if (sprite.facingRight) {
								sprite.bitmap = myRes[AGResources.NAME_G_CROUCHR1_PNG];
								
							}
							else {
								sprite.bitmap = myRes[AGResources.NAME_G_CROUCHL1_PNG];
							}
						break;
					}
					
					
					sprite.bitmap.x =  xx - scrollx + guyx;
					sprite.bitmap.y = yy - scrolly + guyy;
					this.guywidth = sprite.bitmap.width;
					this.guyheight = sprite.bitmap.height;
					makeRails(sprite);
					
					var tempMap:Bitmap = sprite.bitmap;
					
					if (this.biteffect_enable && sprite.active) {
						tempMap = this.biteffect.swishBits(sprite.bitmap); 
					}
					tempMap.x = sprite.bitmap.x;
					tempMap.y = sprite.bitmap.y;
					
					if (sprite.active == true) stageHelper.addChild(tempMap);//(sprite.bitmap);
					myMode.flyersprite = sprite.bitmap;
					
				break;
				case AGMode.D_XMONSTER:
					drawXMonster();
				break;
				case AGMode.D_KEY:
					drawKey();
				break;
				
				case AGMode.D_RING:
					drawRing();
				break;
				
				case AGMode.D_GUN:
				case AGMode.D_GOAL:
				case AGMode.D_EXIT:
				case AGMode.D_PLATFORM:
					this.drawXVarious();
				break;
				
				case AGMode.D_TORPEDO:
					drawTorpedo();
				break;
			}
			
		}
		public function makeRails(sprite:AGSprite):void {
			var vertical:BitmapData = new BitmapData(2,guyheight - AGModeGuy.Y_MOVE,true,0x00ff0000);
			var horizontal:BitmapData = new BitmapData(guywidth - AGModeGuy.X_MOVE, 2,true,0x00ff0000);
			
			this.rail_bottom = new Bitmap(horizontal);
			this.rail_top = new Bitmap(horizontal);
			this.rail_left = new Bitmap(vertical);
			this.rail_right = new Bitmap(vertical);
			this.rail_low_bottom = new Bitmap(horizontal);
			
			this.rail_bottom.x = sprite.bitmap.x + (AGModeGuy.X_MOVE/ 2) ;
			this.rail_bottom.y = sprite.bitmap.y + sprite.bitmap.height +  (AGModeGuy.Y_MOVE/2);
			
			this.rail_low_bottom.x = sprite.bitmap.x + (AGModeGuy.X_MOVE/ 2) ;
			this.rail_low_bottom.y = sprite.bitmap.y + sprite.bitmap.height +  (AGModeGuy.Y_MOVE *2);
			
			
			this.rail_left.x = sprite.bitmap.x - (AGModeGuy.X_MOVE/2);
			this.rail_left.y = sprite.bitmap.y + (AGModeGuy.Y_MOVE/ 2);
			
			this.rail_right.x = sprite.bitmap.x + sprite.bitmap.width + (AGModeGuy.X_MOVE/2);
			this.rail_right.y = sprite.bitmap.y + (AGModeGuy.Y_MOVE/2) ;
			
			this.rail_top.x = sprite.bitmap.x + (AGModeGuy.X_MOVE/2);
			this.rail_top.y = sprite.bitmap.y - ( AGModeGuy.Y_MOVE/2);
			
			myStage.addChild(this.rail_bottom);
			myStage.addChild(this.rail_left);
			myStage.addChild(this.rail_right);
			myStage.addChild(this.rail_top);
			
		}
		
		public function drawXMonster():void {
				var anim_speed:int = 5;
				var add:int, add_radar:int, z:int;

				var ycheat:int = 17;
				sprite.animate ++;
				if (sprite.animate > (anim_speed * 4) ) sprite.animate=0;
				if (sprite.animate > anim_speed * 2) z = 1;
				else z = 0;
				
		
				if(sprite.visible == true && sprite.sprite_type == AGMode.S_XMONSTER) {
					if ( true ) {
						//trace (sprite.animate);
						if(sprite.facingRight == true) {
							if(z == 0) {
								
								sprite.bitmap = new Bitmap( 
									myRes[AGResources.NAME_CRAWLER_R1_PNG].bitmapData.clone());
								sprite.bitmap.x = sprite.x - scrollx;
								sprite.bitmap.y = sprite.y - scrolly + ycheat;
								stageHelper.addChild(sprite.bitmap);
		
							}
							else if (z == 1 ) {
								
								sprite.bitmap = new Bitmap( 
									myRes[AGResources.NAME_CRAWLER_R2_PNG].bitmapData.clone());//
								sprite.bitmap.x = sprite.x - scrollx;
								sprite.bitmap.y = sprite.y - scrolly;
								stageHelper.addChild(sprite.bitmap);
							}
						}
						else if (!sprite.facingRight == true) {
							if(z == 0) {
		
								sprite.bitmap = new Bitmap( 
									myRes[AGResources.NAME_CRAWLER_L1_PNG].bitmapData.clone());//
								sprite.bitmap.x = sprite.x - scrollx;
								sprite.bitmap.y = sprite.y - scrolly + ycheat;
								stageHelper.addChild(sprite.bitmap);
							}
							else if (z == 1) {
		
								sprite.bitmap = new Bitmap( 
									myRes[AGResources.NAME_CRAWLER_L2_PNG].bitmapData.clone());//
								sprite.bitmap.x = sprite.x - scrollx;
								sprite.bitmap.y = sprite.y - scrolly;
								stageHelper.addChild(sprite.bitmap);
							}
						}
					}
					
				}
				
				else if (sprite.sprite_type == AGMode.S_XMONSTER_STAND) {
					ycheat = -56;
					
					if ( true ) {
						//trace (sprite.animate);
						if(sprite.facingRight == true) {
							if(z == 0) {
								
								sprite.bitmap = new Bitmap( 
									myRes[AGResources.NAME_GATOR_PUNCH_R1_PNG].bitmapData.clone());
								sprite.bitmap.x = sprite.x - scrollx;
								sprite.bitmap.y = sprite.y - scrolly + ycheat;
								stageHelper.addChild(sprite.bitmap);
		
							}
							else if (z == 1 ) {
								
								sprite.bitmap = new Bitmap( 
									myRes[AGResources.NAME_GATOR_PUNCH_R2_PNG].bitmapData.clone());//
								sprite.bitmap.x = sprite.x - scrollx;
								sprite.bitmap.y = sprite.y - scrolly + ycheat;
								stageHelper.addChild(sprite.bitmap);
							}
						}
						else if (!sprite.facingRight == true) {
							if(z == 0) {
		
								sprite.bitmap = new Bitmap( 
									myRes[AGResources.NAME_GATOR_PUNCH_L1_PNG].bitmapData.clone());//
								sprite.bitmap.x = sprite.x - scrollx;
								sprite.bitmap.y = sprite.y - scrolly + ycheat;
								stageHelper.addChild(sprite.bitmap);
							}
							else if (z == 1) {
		
								sprite.bitmap = new Bitmap( 
									myRes[AGResources.NAME_GATOR_PUNCH_L2_PNG].bitmapData.clone());//
								sprite.bitmap.x = sprite.x - scrollx;
								sprite.bitmap.y = sprite.y - scrolly + ycheat;
								stageHelper.addChild(sprite.bitmap);
							}
						}
					}
				}
				
			//trace("draw xmonster");
			return;
		}

		public function drawKey() {
			sprite.bitmap.x = sprite.x - scrollx;
			sprite.bitmap.y = sprite.y - scrolly ;
			stageHelper.addChild(sprite.bitmap);
			
		}

		public function drawRing() {
			
			sprite.bitmap.x = (sprite.x - scrollx );
			
			
			sprite.bitmap.y = sprite.y - scrolly;
			if (sprite.active == true && sprite != null && sprite.bitmap != null) {
			//trace("before");
				stageHelper.addChild(sprite.bitmap);
			
			}//if
					
					//myStage.addChild(sprite.bitmap);
		}
		
		public function drawXVarious() {
			
			if (sprite.bitmap == null) return;
			sprite.bitmap.x = (sprite.x - scrollx );
			sprite.bitmap.y = sprite.y - scrolly;
			if (sprite.active == true && sprite != null && sprite.bitmap != null) {
			//trace("before");
				stageHelper.addChild(sprite.bitmap);
			
			}//if
		}

		public function drawTorpedo() {
			if (sprite == null || sprite.bitmap == null ) return;
					
			if (sprite.facingRight) sprite.quality_2 = myMode.spriteWidth;
			else sprite.quality_2 = 0;
			
			if (this.myMode.myGame.gameMode == AGGame.MODE_FLYER) {
				sprite.bitmap.x = (sprite.x - scrollx ) - sprite.quality_2 ;
			}
			else sprite.bitmap.x = (sprite.x - scrollx ) ;
			
			
			//sprite.bitmap.x = (sprite.x - scrollx ) - sprite.quality_2 ;
			
			sprite.bitmap.y = sprite.y - scrolly + 50;
			if (sprite.active == true && sprite != null && sprite.bitmap != null) {
			
				stageHelper.addChild(sprite.bitmap);
			
			}
		}
		
		public function setBitEffectEnable(xx:Boolean):void {
			this.biteffect_enable = xx;
		}

	}
	
}
