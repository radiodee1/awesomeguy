package org.davidliebman.flash.droidbuttons {
	
	
	import org.davidliebman.flash.awesomeguy.*;
	import flash.filesystem.File;
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
	import flash.filesystem.*;
	
	public class AGButtonResources extends AGResources {
	
	var bytes:ByteArray = new ByteArray();
	var myFileStream:FileStream = new FileStream();
	var r_file:File = new File();

	var i:int = 0;
		
	var r_url:String = "";
	var r_type:int = 0;
	
	
	var r_sprite:Sprite = new Sprite();
	var r_sound:Sound = new Sound();
	var r_xml:XMLDocument = new XMLDocument();
	var r_bitmap:Bitmap = new Bitmap();

		public function AGButtonResources(mystage:Stage, keystage:AGKeys, keys:Array) {
			super(mystage, keystage, keys);
			// constructor code
		}
		
		public override function importRes():void {
			if (this.i >= this.neededRes.length) {
				launchNextPhase();
			}
			else {
				
				getRes(neededRes[i][0], neededRes[i][1]);
			}
		}
		
		public override function getRes(resType:int, resUrl:String) {

			startMessage += ".";
			this.format.color = 0x00ffffff;
			this.format.font = "Courier";
			this.format.bold = true;
			this.textField.width = 1000;
			this.textField.x = 10;
			this.textField.y = 10;
			this.textField.text = startMessage;
			this.textField.setTextFormat(this.format);
			
			
			var myFile:File ;//= new File().resolvePath("");
			
			resUrl = this.myKeyStage.prefix + resUrl;
			myFile = File.applicationDirectory;//new File(resUrl);
			r_file = myFile.resolvePath(resUrl);
			r_url = myFile.resolvePath(resUrl).url;//resUrl;
			r_type = resType;
			
			//myFile = new File(r_url);
			
			switch(r_type) {
				case AGResources.R_SPRITE:
				case AGResources.R_BITMAP:
				case AGResources.R_BITMAP_WBLACK:
					loader.load(new URLRequest(r_url));

					loader.contentLoaderInfo.addEventListener(Event.COMPLETE, finishRes);
					
					
				break;
				////////////////////////////////////
				case AGResources.R_SOUND:
					r_sound = new Sound();
					r_sound.load( new URLRequest(r_url));
					r_sound.addEventListener(Event.COMPLETE, finishRes);
					
				break;
				////////////////////////////////////
				case AGResources.R_XML:
					myFileStream.addEventListener(Event.COMPLETE, finishRes);
					myFileStream.openAsync(r_file, FileMode.READ);
					//uloader.addEventListener(Event.COMPLETE, finishRes);
					//uloader.load(new URLRequest(r_url));

				break;
				
				
			}

			
		}
		public override function finishRes(e:Event):void {
		
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
				case AGResources.R_BITMAP_WBLACK:
					r_bitmap = Bitmap(LoaderInfo(e.target).content);
					myRes.push(r_bitmap);
				break;
				
				case AGResources.R_SOUND:
				//sound
					
					myRes.push(new AGSound(r_sound, myKeys[myKeyStage.keycodeQuiet]));
					
				break;
			
				case AGResources.R_XML:
				//xml
					
					this.myFileStream.readBytes(bytes);
					loader.loadBytes(bytes);
					loader.contentLoaderInfo.addEventListener(Event.COMPLETE, xmlComplete);
					
					function xmlComplete(e:Event):void {
						r_xml = new XMLDocument();
						//trace("r_xml");
						r_xml.ignoreWhite = true;
						//r_xml.parseXML(loader.content);
						//trace(r_xml);
						myRes.push(r_xml);
						trace(r_xml, "some value ------------");
					}
					
				break;
				
			}
			i ++;
			this.importRes();
		}
		
		public override function launchNextPhase():void {
			trace("really done android");
			
			var game:AGGame = new AGGame(myStage, myKeyStage, myKeys, myRes);
		}

	}
	
}
