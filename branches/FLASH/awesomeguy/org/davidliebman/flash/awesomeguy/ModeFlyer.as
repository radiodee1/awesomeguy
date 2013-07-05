package org.davidliebman.flash.awesomeguy {
	import flash.xml.XMLDocument;
	import flash.display.Sprite;
	
	public class ModeFlyer extends AGMode{

		var sprite:Sprite = new Sprite();

		public function ModeFlyer() {
			// constructor code
		}
		
		public override function componentsInOrder():void {
			//
			super.componentsInOrder();
			
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
			sprite.x = xpos - scrollBGX;
			sprite.y = ypos - scrollBGY;
			myStage.addChild(sprite);
		}
		
		public override function doOnce():void {
			
			myStage.addChild(myRes[AGResources.NAME_FLYER_L0_PNG]);
			
			prepTiles() ;
			
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
			

			stringVisible = tree.planet[myGame.gamePlanet].visible.toString();
			stringInvisible = tree.planet[myGame.gamePlanet].invisible.toString();
			
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
			
			//trace(myInvisible);
		}
		
		///////////////////////////////////////////
		public function drawLevel():void {
    
    var  i:int,j:int,k:int,l:int,m:int;
	
    var baseX:int, baseY:int;//, startX, startY;
    var mapcheat:int = 1;
    var levelcheat:int = 1;
	var TILE_WIDTH:int = 16;
	var TILE_HEIGHT:int = 16;
	
	var tilesWidthMeasurement:int = 32;
	var tilesHeightMeasurement:int = 32;
    //uint16_t square[TILE_HEIGHT][TILE_WIDTH];
    
    //uint16_t  **  screen = (getScreenPointer(MY_SCREEN_BACK));
    var map_level:Array = myVisible;
	var map_objects:Array = myInvisible;
    
    //animate = newBG + 1;
    
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
    			//LOGE("map_level %d", map_level[j][i] );
    			if(  map_level[j][i] != 0  && map_level[j][i] != B_GOAL  ) { //is tile blank??
    				cutTile(tiles_a, square, map_level[j][i] - levelcheat);
    				
    				drawTile_8(square, j * TILE_WIDTH, i * TILE_HEIGHT , 
    					scrollx , scrolly, PAINT_TRANSPARENT, 0);
			}
			
				// special animated tiles
				k = map_objects[j][i];
				if ( k != B_START && k != B_MONSTER && k != B_DEATH
    				&& k != B_PLATFORM && k != B_MARKER && k != B_BLOCK
    				&& k != B_LADDER  && k != B_SPACE && k != B_GOAL) {
    				
    				
    				if (animate == 0 || animate == 1 || animate == 8) {

    		    		cutTile(tiles_a, square, k - mapcheat);
    				}
    				else if (animate == 2 || animate == 4 || animate == 6) {

    		    		cutTile(tiles_b, square, k - mapcheat);
    				}
    				else if (animate == 3 || animate == 7) {

    		    		cutTile(tiles_c, square, k - mapcheat);
    				}
    				else if (animate == 5) {

    		    		cutTile(tiles_d, square, k - mapcheat);
    				}
    				

    				drawTile_8(square, j * TILE_WIDTH, i * TILE_HEIGHT , 
    					scrollx , scrolly, PAINT_TRANSPARENT, number_alpha);


    			
    			}



			} // if i,j > 0, etc...
			
			if (j  >= LONG_MAP_H ) {
				//draw all of level again.
				m =  (LONG_MAP_H  );
				
				
				if(  map_level[j - m][i] != 0 && map_level[j-m][i] != B_GOAL  ) { //is tile blank??
    				cutTile(tiles_a, square, map_level[j-m][i] - levelcheat);
    				
    				drawTile_8(square, j  * TILE_WIDTH, i * TILE_HEIGHT , 
    					scrollx , scrolly, PAINT_TRANSPARENT, 0);
				}
				
				// special animated tiles
				k = map_objects[j-m][i];
				if ( k != B_START && k != B_MONSTER && k != B_DEATH
    				&& k != B_PLATFORM && k != B_MARKER && k != B_BLOCK
    				&& k != B_LADDER  && k != B_SPACE && k != B_GOAL) {
    				
    				
    				if (animate == 0 || animate == 1 || animate == 8) {

    		    		cutTile(tiles_a, square, k - mapcheat);
    				}
    				else if (animate == 2 || animate == 4 || animate == 6) {

    		    		cutTile(tiles_b, square, k - mapcheat);
    				}
    				else if (animate == 3 || animate == 7) {

    		    		cutTile(tiles_c, square, k - mapcheat);
    				}
    				else if (animate == 5) {

    		    		cutTile(tiles_d, square, k - mapcheat);
    				}
    				

    				drawTile_8(square, j * TILE_WIDTH, i * TILE_HEIGHT , 
    					scrollx , scrolly, PAINT_TRANSPARENT, number_alpha);
				}


			}
		
    	}
    }
    
	drawRadarRock();

    /* draw moving platform */
    drawMovingPlatform();
    
    /* draw score and level */
    drawScoreWords();
    

    /* draw monsters */
    if (preferences_monsters == TRUE) {
        drawMonsters();
    }
    
    if (preferences_monsters == TRUE && preferences_collision == TRUE && animate_only == FALSE) {
        collisionWithMonsters();
    }
    


    if (! animate_only ) {
    	drawInvaderType1();
    	drawInvaderType2();

    }

  	/* draw guy with animation */
    if (! animate_only) {
    	drawFlyer();
    	drawBasicSprite(0, D_FLYER_RINGS);
    }
	

	drawBasicSprite(0, D_EXPLOSION);

	drawSpriteExplosion();

	drawBoundingBox(radar_box, BB_NO_SCROLL, 0xffff);

	drawLasers( );

	drawTorpedo();

	checkRegularCollision();
}
		///////////////////////////////////////////
		
		
	}
	
}
