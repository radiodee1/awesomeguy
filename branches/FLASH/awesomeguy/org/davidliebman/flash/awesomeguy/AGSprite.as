package  org.davidliebman.flash.awesomeguy {
	import flash.display.Sprite;
	import flash.display.Bitmap;
	import flash.display.Shape;
	import flash.display.Stage;
	import flash.display.BitmapData;
	
	public class AGSprite  {
		
			static var TILEMAP_HEIGHT:int = 128 * 2;
			static var TILEMAP_WIDTH:int = 224 * 2;
			static var TILE_HEIGHT:int = 16;
			static var TILE_WIDTH:int = 16;
			
			public var ai:AGai;
			public var myPhysics:AGPhysics;
		
			var timer:AGTimer = new AGTimer();
			var myMode:AGMode;
			
			public var sprite:Sprite;
			public var bitmap:Bitmap;
			public var shape:Shape;
		
			public var x:int, y:int, animate:int;
			public var facingRight:Boolean, active:Boolean, visible:Boolean;
			public var leftBB:int, rightBB:int, topBB:int, bottomBB:int;
			public var radius:int, limit:int, speed:int, strength:int, color:uint;
			public var sprite_type:int, sprite_link:int;
			public var endline_x:int, endline_y:int;
			public var quality_0:int, quality_1:int, quality_2:int, quality_3:int;
			
			public var rail_left:Bitmap;
			public var rail_right:Bitmap;
			public var rail_top:Bitmap;
			public var rail_bottom:Bitmap;
			public var rail_low_bottom:Bitmap;
		
		public function AGSprite(mymode:AGMode, type:int) {
			myMode = mymode;
			
			x = 0;
			y = 0;
			animate = 0;
			facingRight = false;
			active = false;
			visible = false;
			leftBB = 0;
			rightBB = 0;
			topBB = 0;
			bottomBB = 0;
			sprite_type = type;
			quality_0 = 0;
			quality_1 = 0;
			quality_2 = 0;
			quality_3 = 0;
			radius = 0;
		}

		public function updateSprite():void {
			//nothing here...
		}

		public function timerStart(num:Number):void {
			timer.timerStart(num);
		}
		
		public function timerDone():Boolean {
			return timer.timerDone();
		}
		
		public function timerDestroy():void {
			timer.timerDestroy();
		}
		
		public function pruneSprite():void {
			//
		}
		
		public function makeRails():void {
			var asprite:AGSprite = this;
			if (asprite.bitmap == null) {
				//trace("no bitmap");
				return;
			}
			//else trace("make rails");
			
			var guyheight:int = asprite.bitmap.bitmapData.height;
			var guywidth:int = asprite.bitmap.bitmapData.width;
			
			var vertical:BitmapData = new BitmapData(2,guyheight - AGModeGuy.Y_MOVE,true,0x00ff0000);
			var horizontal:BitmapData = new BitmapData(guywidth - AGModeGuy.X_MOVE, 2,true,0x00ff0000);
			/*
			if (asprite.sprite_type == AGMode.S_XMONSTER_CLIMBER) {
				
				vertical = new BitmapData(2,guyheight - AGModeGuy.Y_MOVE,false,0xffff0000);
				horizontal = new BitmapData(guywidth - AGModeGuy.X_MOVE, 2,false,0xffff0000);
			
			}
			*/
			
			this.rail_bottom = new Bitmap(horizontal);
			this.rail_top = new Bitmap(horizontal);
			this.rail_left = new Bitmap(vertical);
			this.rail_right = new Bitmap(vertical);
			this.rail_low_bottom = new Bitmap(horizontal);
			
			this.rail_bottom.x = asprite.bitmap.x + (AGModeGuy.X_MOVE/ 2) ;
			this.rail_bottom.y = asprite.bitmap.y + asprite.bitmap.height +  (AGModeGuy.Y_MOVE/2);
			
			this.rail_low_bottom.x = asprite.bitmap.x + (AGModeGuy.X_MOVE/ 2) ;
			this.rail_low_bottom.y = asprite.bitmap.y + asprite.bitmap.height +  (AGModeGuy.Y_MOVE *2);
			
			
			this.rail_left.x = asprite.bitmap.x - (AGModeGuy.X_MOVE/2);
			this.rail_left.y = asprite.bitmap.y + (AGModeGuy.Y_MOVE/ 2);
			
			this.rail_right.x = asprite.bitmap.x + asprite.bitmap.width + (AGModeGuy.X_MOVE/2);
			this.rail_right.y = asprite.bitmap.y + (AGModeGuy.Y_MOVE/2) ;
			
			this.rail_top.x = asprite.bitmap.x + (AGModeGuy.X_MOVE/2);
			this.rail_top.y = asprite.bitmap.y - ( AGModeGuy.Y_MOVE/2);
			
			
			
		}
		
		public function addRails(myStage:Stage) :void {
			if (this.bitmap == null) {
				//trace("no bitmap");
				return;
			}
			
			myStage.addChild(this.rail_bottom);
			myStage.addChild(this.rail_left);
			myStage.addChild(this.rail_right);
			myStage.addChild(this.rail_top);
		}
	}
	
}
