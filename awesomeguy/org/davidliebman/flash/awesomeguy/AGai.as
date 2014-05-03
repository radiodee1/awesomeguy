package org.davidliebman.flash.awesomeguy {
	import flash.display.Stage;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import flash.display.Shape;
	
	
	/* THIS AI IS REALLY ONLY FOR MAZE LEVELS */
	public class AGai {
		public var myInvisible:Array;
		public var myScreen:Stage;
		public var myGame:AGMode;

		public var invisibleDots:Array;
		public var invisibleChutes:Array;
		public var edgesFromDots:Array;
		public var nodesFromDots:Array;

		public static var MONSTER_GATOR:int = 1;
		public static var MONSTER_CLIMBER:int = 2;
		public static var MONSTER_FLYER:int = 3;
		
		public static var COORDINATES_BLOCKS:int = 1;
		public static var COORDINATES_PIXELS:int = 2;

		public static var EPOS_EDGENAME:int=0;
		public static var EPOS_NODESTART:int = 1;
		public static var EPOS_NODEEND:int= 2;
		public static var EPOS_STARTX:int = 3;
		public static var EPOS_STARTY:int= 4;
		public static var EPOS_STOPX:int = 5;
		public static var EPOS_STOPY:int = 6;
		public static var EPOS_DIST:int = 7;
		public static var EPOS_TOPY:int = 8;
		public static var EPOS_ISJUMP:int = 9;
		
		public static var NPOS_NODENAME:int = 0;
		public static var NPOS_COORDX:int = 1;
		public static var NPOS_COORDY:int = 2;
		public static var NPOS_CALCDIST:int = 3;
		public static var NPOS_VISITED:int = 4;

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
			this.edgesFromDots = new Array();
			this.nodesFromDots = new Array();
			
			var i:int = 0;
			var j:int = 0;
			var k:int = 0;
			var tempArray:Array;// = new Array();
			
			//make empty grid for chutes
			for (i = 0; i < this.myInvisible.length; i ++) {
				tempArray = new Array();
				for (j = 0; j < this.myInvisible[i].length; j ++) {
					tempArray.push(0);
				}
				this.invisibleChutes.push(tempArray);
			}
			
			//platforms
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
					//build array parts
					tempArray.push(k);
				}
				this.invisibleDots.push(tempArray);
			}
			
			
			// detect chutes.
			for (i = 0; i < this.myInvisible.length; i ++) {
				for (j = 0; j < this.myInvisible[i].length; j ++) {
					//detect a platform...
					if (this.invisibleDots[i][j] == 1 ) {
						if (j < this.invisibleDots[i].length - 1 && this.invisibleDots[i][j+1] != 1 && 
								this.myInvisible[i][j] != AGModeGuy.B_LADDER && 
								this.myInvisible[i+1][j] != AGModeGuy.B_LADDER) {
							this.followChutes(j+ 1,i); // right side of platform
						}
						if (j > 0 && this.invisibleDots[i][j-1] != 1 && 
								this.myInvisible[i][j] != AGModeGuy.B_LADDER && 
								this.myInvisible[i+1][j] != AGModeGuy.B_LADDER) {
							this.followChutes(j-1, i); // left side of platform
						}
					}
					
				}
			}
			
			for (i = 0; i < this.myInvisible.length; i ++) {
				for (j = 0; j < this.myInvisible[i].length; j ++) {
					//detect ladders
					if (i < this.myInvisible.length && i > 0 && this.myInvisible[i][j] == AGModeGuy.B_LADDER) {
						//k = 1;
						this.invisibleDots[i][j] = 1;
					}
				}
			}
			/////
			// horizontal edges
			
			var l:int = 0;
			var startx:int = 0;
			var endx:int = 0;
			for (i = 0; i < this.invisibleDots.length; i ++) {
				
				k = 0;
				l = 0;
				while(k < this.invisibleDots[i].length) {
					startx = 0;
					endx = 0;
					//l = k;
					if (this.invisibleDots[i][k] != 0 ) {
						
						if(this.isEndNode(k,i) || this.invisibleDots[i][k + 1] == 0){
							//record a horizontal edge
							startx = l;
							endx = k;
							if (l != k) {
								//var edge:Array = 
								this.makeCoordinateListingHorizontal(startx,endx,i,false);
								//this.edgesFromDots.push(edge);
							}
							l = k;
						}
						
					}
					else {
						l ++;
					}
					k ++;
					

				}
				
				
			}
			
			/////
			// vertical edges
			
			//var l:int = 0;
			var starty:int = 0;
			var endy:int = 0;
			if (this.invisibleDots.length == 0) return;
			
			for (i = 0; i < this.invisibleDots[0].length; i ++) {
				
				k = 0;
				l = 0;
				while(k < this.invisibleDots.length) {
					starty = 0;
					endy = 0;
					
					if (this.invisibleDots[k][i] != 0 ) {
						
						if(this.isEndNode(i,k) ){//|| this.invisibleDots[i][k + 1] == 0){
							//record a vert edge
							starty = l;
							endy = k;
							if (l != k) {
								
								this.makeCoordinateListingVertical(starty,endy,i,false);
							}
							l = k;
						}
						
					}
					else {
						l ++;
					}
					k ++;
					

				}
				
				
			}
			
		}
		
		private function followChutes(xblock:int, yblock:int):void {
			var i:int = 0;
			
			for (i = yblock ; i < this.myInvisible.length ; i ++) {
				if (this.myInvisible[i][xblock] == AGModeGuy.B_SPACE) {
					this.invisibleChutes[i][xblock] = 1;
				}
				else if (this.myInvisible[i][xblock] == AGModeGuy.B_BLOCK){
					return;
				}
			}
		}
		public function makeNodeName(x:int, y:int):String {
			return new String("NODENAME:" + x +"," + y);
		}
		
		
		public function makeEdgeName(startx:int, starty:int, endx:int, endy:int):String {
			return new String("EDGENAME:"+startx+","+starty+":"+endx+","+endy);
		}
		
		public function makeCoordinateListingHorizontal(startx:int, endx:int, ylevel:int, isJump:Boolean):void{
			
			// put edges in list
			var edgename:String = this.makeEdgeName(startx,ylevel,endx,ylevel);
			
			var nodenamestart:String = this.makeNodeName(startx, ylevel);
			var nodenamestop:String = this.makeNodeName(endx, ylevel);

			var temp:Array = new Array(edgename, // edge name
							 nodenamestart, // nodename a
							 nodenamestop, // node name b
							 startx , ylevel, // start x,y
							 endx , ylevel ,  // end x,y
							 Math.abs(endx - startx ), // dist
							 ylevel, // height of highest part of segment
							 isJump);  // is jump segment??
			this.edgesFromDots.push(temp);
			
			this.makeCoordinateListingNodes(startx,ylevel);
			this.makeCoordinateListingNodes(endx,ylevel);
			
		}
		
		public function makeCoordinateListingNodes(x:int, y:int):void {
			var i:int = 0;
			var listed:Boolean = false;
			
			var nodename:String = this.makeNodeName(x, y);

			// put nodes in list... NO REPEATS
			for (i = 0; i < this.nodesFromDots.length; i ++) {
				if (nodename == this.nodesFromDots[i][NPOS_NODENAME]) {
					listed = true;
				}
			}
			var node:Array = new Array( nodename, // node name
										x, //node x
										y, //node y
										-1, // D distance (infinity)
										false); //visited?
			if (!listed) this.nodesFromDots.push(node);
		}
		
		public function makeCoordinateListingVertical(starty:int, endy:int, xlevel:int, isJump:Boolean):void {
			// put edges in list
			var edgename:String = this.makeEdgeName(xlevel,starty,xlevel,endy);
			
			var nodenamestart:String = this.makeNodeName(xlevel, starty);
			var nodenamestop:String = this.makeNodeName(xlevel, endy);

			var temp:Array = new Array(edgename, // edge name
							 nodenamestart, // nodename a
							 nodenamestop, // node name b
							 xlevel , starty, // start x,y
							 xlevel , endy ,  // end x,y
							 Math.abs(endy - starty ), // dist
							 starty, // height of highest part of segment
							 isJump);  // is jump segment??
			this.edgesFromDots.push(temp);
			
			this.makeCoordinateListingNodes(xlevel,starty);
			this.makeCoordinateListingNodes(xlevel,endy);
						
		}
		
		/* CHECK IF END NODE */
		public function isEndNode(xblock:int, yblock:int):Boolean {
			var value:Boolean = true;
			if (yblock == 0 || yblock == this.invisibleDots.length || 
				xblock == 0 || xblock == this.invisibleDots[0].length) return true;
			
			var connections:int = 0;
			if (this.invisibleDots[yblock - 1][xblock] == 1 && //up
				this.invisibleDots[yblock ][xblock + 1] == 1 //right
				) {
				connections ++;
			}
			if (this.invisibleDots[yblock ][xblock + 1] == 1 && // right
				this.invisibleDots[yblock + 1][xblock] == 1) { // down
				connections ++;
			}
			if (this.invisibleDots[yblock][xblock - 1] == 1 && // left
				this.invisibleDots[yblock - 1][xblock] == 1) { //up
				connections ++;
			}
			if (this.invisibleDots[yblock + 1][xblock] == 1 && // down
				this.invisibleDots[yblock ][xblock - 1] == 1) { // left
				connections ++;
			}
			
			//does path not turn?
			if (connections == 0) value = false;
			
			return value;
		}
		
		/* THIS IS DONE BEFORE EACH REDRAW OF THE SCREEN */
		public function doCalculation(mymonstertype:int, coordinateType:int ,startingX:int, startingY:int, endingX:int, endingY:int) {
			
		}
		
		public function drawMap():void {
			this.drawMapSquares();
			this.drawMapEdges();
		}
		
		/* THIS IS DONE FOR DEVELOPMENT ONLY */
		public function drawMapSquares():void {
			
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
		
		public function drawMapEdges():void {
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
			
			
			//var square:AGSprite;
			var xstart:int;
			var ystart:int;
			var xend:int;
			var yend:int;
		
			/* draw background */
			baseX = this.myGame.scrollBGX / TILE_WIDTH;
			baseY = this.myGame.scrollBGY / TILE_HEIGHT;
			//var myVisible:Array = this.invisibleDots;
			
			for(i = 0; i < this.edgesFromDots.length; i ++) {
				
				xstart  = this.edgesFromDots[i][EPOS_STARTX] * TILE_WIDTH - this.myGame.scrollBGX;
				ystart  = this.edgesFromDots[i][EPOS_STARTY] * TILE_HEIGHT - this.myGame.scrollBGY;
				xend  = this.edgesFromDots[i][EPOS_STOPX] * TILE_WIDTH - this.myGame.scrollBGX;
				yend  = this.edgesFromDots[i][EPOS_STOPY] * TILE_HEIGHT- this.myGame.scrollBGY;
				
				var shape:Shape = new Shape();
				shape.graphics.lineStyle(4,0xff0000,1);
				shape.graphics.moveTo(xstart,ystart);
				shape.graphics.lineTo(xend,yend);
				
				mystage.addChild(shape);
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
