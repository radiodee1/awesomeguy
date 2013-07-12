package  org.davidliebman.flash.awesomeguy {
	import flash.display.*;
	import flash.net.URLLoader;
	import flash.events.Event;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	import flash.system.ApplicationDomain;
	import flash.media.Sound;
	import flash.xml.XMLDocument;
	import flash.geom.*;
	import fl.motion.Color;
	
	public class AGResources {

	var myStage:Stage;
	var neededRes:Array = new Array();
	//var collectedRes:Array = new Array();
	var loader:Loader = new Loader();
	var uloader:URLLoader = new URLLoader();
	var myButtons:Array;
	var myRes:Array = new Array();

	public static var R_SPRITE:int = 1;
	public static var R_SOUND:int = 2;
	public static var R_XML:int = 3;
	public static var R_BITMAP:int = 4;
		
	//public static var RES_INDEX:int = 6;
		
	public static var NAME_AWESOMEGUY_XML:int =  0;
	public static var NAME_TEST2_PNG:int =  1;
	public static var NAME_TILES1_PNG:int = 2;
	public static var NAME_TILES2_PNG:int = 3;
	public static var NAME_TILES3_PNG:int = 4;
	public static var NAME_TILES4_PNG:int = 5;
	public static var NAME_FLYER_L0_PNG:int = 6;
	public static var NAME_FLYER_L1_PNG:int = 7;
	public static var NAME_FLYER_R0_PNG:int = 8;
	public static var NAME_FLYER_R1_PNG:int = 9;
	
	public static var NAME_MONSTER_L0_PNG:int = 10;
	public static var NAME_MONSTER_L1_PNG:int = 11;
	public static var NAME_MONSTER_R0_PNG:int = 12;
	public static var NAME_MONSTER_R1_PNG:int = 13;
	
	public static var NAME_BOOM_MP3:int = 14;
	public static var NAME_ENTER_1_MP3:int = 15;
	public static var NAME_ENTER_2_MP3:int = 16;
	public static var NAME_ENTER_3_MP3:int = 17;
	public static var NAME_ENTER_4_MP3:int = 18;
	public static var NAME_EXPLOSION_MP3:int = 19;
	public static var NAME_EXPLOSION_BIG_MP3:int = 20;
	public static var NAME_GOAL_MP3:int = 21;
	public static var NAME_OW_MP3:int = 22;
	public static var NAME_PRIZE_MP3:int = 23;

	public static var NAME_EXPLOSION_A:int = 24;
	public static var NAME_EXPLOSION_B:int = 25;
	public static var NAME_EXPLOSION_C:int = 26;
	public static var NAME_EXPLOSION_D:int = 27;
	public static var NAME_EXPLOSION_E:int = 28;
	public static var NAME_EXPLOSION_F:int = 29;
	public static var NAME_EXPLOSION_G:int = 30;
	public static var NAME_EXPLOSION_H:int = 31;
	

	var res00:Array = new Array (R_XML, "xml/awesomeguy.xml");
	var res01:Array = new Array (R_BITMAP, "bitmap/test2.png");
	var res02:Array = new Array (R_BITMAP, "bitmap/agtiles1.png");
	var res03:Array = new Array (R_BITMAP, "bitmap/agtiles2.png");
	var res04:Array = new Array (R_BITMAP, "bitmap/agtiles3.png");
	var res05:Array = new Array (R_BITMAP, "bitmap/agtiles4.png");
	
	var res06:Array = new Array (R_BITMAP, "bitmap/flyer_l0.png");
	var res07:Array = new Array (R_BITMAP, "bitmap/flyer_l1.png");
	var res08:Array = new Array (R_BITMAP, "bitmap/flyer_r0.png");
	var res09:Array = new Array (R_BITMAP, "bitmap/flyer_r1.png");
	
	var res10:Array = new Array (R_BITMAP, "bitmap/monster_l0.png");
	var res11:Array = new Array (R_BITMAP, "bitmap/monster_l1.png");
	var res12:Array = new Array (R_BITMAP, "bitmap/monster_r0.png");
	var res13:Array = new Array (R_BITMAP, "bitmap/monster_r1.png");

	var res14:Array = new Array (R_SOUND, "sound/boom.mp3");
	var res15:Array = new Array (R_SOUND, "sound/enter_1.mp3");
	var res16:Array = new Array (R_SOUND, "sound/enter_2.mp3");
	var res17:Array = new Array (R_SOUND, "sound/enter_3.mp3");
	var res18:Array = new Array (R_SOUND, "sound/enter_4.mp3");
	var res19:Array = new Array (R_SOUND, "sound/explosion.mp3");
	var res20:Array = new Array (R_SOUND, "sound/explosion_big.mp3");
	var res21:Array = new Array (R_SOUND, "sound/goal.mp3");
	var res22:Array = new Array (R_SOUND, "sound/ow.mp3");
	var res23:Array = new Array (R_SOUND, "sound/prize.mp3");

	var res24:Array = new Array (R_BITMAP, "bitmap/explosion_a.png");
	var res25:Array = new Array (R_BITMAP, "bitmap/explosion_b.png");
	var res26:Array = new Array (R_BITMAP, "bitmap/explosion_c.png");
	var res27:Array = new Array (R_BITMAP, "bitmap/explosion_d.png");
	var res28:Array = new Array (R_BITMAP, "bitmap/explosion_e.png");
	var res29:Array = new Array (R_BITMAP, "bitmap/explosion_f.png");
	var res30:Array = new Array (R_BITMAP, "bitmap/explosion_g.png");
	var res31:Array = new Array (R_BITMAP, "bitmap/explosion_h.png");
	
	
	var i:int = 0;
		
	var r_url:String = "";
	var r_type:int = 0;
	
	
	var r_sprite:Sprite = new Sprite();
	var r_sound:Sound = new Sound();
	var r_xml:XMLDocument = new XMLDocument();
	var r_bitmap:Bitmap = new Bitmap();
		
		public function AGResources(mystage:Stage, buttons:Array) {
			//trace ("import worked. " );
			myStage = mystage;
			myButtons = buttons;
			i = 0;
			myRes = new Array();
			// list resources needed...
			neededRes.push(res00);
			neededRes.push(res01);
			neededRes.push(res02);
			neededRes.push(res03);
			neededRes.push(res04);
			neededRes.push(res05);
			neededRes.push(res06);
			neededRes.push(res07);
			neededRes.push(res08);
			neededRes.push(res09);
			neededRes.push(res10);
			neededRes.push(res11);
			neededRes.push(res12);
			neededRes.push(res13);

			neededRes.push(res14);
			neededRes.push(res15);
			neededRes.push(res16);
			neededRes.push(res17);
			neededRes.push(res18);
			neededRes.push(res19);
			neededRes.push(res20);
			neededRes.push(res21);
			neededRes.push(res22);
			neededRes.push(res23);
			
			neededRes.push(res24);
			neededRes.push(res25);
			neededRes.push(res26);
			neededRes.push(res27);
			neededRes.push(res28);
			neededRes.push(res29);
			neededRes.push(res30);
			neededRes.push(res31);


			importRes();
		}
		
		public function importRes():void {
			if (i >= neededRes.length) {
				launchNextPhase();
			}
			else {
				//trace(neededRes[i][1]);
				getRes(neededRes[i][0], neededRes[i][1]);
			}
		}
		
		public function getRes(resType:int, resUrl:String) {


			r_url = resUrl;
			r_type = resType;
			
			switch(r_type) {
				case AGResources.R_SPRITE:
				case AGResources.R_BITMAP:
				//case AGResources.R_XML:
					loader.contentLoaderInfo.addEventListener(Event.COMPLETE, finishRes);
					//loader.addEventListener(Event.COMPLETE, finishRes);

					loader.load(new URLRequest(r_url));//, loaderContext);
					//trace(r_url + " - stop here.");
				break;
				////////////////////////////////////
				case AGResources.R_SOUND:
					r_sound = new Sound();
					r_sound.load( new URLRequest(r_url));
					finishRes(null);
				break;
				////////////////////////////////////
				case AGResources.R_XML:
					uloader.addEventListener(Event.COMPLETE, finishRes);
					uloader.load(new URLRequest(r_url));
					
				break;
				
				
			}

			
		}
		public function finishRes(e:Event):void {
		
			//trace ("done");
			switch (r_type) {
				case AGResources.R_SPRITE:
				//sprite
					var bitmap:BitmapData;
					bitmap = Bitmap(LoaderInfo(e.target).content).bitmapData;
					r_sprite = new Sprite();
					r_sprite.graphics.beginBitmapFill(bitmap, null, false, false);
					r_sprite.graphics.drawRect(0,0, bitmap.width, bitmap.height);
					r_sprite.graphics.endFill();
					
					myRes.push(r_sprite);
				break;
				case AGResources.R_BITMAP:
					r_bitmap = Bitmap(LoaderInfo(e.target).content);
					var bitmapdata1:BitmapData = r_bitmap.bitmapData;
					var bitmapdata2:BitmapData = new BitmapData(r_bitmap.width, r_bitmap.height, true, 0x000000ff);
					//switch black to alpha
					var pt:Point = new Point(0,0);
					var rect:Rectangle = new Rectangle(0, 0, r_bitmap.width, r_bitmap.height);
					var threshold:uint = 0x00000000;
					var maskcolor:uint = 0x00ffffff;// 0x000000ff;
					var color:uint = 0x00000000;
					bitmapdata2.threshold(bitmapdata1, rect, pt, "==", threshold, color, maskcolor, true);
					r_bitmap = new Bitmap(bitmapdata2);
					myRes.push(r_bitmap);
				break;
				
				case AGResources.R_SOUND:
				//sound
					
					myRes.push(r_sound);
					
				break;
			
				case AGResources.R_XML:
				//xml
					r_xml = new XMLDocument();
					//trace("r_xml");
					r_xml.ignoreWhite = true;
					r_xml.parseXML(e.target.data);
					//trace(r_xml);
					myRes.push(r_xml);
					
				break;
				
			}
			i ++;
			this.importRes();
		}
		
		public function launchNextPhase():void {
			trace("really done");
			
			var game:AGGame = new AGGame(myStage, myButtons, myRes);
		}
		
	}
	
}

