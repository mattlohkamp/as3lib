package ml	{
	
	import flash.display.Sprite;
	import flash.text.Font;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import ml.Fonts;
	
	/**
	 * ...
	 * @author mattlohkamp
	 */
	public class Main extends Sprite	{
		public static const fonts:Fonts = new Fonts();
		
		public function Main():void 	{
			trace('test');
			
			var bg:Sprite = new Sprite();
				bg.graphics.beginFill(0x0000ff);
				bg.graphics.drawRect(0, 0, 100, 100);
			addChild(bg);
			
			var cover:Sprite = new Sprite();
				cover.graphics.beginFill(0x00ff00, .9);
				cover.graphics.drawEllipse(0, 0, 50, 50);
			addChild(cover);
			
			var Swiss721RoundedBoldBT:Font = Utils.getFontByName('Swiss 721 Bold Rounded BT');
			
			var tf:TextField = new TextField();
			addChild(tf);
			tf.embedFonts = true;
			tf.autoSize = TextFieldAutoSize.LEFT;
				var format:TextFormat = tf.getTextFormat();
				format.font = Swiss721RoundedBoldBT.fontName;
				format.color = 0x112233;
				format.size = 36;
			tf.defaultTextFormat = format;
			tf.text = 'THIS is only A TEST';
			
			bg.width = tf.width + 20;
			bg.height = tf.height + 20;
			
			Utils.centerInside(tf, bg);
			
			Utils.scaleToFit(cover, bg);
			
			Utils.bringToTop(cover);
		}
	}
}