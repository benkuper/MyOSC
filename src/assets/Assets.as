package assets 
{
	import benkuper.nativeExtensions.Myo;
	import flash.display.Bitmap;
	/**
	 * ...
	 * @author Ben Kuper
	 */
	public class Assets 
	{
		
		[Embed(source = "none_128.png")]
		public static var POSE_NONE:Class;
		
		[Embed(source = "fist_128.png")]
		public static var POSE_FIST:Class;
		
		[Embed(source = "fingers_spread_128.png")]
		public static var POSE_FINGERS_SPREAD:Class;
		
		[Embed(source = "wave_in_128.png")]
		public static var POSE_WAVE_IN:Class;
		
		[Embed(source = "wave_out_128.png")]
		public static var POSE_WAVE_OUT:Class;
		
		[Embed(source = "double_tap_128.png")]
		public static var POSE_DOUBLE_TAP:Class;
		
		[Embed(source = "thalmic.png")]
		public static var THALMIC:Class;
		
		[Embed(source = "connection.png")]
		public static var CONNECTION:Class;
		
		[Embed(source = "add.png")]
		public static var ADD_BT:Class;
		
		[Embed(source = "addPreset.png")]
		public static var ADD_PRESET_BT:Class;
		
		[Embed(source = "delete.png")]
		public static var DELETE_16:Class;
		
		[Embed(source = "myosc_systray.png")]
		public static var SYSTRAY_ICON:Class;
		
		
		[Embed(source = "lock32.png")]
		public static var LOCK_BT:Class;
		[Embed(source = "unlock32.png")]
		public static var UNLOCK_BT:Class;
		[Embed(source = "autoLock.png")]
		public static var AUTOLOCK_BT:Class;
		
		[Embed(source = "emg32.png")]
		public static var EMG_BT:Class;
		
		[Embed(source = "poseBT_32.png")]
		public static var POSE_BT:Class;
		[Embed(source = "orientationBT_32.png")]
		public static var ORIENTATION_BT:Class;
		[Embed(source = "accelBT.png")]
		public static var ACCEL_BT:Class;
		[Embed(source = "gyroBT.png")]
		public static var GYRO_BT:Class;
		[Embed(source = "emgSend.png")]
		public static var EMGSEND_BT:Class;
		
		public static function getBMForPose(pose:String):Bitmap
		{
			switch(pose)
			{
				case Myo.POSE_NONE: return new POSE_NONE() as Bitmap; break;
				case Myo.POSE_FIST: return new POSE_FIST() as Bitmap; break;
				case Myo.POSE_FINGERS_SPREAD: return new POSE_FINGERS_SPREAD() as Bitmap; break;
				case Myo.POSE_WAVE_IN: return new POSE_WAVE_IN() as Bitmap; break;
				case Myo.POSE_WAVE_OUT: return new POSE_WAVE_OUT() as Bitmap; break;
				case Myo.POSE_DOUBLE_TAP: return new POSE_DOUBLE_TAP() as Bitmap; break;
				
			default:
				return new POSE_NONE() as Bitmap;
			}
			
			return new Bitmap();
		}
		
	}

}