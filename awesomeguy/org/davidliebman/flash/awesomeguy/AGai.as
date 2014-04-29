package org.davidliebman.flash.awesomeguy {
	import flash.display.Stage;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	
	
	/* THIS AI IS REALLY ONLY FOR MAZE LEVELS */
	public class AGai {
		public var myInvisible:Array;
		public var myScreen:Stage;
		public var myGame:AGMode;

		public var invisibleDots:Array;
		public var invisibleChutes:Array;

		public static var MONSTER_GATOR:int = 1;
		public static var MONSTER_CLIMBER:int = 2;
		public static var MONSTER_FLYER:int = 3;
		
		public static var COORDINATES_BLOCKS:int = 1;
		public static var COORDINATES_PIXELS:int = 2;

		public function AGai() {
			// constructor code
			// do nothing...
			this.invisibleDots = new Array();
			
		}
		
		/* THIS IS DONE ONCE AT THE BEGINNING OF THE LEVEL */
		public function setValues(myinvisible:Array, myscreen:Stage, game:AGMode):void {
			myInvisible = myinvisible;
			myScreen = myscreen;
			myGame = game;
			
			this.invisibleChutes = new Array();
			this.invisibleDots = new Array();
			
			var i:int = 0;
			var j:int = 0;
			var k:int = 0;
			var tempArray:Array;// = new Array();
			
			for (i = 0; i < myInvisible.length; i ++) {
				tempArray = new Array();
				for (j = 0; j < myInvisible[i].length; j ++) {
					// all invisible squares...
					k = 0;
					//detect blocks that make platforms
					if (i < this.myInvisible.length -1 && 
							(this.myInvisible[i+1][j] == AGModeGuy.B_BLOCK || 
							 this.myInvisible[i+1][j] == AGModeGuy.B_LADDER)) {
						if (i > 0  && this.myInvisible[i][j] != AGModeGuy.B_BLOCK && 
								this.myInvisible[i-1][j] != AGModeGuy.B_BLOCK) {
							k = 1;
						}
					}
					//detect ladders
					if (i < this.myInvisible.length && i > 0 && this.myInvisible[i][j] == AGModeGuy.B_LADDER) {
						k = 1;
					}
					//build array parts
					tempArray.push(k);
				}
				this.invisibleDots.push(tempArray);
			}
			
			//make empty grid for chutes
			for (i = 0; i < this.myInvisible.length; i ++) {
				tempArray = new Array();
				for (j = 0; j < this.myInvisible[i].length; j ++) {
					tempArray.push(0);
				}
				this.invisibleChutes.push(tempArray);
			}
			
			// detect chutes.
			for (i = 0; i < this.myInvisible.length; i ++) {
				//
				for (j = 0; j < this.myInvisible[i].length; j ++) {
					k = 0;
					//detect a platform...
					if ( i < this.myInvisible.length -1 && this.myInvisible[i+1][j] == AGModeGuy.B_BLOCK) {
						if (i > 0  && this.myInvisible[i][j] == 0 && this.myInvisible[i-1][j] == 0) {
							//k = 1;
							// do nothing...
						}
					}
					else { //not a platform
						if (j < this.myInvisible[i].length - 1 && j > 0 && 
								i < this.myInvisible.length - 1 && i > 0 &&
								(this.myInvisible[i+1][j + 1] == AGModeGuy.B_BLOCK || 
								this.myInvisible[i+1][j - 1] == AGModeGuy.B_BLOCK ) ) {
							this.followChutes(i,j);
						}
					}
					//tempArray.push(k);
				}
			}
			
			/////
			
		}
		
		private function followChutes(xblock:int, yblock:int):void {
			var i:int = 0;
			
			for (i = yblock ; i < this.myInvisible.length ; i ++) {
				if (this.myInvisible[i][xblock] == AGModeGuy.B_SPACE) {
					this.invisibleChutes[i][xblock] = 1;
				}
				else return;
			}
		}
		
		/* THIS IS DONE BEFORE EACH REDRAW OF THE SCREEN */
		public function doCalculation(mymonstertype:int, coordinateType:int ,startingX:int, startingY:int, endingX:int, endingY:int) {
			
		}
		
		/* THIS IS DONE FOR DEVELOPMENT ONLY */
		public function drawMap():void {
			
			var  i:int,j:int,k:int,l:int,m:int, zz:int;
			
			var baseX:int, baseY:int;//, startX, startY;
			var mystage:Sprite = new Sprite();
			
			
			var TILE_WIDTH:int = 64;
			var TILE_HEIGHT:int = 64;
			
			var tilesWidthMeasurement:int =   32;
			var tilesHeightMeasurement:int =  24;//
			
			var LONG_MAP_H:int =	this.myGame.myHoriz;
			var LONG_MAP_V:int = 	this.myGame.myVert;//	this.myVert;
			//animate = newBG + 1;
			//var animate:int = 0;
			var myBlocks:Array = new Array();
			
			
			var square:AGSprite;
		
			/* draw background */
			baseX = this.myGame.scrollBGX / TILE_WIDTH;
			baseY = this.myGame.scrollBGY / TILE_HEIGHT;
			var myVisible:Array = this.invisibleDots;
			
			for ( j = baseX - 1 ; j < baseX + tilesWidthMeasurement + 3; j++) { //32
				for ( i = baseY - 1 ; i < baseY + tilesHeightMeasurement + 3; i ++ ) { //24
					
					if (i >= 0 && j >= 0  && i < LONG_MAP_V && j < LONG_MAP_H) { 
					
						
						
						if(  myVisible[i][j] != 0  || this.invisibleChutes[i][j] != 0) {// && myVisible[i][j] != AGModeGuy.B_GOAL  ) { //is tile blank??
							//trace(myVisible[i][j]);
							square = new AGSprite(this.myGame ,AGMode.S_BLOCK);
							square.bitmap = this.myGame.cutTile(  this.myGame.myRes[AGResources.NAME_TILES1_PNG], 
									AGModeGuy.B_BIGPRIZE - 4 ,
									AGMode.TILE_BOT);
							
							
							square.bitmap.x = new Number ((j * TILE_WIDTH ) - this.myGame.scrollBGX);
							square.bitmap.y = new Number ((i * TILE_HEIGHT) - this.myGame.scrollBGY);
							mystage.addChild(square.bitmap);
							
							
							
						}
						
						
		
					} // if i,j > 0, etc...
				
					//////////////////////////////////////////
					
					
				}
			}
			
			mystage.scrollRect = new Rectangle(0,0,512, (512 * 3/4));
			this.myScreen.addChild(mystage);
			return ;
			
		}
		
		public function getPixHintX():int {
			return 0;
		}
		public function getPixHintY():int {
			return 0;
		}
		
	}
	
}
