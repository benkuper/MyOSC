package  
{
	import assets.Assets;
	import com.greensock.easing.Back;
	import com.greensock.easing.Strong;
	import com.greensock.TweenLite;
	import flash.display.Bitmap;
	import flash.display.Screen;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	/**
	 * ...
	 * @author Ben Kuper
	 */
	public class ConnectionPanel extends Panel 
	{
		public var connections:Vector.<Connection>;
		private var connectionContainer:Sprite;		
		
		private var addConnectionBT:Sprite;
		
		public static var instance:ConnectionPanel;
		
		public function ConnectionPanel() 
		{
			instance = this;
			super(0x82A4D7,0xDCE4E9);
			connections = new Vector.<Connection>;
			
			connectionContainer = new Sprite();
			addChild(connectionContainer);
			
			this.x = Screen.mainScreen.bounds.width*3 / 4;
			this.y = Screen.mainScreen.bounds.height / 2;
			
			
			logo = new Assets.CONNECTION() as Bitmap;
			logo.x = -logo.width / 2;
			logo.y = -logo.height / 2;
			container.addChild(logo);
			
			addConnectionBT = new Sprite();
			connectionContainer.addChild(addConnectionBT);
			var aBM:Bitmap = new Assets.ADD_BT() as Bitmap;
			aBM.x = -aBM.width / 2;
			aBM.y = -aBM.height / 2;
			addConnectionBT.addChild(aBM);
			addConnectionBT.addEventListener(MouseEvent.CLICK, addBTClick);
			addConnectionBT.scaleX = 0;
			addConnectionBT.scaleY = 0;
			TweenLite.fromTo(addConnectionBT, .5, { scaleX:0, scaleY:0 }, {delay:.5, scaleX:1, scaleY:1 } );
			TweenLite.delayedCall(.5, placeElements);
		}
		
		
		
		
		
		//UI
		
		private function placeElements():void 
		{
			var dist:Number;
			var angle:Number;
			var i:int = 0;
			
			for (i=0; i < connections.length; i++)
			{
				var c:Connection = connections[i];
				angle = Math.PI+ i * Math.PI * 2 / (connections.length+1);
				dist = INNER_RADIUS + Connection.RADIUS + 5;
				TweenLite.to(c, .3, { x:Math.cos(angle) * dist, y:Math.sin(angle) * dist, ease:Strong.easeOut } );
				//trace("place :", angle, dist);
			}
			
			
			angle = Math.PI + i * Math.PI * 2 / (connections.length+1);
			dist = innerCircleRad + Connection.RADIUS + 5;
			TweenLite.to(addConnectionBT, .3, { x:Math.cos(angle) * dist, y:Math.sin(angle) * dist, ease:Strong.easeOut } );
		}
		
		//HANDLERS
		
		private function addBTClick(e:MouseEvent):void 
		{
			//trace("bt click, add Connection");
			addConnection("#" + connections.length, "127.0.0.1",6000+connections.length);
		}
		
		//DATA
		
		public function addConnection(id:String,host:String,port:int):Connection
		{
			var tc:Connection = getConnection(id, host, port);
			if (tc != null)
			{
				Toaster.warning("Connection with same id or same host and port already exists");
				return tc;
			}
			
			var c:Connection = new Connection(id, host, port);
			
			c.addEventListener(Event.CANCEL, connectionDelete);
			
			connections.push(c);
			connectionContainer.addChild(c);
			//trace("place Elements");
			placeElements();
			
			Toaster.success("Connection addded !");
			
			return c;
		}
		
		private function loadConnection(data:XML):void 
		{
			var c:Connection = addConnection(data.@id, data.@host, data.@port);
			//trace("Load connection", data.@id, data.@host, data.@port);
			c.loadXML(data);
			
		}
		
		private function connectionDelete(e:Event):void 
		{
			removeConnection(e.currentTarget as Connection);
		}
		
		private function removeConnection(c:Connection):void 
		{
			c.clean();
			c.removeEventListener(Event.CANCEL, connectionDelete);
			connectionContainer.removeChild(c);
			connections.splice(connections.indexOf(c), 1);
			placeElements();
			
			Toaster.warning("Connection removed !");
		}
		
		public function getConnection(id:String, host:String, port:int):Connection
		{
			for each(var c:Connection in connections)
			{
				if (c.id == id) return c; 
				if (c.host == host && c.port == port) return c;
			}
			
			return null;
		}
		
		public function removeConnectionByID(id:String):void 
		{
			var c:Connection = getConnection(id, null, 0);
			
			if (c != null) removeConnection(c);
		}
		
		//OSC
		
		public static function sendOrientation(myoID:String, yaw:Number, pitch:Number, roll:Number):void
		{
			for each(var c:Connection in instance.connections)
			{
				c.sendOrientation(myoID, yaw, pitch, roll);
			}
		}
		
		public static function sendPose(myoID:String, pose:String):void
		{
			for each(var c:Connection in instance.connections)
			{
				c.sendPose(myoID, pose);
			}
		}
		
		static public function sendAccel(id:String, accel:Vector.<Number>):void 
		{
			for each(var c:Connection in instance.connections)
			{
				c.sendAccel(id, accel);
			}
		}
		
		static public function sendGyro(id:String, gyro:Vector.<Number>):void 
		{
			for each(var c:Connection in instance.connections)
			{
				c.sendGyro(id, gyro);
			}
		}
		
		static public function sendEMG(id:String, data:Vector.<int>):void 
		{
			for each(var c:Connection in instance.connections)
			{
				c.sendEMG(id, data);
			}
		}
		
		public function clear():void 
		{
			while (connections.length > 0) removeConnection(connections[0]);
		}
		
		public function loadPreset(data:XML):void 
		{
			for each(var p:XML in data.connections.children())
			{
				//trace("load c", p.@id);
				loadConnection(p);
			}
		}
		
	
		
		public function getXML():XML
		{
			var xml:XML = <data><connections></connections></data>;
			for each(var c:Connection in connections)
			{
				
				xml.connections[0].appendChild(c.getXML());
			}
			
			return xml;
		}
		
		
		
		
		
	}

}