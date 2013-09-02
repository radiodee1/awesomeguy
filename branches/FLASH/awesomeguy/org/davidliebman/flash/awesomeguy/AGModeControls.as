package  org.davidliebman.flash.awesomeguy{
	import flash.display.Bitmap;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.text.*;
	import flash.events.*;
	
	public class AGModeControls extends AGMode {

		var myTextBox:TextField = new TextField();
		var myTextOut:TextField = new TextField();
		var myFormat:TextFormat = new TextFormat();

		public function AGModeControls() {
			// constructor code
		}

		public override function doOnce():void {
			showSign();
			
			myFormat.bold = true;
			myFormat.font = "Courier";
			myTextBox.restrict = "0-9";
			myTextBox.setTextFormat(myFormat);
			myTextBox.text = "000";
			myTextBox.textColor = 0x00;
			myTextBox.thickness = 2;
			myTextBox.type = TextFieldType.INPUT;
			myTextBox.backgroundColor = 0x00ff00;
			myTextBox.x = 20;
			myTextBox.y = 120;
			myTextBox.height = 20;
			myTextBox.width = 30;
			myTextBox.background = true;
			myTextBox.border = true;
			myTextBox.addEventListener(TextEvent.TEXT_INPUT,doTextInput);
			
			myStage.addChild(myTextBox);
		}
		public override function componentsInOrder():void {
			showSign();
			myStage.addChild(myTextBox);
		}

		public function showSign():void {
			//super.componentsInOrder();
			var sign:Bitmap = myRes[AGResources.NAME_START_CONTROLS_PNG];
			sign.x = 0;
			sign.y = 0;
			myStage.addChild(sign);
			
		}

		public function doTextInput(e:TextEvent):void {
			this.myTextOut.text = this.myTextBox.text;
			this.myStage.addChild(this.myTextOut);
			
		}

	}
	
}
