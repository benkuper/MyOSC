package  
{
	import benkuper.nativeExtensions.NativeSerial;
	import flash.display.Graphics;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	/**
	 * ...
	 * @author Ben Kuper
	 */
	public class GloveFeedback extends Feedback
	{
		private var serial:NativeSerial;
		
		public function GloveFeedback(serial:NativeSerial) 
		{
			super();
			this.serial = serial;
			draw();
			
		}
		
		
		private function drawArc(g:Graphics, center:Point, radius:Number, startAngle:Number, endAngle:Number, precision:Number = 1):void
		{
			
            var angle_diff:Number =endAngle-startAngle
            var steps:int = Math.abs(Math.round(angle_diff * precision));
			var deg_to_rad:Number = Math.PI / 180;
            var angle:Number = startAngle;
            var px:Number =center.x+radius*Math.cos(angle*deg_to_rad);
            var py:Number =center.y+radius*Math.sin(angle*deg_to_rad);
           g.moveTo(px, py);
			
            for (var i:int=1; i<=steps; i++) {
                angle = startAngle+angle_diff / steps * i;
                g.lineTo(center.x + radius * Math.cos(angle * deg_to_rad), center.y+ radius * Math.sin(angle * deg_to_rad));
            }
        }
		
		//HANDLERS
		
		private function rightClick(e:MouseEvent):void 
		{
			//offsetYaw = myo.yaw;
		}
		
		private function orientationUpdate():void 
		{
			if (!enabled) return;
			
			
			////trace("Orientation update !", myo.yaw, myo.pitch, myo.roll);
			//inner.rotation = correctedYaw * 180 / Math.PI + 90; // arm upward is 0
			//
			//var reversed:Boolean =  Math.abs(myo.roll) > Math.PI / 2;
			//
			//lines.graphics.clear();
			//
			//lines.graphics.lineStyle(3, 0xC42802);
			//drawArc(lines.graphics, new Point(), RADIUS, -90, -myo.roll * 180 / Math.PI - 90);
			//
			//lines.graphics.lineStyle(3, reversed?0x46B517:0x06A9CC);
			//drawArc(lines.graphics, new Point(), RADIUS - 3, 90, myo.pitch * 180 / Math.PI + 90);
			//
			//ConnectionPanel.sendOrientation(myo.id, correctedYaw, myo.pitch, myo.roll);
			//ConnectionPanel.sendAccel(myo.id, myo.accel);
			//ConnectionPanel.sendGyro(myo.id, myo.gyro);
		}
		
		override public function get id():String
		{
			return "Glove";
		}
	}

}