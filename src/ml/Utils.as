package ml	{	//	https://github.com/mattlohkamp/as3lib	Matt Lohkamp	work@mattlohkamp.com	mattlohkamp.com/portfolio
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.geom.Rectangle;
	import flash.text.Font;
	import flash.utils.describeType;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;

	public class Utils	{
		
			//	data
		
		public static function mergeXMLNode(base:XML, mod:XML):XML	{	//	merge attriutes and values of two xml nodes - mod will overwrite base, returns *new* xml
			var result:XML = new XML(base);
			var attributes:XMLList = mod.attributes();	//	mod attributes
			for(var i:String in attributes){	result.@[attributes[i].name()] = attributes[i].toString();	}	//	overwrite node attributes
			var modFirstChild:XML = mod.children()[0];
			if(modFirstChild != XML(undefined)){	result.replace(0,modFirstChild);	}	//	overwrite node content
			return result;
		}
		
		public static function objectMerge(base:Object, mod:Object):Object	{	//	mod properties will overwrite base, returns *new* object
			var result:Object = new Object();
			var prop:String = new String();
			for(prop in base){	result[prop] = base[prop];	}
			for(prop in mod){	result[prop] = mod[prop];	}
			return result;
		}
		
		public static function vectorToArray(vector:*):Array	{	//	opposite:	Vector.<Class>([a,b,c]);
			var array:Array = new Array();
			for (var i:int = 0; i < vector.length; ++i)	{	array[i] = vector[i];	}
			return array;
		}
		
			//	typography
		
		public static function tryFonts(text:String,...fontNames:Array):String	{	//	specifically to try a css-style list of font names, and return the winning name
			var fonts:Vector.<Font> = new Vector.<Font>();
			for each(var fontName:String in fontNames){	fonts.push(getFontByName(fontName));	}
			return findFallbackFont(fonts,text).fontName;
		}
		
		public static function findFallbackFont(fontList:Vector.<Font>,text:String):Font	{
			for each(var font:Font in fontList){
				if(font){
					if(font.hasGlyphs(text)){
						return font;
					}
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
		
		public static function rectify(target:*):Rectangle	{
			return new Rectangle(
				(target.hasOwnProperty('x')) ? target.x : 0,
				(target.hasOwnProperty('y')) ? target.y : 0,
				(target.hasOwnProperty('width')) ? target.width : 0,
				(target.hasOwnProperty('height')) ? target.height : 0
			);
		}
		
		public static function centerInside(target:*, area:Rectangle, width:Boolean = true, height:Boolean = true):void {
			if (width)	target.x = area.x + ((area.width - target.width) / 2);
			if (height)	target.y = area.y + ((area.height - target.height) / 2);
		}
		public static function scaleToFit(inner:DisplayObject, outer:DisplayObject, letterBox:Boolean = true):Number	{
			var wRatio:Number = outer.width / inner.width;
			var hRatio:Number = outer.height / inner.height;
			var scale:Number = (wRatio < hRatio) ? wRatio : hRatio;
			inner.scaleX = inner.scaleY = scale;
			if (letterBox) centerInside(inner, rectify(outer));
			return scale;
		}
	}
}