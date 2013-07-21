package org.davidliebman.flash.awesomeguy {
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	
	public class AGTimer {

			public var myTimer:Timer ;
			public var done:Boolean = false;
			public var timer_disable:Boolean = false;
			public var started:Boolean = false;
		
		public function AGTimer(num:Number = 0) {
			if (num != 0 ) timerStart(num);
			// constructor code
			
		}
		public function timerStart(num:Number):void {
			
			myTimer = new Timer(num * 1000, 1);
			myTimer.addEventListener(TimerEvent.TIMER, runOnce);
			myTimer.start();
			started = true;
			done = false;
		}
		
		public function runOnce(e:TimerEvent):void {
			done = true;
		}
		
		public function timerDone():Boolean {
			
			if (done && ! timer_disable) return true;
			else if (!started ) return true;
			else return false;
		}
	}
	
}
