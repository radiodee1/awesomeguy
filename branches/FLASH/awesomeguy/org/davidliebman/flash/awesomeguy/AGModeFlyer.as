package org.davidliebman.flash.awesomeguy {
	import flash.xml.XMLDocument;
	import flash.display.Sprite;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.geom.Rectangle;
	import flashx.textLayout.formats.Float;
	
	public class AGModeFlyer extends AGMode{

		public var total_rings:int;
		
		
		public var animate_explosion:Boolean = false;
		
		public function AGModeFlyer() {
			// constructor code
		}


		public override function componentsInOrder():void {
			//
			super.componentsInOrder();
			
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
			updateSprites();
			drawLevelTiles();
			drawAnimatedSprites();
			drawRadarRock();

			//
			agflyer.sprite = this.sprite;
			myDraw.drawRes(agflyer,xpos,ypos,facingRight,AGMode.D_FLYER ,animate);

			drawScoreWords();
			myStage.addChild(myShape);
			//
			fireButton();
			doTimers();
			collisionWithMonsters();
			checkRegularCollision();

			
			screenframe.x = 0;
			screenframe.y = SCREEN_HEIGHT;
			myStage.addChild(screenframe);
			
			drawRadarPing(radar, radarscreen ,xpos,ypos,AGMode.PING_FLYER,0xffffffff);
			
			radarscreen.x = 64;
			radarscreen.y = SCREEN_HEIGHT;
			myStage.addChild(radarscreen);
			
		}
		
		public override function doOnce():void {
			myDraw = new AGDrawFlyer(this, myRes, myStage, myScreenBG);
			this.game_death = false;
			if(game_reset_start == true) {
				setStartingVars();
				game_reset_start = false;
			}
			//else advanceChallenge();
			
			explosionsprite = new AGSprite(this, AGMode.S_EXPLOSION_SPRITE);
			explosionsprite.active = false;
			
			initAGSprite();
			initChallenges();// this just creates the array!!
			initAGTimer();
			
			mySprite[0] = explosionsprite;
			sprite_num ++;
			
			fillChallenges();
			
			
			prepTiles() ;
			prepRings() ;
			prepRingSprites();
			
			radar_start = xpos - scrollBGX;
			radar_start_scroll =  scrollBGX;
			//trace (radar_start + " scroll:" + scrollBGX);
			//myRes[AGResources.NAME_EXPLOSION_MP3].play();
			agflyer = new AGSprite(this,AGMode.S_FLYER);
			agflyer.active = true;
			
		}
		
		public override function advanceChallenge():void {
			super.advanceChallenge();
			myGame.gameChallenge ++;

			prepRings();
			prepRingSprites();
			
			myTimer[AGMode.TIMER_00].timerStart(3 ); // a few seconds 
			myTimer[AGMode.TIMER_01].timerStart( 3/30 ); // 3 refreshes -- screen alert timer
			myTimer[AGMode.TIMER_08].timerStart( 5/30); // torpedos
			
			//
			myChallenge[myGame.gameChallenge].total_placed_bubble_1 = 0;
			myTimer[AGMode.TIMER_02].timerStart(  1); // about a second
			//
			myChallenge[myGame.gameChallenge].total_placed_bubble_2 = 0;
			myTimer[AGMode.TIMER_03].timerStart( 2); // about 2 sec
			//
			myChallenge[myGame.gameChallenge].total_placed_invader_1 = 0;
			myTimer[AGMode.TIMER_04].timerStart( 2);// 2 sec
			//
			myChallenge[myGame.gameChallenge].total_placed_invader_2 = 0;
			myTimer[AGMode.TIMER_06].timerStart( 2); // 2 sec
		}
		
		public override function setStartingVars():void {
			super.setStartingVars();
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
					if (k + mapcheat == AGMode.B_MONSTER) addMonster(j,i ,0);
					if (k + mapcheat == AGMode.B_PLATFORM) addPlatform(j , i );
				}
				myInvisible.push(smallArray);
			}
			
			//trace(myInvisible);
		}
		
		public function fillChallenges():void {
			var challengeBody:String = new String();
			var challengeLength:int = 0;
			var ii:int, jj:int;
			var tree:XML = new XML(new XMLDocument(myRes[AGResources.NAME_AWESOMEGUY_XML]));
			challengeLength = tree.planet[myGame.gamePlanet].challenges.invaders.length();

			myChallenge = new Array();
			
			var tempArray:Array ;
			for (ii = 0; ii < challengeLength; ii ++ ) {
				challengeBody = new String();
			
				challengeBody = tree.planet[myGame.gamePlanet].challenges.invaders[ii].toString();

				tempArray = new Array();
				tempArray = challengeBody.split(",");

				var ch:AGChallenge = new AGChallenge();
				ch.rings = int (tempArray[0]);
				ch.bubble_1 = int (tempArray[1]);
				ch.bubble_2 = int (tempArray[2]);
				ch.bubble_3 = int (tempArray[3]);
				ch.invader_1 = int (tempArray[4]);
				ch.invader_2 = int (tempArray[5]);
				ch.invader_3 = int (tempArray[6]);
				ch.speed = int (tempArray[tempArray.length - 1]);
				
				myChallenge.push(ch);
				ch.showTrace();
			}
			/*
			myChallenge[myGame.gameChallenge].total_rings = 0;
			myChallenge[myGame.gameChallenge].total_bubble_0 = 0;
			myChallenge[myGame.gameChallenge].total_bubble_1 = 0;
			myChallenge[myGame.gameChallenge].total_bubble_2 = 0;
			myChallenge[myGame.gameChallenge].total_bubble_3 = 0;
			myChallenge[myGame.gameChallenge].total_invader_1 = 0;
			myChallenge[myGame.gameChallenge].total_invader_2 = 0;
			myChallenge[myGame.gameChallenge].total_invader_3 = 0;
			
			myChallenge[myGame.gameChallenge].total_placed_bubble_1 = 0;
			myChallenge[myGame.gameChallenge].total_placed_bubble_2 = 0;
			myChallenge[myGame.gameChallenge].total_placed_bubble_3 = 0;
			
			myChallenge[myGame.gameChallenge].total_placed_invader_1 = 0;
			myChallenge[myGame.gameChallenge].total_placed_invader_2 = 0;
			myChallenge[myGame.gameChallenge].total_placed_invader_3 = 0;
			*/
			
			myTimer[AGMode.TIMER_00].timerStart(3 ); // a few seconds 
			myTimer[AGMode.TIMER_01].timerStart( 3/30 ); // 3 refreshes -- screen alert timer
			myTimer[AGMode.TIMER_08].timerStart( 5/30); // torpedos
			
			//
			myChallenge[myGame.gameChallenge].total_placed_bubble_1 = 0;
			myTimer[AGMode.TIMER_02].timerStart(  1); // about a second
			//
			myChallenge[myGame.gameChallenge].total_placed_bubble_2 = 0;
			myTimer[AGMode.TIMER_03].timerStart( 2); // about 2 sec
			//
			myChallenge[myGame.gameChallenge].total_placed_invader_1 = 0;
			myTimer[AGMode.TIMER_04].timerStart( 2);// 2 sec
			//
			myChallenge[myGame.gameChallenge].total_placed_invader_2 = 0;
			myTimer[AGMode.TIMER_06].timerStart( 2); // 2 sec
		}
		
		public function prepRings():void {
			var candidate:Array = new Array();
			
			var candidate_num:int = 0;
			var i:int, j:int, k:int, cheat:int;
			
			for (i = 0 ; i < myVert ; i ++ ) {
				for (j = 0; j < myHoriz ; j ++ ) {
					
					

					if (myInvisible[i][j] + mapcheat == B_PRIZE) {
						var myCandidate:Candidate = new Candidate();
						
						myCandidate.x = j;
						myCandidate.y = i;
						myCandidate.value = B_SPACE ;
						myCandidate.type = B_PRIZE ;
						myInvisible[i][j] = myCandidate.value;
						candidate.push(myCandidate);
						candidate_num ++;
					}
				}
			}
			////////////////////////////
			
			//int i,j, k;
			var num_rings:int, num_spaces:int;
		
			myChallenge[myGame.gameChallenge].total_held_rings = 0;
			
			//the first challenges to place are the rings.
			num_rings = myChallenge[myGame.gameChallenge].rings;
			num_spaces = candidate_num;
		
			for (i = 0; i < num_rings; i ++ ) {
		
				j = getRand(0, num_spaces - ( i ) );
		
				
				for (k = 0; k <= j; k ++) {
		
					while (candidate[k].value != B_SPACE ) {
						k ++;
					}
					if ( candidate[k ].value == B_SPACE && k == j ){//-1) {
						candidate[k].value = B_PRIZE;
		
					}
		
					else if (candidate[k ].value != B_SPACE && k == j ){
						while (candidate[k].value != B_SPACE ) {
							k++;
		
						}
						if ( candidate[k ].value == B_SPACE  ){//-1) {
							candidate[k].value = B_PRIZE;
		
						}
						//LOGE("else condition");
					}
				}
			}
			for (i = 0; i< num_spaces; i ++ ) {
				
				if (candidate[i].value == B_PRIZE ) cheat =   ( mapcheat );//+ 1 );
				else cheat = 0;
				myInvisible[candidate[i].y][candidate[i].x] = candidate[i].value - cheat;
				if (candidate[i].value == B_PRIZE) {
					total_rings ++;
					//trace ("PRIZE " + (candidate[i].value - cheat));
				}
			}
			
			candidate = null;
			/////////////////////////////
		}
				
		public function prepRingSprites():void {
			var i:int, j:int , k:int;
			for (i = 0; i < myVert; i ++ ) {
				
				for (j = 0 ; j < myHoriz; j ++ ) {
					k = myInvisible[i][j];
					
					
					if (k + mapcheat == AGMode.B_PRIZE) {
						addRing(j, i );
						//trace("add ring");
					}
				}
				
			}
		}
				
		public function addMonster(monster_x:int, monster_y:int,  monster_animate:int):void {
			var mon:AGSpriteMonster = new AGSpriteMonster(this,AGMode.S_GATOR);
			mon.x = monster_x * TILE_WIDTH;
			mon.y = monster_y * TILE_HEIGHT;
			mon.animate = monster_animate;
			mon.facingRight = true;
			mon.active = true;
			mon.visible = true;
			  
			mon.topBB = 3 *2; 
			mon.bottomBB = 8 *2;
			mon.leftBB = 0;
			mon.rightBB = 16 * 2;
		
			mon.sprite_type = S_GATOR;
			//mySprite[sprite_num].type = S_GATOR;
			sprite_num ++;
			monster_num = sprite_num;
			
			platform_num = 0;
			mySprite.push(mon);
		}
		
		public function addPlatform( platform_x:int, platform_y:int):void {
			var my:AGSpriteCloud = new AGSpriteCloud(this,AGMode.S_CLOUD);
			my.x = platform_x * TILE_WIDTH ;
			my.y = platform_y * TILE_HEIGHT ;
			my.animate = 0;
			my.facingRight = true;
			my.active = true;
			my.visible = true;
			  
			my.topBB = 0; 
			my.bottomBB = 8* 2;
			my.leftBB = 0;
			my.rightBB = 40*2;
		
			my.sprite_type = S_CLOUD;
			  
			sprite_num ++;
			
			mySprite.push(my);
			platform_num = sprite_num;
		}
		
		public function addLine(color:uint, linktype:int):AGSprite {
			// create a line-type object
			var temp:AGSpriteLine = new AGSpriteLine(this, AGMode.S_LINE);// Sprite temp ;
			temp.x = getRand(scrollBGX, scrollBGX + ( 256*2));
			temp.y = 0;
			var angle:Number = getRand( 80, 180 - 80) ;
			var value:Number = ( myVert * 16)/  (Math.tan(angle) );
			temp.endline_x = int(( Math.abs ((( int(value) ) + temp.x)) % (myHoriz * 16)));
			
			temp.endline_y = myVert * 16;
			temp.sprite_type = S_LINE;
			temp.speed = 4 * 2;
			temp.active = true;
			temp.quality_0 = 0;
			temp.color = color;
			temp.sprite_link = linktype;
			// add it to the sprite list
			mySprite.push(temp);
			return temp;
		}
		public function addRing(xx:int, yy:int):void {
			// create a line-type object
			var temp:AGSpriteRing = new AGSpriteRing(this, AGMode.S_RING);// Sprite temp ;
			temp.x =xx*16;
			temp.y = yy *16;

			temp.sprite_type = S_RING;
			temp.speed = 1;
			temp.active = true;
			temp.quality_0 = xx;
			temp.quality_1 = yy;
			// add it to the sprite list
			mySprite.push(temp);
			//myChallenge[ myGame.gameChallenge].total_rings ++;
			//return temp;
		}
		public function addTorpedo(ii:int, xx:int, yy:int):void {
			var temp:AGSpriteTorpedo = new AGSpriteTorpedo(this, AGMode.TORPEDO_UNUSED);// Sprite temp ;
			temp.x =xx;
			temp.y = yy ;
			temp.facingRight = facingRight;
			if (facingRight) {
				temp.x = temp.x + spriteWidth;
			}
			temp.sprite_type = AGMode.S_TORPEDO;
			temp.speed = 1;
			temp.active = true;
			temp.visible = true;
			temp.limit = 0;
			myTorpedo[ii] = temp;
			//trace("new torpedo");
		}
		
		public function addInvader1(xx:int, yy:int):void {
			//setSoundEnter1();
			myRes[ AGResources.NAME_ENTER_1_MP3 ].play();
			
			var temp:AGSpriteInvader1 = new AGSpriteInvader1(this, AGMode.S_INVADER_1) ;
			temp.x = adjust_x(getRand(scrollBGX, scrollBGX + 512));
			temp.y = 0;

			temp.topBB = 0;
			temp.leftBB = 0;
			temp.bottomBB = 15 *2;
			temp.rightBB = 15*2;
			temp.sprite_type = S_INVADER_1;
			temp.speed = get_sprite_speed(S_INVADER_1);//1;
			temp.active = true;
			temp.quality_0 = 0;
			temp.quality_1 = 0;
			temp.quality_2 = 0;
			temp.quality_3 = P_NONE;
			// add it to the sprite list
			mySprite.push(temp);

			//total_placed_invader_1 ++;
			//total_invader_1 ++;
			//myChallenge[this.myGame.gameChallenge].total_placed_invader_1 ++;
			//myChallenge[this.myGame.gameChallenge].total_invader_1 ++;

			// reset timer
			//timerStart(4, 30 * 2);
			myTimer[AGMode.TIMER_04].timerStart(2);// 2 sec
		}
		
		public function doTimers():void {
			if (myTimer[AGMode.TIMER_01].timerDone()) {
				alert_color = 0x00000000;
			}
			if (this.game_death) { 
				return;
			}
			// current challenge cleared ???
			myChallenge[ myGame.gameChallenge ].countTotals(mySprite);

			trace(myGame.gameChallenge);
			if( myChallenge[ myGame.gameChallenge].checkTotals()  && myGame.gameChallenge  < myChallenge.length ) {
				if(myTimer[AGMode.TIMER_00].timerDone()) {
					trace ("increment at timer");
					advanceChallenge();
					myRes[AGResources.NAME_GOAL_MP3].play();
					//setSoundGoal();
					alert_color = 0xffffffff;
					//fillChallenges(); -- not good
				}
			}
			// end of entire level ???
			else if (myChallenge[ myGame.gameChallenge].checkTotals()  && myGame.gameChallenge == myChallenge.length && myGame.gameChallenge != 0) {
				if(myTimer[AGMode.TIMER_00].timerDone() ){
					//this.game_death = false;
					this.game_end_level = true;
					
					if (this.game_end_level ) {
						myRes[AGResources.NAME_GOAL_MP3].play();
						//setSoundGoal();
						myTimer[AGMode.TIMER_00].timer_disable = true;
						//timer[0].timer_disable = TRUE;
					}
		
		
				}
			}
			
			if ( myChallenge[myGame.gameChallenge].bubble_1 > myChallenge[myGame.gameChallenge].total_placed_bubble_1 ) {
				
				if( myTimer[AGMode.TIMER_02].timerDone()) {
					
					// create a line-type object
					addLine(0x00ffffff,AGMode.S_BUBBLE_1);
					
					
					// reset timer
					myTimer[AGMode.TIMER_02].timerStart(1);
					//timerStart(2, 30 * 1);
				}
			}
		  if ( myChallenge[myGame.gameChallenge].bubble_2 > myChallenge[myGame.gameChallenge].total_placed_bubble_2 ) {
				
			if( myTimer[AGMode.TIMER_03].timerDone()) {
					
					// create a line-type object
					var line:AGSprite = addLine(0x00ffffff,AGMode.S_BUBBLE_2);
					
					
					line.active = true;
					// reset timer
					myTimer[AGMode.TIMER_03].timerStart(2);
					//timerStart(2, 30 * 1);
				}
			}
		}
		
		public function fireButton():void {
			var  ii:int, jj:int, kk:int, ll:int, add:int;
			var flag:Boolean = false;
			
			if (K_JUMP) { // using space key
				
				if (myTimer[AGMode.TIMER_08].timerDone() || myTimer[AGMode.TIMER_08].started == false) {
					
					ii = 0;
					while (ii  < TOTAL_TORPEDOS  && flag == false) {
	
						if (myTorpedo[ii].active == false ) {
	
							
							this.addTorpedo(ii, xpos, ypos);
							
							flag = true;
						} 
						ii ++;
					}
					if (flag == true) myTimer[AGMode.TIMER_08].timerStart( 0.3);
				}
	
	
			}
		}
		
		public function updateSprites():void {
			var i:int;
			for (i = 0; i < mySprite.length; i ++ ) {
				if (mySprite[i].active == true || mySprite[i].visible == true) {
					mySprite[i].updateSprite();
					if (mySprite[i].sprite_type == AGMode.S_CLOUD) myDraw.drawBasicSprite(mySprite[i], D_CLOUD);
					if (mySprite[i].sprite_type == AGMode.S_LINE ) myDraw.drawBasicSprite(mySprite[i], D_LINE_1);
					if (mySprite[i].sprite_type == AGMode.S_BUBBLE_1) myDraw.drawBasicSprite(mySprite[i], D_BUBBLE_1);
					
					if (mySprite[i].sprite_type == AGMode.S_BUBBLE_3) myDraw.drawBasicSprite(mySprite[i], D_BUBBLE_3);
					
					if (mySprite[i].sprite_type == AGMode.S_BUBBLE_2) myDraw.drawBasicSprite(mySprite[i], D_BUBBLE_2);
					
				}
				
			}
			
			
			
			
		}
		public function drawAnimatedSprites():void {
			var i:int;
			for (i = 0; i < mySprite.length; i ++ ) {
				if (mySprite[i].active == true) {
					
					if (mySprite[i].sprite_type == AGMode.S_RING) {
						myDraw.drawBasicSprite(mySprite[i], D_RING);
					}
					if (mySprite[i].sprite_type == AGMode.S_GATOR) {
						myDraw.drawBasicSprite(mySprite[i], D_GATOR);
					}
					if (explosionsprite.sprite_type == AGMode.S_EXPLOSION && 
						explosionsprite.active == true) {
						myDraw.drawBasicSprite(explosionsprite, AGMode.D_EXPLOSION);
					}
				}
				
			}
			var sprite:AGSpriteTorpedo;
			for ( i = 0; i < myTorpedo.length ; i ++ ) {
				sprite = myTorpedo[i];
				if (sprite.active) {
					sprite.updateSprite();
					myDraw.drawBasicSprite(sprite, AGMode.D_TORPEDO);
				}
			}
		}
		
		
		public function collisionWithMonsters():void {

		  var i:int;
	
		  for (i = 0  ; i < mySprite.length ; i++) {
			  if(mySprite[i].sprite_type == AGMode.S_GATOR) {
			  
			 
			 var sprite:AGSprite = mySprite[i];
			  
			  
		    var test:Boolean =  collisionSimple(flyersprite, sprite.bitmap);
			
			
		    if (test && sprite.active   == true) {
		    
		      if (flyersprite.getBounds(myStage).bottom < sprite.bitmap.getBounds(myStage).bottom ) {
		    	
					  
		    	if (preferences_collision == true) {
					sprite.active = false;
					sprite.visible = false;
		    		
					
					myRes[AGResources.NAME_BOOM_MP3].play();
					myGame.gameScore = myGame.gameScore + 10;
		    	}

		      }
		      else {
				//endlevel = TRUE;
				if (preferences_collision == true) {
					flyerDeath();
					
					//myRes[AGResources.NAME_EXPLOSION_MP3].play();
					sprite.active = false;
					sprite.visible = false;
					//animate_explosion = true;
					//explosionsprite.active = true;
					//explosionsprite.x = xpos;
					//explosionsprite.y = ypos;
					//agflyer.active = false;
					
				}

		        

		      }
		    }
			
			  }
		  }

		}
		
		public function flyerDeath():void {
					myRes[AGResources.NAME_EXPLOSION_MP3].play();
					//sprite.active = false;
					//sprite.visible = false;
					animate_explosion = true;
					explosionsprite.quality_3 = 0;
					explosionsprite.timerStart(10/1000);
					explosionsprite.active = true;
					explosionsprite.x = xpos;
					explosionsprite.y = ypos;
					agflyer.active = false;
					this.game_death = true;
		}
		
		
		
		
		
		///////////////////////////////////////////
		public function drawLevelTiles():void {
			var  i:int,j:int,k:int,l:int,m:int, zz:int;
			
			var baseX:int, baseY:int;//, startX, startY;
			
			
			var TILE_WIDTH:int = 16;
			var TILE_HEIGHT:int = 16;
			
			var tilesWidthMeasurement:int = 32;
			var tilesHeightMeasurement:int = 24;//32;
			
			var LONG_MAP_H:int =	192;
			var LONG_MAP_V:int =	32;
			//animate = newBG + 1;
			//var animate:int = 0;
					
			
			var square:Bitmap;
		
			
			
			
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
									myVisible[i][j] + levelcheat,
									AGMode.TILE_TOP);
							
							square.x = new Number ((j * TILE_WIDTH ) - scrollBGX);
							square.y = new Number ((i * TILE_HEIGHT) - scrollBGY);
							myStage.addChild(square);
							//drawTile_8(square, j * TILE_WIDTH, i * TILE_HEIGHT , 
							//	scrollx , scrolly, PAINT_TRANSPARENT, 0);
							
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
									myVisible[i][j-m] + levelcheat,
									AGMode.TILE_TOP);
							//drawTile_8(square, j  * TILE_WIDTH, i * TILE_HEIGHT , 
							//	scrollx , scrolly, PAINT_TRANSPARENT, 0);
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
									myVisible[i][j+m] + levelcheat,
									AGMode.TILE_TOP);
							//drawTile_8(square, j  * TILE_WIDTH, i * TILE_HEIGHT , 
							//	scrollx , scrolly, PAINT_TRANSPARENT, 0);
							square.x = new Number ((j * TILE_WIDTH ) - scrollBGX);
							square.y = new Number ((i * TILE_HEIGHT) - scrollBGY);
							myStage.addChild(square);
						}
						
						
					}
				
					}
					
				}
			}
			
			
			
			
		
		
			//if (! animate_only ) {
			//	drawInvaderType1();
			//	drawInvaderType2();
			//}
		
			/* draw guy with animation */
			//if (! animate_only) {
			//	drawFlyer();
			//	drawBasicSprite(0, D_FLYER_RINGS);
			//}
			
		
			
			
			
			return ;
		}
		///////////////////////////////////////////
		public override function physicsAdjustments():void {
			//super.physicsAdjustments();
			
			if (yy < 0) flyerGrounded = false;
			
			if (flyerGrounded) return;
			
			if (xx + yy == 0 ) {
				//ypos = ypos + 
				yy = (Y_MOVE / 2);
				if (facingRight && ypos < SCREEN_HEIGHT -64) {
					//xpos = xpos + 
					xx = (X_MOVE / 2);
				}
				else if (ypos < SCREEN_HEIGHT -64) {
					//xpos = xpos 
					xx = - (X_MOVE / 2);
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
								
								var temp:AGSpriteBubble1 = new AGSpriteBubble1(this, AGMode.S_BUBBLE_1);// Sprite temp ;
								temp.x = sprite.x;
								temp.y = myVert * TILE_HEIGHT;
								temp.limit = 100;
								temp.color = 0xffff0000;
								temp.speed =  2;
								temp.active = true;
								temp.quality_0 = 0;
								myGame.gameScore += 10;
								mySprite.push(temp);
								myRes[AGResources.NAME_BOOM_MP3].play();
								sprite.active = false;
								//myChallenge[ myGame.gameChallenge].total_held_rings ++;
								//myChallenge[ myGame.gameChallenge].total_rings --;
								
							break;
							
							case AGMode.S_BUBBLE_2:
								this.agflyer.active = false;
								this.agflyer.visible = false;
								sprite.active = false;
								sprite.visible = true;
								flyerDeath();
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
						sprite.active && shot.active &&
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
						}
							
						
					}
				}
			}
			
		}
	

		public function goingRightIsShortest(  spritex:int, flyerx:int ):Boolean {
			var test:Boolean = false;
		
			if (Math.abs(flyerx - spritex) < (myHoriz * TILE_WIDTH)/2 && spritex < flyerx) {
				test = true;
			}
			else if (Math.abs(flyerx - spritex ) > (myHoriz  *TILE_WIDTH )/2) {
				test = true;
			}
			return test;
		}

		public function get_sprite_speed ( spritetype:int ):int {
			var value:int = 1;
			if (getRand(0,2) != 1) return value;
		
			switch (spritetype) {
			case S_INVADER_1:
			case S_INVADER_2:
				if ( this.myGame.gamePlanet   <=3 ) {
					value = this.myGame.gamePlanet;
				}
				else {
					value = 3;
				}
				break;
			case S_INVADER_3:
				break;
			}
			return value;
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
		
	}
	
}
