﻿package org.davidliebman.flash.awesomeguy {
	
	public class AGChallenge {

			public var rings:int, invader_1:int, invader_2:int, invader_3:int;
			public var bubble_1:int, bubble_2:int, bubble_3:int;
			public var speed:int;
		
			public var total_rings:int;
			public var total_bubble_0:int, total_bubble_1:int, total_bubble_2:int, total_bubble_3:int;
			public var total_invader_1:int, total_invader_2:int, total_invader_3:int;

			public var total_placed_bubble_1:int, total_placed_bubble_2:int, total_placed_bubble_3:int;
			public var total_placed_invader_1:int, total_placed_invader_2:int, total_placed_invader_3:int;

			public var total_held_rings:int;
		
		public function AGChallenge() {
			// constructor code
		}

		public function checkTotals():Boolean {
			var test:Boolean = true;
			if ( 	total_rings +
					total_bubble_0 +
					total_bubble_1 +
					total_bubble_2 +
					total_bubble_3 +
					total_invader_1 +
					total_invader_2 +
					total_invader_3
					> 0 ||
					total_placed_bubble_1 < this.bubble_1 ||
					total_placed_bubble_2 < this.bubble_2 ||
					total_placed_invader_1 < this.invader_1 ||
					total_placed_invader_2 < this.invader_2
					) {
				test = false;
			}
			
			trace(total_rings, total_bubble_1, total_bubble_2, total_bubble_3);
			return test;
		}

	}
	
}
