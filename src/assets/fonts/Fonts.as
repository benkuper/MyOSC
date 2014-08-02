package assets.fonts 
{
	import flash.text.Font;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	/**
	 * ...
	 * @author Ben Kuper
	 */
	public class Fonts 
	{
		
		[Embed(source = "Yanone.ttf",
		fontName = "Yanone", 
		mimeType = "application/x-font", 
		fontWeight="normal", 
		fontStyle="normal", 
		advancedAntiAliasing="true", 
		embedAsCFF = "false"
		)]
		public var Yanone:Class;
		
		public static var normalTF:TextFormat;
		public static var buttonTF:TextFormat;
		public static var bigTF:TextFormat;
		public static var blackTF:TextFormat;
		static public var normalCenterTF:TextFormat;
		static public var guideTF:TextFormat;
		static public var smallGreyTF:TextFormat;
		
		public function Fonts() 
		{
			
		}
		
		public static function init():void
		{
			normalTF = new TextFormat("Yanone", 16, 0xffffff);
			normalCenterTF = new TextFormat("Yanone", 16, 0xffffff);
			normalCenterTF.align = TextFormatAlign.CENTER;
			buttonTF = new TextFormat("Yanone", 16, 0xefefef);
			bigTF = new TextFormat("Yanone", 20, 0xefefef);
			blackTF = new TextFormat("Yanone", 20, 0x222222);
			guideTF = new TextFormat("Yanone", 50, 0xF1FBFE);
			smallGreyTF = new TextFormat("Yanone", 15, 0x555555);
			
		}
		
		public static function createTF(text:String, format:TextFormat = null,align:String = TextFieldAutoSize.LEFT,type:String = TextFieldType.DYNAMIC):TextField
		{
			var t:TextField     = new TextField;
			t.embedFonts        = true; // very important to set
			t.autoSize          = align;
			format.align		= align;
			if(format != null)	t.defaultTextFormat = format;
			t.text              = text;
			t.type = type;
			t.multiline  = false;
			
			return t;
		}
	}

}