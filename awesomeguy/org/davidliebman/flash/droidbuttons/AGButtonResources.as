package org.davidliebman.flash.droidbuttons {
	
	
	
	import org.davidliebman.flash.awesomeguy.*;
	//import flash.filesystem.File;
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
	import flash.text.*;
	import flash.utils.ByteArray;
	//import flash.filesystem.*;
	import flash.events.IOErrorEvent;
	
	
	
	public class AGButtonResources extends AGResources {
	
	/*
	public var textField:TextField = new TextField();
	public var format:TextFormat = new TextFormat();

	public var myStage:Stage;
	public var neededRes:Array = new Array();
	
	public var loader:Loader = new Loader();
	public var uloader:URLLoader = new URLLoader();
	//var myButtons:Array;
	public var myKeyStage:AGKeys;
	public var myKeys:Array;
	public var myRes:Array = new Array();

	public static var R_SPRITE:int = 1;
	public static var R_SOUND:int = 2;
	public static var R_XML:int = 3;
	public static var R_BITMAP:int = 4;
	public static var R_BITMAP_WBLACK:int = 5;
	*/
		
	
	var bytes:ByteArray = new ByteArray();
	//var myFileStream:FileStream = new FileStream();
	//var r_file:File = new File();

	//public var startMessage:String = new String("loading....");


	var i:int = 0;
		
	var r_url:String = "";
	var r_type:int = 0;
	
	
	var r_sprite:Sprite = new Sprite();
	var r_sound:Sound = new Sound();
	var r_xml:XMLDocument = new XMLDocument();
	var r_bitmap:Bitmap = new Bitmap();

	
		public function AGButtonResources(mystage:Stage, keystage:AGKeys, keys:Array) {
			//  var  ructor code
			
			

			myStage = mystage;
			//myButtons = buttons;
			myKeyStage = keystage;
			myKeys = keys;
			i = 0;
			myRes = new Array();
			neededRes = new Array();
			
			format = new TextFormat();
			textField = new TextField();
			
			this.format.color = 0x00ffffff;
			this.format.font = "Courier";
			this.format.bold = true;
			this.textField.width = 1000;
			this.textField.x = 10;
			this.textField.y = 10;
			this.textField.text = "loading...";
			this.textField.setTextFormat(this.format);
			myStage.addChild(this.textField);
			
			super(mystage, keystage, keys);

			

			//importResEmbed();
		}
		
		public override function importRes():void {
			
			this.neededRes = new Array();
			
			[Embed("/xml/awesomeguy.xml", mimeType="application/octet-stream")]  var   res00:Class;
			[Embed("/bitmap/test2.png")]  var   res01:Class;
			
			[Embed("/bitmap/agtiles1.png")]  var   res02:Class;
			[Embed("/bitmap/agtiles2.png")]  var   res03:Class;
			[Embed("/bitmap/agtiles3.png")]  var   res04:Class;
			[Embed("/bitmap/agtiles4.png")]  var   res05:Class;
			
			[Embed("/bitmap/flyer_l0.png")]  var   res06:Class;
			[Embed("/bitmap/flyer_l1.png")]  var   res07:Class;
			[Embed("/bitmap/flyer_r0.png")]  var   res08:Class;
			[Embed("/bitmap/flyer_r1.png")]  var   res09:Class;
			
			[Embed("/bitmap/monster_l0.png")]  var   res10:Class;
			[Embed("/bitmap/monster_l1.png")]  var   res11:Class;
			[Embed("/bitmap/monster_r0.png")]  var   res12:Class;
			[Embed("/bitmap/monster_r1.png")]  var   res13:Class;
		
			[Embed("/sound/boom.mp3")]  var   res14:Class;
			[Embed("/sound/enter_1.mp3")]  var   res15:Class;
			[Embed("/sound/enter_2.mp3")]  var   res16:Class;
			[Embed("/sound/enter_3.mp3")]  var   res17:Class;
			[Embed("/sound/enter_4.mp3")]  var   res18:Class;
			[Embed("/sound/explosion.mp3")]  var   res19:Class;
			[Embed("/sound/explosion_big.mp3")]  var   res20:Class;
			[Embed("/sound/goal.mp3")]  var   res21:Class;
			[Embed("/sound/ow.mp3")]  var   res22:Class;
			[Embed("/sound/prize.mp3")]  var   res23:Class;
		
			[Embed("/bitmap/explosion_a.png")]  var   res24:Class;
			[Embed("/bitmap/explosion_b.png")]  var   res25:Class;
			[Embed("/bitmap/explosion_c.png")]  var   res26:Class;
			[Embed("/bitmap/explosion_d.png")]  var   res27:Class;
			[Embed("/bitmap/explosion_e.png")]  var   res28:Class;
			[Embed("/bitmap/explosion_f.png")]  var   res29:Class;
			[Embed("/bitmap/explosion_g.png")]  var   res30:Class;
			[Embed("/bitmap/explosion_h.png")]  var   res31:Class;
			
			[Embed("/bitmap/cloud.png")]  var   res32:Class;
			[Embed("/bitmap/inv2_l.png")]  var   res33:Class;
			[Embed("/bitmap/inv2_r.png")]  var   res34:Class;
			[Embed("/bitmap/rollee_a.png")]  var   res35:Class;
			[Embed("/bitmap/rollee_b.png")]  var   res36:Class;
			
			[Embed("/bitmap/flyer_white_l.png")]  var   res37:Class;
			[Embed("/bitmap/flyer_white_r.png")]  var   res38:Class;
			[Embed("/bitmap/start_pause.png")]  var   res39:Class;
			
			[Embed("/bitmap/pyramiddoor0.png")]  var   res40:Class;
			[Embed("/bitmap/pyramiddoor1.png")]  var   res41:Class;
			[Embed("/bitmap/pyramiddoor2.png")]  var   res42:Class;
			[Embed("/bitmap/pyramiddoor3.png")]  var   res43:Class;
			[Embed("/bitmap/pyramiddoor4.png")]  var   res44:Class;
			
			[Embed("/bitmap/g_climb1.png")]  var   res45:Class;
			[Embed("/bitmap/g_climb2.png")]  var   res46:Class;
			[Embed("/bitmap/g_punchl1.png")]  var   res47:Class;
			[Embed("/bitmap/g_punchl2.png")]  var   res48:Class;
			[Embed("/bitmap/g_punchr1.png")]  var   res49:Class;
			[Embed("/bitmap/g_punchr2.png")]  var   res50:Class;
			[Embed("/bitmap/g_stepl1.png")]  var   res51:Class;
			[Embed("/bitmap/g_stepl2.png")]  var   res52:Class;
			[Embed("/bitmap/g_stepr1.png")]  var   res53:Class;
			[Embed("/bitmap/g_stepr2.png")]  var   res54:Class;
			
			[Embed("/bitmap/crawler_l1.png")]  var   res55:Class;
			[Embed("/bitmap/crawler_l2.png")]  var   res56:Class;
			[Embed("/bitmap/crawler_r1.png")]  var   res57:Class;
			[Embed("/bitmap/crawler_r2.png")]  var   res58:Class;
		
			[Embed("/bitmap/gater_punch_l1.png")]  var   res59:Class;
			[Embed("/bitmap/gater_punch_l2.png")]  var   res60:Class;
			[Embed("/bitmap/gater_punch_r1.png")]  var   res61:Class;
			[Embed("/bitmap/gater_punch_r2.png")]  var   res62:Class;
			[Embed("/bitmap/bunker.png")]  var   res63:Class;
			[Embed("/bitmap/astrogate.png")]  var   res64:Class;
			[Embed("/bitmap/g_stepl3.png")]  var   res65:Class;
			[Embed("/bitmap/g_stepr3.png")]  var   res66:Class;
		
			[Embed("/bitmap/g_shootl1.png")]  var   res67:Class;
			[Embed("/bitmap/g_shootl2.png")]  var   res68:Class;
			[Embed("/bitmap/g_shootr1.png")]  var   res69:Class;
			[Embed("/bitmap/g_shootr2.png")]  var   res70:Class;
		
			[Embed("/bitmap/platform.png")]  var   res71:Class;
			[Embed("/bitmap/arrow_d.png")]  var   res72:Class;
			[Embed("/bitmap/arrow_l.png")]  var   res73:Class;
			[Embed("/bitmap/arrow_r.png")]  var   res74:Class;
			[Embed("/bitmap/arrow_u.png")]  var   res75:Class;
			[Embed("/bitmap/start_controls.png")]  var   res76:Class;
		
			[Embed("/bitmap/g_crouchl1.png")]  var   res77:Class;
			[Embed("/bitmap/g_crouchr1.png")]  var   res78:Class;
		
			[Embed("/bitmap/g_stepl4.png")]  var   res79:Class;
			[Embed("/bitmap/g_stepl5.png")]  var   res80:Class;
			[Embed("/bitmap/g_stepl6.png")]  var   res81:Class;
			[Embed("/bitmap/g_stepl7.png")]  var   res82:Class;
			[Embed("/bitmap/g_stepl8.png")]  var   res83:Class;
		
			[Embed("/bitmap/g_stepr4.png")]  var   res84:Class;
			[Embed("/bitmap/g_stepr5.png")]  var   res85:Class;
			[Embed("/bitmap/g_stepr6.png")]  var   res86:Class;
			[Embed("/bitmap/g_stepr7.png")]  var   res87:Class;
			[Embed("/bitmap/g_stepr8.png")]  var   res88:Class;
		
			[Embed("/bitmap/gunsmall.png")]  var   res89:Class;
			[Embed("/bitmap/key_blue.png")]  var   res90:Class;
			[Embed("/bitmap/key_green.png")]  var   res91:Class;
			[Embed("/bitmap/key_red.png")]  var   res92:Class;
			[Embed("/bitmap/keysmall_blue.png")]  var   res93:Class;
			[Embed("/bitmap/keysmall_green.png")]  var   res94:Class;
			[Embed("/bitmap/keysmall_red.png")]  var   res95:Class;
		
			[Embed("/bitmap/door_blue.png")]  var   res96:Class;
			[Embed("/bitmap/door_green.png")]  var   res97:Class;
			[Embed("/bitmap/door_red.png")]  var   res98:Class;
			
			
			// list resources needed...
			neededRes.push( new Array ( new res00(), R_XML));
			neededRes.push( new Array ( new res01(), R_BITMAP));
			
			neededRes.push( new Array ( new res02(), R_BITMAP));
			neededRes.push( new Array ( new res03(), R_BITMAP));
			neededRes.push( new Array ( new res04(), R_BITMAP));
			neededRes.push( new Array ( new res05(), R_BITMAP));
			neededRes.push( new Array ( new res06(), R_BITMAP));
			neededRes.push( new Array ( new res07(), R_BITMAP));
			neededRes.push( new Array ( new res08(), R_BITMAP));
			neededRes.push( new Array ( new res09(), R_BITMAP));
			neededRes.push( new Array ( new res10(), R_BITMAP));
			neededRes.push( new Array ( new res11(), R_BITMAP));
			neededRes.push( new Array ( new res12(), R_BITMAP));
			neededRes.push( new Array ( new res13(), R_BITMAP));

			neededRes.push( new Array ( new res14(), R_SOUND));
			neededRes.push( new Array ( new res15(), R_SOUND));
			neededRes.push( new Array ( new res16(), R_SOUND));
			neededRes.push( new Array ( new res17(), R_SOUND));
			neededRes.push( new Array ( new res18(), R_SOUND));
			neededRes.push( new Array ( new res19(), R_SOUND));
			neededRes.push( new Array ( new res20(), R_SOUND));
			neededRes.push( new Array ( new res21(), R_SOUND));
			neededRes.push( new Array ( new res22(), R_SOUND));
			neededRes.push( new Array ( new res23(), R_SOUND));
			
			neededRes.push( new Array ( new res24(), R_BITMAP));
			neededRes.push( new Array ( new res25(), R_BITMAP));
			neededRes.push( new Array ( new res26(), R_BITMAP));
			neededRes.push( new Array ( new res27(), R_BITMAP));
			neededRes.push( new Array ( new res28(), R_BITMAP));
			neededRes.push( new Array ( new res29(), R_BITMAP));
			neededRes.push( new Array ( new res30(), R_BITMAP));
			neededRes.push( new Array ( new res31(), R_BITMAP));
			neededRes.push( new Array ( new res32(), R_BITMAP));
			neededRes.push( new Array ( new res33(), R_BITMAP));
			neededRes.push( new Array ( new res34(), R_BITMAP));
			neededRes.push( new Array ( new res35(), R_BITMAP));
			neededRes.push( new Array ( new res36(), R_BITMAP));
			neededRes.push( new Array ( new res37(), R_BITMAP));
			neededRes.push( new Array ( new res38(), R_BITMAP));
			neededRes.push( new Array ( new res39(), R_BITMAP));

			neededRes.push( new Array ( new res40(), R_BITMAP_WBLACK));
			neededRes.push( new Array ( new res41(), R_BITMAP_WBLACK));
			neededRes.push( new Array ( new res42(), R_BITMAP_WBLACK));
			neededRes.push( new Array ( new res43(), R_BITMAP_WBLACK));
			neededRes.push( new Array ( new res44(), R_BITMAP_WBLACK));

			neededRes.push( new Array ( new res45(), R_BITMAP_WBLACK));
			neededRes.push( new Array ( new res46(), R_BITMAP_WBLACK));
			neededRes.push( new Array ( new res47(), R_BITMAP_WBLACK));
			neededRes.push( new Array ( new res48(), R_BITMAP_WBLACK));
			neededRes.push( new Array ( new res49(), R_BITMAP_WBLACK));
			neededRes.push( new Array ( new res50(), R_BITMAP_WBLACK));
			neededRes.push( new Array ( new res51(), R_BITMAP_WBLACK));
			neededRes.push( new Array ( new res52(), R_BITMAP_WBLACK));
			neededRes.push( new Array ( new res53(), R_BITMAP_WBLACK));
			neededRes.push( new Array ( new res54(), R_BITMAP_WBLACK));

			neededRes.push( new Array ( new res55(), R_BITMAP_WBLACK));
			neededRes.push( new Array ( new res56(), R_BITMAP_WBLACK));
			neededRes.push( new Array ( new res57(), R_BITMAP_WBLACK));
			neededRes.push( new Array ( new res58(), R_BITMAP_WBLACK));
			neededRes.push( new Array ( new res59(), R_BITMAP_WBLACK));
			neededRes.push( new Array ( new res60(), R_BITMAP_WBLACK));
			neededRes.push( new Array ( new res61(), R_BITMAP_WBLACK));
			neededRes.push( new Array ( new res62(), R_BITMAP_WBLACK));
			neededRes.push( new Array ( new res63(), R_BITMAP_WBLACK));
			neededRes.push( new Array ( new res64(), R_BITMAP));
			neededRes.push( new Array ( new res65(), R_BITMAP_WBLACK));
			neededRes.push( new Array ( new res66(), R_BITMAP_WBLACK));

			neededRes.push( new Array ( new res67(), R_BITMAP_WBLACK));
			neededRes.push( new Array ( new res68(), R_BITMAP_WBLACK));
			neededRes.push( new Array ( new res69(), R_BITMAP_WBLACK));
			neededRes.push( new Array ( new res70(), R_BITMAP_WBLACK));

			neededRes.push( new Array ( new res71(), R_BITMAP_WBLACK));
			neededRes.push( new Array ( new res72(), R_BITMAP_WBLACK));
			neededRes.push( new Array ( new res73(), R_BITMAP_WBLACK));
			neededRes.push( new Array ( new res74(), R_BITMAP_WBLACK));
			neededRes.push( new Array ( new res75(), R_BITMAP_WBLACK));
			neededRes.push( new Array ( new res76(), R_BITMAP_WBLACK));
			
			neededRes.push( new Array ( new res77(), R_BITMAP_WBLACK));
			neededRes.push( new Array ( new res78(), R_BITMAP_WBLACK));

			neededRes.push( new Array ( new res79(), R_BITMAP_WBLACK));
			neededRes.push( new Array ( new res80(), R_BITMAP_WBLACK));
			neededRes.push( new Array ( new res81(), R_BITMAP_WBLACK));
			neededRes.push( new Array ( new res82(), R_BITMAP_WBLACK));
			neededRes.push( new Array ( new res83(), R_BITMAP_WBLACK));

			neededRes.push( new Array ( new res84(), R_BITMAP_WBLACK));
			neededRes.push( new Array ( new res85(), R_BITMAP_WBLACK));
			neededRes.push( new Array ( new res86(), R_BITMAP_WBLACK));
			neededRes.push( new Array ( new res87(), R_BITMAP_WBLACK));
			neededRes.push( new Array ( new res88(), R_BITMAP_WBLACK));

			neededRes.push( new Array ( new res89(), R_BITMAP));
			neededRes.push( new Array ( new res90(), R_BITMAP));
			neededRes.push( new Array ( new res91(), R_BITMAP));
			neededRes.push( new Array ( new res92(), R_BITMAP));
			neededRes.push( new Array ( new res93(), R_BITMAP));
			neededRes.push( new Array ( new res94(), R_BITMAP));
			neededRes.push( new Array ( new res95(), R_BITMAP));

			neededRes.push( new Array ( new res96(), R_BITMAP));
			neededRes.push( new Array ( new res97(), R_BITMAP));
			neededRes.push( new Array ( new res98(), R_BITMAP));
			
			
			if (this.i >= this.neededRes.length) {
				launchNextPhase();
			}
			else {
				
				getResEmbed(neededRes[i][1], neededRes[i][0]);
			}
		}
		
		public function getResEmbed(resType:int, resUrl:Object) {

			startMessage += ".";
			this.format.color = 0x00ffffff;
			this.format.font = "Courier";
			this.format.bold = true;
			this.textField.width = 1000;
			this.textField.x = 10;
			this.textField.y = 10;
			this.textField.text = startMessage;
			this.textField.setTextFormat(this.format);
			
			
			r_type = resType;
			finishResEmbed(resUrl);
			
		
		}
		public function finishResEmbed(e:Object):void {
		
			//
			switch (r_type) {
				case AGResources.R_SPRITE:
				//sprite
					var bitmap:BitmapData;
					bitmap = Bitmap(e).bitmapData;
					r_sprite = new Sprite();
					r_sprite.graphics.beginBitmapFill(bitmap, null, false, false);
					r_sprite.graphics.drawRect(0,0, bitmap.width, bitmap.height);
					r_sprite.graphics.endFill();
					
					myRes.push(r_sprite);
				break;
				case AGResources.R_BITMAP:
					//r_bitmap = Bitmap(LoaderInfo(e.target).content);
					r_bitmap = Bitmap(e);
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
				case AGResources.R_BITMAP_WBLACK:
					//r_bitmap = Bitmap(LoaderInfo(e.target).content);
					r_bitmap = Bitmap(e);
					myRes.push(r_bitmap);
				break;
				
				case AGResources.R_SOUND:
				//sound
					r_sound = Sound(e);
					//r_sound.load( new URLRequest(r_url));
					//r_sound.load(e);
					//r_sound.addEventListener(Event.COMPLETE, finishRes);
					myRes.push(new AGSound(r_sound, myKeys[myKeyStage.keycodeQuiet]));
					
				break;
			
				case AGResources.R_XML:
				//xml
					
					//this.myFileStream.readBytes(bytes);
					
					//loader.loadBytes(bytes);
					//loader.contentLoaderInfo.addEventListener(Event.COMPLETE, xmlComplete);
					
					
					r_xml = new XMLDocument();
					//
					r_xml.ignoreWhite = true;
					r_xml.parseXML(e.toString());
					//trace(r_xml);
					myRes.push(r_xml);
					//trace(r_xml, "some value ------------");//]  var   res00:Class;
					
					
				break;
				
			}
			i ++;
			importRes();
		}
		
		public override function launchNextPhase():void {
			trace("really done android");//]  var   res00:Class;
			
			var game:AGGame = new AGGame(myStage, myKeyStage, myKeys, myRes);
		}

	}
	
}
