package  
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	
	/**
	 * ...
	 * @author Ben Kuper
	 */
	public class Button extends Sprite 
	{
		private var bm:Bitmap;
		
		public function Button(bm:Bitmap) 
		{
			this.bm = bm;
			addChild(bm);
			bm.x = -bm.width / 2;
			bm.y = -bm.height / 2;
			super();
			
			mouseChildren = false;
			
		}
		
		public function setBitmapData(data:BitmapData):void
		{
			bm.bitmapData = data;
			bm.x = -bm.width / 2;
			bm.y = -bm.height / 2;
		}
	}

}