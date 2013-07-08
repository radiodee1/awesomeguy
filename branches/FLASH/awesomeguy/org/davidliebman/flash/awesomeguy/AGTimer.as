package org.davidliebman.flash.awesomeguy {
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	
	public class AGTimer {

			public var myTimer:Timer;
			public var done:Boolean = false;
			public var timer_disable:Boolean = false;
		
		
		public function AGTimer() {
			// constructor code
			
		}
		public function timerStart(num:int):void {
			myTimer = new Timer(num * 1000, 1);
			myTimer.addEventListener(TimerEvent.TIMER, runOnce);
			myTimer.start();
		}
		
		public function runOnce(e:TimerEvent):void {
			done = true;
		}
		
		public function timerDone():Boolean {
			if (done && ! timer_disable) return true;
			else return false;
		}
	}
	
}
