package  org.davidliebman.flash.awesomeguy {
	import flash.display.Stage;
	import flash.events.Event;
	import flash.xml.XMLDocument;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
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
	var K_CONTROLS:Boolean = false;
	
	var myStage:Stage;
	var myKeys:Array;
	var myRes:Array;
	var myMazeEntrance:Array;
	var myKeyStage:AGKeys;
	
	public static var MAGIC_NUMBER_PLANETS:int = 2;
	
	public static var MODE_FLYER:int = 0;
	public static var MODE_GUY:int = 1;
	public static var MODE_PAUSE:int = 2;
	public static var MODE_START:int = 3;
	public static var MODE_CONTROLS:int = 4;
	
	public var gameMode:int = MODE_START;
	public var lastGameMode:int = 0;
	public var myModeStack:Array = new Array();
	public var gamePaused:Boolean = true;
	public var load_after_start:Boolean = false;
	
	public var gamePlanet:int = 0;
	public var gamePlanetTot:int = 0;
	public var gameMaze:int = 0;
	public var gameChallenge:int = 0;
	public var gameScore:int = 10;
	public var gameLives:int = 3;
	public var gameHealth:int = 50;
	public var gameKeys:int = 0;
	public var gameXML:XMLDocument = null;
	
	public var uloader:URLLoader = new URLLoader();
	
	public var xml_text_planet_before:int = 1;
	public var xml_text_planet_after:int = 2;
	public var xml_text_maze_before:int = 3;
	public var xml_text_maze_after:int = 4;
	
	var modeObj:AGMode ;
	var guy:AGModeGuy;
	var flyer:AGModeFlyer;
	var paused:AGModePause;
	var controls:AGModeControls;
		
		public function AGGame(mystage:Stage, mykeystage:AGKeys, mykeys:Array, myresources:Array) {
			
			myStage = mystage;
			myKeys = mykeys;
			myRes = myresources;
			myKeyStage = mykeystage;
			
			//myStage.addEventListener(Event.ENTER_FRAME, setKeys );
			//loadXML();
			
			controls = new AGModeControls();
			controls.setValues(myStage,myKeys,myRes,this);
			
			//var myXml:XMLDocument = new XMLDocument(myRes[AGResources.NAME_AWESOMEGUY_XML]);
			//var tree:XML = new XML(myXml);
			//this.gamePlanetTot = int(tree.planet.length());
			
			this.gamePlanetTot = AGGame.MAGIC_NUMBER_PLANETS;
			
			this.loadXML();
			//this.startAGGame();
		}
		
		public function startAGGame() {
			gamePaused = true;
			K_PAUSE = false;
			K_ANY = false;
			
			
			myKeys[myKeyStage.keycodePause].setValBool(false);
			myKeys[myKeyStage.keycodeAny].setValBool(false);
			this.myMazeEntrance = new Array();
			
			guy = new AGModeGuy();
			flyer = new AGModeFlyer();
			paused = new AGModePause();


			flyer.setValues(myStage, myKeys, myRes, this);
			guy.setValues(myStage, myKeys, myRes, this);
			paused.setValues(myStage, myKeys, myRes, this);

			if (! this.load_after_start) {
				this.myModeStack = new Array();
				this.myModeStack.push(AGGame.MODE_START);
			
				this.gameHealth = 50;
				this.gameLives = 3;
				this.gameScore = 10;
				this.gameHealth = 50;
				this.gamePlanet = 0;
				this.gameKeys = 0;
				//this.myModeStack = new Array();
				
				this.gamePaused = true;
			}
			else {
				this.modeObj = flyer;
				this.myModeStack = new Array();
				this.myModeStack.push(AGGame.MODE_START);
				this.myModeStack.push(AGGame.MODE_FLYER);
				this.gamePaused = false;
			}
			this.load_after_start = false;
		}
		
		public function loadXML(after_start:Boolean = false):void {
			
			load_after_start = after_start;
			myStage.removeEventListener(Event.ENTER_FRAME, setKeys);
			
			
			var path:String = new String("xml/0");
			var number:String = new String(this.gamePlanet.toString());
			var name:String = new String("awesomeguy.xml");
			var title_s:String = path + number + name;
			
			// form title string here:
			uloader.addEventListener(Event.COMPLETE, finishLoadXML);
			trace(title_s);
			uloader.load( new URLRequest(title_s));
		}
		
		public function finishLoadXML(e:Event):void {
			// finish loading xml:
			
			var xml_doc:XMLDocument = new XMLDocument();
			xml_doc.ignoreWhite = true;
			xml_doc.parseXML(e.target.data);
			//myRes[AGResources.NAME_AWESOMEGUY_XML] = xml_doc;
			this.gameXML = xml_doc;
			// last thing here:
			
			myStage.addEventListener(Event.ENTER_FRAME, setKeys );
			
			this.startAGGame();
			
			//trace("xml");
			
		}

		public function setKeys(e:Event) {
			
			setKeyValues(myKeys[myKeyStage.keycodeLeft].getValBool(),myKeys[myKeyStage.keycodeRight].getValBool(),
						 myKeys[myKeyStage.keycodeUp].getValBool(),myKeys[myKeyStage.keycodeDown].getValBool(),
						 myKeys[myKeyStage.keycodeShoot].getValBool(),myKeys[myKeyStage.keycodeJump].getValBool(),
						 myKeys[myKeyStage.keycodePause].getValBool(),myKeys[myKeyStage.keycodeAny].getValBool(),
						 myKeys[myKeyStage.keycodeRestart].getValBool(),myKeys[myKeyStage.keycodeQuiet].getValBool());
			
			
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

			K_CONTROLS = myKeys[myKeyStage.keycodeControls].getValBool();

			doAnimation();
		}
		
		public function doAnimation() {
			//var current:int = 0;
			this.gameMode = this.myModeStack[this.myModeStack.length - 1];
			
			switch(this.gameMode) {
				case AGGame.MODE_START:
				
					//controls = new AGModeControls();
					//controls.setValues(myStage,myKeys,myRes,this);
					
					 if (K_CONTROLS  ) {
						this.myModeStack.push(AGGame.MODE_CONTROLS);
						
						
						
						K_CONTROLS = false;
						myKeys[myKeyStage.keycodeControls].setValBool(false);
						myKeys[myKeyStage.keycodeAny].setValBool(false);
						gamePaused = true;
					}
					
					else if (!K_CONTROLS && K_ANY ) {
						if (gamePaused) {
							gamePaused = false;
							
							this.myModeStack.push(AGGame.MODE_FLYER);
							//this.loadXML();
						}
						K_PAUSE = false;
						K_ANY = false;
						
						
						myKeys[myKeyStage.keycodePause].setValBool(false);
						myKeys[myKeyStage.keycodeAny].setValBool(false);
					}
					
					
					
				
				break;
				case AGGame.MODE_PAUSE:
					
					//controls = new AGModeControls();
					//controls.setValues(myStage,myKeys,myRes,this);
					
					if (K_CONTROLS  ) {
						
						
						
						this.myModeStack.push(AGGame.MODE_CONTROLS);
						
						K_CONTROLS = false;
						myKeys[myKeyStage.keycodeControls].setValBool(false);
						myKeys[myKeyStage.keycodeAny].setValBool(false);
						gamePaused = true;
					}
				
					else if (K_ANY && !K_CONTROLS ) {
						if (gamePaused) {
							gamePaused = false;
							
							this.myModeStack.pop();
							
							if (this.myModeStack[this.myModeStack.length - 1] == AGGame.MODE_FLYER){
								
								this.guy.game_advance_maze = false;
								this.flyer.game_advance_maze = false;
								this.modeObj.game_advance_maze = false;
								this.paused.game_advance_maze = false;
								//this.loadXML();
							}
						}
						K_PAUSE = false;
						K_ANY = false;
						
						
						
						myKeys[myKeyStage.keycodePause].setValBool(false);
						myKeys[myKeyStage.keycodeAny].setValBool(false);
						
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
						
						
						myKeys[myKeyStage.keycodePause].setValBool(false);
						myKeys[myKeyStage.keycodeAny].setValBool(false);
						
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
						
						
						myKeys[myKeyStage.keycodePause].setValBool(false);
						myKeys[myKeyStage.keycodeAny].setValBool(false);
					}
				break;
				case AGGame.MODE_CONTROLS:
					if (K_CONTROLS  ) {
						
						this.myModeStack.pop();
						
						var gmode:int = this.myModeStack[this.myModeStack.length - 1];
						if (gmode == AGGame.MODE_START || gmode == AGGame.MODE_PAUSE ){
							
							
							var choice:int = int (this.controls.myTextBox.text) -1;
							if (choice == -1) choice = 1;
							//this.gamePlanet = (this.gamePlanet)% this.flyer.planets;
							this.gamePlanet = (choice) % this.gamePlanetTot;
							
							this.myMazeEntrance = new Array();
							flyer = new AGModeFlyer();
							
							this.flyer.setValues(myStage,myKeys,myRes,this);
							this.flyer.doOnce();
							
							
							
						}
						
						K_CONTROLS = false;
						K_ANY = false;
						
						
						
						myKeys[myKeyStage.keycodeControls].setValBool(false);
						myKeys[myKeyStage.keycodeAny].setValBool(false);
						
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
				this.guy.setValues(this.myStage, myKeys, this.myRes, this);
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
			
			if(this.modeObj != null && 
			   this.guy.game_advance_maze && this.gameMode == AGGame.MODE_GUY) {
				// switch to new maze from old maze...
				//this.myModeStack.push(AGGame.MODE_GUY);
				this.guy = new AGModeGuy();
				this.guy.setValues(this.myStage, myKeys, this.myRes, this);
				//this.myModeStack.push(AGGame.MODE_PAUSE);// just for testing!!
				//gamePaused = true; // just for testing!!
				//this.guy.game_reset_start = true;
				//
				this.guy.game_advance_maze = false;
				this.flyer.game_advance_maze = false;
				this.modeObj.game_advance_maze = false;
				this.paused.game_advance_maze = false;
			}
			
			if(this.modeObj != null && 
			   this.flyer.game_advance_planet && this.gameMode == AGGame.MODE_FLYER) {
				
				this.myMazeEntrance = new Array();
				
				//var planet:int = this.gamePlanet;
				this.gamePlanet ++;
				//if (this.gamePlanet >= this.flyer.planets) this.gamePlanet = 0;
				if (this.gamePlanet >= this.gamePlanetTot) this.gamePlanet = 0;
				this.loadXML(true);
				
				this.flyer = new AGModeFlyer();
				this.flyer.game_start = true;
				this.flyer.setValues(this.myStage, myKeys, this.myRes, this);
				//this.flyer.game_start = true;
				//this.loadXML(true);
				this.modeObj = flyer;
				this.guy.game_advance_maze = false;
				this.flyer.game_advance_maze = false;
				this.flyer.game_advance_planet = false;
				this.modeObj.game_advance_maze = false;
				this.paused.game_advance_maze = false;
			}
			
			if (K_RESTART) {
				//this.myButtons[AGKeys.BUTTON_RESTART].setValBool(false);
				this.myKeys[this.myKeyStage.keycodeRestart].setValBool(false);
				controls = new AGModeControls();
				controls.setValues(myStage,myKeys,myRes,this);
				
				this.gamePlanet = 0;
				this.loadXML();
				//this.startAGGame();
			}
			
			if (gameLives == 0 ) {
				this.gameLives = 3;
				this.gameScore = 10;
				this.gameHealth = 50;
				this.gamePlanet = 0;
				this.myModeStack = new Array();
				this.myModeStack.push(AGGame.MODE_START);
				this.gamePaused = true;
				
				this.loadXML();
				//this.startAGGame();
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
			else if (gameMode == MODE_CONTROLS) {
				modeObj = controls;
			}
			
			if (true ) modeObj.innerGameLoop();
		}
	}
	
}
