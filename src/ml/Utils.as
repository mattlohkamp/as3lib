package ml	{	//	https://github.com/mattlohkamp/as3lib	Matt Lohkamp	work@mattlohkamp.com	mattlohkamp.com/portfolio
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.geom.Rectangle;
	import flash.text.Font;
	import flash.utils.describeType;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	import flash.utils.Dictionary;
	import flash.net.LocalConnection;
	import flash.system.System;
	import flash.display.MovieClip;

	public class Utils	{
		
			//	structure
		
			//	props to http://stackoverflow.com/a/748753/14026
		public static function isDynamic(target:*):Boolean	{	return describeType(target).@isDynamic.toString() == "true";	}
		
			//	data
		
		public static function stringToBool(target:String):Boolean	{
			if(target == '0')	return false;
			if(target.toLowerCase() == 'true')	return true;
			if(target == '')	return false;
			return false;
		}

		public static function roundTo(target:Number, decPlaces:uint):Number	{	//	rounding as opposed to cropping, as in: Number(target.toFixed(decPlaces))
			var exp:Number = Math.pow(10,decPlaces);
			return Math.round(target * exp) / exp;
		}		
		
		public static function mergeXMLNode(base:XML, mod:XML, useModChildren:Boolean = true):XML	{	//	merge attriutes and values of two xml nodes - mod will overwrite base, returns *new* xml
			var result:XML = new XML(base);
			var attributes:XMLList = mod.attributes();	//	mod attributes
			for(var i:String in attributes){	result.@[attributes[i].name()] = attributes[i].toString();	}	//	overwrite node attributes
			if(useModChildren){
				var modChildren:XMLList = mod.children();
				if(modChildren.length()){	result.setChildren(modChildren);	}	//	overwrite node content
			}
			return result;
		}
		
		public static function objectMerge(base:Object, mod:Object):Object	{	//	mod properties will overwrite base, returns *new* object
			var result:Object = new Object();
			var prop:String;
			for(prop in base){	result[prop] = base[prop];	}
			for(prop in mod){	result[prop] = mod[prop];	}
			return result;
		}
		
		public static function propsTo(base:*, mod:Object):void	{	//	similar to objectMerge, but effects the actual target and respects typing
			for(var prop:String in mod){	if(base.hasOwnProperty(prop) || isDynamic(base))	base[prop] = mod[prop];	}
		}
		
		public static function vectorToArray(vector:*):Array	{	//	opposite:	Vector.<Class>([a,b,c]);
			var array:Array = new Array();
			for (var i:int = 0; i < vector.length; ++i)	{	array[i] = vector[i];	}
			return array;
		}
		
		public static function count(target:Object):uint	{	//	mostly for counting the number of values of an associative array
			var len:uint = new uint();
			for(var prop:* in target){	len++;	}
			return len;
		}
		
		public static function arrayValues(array:Array):Array	{	//	returns the keys of an array, as an array
			var newArray:Array = new Array();
			for(var prop:* in array){	newArray.push(array[prop]);	}
			return newArray;
		}
		
			//	typography
		
		public static function tryFonts(text:String,...fontNames:Array):String	{	//	specifically to try a css-style list of fonts  names, and return the winning name
			var fonts:Vector.<Font> = new Vector.<Font>();
			for each(var fontName:String in fontNames){
				var font:Font = getFontByName(fontName);
				fonts.push(font);
			}
			var fallbackFont:Font = findFallbackFont(fonts,text);
			return fallbackFont.fontName;
		}
		
		public static function findFallbackFont(fontList:Vector.<Font>,text:String):Font	{	//	an array of Font.hasGlyphs() tests
			for each(var font:Font in fontList){
				if(font){
					if(font.hasGlyphs(text)){
						return font;
					}
				}
			}
			return fontList.pop();	//	fall back on the last item in the list
		}
		
		public static function getFontByName(fontName:String):Font	{	//	the opposite of Font.fontName
			for each(var font:Font in Font.enumerateFonts()){
				if (fontName == font.fontName) {	return font;	}	//	font names are case sensitive note
			}
			return null;
		}
		
			//	position & layout
			
		public static function bringToTop(target:DisplayObject):void{	//	position an element above its siblings
			target.parent.setChildIndex(target,target.parent.numChildren-1);
		}
		
		public static function rectify(target:*):Rectangle	{	//	build a rectangle out of a display object
			return new Rectangle(
				(target.hasOwnProperty('x')) ? target.x : 0,
				(target.hasOwnProperty('y')) ? target.y : 0,
				(target.hasOwnProperty('width')) ? target.width : 0,
				(target.hasOwnProperty('height')) ? target.height : 0
			);
		}
		
		public static function getCenteredOffset(innerLength:Number,outerPos:Number,outerLength:Number):Number	{	return outerPos + ((outerLength - innerLength) / 2);	}
		
		public static function centerInside(target:*, area:Rectangle, width:Boolean = true, height:Boolean = true):void {	//	shortcut the usual half minus width equation
			if(width)	target.x = getCenteredOffset(target.width,area.x,area.width);
			if(height)	target.y = getCenteredOffset(target.height,area.y,area.height);
		}
		
			//	returns a scale value to be applied to scaleX and scaleY, such that the object fits as defined by cropToFit
		public static function get2DScaleRatio(innerWidth:Number, innerHeight:Number, outerWidth:Number, outerHeight:Number, letterbox:Boolean = false):Number	{
			var wRatio:Number = outerWidth / innerWidth;
			var hRatio:Number = outerHeight / innerHeight;
			return (letterbox) ? ((wRatio < hRatio) ? wRatio : hRatio) : ((wRatio > hRatio) ? wRatio : hRatio);
		}
		
		public static function scaleToFit(inner:DisplayObject, outer:*, letterbox:Boolean = false, centerInnerInOuter:Boolean = true):Number	{
			inner.scaleX = inner.scaleY = get2DScaleRatio(inner.width,inner.height,outer.width,outer.height,letterbox);
			if(centerInnerInOuter)	centerInside(inner, rectify(outer));
			return inner.scaleX;	//	convenience, so we don't have to save the return of 
		}
		
		public static function killAllChildren(collection:*):void	{
			var displayObject:DisplayObject;
			if(collection is DisplayObjectContainer){
				collection.stopAllMovieClips();
				while(collection.numChildren)	collection.removeChild(collection.getChildAt(0));
			}else if(collection is Vector || collection is Array){
				while(collection.length){
					displayObject = collection.pop();
					if(displayObject is MovieClip)	MovieClip(displayObject).stop();
					if(displayObject.parent)	displayObject.parent.removeChild(displayObject);
				}
			}else if(collection is Object){
				//	todo
			}else if(collection is Dictionary){
				//	todo
			}
		}
		
			//	other
		
		public static function forceGC():void	{
			try	{	//	hax
				new LocalConnection().connect('foo');
				new LocalConnection().connect('foo');
			}catch(e:*){}
			
			try	{	//	requires AIR
				System.gc();
			}catch(e:*){}
			
		}
	}
}