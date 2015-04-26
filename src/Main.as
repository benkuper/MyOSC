package 
{
	import assets.Assets;
	import assets.fonts.Fonts;
	import benkuper.nativeExtensions.MyoController;
	import benkuper.nativeExtensions.MyoEvent;

import flash.system.Capabilities;

    //import benkuper.nativeExtensions.NativeSerial;
	//import benkuper.nativeExtensions.SerialEvent;
	//import benkuper.nativeExtensions.SerialPort;
	import com.greensock.TweenLite;
	import flash.desktop.NativeApplication;
	import flash.desktop.SystemTrayIcon;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.NativeMenu;
	import flash.display.NativeMenuItem;
	import flash.display.Screen;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.InvokeEvent;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.ui.Keyboard;
	import flash.utils.ByteArray;


	/**
	 * ...
	 * @author Ben Kuper
	 */
	public class Main extends Sprite
	{
		private var cp:ConnectionPanel;
		private var fp:FeedbackPanel;
		private var pp:PresetPanel;

		private var blurDesktop:Boolean;
		private var _opened:Boolean;

		private var blurBG:Bitmap;

		private var mc:MyoController;
		
		private var sysTrayIcon:SystemTrayIcon;
		
		//Glove addon
		//private var gloveSerial:NativeSerial;

        private var isWin:Boolean;
        private var isMac:Boolean;
		
		public function Main():void 
		{
			Fonts.init();
			Toaster.init(stage);
			
			OSCMaster.init();
			
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			stage.nativeWindow.x = 0;
			stage.nativeWindow.y = 0;
			stage.nativeWindow.width = Screen.mainScreen.bounds.width;
			stage.nativeWindow.height = Screen.mainScreen.bounds.height;
			
			blurDesktop = true;
			blurBG = new Bitmap();
			addChild(blurBG);
			
			
			cp = new ConnectionPanel();
			addChild(cp);
			fp = new FeedbackPanel();
			addChild(fp);
			pp = new PresetPanel();
			addChild(pp);
			
			mc = new MyoController();
			mc.addEventListener(MyoEvent.MYO_PAIRED, myoPaired);
			//mc.setLockingPolicy(false);
			
			stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDown);
			
			NativeApplication.nativeApplication.icon.bitmaps = [(new Assets.SYSTRAY_ICON() as Bitmap).bitmapData];
			
            isWin =  Capabilities.os.toLowerCase().indexOf("win") != -1;
            isMac = Capabilities.os.toLowerCase().indexOf("mac") != -1;



            var sysMenu:NativeMenu = new NativeMenu();
			var exitItem:NativeMenuItem = new NativeMenuItem("Exit");
			exitItem.addEventListener(Event.SELECT, exitSelect);
			sysMenu.addItem(exitItem);
			
            if(isWin) {
                sysTrayIcon = NativeApplication.nativeApplication.icon as SystemTrayIcon;
                sysTrayIcon.addEventListener(MouseEvent.CLICK, sysTrayIconClick);
                SystemTrayIcon(NativeApplication.nativeApplication.icon).menu = sysMenu;
            }

            opened = true;
			
			
			NativeApplication.nativeApplication.addEventListener(InvokeEvent.INVOKE, invokeHandler);
			
			//Glove Addon
			//gloveSerial = new NativeSerial();
			//var glovePort:String = "COM30";
			//for each(var p:SerialPort in NativeSerial.ports)
			//{
				//if (p.COMID == "COM30")
				//{
					//gloveSerial.openPort("COM30", 115200);
					//gloveSerial.addEventListener(SerialEvent.DATA, gloveData);
					//FeedbackPanel.instance.addGlove(gloveSerial);
				//}
			//}s
			
		}

        /*
		private function gloveData(e:SerialEvent):void 
		{
			
		}
		*/

		private function invokeHandler(e:InvokeEvent):void 
		{
			opened = true;
		}
		
		
		private function exitSelect(e:Event):void 
		{
			NativeApplication.nativeApplication.exit();
		}
		
		
		private function sysTrayIconClick(e:MouseEvent):void 
		{
			opened = true;
		}
		
		private function myoPaired(e:MyoEvent):void 
		{
			fp.addMyo(e.myo);
		}
		
		private function keyDown(e:KeyboardEvent):void 
		{
			switch(e.keyCode)
			{
				case Keyboard.ESCAPE:
					opened = false;
					break;
					
				case Keyboard.S:
					getSS();
					break;
			}
		}
		
		//ScreenShooter doesn't work, need to find another ANE or make one
		private function getSS():void 
		{
			var rect:Rectangle = Screen.mainScreen.bounds;
			blurBG.bitmapData = new BitmapData(rect.width,rect.height,true,0);
			blurBG.bitmapData.fillRect(rect, 0xcc000000);
		}
		
		public function hideWindow():void
		{
			stage.nativeWindow.visible = false;
		}
		
		public function get opened():Boolean 
		{
			return _opened;
		}
		
		public function set opened(value:Boolean):void 
		{
			if (opened == value) return;
			
			_opened = value;		
			
			if (blurDesktop) 
			{
				getSS();
				TweenLite.to(blurBG, .5, { alpha:value?1:0,onComplete:value?null:hideWindow } );
			}
			
			stage.nativeWindow.visible = true;
			//stage.nativeWindow.alwaysInFront = value;
			if(value) stage.nativeWindow.orderToFront();
			
			cp.opened = value;
			fp.opened = value;

            if(isWin) {
                sysTrayIcon.tooltip = "MyOSC - " + fp.feedbacks.length + " Myos, " + cp.connections.length + " connections";
            }
        }
		
		
		
	}
	
}