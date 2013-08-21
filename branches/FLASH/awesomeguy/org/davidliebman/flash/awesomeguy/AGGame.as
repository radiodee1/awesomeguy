package  org.davidliebman.flash.awesomeguy {
	import flash.display.Stage;
	import flash.events.Event;
	
	public class AGGame {

	var K_LEFT:Boolean = false;
	var K_RIGHT:Boolean = false;
	var K_UP:Boolean = false;
	var K_DOWN:Boolean = false;		
	var K_SHOOT:Boolean = false;
	var K_JUMP:Boolean = false;
	var K_PAUSE:Boolean = false;
	var K_ANY:Boolean = false;
	var K_RESTART:Boolean = false;
	var K_QUIET:Boolean = false;
	
	var myStage:Stage;
	var myButtons:Array;
	var myRes:Array;
	var myMazeEntrance:Array;
	
	public static var MODE_FLYER:int = 0;
	public static var MODE_GUY:int = 1;
	public static var MODE_PAUSE:int = 2;
	public static var MODE_START:int = 3;
	public var gameMode:int = MODE_START;
	public var lastGameMode:int = 0;
	public var myModeStack:Array = new Array();
	public var gamePaused:Boolean = true;
	
	public var gamePlanet:int = 0;
	public var gameMaze:int = 0;
	public var gameChallenge:int = 0;
	public var gameScore:int = 10;
	public var gameLives:int = 3;
	public var gameHealth:int = 50;
	public var gameKeys:int = 0;
	
	public var xml_text_planet_before:int = 1;
	public var xml_text_planet_after:int = 2;
	public var xml_text_maze_before:int = 3;
	public var xml_text_maze_after:int = 4;
	
	var modeObj:AGMode ;
	var guy:AGModeGuy;
	var flyer:AGModeFlyer;
	var paused:AGModePause;
		
		public function AGGame(mystage:Stage, mybuttons:Array, myresources:Array) {
			
			myStage = mystage;
			myButtons = mybuttons;
			myRes = myresources;
			
			myStage.addEventListener(Event.ENTER_FRAME, setKeys );
			//trace ("import worked. " );
			
			this.startAGGame();
		}
		
		public function startAGGame() {
			gamePaused = true;
			K_PAUSE = false;
			K_ANY = false;
			myButtons[AGKeys.BUTTON_PAUSE].setValBool(false);
			myButtons[AGKeys.BUTTON_ANY].setValBool(false);
			
			this.myMazeEntrance = new Array();
			
			guy = new AGModeGuy();
			flyer = new AGModeFlyer();
			paused = new AGModePause();
			flyer.setValues(myStage, myButtons, myRes, this);
			guy.setValues(myStage, myButtons, myRes, this);
			paused.setValues(myStage, myButtons, myRes, this);
			this.myModeStack = new Array();
			this.myModeStack.push(AGGame.MODE_START);
			
			this.gameHealth = 50;
		}

		public function setKeys(e:Event) {
			setKeyValues(myButtons[AGKeys.BUTTON_LEFT].getValBool() , myButtons[AGKeys.BUTTON_RIGHT].getValBool(),
						 myButtons[AGKeys.BUTTON_UP].getValBool(), myButtons[AGKeys.BUTTON_DOWN].getValBool(), 
						 myButtons[AGKeys.BUTTON_SHOOT].getValBool(), myButtons[AGKeys.BUTTON_JUMP].getValBool(),
						 myButtons[AGKeys.BUTTON_PAUSE].getValBool() ,myButtons[AGKeys.BUTTON_ANY].getValBool() ,
						 myButtons[AGKeys.BUTTON_RESTART].getValBool(), myButtons[AGKeys.BUTTON_QUIET].getValBool());
		}

		public function setKeyValues(left:Boolean, right:Boolean, 
									 up:Boolean, down:Boolean, 
									 shoot:Boolean, jump:Boolean, 
									 bpause:Boolean, any:Boolean,
									 restart:Boolean, quiet:Boolean) {
			K_LEFT = left;
			K_RIGHT = right;
			K_UP = up;
			K_DOWN = down;
			K_JUMP = jump;
			K_SHOOT = shoot;
			K_PAUSE = bpause;
			K_ANY = any;
			K_RESTART = restart;
			K_QUIET = quiet;
			doAnimation();
		}
		
		public function doAnimation() {
			//var current:int = 0;
			this.gameMode = this.myModeStack[this.myModeStack.length - 1];
			
			switch(this.gameMode) {
				case AGGame.MODE_START:
					if (K_ANY ) {
						if (gamePaused) {
							gamePaused = false;
							
							this.myModeStack.push(AGGame.MODE_FLYER);
						}
						K_PAUSE = false;
						K_ANY = false;
						myButtons[AGKeys.BUTTON_PAUSE].setValBool(false);
						myButtons[AGKeys.BUTTON_ANY].setValBool(false);
					}
					
				
				break;
				case AGGame.MODE_PAUSE:
					if (K_ANY ) {
						if (gamePaused) {
							gamePaused = false;
							
							this.myModeStack.pop();
							
							if (this.myModeStack[this.myModeStack.length - 1] == AGGame.MODE_FLYER){
								this.flyer.animate_return_to_planet = true;
								this.flyer.animate_enter_maze = false;
								
								this.guy.game_advance_maze = false;
								this.flyer.game_advance_maze = false;
								this.modeObj.game_advance_maze = false;
								this.paused.game_advance_maze = false;
								
							}
						}
						K_PAUSE = false;
						K_ANY = false;
						myButtons[AGKeys.BUTTON_PAUSE].setValBool(false);
						myButtons[AGKeys.BUTTON_ANY].setValBool(false);
					}
				
				
				break;
				case AGGame.MODE_GUY:
				
					
					if (K_PAUSE ) {
						
						if ( !gamePaused ) {
							gamePaused = true;
							
							this.myModeStack.push(AGGame.MODE_PAUSE);
						}
						K_PAUSE = false;
						K_ANY = false;
						myButtons[AGKeys.BUTTON_PAUSE].setValBool(false);
						myButtons[AGKeys.BUTTON_ANY].setValBool(false);
					}
				
				break;
				case AGGame.MODE_FLYER:
					
					
					
					if (K_PAUSE ) {
						
						if ( !gamePaused ) {
							gamePaused = true;
							
							this.myModeStack.push(AGGame.MODE_PAUSE);
						}
						K_PAUSE = false;
						K_ANY = false;
						myButtons[AGKeys.BUTTON_PAUSE].setValBool(false);
						myButtons[AGKeys.BUTTON_ANY].setValBool(false);
					}
				break;
			}
			
			// SPECIAL CONDITIONS HERE!!
			this.gameMode = this.myModeStack[ this.myModeStack.length - 1];

			if(this.modeObj != null && 
			   this.flyer.game_advance_maze && this.gameMode == AGGame.MODE_FLYER) {
				// switch to maze from planet...
				this.myModeStack.push(AGGame.MODE_GUY);
				this.guy = new AGModeGuy();
				this.guy.setValues(this.myStage, this.myButtons, this.myRes, this);
				//this.myModeStack.push(AGGame.MODE_PAUSE);// just for testing!!
				//gamePaused = true; // just for testing!!
				
				//this.modeObj.game_advance_maze = false;
				this.guy.game_advance_maze = false;
				this.flyer.game_advance_maze = false;
				this.modeObj.game_advance_maze = false;
				this.paused.game_advance_maze = false;
			}
			
			if(this.modeObj != null && 
			   this.guy.animate_return_to_planet && this.gameMode == AGGame.MODE_GUY) {
				// switch to maze from planet...
				this.myModeStack.pop();
				
				this.flyer.animate_return_to_planet = true;
				//this.flyer.animate_enter_maze = false;
								
				//this.guy.setValues(this.myStage, this.myButtons, this.myRes, this);
				//this.myModeStack.push(AGGame.MODE_PAUSE);// just for testing!!
				//gamePaused = true; // just for testing!!
				
				//this.modeObj.game_advance_maze = false;
				this.guy.game_advance_maze = false;
				this.flyer.game_advance_maze = false;
				this.modeObj.game_advance_maze = false;
				this.paused.game_advance_maze = false;
			}
			
			if (K_RESTART) {
				this.myButtons[AGKeys.BUTTON_RESTART].setValBool(false);
				this.startAGGame();
			}
			
			if (gameLives == 0 ) {
				this.gameLives = 3;
				this.gameScore = 10;
				this.gamePlanet = 0;
				this.myModeStack = new Array();
				this.myModeStack.push(AGGame.MODE_START);
				this.gamePaused = true;
				
				
			}
			
			// SWITCH MODE??!!
			
			this.gameMode = this.myModeStack[ this.myModeStack.length - 1];
			
			if (gameMode == MODE_FLYER) {
				modeObj = flyer;
				
			}
			else if (gameMode == MODE_GUY) {
				modeObj = guy;
				
			}
			else if (gameMode == MODE_PAUSE) {
				modeObj = paused;
			}
			else if (gameMode == MODE_START) {
				modeObj = paused;
			}
			
			
			modeObj.innerGameLoop();
		}
	}
	
}
