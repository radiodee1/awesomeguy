package org.davidliebman.flash.awesomeguy {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	
	
	public class AGSpriteTorpedo extends AGSprite {

		var startx:int, starty:int;
		var startedOnce:Boolean = false;

		public function AGSpriteTorpedo(mymode:AGMode, kind:int):void {
			super(mymode,kind);
			
			active = false;
		}
		public override function updateSprite():void {
				
				var  ii:int, jj:int, kk:int, ll:int, add:int;
				var flag:Boolean = false;
				var long:Boolean = false;
				var guy:Boolean = false;
				var SCREEN_WIDTH:int = myMode.SCREEN_WIDTH;
				var SCREEN_HEIGHT:int = myMode.SCREEN_HEIGHT;
				
				if (myMode.myGame.gameHealth >= 60 && 
					myMode.myGame.gameMode == AGGame.MODE_GUY) long = true;
					
				//trace("long",long);
					
				if (myMode.myGame.gameMode == AGGame.MODE_GUY) guy = true;
				
				jj = 4;
				
				
				if (! myMode.animate_only ) {
					if (startedOnce == false) {
						//startedOnce = true;
						startx = x;
						starty = y;
					}
					
					
					if (this.active == true ) {
						//this.limit = this.limit + jj;
					}
					else {
						return;
					}
					
					//this.quality_1 = jj;
					if (myMode.facingRight != this.facingRight) {  
						this.visible = false;
						this.active = false;
						return;
					}
						if (myMode.facingRight) { 
							this.quality_0 = AGMode.X_MOVE *jj;
							this.x += this.quality_0;
						}
						else if (!myMode.facingRight ){ 
							this.quality_0 = - (AGMode.X_MOVE * jj);
							this.x += this.quality_0;
						}
						
						/////////////////////
						if (myMode.facingRight && long) { 
							this.quality_0 = SCREEN_WIDTH - this.x;
							this.x += 0;
						}
						else if (!myMode.facingRight && long){ 
							this.quality_0 = - (this.x);
							this.x += this.quality_0;
						}
					
					
						
						if(this.facingRight && !guy) {
							
							if (x - startx > AGMode.LASER_WIDTH *4) this.active = false;
						}
						else if (!guy) {
							if (startx - x > AGMode.LASER_WIDTH *4) this.active = false;
						}
						
						//if (long == true) add = SCREEN_WIDTH;
						//else add = this.quality_0;
						
					this.bitmap = new Bitmap(new BitmapData(Math.abs(this.quality_0) ,  2, true, 0xffffffff));
					
					if (!startedOnce) startedOnce = true;
					
				//}
			}
		}
		public override function pruneSprite():void {
			super.pruneSprite();
			active = false;
			visible = false;
		}


	}
	
}
