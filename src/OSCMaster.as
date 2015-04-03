package  
{
	import benkuper.util.IPUtil;
	import flash.desktop.NativeApplication;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import org.tuio.connectors.UDPConnector;
	import org.tuio.osc.IOSCListener;
	import org.tuio.osc.OSCManager;
	import org.tuio.osc.OSCMessage;
	
	/**
	 * ...
	 * @author Ben Kuper
	 */
	public class OSCMaster extends EventDispatcher implements IOSCListener
	{
		public static var instance:OSCMaster;
		public var oscM:OSCManager;
		public var oscMLan:OSCManager;
		public var port:int;
		
		public function OSCMaster() 
		{
			port = 11000;
			oscM = new OSCManager(new UDPConnector("127.0.0.1", port), new UDPConnector("127.0.0.1", 10000, false, false));
			oscM.addMsgListener(this);
			var lanIP:String = IPUtil.getLocalIP();
			if (lanIP != "127.0.0.1")
			{
				oscMLan = new OSCManager(new UDPConnector(lanIP, port), null);
				oscMLan.addMsgListener(this);
			}
		}
		
		public static function init():void
		{
			if (instance) return;
			instance = new OSCMaster();
		}
		
		public static function sendTo(msg:OSCMessage, host:String, port:int):void
		{
			instance.oscM.sendOSCPacketTo(msg, host, port);
		}
		
		/* INTERFACE org.tuio.osc.IOSCListener */
		
		public function acceptOSCMessage(msg:OSCMessage):void 
		{
			var id:String;
			trace("Received message :" + msg.address + "," + msg.argumentsToString());
			var command:String = msg.address.split("/")[2];
			switch(command)
			{
				case "register":
					id = msg.arguments[0] as String;
					var host:String = msg.arguments[1] as String;
					var port:int = msg.arguments[2] as int;
					ConnectionPanel.instance.addConnection(id, host, port);
					break;
					
				case "unregister":
					id = msg.arguments[0] as String;
					ConnectionPanel.instance.removeConnectionByID(id);
					break;
					
				case "vibrate":
					if (msg.arguments.length == 0) //default to vibrate all myos short
					{
						FeedbackPanel.instance.vibrateAllMyos();
					}else if (msg.arguments.length == 1) 
					{
						if (!isNaN(Number(msg.arguments[0]))) //if arg is int, vibrate all myos with parameter intensity (0,1,2)
						{
							FeedbackPanel.instance.vibrateAllMyos(int(Number(msg.arguments[0])));
						}else //vibrate specific myo with id in arguments[0]
						{
							FeedbackPanel.instance.vibrateMyo(msg.arguments[0]);
						}
					}else
					{
						FeedbackPanel.instance.vibrateMyo(msg.arguments[0], int(Number(msg.arguments[1])));
					}
			}
			
		}
		
	}

}