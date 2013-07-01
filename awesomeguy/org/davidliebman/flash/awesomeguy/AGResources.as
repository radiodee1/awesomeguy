package  org.davidliebman.flash.awesomeguy {
	import flash.display.*;
	import flash.net.URLLoader;
	import flash.events.Event;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	import flash.system.ApplicationDomain;

	public class AGResources {

	var neededRes:Array = new Array();
	var collectedRes:Array = new Array();
		
	public static var R_SPRITE:int = 1;
	public static var R_SOUND:int = 2;
	public static var R_XML:int = 3;
		
	var res1:Array = new Array (R_SPRITE, "./bitmap/test.png");
	var res2:Array = new Array (R_SPRITE, "./bitmap/test2.png");
		
	var i:int = 0;
		
	var r_url:String = "";
	var r_type:int = 0;
	//var loader:Loader = new Loader();
	
	var r_sprite:Sprite = new Sprite();
		
		
		public function AGResources() {
			//trace ("import worked. " );
			i = 0;
			neededRes.push(res1);
			importRes();
		}

		//public function AGResources(needed:Array):void {
		//	neededRes = needed;
		//	importRes();
		//}
		
		public function importRes():void {
			if (i >= neededRes.length) return;
			getRes(neededRes[i][0], neededRes[i][1]);
		}
		
		public function getRes(resType:int, resUrl:String) {

			var loader:Loader = new Loader();

			r_url = resUrl;
			r_type = resType;

			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, finishRes);

			loader.load(new URLRequest(r_url));//, loaderContext);
			trace(r_url + " - stop here.");
		}
		public function finishRes(e:Event):void {
		
			trace ("done");
			switch (r_type) {
				case AGResources.R_SPRITE:
				//sprite
					var bitmap:BitmapData;
					bitmap = Bitmap(LoaderInfo(e.target).content).bitmapData;
					
					r_sprite.graphics.beginBitmapFill(bitmap, null, false, false);
					r_sprite.graphics.drawRect(0,0, bitmap.width, bitmap.height);
					r_sprite.graphics.endFill();
				break;
			
				case AGResources.R_SOUND:
				//sound
				break;
			
				case AGResources.R_XML:
				//xml
				break;
				
			}
			i ++;
			this.importRes();
		}
		
		
	}
	
}

