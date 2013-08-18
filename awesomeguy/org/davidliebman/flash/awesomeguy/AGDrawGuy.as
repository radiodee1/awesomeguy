package org.davidliebman.flash.awesomeguy {
	import flash.display.Bitmap;
	import flash.display.Stage;
	import flash.display.BitmapData;
	
	public class AGDrawGuy extends AGDraw{

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
			drawRes(sprite, sprite.x, sprite.y, sprite.facingRight, kind, sprite.animate);
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
						case AGModeGuy.GUY_STEP:
							if (sprite.facingRight) {
								if (sprite.animate %2 == 1 ) {
									sprite.bitmap = myRes[AGResources.NAME_G_STEPR1_PNG];
									guyx = this.cheatx_step;
								}
								else {
									sprite.bitmap = myRes[AGResources.NAME_G_STEPR2_PNG];
								}
							}
							else {
								if (sprite.animate %2 == 1) {
									sprite.bitmap = myRes[AGResources.NAME_G_STEPL1_PNG];
									guyx =  this.cheatx_step;
								}
								else {
									sprite.bitmap = myRes[AGResources.NAME_G_STEPL2_PNG];
								}
							}
						break;
						case AGModeGuy.GUY_STILL:
						break;
					}
					
					
					sprite.bitmap.x =  xx - scrollx + guyx;
					sprite.bitmap.y = yy - scrolly + guyy;
					this.guywidth = sprite.bitmap.width;
					this.guyheight = sprite.bitmap.height;
					makeRails(sprite);
					
					if (sprite.active == true) myStage.addChild(sprite.bitmap);
					myMode.flyersprite = sprite.bitmap;
					
				break;
				case AGMode.D_XMONSTER:
					drawXMonster();
				break;
				case AGMode.D_KEY:
					drawKey();
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
			
			this.rail_bottom.x = sprite.bitmap.x + (AGModeGuy.X_MOVE/ 2) ;
			this.rail_bottom.y = sprite.bitmap.y + sprite.bitmap.height +  (AGModeGuy.Y_MOVE/2);
			
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
								myStage.addChild(sprite.bitmap);
		
							}
							else if (z == 1 ) {
								
								sprite.bitmap = new Bitmap( 
									myRes[AGResources.NAME_CRAWLER_R2_PNG].bitmapData.clone());//
								sprite.bitmap.x = sprite.x - scrollx;
								sprite.bitmap.y = sprite.y - scrolly;
								myStage.addChild(sprite.bitmap);
							}
						}
						else if (!sprite.facingRight == true) {
							if(z == 0) {
		
								sprite.bitmap = new Bitmap( 
									myRes[AGResources.NAME_CRAWLER_L1_PNG].bitmapData.clone());//
								sprite.bitmap.x = sprite.x - scrollx;
								sprite.bitmap.y = sprite.y - scrolly + ycheat;
								myStage.addChild(sprite.bitmap);
							}
							else if (z == 1) {
		
								sprite.bitmap = new Bitmap( 
									myRes[AGResources.NAME_CRAWLER_L2_PNG].bitmapData.clone());//
								sprite.bitmap.x = sprite.x - scrollx;
								sprite.bitmap.y = sprite.y - scrolly;
								myStage.addChild(sprite.bitmap);
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
								myStage.addChild(sprite.bitmap);
		
							}
							else if (z == 1 ) {
								
								sprite.bitmap = new Bitmap( 
									myRes[AGResources.NAME_GATOR_PUNCH_R2_PNG].bitmapData.clone());//
								sprite.bitmap.x = sprite.x - scrollx;
								sprite.bitmap.y = sprite.y - scrolly + ycheat;
								myStage.addChild(sprite.bitmap);
							}
						}
						else if (!sprite.facingRight == true) {
							if(z == 0) {
		
								sprite.bitmap = new Bitmap( 
									myRes[AGResources.NAME_GATOR_PUNCH_L1_PNG].bitmapData.clone());//
								sprite.bitmap.x = sprite.x - scrollx;
								sprite.bitmap.y = sprite.y - scrolly + ycheat;
								myStage.addChild(sprite.bitmap);
							}
							else if (z == 1) {
		
								sprite.bitmap = new Bitmap( 
									myRes[AGResources.NAME_GATOR_PUNCH_L2_PNG].bitmapData.clone());//
								sprite.bitmap.x = sprite.x - scrollx;
								sprite.bitmap.y = sprite.y - scrolly + ycheat;
								myStage.addChild(sprite.bitmap);
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
			myStage.addChild(sprite.bitmap);
			trace("key");
		}

	}
	
}
