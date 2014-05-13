package org.davidliebman.flash.awesomeguy {
	import flash.display.Stage;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import flash.display.Shape;
	import flash.system.MessageChannel;
	import flash.system.Worker;
	import flash.system.WorkerDomain;
	import flash.events.Event;
	import flash.utils.ByteArray;
	
	/* THIS AI IS REALLY ONLY FOR MAZE LEVELS */
	public class AGai  extends Sprite{
		
		public var mainToWorker:MessageChannel;
		public var workerToMain:MessageChannel;
		public var worker:Worker;
		
		public var myInvisible:Array;
		public var myScreen:Stage;
		public var myGame:AGMode;
		public var myKeyStage:AGKeys;

		public var invisibleDots:Array;
		public var invisibleChutes:Array;
		public var edgesFromDots:Array;
		public var nodesFromDots:Array;
		
		public var monsterx:int;
		public var monstery:int;
		
		public var guyx:int;
		public var guyy:int;

		public var hint_x:int = 0;
		public var hint_y:int = 0;
		
		public static var MOVE_X:int = 3;
		public static var MOVE_Y:int = 3;
		
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
		
		public static var NPOS_NODENAME:int = 0;
		public static var NPOS_COORDX:int = 1;
		public static var NPOS_COORDY:int = 2;
		public static var NPOS_CALCDIST:int = 3;
		public static var NPOS_VISITED:int = 4;
		public static var NPOS_PREVIOUS:int = 5;
		public static var NPOS_TEMPFLAG:int = 6;
		
		// MAYBE FOR PASSING MESSAGES TO A THREADED VERSION OF ai
		public static var MESSAGE_START:String = "start";
		public static var MESSAGE_STOP:String = "stop";
		public static var MESSAGE_CLEAR:String = "clear";
		public static var MESSAGE_HORIZONTAL:String = "horizontal";
		public static var MESSAGE_VERTICAL:String = "vertical";

		public var alg_state:int = -1;
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
		public static var ALG_NON_DIJKSTRA:int = 20;
		
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

		// ACTUAL SCREEN COORDINATES
		public var startingX:int = 0;
		public var startingY:int = 0;
		public var endingX:int = 0;
		public var endingY:int = 0;

		public var nodenumstart:int = 0;//
		public var nodenumend:int = 0;//
		public var TILE_WIDTH:int = 64;
		public var TILE_HEIGHT:int = 64;

		public function AGai() {
			// constructor code
			// do nothing...
			
			/*
			if (Worker.current.isPrimordial) {
				
				this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
				
			}
			else {
				this.set_values_called = false;

				mainToWorker = Worker.current.getSharedProperty("mainToWorker");
				workerToMain = Worker.current.getSharedProperty("workerToMain");
				
				mainToWorker.addEventListener("mainToWorker", onMainToWorker);
			}
			*/
			
		}
		
		public function onAddedToStage(e:Event):void {
				this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
				this.loaderInfo.addEventListener(Event.COMPLETE, onLoadedComplete);
		}
		
		public function onLoadedComplete(e:Event):void {
			
			this.loaderInfo.removeEventListener(Event.COMPLETE, onLoadedComplete);
			
			trace(this.loaderInfo);
				
			var swfBytes:ByteArray = this.loaderInfo.bytes;
			
			worker = WorkerDomain.current.createWorker( swfBytes );
			
			trace(worker);
			
			mainToWorker = Worker.current.createMessageChannel(worker);
			workerToMain = worker.createMessageChannel(Worker.current);
			
			worker.setSharedProperty("mainToWorker", mainToWorker);
			worker.setSharedProperty("workerToMain", workerToMain);
			
			workerToMain.addEventListener(Event.CHANNEL_MESSAGE, onWorkerToMain);
			
			worker.start();
		}
		
		public function onWorkerToMain(e:Event):void {
			
		}
		
		public function onMainToWorker(e:Event):void {
			
		}
		
		public function sendInvisibleMap():void {
			
		}
		
		/* THIS IS DONE ONCE AT THE BEGINNING OF THE LEVEL */
		public function setValues(myinvisible:Array, myscreen:Stage, game:AGMode):void {
			this.set_values_called = true;
			
			myInvisible = myinvisible;
			myScreen = myscreen;
			myGame = game;
			
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
						
						
						if((this.isEndNodeBasic(k,i, this.invisibleDots) || this.isEndNodeHoriz(k,i)) && 
						   this.myInvisible[i][k] != AGModeGuy.B_LADDER){
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
			var edgenamestart:String = new String() ;
			var edgenameend:String  = new String();
			
			
			for (i = 0; i < this.nodesFromDots.length; i ++) {
				for (j = 0; j < this.edgesFromDots.length; j ++) {
					
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
							 true // is-horizontal??
							 );  
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
							 false // is-horizontal??
							 );  
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

			// put nodes in list... NO REPEATS
			for (i = 0; i < this.nodesFromDots.length; i ++) {
				if (nodename == this.nodesFromDots[i][NPOS_NODENAME]) {
					listed = true;
					listed_index = i;
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
		
		public function isEndNodeHoriz(x:int, y:int):Boolean {
			var value:Boolean = true;
			var connections:int = 0;
			if (y == 0 || y == this.invisibleDots.length || 
				x == 0 || x == this.invisibleDots[0].length) return true;
				
			// what to do if next to a chute
			if ((this.invisibleDots[y][x] == 1 && 
				this.invisibleDots[y][x+ 1] == 0 &&
				this.invisibleChutes[y][x+ 1] != 1 ) //||
				 //this.myInvisible[y+1][x] == AGModeGuy.B_LADDER
				) {
				connections ++;
			}
			if ((this.invisibleDots[y][x] == 1 && 
				this.invisibleDots[y][x - 1] == 0 &&
				this.invisibleChutes[y][x -1] != 1) //||
				 //this.myInvisible[y+1][x] == AGModeGuy.B_LADDER
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
		
		public function setStartEnd(startX:int, startY:int, endX:int, endY:int):void {
			
			
			this.startingX = startX; // monster
			this.startingY = startY;
			this.endingX = endX; // guy
			this.endingY = endY;
			
			
			//this.alg_state = AGai.ALG_ZERO;
		}
		
		/* THIS IS DONE BEFORE EACH REDRAW OF THE SCREEN */
		
		public function doCalc() {
			
			this.alg_count ++;
			if (this.alg_count > AGai.COUNT_ALG) { //1200
				this.alg_count = 0;
				this.alg_state = AGai.ALG_ZERO;
			}
			
			var i:int = 0;
			var found:int = -1;
			var pair1:Array;
			var pair2:Array;
			var tempArray:Array = new Array();
			var j:int = 0;
			//trace("S:" + this.nodenumstart, "E:"+ this.nodenumend);
			//trace(this.q_startedge_hor, this.q_startedge_vert, this.q_endedge_hor, this.q_endedge_vert);
			
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
					
					this.guyx = this.endingX;
					this.guyy = this.endingY;
			
					this.monsterx = this.startingX;
					this.monstery = this.startingY;
					
					trace("monster and guy");
					this.alg_state ++;
				break;
				case AGai.ALG_REMOVE_TEMP_A:
					for (i = 0; i < this.edgesFromDots.length; i ++) {
						
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
						trace(1,"pair1", pair1, "pair2", pair2);
						
						if (pair1[0] == pair2[0]) {
							found = pair1[0];
						}
						else {
							found = pair1[1];
						}
					}
					
					this.nodenumstart = found;
					trace("start node",this.nodenumstart);
					this.alg_state ++;
				break;
				case AGai.ALG_MAKE_NODES_AND_EDGES_START_VERTICAL:
					found = -1;
					if (this.q_startedge_vert != -1 && this.q_startedge_hor == -1) {
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
						trace(2,"pair1", pair1, "pair2", pair2);

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
					trace("start node", this.nodenumstart);
					this.alg_state ++;
					
				break;
				
				case AGai.ALG_MAKE_NODES_AND_EDGES_END_HORIZONTAL:
					found = -1;
					if (this.q_endedge_hor != -1) {
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
						trace(3,"pair1", pair1, "pair2", pair2);

						if (pair1[0] == pair2[0]) {
							found = pair1[0];
						}
						else {
							found = pair1[1];
						}
					}
					this.nodenumend = found;
					trace("end node", this.nodenumend);
					this.alg_state ++;
				
				break;
				case AGai.ALG_MAKE_NODES_AND_EDGES_END_VERTICAL:
					found = -1;
					if (this.q_endedge_vert != -1 ){//&& this.q_endedge_hor == -1) {
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
						trace(4,"pair1", pair1, "pair2", pair2);

						if (pair1[0] == pair2[0]) {
							found = pair1[0];
						}
						else {
							found = pair1[1];
						}
					}
					if (this.q_endedge_hor == -1 && found != -1) {
						this.nodenumend = found;
					}
					trace("end node", this.nodenumend);
					this.alg_state ++;
				break;
				case AGai.ALG_FIRST_HINT:
					if (this.q_endedge_hor != -1) {
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
					this.alg_state ++;
				break;
				case AGai.ALG_START_DIJKSTRA:
					this.node_index_end = -1;
					
					if (this.nodenumstart >= this.nodesFromDots.length ||
						this.nodenumstart == -1) {
						//this.nodenumstart = 0; // this doesn't make sense!!
						return;
					}
					
					this.nodesFromDots[nodenumstart][AGai.NPOS_CALCDIST] = 0;
					
					q_i = nodenumstart;
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
					trace("i:",q_i, "node start", this.nodenumstart );
					this.nodesFromDots[q_i][AGai.NPOS_VISITED] = true;
				
					if (q_i == this.nodenumend ) {
							
						this.node_index_end = q_i;
						//this.createHint();
						//this.q_hint = true;
						this.alg_state = AGai.ALG_SECOND_HINT_A;
						break;
						//return;
					}
					this.alg_state ++;
				break;
				
				case AGai.ALG_DIJKSTRA_LOOP_B:
					q_list = this.getNodeNeighborList(q_i);
					
					this.q_list_index = 0;
					this.alg_state ++;
				break;
				
				case AGai.ALG_DIJKSTRA_LOOP_NEIGHBOR_LIST_A:
					//
					this.q_j = this.q_list[this.q_list_index];
					if (this.q_list.length > 0) {
						trace(this.nodesFromDots[this.q_i][AGai.NPOS_NODENAME],
							  "neighbor:",q_j, this.nodesFromDots[this.q_j][AGai.NPOS_NODENAME]);
					}
					else trace("skipping");
					
					q_edge = this.getEdgeFromNodeIndeces(q_i,q_j);
					//trace(this.q_j);
					this.alg_state ++;
				break;
				
				case AGai.ALG_DIJKSTRA_LOOP_NEIGHBOR_LIST_B:
					q_k = q_edge[AGai.EPOS_DIST];
					q_alt = q_k + this.nodesFromDots[q_i][AGai.NPOS_CALCDIST];
					
					if (q_alt < this.nodesFromDots[q_j][AGai.NPOS_CALCDIST] && this.q_list.length > 0) {
						this.nodesFromDots[q_j][AGai.NPOS_CALCDIST] = q_alt;
						this.nodesFromDots[q_j][AGai.NPOS_PREVIOUS] = q_i;
						// heap reorder j
					}
					
					if (this.q_list_index < this.q_list.length -1) {
						this.q_list_index ++;
						this.alg_state = AGai.ALG_DIJKSTRA_LOOP_NEIGHBOR_LIST_A;
						break;
					}
					else {
						this.alg_state ++;
					}
				break;
				
				case AGai.ALG_DIJKSTRA_LOOP_CLOSE:
					trace("----");
					if (!this.isListEmpty()) {
						
						this.alg_state = AGai.ALG_DIJKSTRA_LOOP_A;
					}
					else {
						if (this.node_index_end == -1) {
							// what to do if no path??
							trace("====");
							trace("no path");
							//this.alg_state ++;// skip second hint!!
							this.alg_state = AGai.ALG_ZERO;
							break;
						}
						
						this.alg_state ++;
					}
				break;
				case AGai.ALG_SECOND_HINT_A:
					// set REAL hint
					trace("second hint");
					this.q_hint_list = this.createHint();
					
					this.alg_state ++;
				break;
				
				case AGai.ALG_SECOND_HINT_B:
					this.q_hint_nodes = new Array();
					for(i = 0; i < this.nodesFromDots.length; i ++) {
						tempArray = new Array();
						for (j = 0; j < this.nodesFromDots[i].length; j ++) {
							tempArray.push(this.nodesFromDots[i][j]);
						}
						this.q_hint_nodes.push(tempArray);
					}
				
					this.alg_state = AGai.ALG_ZERO;
				break;
				
				case AGai.ALG_NON_DIJKSTRA:
				
				break;
				
				
				default:
					//what to do here?
					this.alg_state = AGai.ALG_ZERO;
				break;
			}
		}
		
		
		public function doCalculation(mymonstertype:int, coordinateType:int ,startingX:int, startingY:int, endingX:int, endingY:int):void {
			
			if (! this.set_values_called || this.myInvisible.length == 0 ||
				this.edgesFromDots.length == 0 || this.nodesFromDots.length == 0) return;
			
			switch (coordinateType) {
				case AGai.COORDINATES_PIXELS:
				
				break;
				case AGai.COORDINATES_BLOCKS:
					startingX = startingX * TILE_WIDTH;
					startingY = startingY * TILE_HEIGHT;
					endingX = endingX * TILE_WIDTH;
					endingY = endingY * TILE_HEIGHT;
					
				break;
			}
			var i:int = 0;

			
			
			
			///////////////////////////
			
			this.node_index_end = -1;
			
			
			
			//nodenumstart = this.getStartNodeNum(startingX, startingY, true);
			//nodenumend = this.getStopNodeNum(endingX, endingY, true);
			
			if (this.nodenumstart >= this.nodesFromDots.length) {
				//this.nodenumstart = 0; // this doesn't make sense!!
				return;
			}
			
			this.nodesFromDots[nodenumstart][AGai.NPOS_CALCDIST] = 0;
			
			q_i = nodenumstart;
			q_j = 0;
			q_list = new Array();
			q_k = 0;
			q_alt = 0;
			q_edge = new Array();
			
			while(! this.isListEmpty() ) {
				q_i = this.smallestDistanceNode();
				trace("i:",q_i);
				this.nodesFromDots[q_i][AGai.NPOS_VISITED] = true;
				
				
				if (q_i == this.nodenumend ) {
							
					this.node_index_end = q_i;
					this.createHint();
					return;
				}
				//
				q_list = this.getNodeNeighborList(q_i);
				
				
				//trace("size:", q_list.length);
				for each (q_j in q_list) {
					trace("neighbor:",q_j);
					
					q_edge = this.getEdgeFromNodeIndeces(q_i,q_j);
					q_k = q_edge[AGai.EPOS_DIST];
					q_alt = q_k + this.nodesFromDots[q_i][AGai.NPOS_CALCDIST];
					
					if (q_alt < this.nodesFromDots[q_j][AGai.NPOS_CALCDIST]) {
						this.nodesFromDots[q_j][AGai.NPOS_CALCDIST] = q_alt;
						this.nodesFromDots[q_j][AGai.NPOS_PREVIOUS] = q_i;
						// heap reorder j
					}
					
				}
				trace("----");
			}
			if (this.node_index_end == -1) {
				trace("no path");
			}
		}
		
		private function isListEmpty():Boolean {
			var value:Boolean = true;
			var i:int = 0;
			
			for (i = 0; i < this.nodesFromDots.length; i ++) {
				if (this.nodesFromDots[i][AGai.NPOS_VISITED] == false ){
					value = false;
					
				}
			}
			
			return value;
		}
		
		private function smallestDistanceNode():int {
			var value:int = 0;
			var i:int = 0; // for loop index
			var j:int = 0; // for loop calc-dist
			var k:int = AGai.START_DISTANCE; // lowest dist
			var l:int = 0;// this.nodenumstart; // value output
			
			var default_l:int = -1;
			
			for (i = 0; i < this.nodesFromDots.length; i ++) {
				if (!this.nodesFromDots[i][AGai.NPOS_VISITED]) {
					if (default_l == -1) { 
						default_l = i;
						l = i;
					}
					j = this.nodesFromDots[i][AGai.NPOS_CALCDIST];
					if (j < k) {
						k = j;
						l = i;
						//trace(k);
					}
				}
			}
			
			
			value = l;
			return value;
		}
		
		
		private function getNodeNeighborList(node:int):Array {
			var value:int = node;
			var list:Array = new Array();
			var i:int = 0;
			var j:int = 0;
			for (i = 0; i < this.edgesFromDots.length; i ++) {
				if ( !this.edgesFromDots[i][AGai.EPOS_ISJUMP] || 
					this.edgesFromDots[i][AGai.EPOS_TOPY] >= this.monstery ){
						
					if (this.edgesFromDots[i][AGai.EPOS_NODESTART] == 
						this.nodesFromDots[node][AGai.NPOS_NODENAME]) {
						
						value = this.edgesFromDots[i][AGai.EPOS_NODEENDINDEX];
						
						if (this.nodesFromDots[value][AGai.NPOS_VISITED] == false) {
							list.push(value);
						}
						
						
					}
					else if (this.edgesFromDots[i][AGai.EPOS_NODEEND] == 
							 this.nodesFromDots[node][AGai.NPOS_NODENAME]) {
								 
						value = this.edgesFromDots[i][AGai.EPOS_NODESTARTINDEX];
						if (this.nodesFromDots[value][AGai.NPOS_VISITED] == false) {
							list.push(value);
						}
						
					}
					
				}
				
			}
			return list;
		}
		
		private function getEdgeFromNodeIndeces(nodeenda:int, nodeendb:int):Array {
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
			var j:int;
			var value:Array = new Array();
			for(i = 0; i < this.edgesFromDots.length; i ++){
				if (this.edgesFromDots[i][AGai.EPOS_EDGENAME] == ab_name) {
					j = i;
				}
				else if(this.edgesFromDots[i][AGai.EPOS_EDGENAME] == ba_name) {
					j = i;
				}
			}
			value = this.edgesFromDots[j];
			return value;
		}
		
		private function createHint():Array {
			if (this.node_index_end == -1 || this.node_index_start == -1 ||
				this.nodesFromDots.length < this.node_index_end) return new Array();
				
			trace("====");
			
			var list:Array = new Array();
			var i:int = this.node_index_end;
			list.push(i);
			trace(i, this.nodesFromDots[i][AGai.NPOS_NODENAME]);
			while (i != this.node_index_start && i != -1 && i < this.nodesFromDots.length) {
				i = this.nodesFromDots[i][AGai.NPOS_PREVIOUS];
				if (i > -1) {
					list.push(i);
					trace(i, this.nodesFromDots[i][AGai.NPOS_NODENAME]);
				}
				else trace(i);
			}
			trace ("done dijkstra");
			return list;
		}
		
		public function getStartNodeNum(x:int, y:int, newnode:Boolean):int {
			var value:int = 0;
			//this.node_index_end = 0;
			this.node_index_start = value;
			// if newnode is true, add new node if necessary
			return value;
		}
		
		public function getStopNodeNum(x:int, y:int, newnode:Boolean):int {
			// if newnode is true, add new node and edges if necessary.
			return 5;
		}
		
		public function getPixHintX():int {
			return this.hint_x;
		}
		public function getPixHintY():int {
			return this.hint_y;
		}
		
		////////////////////////////////////////////////////
		
		public function drawMap():void {
			//this.drawMapSquares();
			//this.drawMapEdges();
			//this.drawMapNodes();
			this.drawMapMonster();
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
				xstart  = this.edgesFromDots[i][EPOS_STARTX] * TILE_WIDTH - this.myGame.scrollBGX + cheat;
				ystart  = this.edgesFromDots[i][EPOS_STARTY] * TILE_HEIGHT - this.myGame.scrollBGY + cheat;
				xend  = this.edgesFromDots[i][EPOS_STOPX] * TILE_WIDTH - this.myGame.scrollBGX + cheat;
				yend  = this.edgesFromDots[i][EPOS_STOPY] * TILE_HEIGHT- this.myGame.scrollBGY + cheat;
				
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
			if (this.q_hint_list.length > 0 && this.nodenumstart != -1 && this.nodenumend != -1) {
			
				
				j = this.q_hint_list[0];
				if (j > -1 && j < this.q_hint_nodes.length) {
					xstart  = this.q_hint_nodes[this.nodenumend][AGai.NPOS_COORDX] * TILE_WIDTH - 
						this.myGame.scrollBGX + cheat;
					ystart  = this.q_hint_nodes[this.nodenumend][AGai.NPOS_COORDY] * TILE_HEIGHT - 
						this.myGame.scrollBGY + cheat;
						
					shape.graphics.lineStyle(4,0xff0000,1);
					shape.graphics.moveTo(xstart,ystart);
				}
				//
				for each (i in this.q_hint_list) {
					if (i > 0 && i < this.q_hint_nodes.length) {
						
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
			
			
			//var shape:Shape = new Shape();
			shape.graphics.lineStyle(20,0x00ff00,1);
			shape.graphics.moveTo(xstart - 10,ystart);
			shape.graphics.lineTo(xstart + 20,ystart);
			
			mystage.addChild(shape);
			
			
			mystage.scrollRect = new Rectangle(0,0,512, (512 * 3/4));
			this.myScreen.addChild(mystage);
			return ;
		}
		
		
	}
	
	
}
