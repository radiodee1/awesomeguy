package  org.davidliebman.flash.awesomeguy {
	import flash.display.Sprite;
	import flash.display.Bitmap;
	import flash.display.Shape;
	
	public class AGSprite  {
		
			static var TILEMAP_HEIGHT:int = 128 * 2;
			static var TILEMAP_WIDTH:int = 224 * 2;
			static var TILE_HEIGHT:int = 16;
			static var TILE_WIDTH:int = 16;
	
		
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
	}
	
}
