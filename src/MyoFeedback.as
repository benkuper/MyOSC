package  
{
	import assets.Assets;
	import benkuper.nativeExtensions.Myo;
	import benkuper.nativeExtensions.MyoEvent;
	import com.greensock.TweenLite;
	import flash.display.Bitmap;
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	/**
	 * ...
	 * @author Ben Kuper
	 */
	public class MyoFeedback extends Feedback 
	{
		
		private var _orientationEnabled:Boolean;
		private var _poseEnabled:Boolean;
		private var accelEnabled:Boolean;
		private var gyroEnabled:Boolean;
		
		public var myo:Myo;
		
		public var poseBM:Bitmap;
		public var lines:Sprite;
		
		private var offsetYaw:Number;//to integrate in library
		
		public function MyoFeedback(myo:Myo) 
		{
			super();
			
			this.myo = myo;
			orientationEnabled = true;
			poseEnabled = true;
			
			enabled = true;
			
			lines = new Sprite();
			addChild(lines);
			
			poseBM = new Bitmap();
			poseBM.bitmapData = Assets.getBMForPose(Myo.POSE_NONE).bitmapData;
			poseBM.x = -poseBM.width / 2;
			poseBM.y = -poseBM.height / 2;
			poseBM.smoothing = true;
			
			inner.addChild(poseBM);
			
			TweenLite.fromTo(this, .3, { scaleX:0, scaleY:0 }, { scaleX:1, scaleY:1 } );
			
			mouseChildren = false;
			
			offsetYaw = 0;
			
			addEventListener(MouseEvent.RIGHT_CLICK, rightClick);
			
			myo.addEventListener(MyoEvent.MYO_CONNECTED, myoConnected);
			myo.addEventListener(MyoEvent.MYO_DISCONNECTED, myoDisconnected);
			
			myo.addEventListener(MyoEvent.EMGDATA_UPDATE, emgUpdate);
			
			myo.addEventListener(MyoEvent.DATA_UPDATE, dataUpdate);
			
		}		
		
		private function emgUpdate(e:MyoEvent):void 
		{
			ConnectionPanel.sendEMG(myo.id, myo.emgData);
		}
		
		//UI
		
		override protected function draw():void 
		{
			
			super.draw();
			
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
			offsetYaw = myo.yaw;
		}
		
		private function dataUpdate(e:MyoEvent):void 
		{
			if (!enabled) return;
			
			
			//trace(myo.yaw, correctedYaw);
			
			//trace("Orientation update !", myo.yaw, myo.pitch, myo.roll);
			inner.rotation = correctedYaw * 180 / Math.PI + 90; // arm upward is 0
			
			var reversed:Boolean =  Math.abs(myo.roll) > Math.PI / 2;
			
			lines.graphics.clear();
			
			lines.graphics.lineStyle(3, 0xC42802);
			drawArc(lines.graphics, new Point(), RADIUS, -90, -myo.roll * 180 / Math.PI - 90);
			
			lines.graphics.lineStyle(3, reversed?0x46B517:0x06A9CC);
			drawArc(lines.graphics, new Point(), RADIUS - 3, 90, myo.pitch * 180 / Math.PI + 90);
			
			if (orientationEnabled)
			{
				ConnectionPanel.sendOrientation(myo.id, correctedYaw, myo.pitch, myo.roll);
				ConnectionPanel.sendAccel(myo.id, myo.accel);
				ConnectionPanel.sendGyro(myo.id, myo.gyro);
			}
			
		}
		
		private function poseUpdate(e:MyoEvent):void 
		{
			if (!enabled) return;
			trace("Pose update !", myo.pose);
			
			poseBM.bitmapData = Assets.getBMForPose(myo.pose).bitmapData;
			poseBM.smoothing = true;
			
			ConnectionPanel.sendPose(myo.id, myo.pose);
		}
		
		
		private function myoConnected(e:MyoEvent):void 
		{
			TweenLite.to(this, .5, { alpha: 1} );
		}
		
		private function myoDisconnected(e:MyoEvent):void 
		{
			TweenLite.to(this, .5, { alpha:.3 } );
		}
		
		//GETTER / SETTER
		
		
		public function get correctedYaw():Number
		{
			var oy:Number = -(myo.yaw - offsetYaw);
			if (oy > Math.PI) oy -= Math.PI*2;
			else if (oy < -Math.PI) oy += Math.PI*2;
			
			return oy;
			//return myo.yaw;
		}
		
		public function get orientationEnabled():Boolean 
		{
			return _orientationEnabled;
		}
		
		public function set orientationEnabled(value:Boolean):void 
		{
			if (orientationEnabled == value) return;
			_orientationEnabled = value;
			
			
		}
		
		public function get poseEnabled():Boolean 
		{
			return _poseEnabled;
		}
		
		public function set poseEnabled(value:Boolean):void 
		{
			if (poseEnabled == value) return;
			_poseEnabled = value;
			
			if (value) myo.addEventListener(MyoEvent.POSE_UPDATE, poseUpdate);
			else myo.removeEventListener(MyoEvent.POSE_UPDATE, poseUpdate);
		}
		
		override public function get id():String
		{
			return myo.id;
		}
		
	}

}