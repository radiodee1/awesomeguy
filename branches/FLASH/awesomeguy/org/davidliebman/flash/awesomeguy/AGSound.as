package org.davidliebman.flash.awesomeguy {
	import flash.media.Sound;
	
	public class AGSound {

		public var mySound:Sound;
		public var myKey:KeyValue;

		public function AGSound(sound:Sound, key:KeyValue) {
			mySound = sound;
			myKey = key;
			
		}

		public function play():void {
			if ( myKey.getValBool() == false) {
				mySound.play();
				
			}
		}

	}
	
}
