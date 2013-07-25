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
	
	var myStage:Stage;
	var myButtons:Array;
	var myRes:Array;
	
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
	
	
	
	var modeObj:AGMode ;
	var guy:AGModeGuy = new AGModeGuy();
	var flyer:AGModeFlyer = new AGModeFlyer();
	var paused:AGModePause = new AGModePause();
		
		public function AGGame(mystage:Stage, mybuttons:Array, myresources:Array) {
			
			myStage = mystage;
			myButtons = mybuttons;
			myRes = myresources;
			
			myStage.addEventListener(Event.ENTER_FRAME, setKeys );
			//trace ("import worked. " );
			//var getter:AGResources = new AGResources();
			flyer.setValues(myStage, myButtons, myRes, this);
			guy.setValues(myStage, myButtons, myRes, this);
			paused.setValues(myStage, myButtons, myRes, this);
			this.myModeStack.push(AGGame.MODE_START);
				
		}

		public function setKeys(e:Event) {
			setKeyValues(myButtons[AGKeys.BUTTON_LEFT].getValBool() , myButtons[AGKeys.BUTTON_RIGHT].getValBool(),
						 myButtons[AGKeys.BUTTON_UP].getValBool(), myButtons[AGKeys.BUTTON_DOWN].getValBool(), 
						 myButtons[AGKeys.BUTTON_SHOOT].getValBool(), myButtons[AGKeys.BUTTON_JUMP].getValBool(),
						 myButtons[AGKeys.BUTTON_PAUSE].getValBool() ,myButtons[AGKeys.BUTTON_ANY].getValBool());
		}

		public function setKeyValues(left:Boolean, right:Boolean, up:Boolean, down:Boolean, shoot:Boolean, jump:Boolean, bpause:Boolean, any:Boolean) {
			K_LEFT = left;
			K_RIGHT = right;
			K_UP = up;
			K_DOWN = down;
			K_JUMP = jump;
			K_SHOOT = shoot;
			K_PAUSE = bpause;
			K_ANY = any;
			doAnimation();
		}
		
		public function doAnimation() {
			var current:int = 0;
			current = this.myModeStack[this.myModeStack.length - 1];
			trace (this.myModeStack);
			switch(current) {
				case AGGame.MODE_START:
					if (K_ANY ) {
						if (gamePaused) {
							gamePaused = false;
							//this.gameMode = this.lastGameMode ;
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
							//this.gameMode = this.lastGameMode ;
							this.myModeStack.pop();
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
			
			if (gameLives == 0 ) {
				this.gameLives = 3;
				this.gameScore = 10;
				this.gamePlanet = 0;
				this.myModeStack = new Array();
				this.myModeStack.push(AGGame.MODE_START);
				this.gamePaused = true;
				//flyer = new AGModeFlyer();
				//flyer.setValues(myStage, myButtons,myRes,this);
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
