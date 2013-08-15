package org.davidliebman.flash.awesomeguy {
	import flash.display.Bitmap;
	import flash.geom.Rectangle;
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.xml.XMLDocument;
	import flash.display.Shape;
	
	public class AGModeGuy extends AGMode{

		var myGuy:AGSpriteGuy;

		static var GUY_CLIMB:int = 1;
		static var GUY_PUNCH:int = 2;
		static var GUY_STEP:int = 3;
		static var GUY_STILL:int = 4;
		static var GUY_FALL:int= 5;

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
		
		var myHorizontal:int = 0;
		var myVertical:int = 0;
		
		public static var X_MOVE = 10 * 2;
		public static var Y_MOVE = 10 * 2;

		public var hit_top:Boolean =false; 
		public var hit_bottom:Boolean= false; 
		public var hit_left:Boolean= false;
		public var hit_right:Boolean = false;
		public var hit_center:Boolean= false;
		public var hit_ladder:Boolean = false;

		public function AGModeGuy() {
			// constructor code
			super();
			levelcheat = 0 ;
			mapcheat = 0;
			this.game_start = true;
		}
		
		public override function componentsInOrder():void {
			//super.componentsInOrder();
			
			
			//physicsAdjustments();
			var myShape:Shape = new Shape();
			myShape.graphics.lineStyle(2, 0xffffffff, 1);
			myShape.graphics.moveTo(0,0);
			myShape.graphics.lineTo(0,SCREEN_HEIGHT );
			myShape.graphics.lineTo(SCREEN_WIDTH, SCREEN_HEIGHT );
			myShape.graphics.lineTo(SCREEN_WIDTH, 0);
			myShape.graphics.lineTo(0,0);
			
			myScreenBG = new Bitmap (new BitmapData (SCREEN_WIDTH, SCREEN_HEIGHT , false, alert_color));
			myScreenBG.x = 0;
			myScreenBG.y = 0;
			myStage.addChild(myScreenBG);
			
			var screenframe:Bitmap= new Bitmap (new BitmapData (SCREEN_WIDTH, 64, false, 0x66666666));
			radarscreen = new Bitmap( new BitmapData(SCREEN_WIDTH - 128, 64,
										false, 0x00000000));
			addSprites();
			
			drawLevelTiles();
			updateSprites();
			drawAnimatedSprites();
			drawRadarRock();

			//
			//agflyer.sprite = this.sprite;
			myGuy.x = xpos;
			myGuy.y = ypos;

			drawScoreWords();
			myStage.addChild(myShape);
			//
			fireButton();
			doTimers();

			checkRegularCollision();

			
			screenframe.x = 0;
			screenframe.y = SCREEN_HEIGHT;
			myStage.addChild(screenframe);
			
			drawRadarPing(radar, radarscreen ,xpos,ypos,AGMode.PING_FLYER,0xffffffff);
			
			radarscreen.x = 64;
			radarscreen.y = SCREEN_HEIGHT;
			myStage.addChild(radarscreen);

			this.detectMovement();

			this.physicsAdjustments();
			this.scrollBackground();
			

		}
		
		public override function doOnce():void {
			
			myDraw = new AGDrawGuy(this, myRes, myStage, myScreenBG);
			myGuy = new AGSpriteGuy(this, AGMode.S_GUY);
			myGuy.active = true;
			myGuy.visible = true;
			myGuy.quality_0 = AGModeGuy.GUY_STEP;
			this.flyersprite = myGuy.bitmap;
			
			this.mySprite.push(myGuy);
			
			this.game_death = false;
			if(game_reset_start == true || this.game_start) {
				setStartingVars();
				myRes[AGResources.NAME_ENTER_1_MP3].play();
				//game_reset_start = false;
			}
			
			
			//flyerrings = new AGSprite(this, AGMode.S_FLYER_RINGS);
			//flyerrings.active = true;
			
			explosionsprite = new AGSprite(this, AGMode.S_EXPLOSION);
			explosionsprite.active = false;
			
			initAGSprite();
			initChallenges();// this just creates the array!!
			initAGTimer();
			setStartingTimers();
			
			
			mySprite[0] = explosionsprite;
			sprite_num ++;
			
			fillChallenges();
			
			var myXml:XMLDocument = new XMLDocument(myRes[AGResources.NAME_AWESOMEGUY_XML]);
			var tree:XML = new XML(myXml);
			planets = int(tree.planet.length());
			challenges = myChallenge.length;
			
			prepTiles() ;
			prepRings() ;
			prepSpecialXml();
			//prepRingSprites();
			
			if (this.game_reset_start ) {
				radar_start = xpos - scrollBGX;
				radar_start_scroll =  scrollBGX;
			}
			
			//agflyer = new AGSprite(this,AGMode.S_FLYER);
			//agflyer.active = true;
			//agflyer.bottomBB = 32;

			this.game_start = false;
			this.game_reset_start = false;
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
			startingx = xpos;
			startingy = ypos;
			
			
			if (this.game_reset_start || this.game_start) {
				xpos = xx * TILE_WIDTH;
				ypos = yy * TILE_HEIGHT;
			
				scrollBGX = xpos - 100;
				scrollBGY = ypos - 100;
			
				startingx = xpos;
				startingy = ypos;
				
			}
		}
		
		public override function prepTiles():void {
			var tempArray:Array = new Array();
			var smallArray:Array = new Array();
			var visibleArray:Array = new Array();
			var invisibleArray:Array = new Array();
			
			var stringVisible:String;
			var stringInvisible:String;
			var myXML:XMLDocument = myRes[AGResources.NAME_AWESOMEGUY_XML];
			
			var mazeNumber:String = String( this.myGame.gameMaze);
			var tree:XML = new XML(myXML);
			
			
			myHoriz = int (tree.planet[myGame.gamePlanet].underground.maze.(@number==mazeNumber).horizontal.toString());
			myVert = int (tree.planet[myGame.gamePlanet].underground.maze.(@number==mazeNumber).vertical.toString());
			
			stringVisible = tree.planet[myGame.gamePlanet].underground.maze.(@number==mazeNumber).visible.toString();
			stringInvisible = tree.planet[myGame.gamePlanet].underground.maze.(@number==mazeNumber).invisible.toString();
			
			var i:int = 0;
			var j:int = 0;
			var k:int = 0;
			
			myVisible = new Array();
			tempArray = new Array();
			tempArray = stringVisible.split(",");
			for (i = 0; i < myVert; i ++ ) {
				smallArray = new Array();
				for (j = 0 ; j < myHoriz; j ++ ) {
					smallArray.push(int (tempArray[ (i * myHoriz) + j ] ) );
				}
				myVisible.push(smallArray);
			}
			
			myInvisible = new Array();
			tempArray = new Array();
			tempArray = stringInvisible.split(",");
			for (i = 0; i < myVert; i ++ ) {
				smallArray = new Array();
				for (j = 0 ; j < myHoriz; j ++ ) {
					k = int (tempArray[ (i * myHoriz) + j ] );
					smallArray.push(int (tempArray[ (i * myHoriz) + j ] ) );
					//if (k + mapcheat == AGModeFlyer.B_MONSTER) addMonster(j,i ,0);
					//if (k + mapcheat == AGModeFlyer.B_PLATFORM) addPlatform(j , i );
					if (k + mapcheat == AGModeGuy.B_START) startingPos(j,i); // only do on 'reset start'
				}
				myInvisible.push(smallArray);
			}
			
		}
		
		public  function fillChallenges():void {
			
		}
		
		public function prepRings():void {
			
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
			var i:int = 0;
			mySprite.push(myGuy);
			
			for( i= 0; i < myTemp.length; i ++ ) {
				mySprite.push(myTemp[i]);
			}
			myTemp = new Array();
			for ( i = 0; i < myHold.length; i ++ ) {
				mySprite.push(myHold[i]);
			}
		}
		
		public function doTimers():void {
			
		}
		
		public function updateSprites():void {
			var i:int;
			//var anim:Boolean = this.animate_enter_maze;
			
			for (i = 0; i < mySprite.length; i ++ ) {
				if (mySprite[i].active == true ){
					mySprite[i].updateSprite();
//					if ((mySprite[i].sprite_type != AGMode.S_EXPLOSION_SPRITE ) || 
//						(mySprite[i].sprite_type == AGMode.S_BUBBLE_MAZE )) {
//						mySprite[i].updateSprite();
//					}
//					
					if (mySprite[i].sprite_type == AGMode.S_GUY) myDraw.drawBasicSprite(mySprite[i], D_GUY);
//					if (mySprite[i].sprite_type == AGMode.S_LINE ) myDraw.drawBasicSprite(mySprite[i], D_LINE_1);
//					if (mySprite[i].sprite_type == AGMode.S_BUBBLE_1) myDraw.drawBasicSprite(mySprite[i], D_BUBBLE_1);
//					
//					if (mySprite[i].sprite_type == AGMode.S_BUBBLE_3) myDraw.drawBasicSprite(mySprite[i], D_BUBBLE_3);
//					if (mySprite[i].sprite_type == AGMode.S_BUBBLE_2) myDraw.drawBasicSprite(mySprite[i], D_BUBBLE_2);
//					if (mySprite[i].sprite_type == AGMode.S_INVADER_1) myDraw.drawBasicSprite(mySprite[i], D_INVADER_1);
//					if (mySprite[i].sprite_type == AGMode.S_INVADER_2) myDraw.drawBasicSprite(mySprite[i], D_INVADER_2);
					
				}
				
			}
		}
		public function drawAnimatedSprites():void {
			
		}
		
		public function drawLevelTiles():void {
			var  i:int,j:int,k:int,l:int,m:int, zz:int;
			
			var baseX:int, baseY:int;//, startX, startY;
			
			
			var TILE_WIDTH:int = 64;
			var TILE_HEIGHT:int = 64;
			
			var tilesWidthMeasurement:int =   32;
			var tilesHeightMeasurement:int =  24;//
			
			var LONG_MAP_H:int =	this.myHoriz;
			var LONG_MAP_V:int =	this.myVert;
			//animate = newBG + 1;
			//var animate:int = 0;
			this.myBlocks = new Array();
			
			var square:AGSprite;
		
			/* draw background */
			baseX = scrollBGX / TILE_WIDTH;
			baseY = scrollBGY / TILE_HEIGHT;
			
			for ( j = baseX - 1 ; j < baseX + tilesWidthMeasurement + 3; j++) { //32
				for ( i = baseY - 1 ; i < baseY + tilesHeightMeasurement + 3; i ++ ) { //24
					
					if (i >= 0 && j >= 0  && i < LONG_MAP_V && j < LONG_MAP_H) { 
					
						
						
						if(  myVisible[i][j] != 0 ) {// && myVisible[i][j] != AGModeGuy.B_GOAL  ) { //is tile blank??
							//trace(myVisible[i][j]);
							square = new AGSprite(this,AGMode.S_BLOCK);
							square.bitmap = cutTile(  myRes[AGResources.NAME_TILES1_PNG], 
									myVisible[i][j] + levelcheat,
									AGMode.TILE_BOT);
							
							
							square.bitmap.x = new Number ((j * TILE_WIDTH ) - scrollBGX);
							square.bitmap.y = new Number ((i * TILE_HEIGHT) - scrollBGY);
							myStage.addChild(square.bitmap);
							if (myInvisible[i][j] + mapcheat == AGModeGuy.B_BLOCK) {
								this.myBlocks.push(square);
								
							}
							if (myInvisible[i][j] + mapcheat == AGModeGuy.B_LADDER){ 
								square.sprite_type = AGMode.S_LADDER;
								this.myBlocks.push(square);
							}
							
						}
						
						
		
					} // if i,j > 0, etc...
				
					//////////////////////////////////////////
					
					
				}
			}
			
			return ;
		}
		public override function scrollBackground():void {
			this.wrapHorizontal = false;
			this.spriteWidth = 64;
			this.spriteHeight = 128;
			
			myField.top = 0;
			myField.bottom = myVert * TILE_HEIGHT;
			myField.left = 0;
			myField.right = myHoriz * TILE_WIDTH;
			
			myScreen.top = scrollBGY;
			myScreen.bottom = scrollBGY + SCREEN_HEIGHT;
			myScreen.left = scrollBGX;
			myScreen.right = scrollBGX + SCREEN_WIDTH;
			
			myBoundaries.top = myScreen.top + (2 * TILE_HEIGHT) + 0;
			myBoundaries.bottom = myScreen.bottom - (2 * TILE_HEIGHT) - spriteHeight;
			myBoundaries.left = myScreen.left + (5 * TILE_WIDTH) + 0;
			myBoundaries.right = myScreen.right - (5 * TILE_WIDTH) - spriteWidth;
			
			mySweetspot.top = myBoundaries.top + (Y_MOVE * 3/2);
			mySweetspot.bottom = myBoundaries.bottom - (Y_MOVE * 3/2) ;
			mySweetspot.left = myBoundaries.left + (X_MOVE * 3/2) ;
			mySweetspot.right = myBoundaries.right - (X_MOVE * 3/2);
			
			var newx:int = xpos;
			var newy:int = ypos;
			
			var newscrollx:int = scrollBGX;// myScreen.left;
			var newscrolly:int = scrollBGY;// myScreen.top;
			
			var wrappingNow:Boolean = false;
			
			
			//change values
			if (xx > 0) { // going right 
				
				if (newx + xx >= myField.right - spriteWidth) { //clip
					newx = myField.right - spriteWidth;
					
				}
				if (newx + xx < myField.right - spriteWidth) {
					newx = newx + xx;
					
					if (myScreen.right <= myField.right && newx + xx >= myBoundaries.left  ) {
						newscrollx = newscrollx + xx;
					}
					else {
						//newx -= xx;
					}
					
				}
				//myGuy.facingRight = true;
				myGuy.quality_0 = AGModeGuy.GUY_STEP;
			}
			if (xx < 0) { //going left 
			
				if (newx + xx <= myField.left) { //clip
					newx = myField.left;
					
				}
				
				
				if (newx + xx > myField.left ) {
					newx = newx + xx;
					
					if (myScreen.left + xx >= myField.left && newx + xx <= myBoundaries.right ) {
						newscrollx = newscrollx + xx;
					}
					else {
						//newx -= xx;
					}
					
					
				}
			
				//myGuy.facingRight = false;
				myGuy.quality_0 = AGModeGuy.GUY_STEP;
			}
			if (yy > 0) { // going down
				if (newy + yy >= myField.bottom - spriteHeight) { //clip
					newy = myField.bottom - spriteHeight;
					//flyerGrounded = true;// ??
					//newscrolly = myField.bottom - myScreen.bottom + spriteHeight;
				}
				if (newy + yy < myField.bottom - spriteHeight) {
					newy = newy + yy;
					
					if (myScreen.bottom <= myField.bottom  && newy + yy >= myBoundaries.top) {
						newscrolly = newscrolly + yy;
					}
					else {
						//newy -= yy;
					}
				}
				
				
			}
			if (yy < 0 ) { // up 
				if (newy + yy <= myField.top) { //clip
					newy = myField.top;
					newscrolly = myField.top; // bad hack...
				}
				
				
				if (newy + yy > myField.top ) {
					newy = newy + yy;
					
					if (myScreen.top  >= myField.top && newy + yy <= myBoundaries.bottom  ) {
						newscrolly = newscrolly + yy;
					}
					else {
						//newy -= yy;
					}
					
					
				}
				
				
				//////////////////////////////
				
			}
			
			scrollBGX = newscrollx;
			scrollBGY = newscrolly;
			xpos = newx;
			ypos = newy;
			
		}
		public override function detectMovement():void {
			xx = 0;
			yy = 0;
			if ( K_LEFT  ) {
				if (!this.hit_left) xx = - X_MOVE;
				else if (!this.hit_right) xx = int (X_MOVE / 1);
				myGuy.facingRight = false;
				this.facingRight = false;
				
			}
			if (K_RIGHT ) {
				if (!this.hit_right) xx = + X_MOVE;
				else if (!this.hit_left) xx = - int (X_MOVE / 1);
				myGuy.facingRight = true;
				this.facingRight = true;
				
			}
			if (K_UP ) {
				
				if (this.hit_ladder) {
					yy = - Y_MOVE;
					if(!this.hit_bottom) myGuy.quality_0 = AGModeGuy.GUY_CLIMB;
				}
				
			}
			if (K_DOWN ) {
				if (!this.hit_bottom) yy = + Y_MOVE;
				else if (!this.hit_top) yy = - Y_MOVE;
				if (this.hit_ladder && !this.hit_bottom) {
					yy =  Y_MOVE;
					if(!this.hit_bottom) myGuy.quality_0 = AGModeGuy.GUY_CLIMB;
				}
			}
			//if (K_JUMP) {
				//trace(K_JUMP);
				
			//}
			if (xx  == 0 && yy == 0) myGuy.quality_0 = AGModeGuy.GUY_STILL;
			
		}
		public override function fireButton():void {
			
		}
		
		public override function cutTile(  tileset:Bitmap, num:int , tilebracket:int ):Bitmap {
			
			var i:int ,j:int, k:int,l:int, m:int,n:int, p:int ;

			m = int ( int (TILEMAP_HEIGHT / TILE_HEIGHT) * tilebracket) ; // 128 * 2 /64 = 4
			n = int ( TILEMAP_WIDTH / TILE_WIDTH) ; // 224 * 2 /64 = 7
    
			k = int (((num -1)/ n)   ); // y pos //14 / 7 = 2
			l = int (num - (k * n) -1  ) ; // x pos // 14 - 14 - 1
			//trace (num,k,l, TILE_HEIGHT, TILEMAP_HEIGHT, TILEMAP_WIDTH);
			
			
			k = k + m; // must come after!!
			
			var b:BitmapData = new BitmapData(  TILE_WIDTH, TILE_HEIGHT, true, 0x0);
			
			var bitmap:Bitmap = new Bitmap(b);
			bitmap.bitmapData.copyPixels(tileset.bitmapData,
							new Rectangle ( l * TILE_WIDTH, k * TILE_HEIGHT, 
							TILE_HEIGHT, TILE_HEIGHT),
							new Point (0,0) , null, null, true );
			
			
			return bitmap;
		}
		
		public override function adjust_x( xxx:int ):int {
			return xxx;
		}
		
		public override function physicsAdjustments():void {
				//this version for overriding
				
				switch(myGuy.quality_0) {
					case AGModeGuy.GUY_STEP:
					
						if ( this.hit_bottom && this.hit_center && !this.hit_left && !this.hit_right) {
							yy = yy - 2;
						}
						if (!this.hit_bottom && !this.hit_center && !this.hit_ladder) {
							yy = AGModeGuy.Y_MOVE;
						}
						
					break;
					case AGModeGuy.GUY_STILL:
					case AGModeGuy.GUY_FALL:
						if (!this.hit_bottom && !this.hit_center && !this.hit_ladder) {
							yy = AGModeGuy.Y_MOVE;
						}
					
					break;
				}
				
				
				
				
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
						
						
						square.x = (scorePos + i) * TILE_WIDTH  ;
						square.y = (1) * TILE_HEIGHT ;
						myStage.addChild(square);
	
						square = cutTile(myRes[AGResources.NAME_TILES1_PNG], topScore[i] +28 + 1, AGMode.TILE_TOP);
	
						
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
						
						square = cutTile(myRes[AGResources.NAME_TILES1_PNG],  topLives[i] + 28 + 1,AGMode.TILE_TOP );
	
						
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
	
						square.x = (pos + i - p + c) * TILE_WIDTH;
						square.y = (1) * TILE_HEIGHT;
						myStage.addChild(square);
	
						square = cutTile(myRes[AGResources.NAME_TILES1_PNG], topNumbers[placesValue] +28 + 1, AGMode.TILE_TOP);
	
						square.x = (pos + i - p + c) * TILE_WIDTH;
						square.y = (2) * TILE_HEIGHT;
						myStage.addChild(square);
						
				}
	
			}
		} 
		
		public function drawRadarRock():void {

			var xxx:int,yyy:int;
			for (xxx = 0; xxx < myHoriz; xxx ++ ) {
				for(yyy = 0; yyy < myVert; yyy ++ ) {
		
					if (myInvisible[yyy][xxx] + mapcheat == B_BLOCK) {
						
						drawRadarPing(radar, radarscreen, xxx * TILE_WIDTH, yyy * TILE_HEIGHT, PING_ROCK, 0xffffffff);
					}
					else if (myVisible[yyy][xxx]  != B_SPACE) {
						drawRadarPing(radar, radarscreen, xxx * TILE_WIDTH, yyy * TILE_HEIGHT, PING_ROCK, 0xff903590);//0xff889be7);
						
					}
					
				}
			}
		}
		
		public function checkRegularCollision():void {
			
			var ii:int;
			for (ii = 0; ii < mySprite.length ; ii ++ ) {
				if (mySprite[ii].bitmap != null) {
					if (this.collisionSimple(mySprite[ii].bitmap, this.flyersprite) 
						&& mySprite[ii].active == true ) {
							var sprite:AGSprite = mySprite[ii];
						switch (sprite.sprite_type) {
							case AGMode.S_RING:
								
								
								
								//myChallenge[myGame.gameChallenge].total_held_rings ++ ;
							break;
							
							case AGMode.S_GATOR:
								if (sprite.bitmap.getBounds(myStage).bottom  >
									this.flyersprite.getBounds(myStage).bottom) {
									sprite.active = false;
									sprite.visible = false;
									myGame.gameScore += 10;
									
									break;
								}
							
							case AGMode.S_BUBBLE_2:
							case AGMode.S_INVADER_1:
							case AGMode.S_INVADER_2:
								//this.agflyer.active = false;
								//this.agflyer.visible = false;
								sprite.active = false;
								sprite.visible = true;//true
								//flyerDeath();
							break;
							
							
						}//switch
					}// collision simple
				}
			}
			
			///////////
			for (ii = 0; ii < myTorpedo.length ; ii ++ ) {
				for (var jj:int = 0; jj < mySprite.length ; jj ++) {
					var shot:AGSpriteTorpedo = myTorpedo[ii];
					sprite = mySprite[jj];
					if (sprite.bitmap != null && shot.bitmap != null && 
						sprite.active && 
						shot.active &&
						//sprite.sprite_type != AGMode.S_EXPLOSION_SPRITE &&
						this.collisionSimple( sprite.bitmap, shot.bitmap)) {
						
						myRes[AGResources.NAME_BOOM_MP3].play();
						shot.active = false;
						shot.visible = false;
						
						switch (sprite.sprite_type) {
							case AGMode.S_BUBBLE_1:
								sprite.active = false;
								myGame.gameScore += 10;
								//myChallenge[ myGame.gameChallenge].total_bubble_1 --;
							break;
							
							case AGMode.S_BUBBLE_2:
								sprite.active = false;
								myGame.gameScore +=10;
								//myChallenge[ myGame.gameChallenge].total_bubble_2 --;
							break;
							
							case AGMode.S_BUBBLE_3:
								sprite.active = false;
								myGame.gameScore += 10;
								//myChallenge[ myGame.gameChallenge].total_bubble_3 --;
							break;
							
							case AGMode.S_GATOR:
								sprite.active = false;
								myGame.gameScore += 10;
							break;
							
							case AGMode.S_INVADER_1:
								myGame.gameScore += 10;
								
								sprite.sprite_type = AGMode.S_EXPLOSION_SPRITE;
							break;
							
							case AGMode.S_INVADER_2:
								sprite.quality_3 = P_NONE;
								myGame.gameScore += 10;
								sprite.sprite_type = AGMode.S_EXPLOSION_SPRITE;


							break;
						}//switch
							
						
					}// if !null
				}// for sprite
			}//for torpedo
			
			this.hit_bottom = false;
			this.hit_left = false;
			this.hit_right = false;
			this.hit_top = false;
			this.hit_center = false;
			this.hit_ladder = false;
			
			for (ii = 0; ii < myBlocks.length; ii ++) {
				if (myBlocks[ii].bitmap != null && this.flyersprite != null) {
					if (this.collisionBlock(myBlocks[ii].bitmap, myDraw.rail_left) && 
						myBlocks[ii].sprite_type == AGMode.S_BLOCK) {
							
						if(myBlocks[ii].bitmap.y  < 
						   myDraw.rail_left.y + (myDraw.rail_left.height / 2) ) {
							this.hit_left = true;
						}
						
						
						//this.hit_left = true;
						//this.examineHit(myBlocks[ii].bitmap, myDraw.rail_left);
					}
					if (this.collisionBlock(myBlocks[ii].bitmap, myDraw.rail_right)&& 
						myBlocks[ii].sprite_type == AGMode.S_BLOCK) {
							
						if(myBlocks[ii].bitmap.y  < 
						   myDraw.rail_right.y + (myDraw.rail_right.height / 2) ) {
							this.hit_right = true;
						}
						
						//this.hit_right = true;
						//this.examineHit(myBlocks[ii].bitmap, myDraw.rail_right);
					}
					if (this.collisionBlock(myBlocks[ii].bitmap, myDraw.rail_top)&& 
						myBlocks[ii].sprite_type == AGMode.S_BLOCK) {
						this.hit_top = true;
						//this.examineHit(myBlocks[ii].bitmap, myDraw.rail_top);
					}
					if (this.collisionBlock(myBlocks[ii].bitmap, myDraw.rail_bottom) && 
						myBlocks[ii].sprite_type == AGMode.S_BLOCK) {
						this.hit_bottom = true;
						//this.examineHit(myBlocks[ii].bitmap, myDraw.rail_bottom);
					}
				}
				
				if (myBlocks[ii].bitmap != null && this.flyersprite != null &&
					collisionBlock(myBlocks[ii].bitmap, this.flyersprite)) {
					//this.hittype = AGModeGuy.HIT_NONE;

					if (myBlocks[ii].sprite_type == AGMode.S_BLOCK) {
						//examineHit(myBlocks[ii].bitmap, this.flyersprite);
						this.hit_center = true;
					}
					
					if (myBlocks[ii].sprite_type == AGMode.S_GOAL) {
						//myGame.gameScore = myGame.gameScore + ( myChallenge[myGame.gameChallenge].total_held_rings * 20);
						//myChallenge[myGame.gameChallenge].total_held_rings = 0;
						is_blinking = true;
						
						//myTimer[ AGMode.TIMER_07] = new AGTimer(1.5);//.timerStart(3);
					}
					if (myBlocks[ii].sprite_type == AGMode.S_LADDER) {
						if (!this.hit_bottom) this.hit_ladder = true;
						//trace("ladder!");
					}
				}
				
				
			}
			return;
		}
		
		
		
	}
	
}
