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
	var K_ANY:Boolean = false;
		
	var myStage:Stage;
	var myButtons:Array;
	var myRes:Array;
	var myBlocks:Array; 
	var myGame:AGGame;
	var myDraw:AGDraw;
	var myScreenBG:Bitmap;

	var mySprite:Array = new Array();
	var myTimer:Array = new Array();
	var myTorpedo:Array = new Array();
	var myChallenge:Array = new Array();
	var myTemp:Array = new Array();
		
	static var TOTAL_SPRITE:int = 50;
	static var TOTAL_TORPEDOS:int = 5;
	static var TOTAL_TIMER:int = 15;
	static var TOTAL_CHALLENGE:int = 10;
		
	static var PLATFORM_WIDTH:int = 40*2;
	static var PLATFORM_HEIGHT:int = 8*2;
		
		
	
	//sprites
	static var S_NONE:int =  0;
	static var S_GUY:int =  1;
	static var S_FLYER:int =  2;
	static var S_GATOR:int =  3;
	static var S_CLOUD:int =  4;
	static var S_TORPEDO:int =  5;
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
	static var S_RING:int = 16;
	static var S_EXPLOSION:int = 17;
	static var S_BLOCK:int = 18;
	static var S_FLYER_RINGS:int = 19;
	static var S_GOAL:int = 20;
	static var S_PYRAMID:int = 21;
	static var S_BUBBLE_MAZE:int = 22;
	static var S_LADDER:int = 23;
	
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
	static var  D_RING:int = 15;
	static var  D_TORPEDO:int = 16;
	static var D_GOAL:int = 17;
	static var D_PYRAMID:int = 18;
	static var D_GUY:int = 19;
	
	//radar ping types
	static var PING_FLYER:int = 0;
	static var PING_OTHER:int =  1;
	static var PING_ROCK:int = 2;	
	
	// path taken by invader 1
	static var P_NONE:int = 0;
	static var P_GOING_LEFT:int = 1;
	static var P_GOING_RIGHT:int = 2;
	static var P_GOING_LEFT_ARMED:int = 3;
	static var P_GOING_RIGHT_ARMED:int = 4;
	
	static var TORPEDO_FLYING:int = 1;
	static var TORPEDO_HIT:int =  2;
	static var TORPEDO_UNUSED:int = 0;	
	
	static var LASER_WIDTH:int = 150 * 2;
	static var LASER_GUN:int = 12*2;
	
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
	var startingx:int = xpos;
	var startingy:int = ypos;
	
	//game progress variables
	public var game_death:Boolean = false;
	public var game_over:Boolean = false;
	public var game_advance_challenge:Boolean = false;
	public var game_reset_start:Boolean = false;
	public var game_advance_planet:Boolean = false;
	public var game_advance_maze:Boolean = false;
	public var game_enter_maze:Boolean = false;
	public var game_end_level:Boolean = false;
	public var game_start:Boolean = false;
	
	public var facingRight:Boolean = true;
	public var animate:int = 0;
	public var levelcheat:int = 4;
	public var mapcheat:int = 4; 
	public var wrapHorizontal:Boolean = true;
	public var gamePaused:Boolean = true;
	public var flyerGrounded:Boolean = false;
	public var preferences_collision:Boolean = true;
	public var animate_only:Boolean = false;
	public var is_blinking:Boolean = false;
	public var alert_color:uint = 0x00000000;
	public var planets:int = 0;
	public var challenges:int = 0;
	
	public var radar:Rectangle = new Rectangle(0,0,SCREEN_WIDTH - 128, 64);
	public var radarscreen:Bitmap = new Bitmap();
	
	public var myVisible:Array ;
	public var myInvisible:Array ;
	public var myHold:Array = new Array();
	
	var sprite:Sprite = new Sprite();
	public var flyersprite:Bitmap; // for collision detection
	public var explosionsprite:AGSprite; // for display of explosion
	var agflyer:AGSprite;// = new AGSprite(this,AGMode.S_FLYER);

	

		public function AGMode() {
			// constructor code
			this.game_start = true;
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
						 myButtons[AGKeys.BUTTON_PAUSE].getValBool(), myButtons[AGKeys.BUTTON_ANY].getValBool());
		}

		public function setKeyValues(left:Boolean, right:Boolean, up:Boolean, down:Boolean, 
									 shoot:Boolean, jump:Boolean , pause:Boolean, any:Boolean) {
			K_LEFT = left;
			K_RIGHT = right;
			K_UP = up;
			K_DOWN = down;
			K_JUMP = jump;
			K_SHOOT = shoot;
			K_PAUSE = pause;
			K_ANY = any;
		}
		
		public function innerGameLoop() {
			// this happens every frame because it is called in AGGame.as once every 
			// frame by 'doAnimation()'...
			myBlocks = new Array();
			
						
			animate ++
			if (animate > 4) animate = 0;
			
			setKeys();
			//if (myGame.gamePaused) return;			
			
			myStage.removeChildren();
			
			if (myGame.gameChallenge > challenges) {
				game_end_level = true;
			}
			if (myGame.gamePlanet > planets) {
				myGame.gamePlanet = -1;
				game_end_level = true;
			}
			
			if (game_death) {
				myGame.gameLives --;
				game_death = false;
				game_reset_start = true;
				this.doOnce();
				if (myGame.gameLives <= 0 ) {
					game_over = true;
				}
			}
			if (game_end_level) {
				game_reset_start = true;
				myGame.gamePlanet ++;
				this.doOnce();
			}
			
			componentsInOrder();
		}
		
		public function doOnce():void {
			
		}
		
		public function advanceChallenge():void {
			myGame.gameChallenge ++;
			
		}
		
		public function setStartingVars():void {
			xpos = startingx ;
			ypos = startingy ;
			scrollBGX = xpos - 100;
			scrollBGY = ypos - 100;
			
			yy=xx=0;
			flyerGrounded = false;
		}
		
		public function startingPos(xx:int, yy:int):void {
			// taken from myInvisible[][] array
		}
		
		public function componentsInOrder():void {
			detectMovement();
			physicsAdjustments();
			
			scrollBackground();
		}
		
		public function prepTiles():void {
			
		}
		
		public function prepSpecialXml():void {
			
		}
		
		public function initAGSprite():void {
			var ii:int = 0;
			mySprite = new Array();
			myTorpedo = new Array();
			//for (ii = 0; ii < TOTAL_SPRITE; ii ++ ) {
			//	mySprite.push(new AGSprite(this,S_NONE));
			//}
			for (ii = 0; ii < TOTAL_TORPEDOS; ii ++ ) {
				myTorpedo.push(new AGSpriteTorpedo(this, TORPEDO_UNUSED));
			}
			
			
		}
		public function initChallenges():void {
			myChallenge = new Array();
			
		}
		public function initAGTimer():void {
			myTimer = new Array();
			for (var ii:int = 0; ii < TOTAL_TIMER; ii ++ ) {
				myTimer.push(new AGTimer());
			}
		}
		
		public function scrollBackground():void {
			
			
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
			//if (K_JUMP) {
				//trace(K_JUMP);
				
			//}
		}
	
		public function fireButton():void {
			
		}
	
		public function cutTile(  tileset:Bitmap, num:int , tilebracket:int ):Bitmap {
			return new Bitmap();
		}
		public function adjust_x( xxx:int ):int {
			return 0;
		}
		
		////////////////////////
		public function physicsAdjustments():void {
				//this version for overriding
		}
		

		public function drawRadarPing(box:Rectangle, bits:Bitmap, oldx:int, oldy:int , kind:int,  color:uint):void {
	
		
		}
		
		
		public function drawScoreWords():void {
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
 /////////////////////////////////
 
	public function drawScoreNumbers( pos:int,  num:int,  p:int):void {
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
 
////////////////////////////////////
		
		
		public function getRand(min:int, max:int):int {
			return min + (( max - min ) * Math.random());
		}
		
		public function collisionSimple( a:Bitmap, b:Bitmap ):Boolean {
			var arect:Rectangle = a.getBounds(myStage);
			var brect:Rectangle = b.getBounds(myStage);
			var apt:Point = new Point(a.x, a.y);
			var bpt:Point = new Point(b.x, b.y);
			return a.bitmapData.hitTest(apt,128,b.bitmapData,bpt,128);
			
		}
		public function collisionBlock( a:Bitmap, b:Bitmap ):Boolean {
			var arect:Rectangle = a.getBounds(myStage);
			var brect:Rectangle = b.getBounds(myStage);
			var apt:Point = new Point(a.x, a.y);
			var bpt:Point = new Point(b.x, b.y);
			return a.bitmapData.hitTest(apt,0,b.bitmapData,bpt,0);
			
		}
		
		public function goingRightIsShortest(  spritex:int, flyerx:int ):Boolean { 
			return true;
		}
		
		
	}
	
}
