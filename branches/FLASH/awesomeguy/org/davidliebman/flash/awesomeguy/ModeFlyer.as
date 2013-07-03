package org.davidliebman.flash.awesomeguy {
	import flash.xml.XMLDocument;
	
	public class ModeFlyer extends AGMode{

		public function ModeFlyer() {
			// constructor code
		}
		
		public override function componentsInOrder():void {
			//myStage.addChild(myRes[AGResources.NAME_TEST_PNG]);
			
		}
		
		public override function doOnce():void {
			myStage.addChild(myRes[AGResources.NAME_TEST2_PNG]);
			prepTiles() ;
			
			//myRes[AGResources.NAME_EXPLOSION_MP3].play();
		}
		
		public override function prepTiles():void {
			var tempArray:Array = new Array();
			var smallArray:Array = new Array();
			var visibleArray:Array = new Array();
			var invisibleArray:Array = new Array();
			var myHoriz:int = 0;
			var myVert:int = 0;
			var stringVisible:String;
			var stringInvisible:String;
			var myXML:XMLDocument = myRes[AGResources.NAME_AWESOMEGUY_XML];
			
			myHoriz = int (myXML.firstChild.firstChild.firstChild.firstChild.toString());
			myVert = int (myXML.firstChild.firstChild.firstChild.nextSibling.firstChild.toString());
			
			stringVisible = myXML.firstChild.firstChild.firstChild.nextSibling.nextSibling.firstChild.firstChild.toString();// visible
			stringInvisible = myXML.firstChild.firstChild.firstChild.nextSibling.nextSibling.firstChild.nextSibling.firstChild.toString();// invisible
			
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
