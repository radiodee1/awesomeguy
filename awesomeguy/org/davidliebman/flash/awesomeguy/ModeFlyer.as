package org.davidliebman.flash.awesomeguy {
	import flash.xml.XMLDocument;
	import flash.display.Sprite;
	
	public class ModeFlyer extends AGMode{

		var sprite:Sprite = new Sprite();

		public function ModeFlyer() {
			// constructor code
		}
		
		public override function componentsInOrder():void {
			//
			super.componentsInOrder();
			
			if (facingRight) {
				if (animate %2 == 1 ) {
					sprite = myRes[AGResources.NAME_FLYER_R0_PNG];

				}
				else {
					sprite = myRes[AGResources.NAME_FLYER_R1_PNG];

				}
			}
			else {
				if (animate %2 == 1) {
					sprite = myRes[AGResources.NAME_FLYER_L0_PNG];

				}
				else {
					sprite = myRes[AGResources.NAME_FLYER_L1_PNG];

				}
			}
			sprite.x = xpos - scrollBGX;
			sprite.y = ypos - scrollBGY;
			myStage.addChild(sprite);
		}
		
		public override function doOnce():void {
			
			myStage.addChild(myRes[AGResources.NAME_FLYER_L0_PNG]);
			
			prepTiles() ;
			
			//myRes[AGResources.NAME_EXPLOSION_MP3].play();
		}
		
		public override function prepTiles():void {
			var tempArray:Array = new Array();
			var smallArray:Array = new Array();
			var visibleArray:Array = new Array();
			var invisibleArray:Array = new Array();
			
			var stringVisible:String;
			var stringInvisible:String;
			var myXML:XMLDocument = myRes[AGResources.NAME_AWESOMEGUY_XML];
			
			var tree:XML = new XML(myXML);
			//trace (tree.planet[myGame.gamePlanet].horizontal);
			
			myHoriz = int (tree.planet[myGame.gamePlanet].horizontal.toString());
			myVert = int (tree.planet[myGame.gamePlanet].vertical.toString());
			

			stringVisible = tree.planet[myGame.gamePlanet].visible.toString();
			stringInvisible = tree.planet[myGame.gamePlanet].invisible.toString();
			
			var i:int = 0;
			var j:int = 0;
			
			myVisible = new Array();
			tempArray = new Array();
			tempArray = stringVisible.split(",");
			for (i = 0; i < myVert; i ++ ) {
				smallArray = new Array();
				for (j = 0 ; j < myHoriz; j ++ ) {
					smallArray.push(int (tempArray[ (i * myHoriz) + j ] ) );
				}
				myVisible.push(smallArray);
			}
			
			myInvisible = new Array();
			tempArray = new Array();
			tempArray = stringInvisible.split(",");
			for (i = 0; i < myVert; i ++ ) {
				smallArray = new Array();
				for (j = 0 ; j < myHoriz; j ++ ) {
					smallArray.push(int (tempArray[ (i * myHoriz) + j ] ) );
				}
				myInvisible.push(smallArray);
			}
			
			//trace(myInvisible);
		}
	}
	
}
