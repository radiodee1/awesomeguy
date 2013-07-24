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
	public var gameMode:int = 2;
	public var lastGameMode:int = 0;
	public var myModeStack:Array = new Array(MODE_FLYER);
	
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

				this.myModeStack.push(AGGame.MODE_PAUSE);
				
			if (gameMode == MODE_FLYER) {
				//modeObj = flyer;
				modeObj = flyer;
			}
			else if (gameMode == MODE_GUY) {
				//modeObj = guy;
				modeObj = guy;
			}
			else if (gameMode == MODE_PAUSE) {
				//modeObj = paused;
				modeObj = paused;
			}
			
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
			
			//modeObj.innerGameLoop();
			//trace ("down " + K_DOWN);
			if (gameMode == MODE_FLYER) {
				modeObj = flyer;
				//flyer.innerGameLoop();
			}
			else if (gameMode == MODE_GUY) {
				modeObj = guy;
				//guy.innerGameLoop();
			}
			else if (gameMode == MODE_PAUSE) {
				modeObj = paused;
			}
			modeObj.innerGameLoop();
		}
	}
	
}
