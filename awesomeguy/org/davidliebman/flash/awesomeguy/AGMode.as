package  org.davidliebman.flash.awesomeguy {
	import flash.display.Stage;
	import flash.events.Event;
	import flash.geom.Rectangle;
	
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
	
	//scroll variables
	public var spriteHeight:int = 40;
	public var spriteWidth:int = 90;
	var myField:Rectangle = new Rectangle();
	var myScreen:Rectangle = new Rectangle();
	var myBoundaries:Rectangle = new Rectangle();
	var myHoriz:int = 0;
	var myVert:int = 0;
	var scrollBGX:int = 0;
	var scrollBGY:int = 0;
	var xx:int = 0;
	var yy:int = 0;
	public static var X_MOVE = 3 * 2;
	public static var Y_MOVE = 3 * 2;
	var xpos:int = 100;
	var ypos:int = 100;
	
	public var wrapHorizontal:Boolean = true;
	
	public var myVisible:Array;
	public var myInvisible:Array;

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
			myField.bottom = myVert * 8 *2;
			myField.left = 0;
			myField.right = myHoriz * 8 * 2;
			
			myScreen.top = scrollBGY;
			myScreen.bottom = scrollBGY + 384;
			myScreen.left = scrollBGX;
			myScreen.right = scrollBGX + 512;
			
			myBoundaries.top = myScreen.top + 20 + 0;
			myBoundaries.bottom = myScreen.bottom - 20 - spriteHeight;
			myBoundaries.left = myScreen.left + (5 * 8 * 2) + 0;
			myBoundaries.right = myScreen.right - (5 * 8 * 2) - spriteWidth;
			
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
				if (newx + xx > myBoundaries.left) {
					if (myScreen.right < myField.right) {
						newscrollx = newscrollx + X_MOVE;
					}
					else {
						newx = newx + X_MOVE;
					}
				}
				else if (newx + xx <=  myBoundaries.left ) {
					newx = newx + xx;
					newscrollx = newscrollx + xx;
				}
				
			}
			if (xx < 0) { //going left - drift right
				if (newx + xx <= myField.left && wrapHorizontal) { //wrap
					newx = newx + myField.right + xx;
				}
				if (myScreen.left + xx <= myField.left && wrapHorizontal) { // wrap
					newscrollx = newscrollx + myField.right + xx;
				}
				if (newx +xx < myBoundaries.right) {
					if (myScreen.left < myField.left) {
						newscrollx = newscrollx + X_MOVE;
					}
					else {
						newx = newx + X_MOVE;
					}
				}
				else if (newx  + xx >=  myBoundaries.right ) {
					newx = newx + X_MOVE;
					newscrollx = newscrollx + X_MOVE;
				}
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
				else if (newy + yy <=  myBoundaries.top ) {
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
				else if (newy  + yy >=  myBoundaries.bottom ) {
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
				trace(xx);
			}
			if (K_RIGHT ) {
				xx = + X_MOVE;
				trace(xx);
			}
			if (K_UP ) {
				yy = - Y_MOVE;
				trace (yy);
			}
			if (K_DOWN ) {
				yy = + Y_MOVE;
				trace ("y"+yy);
			}
		}
	}
	
}
