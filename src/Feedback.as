package  
{
	import flash.display.Shape;
	import flash.display.Sprite;
	
	/**
	 * ...
	 * @author Ben Kuper
	 */
	public class Feedback extends Sprite 
	{
		public static const RADIUS:Number = 80;
		
		protected var enabled:Boolean;
		private var _selected:Boolean;
		
		public var inner:Sprite;
		public var innerMask:Shape;
		
		public function Feedback() 
		{
			super();
			innerMask = new Shape();
			addChild(innerMask);
			inner = new Sprite();
			addChild(inner);
			inner.mask = innerMask;
			draw();
			
		}
		
		protected function draw():void
		{
			innerMask.graphics.clear();
			innerMask.graphics.beginFill(0xff00ff);
			innerMask.graphics.drawCircle(0, 0, RADIUS);
			
			graphics.clear();
			if (selected) graphics.lineStyle(3, 0xffff00);
			else graphics.lineStyle(1, 0, .2);
			graphics.beginFill(0xE2E2E2);
			graphics.drawCircle(0, 0, RADIUS);
		}
		
		
		public function get selected():Boolean 
		{
			return _selected;
		}
		
		public function set selected(value:Boolean):void 
		{
			_selected = value;
			draw();
		}
		
		public function get id():String 
		{
			return "Feedback ID";
		}
	}

}