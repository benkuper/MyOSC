package  
{
	import com.greensock.easing.Back;
	import com.greensock.easing.Strong;
	import com.greensock.TweenLite;
	import flash.display.Bitmap;
	import flash.display.Sprite;
	
	/**
	 * ...
	 * @author Ben Kuper
	 */
	public class Panel extends Sprite 
	{
		public var innerColor:uint;
		public var outerColor:uint;
		
		private var _innerCircleRad:Number;
		private var _outerCircleRad:Number;
		
		private var _opened:Boolean;
		
		protected var container:Sprite;
		
		public static const INNER_RADIUS:Number = 60;
		public static const OUTER_RADIUS:Number = 230;
		
		protected var logo:Bitmap;
		
		public function Panel(innerColor:uint,outerColor:uint) 
		{
			super();
			
			this.outerColor = outerColor;
			this.innerColor = innerColor;
			
			_innerCircleRad = 0;
			_outerCircleRad  = 0;
			
			container = new Sprite();
			addChild(container)
			
			draw();
		}
		
		
		public function draw():void
		{
			graphics.clear();
			graphics.beginFill(outerColor, .7);
			graphics.drawCircle(0, 0, outerCircleRad);
			graphics.endFill();
			
			
			graphics.beginFill(innerColor, 1);
			graphics.lineStyle(2, 0x666666, .7);
			graphics.drawCircle(0, 0, innerCircleRad);
			graphics.endFill();
		}
		
		
		public function get opened():Boolean 
		{
			return _opened;
		}
		
		public function set opened(value:Boolean):void 
		{
			_opened = value;
			TweenLite.to(this, .6, { outerCircleRad:value?OUTER_RADIUS:0, ease:value?Back.easeOut:Back.easeIn} );
			TweenLite.to(this, .5, { delay:.1, innerCircleRad:value?INNER_RADIUS:0, ease:Strong.easeOut } );
			TweenLite.to(this, .3, { alpha:value?1:0, ease:Strong.easeOut } );
		}
		
		public function get innerCircleRad():Number 
		{
			return _innerCircleRad;
		}
		
		public function set innerCircleRad(value:Number):void 
		{
			_innerCircleRad = value;
			draw();
		}
		
		public function get outerCircleRad():Number 
		{
			return _outerCircleRad;
		}
		
		public function set outerCircleRad(value:Number):void 
		{
			_outerCircleRad = value;
			draw();
		}
	}

}