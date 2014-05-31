package org.davidliebman.flash.awesomeguy {
	import flash.display.Stage;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import flash.display.Shape;
	import flash.events.Event;
	import flash.utils.ByteArray;
	
	/* THIS AI IS REALLY ONLY FOR MAZE LEVELS */
	public class AGai {
		
		public var myInvisible:Array;
		public var myScreen:Stage;
		public var myGame:AGMode;
		public var myKeyStage:AGKeys;
		public var mySprite:AGSprite;
		public var myMultiFlag:Boolean;

		public var invisibleDots:Array = new Array();
		public var invisibleChutes:Array = new Array();
		public var edgesFromDots:Array = new Array();
		public var nodesFromDots:Array = new Array();
		
		public var monsterx:int;
		public var monstery:int;
		
		public var guyx:int;
		public var guyy:int;

		public var hint_x:int = 0;
		public var hint_y:int = 0;
		
		public static var MOVE_X:int = 15;
		public static var MOVE_Y:int = 15;
		
		public var set_values_called:Boolean = false;
		public var node_index_start:int = 0;
		public var node_index_end:int = 0;
		
		public static var START_DISTANCE:int = 1000;
		
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
		public static var EPOS_NODESTARTINDEX:int = 10;
		public static var EPOS_NODEENDINDEX:int = 11;
		public static var EPOS_TEMPFLAG:int = 12;
		public static var EPOS_ISHORIZONTAL:int = 13;
		public static var EPOS_DIRECTION_X:int = 14;
		public static var EPOS_DIRECTION_Y:int = 15;
		public static var EPOS_VISITED:int = 16;
		
		public static var NPOS_NODENAME:int = 0;
		public static var NPOS_COORDX:int = 1;
		public static var NPOS_COORDY:int = 2;
		public static var NPOS_CALCDIST:int = 3;
		public static var NPOS_VISITED:int = 4;
		public static var NPOS_PREVIOUS:int = 5;
		public static var NPOS_TEMPFLAG:int = 6;
		
		public var alg_state:int = 0;
		public var alg_count:int = 0;
		public static var COUNT_ALG:int = 1200;
		
		public static var ALG_NONE:int = -1;
		public static var ALG_ZERO:int = 0;
		public static var ALG_REMOVE_TEMP_A:int = 1;
		public static var ALG_REMOVE_TEMP_B:int = 2;
		public static var ALG_FINDEDGE_END_HORIZONTAL:int = 3;
		public static var ALG_FINDEDGE_END_VERTICAL:int = 4;
		public static var ALG_FINDEDGE_START_HORIZONTAL:int = 5;
		public static var ALG_FINDEDGE_START_VERTICAL:int = 6;
		public static var ALG_MAKE_NODES_AND_EDGES_START_HORIZONTAL:int = 7;
		public static var ALG_MAKE_NODES_AND_EDGES_START_VERTICAL:int = 8;
		public static var ALG_MAKE_NODES_AND_EDGES_END_HORIZONTAL:int = 9;
		public static var ALG_MAKE_NODES_AND_EDGES_END_VERTICAL:int = 10;
		public static var ALG_FIRST_HINT:int = 11;
		public static var ALG_START_DIJKSTRA:int = 12;
		public static var ALG_DIJKSTRA_LOOP_A:int = 13;
		public static var ALG_DIJKSTRA_LOOP_B:int = 14;
		public static var ALG_DIJKSTRA_LOOP_NEIGHBOR_LIST_A:int = 15;
		public static var ALG_DIJKSTRA_LOOP_NEIGHBOR_LIST_B:int = 16;
		public static var ALG_DIJKSTRA_LOOP_CLOSE:int = 17;
		public static var ALG_SECOND_HINT_A:int = 18;
		public static var ALG_SECOND_HINT_B:int = 19;
		public static var ALG_SECOND_HINT_C:int = 20;
		public static var ALG_NON_DIJKSTRA:int = 21;
		
		public var q_startedge_vert = 0;
		public var q_startedge_hor = 0;
		public var q_endedge_vert = 0;
		public var q_endedge_hor = 0;

		public var q_i:int = 0;//
		public var q_j:int = 0;
		public var q_list:Array = new Array();
		public var q_k:int = 0;
		public var q_alt:int = 0;
		public var q_edge:Array = new Array();
		public var q_hint:Boolean = false;
		public var q_hint_list:Array = new Array();
		public var q_list_index:int = 0;
		public var q_hint_nodes:Array = new Array();
		public var q_edge_indeces:int = 0;

		// ACTUAL SCREEN COORDINATES
		public var startingX:int = 0;
		public var startingY:int = 0;
		public var endingX:int = 0;
		public var endingY:int = 0;

		public var nodenumstart:int = 0;//
		public var nodenumend:int = 0;//
		public var TILE_WIDTH:int = 64;
		public var TILE_HEIGHT:int = 64;

		public var hint_nodenumstart:int = 0;
		public var hint_nodenumend:int = 0;
		public var hint_nodecounter:int = 0;

		public var hint_last_x:int = 0;
		public var hint_last_y:int = 0;

		public var hint_auto:Boolean = true;
		public var hint_direction_enum:int = 0;
		public var hint_timer_counter:int = 0;
		public var hint_edge_found:int = -1;
		
		public static var ENUM_HORIZONTAL_LEFT:int = 1;
		public static var ENUM_VERTICAL_UP:int = 2;
		public static var ENUM_HORIZONTAL_RIGHT:int = 3;
		public static var ENUM_VERTICAL_DOWN:int = 4;
		public static var ENUM_VERTICAL:int = 5;
		public static var ENUM_HORIZONTAL:int = 6;
		public static var ENUM_STILL:int = 7;
		
		public static var ALLOW_X:int = 1;
		public static var ALLOW_Y:int = 2;
		public static var ALLOW_BOTH:int = 3;
		
		public static var FOLLOW_UNSET:int = -1;
		public static var FOLLOW_START:int = 1;
		public static var FOLLOW_APPROACH_TURN:int = 2;
		public static var FOLLOW_APPROACH_TURN_CLOSE:int = 3;
		public static var FOLLOW_LEAVE_TURN_CLOSE:int = 4;
		public static var FOLLOW_LEAVE_TURN:int = 5;
		public static var FOLLOW_TURN_COMPLETE:int = 6;
		
		public var follow_enum:int = -1;
		public var orient_enum:int = -1;
		public var allow_enum:int = 1;
		
		public var latch_a:Boolean = false;
		public var latch_b:Boolean = false;
		public var latch_c:Boolean = false;
		
		public function AGai() {
			// constructor code
			// do nothing...
		}
		
		
		/* THIS IS DONE ONCE AT THE BEGINNING OF THE LEVEL */
		public function setValues(myinvisible:Array, myscreen:Stage, game:AGMode, multi:Boolean = false):void{
			this.set_values_called = true;
			
			myInvisible = myinvisible;
			myScreen = myscreen;
			myGame = game;
			myMultiFlag = multi;
			
			this.setupGraph();
		}
		
		public function setupGraph( ):void {
			//this.myInvisible = myinvisible;
			this.alg_count = 0;
			
			this.invisibleChutes = new Array();
			this.invisibleDots = new Array();
			this.edgesFromDots = new Array();
			this.nodesFromDots = new Array();
			
			var i:int = 0;
			var j:int = 0;
			var k:int = 0;
			var tempArray:Array;
			
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
					if (i < this.myInvisible.length && i > 0 && 
						this.myInvisible[i][j] == AGModeGuy.B_LADDER) {
						
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
					if ((this.invisibleDots[i][k] != 0 || this.invisibleChutes[i][k] != 0)){
						
						
						if(((this.isEndNodeBasic(k,i, this.invisibleDots) || this.isEndNodeHoriz(k,i)) && 
							(this.myInvisible[i][k] != AGModeGuy.B_LADDER) || 
						   (this.myInvisible[i][k] == AGModeGuy.B_LADDER && 
							this.myInvisible[i+1][k] == AGModeGuy.B_BLOCK))){
							//record a horizontal edge
							startx = l;
							endx = k;
							if (l != k) {
								//
								this.makeCoordinateListingHorizontal(startx,endx,i,false);
								
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
			if (this.invisibleDots.length != 0) {//return;
				
				for (i = 0; i < this.invisibleDots[0].length; i ++) {
					
					k = 0;
					l = 0;
					while(k < this.invisibleDots.length) {
						starty = 0;
						endy = 0;
						
						if (this.invisibleDots[k][i] != 0 ) {
							
							if(this.isEndNodeBasic(i,k, this.invisibleDots) ){//
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
			/////
			// vertical edges chutes
			
			
			if (this.invisibleChutes.length != 0) {// return;
			
				for (i = 0; i < this.invisibleChutes[0].length; i ++) {
					
					k = 0;
					l = 0;
					while(k < this.invisibleChutes.length) {
						starty = 0;
						endy = 0;
						
						if (this.invisibleChutes[k][i] != 0 ) {
							
							if(this.isEndNodeChute(i,k)  ){//
								//record a vert edge
								starty = l;
								endy = k;
								if (l != k) {
									
									this.makeCoordinateListingVertical(starty,endy,i,true);
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
			
			
			
			////
			// set index of nodes in edge array
			
			for (i = 0; i < this.edgesFromDots.length; i ++) {
				this.connectNodeEdgeIndices(i);
			}
			
			this.alg_state = AGai.ALG_ZERO;
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
		
		public function makeCoordinateListingHorizontal(startx:int, endx:int, ylevel:int, isJump:Boolean, isTemp:Boolean = false):Array{
			
			// put edges in list
			var values:Array = new Array();
			
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
							 isJump,// is jump segment??
							 0, // edge A index in node array
							 0, // edge B index in node array
							 isTemp,//false, // is temp flag set??
							 true, // is-horizontal??
							 0,// x direction
							 0, // y direction
							 false); // visited
			this.edgesFromDots.push(temp);
			
			values.push(this.makeCoordinateListingNodes(startx,ylevel, isTemp));
			values.push(this.makeCoordinateListingNodes(endx,ylevel, isTemp));
			return values;
		}
		
		
		
		public function makeCoordinateListingVertical(starty:int, endy:int, xlevel:int, isJump:Boolean, isTemp:Boolean = false):Array {
			// put edges in list
			var values:Array = new Array();
			
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
							 isJump, // is jump segment??
							 0, // edge A node index number
							 0, // edge B node index number
							 isTemp,//false, // is temp flag set??
							 false, // is-horizontal??
							 0, // x direction
							 0, // y dierction
							 false);  // visited
			this.edgesFromDots.push(temp);
			
			values.push(this.makeCoordinateListingNodes(xlevel,starty, isTemp));
			values.push(this.makeCoordinateListingNodes(xlevel,endy, isTemp));
			return values;
		}
		
		public function makeCoordinateListingNodes(x:int, y:int, isTemp:Boolean = false):int {
			var i:int = 0;
			var listed:Boolean = false;
			var listed_index:int = -1;
			var nodename:String = this.makeNodeName(x, y);
			//var j:int = 0;
			// put nodes in list... NO REPEATS
			for (i = 0; i < this.nodesFromDots.length; i ++) {
				if (nodename == this.nodesFromDots[i][NPOS_NODENAME]) {
					listed = true;
					listed_index = i;
					//j++;
				}
			}
			var node:Array = new Array( nodename, // node name
										x, //node x
										y, //node y
										START_DISTANCE, // D distance (infinity)
										false, //visited?
										-1, // previous....
										isTemp // is node temp flag set??
										); 
			
			if (!listed) {
				this.nodesFromDots.push(node);
				return this.nodesFromDots.length -1;
			}
			else {
				return listed_index;
			}
		}
		
		public function connectNodeEdgeIndices(j:int):int {
			var i:int = 0;
			var edgenameend:String ;
			var edgenamestart:String ;
			
			for (i = 0; i < this.nodesFromDots.length; i ++) {
				
				
				edgenamestart = this.makeNodeName(
					this.edgesFromDots[j][AGai.EPOS_STARTX], 
					this.edgesFromDots[j][AGai.EPOS_STARTY]);
					
				edgenameend = this.makeNodeName(
					this.edgesFromDots[j][AGai.EPOS_STOPX], 
					this.edgesFromDots[j][AGai.EPOS_STOPY]);
					
					
				if (edgenamestart == 
					this.nodesFromDots[i][AGai.NPOS_NODENAME]) {
					this.edgesFromDots[j][AGai.EPOS_NODESTARTINDEX] = i;
					
				}
				else if(edgenameend ==
					  this.nodesFromDots[i][AGai.NPOS_NODENAME]) {
					this.edgesFromDots[j][AGai.EPOS_NODEENDINDEX] = i;
					
				}
			}

			return 0;
		}
		
		public function isEndNodeHoriz(x:int, y:int):Boolean {
			var value:Boolean = true;
			var connections:int = 0;
			if (y == 0 || y == this.invisibleDots.length || 
				x == 0 || x == this.invisibleDots[0].length) return true;
				
			// what to do if next to a chute
			if ((this.invisibleDots[y][x] == 1 && 
				this.invisibleDots[y][x+ 1] == 0 &&
				this.invisibleChutes[y][x+ 1] != 1 ) //||
				) {
				connections ++;
			}
			if ((this.invisibleDots[y][x] == 1 && 
				this.invisibleDots[y][x - 1] == 0 &&
				this.invisibleChutes[y][x -1] != 1) //||
				) {
				connections ++;
			}
			/////////////////////////
			//what to do if next to a chute
			if ((this.invisibleDots[y][x - 1] == 1 && //
				this.invisibleChutes[y][x] == 1) &&
				this.invisibleChutes[y][x+ 1] != 1
				) {
				connections ++;
			}
			if ((this.invisibleDots[y][x +1] == 1 && //
				this.invisibleChutes[y][x] == 1) &&
				this.invisibleChutes[y][x -1] != 1
				) {
				connections ++;
			}
			////
			
			if ( this.myInvisible[y][x] != AGModeGuy.B_LADDER && 
				this.myInvisible[y+1][x] == AGModeGuy.B_LADDER ) {
				connections ++;
				
			}
			
			if (connections == 0) value = false;
			
			return value;
		}
		
		
		
		public function isEndNodeChute(x:int, y:int):Boolean {
			var value:Boolean = true;
			var connections:int = 0;
			if (y == 0 || y == this.invisibleChutes.length || 
				x == 0 || x == this.invisibleChutes[0].length) return true;
				
			// 
			if (this.invisibleChutes[y][x] == 1 && 
				this.invisibleChutes[y-1][x] == 0 //&&
				
				) {
				connections ++;
			}
			if (this.invisibleChutes[y][x] == 1 && 
				this.invisibleChutes[y+1][x] == 0// &&
				
				) {
				connections ++;
			}		
			//does path not turn?
			if (connections == 0) value = false;
			
			return value;
		}
		
		/* CHECK IF END NODE */
		public function isEndNodeBasic(xblock:int, yblock:int, invisible:Array):Boolean {
			var value:Boolean = true;
			if (yblock == 0 || yblock == invisible.length || 
				xblock == 0 || xblock == invisible[0].length) return true;
			
			var connections:int = 0;
			if (invisible[yblock - 1][xblock] == 1 && //up
				invisible[yblock ][xblock + 1] == 1 //right
				) {
				connections ++;
			}
			if (invisible[yblock ][xblock + 1] == 1 && // right
				invisible[yblock + 1][xblock] == 1) { // down
				connections ++;
			}
			if (invisible[yblock][xblock - 1] == 1 && // left
				invisible[yblock - 1][xblock] == 1) { //up
				connections ++;
			}
			if (invisible[yblock + 1][xblock] == 1 && // down
				invisible[yblock ][xblock - 1] == 1) { // left
				connections ++;
			}
			
			//does path not turn?
			if (connections == 0) value = false;
			
			return value;
		}
		
		/////////////////////////////////////////////////////////////////
		
		public function setStartEnd(startX:int, startY:int, endX:int, endY:int, speed:int = 1, sprite:AGSprite = null):void {
			var i:int = 0;
			
			
			this.startingX = startX; // monster
			this.startingY = startY;
			this.endingX = endX; // guy
			this.endingY = endY;
			
			
			
			if (sprite != null) {
				this.mySprite = sprite;
			}
			
			if (!this.myMultiFlag) {
				//this.advanceNodecounter();
				this.startNewsegment();
			}
			else {
				
			}
			this.findAndFollowEdge();
			
			if (!this.myMultiFlag) {
				for (i = 0; i < speed; i ++) {
					this.doCalc();
				
				}
			}
		}
		
		/* THIS IS DONE BEFORE EACH REDRAW OF THE SCREEN */
		
		public function doCalc() {
			
			this.alg_count ++;
			if (this.alg_count > AGai.COUNT_ALG && false) { //1200
				this.alg_count = 0;
				this.alg_state = AGai.ALG_ZERO;
			}
			
			
			var i:int = 0;
			var found:int = -1;
			var pair1:Array;
			var pair2:Array;
			var tempArray:Array = new Array();
			var j:int = 0;
			
			switch(this.alg_state) {
				case AGai.ALG_NONE:
					//do nothing...
				break;
				case AGai.ALG_ZERO:
					//start everything...
					for (i = 0; i < this.nodesFromDots.length; i ++) {
						this.nodesFromDots[i][AGai.NPOS_VISITED] = false;
						this.nodesFromDots[i][AGai.NPOS_CALCDIST] = AGai.START_DISTANCE;
						
					}
					this.nodenumend = -1;
					this.nodenumstart = -1;
					
					if (!this.myMultiFlag) {
						this.guyx = this.endingX;
						this.guyy = this.endingY;
			
						this.monsterx = this.startingX;
						this.monstery = this.startingY;
					}
					else {
						this.monsterx = this.endingX;
						this.monstery = this.endingY;
						
						this.guyx = this.startingX;
						this.guyy = this.startingY;
					}
					
					this.q_endedge_hor = -1;
					this.q_endedge_vert = -1;
					
					this.q_startedge_hor = -1;
					this.q_startedge_vert = -1;
					
					this.alg_state ++;
				break;
				case AGai.ALG_REMOVE_TEMP_A:
					for (i = 0; i < this.edgesFromDots.length; i ++) {
						this.edgesFromDots[i][AGai.EPOS_VISITED] = false;
						if (this.edgesFromDots[i][AGai.EPOS_TEMPFLAG] == true) {
							this.edgesFromDots = this.edgesFromDots.slice(0,i );//
							//
							//
							break;
						}
					}
					this.alg_state ++;
				break;
				case AGai.ALG_REMOVE_TEMP_B:
					for (i = 0; i < this.nodesFromDots.length; i ++) {
						//
						if (this.nodesFromDots[i][AGai.NPOS_TEMPFLAG] == true) {
							this.nodesFromDots = this.nodesFromDots.slice(0,i );//
							//
							//
							break;
						}
					}
					
					this.alg_state ++;
				break;
				case AGai.ALG_FINDEDGE_END_HORIZONTAL:
					if (this.myMultiFlag && false ) {
						this.alg_state ++;
						break;
					}
					
				
					found = -1;
					for (i = 0; i < this.edgesFromDots.length; i ++) {
						if (this.edgesFromDots[i][AGai.EPOS_ISHORIZONTAL] == true && 
							this.edgesFromDots[i][AGai.EPOS_TEMPFLAG] == false) {
							if (this.edgesFromDots[i][AGai.EPOS_STARTX] * this.TILE_WIDTH < this.guyx &&
								this.edgesFromDots[i][AGai.EPOS_STOPX] * this.TILE_WIDTH > this.guyx &&
								this.edgesFromDots[i][AGai.EPOS_STARTY] * this.TILE_HEIGHT - (this.TILE_HEIGHT * 3 / 2) < this.guyy &&
								this.edgesFromDots[i][AGai.EPOS_STARTY] * this.TILE_HEIGHT + (this.TILE_HEIGHT / 2) > this.guyy) {
								found = i;
							}
						}
					}
					this.q_endedge_hor = found;
					this.alg_state ++;
				
				break;
				case AGai.ALG_FINDEDGE_END_VERTICAL:
					// alg_find ending vert edge...
					if (this.myMultiFlag && false ) {
						this.alg_state ++;
						break;
					}
					found = -1;
					for (i = 0; i < this.edgesFromDots.length; i ++) {
						if (this.edgesFromDots[i][AGai.EPOS_ISHORIZONTAL] == false && 
							this.edgesFromDots[i][AGai.EPOS_TEMPFLAG] == false) {
							if (this.edgesFromDots[i][AGai.EPOS_STARTY] * this.TILE_HEIGHT < this.guyy &&
								this.edgesFromDots[i][AGai.EPOS_STOPY] * this.TILE_HEIGHT > this.guyy &&
								this.edgesFromDots[i][AGai.EPOS_STARTX] * this.TILE_WIDTH - (this.TILE_WIDTH / 2) < this.guyx &&
								this.edgesFromDots[i][AGai.EPOS_STARTX] * this.TILE_WIDTH + (this.TILE_WIDTH / 2) > this.guyx) {
								found = i;
							}
						}
					}
					this.q_endedge_vert = found;
					this.alg_state ++;
				break;
				case AGai.ALG_FINDEDGE_START_HORIZONTAL:
					// alg_find starting horiz edge...
					if (this.myMultiFlag && false ) {
						this.alg_state ++;
						break;
					}
					found = -1;
					for (i = 0; i < this.edgesFromDots.length; i ++) {
						if (this.edgesFromDots[i][AGai.EPOS_ISHORIZONTAL] == true && 
							this.edgesFromDots[i][AGai.EPOS_TEMPFLAG] == false) {
							if (this.edgesFromDots[i][AGai.EPOS_STARTX] * this.TILE_WIDTH < this.monsterx &&
								this.edgesFromDots[i][AGai.EPOS_STOPX] * this.TILE_WIDTH > this.monsterx &&
								this.edgesFromDots[i][AGai.EPOS_STARTY] * this.TILE_HEIGHT - (this.TILE_HEIGHT * 3 / 2) < this.monstery &&
								this.edgesFromDots[i][AGai.EPOS_STARTY] * this.TILE_HEIGHT + (this.TILE_HEIGHT / 2) > this.monstery) {
								found = i;
							}
						}
					}
					this.q_startedge_hor = found;
					this.alg_state ++;
				break;
				case AGai.ALG_FINDEDGE_START_VERTICAL:
					// alg_find starting vert edge...
					if (this.myMultiFlag && false ) {
						this.alg_state ++;
						break;
					}
					found = -1;
					for (i = 0; i < this.edgesFromDots.length; i ++) {
						if (this.edgesFromDots[i][AGai.EPOS_ISHORIZONTAL] == false && 
							this.edgesFromDots[i][AGai.EPOS_TEMPFLAG] == false) {
							if (this.edgesFromDots[i][AGai.EPOS_STARTY] * this.TILE_HEIGHT < this.monstery &&
								this.edgesFromDots[i][AGai.EPOS_STOPY] * this.TILE_HEIGHT > this.monstery &&
								this.edgesFromDots[i][AGai.EPOS_STARTX] * this.TILE_WIDTH - (this.TILE_WIDTH / 2) < this.monsterx &&
								this.edgesFromDots[i][AGai.EPOS_STARTX] * this.TILE_WIDTH + (this.TILE_WIDTH / 2) > this.monsterx) {
								found = i;
							}
						}
					}
					this.q_startedge_vert = found;
					this.alg_state ++;
				break;
				case AGai.ALG_MAKE_NODES_AND_EDGES_START_HORIZONTAL:
					found = -1;
					if (this.q_startedge_hor != -1) {
						pair1 = this.makeCoordinateListingHorizontal(
								this.edgesFromDots[this.q_startedge_hor][AGai.EPOS_STARTX],
								Math.floor(this.monsterx /this.TILE_WIDTH), 
								this.edgesFromDots[this.q_startedge_hor][AGai.EPOS_STARTY],
								false, true);
						pair2 = this.makeCoordinateListingHorizontal(
								Math.floor(this.monsterx / this.TILE_WIDTH),
								this.edgesFromDots[this.q_startedge_hor][AGai.EPOS_STOPX],
								this.edgesFromDots[this.q_startedge_hor][AGai.EPOS_STARTY],
								false, true);
						//trace(1,"pair1", pair1, "pair2", pair2);
						
						if (pair1[0] == pair2[0]) {
							found = pair1[0];
						}
						else {
							found = pair1[1];
						}
					}
					
					this.nodenumstart = found;
					//trace("start node",this.nodesFromDots[this.nodenumstart]);
					this.alg_state ++;
				break;
				case AGai.ALG_MAKE_NODES_AND_EDGES_START_VERTICAL:
					found = -1;
					if (this.q_startedge_vert != -1 ){//&& this.q_startedge_hor == -1) {
						pair1 = this.makeCoordinateListingVertical(
								this.edgesFromDots[this.q_startedge_vert][AGai.EPOS_STARTY],
								Math.floor(this.monstery / this.TILE_WIDTH), 
								this.edgesFromDots[this.q_startedge_vert][AGai.EPOS_STARTX],
								false, true);
						pair2 = this.makeCoordinateListingVertical(
								Math.floor(this.monstery / this.TILE_WIDTH),
								this.edgesFromDots[this.q_startedge_vert][AGai.EPOS_STOPY],
								this.edgesFromDots[this.q_startedge_vert][AGai.EPOS_STARTX],
								false, true);
						//trace(2,"pair2", pair1, "pair2", pair2);

						if (pair1[0] == pair2[0]) {
							found = pair1[0];
						}
						else {
							found = pair1[1];
						}
					}
					if (this.q_startedge_hor == -1 && found != -1) {
						this.nodenumstart = found;
					}
					//trace("start node", this.nodesFromDots[ this.nodenumstart]);
					
					if (this.nodenumstart < 0 && !this.myMultiFlag) {
						this.alg_state = AGai.ALG_ZERO;
						break;
					}
					
					this.alg_state ++;
					
				break;
				
				case AGai.ALG_MAKE_NODES_AND_EDGES_END_HORIZONTAL:
					if (this.myMultiFlag && false) {
						this.alg_state ++;
						break;
					}
				
					found = -1;
					if (this.q_endedge_hor != -1 ) {
						pair1 = this.makeCoordinateListingHorizontal(
								this.edgesFromDots[this.q_endedge_hor][AGai.EPOS_STARTX],
								Math.floor(this.guyx / this.TILE_WIDTH), 
								this.edgesFromDots[this.q_endedge_hor][AGai.EPOS_STARTY],
								false, true);
						pair2 = this.makeCoordinateListingHorizontal(
								Math.floor(this.guyx / this.TILE_WIDTH),
								this.edgesFromDots[this.q_endedge_hor][AGai.EPOS_STOPX],
								this.edgesFromDots[this.q_endedge_hor][AGai.EPOS_STARTY],
								false, true);
						//trace(3,"pair3", pair1, "pair2", pair2);

						if (pair1[0] == pair2[0]) {
							found = pair1[0];
						}
						else {
							found = pair1[1];
						}
					}
					this.nodenumend = found;
					//trace("end node",this.nodesFromDots[ this.nodenumend]);
					this.alg_state ++;
				
				break;
				case AGai.ALG_MAKE_NODES_AND_EDGES_END_VERTICAL:
					if (this.myMultiFlag && false) {
						this.alg_state ++;
						break;
					}
					found = -1;
					if (this.q_endedge_vert != -1 ) {
						pair1 = this.makeCoordinateListingVertical(
								this.edgesFromDots[this.q_endedge_vert][AGai.EPOS_STARTY],
								Math.floor(this.guyy / this.TILE_WIDTH), 
								this.edgesFromDots[this.q_endedge_vert][AGai.EPOS_STARTX],
								false, true);
						pair2 = this.makeCoordinateListingVertical(
								Math.floor(this.guyy / this.TILE_WIDTH),
								this.edgesFromDots[this.q_endedge_vert][AGai.EPOS_STOPY],
								this.edgesFromDots[this.q_endedge_vert][AGai.EPOS_STARTX],
								false, true);
						//trace(4,"pair4", pair1, "pair2", pair2);
						
						if (pair1[0] == pair2[0]) {
							found = pair1[0];
						}
						else {
							found = pair1[1];
						}
					}
					if ( found != -1) {
						this.nodenumend = found;
					}
					//
					this.alg_state ++;
				break;
				case AGai.ALG_FIRST_HINT:
					
					if(this.q_hint_nodes.length < this.hint_nodecounter + 2) {
						if (this.q_endedge_hor != -1 && this.hint_auto) {
							if (this.guyx < this.startingX ) {
								this.hint_x = - AGai.MOVE_X;
							}
							else {
								this.hint_x = AGai.MOVE_X;
							}
						}
						if (this.q_endedge_vert != -1) {
							if (this.guyy < this.startingY) {
								this.hint_y = - AGai.MOVE_Y;
							}
							else {
								this.hint_y = AGai.MOVE_Y;
							}
						}
					}
					
					if (this.nodenumend == -1 || this.nodenumstart == -1) {
						//this.alg_state = AGai.ALG_ZERO;
						
						//return;
					}
					this.alg_state ++;
				break;
				case AGai.ALG_START_DIJKSTRA:
					this.node_index_end = -1;
					
					for (i = 0; i < this.edgesFromDots.length; i ++) {
						if (this.edgesFromDots[i][AGai.EPOS_TEMPFLAG] == true) {
							this.connectNodeEdgeIndices(i);
							

						}
					}
					if (!this.myMultiFlag  ) {
						this.nodesFromDots[this.nodenumstart][AGai.NPOS_CALCDIST] =  0;
					}
					else if (this.nodenumstart != -1) {
						this.nodesFromDots[this.nodenumstart][AGai.NPOS_CALCDIST] = 0;
					}
					else if (this.nodenumstart == -1) {
						this.alg_state = AGai.ALG_ZERO;
						break;
					}
					
					q_i = 0;
					q_j = 0;
					q_list = new Array();
					q_k = 0;
					q_alt = 0;
					q_edge = new Array();
					q_hint = false;
					
					this.alg_state ++;
				break;
				case AGai.ALG_DIJKSTRA_LOOP_A:
					q_i = this.smallestDistanceNode();
					
					this.nodesFromDots[q_i][AGai.NPOS_VISITED] = true;
					
					
					
					if (q_i == this.nodenumend && !this.myMultiFlag ) {
						
						this.node_index_end = q_i;
						
						this.q_list_index = 0;
						this.alg_state = AGai.ALG_SECOND_HINT_A;
						break;
						
					}
					
					
					if (this.nodesFromDots[q_i][AGai.NPOS_CALCDIST] >= AGai.START_DISTANCE
						&& !this.myMultiFlag ) {
						
						
						this.alg_state = AGai.ALG_SECOND_HINT_A;
						break;
					}
					
					
					this.alg_state ++;
				break;
				
				case AGai.ALG_DIJKSTRA_LOOP_B:
					q_list = this.getNodeNeighborList(q_i);

					
					
					this.q_list_index = 0;
					this.alg_state ++;
				break;
				
				case AGai.ALG_DIJKSTRA_LOOP_NEIGHBOR_LIST_A:
					
					this.q_j = this.q_list[this.q_list_index];
					
					
					if (this.q_list.length > 0) {
						
						this.q_edge_indeces = this.getEdgeIndecesFromNodeIndeces(q_i, q_j);
					}
					
					this.alg_state ++;
				break;
				
				case AGai.ALG_DIJKSTRA_LOOP_NEIGHBOR_LIST_B:
					if (q_list.length > 0 && this.q_edge_indeces >=0 ) { 
				
						q_k = this.edgesFromDots[this.q_edge_indeces][AGai.EPOS_DIST];
					
						
						q_alt = q_k + this.nodesFromDots[q_i][AGai.NPOS_CALCDIST];
						
						
						if (q_alt <= this.nodesFromDots[q_j][AGai.NPOS_CALCDIST] ){// was q_j 
							this.nodesFromDots[q_j][AGai.NPOS_CALCDIST] = q_alt;
							this.nodesFromDots[q_j][AGai.NPOS_PREVIOUS] = q_i;
							
							this.edgesFromDots[this.q_edge_indeces][AGai.EPOS_DIRECTION_X] = 
								this.getEdgeDirectionX(q_i, q_j, this.q_edge_indeces);
							this.edgesFromDots[this.q_edge_indeces][AGai.EPOS_DIRECTION_Y] = 
								this.getEdgeDirectionY(q_i, q_j, this.q_edge_indeces);
							
							this.edgesFromDots[this.q_edge_indeces][AGai.EPOS_VISITED] = true;
						}
					
					}
					if (this.q_list_index < this.q_list.length -1) {
						this.q_list_index ++;
						this.alg_state = AGai.ALG_DIJKSTRA_LOOP_NEIGHBOR_LIST_A;
						break;
					}
					else {
						this.q_list_index = 0;
						this.q_list = new Array();
						this.alg_state ++;
					}
				break;
				
				case AGai.ALG_DIJKSTRA_LOOP_CLOSE:
					
					if (!this.isListEmpty()) {
						
						this.alg_state = AGai.ALG_DIJKSTRA_LOOP_A;
						break;
					}
					else {
						if (this.node_index_end == -1) {
							
							this.alg_state = AGai.ALG_ZERO;
							break;
						}
						
						this.alg_state = AGai.ALG_SECOND_HINT_A;
					}
				break;
				
				
				case AGai.ALG_SECOND_HINT_A:
					if (this.myMultiFlag) {
						this.alg_state = AGai.ALG_ZERO;
						break;
					}
					else {
						this.q_hint_nodes = new Array();
						for(i = 0; i < this.nodesFromDots.length; i ++) {
							tempArray = new Array();
							for (j = 0; j < this.nodesFromDots[i].length; j ++) {
								tempArray.push(this.nodesFromDots[i][j]);
							}
							this.q_hint_nodes.push(tempArray);
						}
					}
				
					
					//this.alg_state = AGai.ALG_ZERO;
					this.alg_state ++;
				break;
				case AGai.ALG_SECOND_HINT_B:
					
					if (!this.myMultiFlag) this.q_hint_list = this.createHint();
					
					this.hint_nodecounter = 1;
					this.hint_nodenumend = this.nodenumend;
					this.hint_nodenumstart = this.nodenumstart;
					
					this.alg_count =0;
					
					//this.alg_state ++;
					this.alg_state = AGai.ALG_ZERO;
				break;
				case AGai.ALG_SECOND_HINT_C:
				
					//this.createHintEdges();
				break;
				
				case AGai.ALG_NON_DIJKSTRA:
				
				break;
				
				
				default:
					
					this.alg_state = AGai.ALG_ZERO;
				break;
			}
		}
		
		
		
		
		private function isListEmpty():Boolean {
			var value:Boolean = true;
			var i:int = 0;
			var j:int = 0;
			for (i = 0; i < this.nodesFromDots.length; i ++) {
				if (this.nodesFromDots[i][AGai.NPOS_VISITED] == false ){
					value = false;
					j ++;
				}
			}
			
			return value;
		}
		
		private function smallestDistanceNode():int {
			var value:int = 0;
			var i:int = 0; // for loop index
			var j:int = 0; // for loop calc-dist
			var k:int = AGai.START_DISTANCE; // lowest dist
			var l:int = 0;//  value output
			
			var default_l:int = -1;
			
			for (i = 0; i < this.nodesFromDots.length; i ++) {
				if (!this.nodesFromDots[i][AGai.NPOS_VISITED]) {
					j = this.nodesFromDots[i][AGai.NPOS_CALCDIST];
					
					if (default_l == -1) { 
						default_l = i;
						
					}
					if (j < k) {
						k = j;
						l = i;
						//trace(k);
					}
				}
			}
			
			if (k == AGai.START_DISTANCE) {
				l = default_l;
			}
			
			value = l;
			
			return value;
		}
		
		
		private function getNodeNeighborList(node:int):Array {
			var val:int = -1;
			var list:Array = new Array();
			var i:int = 0;
			var j:int = 0;
			for (i = 0; i < this.edgesFromDots.length; i ++) {
				if ( !this.edgesFromDots[i][AGai.EPOS_ISJUMP]  || 
					this.edgesFromDots[i][AGai.EPOS_TOPY] >= this.monstery  ){
						
					if (this.edgesFromDots[i][AGai.EPOS_NODESTART] == 
						this.nodesFromDots[node][AGai.NPOS_NODENAME]) {
						
						val = this.edgesFromDots[i][AGai.EPOS_NODEENDINDEX];
						
						if (this.nodesFromDots[val][AGai.NPOS_VISITED] == false ){//|| true) {
							list.push(val);
						}
						
						
					}
					else if (this.edgesFromDots[i][AGai.EPOS_NODEEND] == 
							 this.nodesFromDots[node][AGai.NPOS_NODENAME]) {
								 
						val = this.edgesFromDots[i][AGai.EPOS_NODESTARTINDEX];
						if (this.nodesFromDots[val][AGai.NPOS_VISITED] == false ){//|| true) {
							list.push(val);
						}
						
					}
					
				}
				
			}
			
			return list;
		}
		
		private function getEdgeIndecesFromNodeIndeces(nodeenda:int, nodeendb:int):int {
			var a_array:Array = this.nodesFromDots[nodeenda];
			var b_array:Array = this.nodesFromDots[nodeendb];
			var ab_name:String = this.makeEdgeName(a_array[AGai.NPOS_COORDX],
												   a_array[AGai.NPOS_COORDY],
												   b_array[AGai.NPOS_COORDX], 
												   b_array[AGai.NPOS_COORDY]);
												   
			var ba_name:String = this.makeEdgeName(b_array[AGai.NPOS_COORDX],
												   b_array[AGai.NPOS_COORDY],
												   a_array[AGai.NPOS_COORDX], 
												   a_array[AGai.NPOS_COORDY]);
			var i:int;
			var j:int = -1;
			var value:Array = new Array();
			for(i = 0; i < this.edgesFromDots.length; i ++){
				if (this.edgesFromDots[i][AGai.EPOS_EDGENAME] == ab_name) {
					j = i;
				}
				else if(this.edgesFromDots[i][AGai.EPOS_EDGENAME] == ba_name) {
					j = i;
				}
			}
			
			return j;
		}
		
		private function getEdgeFromNodeIndeces(nodeenda:int, nodeendb:int):Array {
			
			var j:int = -1;
			var value:Array = new Array();
			
			j = this.getEdgeIndecesFromNodeIndeces(nodeenda, nodeendb);
			
			if (j == -1) { 
				value = new Array();//this.edgesFromDots[0];
				//trace("ERROR");
			}
			else value = this.edgesFromDots[j];
			return value;
		}
		
		public function getEdgeDirectionX(nodea:int, nodeb:int, edge:int) : int {
			var value1:int = 0;
			if (nodea < 0 || nodea>=this.nodesFromDots.length || 
				nodeb < 0 || nodeb>=this.nodesFromDots.length  ||
				edge < 0 || edge >= this.edgesFromDots.length) {
				return value1;
			}
			
			var a:int = this.nodesFromDots[nodea][AGai.NPOS_COORDY];
			var b:int = this.nodesFromDots[nodeb][AGai.NPOS_COORDY];
			var e:int = this.edgesFromDots[edge][AGai.EPOS_STARTX];
			
			if (a != b) {
				//trace("bad y in x direction");
				return value1;
			}
			//else trace("good x");
			
			a = this.nodesFromDots[nodea][AGai.NPOS_COORDX];
			b = this.nodesFromDots[nodeb][AGai.NPOS_COORDX];
			
			
			if (!this.myMultiFlag ) {
				if (a>b ) {
					value1 = - AGai.MOVE_X;
				}
				else if (b>a){
					value1 = AGai.MOVE_X;
				}
				else return 0;
			}
			else {
				if (a<b ) {
					value1 = - AGai.MOVE_X;
				}
				else if (a>b){
					value1 = AGai.MOVE_X;
				}
				else return 0;
				//if (a== e) value1 = value1 * -1;
			}
			
			return value1;
		}
		
		public function getEdgeDirectionY(nodea:int, nodeb:int, edge:int) : int {
			var value1:int = 0;
			if (nodea < 0 || nodea>=this.nodesFromDots.length || 
				nodeb < 0 || nodeb>=this.nodesFromDots.length ||
				edge < 0 || edge >= this.edgesFromDots.length) {
				return value1;
			}
			
			var a:int = this.nodesFromDots[nodea][AGai.NPOS_COORDX];
			var b:int = this.nodesFromDots[nodeb][AGai.NPOS_COORDX];
			var e:int = this.edgesFromDots[edge][AGai.EPOS_STARTY];
			
			
			if (a != b) {
				//trace("bad x in y direction");
				return value1;
			}
			//else trace("good y");
			
			a = this.nodesFromDots[nodea][AGai.NPOS_COORDY];
			b = this.nodesFromDots[nodeb][AGai.NPOS_COORDY];
			
			
			if (!this.myMultiFlag ) {
				if (a>b ) {
					value1 = - AGai.MOVE_Y;
				}
				else if (b>a){
					value1 = AGai.MOVE_Y;
				}
				else return 0;
			}
			else {
				if (a<b ) {
					value1 = - AGai.MOVE_Y;
				}
				else if (b<a){
					value1 = AGai.MOVE_Y;
				}
				else return 0;
				//if (a== e) value1 = value1 * -1;
			}
			
			return value1;
		}
		
		
		/////////////////////////////////////////////////////////
		
		
		public function findAndFollowEdge() :void {
			var found:int = 0;
			var i:int = 0;
			var j:int = 0;
			//
			var somex:int = 0;
			var somey:int = 0;
			
			if (!this.myMultiFlag) {
				somex = this.monsterx;
				somey = this.monstery;
			}
			else {
				somex = this.startingX;
				somey = this.startingY;
			}
			
			found = -1;
			for (i = 0; i < this.edgesFromDots.length; i ++) {
				if (true) {
					if (this.edgesFromDots[i][AGai.EPOS_STARTY] * this.TILE_HEIGHT <= somey &&
						this.edgesFromDots[i][AGai.EPOS_STOPY] * this.TILE_HEIGHT >= somey &&
						this.edgesFromDots[i][AGai.EPOS_STARTX] * this.TILE_WIDTH - (this.TILE_WIDTH / 2) <= somex &&
						this.edgesFromDots[i][AGai.EPOS_STARTX] * this.TILE_WIDTH + (this.TILE_WIDTH / 2) >= somex) {
						//found = i;
						j++;
						if (0 != this.edgesFromDots[i][AGai.EPOS_DIRECTION_X] ||
							0 != this.edgesFromDots[i][AGai.EPOS_DIRECTION_Y] ) {
							found = i;
							//trace("vert");
							
						}
					}
					if (this.edgesFromDots[i][AGai.EPOS_STARTX] * this.TILE_HEIGHT <= somex &&
						this.edgesFromDots[i][AGai.EPOS_STOPX] * this.TILE_HEIGHT + this.TILE_WIDTH >= somex &&
						this.edgesFromDots[i][AGai.EPOS_STARTY] * this.TILE_WIDTH - (this.TILE_WIDTH / 2) <= somey &&
						this.edgesFromDots[i][AGai.EPOS_STARTY] * this.TILE_WIDTH + (this.TILE_WIDTH / 2) >= somey) {
						//found = i;
						j++;
						if (0 != this.edgesFromDots[i][AGai.EPOS_DIRECTION_X] ||
							0 != this.edgesFromDots[i][AGai.EPOS_DIRECTION_Y] ) {
							found = i;
							//trace("hor");
							
						}
					}
					/*
					trace( i, this.edgesFromDots[i][AGai.EPOS_EDGENAME], this.nodenumend, this.nodenumstart
						,"j="+j, this.edgesFromDots[i][AGai.EPOS_DIRECTION_X] , 
						this.edgesFromDots[i][AGai.EPOS_DIRECTION_Y],
						this.edgesFromDots[i][AGai.EPOS_ISHORIZONTAL],
						"v="+this.edgesFromDots[i][AGai.EPOS_VISITED]);
					*/
				}
			}
			if (found == -1) {
				//trace("none found");
			}
			else {
				this.hint_x = this.edgesFromDots[found][AGai.EPOS_DIRECTION_X];
				this.hint_y = this.edgesFromDots[found][AGai.EPOS_DIRECTION_Y];
				
				this.hint_edge_found = found;
				/*
				trace("found", found, this.edgesFromDots[found][AGai.EPOS_DIRECTION_X], 
					   this.edgesFromDots[found][AGai.EPOS_DIRECTION_Y]);
				
				trace("edges num", this.edgesFromDots.length);
				*/
			}
		}
		
		public function isHitCenter(x:int, y:int, graphnode:Boolean = true, width:int = 8, height:int = 8):Boolean {
			
			if (this.mySprite.bitmap == null){ 
				//trace("no bitmap here");
				return false;
			}
			var awidth:int = this.mySprite.bitmap.width;
			var aheight:int = this.mySprite.bitmap.height;
			var drop:int = aheight - 64;
			var ax:int = this.monsterx;// +( awidth / 2) - 4;
			var ay:int = this.monstery;// + ( aheight / 2);
			var arect:Rectangle = new Rectangle(ax, ay + drop, awidth, 64);//aheight );//awidth, aheight);
			
			var brect:Rectangle;
			
			if(graphnode) {
				//brect = new Rectangle((x*64) + 32,(y * 64) + 32, 8, 8);
				brect = new Rectangle((x*64) ,(y * 64) , 64, 64);
			}
			else {
				brect = new Rectangle((x) + 32,(y ) + 32, width, height);
			}
			var value:Boolean = arect.intersects(brect);
			
			if (value) trace ( "hit");
			
			return value;// arect.intersects(brect);
		}
		
		private function createHint():Array {
						
			var list:Array = new Array();
			var i:int = this.nodenumend;
			var j:int = 0;
			if (i != -1) list.push(i);
			if (this.nodesFromDots == null || i == -1) return list;
			while ( i != -1 && j < this.nodesFromDots.length - 1) {
				j ++;
				
				if (i > -1 && i < this.nodesFromDots.length) {
				i = this.nodesFromDots[i][AGai.NPOS_PREVIOUS];
					if (i != this.nodenumstart || true ) {
						list.push(i);
					}
					
				}
				
			}
			
			trace("--change map", list.length);
			list.reverse();
			
			this.hint_nodecounter = 1;
			this.latch_a = false;
			this.follow_enum = AGai.FOLLOW_APPROACH_TURN;
			
			return list;
		}
		
		
		
		
		public function getPixHintX():int {
			var a:int ;
			var b:int ;
			
			//return this.hint_x;
			if ( this.hint_edge_found < 0 || 
				this.hint_edge_found >= this.edgesFromDots.length ) return this.hint_last_x;
			if ( !this.edgesFromDots[this.hint_edge_found][AGai.EPOS_ISHORIZONTAL]) return 0;
			
			this.hint_last_x = this.hint_x;
			
			if (this.hint_x == 0 && this.hint_auto) {
				if (this.guyx < this.monsterx ) {
					this.hint_x = - AGai.MOVE_X;
					//trace("hint left");
				}
				else {
					this.hint_x = AGai.MOVE_X;
					//trace("hint right");
				}
			}
			//else this.hint_x = this.hint_last_x;
			
			
			return this.hint_x;
			
		}
		
		public function getPixHintY():int {
			var a:int ;
			var b:int ;
			//return this.hint_y;
			if ( this.hint_edge_found < 0 || 
				this.hint_edge_found >= this.edgesFromDots.length ) return this.hint_last_y ;
			if ( this.edgesFromDots[this.hint_edge_found][AGai.EPOS_ISHORIZONTAL]) return 0;
			
			this.hint_last_y = this.hint_y;
			
			if (this.hint_y == 0 && this.hint_auto) {
				if (this.guyy < this.monstery) {
					this.hint_y = - AGai.MOVE_Y;
					//trace("hint up");
				}
				else {
					this.hint_y = AGai.MOVE_Y;
					//trace("hint down");
				}
			}
			//else this.hint_y = this.hint_last_y;
			
			
			return this.hint_y;
			
		}
		
		public function advanceNodecounter():void {
			
			if (this.q_hint_list.length < this.hint_nodecounter + 2 ) return;
			
			var a:int = this.q_hint_list[this.hint_nodecounter + 1];
			var zero:int = this.q_hint_list[this.hint_nodecounter + 0];
			
			if (a < 0 || a >= this.q_hint_nodes.length) { 
				//this.hint_nodecounter ++;
				trace("<", a);
				return;
			}
			
			this.hint_x = 0;
			this.hint_y = 0;
			///////
			// simple follow path...
			if (this.follow_enum != AGai.FOLLOW_APPROACH_TURN_CLOSE && !this.latch_a ) {
				if (this.q_hint_nodes[zero][AGai.NPOS_COORDY] == 
					this.q_hint_nodes[a][AGai.NPOS_COORDY] 
					|| this.allow_enum == AGai.ALLOW_BOTH
					) { 
					
					if (this.q_hint_nodes[zero][AGai.NPOS_COORDX] > 
						this.q_hint_nodes[a][AGai.NPOS_COORDX]) {
						
						this.hint_x = - AGai.MOVE_X;
						this.hint_direction_enum = AGai.ENUM_HORIZONTAL_LEFT;
						trace("fourth left");
					}
					else if (this.q_hint_nodes[zero][AGai.NPOS_COORDX] < 
						this.q_hint_nodes[a][AGai.NPOS_COORDX]) {
							
						this.hint_x = AGai.MOVE_X;
						this.hint_direction_enum = AGai.ENUM_HORIZONTAL_RIGHT;
						trace("fourth right");
					}
					//this.hint_last_x = this.hint_x;
				}
				if (this.q_hint_nodes[zero][AGai.NPOS_COORDX] == 
					this.q_hint_nodes[a][AGai.NPOS_COORDX] 
					|| this.allow_enum == AGai.ALLOW_BOTH
					) { 
					
					if (this.q_hint_nodes[zero][AGai.NPOS_COORDY] > 
						this.q_hint_nodes[a][AGai.NPOS_COORDY]) {
						
						this.hint_y = - AGai.MOVE_Y;
						this.hint_direction_enum = AGai.ENUM_VERTICAL_UP;
						trace("fourth up");
					}
					else if (this.q_hint_nodes[zero][AGai.NPOS_COORDY] < 
						this.q_hint_nodes[a][AGai.NPOS_COORDY]  ) {
							
						this.hint_y = AGai.MOVE_Y;
						this.hint_direction_enum = AGai.ENUM_VERTICAL_DOWN;
						trace("fourth down");
					}
					//this.hint_last_y = this.hint_y;
				}
			}
			///////
			// stop here??
			if ( this.isHitCenter(this.q_hint_nodes[a][AGai.NPOS_COORDX], 
					this.q_hint_nodes[a][AGai.NPOS_COORDY]) 
					) {
				//this.allow_enum = AGai.ALLOW_BOTH;
				//this.follow_enum = AGai.FOLLOW_APPROACH_TURN_CLOSE;
				//this.hint_y = 0;
				//this.hint_x = 0;
				//this.hint_timer_counter = 0;
				this.latch_a = true;
				//this.latch_b = false;
				//this.latch_c = false;
				//this.hint_nodecounter ++
				trace("<== counter", this.q_hint_nodes[zero][AGai.NPOS_NODENAME],"to",
					  this.q_hint_nodes[a][AGai.NPOS_NODENAME]);
				return;// this line is crucial...?
			}
			if ( this.isHitCenter(this.q_hint_nodes[zero][AGai.NPOS_COORDX], 
					this.q_hint_nodes[zero][AGai.NPOS_COORDY]) 
					) {
				
				trace("<== zero", this.q_hint_nodes[zero][AGai.NPOS_NODENAME],"to",
					  this.q_hint_nodes[a][AGai.NPOS_NODENAME]);
				//return;// this line is crucial...?
			}
			
			////
		}
		
		public function startNewsegment():void {
			
		}
		
		////////////////////////////////////////////////////
		
		public function drawMap():void {
			//this.drawMapSquares();
			//this.drawMapEdges();//---
			//this.drawMapNodes();
			//this.drawMapMonster();
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
					
				}
			}
			
			mystage.scrollRect = new Rectangle(0,0,512, (512 * 3/4));
			this.myScreen.addChild(mystage);
			return ;
			
		}
		
		public function drawMapEdges():void {
			var  i:int,j:int,k:int,l:int,m:int, zz:int;
			
			//var baseX:int, baseY:int;//, startX, startY;
			var mystage:Sprite = new Sprite();
			
			
			var TILE_WIDTH:int = 64;
			var TILE_HEIGHT:int = 64;
			
			var tilesWidthMeasurement:int =   32;
			var tilesHeightMeasurement:int =  24;//
			
			var LONG_MAP_H:int =	this.myGame.myHoriz;
			var LONG_MAP_V:int = 	this.myGame.myVert;//	this.myVert;
			
			var xstart:int;
			var ystart:int;
			var xend:int;
			var yend:int;
		
			
			var cheat:int = TILE_WIDTH /2;

			for(i = 0; i < this.edgesFromDots.length; i ++) {
				
				if (this.edgesFromDots[i][AGai.EPOS_TEMPFLAG] == false) {
					//continue;
				}
				
				xstart  = this.edgesFromDots[i][EPOS_STARTX] * TILE_WIDTH - this.myGame.scrollBGX + cheat;
				ystart  = this.edgesFromDots[i][EPOS_STARTY] * TILE_HEIGHT - this.myGame.scrollBGY + cheat;
				xend  = this.edgesFromDots[i][EPOS_STOPX] * TILE_WIDTH - this.myGame.scrollBGX + cheat;
				yend  = this.edgesFromDots[i][EPOS_STOPY] * TILE_HEIGHT- this.myGame.scrollBGY + cheat;
				
				var shape:Shape = new Shape();
				shape.graphics.lineStyle(4,0x0000ff,1);
				shape.graphics.moveTo(xstart,ystart);
				shape.graphics.lineTo(xend,yend);
				
				mystage.addChild(shape);
			}
			
			mystage.scrollRect = new Rectangle(0,0,512, (512 * 3/4));
			this.myScreen.addChild(mystage);
			return ;
		}
		
		public function drawMapNodes():void {
			var  i:int,j:int,k:int,l:int,m:int, zz:int;
			
			//var baseX:int, baseY:int;//, startX, startY;
			var mystage:Sprite = new Sprite();
			
			
			var TILE_WIDTH:int = 64;
			var TILE_HEIGHT:int = 64;
			
			var tilesWidthMeasurement:int =   32;
			var tilesHeightMeasurement:int =  24;//
			
			var LONG_MAP_H:int =	this.myGame.myHoriz;
			var LONG_MAP_V:int = 	this.myGame.myVert;//	this.myVert;
			
			
			//var square:AGSprite;
			var xstart:int;
			var ystart:int;
			
			var cheat:int = TILE_WIDTH /2;

			for(i = 0; i < this.nodesFromDots.length; i ++) {
				xstart  = this.nodesFromDots[i][AGai.NPOS_COORDX] * TILE_WIDTH - this.myGame.scrollBGX + cheat;
				ystart  = this.nodesFromDots[i][AGai.NPOS_COORDY] * TILE_HEIGHT - this.myGame.scrollBGY + cheat;
				
				
				var shape:Shape = new Shape();
				shape.graphics.lineStyle(20,0x00ff00,1);
				shape.graphics.moveTo(xstart - 10,ystart);
				shape.graphics.lineTo(xstart + 20,ystart);
				
				mystage.addChild(shape);
			}
			
			mystage.scrollRect = new Rectangle(0,0,512, (512 * 3/4));
			this.myScreen.addChild(mystage);
			return ;
		}
		
		public function drawMapMonster():void {
			var  i:int,j:int,k:int,l:int,m:int, zz:int;
			
			var mystage:Sprite = new Sprite();
			
			var TILE_WIDTH:int = 64;
			var TILE_HEIGHT:int = 64;
			
			var tilesWidthMeasurement:int =   32;
			var tilesHeightMeasurement:int =  24;//
			
			var LONG_MAP_H:int =	this.myGame.myHoriz;
			var LONG_MAP_V:int = 	this.myGame.myVert;//	this.myVert;
			
			
			//var square:AGSprite;
			var xstart:int;
			var ystart:int;
			var xend:int;
			var yend:int;
			var shape:Shape = new Shape();

			var cheat:int = TILE_WIDTH /2;


			//trace("qlist",this.q_hint_nodes.length, this.nodenumstart,this.nodenumend);
			if (this.q_hint_list.length > 1 && this.nodenumstart != -1 && this.nodenumend != -1) {
			
				var startdrawing:int = 1;
				j = this.q_hint_list[startdrawing];
				if (j > -1 && j < this.q_hint_nodes.length && 
						this.nodenumend != -1 && this.nodenumend < this.q_hint_nodes.length) {
							
					xstart  = this.q_hint_nodes[j][AGai.NPOS_COORDX] * TILE_WIDTH - 
						this.myGame.scrollBGX + cheat;
					ystart  = this.q_hint_nodes[j][AGai.NPOS_COORDY] * TILE_HEIGHT - 
						this.myGame.scrollBGY + cheat;
						
					shape.graphics.lineStyle(4,0xff0000,1);
					shape.graphics.moveTo(xstart,ystart);
				}
				// 
				//
				for (m = startdrawing; m< this.q_hint_list.length ; m ++) {
					i = this.q_hint_list[m];
					
					if (i > -1 && i < this.q_hint_nodes.length) {
						
						xend  = this.q_hint_nodes[i][AGai.NPOS_COORDX] * TILE_WIDTH - 
							this.myGame.scrollBGX + cheat;
						yend  = this.q_hint_nodes[i][AGai.NPOS_COORDY] * TILE_HEIGHT - 
							this.myGame.scrollBGY + cheat;
					
					
						shape.graphics.lineTo(xend,yend);
					}
					
					mystage.addChild(shape);
				}

			}
			xstart  = this.startingX - this.myGame.scrollBGX + cheat;
			ystart  = this.startingY - this.myGame.scrollBGY + cheat;
			
			
			//draw green monster dot.
			shape.graphics.lineStyle(20,0x00ff00,1);
			shape.graphics.moveTo(xstart - 10,ystart);
			shape.graphics.lineTo(xstart + 20,ystart);
			
			mystage.addChild(shape);
			
			
			mystage.scrollRect = new Rectangle(0,0,512, (512 * 3/4) - 64);
			this.myScreen.addChild(mystage);
			return ;
		}
		
		
	}
	
	
}
