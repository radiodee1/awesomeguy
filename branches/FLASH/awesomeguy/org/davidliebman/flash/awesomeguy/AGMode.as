package  org.davidliebman.flash.awesomeguy {
	import flash.display.Stage;
	import flash.events.Event;
	import flash.geom.*;
	import flash.display.Sprite;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.*;
	
	public class AGMode {

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
	
	static var change:int = 0;
	
	//blocks	
	static var B_NONE:int = -1 +change;
	static var B_START:int = 5 +change;
	static var B_SPACE:int = 0 ;
	static var B_LADDER:int = 444 +change;
	static var B_BLOCK:int = 442 +change;
	static var B_GOAL:int = 446 +change;
	static var B_KEY:int = 445 +change; 
	static var B_PRIZE:int =  447 +change;
	static var B_MONSTER:int = 443 +change;
	static var B_MARKER:int = 441 +change; 
	static var B_DEATH:int = 439 +change;
	static var B_ONEUP:int = 438 +change;
	static var B_BIBPRIZE:int = 440 +change;
	static var B_PLATFORM:int = 437 +change; 
	
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
	
	var TILEMAP_HEIGHT:int = 128 * 2;
	var TILEMAP_WIDTH:int = 224 * 2;
	var TILE_HEIGHT:int = 16;
	var TILE_WIDTH:int = 16;
	
	static var TILE_TOP:int = 0;
	static var TILE_MID:int = 1;
	static var TILE_BOT:int = 3;
	
	//scroll variables
	public var spriteHeight:int = 40;
	public var spriteWidth:int = 90;
	var myField:Rectangle = new Rectangle();
	var myScreen:Rectangle = new Rectangle();
	var myBoundaries:Rectangle = new Rectangle();
	var mySweetspot:Rectangle = new Rectangle();
	var myHoriz:int = 0;
	var myVert:int = 0;
	public var scrollBGX:int = 50;
	public var scrollBGY:int = 50;
	var xx:int = 0;
	var yy:int = 0;
	public static var X_MOVE = 10 * 2;
	public static var Y_MOVE = 3 * 2;
	var xpos:int = 100;
	var ypos:int = 100;
	
	public var facingRight:Boolean = false;
	public var animate:int = 0;
	public var wrapHorizontal:Boolean = true;
	public var verticalWrapPref:Boolean = false;// unused?
	
	public var myVisible:Array ;
	public var myInvisible:Array ;
	
	var sprite:Sprite = new Sprite();

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
			animate ++
			if (animate > 4) animate = 0;
			
			myStage.removeChildren();
			setKeys();
			componentsInOrder();
		}
		
		public function doOnce():void {
			
		}
		
		public function componentsInOrder():void {
			detectMovement();
			physicsAdjustments();
			
			scrollBackground();
		}
		
		public function prepTiles():void {
			
		}
		
		public function scrollBackground():void {
			myField.top = 0;
			myField.bottom = myVert * TILE_HEIGHT;
			myField.left = 0;
			myField.right = myHoriz * TILE_WIDTH;
			
			myScreen.top = scrollBGY;
			myScreen.bottom = scrollBGY + 384;
			myScreen.left = scrollBGX;
			myScreen.right = scrollBGX + 512;
			
			myBoundaries.top = myScreen.top + 20 + 0;
			myBoundaries.bottom = myScreen.bottom - 20 - spriteHeight;
			myBoundaries.left = myScreen.left + (5 * 8 * 2) + 0;
			myBoundaries.right = myScreen.right - (5 * 8 * 2) - spriteWidth;
			
			mySweetspot.top = myBoundaries.top;
			mySweetspot.bottom = myBoundaries.bottom;
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
				}
				
				//////////////////////////////
				
			}
			
			scrollBGX = newscrollx;
			scrollBGY = newscrolly;
			xpos = newx;
			ypos = newy;
			
			trace(newscrolly);
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

			m = TILEMAP_HEIGHT / TILE_HEIGHT * tilebracket; // 128 * 2 /16 = 16
			n = TILEMAP_WIDTH / TILE_WIDTH; // 224 * 2 /16 = 28
    
			k = int ((num / n) + m  ); // y pos 
			l = int (num - (k * n)  ); // x pos + 4
			
			
			var b:BitmapData = new BitmapData(  TILE_WIDTH, TILE_HEIGHT, true, 0x0);
			
			var bitmap:Bitmap = new Bitmap(b);
			bitmap.bitmapData.copyPixels(tileset.bitmapData,
							new Rectangle ( l * TILE_WIDTH, k * TILE_HEIGHT, 
							TILE_HEIGHT, TILE_HEIGHT),
							new Point (0,0) , null, null, true );
			
			
			
			
			return bitmap;
		}
		
		public function drawBasicSprite(spriteNum:int, kind:int):void {
			// init some vars here
			var add:int, add_radar:int;
			
			
			switch (kind) {
				case AGMode.S_FLYER:
					
				add = 0;
				add_radar = 0;

				
				if (scrollBGX >= xpos  ) {
					add = myHoriz * TILE_WIDTH;
					add_radar =  (xpos - scrollBGX) - xpos ;
				}
				
				
				
				
				
				if (facingRight) {
					if (animate %2 == 1 ) {
						sprite = myRes[AGResources.NAME_FLYER_R0_PNG];

					}
					else {
						sprite = myRes[AGResources.NAME_FLYER_R1_PNG];
	
					}
				}
				else {
					if (animate %2 == 1) {
						sprite = myRes[AGResources.NAME_FLYER_L0_PNG];

					}
					else {
						sprite = myRes[AGResources.NAME_FLYER_L1_PNG];
	
					}
				}
				sprite.x = add + xpos - scrollBGX;
				sprite.y = ypos - scrollBGY;
				myStage.addChild(sprite);
			
				break;
			}
		}
		
		////////////////////////
		public function physicsAdjustments():void {
				//this version for
		}
		
	}
	
}
