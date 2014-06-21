package org.davidliebman.flash.awesomeguy {
	
	
	public class AGSpriteXRing extends AGSprite{

		public function AGSpriteXRing(mymode:AGMode, kind:int) {
			super(mymode,kind);
			// constructor code
		}
		
		public override function updateSprite():void {
			super.updateSprite();
			animate ++;
			if (animate > 7) animate = 0;
			
			var zz:int = AGModeGuy.B_PRIZE ;
			if (animate == 0 || animate == 1 || animate == 8) {
		
								//cutTile(tiles_a, square, k - mapcheat);
								this.bitmap = myMode.oldCutTile(  myMode.myRes[AGResources.NAME_TILES1_PNG], 
									zz,//myInvisible[i][j] + mapcheat,
									AGMode.TILE_BOT, 32, 32);
							}
							else if (animate == 2 || animate == 4 || animate == 6) {
		
								//cutTile(tiles_b, square, k - mapcheat);
								this.bitmap = myMode.oldCutTile(  myMode.myRes[AGResources.NAME_TILES2_PNG], 
									zz,//myInvisible[i][j] + mapcheat,
									AGMode.TILE_BOT, 32, 32);
							}
							else if (animate == 3 || animate == 7) {
		
								//cutTile(tiles_c, square, k - mapcheat);
								this.bitmap = myMode.oldCutTile(  myMode.myRes[AGResources.NAME_TILES3_PNG], 
									zz,//myInvisible[i][j] + mapcheat,
									AGMode.TILE_BOT, 32, 32);
							}
							else if (animate == 5) {
		
								//cutTile(tiles_d, square, k - mapcheat);
								this.bitmap = myMode.oldCutTile(  myMode.myRes[AGResources.NAME_TILES4_PNG], 
									zz,//myInvisible[i][j] + mapcheat,
									AGMode.TILE_BOT, 32 , 32);
							}
							
			myMode.drawRadarPing(myMode.radar, 
								 myMode.radarscreen, 
								 this.x, this.y, 
								 AGMode.PING_OTHER, 
								 0xffff0000);

		}
		
		

	}
	
}
