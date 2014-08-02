package  
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	
	/**
	 * ...
	 * @author Ben Kuper
	 */
	public class Button extends Sprite 
	{
		
		public function Button(bm:Bitmap) 
		{
			addChild(bm);
			bm.x = -bm.width / 2;
			bm.y = -bm.height / 2;
			super();
			
			mouseChildren = false;
			
		}
		
	}

}