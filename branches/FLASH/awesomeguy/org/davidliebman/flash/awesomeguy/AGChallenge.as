package org.davidliebman.flash.awesomeguy {
	
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
		
		public function clearTotals():void {
			//this.rings = 0;
			this.total_rings = 0;
			this.total_bubble_0 = 0;
			this.total_bubble_1 = 0;
			this.total_bubble_2 = 0;
			this.total_bubble_3 = 0;
			
			this.total_invader_1 = 0;
			this.total_invader_2 = 0;
			this.total_invader_3 = 0;
			
			this.total_placed_bubble_1 = 0;
			this.total_placed_bubble_2 = 0;
			this.total_placed_bubble_3 = 0;
			
			this.total_placed_invader_1 = 0;
			this.total_placed_invader_2 = 0;
			this.total_placed_invader_3 = 0;
		}
		
		public function countTotals(mySprite:Array):void {
			clearTotals();
			var sprite:AGSprite;
			for(var i:int = 0; i < mySprite.length; i ++ ) {
				sprite = mySprite[i];
				switch( sprite.sprite_type) {
					case AGMode.S_BUBBLE_1:
						this.total_placed_bubble_1 ++;
					break;
					case AGMode.S_BUBBLE_2:
						this.total_placed_bubble_2 ++;
					break;
					case AGMode.S_BUBBLE_3:
						this.total_placed_bubble_3 ++;
					break;
					case AGMode.S_GATOR:
					break;
					case AGMode.S_INVADER_1:
						this.total_placed_invader_1 ++;
					break;
					case AGMode.S_INVADER_2:
						this.total_placed_invader_2 ++;
					break;
					case AGMode.S_INVADER_3:
						this.total_placed_invader_3 ++;
					break;
					case AGMode.S_RING:
						
					break;
				}
				if (sprite.sprite_type == AGMode.S_LINE || sprite.sprite_type == AGMode.S_LINE_2) {
					// ... because lines are misinterpreted.
					this.total_placed_bubble_1++;
					this.total_placed_bubble_2++;
				}
				if (sprite.active == true ) {
					switch( sprite.sprite_type) {
						case AGMode.S_BUBBLE_1:
							this.total_bubble_1 ++;
						break;
						case AGMode.S_BUBBLE_2:
							this.total_bubble_2 ++;
						break;
						case AGMode.S_BUBBLE_3:
							this.total_bubble_3 ++;
						break;
						case AGMode.S_GATOR:
						break;
						case AGMode.S_INVADER_1:
							this.total_invader_1 ++;
						break;
						case AGMode.S_INVADER_2:
							this.total_invader_2 ++;
						break;
						case AGMode.S_INVADER_3:
							this.total_invader_3 ++;
						break;
						case AGMode.S_RING:
							this.total_rings ++;
						break;
					}
				}
				
			}
			//trace("--",total_rings, total_bubble_1, total_bubble_2, total_bubble_3);

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
					total_placed_invader_1 < this.invader_1 //||
					//total_placed_invader_2 < this.invader_2
					) {
				test = false;
			}
			
			//trace(total_rings, total_bubble_1, total_bubble_2, total_bubble_3);
			return test;
		}

		public function showTrace():void {
			trace(rings, bubble_1, bubble_2, bubble_3, this.invader_1, this.invader_2);

		}
	}
	
}
