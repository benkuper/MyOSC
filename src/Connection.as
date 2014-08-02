package  
{
	import assets.Assets;
	import assets.fonts.Fonts;
	import com.greensock.TweenLite;
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.ui.Keyboard;
	import org.tuio.osc.OSCMessage;
	
	/**
	 * ...
	 * @author Ben Kuper
	 */
	public class Connection extends Sprite 
	{
		public var id:String;
		public var host:String;
		public var port:int;
		
		
		private var enabled:Boolean;
		
		private var orientationEnabled:Boolean;
		private var poseEnabled:Boolean;
		private var accelEnabled:Boolean;
		private var gyroEnabled:Boolean;
		
		static public const RADIUS:Number = 80;
		
		private var _editingTF:TextField;
		private var idTF:TextField;
		private var hostTF:TextField;
		private var portTF:TextField;
		private var poseBT:Button;
		private var orientationBT:Button;
		private var accelBT:Button;
		private var gyroBT:Button;
		private var deleteBT:Button;
		
		public function Connection(id:String,host:String,port:int) 
		{
			super();
			this.port = port;
			this.host = host;
			this.id = id;
			
			var idLabel:TextField = Fonts.createTF("ID : ",Fonts.normalTF);
			addChild(idLabel);
			var hostLabel:TextField = Fonts.createTF("Host : ",Fonts.normalTF);
			addChild(hostLabel);
			var portLabel:TextField = Fonts.createTF("Port : ",Fonts.normalTF);
			addChild(portLabel);
			
			idTF = Fonts.createTF(id,Fonts.normalTF);
			addChild(idTF);
			hostTF = Fonts.createTF(host,Fonts.normalTF);
			addChild(hostTF);
			portTF = Fonts.createTF(port.toString(),Fonts.normalTF);
			addChild(portTF);
			
			idLabel.x = -idLabel.width - 10;
			idLabel.y = -40;
			idLabel.selectable = false;
			idLabel.mouseEnabled = false;
			
			hostLabel.x = -hostLabel.width - 10;
			hostLabel.y = -20;
			hostLabel.selectable = false;
			hostLabel.mouseEnabled = false;
			
			portLabel.x = -portLabel.width - 10;
			portLabel.y = 0;
			portLabel.selectable = false;
			portLabel.mouseEnabled = false;
			
			idTF.x = -5;
			idTF.y = -40;
			
			hostTF.x = -5;
			hostTF.y = -20;
			
			portTF.x = -5;
			portTF.y = 0;
			
			poseBT = new Button(new Assets.POSE_BT() as Bitmap);
			poseBT.x = -50;
			poseBT.y = 35;
			addChild(poseBT);
			
			orientationBT = new Button(new Assets.ORIENTATION_BT() as Bitmap);
			orientationBT.x = -20;
			orientationBT.y = 60;
			addChild(orientationBT);
			
			accelBT = new Button(new Assets.ACCEL_BT() as Bitmap);
			accelBT .x = 20;
			accelBT .y = 60;
			addChild(accelBT );
			
			
			gyroBT  = new Button(new Assets.GYRO_BT() as Bitmap);
			gyroBT .x = 50;
			gyroBT .y = 35;
			addChild(gyroBT );
			
			
			
			
			deleteBT = new Button(new Assets.DELETE_16() as Bitmap);
			deleteBT.x = 0;
			deleteBT.y = -60;
			addChild(deleteBT);
			
			poseBT.addEventListener(MouseEvent.CLICK, poseBTClick);
			orientationBT.addEventListener(MouseEvent.CLICK,orientationBTClick);
			accelBT.addEventListener(MouseEvent.CLICK,accelBTClick);
			gyroBT.addEventListener(MouseEvent.CLICK,gyroBTClick);
			deleteBT.addEventListener(MouseEvent.CLICK, deleteBTClick);
			
			addEventListener(MouseEvent.CLICK, mouseClick);
			
			this.enabled = true;
			this.orientationEnabled = true;
			this.accelEnabled = true;
			this.gyroEnabled = true;
			this.poseEnabled = true;
			
			TweenLite.fromTo(this, .3, { scaleX:0, scaleY:0 }, { scaleX:1, scaleY:1 } );
			draw();
			
		}
		
		
		//UI
		
		private function draw():void 
		{
			graphics.clear();
			graphics.lineStyle(1, 0, .2);
			graphics.beginFill(0x414141);
			graphics.drawCircle(0, 0, RADIUS);
		}
		
		//OSC
		
		public function send(msg:OSCMessage):void
		{
			OSCMaster.sendTo(msg, host, port);
		}
		
		public function sendOrientation(myoID:String, yaw:Number, pitch:Number, roll:Number):void 
		{
			if (!enabled) return;
			if (!orientationEnabled) return;
			var msg:OSCMessage = new OSCMessage();
			msg.address = "/myo/orientation";
			msg.addArgument("s", myoID);
			msg.addArgument("f",roll);
			msg.addArgument("f",pitch)
			msg.addArgument("f",yaw)
			send(msg);
		}
		
		public function sendPose(myoID:String, pose:String):void 
		{
			if (!enabled) return;
			if (!poseEnabled) return;
			var msg:OSCMessage = new OSCMessage();
			msg.address = "/myo/pose";
			msg.addArgument("s", myoID);
			msg.addArgument("s", pose);
			send(msg);
			
		}
		
		public function sendAccel(myoID:String,accel:Vector.<Number>):void 
		{
			if (!enabled) return;
			if (!accelEnabled) return;
			var msg:OSCMessage = new OSCMessage();
			msg.address = "/myo/accel";
			msg.addArgument("s", myoID);
			msg.addArgument("f", accel[0]);
			msg.addArgument("f", accel[1]);
			msg.addArgument("f", accel[2]);
			send(msg);
		}
		
		public function sendGyro(myoID:String, gyro:Vector.<Number>):void 
		{
			if (!enabled) return;
			if (!gyroEnabled) return;
			var msg:OSCMessage = new OSCMessage();
			msg.address = "/myo/gyro";
			msg.addArgument("s", myoID);
			msg.addArgument("f", gyro[0]);
			msg.addArgument("f", gyro[1]);
			msg.addArgument("f", gyro[2]);
			send(msg);
		}
		
		public function clean():void 
		{
			poseBT.removeEventListener(MouseEvent.CLICK, poseBTClick);
			orientationBT.removeEventListener(MouseEvent.CLICK,orientationBTClick);
			deleteBT.removeEventListener(MouseEvent.CLICK, deleteBTClick);
			
			removeEventListener(MouseEvent.CLICK, mouseClick);
		}
		
		public function loadXML(data:XML):void 
		{
			enabled = data.@enabled;
			accelEnabled = data.@accelEnabled;
			gyroEnabled = data.@gyroEnabled;
			orientationEnabled = data.@orientation;
			poseEnabled = data.@pose;
		}
		
		public function getXML():XML
		{
			return new XML("<connection id='"+id+"' host='"+host+"' port='"+port+"' enabled='" + enabled + "' accelEnabled='" + accelEnabled + "' gyroEnabled='" + gyroEnabled + "' orientationEnabled='" + orientationEnabled + "' poseEnabled='" + poseEnabled + "' />");
		}
		
		
		
		
		private function poseBTClick(e:MouseEvent):void 
		{
			poseEnabled = !poseEnabled;
			TweenLite.to(poseBT, .25, { alpha:poseEnabled?1:.3 } );
		}
		
		private function orientationBTClick(e:MouseEvent):void 
		{
			orientationEnabled = !orientationEnabled;
			TweenLite.to(orientationBT, .25, { alpha:orientationEnabled?1:.3 } );
		}
		
		private function gyroBTClick(e:MouseEvent):void 
		{
			gyroEnabled = !gyroEnabled;
			TweenLite.to(gyroBT, .25, { alpha:gyroEnabled?1:.3 } );
		}
		
		private function accelBTClick(e:MouseEvent):void 
		{
			accelEnabled = !accelEnabled;
			TweenLite.to(accelBT, .25, { alpha:accelEnabled?1:.3 } );
		}
		
		private function deleteBTClick(e:MouseEvent):void 
		{
			TweenLite.to(this, .2, { scaleX:0, scaleY:0, onComplete: dispatchEvent,onCompleteParams:[new Event(Event.CANCEL)]});
		}
		
		
		private function mouseClick(e:MouseEvent):void 
		{
			if (e.target is TextField)
			{
				editingTF = e.target as TextField;
			}else
			{
				editingTF = null;
			}
			
			this.parent.setChildIndex(this, this.parent.numChildren - 1);
		}
		
		
		
		//GETTER / SETTER 
		
		public function get editingTF():TextField 
		{
			return _editingTF;
		}
		
		public function set editingTF(value:TextField):void 
		{
			//if (editingTF == value) editingTF = null;
			
			if (editingTF != null)
			{
				//editingTF.opaqueBackground = false;
				
				editingTF.background = false;
				editingTF.border = false;
				editingTF.textColor = 0xefefef;
				editingTF.type = TextFieldType.DYNAMIC;
				stage.removeEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
				
				saveConfig();
			}
			
			_editingTF = value;
			
			if (editingTF != null)
			{
				//editingTF.opaqueBackground = true;
				editingTF.background = true;
				editingTF.border = true;
				editingTF.textColor = 0x333333;
				editingTF.type = TextFieldType.INPUT;
				
				stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
			}
		}
		
		private function saveConfig():void 
		{
			this.id = idTF.text;
			this.host = hostTF.text;
			this.port = int(Number(portTF.text));
		}
		
		private function keyDownHandler(e:KeyboardEvent):void 
		{
			switch(e.keyCode)
			{
				case Keyboard.ENTER:
				case Keyboard.NUMPAD_ENTER:
					editingTF = null;
					break;
			}
		}
		
	}

}