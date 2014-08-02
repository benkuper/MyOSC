package 
{
	import assets.fonts.Fonts;
	import com.greensock.easing.Strong;
	import com.greensock.TweenLite;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.text.TextField;
	
	/**
	 * ...
	 * @author Ben Kuper
	 */
	public class Toaster extends Sprite
	{
		public static var instance:Toaster;
		
		
		static public const INFO:String = "info";
		static public const WARNING:String = "warning";
		static public const ERROR:String = "error";
		static public const SUCCESS:String = "success";
		
		private var tf:TextField;
		private var s:Stage;
		
		public function Toaster(s:Stage)
		{
			this.s = s;
			this.y = s.stageHeight;
			
			tf = Fonts.createTF("Toaster !", Fonts.blackTF);
			addChild(tf);
			tf.selectable = false;
		}
		
		public function notif(text:String, type:String = INFO):void
		{
			s.addChild(this);
			
			tf.text = text;
			tf.x = -tf.textWidth / 2;
			this.x = stage.stageWidth / 2;
			tf.textColor = 0x333333;
			
			var targetColor:uint = 0xffffff;
			switch (type)
			{
				case INFO: 
					targetColor = 0xbbbbbb;
					tf.textColor = 0x555555;
					break;
				
				case WARNING: 
					targetColor = 0xFAD34E;
					tf.textColor = 0xFF6B09;
					break;
				
				case ERROR: 
					targetColor = 0xF75151;
					tf.textColor = 0xB51111;
					break;
				
				case SUCCESS: 
					targetColor = 0xA4DD6A;
					tf.textColor = 0x547E05
					break;
			}
			graphics.clear();
			graphics.beginFill(targetColor);
			graphics.drawRoundRect(tf.x - 10, tf.y - 5, tf.width + 20, tf.height + 10,5,5);
			graphics.endFill();
			
			this.x = s.stageWidth / 2;
			
			TweenLite.killDelayedCallsTo(close);
			TweenLite.killTweensOf(this);
			
			TweenLite.to(this, .5, { y: stage.stageHeight - this.height - 40, ease: Strong.easeOut } );
			TweenLite.delayedCall(3, close);
		}
		
		public function close():void
		{
			TweenLite.to(this, .5, {y: stage.stageHeight+20, ease: Strong.easeOut,onComplete:clean});
		}
		
		public function clean():void
		{
			if (this.parent == s) s.removeChild(this);
		}
		
		public static function init(s:Stage):void
		{
			if (instance != null) return;
			instance = new Toaster(s);
		}
		
		public static function info(text:String):void
		{
			if (instance == null) return;
			instance.notif(text, INFO);
		}
		
		public static function warning(text:String):void
		{
			if (instance == null) return;
			instance.notif(text, WARNING);
		}
		
		public static function error(text:String):void
		{
			if (instance == null) return;
			instance.notif(text, ERROR);
		}
		
		public static function success(text:String):void
		{
			if (instance == null) return;
			instance.notif(text, SUCCESS);
		}
	
	}

}