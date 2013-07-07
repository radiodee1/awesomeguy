package org.davidliebman.flash.awesomeguy {
	import flash.xml.XMLDocument;
	import flash.display.Sprite;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	
	public class AGModeFlyer extends AGMode{


		public function AGModeFlyer() {
			// constructor code
		}
		
		public override function componentsInOrder():void {
			//
			super.componentsInOrder();
			
			
			drawLevel();


			drawBasicSprite(0, AGMode.S_FLYER);
			var screenframe:Bitmap = new Bitmap (new BitmapData (SCREEN_WIDTH, 64, false, 0x66666666));
			screenframe.x = 0;
			screenframe.y = SCREEN_HEIGHT;
			myStage.addChild(screenframe);
			
			var screenBitmap:Bitmap = new Bitmap( new BitmapData(SCREEN_WIDTH - 128, 64,
										false, 0x00000000));
			drawRadarPing(radar,screenBitmap,xpos,ypos,AGMode.PING_FLYER,0xffffffff);
			
			screenBitmap.x = 64;
			screenBitmap.y = SCREEN_HEIGHT;
			myStage.addChild(screenBitmap);
		}
		
		public override function doOnce():void {
			
			//myStage.addChild(myRes[AGResources.NAME_FLYER_L0_PNG]);
			
			prepTiles() ;
			radar_start = xpos - scrollBGX;
			radar_start_scroll =  scrollBGX;
			//trace (radar_start + " scroll:" + scrollBGX);
			//myRes[AGResources.NAME_EXPLOSION_MP3].play();
		}
		
		public override function prepTiles():void {
			var tempArray:Array = new Array();
			var smallArray:Array = new Array();
			var visibleArray:Array = new Array();
			var invisibleArray:Array = new Array();
			
			var stringVisible:String;
			var stringInvisible:String;
			var myXML:XMLDocument = myRes[AGResources.NAME_AWESOMEGUY_XML];
			
			var tree:XML = new XML(myXML);
			//trace (tree.planet[myGame.gamePlanet].horizontal);
			
			myHoriz = int (tree.planet[myGame.gamePlanet].horizontal.toString());
			myVert = int (tree.planet[myGame.gamePlanet].vertical.toString());
			

			stringVisible = tree.planet[myGame.gamePlanet].horizon.visible.toString();
			stringInvisible = tree.planet[myGame.gamePlanet].horizon.invisible.toString();

			var i:int = 0;
			var j:int = 0;
			
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
					smallArray.push(int (tempArray[ (i * myHoriz) + j ] ) );
				}
				myInvisible.push(smallArray);
			}
			
			//trace(myVisible);
		}
		
		///////////////////////////////////////////
		public function drawLevel():void {
    var  i:int,j:int,k:int,l:int,m:int, zz:int;
	
    var baseX:int, baseY:int;//, startX, startY;
    var mapcheat:int = -3;
    var levelcheat:int = -3;
	var TILE_WIDTH:int = 16;
	var TILE_HEIGHT:int = 16;
	
	var tilesWidthMeasurement:int = 32;
	var tilesHeightMeasurement:int = 24;//32;
    //uint16_t square[TILE_HEIGHT][TILE_WIDTH];
    
    //uint16_t  **  screen = (getScreenPointer(MY_SCREEN_BACK));
    //var map_level:Array = myVisible;
	//var map_objects:Array = myInvisible;
    var LONG_MAP_H:int =	192;
	var LONG_MAP_V:int =	32;
    //animate = newBG + 1;
    //var animate:int = 0;
			
	
	var square:Bitmap;

    /* clear screen */
    //alertOnScreen();
    //memset(screen, alert_color, (SCREEN_HEIGHT + LONG_MAP_V)* SCREEN_WIDTH * 2);
    
    /* draw bubbles behind mountains */
    //drawBubbleType0();
    //drawBubbleType1();
    //drawBubbleType2();
    //drawBubbleWithColor();

    /* draw background */
    baseX = scrollBGX / TILE_WIDTH;
    baseY = scrollBGY / TILE_HEIGHT;
    
	for ( j = baseX - 1 ; j < baseX + tilesWidthMeasurement + 3; j++) { //32
    	for ( i = baseY - 1 ; i < baseY + tilesHeightMeasurement + 3; i ++ ) { //24
    		
    		if (i >= 0 && j >= 0  && i < LONG_MAP_V && j < LONG_MAP_H) { 
    		//trace("i"+i+" j" + j + " = " + myVisible[i][j]);
    			
				//LOGE("map_level %d", map_level[j][i] );
    			if(  myVisible[i][j] != 0  && myVisible[i][j] != AGMode.B_GOAL  ) { //is tile blank??
    				//trace(myVisible);
					square = cutTile(  myRes[AGResources.NAME_TILES1_PNG], 
							myVisible[i][j] - levelcheat,
							AGMode.TILE_TOP);
					
					square.x = new Number ((j * TILE_WIDTH ) - scrollBGX);
					square.y = new Number ((i * TILE_HEIGHT) - scrollBGY);
					myStage.addChild(square);
    				//drawTile_8(square, j * TILE_WIDTH, i * TILE_HEIGHT , 
    				//	scrollx , scrolly, PAINT_TRANSPARENT, 0);
					
				}
				
				// special animated tiles
				k = myInvisible[i][j] ;
				zz = k - levelcheat;
				if ( zz != AGMode.B_START && zz != AGMode.B_MONSTER && zz != AGMode.B_DEATH
    				&& zz != AGMode.B_PLATFORM && zz != AGMode.B_MARKER && zz != AGMode.B_BLOCK
    				&& zz != AGMode.B_LADDER  && k != AGMode.B_SPACE  && zz != AGMode.B_GOAL) {
    				
    				
    				if (animate == 0 || animate == 1 || animate == 8) {

    		    		//cutTile(tiles_a, square, k - mapcheat);
						square = cutTile(  myRes[AGResources.NAME_TILES1_PNG], 
							myInvisible[i][j] - levelcheat,
							AGMode.TILE_TOP);
    				}
    				else if (animate == 2 || animate == 4 || animate == 6) {

    		    		//cutTile(tiles_b, square, k - mapcheat);
						square = cutTile(  myRes[AGResources.NAME_TILES2_PNG], 
							myInvisible[i][j] - levelcheat,
							AGMode.TILE_TOP);
    				}
    				else if (animate == 3 || animate == 7) {

    		    		//cutTile(tiles_c, square, k - mapcheat);
						square = cutTile(  myRes[AGResources.NAME_TILES3_PNG], 
							myInvisible[i][j] - levelcheat,
							AGMode.TILE_TOP);
    				}
    				else if (animate == 5) {

    		    		//cutTile(tiles_d, square, k - mapcheat);
						square = cutTile(  myRes[AGResources.NAME_TILES4_PNG], 
							myInvisible[i][j] - levelcheat,
							AGMode.TILE_TOP);
    				}
    				
					square.x = new Number ((j * TILE_WIDTH ) - scrollBGX);
					square.y = new Number ((i * TILE_HEIGHT) - scrollBGY);
					myStage.addChild(square);

    				//drawTile_8(square, j * TILE_WIDTH, i * TILE_HEIGHT , 
    				//	scrollx , scrolly, PAINT_TRANSPARENT, number_alpha);
    			}
				


			} // if i,j > 0, etc...
		
			//////////////////////////////////////////
			if (j  >= LONG_MAP_H || true) {
				//draw all of level again.
				m =  (LONG_MAP_H  );
				
				
				if (i >= 0 && j-m >= 0  && i < LONG_MAP_V && j-m < LONG_MAP_H) { 
				if(  myVisible[i][j-m] != 0 && myVisible[i][j-m] != B_GOAL  ) { //is tile blank??
    				//cutTile(tiles_a, square, map_level[j-m][i] - levelcheat);
    				square = cutTile(  myRes[AGResources.NAME_TILES1_PNG], 
							myVisible[i][j-m] - levelcheat,
							AGMode.TILE_TOP);
    				//drawTile_8(square, j  * TILE_WIDTH, i * TILE_HEIGHT , 
    				//	scrollx , scrolly, PAINT_TRANSPARENT, 0);
					square.x = new Number ((j * TILE_WIDTH ) - scrollBGX);
					square.y = new Number ((i * TILE_HEIGHT) - scrollBGY);
					myStage.addChild(square);
				}
				
				// special animated tiles
				k = myInvisible[i][ j-m] ;//- levelcheat;
				zz = k - levelcheat;
				if ( zz != B_START && zz != B_MONSTER && zz != B_DEATH
    				&& zz != B_PLATFORM && zz != B_MARKER && zz != B_BLOCK
    				&& zz != B_LADDER  && k != B_SPACE && zz != B_GOAL) {
    				
    				
    				if (animate == 0 || animate == 1 || animate == 8) {

    		    		//cutTile(tiles_a, square, k - mapcheat);
						square = cutTile(  myRes[AGResources.NAME_TILES1_PNG], 
							k - levelcheat,
							AGMode.TILE_TOP);
    				}
    				else if (animate == 2 || animate == 4 || animate == 6) {

    		    		//cutTile(tiles_b, square, k - mapcheat);
						square = cutTile(  myRes[AGResources.NAME_TILES2_PNG], 
							k - levelcheat,
							AGMode.TILE_TOP);
    				}
    				else if (animate == 3 || animate == 7) {

    		    		//cutTile(tiles_c, square, k - mapcheat);
						square = cutTile(  myRes[AGResources.NAME_TILES3_PNG], 
							k - levelcheat,
							AGMode.TILE_TOP);
    				}
    				else if (animate == 5) {

    		    		//cutTile(tiles_d, square, k - mapcheat);
						square = cutTile(  myRes[AGResources.NAME_TILES4_PNG], 
							k - levelcheat,
							AGMode.TILE_TOP);
    				}
    				

    				//drawTile_8(square, j * TILE_WIDTH, i * TILE_HEIGHT , 
    				//	scrollx , scrolly, PAINT_TRANSPARENT, number_alpha);
					square.x = new Number ((j * TILE_WIDTH ) - scrollBGX);
					square.y = new Number ((i * TILE_HEIGHT) - scrollBGY);
					myStage.addChild(square);
				}
				
			}// if j-m > 0 etc.

			}
			
			if (j < 0 ) {
			m =  (LONG_MAP_H  );
			
			if (i >= 0 && j+m >= 0  && i < LONG_MAP_V && j+m < LONG_MAP_H) {
			if(  myVisible[i][j+m] != 0 && myVisible[i][j+m] != B_GOAL  ) { //is tile blank??
    				//cutTile(tiles_a, square, map_level[j-m][i] - levelcheat);
    				square = cutTile(  myRes[AGResources.NAME_TILES1_PNG], 
							myVisible[i][j+m] - levelcheat,
							AGMode.TILE_TOP);
    				//drawTile_8(square, j  * TILE_WIDTH, i * TILE_HEIGHT , 
    				//	scrollx , scrolly, PAINT_TRANSPARENT, 0);
					square.x = new Number ((j * TILE_WIDTH ) - scrollBGX);
					square.y = new Number ((i * TILE_HEIGHT) - scrollBGY);
					myStage.addChild(square);
				}
				
				/////////////////////////////////////////////
					// special animated tiles
				k = myInvisible[i][ j+m] ;//- levelcheat;
				zz = k - levelcheat;
				if ( zz != B_START && zz != B_MONSTER && zz != B_DEATH
    				&& zz != B_PLATFORM && zz != B_MARKER && zz != B_BLOCK
    				&& zz != B_LADDER  && k != B_SPACE && zz != B_GOAL) {
    				
    				
    				if (animate == 0 || animate == 1 || animate == 8) {

    		    		//cutTile(tiles_a, square, k - mapcheat);
						square = cutTile(  myRes[AGResources.NAME_TILES1_PNG], 
							k - levelcheat,
							AGMode.TILE_TOP);
    				}
    				else if (animate == 2 || animate == 4 || animate == 6) {

    		    		//cutTile(tiles_b, square, k - mapcheat);
						square = cutTile(  myRes[AGResources.NAME_TILES2_PNG], 
							k - levelcheat,
							AGMode.TILE_TOP);
    				}
    				else if (animate == 3 || animate == 7) {

    		    		//cutTile(tiles_c, square, k - mapcheat);
						square = cutTile(  myRes[AGResources.NAME_TILES3_PNG], 
							k - levelcheat,
							AGMode.TILE_TOP);
    				}
    				else if (animate == 5) {

    		    		//cutTile(tiles_d, square, k - mapcheat);
						square = cutTile(  myRes[AGResources.NAME_TILES4_PNG], 
							k - levelcheat,
							AGMode.TILE_TOP);
    				}
    				

    				//drawTile_8(square, j * TILE_WIDTH, i * TILE_HEIGHT , 
    				//	scrollx , scrolly, PAINT_TRANSPARENT, number_alpha);
					square.x = new Number ((j * TILE_WIDTH ) - scrollBGX);
					square.y = new Number ((i * TILE_HEIGHT) - scrollBGY);
					myStage.addChild(square);
				}
				
			}
		
			}
			
    	}
    }
    
	//drawRadarRock();

    /* draw moving platform */
    //drawMovingPlatform();
    
    /* draw score and level */
    //drawScoreWords();
    

    /* draw monsters */
    //if (preferences_monsters == TRUE) {
    //    drawMonsters();
    //}
    
    //if (preferences_monsters == TRUE && preferences_collision == TRUE && animate_only == FALSE) {
    //    collisionWithMonsters();
    //}
    


    //if (! animate_only ) {
    //	drawInvaderType1();
    //	drawInvaderType2();
    //}

  	/* draw guy with animation */
    //if (! animate_only) {
    //	drawFlyer();
    //	drawBasicSprite(0, D_FLYER_RINGS);
    //}
	

	//drawBasicSprite(0, D_EXPLOSION);

	//drawSpriteExplosion();

	//drawBoundingBox(radar_box, BB_NO_SCROLL, 0xffff);

	//drawLasers( );

	//drawTorpedo();

	//checkRegularCollision();
	
	return ;
}
		///////////////////////////////////////////
		public override function physicsAdjustments():void {
			if (yy < 0) flyerGrounded = false;
			
			if (flyerGrounded) return;
			
			if (xx + yy == 0 ) {
				//ypos = ypos + 
				yy = (Y_MOVE / 2);
				if (facingRight) {
					//xpos = xpos + 
					xx = (X_MOVE / 2);
				}
				else {
					//xpos = xpos 
					xx = - (X_MOVE / 2);
				}
			}
		}
	
	}
	
}
