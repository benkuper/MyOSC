package 
{
	import assets.Assets;
	import assets.fonts.Fonts;
	import benkuper.nativeExtensions.MyoController;
	import benkuper.nativeExtensions.MyoEvent;
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
			
			stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDown);
			
			NativeApplication.nativeApplication.icon.bitmaps = [(new Assets.SYSTRAY_ICON() as Bitmap).bitmapData];
			sysTrayIcon = NativeApplication.nativeApplication.icon as SystemTrayIcon;
			sysTrayIcon.addEventListener(MouseEvent.CLICK, sysTrayIconClick);
			var sysMenu:NativeMenu = new NativeMenu();
			var exitItem:NativeMenuItem = new NativeMenuItem("Exit");
			exitItem.addEventListener(Event.SELECT, exitSelect);
			sysMenu.addItem(exitItem);
			SystemTrayIcon(NativeApplication.nativeApplication.icon).menu = sysMenu;
			opened = true;
			
			
			NativeApplication.nativeApplication.addEventListener(InvokeEvent.INVOKE, invokeHandler);
		}
		
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
			
			sysTrayIcon.tooltip = "MyOSC - " + fp.feedbacks.length + " Myos, " + cp.connections.length + " connections";
		}
		
		
		
	}
	
}