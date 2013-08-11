package org.davidliebman.flash.awesomeguy {
	import flash.display.Bitmap;
	import flash.geom.Rectangle;
	import flash.display.BitmapData;
	import flash.geom.Point;
	
	public class AGModeGuy extends AGMode{

		static var B_NONE:int = -1 ;
		static var B_START:int = 17 ;
		static var B_GUN:int = 16;
		static var B_SPACE:int = 0 ;
		static var B_LADDER:int = 25 ;
		static var B_BLOCK:int = 23 ;
		static var B_GOAL:int = 27 ;
		static var B_KEY:int = 26 ; 
		static var B_PRIZE:int =  28 ;
		static var B_MONSTER:int = 24 ;
		static var B_MARKER:int = 22 ; 
		static var B_DEATH:int = 20 ;
		static var B_ONEUP:int = 19 ;
		static var B_BIGPRIZE:int = 21 ;
		static var B_PLATFORM:int = 18 ; 
		
		var TILEMAP_HEIGHT:int = 128 * 2;
		var TILEMAP_WIDTH:int = 224 * 2;
		var TILE_HEIGHT:int = 64;
		var TILE_WIDTH:int = 64;

		public function AGModeGuy() {
			// constructor code
			super();
			levelcheat = 0;
			mapcheat = 0;
		}
		
		public override function componentsInOrder():void {
			super.componentsInOrder();
			
			myStage.addChild(myRes[AGResources.NAME_START_PAUSE_PNG]);

		}
		
		public override function doOnce():void {
		}
		
		public override function advanceChallenge():void {
			super.advanceChallenge();
			myHold = new Array();
			
			if (myGame.gameChallenge >= challenges) {
				myGame.gameChallenge = 0;
				
			}
			
			doOnce();
		}
		
		public function setStartingTimers():void {
			
		}
		
		public override function setStartingVars():void {
			xpos = startingx ;
			ypos = startingy ;
			scrollBGX = xpos - 100;
			scrollBGY = ypos - 100;
			
			yy=xx=0;
			//flyerGrounded = false;
		}
		
		public override function startingPos(xx:int, yy:int):void {
			// taken from myInvisible[][] array
		}
		
		public override function prepTiles():void {
			
		}
		
		public override function prepSpecialXml():void {
			
		}
		
		public override function initAGSprite():void {
			super.initAGSprite();
			
		}
		public override function initChallenges():void {
			super.initChallenges();
			
		}
		public override function initAGTimer():void {
			super.initAGTimer();
		}
		
		public function addSprites():void {
			
		}
		
		public function doTimers():void {
			
		}
		
		public function updateSprites():void {
			
		}
		public function drawAnimatedSprites():void {
			
		}
		
		public function drawLevelTiles():void {
			
		}
		public override function scrollBackground():void {
			
			
		}
		public override function detectMovement():void {
			super.detectMovement();
			//if (K_JUMP) {
				//trace(K_JUMP);
				
			//}
		}
		public override function fireButton():void {
			
		}
		
		public override function cutTile(  tileset:Bitmap, num:int , tilebracket:int ):Bitmap {
			
			var i:int ,j:int, k:int,l:int, m:int,n:int, p:int ;

			m = int (TILEMAP_HEIGHT / TILE_HEIGHT * tilebracket) ; // 128 * 2 /16 = 16
			n = int ( TILEMAP_WIDTH / TILE_WIDTH) ; // 224 * 2 /16 = 28
    
			k = int ((num / n)   ); // y pos 
			l = int (num - (k * n) -1  ); // x pos + 4
			k = k + m; // must come after!!
			
			var b:BitmapData = new BitmapData(  TILE_WIDTH, TILE_HEIGHT, true, 0x0);
			
			var bitmap:Bitmap = new Bitmap(b);
			bitmap.bitmapData.copyPixels(tileset.bitmapData,
							new Rectangle ( l * TILE_WIDTH, k * TILE_HEIGHT, 
							TILE_HEIGHT, TILE_HEIGHT),
							new Point (0,0) , null, null, true );
			
			//trace("nums m:" + m + " n:" + n + " k:" + k + " l:" + l);
			
			
			return bitmap;
		}
		
		public override function adjust_x( xxx:int ):int {
			return xxx;
		}
		
		public override function physicsAdjustments():void {
				//this version for overriding
		}
		
		public override function drawRadarPing(box:Rectangle, bits:Bitmap, oldx:int, oldy:int , kind:int,  color:uint):void {
			
		
		}
		
		public override function drawScoreWords():void {
			var TILE_HEIGHT:int = 16;
			var TILE_WIDTH:int = 16;
			
			var square:Bitmap;
			var scrollx:int = scrollBGX;
			var scrolly:int = scrollBGY;
			
			var i:int;
			var topScore:Array = new Array(374,375,376,377,378,383);
	
			var topLives:Array = new Array (379,380,381,378,382,383);
	
			var scorePos:int, livesPos:int;
			scorePos = 2 ;
			livesPos = 16  ;
			//uint16_t square[TILE_HEIGHT][TILE_WIDTH];
			
			
			if (ypos - scrollBGY > 16 * 2) {
					//print SCORE:
					for (i = 0; i < 6; i ++) {
						square = cutTile(myRes[AGResources.NAME_TILES1_PNG],  topScore[i] + 1, AGMode.TILE_TOP);
						
						//drawTile_8(square, (scorePos + i) * TILE_WIDTH + scrollx, (1) * TILE_HEIGHT + scrolly, 
						//	scrollx , scrolly, PAINT_TRANSPARENT, number_alpha);
						square.x = (scorePos + i) * TILE_WIDTH  ;
						square.y = (1) * TILE_HEIGHT ;
						myStage.addChild(square);
	
						square = cutTile(myRes[AGResources.NAME_TILES1_PNG], topScore[i] +28 + 1, AGMode.TILE_TOP);
	
						//drawTile_8(square, (scorePos + i) * TILE_WIDTH  + scrollx, (2) * TILE_HEIGHT + scrolly, 
						//	scrollx , scrolly, PAINT_TRANSPARENT, number_alpha);
						square.x = (scorePos + i) * TILE_WIDTH  ;
						square.y = (2) * TILE_HEIGHT ;
						myStage.addChild(square);
	
					}
					//print LEVEL:
					for (i = 0; i < 6; i ++) {
						
						square = cutTile(myRes[AGResources.NAME_TILES1_PNG], topLives[i] + 1, AGMode.TILE_TOP);
	
						square.x = (livesPos + i) * TILE_WIDTH  ;
						square.y = (1) * TILE_HEIGHT ;
						myStage.addChild(square);
						//drawTile_8(square, (livesPos + i) * TILE_WIDTH + scrollx, (1) * TILE_HEIGHT + scrolly, 
						//	scrollx , scrolly, PAINT_TRANSPARENT, number_alpha);
	
						square = cutTile(myRes[AGResources.NAME_TILES1_PNG],  topLives[i] + 28 + 1,AGMode.TILE_TOP );
	
						//drawTile_8(square, (livesPos + i) * TILE_WIDTH +scrollx , (2) * TILE_HEIGHT + scrolly , 
						//	scrollx , scrolly, PAINT_TRANSPARENT, number_alpha);
						square.x = (livesPos + i) * TILE_WIDTH  ;
						square.y = (2) * TILE_HEIGHT ;
						myStage.addChild(square);
						
					}
	
					//print numbers:
					drawScoreNumbers( scorePos + 6, myGame.gameScore  , 7); // score
					drawScoreNumbers( livesPos + 6, myGame.gameLives , 7); // lives
			}
		}
		
		public override function drawScoreNumbers( pos:int,  num:int,  p:int):void {
			var TILE_HEIGHT:int = 16;
			var TILE_WIDTH:int = 16;
			var i:int, a:int, b:int, c:int, placesValue:int;
			var places:Array = new Array(0,0,0,0,0,0,0,0,0,0);//ten spots
			var topNumbers:Array = new Array (364,365,366, 367, 368, 369, 370, 371, 372, 373);
			var showZeros:int = 0;
			var square:Bitmap;
	
			for (i = 0; i < 10; i ++) {
				a = num -( int(num / 10)) * 10;
				places[9 - i] = int( a) ;
				b = (num / 10) * 10;
				num = b / 10;
			}
			c = 0;
			for(i = 0; i < p; i ++) {
				placesValue =int( places[i + (10 - p)]);
				if (showZeros == 1 || placesValue != 0) {
					if(placesValue != 0) showZeros = 1;
					if(showZeros == 1 && c == 0) {
						c = p - i;
					}
					
						square = cutTile(myRes[AGResources.NAME_TILES1_PNG], topNumbers[placesValue] + 1, AGMode.TILE_TOP);
	
						//drawTile_8(square, (pos + i - p + c) * TILE_WIDTH + scrollx, (1) * TILE_HEIGHT +
						//	scrolly, scrollx , scrolly, PAINT_TRANSPARENT, number_alpha);
	
						square.x = (pos + i - p + c) * TILE_WIDTH;
						square.y = (1) * TILE_HEIGHT;
						myStage.addChild(square);
	
						square = cutTile(myRes[AGResources.NAME_TILES1_PNG], topNumbers[placesValue] +28 + 1, AGMode.TILE_TOP);
	
						//drawTile_8(square, (pos + i - p + c) * TILE_WIDTH +scrollx , (2) * TILE_HEIGHT +
						//	scrolly , scrollx , scrolly, PAINT_TRANSPARENT, number_alpha);
						
						square.x = (pos + i - p + c) * TILE_WIDTH;
						square.y = (2) * TILE_HEIGHT;
						myStage.addChild(square);
						
				}
	
			}
		} 
		
		
		
	}
	
}
