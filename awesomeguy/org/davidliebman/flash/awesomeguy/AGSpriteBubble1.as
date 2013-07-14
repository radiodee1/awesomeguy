package org.davidliebman.flash.awesomeguy  {
	
	public class AGSpriteBubble1 extends AGSprite {

		public function AGSpriteBubble1(mode:AGMode, kind:int) {
			super(mode, kind);
			// constructor code
		}

		public override function updateSprite():void {
			/*
			int i, j, k, l, m;
			BOOL test = FALSE;
			int num_strikes = challenge[current_challenge].bubble_1;
		
			if ( num_strikes > total_placed_bubble_1 ) {
				if(timerDone(2)) {
					// create a line-type object
					Sprite temp ;
					temp.x = getRand(scrollx, scrollx + TEX_WIDTH);
					temp.y = 0;
					int angle = getRand( 80, 180 - 80) ;
					float value = ((float) LONG_MAP_V * 8)/ (float) tan(angle) ;
					temp.endline_x = abs ((( (int) value ) + temp.x) % (LONG_MAP_H * 8));
		
					temp.endline_y = LONG_MAP_V * 8;
					temp.sprite_type = S_LINE;
					temp.speed = 2;
					temp.active = TRUE;
					temp.quality_0 = 0;
		
					// add it to the sprite list
					addSprite(temp);
		
					// increment total_placed_bubble_1
					total_placed_bubble_1 ++;
					//total_bubble_1 ++;
		
					// reset timer
					timerStart(2, 30 * 1);
				}
			}
			// draw lines... make bubbles...
		
			//go through sprites
			for (i = 0; i < 100; i ++ ) {
		
				if (sprite[i].sprite_type == S_LINE && sprite[i].active == TRUE ) { // if i is a line
					
					if(sprite[i].quality_0 <= sprite[i].endline_y ) {
						sprite[i].quality_0 = sprite[i].quality_0 + sprite[i].speed;
					}
					else {//if (total_bubble_1 < num_strikes)  {
						// make bubble
		
		
						////
						if (TRUE ) {
							Sprite new;
							new.sprite_type = S_BUBBLE_1;
							new.x = sprite[i].endline_x;
							new.y = sprite[i].endline_y;
							new.limit = 100;
							new.radius = 8;
							new.speed = 1;
							new.active = TRUE;
							new.sprite_link = i;
		
							sprite[i].active = FALSE;
		
							addSprite(new);
							total_bubble_1 ++;
						}
						////
		
					}
					// draw lines ...
					
					
					for (l = 0; l < sprite[i].quality_0 ; l ++) {
						k = ((sprite[i].endline_x - sprite[i].x ) * l) / ( sprite[i].endline_y - sprite[i].y) + sprite[i].x;
		
						drawPoint(k,l, 0xffff);
		
						if ( scrollx + SCREEN_WIDTH > (level_w * 8) && k  < SCREEN_WIDTH ) {
							drawPoint(k + (level_w * 8), l, 0xffff);
							//LOGE("over edge here");
						}
		
					}
					
		
				}//function
				
			}// 
			*/
		}//function

	}//class
	
}// package
