package ml	{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.geom.Rectangle;
	import flash.text.Font;

	public class Utils	{
		
			//	typography
		
		public static function findFallbackFont(fontList:Vector.<Font>,text:String):Font	{
			for each(var font:Font in fontList){
				if(font.hasGlyphs(text)){
					return font;
				}
			}
			return null;
		}

		public static function getFontByName(fontName:String):Font	{
			for each(var font:Font in Font.enumerateFonts()){
				if (fontName == font.fontName) {
					return font;
				}
			}
			return null;
		}
		
			//	position & layout
			
		public static function bringToTop(target:DisplayObject):void{
			target.parent.setChildIndex(target,target.parent.numChildren-1);
		}
			
		public static function centerInside(inner:DisplayObject, outer:DisplayObject, width:Boolean = true, height:Boolean = true):void {
			if (outer is DisplayObjectContainer) {
				if (DisplayObjectContainer(outer).contains(inner)) {
					throw new Error('error: ' + outer + ' contains ' + inner);
					return false;
				}
			}
			if (width)	inner.x = outer.x + ((outer.width - inner.width) / 2);
			if (height)	inner.y = outer.y + ((outer.height - inner.height) / 2);
		}
		public static function scaleToFit(inner:DisplayObject, outer:DisplayObject, letterBox:Boolean = true):Number	{
			var wRatio:Number = outer.width / inner.width;
			var hRatio:Number = outer.height / inner.height;
			var scale:Number = (wRatio < hRatio) ? wRatio : hRatio;
			inner.scaleX = inner.scaleY = scale;
			if (letterBox) centerInside(inner, outer);
			return scale;
		}
	}
}