package org.davidliebman.flash.awesomeguy {
	
	public class AGSpriteInvader2 extends AGSprite{

		public function AGSpriteInvader2(mymode:AGMode, kind:int) {
			super(mymode,kind);
			// constructor code
		}
		public override function updateSprite():void {
			
				if (!this.active || !this.visible || this.sprite_type != AGMode.S_INVADER_2) return;
			
				myMode.drawRadarPing(myMode.radar, myMode.radarscreen,
								 this.x, this.y, AGMode.PING_OTHER, 0xffff0000);
	
				if(myMode.ypos  + AGMode.LASER_GUN  < this.y + 5) {
					this.y = this.y - this.speed;
				}
				else if (myMode.ypos + AGMode.LASER_GUN > this.y + 11) {
					this.y = this.y + this.speed;
				}
	
				if(this.quality_3 == AGMode.P_GOING_RIGHT && ! this.timerDone()  ) {
					this.x = this.x + this.speed;
				}
				if ( this.quality_3 == AGMode.P_GOING_LEFT  && ! this.timerDone() ) {
					this.x = this.x - this.speed;
				}
				if(this.quality_3 == AGMode.P_GOING_RIGHT_ARMED && ! this.timerDone() ) {
					this.x = this.x + this.speed;
				}
				if ( this.quality_3 == AGMode.P_GOING_LEFT_ARMED  && ! this.timerDone() ) {
					this.x = this.x - this.speed;
				}
	
				// set various paths
	
				// goingRightIsShortest(this.x, flyer.x)
				if (this.myMode.goingRightIsShortest(this.x ,myMode.xpos ) && this.quality_3 == AGMode.P_NONE) {
					this.quality_3 = AGMode.P_GOING_RIGHT;
					this.facingRight = true;
					//spriteTimerStart(i, 30 * 3);
					this.timerStart(3);
				}
				else if (this.quality_3 == AGMode.P_NONE ) {
					this.quality_3 = AGMode.P_GOING_LEFT;
					this.facingRight = false;
					//spriteTimerStart(i, 30 * 3);
					this.timerStart(3);
				}
	
				if ( this.quality_3 == AGMode.P_GOING_RIGHT && this.timerDone() ) {
					this.quality_3 = AGMode.P_GOING_LEFT_ARMED;
					this.facingRight = false;
					this.timerStart(3);
					//spriteTimerStart(i, 30 * 3);
				}
				if ( this.quality_3 == AGMode.P_GOING_LEFT && this.timerDone()  ) {
					this.quality_3 = AGMode.P_GOING_RIGHT_ARMED;
					this.facingRight = true;
					this.timerStart(3);
					//spriteTimerStart(i, 30 * 3);
				}
	
				if ( (this.quality_3 == AGMode.P_GOING_LEFT_ARMED || this.quality_3 == AGMode.P_GOING_RIGHT_ARMED)  && this.timerDone() ) {
					if (!myMode.goingRightIsShortest(this.x , myMode.xpos ) ) {
						this.quality_3 = AGMode.P_GOING_LEFT_ARMED;
						this.facingRight = false;
						this.timerStart(3);
						//spriteTimerStart(i, 30 * 3);
	
					}
					else  {
						this.quality_3 = AGMode.P_GOING_RIGHT_ARMED;
						this.facingRight = true;
						this.timerStart(3);
						//spriteTimerStart(i, 30 * 3);
					}
				}
			
		}

	}
	
}
