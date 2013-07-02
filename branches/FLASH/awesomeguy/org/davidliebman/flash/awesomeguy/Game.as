﻿package  org.davidliebman.flash.awesomeguy {
	import flash.display.Stage;
	import flash.events.Event;
	
	public class Game {

	var K_LEFT:Boolean = false;
	var K_RIGHT:Boolean = false;
	var K_UP:Boolean = false;
	var K_DOWN:Boolean = false;		
	var K_SHOOT:Boolean = false;
	var K_JUMP:Boolean = false;
	
	var myStage:Stage;
	var myButtons:Array;
	var myRes:Array;
		
		public function Game(mystage:Stage, mybuttons:Array, myresources:Array) {
			
			myStage = mystage;
			myButtons = mybuttons;
			myRes = myresources;
			
			myStage.addEventListener(Event.ENTER_FRAME, setKeys );
			trace ("import worked. " );
			//var getter:AGResources = new AGResources();
		}

		public function setKeys(e:Event) {
			setKeyValues(myButtons[AGKeys.BUTTON_LEFT], myButtons[AGKeys.BUTTON_RIGHT], myButtons[AGKeys.BUTTON_UP],
						 myButtons[AGKeys.BUTTON_DOWN], myButtons[AGKeys.BUTTON_SHOOT], myButtons[AGKeys.BUTTON_JUMP]);
		}

		public function setKeyValues(left:Boolean, right:Boolean, up:Boolean, down:Boolean, shoot:Boolean, jump:Boolean) {
			K_LEFT = left;
			K_RIGHT = right;
			K_UP = up;
			K_DOWN = down;
			K_JUMP = jump;
			K_SHOOT = shoot;
			doAnimation();
		}
		
		public function doAnimation() {
			trace ("down " + K_DOWN);
		}
	}
	
}
