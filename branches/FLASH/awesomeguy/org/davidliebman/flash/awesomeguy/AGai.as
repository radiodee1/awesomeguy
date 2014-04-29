package org.davidliebman.flash.awesomeguy {
	import flash.display.Stage;
	
	
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
					if (i < this.myInvisible.length -1 && this.myInvisible[i+1][j] == AGModeGuy.B_BLOCK) {
						if (i > 0  && this.myInvisible[i][j] == 0 && this.myInvisible[i-1][j] == 0) {
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
			
		}
		
		public function getPixHintX():int {
			return 0;
		}
		public function getPixHintY():int {
			return 0;
		}
		
	}
	
}
