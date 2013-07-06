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
	
	static var B_NONE:int = -1;
	static var B_START:int = 5;
	static var B_SPACE:int = 0;
	static var B_LADDER:int = 444;
	static var B_BLOCK:int = 442;
	static var B_GOAL:int = 446;
	static var B_KEY:int = 445; 
	static var B_PRIZE:int =  447;
	static var B_MONSTER:int = 443;
	static var B_MARKER:int = 441; 
	static var B_DEATH:int = 439 ;
	static var B_ONEUP:int = 438 ;
	static var B_BIBPRIZE:int = 440 ;
	static var B_PLATFORM:int = 437 ; 
	
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
	public var scrollBGX:int = 0;
	public var scrollBGY:int = 0;
	var xx:int = 0;
	var yy:int = 0;
	public static var X_MOVE = 3 * 2;
	public static var Y_MOVE = 3 * 2;
	var xpos:int = 100;
	var ypos:int = 100;
	
	public var facingRight:Boolean = false;
	public var animate:int = 0;
	public var wrapHorizontal:Boolean = true;
	
	public var myVisible:Array ;
	public var myInvisible:Array ;

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
			mySweetspot.left = myBoundaries.left + 8;
			mySweetspot.right = myBoundaries.right - 8;
			
			var newx:int = xpos;
			var newy:int = ypos;
			
			var newscrollx:int = myScreen.left;
			var newscrolly:int = myScreen.top;
			
			//change values
			if (xx > 0) { // going right - drift left
				if (newx + xx >= myField.right && wrapHorizontal) { //wrap
					newx = newx - myField.right + xx;
				}
				if (myScreen.right + xx >= myField.right && wrapHorizontal) { //wrap
					newscrollx = newscrollx - myField.right + xx;
				}
				
				newx = newx + xx;
				newscrollx = newscrollx + xx;
				/*
				if (newx + xx > myBoundaries.left) {
					if (myScreen.right < myField.right ) {
						newscrollx = newscrollx + X_MOVE;
					}
					else {
						newx = newx  + xx;
					}
				}
				else if (newx + xx <=  mySweetspot.left ) {
					newx = newx + xx;
					newscrollx = newscrollx + xx;
				}
				*/
				
			}
			if (xx < 0) { //going left - drift right
				if (newx + xx <= myField.left && wrapHorizontal) { //wrap
					newx = newx + myField.right + xx;
				}
				if (myScreen.left + xx <= myField.left && wrapHorizontal) { // wrap
					newscrollx = newscrollx + myField.right + xx;
				}
				
				newx = newx + xx;
				newscrollx = newscrollx + xx;
				/*
				if (newx +xx < myBoundaries.right) {
					if (myScreen.left < myField.left) {
						newscrollx = newscrollx + X_MOVE;
					}
					else {
						newx = newx + X_MOVE;
					}
				}
				else if (newx  + xx >=  mySweetspot.right ) {
					newx = newx + X_MOVE;
					newscrollx = newscrollx + X_MOVE;
				}
				*/
			}
			if (yy > 0) { // going down
				if (newy + yy >= myField.bottom) { //clip
					newy = myField.bottom ;
				}
				//if (myScreen.bottom + yy >= myField.bottom) { //wrap
				//	newscrolly = newscrolly - myField.bottom + yy;
				//}
				if (newy + yy > myBoundaries.top) {
					if (myScreen.bottom < myField.bottom) {
						newscrolly = newscrolly + yy;
					}
					else {
						newy = newy - yy;
					}
				}
				else if (newy + yy <=  mySweetspot.top ) {
					newy = newy + yy;
					if (myScreen.top < myField.top) {
						newscrolly = newscrolly + yy;
					}
				}
			
				
			}
			if (yy < 0 ) { // up - drift down
				if (newy + yy <= myField.top) { //clip
					newy = myField.top;
				}
				//if (myScreen.top + yy <= myField.top) { // wrap
				//	newscrolly = newscrolly + myField.bottom + yy;
				//}
				if (newy + yy < myBoundaries.bottom) {
					if (myScreen.top < myField.top) {
						newscrolly = newscrolly + yy;
					}
					else {
						newy = newy - yy;
					}
				}
				else if (newy  + yy >=  mySweetspot.bottom ) {
					newy = newy + yy;
					if (myScreen.bottom > myField.bottom) {
						newscrolly = newscrolly + yy;
					}
				}
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
			//var newsprite:Bitmap = new Bitmap();
			
			var i:int ,j:int, k:int,l:int, m:int,n:int, p:int ;

			m = TILEMAP_HEIGHT / TILE_HEIGHT * tilebracket; // 128 * 2 /16 = 16
			n = TILEMAP_WIDTH / TILE_WIDTH; // 224 * 2 /16 = 28
    
			k = int ((num / n) + m  ); // y pos 
			l = int (num - (k * n) + 4  ); // x pos
			
			//trace(n + "copy l="+ l + " k=" + k + " num=" + num + " bits=" + tileset);
			var b:BitmapData = new BitmapData(  TILE_WIDTH, TILE_HEIGHT, true, 0x0);
			//b.draw(tileset);
			//var bits:Bitmap = new Bitmap(b);
			var bitmap:Bitmap = new Bitmap(b);
			bitmap.bitmapData.copyPixels(tileset.bitmapData,
							new Rectangle ( l * TILE_WIDTH, k * TILE_HEIGHT, 
							TILE_HEIGHT, TILE_HEIGHT),
							new Point (0,0) , null, null, true );
			
			
			
			
			return bitmap;
		}
	}
	
}
