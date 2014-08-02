package benkuper.util 
{
	import flash.net.InterfaceAddress;
	import flash.net.NetworkInfo;
	import flash.net.NetworkInterface;
	/**
	 * ...
	 * @author Ben Kuper
	 */
	public class IPUtil 
	{
		
		public function IPUtil() 
		{
			
		}
		
		public static function getLocalIP():String
		{
			if (!NetworkInfo.isSupported)
			{
				trace("NetworkInfo not supported !");
				return "127.0.0.1";
			}
			
			var interfaces:Vector.<NetworkInterface> = NetworkInfo.networkInfo.findInterfaces();
			for each(var inf:NetworkInterface in interfaces)
			{
				for each (var add:InterfaceAddress in inf.addresses)
				{
					if (add.address.slice(0, 7) == "192.168") return add.address;
				}
			}
			
			trace("no local addresses found !");
			return "127.0.0.1";
		}
	}

}