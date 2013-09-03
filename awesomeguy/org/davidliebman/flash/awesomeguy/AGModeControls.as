package  org.davidliebman.flash.awesomeguy{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.text.*;
	import flash.events.*;
	import fl.motion.MotionEvent;
	import flash.display.BitmapData;
	
	
	public class AGModeControls extends AGMode {

		var arrowBoxL:TextField = new TextField();
		var arrowBoxR:TextField = new TextField();
		var arrowBoxU:TextField = new TextField();
		var arrowBoxD:TextField = new TextField();
		var arrowBoxShoot:TextField = new TextField();
		var arrowBoxJump:TextField = new TextField();

		var arrowButL:Sprite = new Sprite();
		var arrowButR:Sprite = new Sprite();
		var arrowButU:Sprite = new Sprite();
		var arrowButD:Sprite = new Sprite();
		var arrowButShoot:Sprite = new Sprite();
		var arrowButJump:Sprite = new Sprite();

		var myTextBox:TextField = new TextField();
		var myTextOut:TextField = new TextField();
		var myTextJump:TextField = new TextField();
		var myTextShoot:TextField = new TextField();
		
		var myFormat:TextFormat = new TextFormat();
		var myBitmap:Bitmap = new Bitmap();
		var myBitmap2:Bitmap = new Bitmap();
		
		static var INPUT_LEVEL:int = 1;
		static var INPUT_UP:int = 2;
		static var INPUT_DOWN:int = 3;
		static var INPUT_LEFT:int = 4;
		static var INPUT_RIGHT:int = 5;
		static var INPUT_JUMP:int = 6;
		static var INPUT_SHOOT:int = 7;
		
		var input:int = 0;

		public function AGModeControls() {
			// constructor code
		}

		public override function doOnce():void {
			showSign();
			
			myBitmap = new Bitmap(new BitmapData(20,20,false,0xaaaaaa));
			myBitmap2 = new Bitmap(new BitmapData(20,20,false,0xaaaaaa));
			
			myFormat.bold = true;
			myFormat.font = "Courier";
			myTextBox.restrict = "0-9";
			myTextBox.setTextFormat(myFormat);
			myTextBox.text = "000";
			myTextBox.textColor = 0x00;
			myTextBox.thickness = 2;
			myTextBox.type = TextFieldType.INPUT;
			myTextBox.backgroundColor = 0xaaaaaa;
			myTextBox.x = 20;
			myTextBox.y = 130;
			myTextBox.height = 20;
			myTextBox.width = 30;
			myTextBox.background = true;
			myTextBox.border = true;
			myTextBox.addEventListener(TextEvent.TEXT_INPUT,doTextInput);
			
			this.doArrowBoxFormat(this.arrowBoxD);
			this.doArrowBoxFormat(this.arrowBoxL);
			this.doArrowBoxFormat(this.arrowBoxR);
			this.doArrowBoxFormat(this.arrowBoxU);
			this.doArrowBoxFormat(this.arrowBoxJump);
			this.doArrowBoxFormat(this.arrowBoxShoot);
			
			this.doArrowBoxFormat(this.myTextJump);
			this.doArrowBoxFormat(this.myTextShoot);
			
			this.myTextJump.text = "jump";
			this.myTextJump.mouseEnabled=false;
			this.myTextJump.x = 0;
			this.myTextJump.y = 0;
			
			this.myTextShoot.text = "shoot";
			this.myTextShoot.mouseEnabled = false;
			this.myTextShoot.x = 0;
			this.myTextShoot.y = 0;
			
			this.arrowBoxD.x = 100;
			this.arrowBoxD.y = 130;			
			
			this.arrowBoxL.x = 150;
			this.arrowBoxL.y = 130;
			
			this.arrowBoxR.x = 200;
			this.arrowBoxR.y = 130;
			
			this.arrowBoxU.x = 250;
			this.arrowBoxU.y = 130;
			
			this.arrowBoxJump.x = 300;
			this.arrowBoxJump.y = 130;
			
			this.arrowBoxShoot.x = 350;
			this.arrowBoxShoot.y = 130;
			
			//myStage.addChild(this.arrowBoxD);
			this.doArrowSpriteFormat(this.arrowButD, myRes[AGResources.NAME_ARROW_D_PNG]);
			this.arrowButD.x = 100;
			this.arrowButD.y = 160;
			this.arrowButD.addEventListener(MouseEvent.CLICK, doInputD);
			
			this.doArrowSpriteFormat(this.arrowButL, myRes[AGResources.NAME_ARROW_L_PNG]);
			this.arrowButL.x = 150;
			this.arrowButL.y = 160;
			this.arrowButL.addEventListener(MouseEvent.CLICK, doInputL);

			
			this.doArrowSpriteFormat(this.arrowButR, myRes[AGResources.NAME_ARROW_R_PNG]);
			this.arrowButR.x = 200;
			this.arrowButR.y = 160;
			this.arrowButR.addEventListener(MouseEvent.CLICK, doInputR);


			this.doArrowSpriteFormat(this.arrowButU, myRes[AGResources.NAME_ARROW_U_PNG]);
			this.arrowButU.x = 250;
			this.arrowButU.y = 160;
			this.arrowButU.addEventListener(MouseEvent.CLICK, doInputU);


			this.doArrowSpriteFormat(this.arrowButJump, this.myBitmap);
			this.arrowButJump.x = 300;
			this.arrowButJump.y = 160;
			this.arrowButJump.addChild(this.myTextJump);
			this.arrowButJump.addEventListener(MouseEvent.CLICK, doInputJump);


			this.doArrowSpriteFormat(this.arrowButShoot, this.myBitmap2);
			this.arrowButShoot.x = 350;
			this.arrowButShoot.y = 160;
			this.arrowButShoot.addChild(this.myTextShoot);
			this.arrowButShoot.addEventListener(MouseEvent.CLICK, doInputShoot);
			
			this.doArrowBoxFormat(this.myTextOut);
			this.myTextOut.x = 200;
			this.myTextOut.y = 200;
			//myStage.addChild(myTextBox);
		}
		public override function componentsInOrder():void {
			showSign();
			myStage.addChild(myTextBox);
			myStage.addChild(this.arrowBoxD);
			myStage.addChild(this.arrowBoxL);
			myStage.addChild(this.arrowBoxR);
			myStage.addChild(this.arrowBoxU);
			myStage.addChild(this.arrowBoxJump);
			myStage.addChild(this.arrowBoxShoot);
			
			myStage.addChild(this.arrowButD);
			myStage.addChild(this.arrowButL);
			myStage.addChild(this.arrowButR);
			myStage.addChild(this.arrowButU);
			myStage.addChild(this.arrowButJump);
			myStage.addChild(this.arrowButShoot);
			
			myStage.addChild(this.myTextOut);
			
			this.arrowBoxD.text = myGame.myKeyStage.keycodeDown.toString();
			this.arrowBoxL.text = myGame.myKeyStage.keycodeLeft.toString();
			this.arrowBoxR.text = myGame.myKeyStage.keycodeRight.toString();
			this.arrowBoxU.text = myGame.myKeyStage.keycodeUp.toString();
			this.arrowBoxShoot.text = myGame.myKeyStage.keycodeShoot.toString();
			this.arrowBoxJump.text = myGame.myKeyStage.keycodeJump.toString();
		}

		public function showSign():void {
			//super.componentsInOrder();
			var sign:Bitmap = myRes[AGResources.NAME_START_CONTROLS_PNG];
			sign.x = 0;
			sign.y = 0;
			myStage.addChild(sign);
			
		}

		public function doTextInput(e:TextEvent):void {
			
			this.myStage.addChild(this.myTextOut);
			input = INPUT_LEVEL;
		}

		public function doInputD(e:MouseEvent):void {
			input = INPUT_DOWN;
			this.clearAllBorders();
			this.arrowBoxD.border = true;
		}

		public function doInputL(e:MouseEvent):void {
			input = INPUT_LEFT;
			this.clearAllBorders();
			this.arrowBoxL.border = true;
		}
		public function doInputR(e:MouseEvent):void {
			input = INPUT_RIGHT;
			this.clearAllBorders();
			this.arrowBoxR.border = true;
		}
		public function doInputU(e:MouseEvent):void {
			input = INPUT_UP;
			this.clearAllBorders();
			this.arrowBoxU.border = true;
		}
		public function doInputJump(e:MouseEvent):void {
			input = INPUT_JUMP;
			this.clearAllBorders();
			this.arrowBoxJump.border = true;
		}
		public function doInputShoot(e:MouseEvent):void {
			input = INPUT_SHOOT;
			this.clearAllBorders();
			this.arrowBoxShoot.border = true;
		}

		

		public function clearAllBorders():void {
			this.arrowBoxD.border = false;
			this.arrowBoxJump.border = false;
			this.arrowBoxL.border = false;
			this.arrowBoxR.border = false;
			this.arrowBoxShoot.border = false;
			this.arrowBoxU.border = false;
			myStage.addEventListener(KeyboardEvent.KEY_DOWN, saveKey);
		}

		
		public function saveKey(e:KeyboardEvent):void {
			switch(input) {
				case INPUT_DOWN:
					myGame.myKeyStage.keycodeDown = e.keyCode;
					this.arrowBoxD.border = false;
				break;
				case INPUT_LEFT:
					myGame.myKeyStage.keycodeLeft = e.keyCode;
					this.arrowBoxL.border = false;
				break;
				case INPUT_RIGHT:
					myGame.myKeyStage.keycodeRight = e.keyCode;
					this.arrowBoxR.border = false;
				break;
				case INPUT_UP:
					myGame.myKeyStage.keycodeUp = e.keyCode;
					this.arrowBoxU.border = false;
				break;
				case INPUT_SHOOT:
					myGame.myKeyStage.keycodeShoot = e.keyCode;
					this.arrowBoxShoot.border = false;
				break;
				case INPUT_JUMP:
					myGame.myKeyStage.keycodeJump = e.keyCode;
					this.arrowBoxJump.border = false;
				break;
			}
			
			this.myTextOut.text = String.fromCharCode(e.charCode);
			myStage.removeEventListener(KeyboardEvent.KEY_DOWN, saveKey);
		}

		public function doArrowBoxFormat(box:TextField):void {
			myFormat.bold = true;
			myFormat.font = "Courier";
			//box.restrict = "0-9";
			box.setTextFormat(myFormat);
			box.text = "";
			box.textColor = 0x00;
			box.thickness = 2;
			box.borderColor = 0xff0000;
			box.backgroundColor = 0xaaaaaa;
			box.x = 20;
			box.y = 120;
			box.height = 20;
			box.width = 30;
			box.background = true;
			box.border = false;
		}

		public function doArrowSpriteFormat(box:Sprite, bits:Bitmap=null):void {
			box.buttonMode = true;
			box.addChild(bits);
		}
	}
	
}
