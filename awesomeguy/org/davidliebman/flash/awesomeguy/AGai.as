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
		
		public static var NPOS_NODENAME:int = 0;
		public static var NPOS_COORDX:int = 1;
		public static var NPOS_COORDY:int = 2;
		public static var NPOS_CALCDIST:int = 3;
		public static var NPOS_VISITED:int = 4;
		public static var NPOS_PREVIOUS:int = 5;
		public static var NPOS_TEMPFLAG:int = 6;
		
		public static var MESSAGE_START:String = "start";
		public static var MESSAGE_STOP:String = "stop";
		public static var MESSAGE_CLEAR:String = "clear";
		public static var MESSAGE_HORIZONTAL:String = "horizontal";
		public static var MESSAGE_VERTICAL:String = "vertical";

		public function AGai() {
			// constructor code
			// do nothing...
			//this.myKeyStage = mykeys;
			
			
			if (Worker.current.isPrimordial) {
				
				this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
				//this.loaderInfo.addEventListener(Event.COMPLETE, onAddedToStage);
				/*
				trace(this.loaderInfo);
				
				var swfBytes:ByteArray = this.loaderInfo.bytes;
				
				worker = WorkerDomain.current.createWorker( swfBytes );
				mainToWorker = Worker.current.createMessageChannel(worker);
				workerToMain = worker.createMessageChannel(Worker.current);
				
				worker.setSharedProperty("mainToWorker", mainToWorker);
				worker.setSharedProperty("workerToMain", workerToMain);
				
				//workerToMain.addEventListener(Event.CHANNEL_MESSAGE, onWorkerToMain);
				
				//worker.start();
				*/
			}
			else {
				this.set_values_called = false;

				mainToWorker = Worker.current.getSharedProperty("mainToWorker");
				workerToMain = Worker.current.getSharedProperty("workerToMain");
				
				mainToWorker.addEventListener("mainToWorker", onMainToWorker);
			}
			
			
		}
		
		public function onAddedToStage(e:Event):void {
				this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
				this.loaderInfo.addEventListener(Event.COMPLETE, onLoadedComplete);
		}
		
		public function onLoadedComplete(e:Event):void {
			//if (!Worker.current.isPrimordial) return;
			
			this.loaderInfo.removeEventListener(Event.COMPLETE, onLoadedComplete);
			
			trace(this.loaderInfo);
				
			var swfBytes:ByteArray = this.loaderInfo.bytes;
			
			worker = WorkerDomain.current.createWorker( swfBytes );
			
			trace(worker);
			
			//mainToWorker = Worker.current.createMessageChannel(worker);
			//workerToMain = worker.createMessageChannel(Worker.current);
			
			//worker.setSharedProperty("mainToWorker", mainToWorker);
			//worker.setSharedProperty("workerToMain", workerToMain);
			
			//workerToMain.addEventListener(Event.CHANNEL_MESSAGE, onWorkerToMain);
			
			worker.start();
		}
		
		public function onWorkerToMain(e:Event):void {
			
		}
		
		public function onMainToWorker(e:Event):void {
			
		}
		
		/* THIS IS DONE ONCE AT THE BEGINNING OF THE LEVEL */
		public function setValues(myinvisible:Array, myscreen:Stage, game:AGMode):void {
			this.set_values_called = true;
			
			myInvisible = myinvisible;
			myScreen = myscreen;
			myGame = game;
			
			this.setupGraph();
		}
		
		public function sendInvisibleMap():void {
			
		}
		
		public function setupGraph( ):void {
			//this.myInvisible = myinvisible;
			
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
							 isJump,// is jump segment??
							 0, // edge A index in node array
							 0, // edge B index in node array
							 false // is temp flag set??
							 );  
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
										START_DISTANCE, // D distance (infinity)
										false, //visited?
										-1, // previous....
										false); // is node temp flag set??
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
							 isJump, // is jump segment??
							 0, // edge A node index number
							 0, // edge B node index number
							 false // is temp flag set??
							 );  
			this.edgesFromDots.push(temp);
			
			this.makeCoordinateListingNodes(xlevel,starty);
			this.makeCoordinateListingNodes(xlevel,endy);
						
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
			/*
			if ((this.invisibleDots[y][x +1] == 1 ) 
				) {
				connections ++;
			}
			*/
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
		
		/* THIS IS DONE BEFORE EACH REDRAW OF THE SCREEN */
		public function doCalculation(mymonstertype:int, coordinateType:int ,startingX:int, startingY:int, endingX:int, endingY:int):void {
			var TILE_WIDTH:int = 64;
			var TILE_HEIGHT:int = 64;
			
			
			if (! this.set_values_called) return;
			
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
			
			var nodenumstart:int = this.getStartNodeNum(startingX, startingY, true);
			var nodenumend:int = this.getStopNodeNum(endingX, endingY, true);
			
			this.nodesFromDots[nodenumstart][AGai.NPOS_CALCDIST] = 0;
			
			var i:int = nodenumstart;
			var j:int = 0;
			var q_list:Array = new Array();
			var k:int = 0;
			var alt:int = 0;
			var edge:Array = new Array();
			
			while(! this.isListEmpty() ) {
				i = this.smallestDistanceNode();
				trace("i:",i);
				this.nodesFromDots[i][AGai.NPOS_VISITED] = true;
				
				
				if (this.nodesFromDots[i][AGai.NPOS_CALCDIST] == AGai.START_DISTANCE ||
						i == nodenumend) {
							
					this.node_index_end = i;
					this.createHint();
					return;
				}
				//
				q_list = this.getNodeNeighborList(i);
				
				if (q_list.length == 1 && 
						this.nodesFromDots[q_list[0]][AGai.NPOS_CALCDIST] == AGai.START_DISTANCE && 
						false) { // this doesn't work...
					this.node_index_end = i;
					this.createHint();
					return;
				}
				//trace("size:", q_list.length);
				for each (j in q_list) {
					trace("neighbor:",j);
					
					edge = this.getEdgeFromNodeIndeces(i,j);
					k = edge[AGai.EPOS_DIST];
					alt = k + this.nodesFromDots[i][AGai.NPOS_CALCDIST];
					
					if (alt < this.nodesFromDots[j][AGai.NPOS_CALCDIST]) {
						this.nodesFromDots[j][AGai.NPOS_CALCDIST] = alt;
						this.nodesFromDots[j][AGai.NPOS_PREVIOUS] = i;
						// heap reorder j
					}
					
				}
				trace("----");
			}
		}
		
		private function isListEmpty():Boolean {
			var value:Boolean = false;
			var i:int = 0;
			var j:int = 0;
			for (i = 0; i < this.nodesFromDots.length; i ++) {
				if (this.nodesFromDots[i][AGai.NPOS_VISITED] == true ){
					//value = true;
					j ++;
				}
			}
			if (j == this.nodesFromDots.length ) value = true;
			return value;
		}
		
		private function smallestDistanceNode():int {
			var value:int = 0;
			var i:int = 0; // for loop index
			var j:int = 0; // for loop calc-dist
			var k:int = AGai.START_DISTANCE; // lowest dist
			var l:int = 0; // value output
			
			
			
			for (i = 0; i < this.nodesFromDots.length; i ++) {
				if (!this.nodesFromDots[i][AGai.NPOS_VISITED]) {
					j = this.nodesFromDots[i][AGai.NPOS_CALCDIST];
					if (j < k) {
						k = j;
						l = i;
						trace(k);
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
						list.push(value);
						trace("edge-end", i);
					}
					else if (this.edgesFromDots[i][AGai.EPOS_NODEEND] == 
							 this.nodesFromDots[node][AGai.NPOS_NODENAME]) {
								 
						value = this.edgesFromDots[i][AGai.EPOS_NODESTARTINDEX];
						list.push(value);
						trace("edge-end",i);
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
		
		private function createHint():void {
			trace("====");
			var i:int = this.node_index_end;
			while (i != this.node_index_start && i != -1) {
				i = this.nodesFromDots[i][AGai.NPOS_PREVIOUS];
				trace(i, this.nodesFromDots[i][AGai.NPOS_NODENAME]);

			}
			trace ("done dijkstra");
		}
		
		public function getStartNodeNum(x:int, y:int, newnode:Boolean):int {
			var value:int = 0;
			this.node_index_end = 0;
			this.node_index_start = value;
			// if newnode is true, add new node if necessary
			return value;
		}
		
		public function getStopNodeNum(x:int, y:int, newnode:Boolean):int {
			// if newnode is true, add new node and edges if necessary.
			return 4;
		}
		
		public function drawMap():void {
			this.drawMapSquares();
			this.drawMapEdges();
			this.drawMapNodes();
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
			
			//var baseX:int, baseY:int;//, startX, startY;
			var mystage:Sprite = new Sprite();
			
			
			var TILE_WIDTH:int = 64;
			var TILE_HEIGHT:int = 64;
			
			var tilesWidthMeasurement:int =   32;
			var tilesHeightMeasurement:int =  24;//
			
			var LONG_MAP_H:int =	this.myGame.myHoriz;
			var LONG_MAP_V:int = 	this.myGame.myVert;//	this.myVert;
			//animate = newBG + 1;
			//var animate:int = 0;
			//var myBlocks:Array = new Array();
			
			
			//var square:AGSprite;
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
		
		public function getPixHintX():int {
			return 0;
		}
		public function getPixHintY():int {
			return 0;
		}
		
	}
	
	
}
