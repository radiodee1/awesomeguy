package  org.davidliebman.flash.awesomeguy {
	import flash.display.Sprite;
	import flash.display.Bitmap;
	
	public class AGSprite  {
		
			var timer:AGTimer = new AGTimer();
			public var sprite:Sprite;
			public var bitmap:Bitmap;
		
			public var x:int, y:int, animate:int;
			public var facingRight:int, active:int, visible:int;
			public var leftBB:int, rightBB:int, topBB:int, bottomBB:int;
			public var radius:int, limit:int, speed:int, strength:int, color:int;
			public var sprite_type:int, sprite_link:int;
			public var endline_x:int, endline_y:int;
			public var quality_0:int, quality_1:int, quality_2:int, quality_3:int;
		
		public function AGSprite() {
			//super();
		}

		public function timerStart(num:int):void {
			timer.timerStart(num);
		}
		
		public function timerDone():Boolean {
			return timer.timerDone();
		}
	}
	
}
