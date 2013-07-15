package  org.davidliebman.flash.awesomeguy {
	import flash.display.Stage;
	import flash.events.Event;
	import flash.geom.*;
	import flash.display.Sprite;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.*;
	
	public class AGMode {

	// keys
	var K_LEFT:Boolean = false;
	var K_RIGHT:Boolean = false;
	var K_UP:Boolean = false;
	var K_DOWN:Boolean = false;		
	var K_SHOOT:Boolean = false;
	var K_JUMP:Boolean = false;
	var K_PAUSE:Boolean = false;
		
	var myStage:Stage;
	var myButtons:Array;
	var myRes:Array;
	var myGame:AGGame;
	var myDraw:AGDraw;
	var myScreenBG:Bitmap;

	var mySprite:Array = new Array();
	var myTimer:Array = new Array();
	var myTorpedo:Array = new Array();
	var myChallenge:Array = new Array();
		
	static var TOTAL_SPRITE:int = 50;
	static var TOTAL_TORPEDOS:int = 5;
	static var TOTAL_TIMER:int = 10;
	static var TOTAL_CHALLENGE:int = 10;
		
	static var PLATFORM_WIDTH:int = 40*2;
	static var PLATFORM_HEIGHT:int = 8*2;
		
	//blocks	
	static var B_NONE:int = -1 ;
	static var B_START:int = 5 ;
	static var B_SPACE:int = 0 ;
	static var B_LADDER:int = 444 ;
	static var B_BLOCK:int = 442 ;
	static var B_GOAL:int = 446 ;
	static var B_KEY:int = 445 ; 
	static var B_PRIZE:int =  447 ;
	static var B_MONSTER:int = 443 ;
	static var B_MARKER:int = 441 ; 
	static var B_DEATH:int = 439 ;
	static var B_ONEUP:int = 438 ;
	static var B_BIBPRIZE:int = 440 ;
	static var B_PLATFORM:int = 437 ; 
	
	//sprites
	static var  S_NONE:int =  0;
	static var  S_GUY:int =  1;
	static var  S_FLYER:int =  2;
	static var  S_GATOR:int =  3;
	static var  S_CLOUD:int =  4;
	static var  S_TORPEDO:int =  5;
	static var S_BUBBLE_0:int =  6;
	static var S_BUBBLE_1:int =  7;
	static var S_BUBBLE_2:int =  8;
	static var S_BUBBLE_3:int =  9;
	static var S_INVADER_1:int =  10;
	static var S_INVADER_2:int =  11;
	static var S_INVADER_3:int =  12;
	static var S_LINE:int =	13;
	static var S_LINE_2:int = 14;
	static var S_EXPLOSION_SPRITE:int = 15;
	
	//draw enumeration
	static var D_NONE:int = 0;
	static var  D_FLYER:int =  1;
	static var  D_EXPLOSION:int =  2;
	static var  D_EXPLOSION_SPRITE:int =  3;
	static var  D_CLOUD:int =  4;
	static var  D_GATOR:int =  5;
	static var  D_INVADER_1:int =  6;
	static var  D_INVADER_2:int =  7;
	static var  D_INVADER_3:int =  8;
	static var  D_FLYER_RINGS:int =  9;
	static var  D_LINE_1:int = 10;
	static var  D_BUBBLE_0:int = 11;
	static var  D_BUBBLE_1:int = 12;
	static var  D_BUBBLE_2:int = 13;
	static var  D_BUBBLE_3:int = 14;
	
	//radar ping types
	static var PING_FLYER:int = 0;
	static var PING_OTHER:int =  1;
	static var PING_ROCK:int = 2;	
	
	static var TORPEDO_FLYING:int = 1;
	static var TORPEDO_HIT:int =  2;
	static var TORPEDO_UNUSED:int = 0;	
	
	static var TIMER_00:int = 0;
	static var TIMER_01:int = 1;
	static var TIMER_02:int = 2;
	static var TIMER_03:int = 3;
	static var TIMER_04:int = 4;
	static var TIMER_05:int = 5;
	static var TIMER_06:int = 6;
	static var TIMER_07:int = 7;
	static var TIMER_08:int = 8;
	static var TIMER_09:int = 9;
	
	var sprite_num:int = 0;
	var monster_num:int = 0;
	var platform_num:int = 0;
	
	var TILEMAP_HEIGHT:int = 128 * 2;
	var TILEMAP_WIDTH:int = 224 * 2;
	var TILE_HEIGHT:int = 16;
	var TILE_WIDTH:int = 16;
	
	public var SCREEN_HEIGHT:int = (512 * 3/4 ) - 64;
	public var SCREEN_WIDTH:int = 512;
	
	static var TILE_TOP:int = 0;
	static var TILE_MID:int = 1;
	static var TILE_BOT:int = 2;
	
	//scroll variables
	public var spriteHeight:int = 40;
	public var spriteWidth:int = 90;
	var myField:Rectangle = new Rectangle();
	var myScreen:Rectangle = new Rectangle();
	var myBoundaries:Rectangle = new Rectangle();
	var mySweetspot:Rectangle = new Rectangle();
	var myHoriz:int = 0;
	var myVert:int = 0;
	public var scrollBGX:int = 0;
	public var scrollBGY:int = 50;
	var xx:int = 0;
	var yy:int = 0;
	public static var X_MOVE = 10 * 2;
	public static var Y_MOVE = 3 * 2;
	var xpos:int = scrollBGX + 100;
	var ypos:int = scrollBGY + 100;
	var radar_start:int = 0;
	var radar_start_scroll:int = 0;
	
	//game progress variables
	public var game_death:Boolean = false;
	public var game_over:Boolean = false;
	public var game_advance_challenge:Boolean = false;
	public var game_reset_start:Boolean = false;
	public var game_advance_planet:Boolean = false;
	public var game_advance_maze:Boolean = false;
	public var game_enter_maze:Boolean = false;
	
	public var facingRight:Boolean = false;
	public var animate:int = 0;
	public var levelcheat:int = 4;
	public var mapcheat:int = 4; 
	public var wrapHorizontal:Boolean = true;
	public var gamePaused:Boolean = false;
	public var flyerGrounded:Boolean = false;
	public var preferences_collision:Boolean = true;
	
	public var radar:Rectangle = new Rectangle(0,0,SCREEN_WIDTH - 128, 64);
	public var radarscreen:Bitmap = new Bitmap();
	
	public var myVisible:Array ;
	public var myInvisible:Array ;
	
	var sprite:Sprite = new Sprite();
	public var flyersprite:Bitmap; // for collision detection
	public var explosionsprite:AGSprite; // for display of explosion
	var agflyer:AGSprite;// = new AGSprite(this,AGMode.S_FLYER);

	

		public function AGMode() {
			// constructor code
		}
		
		public function setValues(mystage:Stage, mybuttons:Array, myresources:Array, mygame:AGGame) {
			
			myStage = mystage;
			myButtons = mybuttons;
			myRes = myresources;
			myGame = mygame;
			
			doOnce();
		}
		
		public function setKeys() {
			setKeyValues(myButtons[AGKeys.BUTTON_LEFT].getValBool() , myButtons[AGKeys.BUTTON_RIGHT].getValBool(),
						 myButtons[AGKeys.BUTTON_UP].getValBool(), myButtons[AGKeys.BUTTON_DOWN].getValBool(), 
						 myButtons[AGKeys.BUTTON_SHOOT].getValBool(), myButtons[AGKeys.BUTTON_JUMP].getValBool(),
						 myButtons[AGKeys.BUTTON_PAUSE].getValBool());
		}

		public function setKeyValues(left:Boolean, right:Boolean, up:Boolean, down:Boolean, 
									 shoot:Boolean, jump:Boolean , pause:Boolean) {
			K_LEFT = left;
			K_RIGHT = right;
			K_UP = up;
			K_DOWN = down;
			K_JUMP = jump;
			K_SHOOT = shoot;
			K_PAUSE = pause;
			
		}
		
		public function innerGameLoop() {
			// this happens every frame because it is called in AGGame.as once every 
			// frame by 'doAnimation()'...
			if (K_PAUSE) {
				if ( gamePaused) {
					gamePaused = false;
				}
				else if ( !gamePaused) {
					gamePaused = true;
				}
				K_PAUSE = false;
				myButtons[AGKeys.BUTTON_PAUSE].setValBool(false);
				
			}
			
			animate ++
			if (animate > 4) animate = 0;
			
			setKeys();
			if (gamePaused) return;			
			
			myStage.removeChildren();
			
			if (game_death) {
				myGame.gameLives --;
				game_death = false;
				game_reset_start = true;
				this.doOnce();
				if (myGame.gameLives <= 0 ) {
					game_over = true;
				}
			}
			if (game_advance_challenge) {
				myGame.gameChallenge ++;
				
			}
			
			componentsInOrder();
		}
		
		public function doOnce():void {
			
		}
		
		public function advanceChallenge():void {
			
		}
		
		public function setStartingVars():void {
			scrollBGX = 0;
			scrollBGY = 50;
			xpos = scrollBGX + 100;
			ypos = scrollBGY + 100;
			yy=xx=0;
			flyerGrounded = false;
		}
		
		public function componentsInOrder():void {
			detectMovement();
			physicsAdjustments();
			
			scrollBackground();
		}
		
		public function prepTiles():void {
			
		}
		
		public function initAGSprite():void {
			var ii:int = 0;
			mySprite = new Array();
			myTorpedo = new Array();
			//for (ii = 0; ii < TOTAL_SPRITE; ii ++ ) {
			//	mySprite.push(new AGSprite(this,S_NONE));
			//}
			for (ii = 0; ii < TOTAL_TORPEDOS; ii ++ ) {
				myTorpedo.push(new AGSprite(this, TORPEDO_UNUSED));
			}
			
		}
		public function initChallenges():void {
			myChallenge = new Array();
			for (var ii:int = 0; ii < TOTAL_CHALLENGE; ii ++ ) {
				myChallenge.push(new AGChallenge());
			}
		}
		public function initAGTimer():void {
			myTimer = new Array();
			for (var ii:int = 0; ii < TOTAL_TIMER; ii ++ ) {
				myTimer.push(new AGTimer());
			}
		}
		
		public function scrollBackground():void {
			myField.top = 0;
			myField.bottom = myVert * TILE_HEIGHT;
			myField.left = 0;
			myField.right = myHoriz * TILE_WIDTH;
			
			myScreen.top = scrollBGY;
			myScreen.bottom = scrollBGY + SCREEN_HEIGHT;
			myScreen.left = scrollBGX;
			myScreen.right = scrollBGX + SCREEN_WIDTH;
			
			myBoundaries.top = myScreen.top + 20 + 0;
			myBoundaries.bottom = myScreen.bottom - 20 - spriteHeight;
			myBoundaries.left = myScreen.left + (5 * 8 * 2) + 0;
			myBoundaries.right = myScreen.right - (5 * 8 * 2) - spriteWidth;
			
			mySweetspot.top = myBoundaries.top + (Y_MOVE * 3/2);
			mySweetspot.bottom = myBoundaries.bottom - (Y_MOVE * 3/2) ;
			mySweetspot.left = myBoundaries.left + (X_MOVE * 3/2) ;
			mySweetspot.right = myBoundaries.right - (X_MOVE * 3/2);
			
			var newx:int = xpos;
			var newy:int = ypos;
			
			var newscrollx:int = myScreen.left;
			var newscrolly:int = myScreen.top;
			
			var wrappingNow:Boolean = false;
			
			if (myScreen.right > myField.right || myScreen.left < myField.left) wrappingNow = true;
			
			//change values
			if (xx > 0) { // going right - drift left
				if (newx + xx >= myField.right && wrapHorizontal) { //wrap
					newx = newx - myField.right + xx;
				
				}
				if (myScreen.left + xx >= myField.right && wrapHorizontal) { //wrap
					newscrollx = newscrollx - myField.right + xx;
					
				}
				
				newx = newx + xx;
				newscrollx = newscrollx + xx;
				
				
				if (newx < mySweetspot.left && !wrappingNow) { //drift
					newscrollx = newscrollx - xx;
				}
				if (newx > myBoundaries.left && !wrappingNow) { //drift
					newscrollx = newscrollx + xx;
				}
				
			}
			if (xx < 0) { //going left 
				if (newx + xx <= myField.left && wrapHorizontal) { //wrap
					newx = newx + myField.right + xx;
				}
				if (myScreen.left + xx <= myField.left && wrapHorizontal) { // wrap
					newscrollx = newscrollx + myField.right + xx;
				}
				
				newx = newx + xx;
				newscrollx = newscrollx + xx;
				
				if (newx > mySweetspot.right && !wrappingNow) { //drift
					newscrollx = newscrollx - xx;
				}
				if (newx < myBoundaries.right && !wrappingNow) { //drift
					newscrollx = newscrollx + xx;
				}
				
			}
			if (yy > 0) { // going down
				if (newy + yy >= myField.bottom - spriteHeight) { //clip
					newy = myField.bottom - spriteHeight;
					flyerGrounded = true;// ??
					//newscrolly = myField.bottom - myScreen.bottom;
				}
				if (newy + yy < myField.bottom - spriteHeight) {
					newy = newy + yy;
					
					if (myScreen.bottom <= myField.bottom ) {
						newscrolly = newscrolly + yy;
					}
				}
				
				
			}
			if (yy < 0 ) { // up - drift down
				if (newy + yy <= myField.top) { //clip
					newy = myField.top;
					//newscrolly = myField.top;
				}
				
				
				if (newy + yy > myField.top ) {
					newy = newy + yy;
					
					if (myScreen.top >= myField.top ) {
						newscrolly = newscrolly + yy;
					}
					if (newy + yy > myBoundaries.top ) {
						newscrolly -= yy;
					}
					
				}
				
				
				//////////////////////////////
				
			}
			
			scrollBGX = newscrollx;
			scrollBGY = newscrolly;
			xpos = newx;
			ypos = newy;
			

		}
		
		public function detectMovement():void {
			xx = 0;
			yy = 0;
			if ( K_LEFT  ) {
				xx = - X_MOVE;				
				facingRight = false;
			}
			if (K_RIGHT ) {
				xx = + X_MOVE;
				facingRight = true;
			}
			if (K_UP ) {
				yy = - Y_MOVE;

			}
			if (K_DOWN ) {
				yy = + Y_MOVE;
			
			}
		}
	
		public function cutTile(  tileset:Bitmap, num:int , tilebracket:int ):Bitmap {
			
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
		
		
		
		
		////////////////////////
		public function physicsAdjustments():void {
				//this version for overriding
		}
		

		public function drawRadarPing(box:Rectangle, bits:Bitmap, oldx:int, oldy:int , kind:int,  color:uint):void {
	
		var b:BitmapData;
		var oldxx:int = 0;
		var oldyy:int = 0;
		var ii:int = 0;
		var jj:int = 0;

		ii =  radar_start_scroll;
		jj = adjust_x (radar_start);
		oldyy = oldy;

		
			
		
			oldxx = (oldx - scrollBGX + (myHoriz * TILE_WIDTH/2) -256 + ii) % (myHoriz * TILE_WIDTH );// this might be OK...
			oldxx = adjust_x(oldxx) * 2;
		
	
		oldyy = oldyy * 2;
	
		b = new BitmapData( 2, 2, true, color);
		bits.bitmapData.copyPixels(b,
							new Rectangle (0, 0, 
							2, 2),
							new Point (box.left + (oldxx/16 ), box.top + (oldyy/16 ) ) , null, null, true );
	
		

	if (kind == PING_ROCK) return;

		b = new BitmapData( 2, 2, true, color);
		bits.bitmapData.copyPixels(b,
							new Rectangle (0, 0, 
							2, 2),
							new Point (box.left + 1 +(oldxx/16 ), box.top + (oldyy/16 ) ) , null, null, true );
	
	

		b = new BitmapData( 2, 2, true, color);
		bits.bitmapData.copyPixels(b,
							new Rectangle (0, 0, 
							2, 2),
							new Point (box.left + (oldxx/16 ), box.top + 1+(oldyy/16 ) ) , null, null, true );

		

		b = new BitmapData( 2, 2, true, color);
		bits.bitmapData.copyPixels(b,
							new Rectangle (0, 0, 
							2, 2),
							new Point (box.left + 1 + (oldxx/16 ), box.top + 1+ (oldyy/16 ) ) , null, null, true );

	

	if (kind != PING_OTHER) return;

		b = new BitmapData( 2, 2, true, color);
		bits.bitmapData.copyPixels(b,
							new Rectangle (0, 0, 
							2, 2),
							new Point (box.left -2 + (oldxx/16 ), box.top + (oldyy/16 ) ) , null, null, true );

		
		b = new BitmapData( 2, 2, true, color);
		bits.bitmapData.copyPixels(b,
							new Rectangle (0, 0, 
							2, 2),
							new Point (box.left -2 + (oldxx/16 ), box.top +1+ (oldyy/16 ) ) , null, null, true );

		
		b = new BitmapData( 2, 2, true, color);
		bits.bitmapData.copyPixels(b,
							new Rectangle (0, 0, 
							2, 2),
							new Point (box.left -1 + (oldxx/16 ), box.top + (oldyy/16 ) ) , null, null, true );

		
		b = new BitmapData( 2, 2, true, color);
		bits.bitmapData.copyPixels(b,
							new Rectangle (0, 0, 
							2, 2),
							new Point (box.left -1+ (oldxx/16 ), box.top +1 + (oldyy/16 ) ) , null, null, true );

		
		}
		
		
		public function drawScoreWords():void {
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
			
			
			if (ypos > 16 * 2) {
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
 /////////////////////////////////
 
	public function drawScoreNumbers( pos:int,  num:int,  p:int):void {
		
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
 
////////////////////////////////////
		public function adjust_x( xxx:int ):int {
			if (xxx > myHoriz *  TILE_WIDTH ) {
				//x = 0;
				xxx = xxx - (myHoriz * TILE_WIDTH);
			}
			if (xxx < 0 ) {
				xxx = xxx + (myHoriz * TILE_WIDTH);
			}
			return xxx;
		}		
		
		public function getRand(min:int, max:int):int {
			return min + ( max - min ) * Math.random();
		}
		
		public function collisionSimple( a:Bitmap, b:Bitmap ):Boolean {
			var arect:Rectangle = a.getBounds(myStage);
			var brect:Rectangle = b.getBounds(myStage);
			var apt:Point = new Point(a.x, a.y);
			var bpt:Point = new Point(b.x, b.y);
			return a.bitmapData.hitTest(apt,128,b.bitmapData,bpt,128);
			
		}
	}
	
}
