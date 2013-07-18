﻿package org.davidliebman.flash.awesomeguy {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	
	
	public class AGSpriteTorpedo extends AGSprite {

		var startx:int, starty:int;
		var startedOnce:Boolean = false;

		public function AGSpriteTorpedo(mymode:AGMode, kind:int):void {
			super(mymode,kind);
			
			active = true;
		}
		public override function updateSprite():void {
				
				var  ii:int, jj:int, kk:int, ll:int, add:int;
				var flag:Boolean = false;
				
				var SCREEN_WIDTH:int = myMode.SCREEN_WIDTH;
				var SCREEN_HEIGHT:int = myMode.SCREEN_HEIGHT;
				
				jj = 4;
				
				
				if (! myMode.animate_only ) {
					if (startedOnce == false) {
						startedOnce = true;
						startx = x;
						starty = y;
					}
					
					//for (ii = 0; ii < AGMode.TOTAL_TORPEDOS ; ii ++ ) {
					if (this.active == true ) {
						this.limit = this.limit + jj;
					}
					else {
						return;
					}
					
					this.quality_1 = jj;
					if (myMode.xx > 0) { 
						this.quality_0 = AGMode.X_MOVE * this.quality_1;
						this.x += this.quality_0;
					}
					else if (myMode.xx < 0 ){ 
						this.quality_0 = - (AGMode.X_MOVE * this.quality_1);
						this.x += this.quality_0;
					}
					else {
						this.quality_0 = 0;
					}
					//if (this.limit > AGMode.LASER_WIDTH) {
					//	this.active = false;
						//this.sprite_type = AGMode.TORPEDO_UNUSED;
					//	this.visible = false;
					//}
					
					if(this.facingRight) {
						this.x = this.x +  Math.abs(this.limit);
						if (x - startx > AGMode.LASER_WIDTH) this.active = false;
					}
					else {
						this.x = this.x - Math.abs(this.limit);
						if (startx - x > AGMode.LASER_WIDTH) this.active = false;
					}
					
					if (this.quality_0 == 0) this.quality_0 = 2 * 2 * 2;
					//this.quality_1 = jj;
					this.bitmap = new Bitmap(new BitmapData(Math.abs(this.quality_0) ,  2, true, 0xffffffff));

					
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