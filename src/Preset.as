package  
{
	import assets.Assets;
	import assets.fonts.Fonts;
	import com.greensock.easing.Back;
	import com.greensock.TweenLite;
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.ui.Keyboard;
	
	/**
	 * ...
	 * @author Ben Kuper
	 */
	public class Preset extends Sprite 
	{
		
		private var _presetName:String;
		public var nameTF:TextField;
		static public const HEIGHT:Number = 30;
		static public const WIDTH:Number = 130;
		
		private var deleteBT:Button;
		
		private var _active:Boolean;
		private var _editing:Boolean;
		
		
		public function Preset(presetName:String) 
		{
			
			super();
			
			nameTF = Fonts.createTF(presetName, Fonts.bigTF);
			addChild(nameTF);
			nameTF.selectable = false;
			
			
			
			
			var f:File = getPresetFile();
			//trace("file exists ?", f.nativePath,f.exists);
			if (!f.exists) savePreset();
			
			deleteBT = new Button(new Assets.DELETE_16() as Bitmap);
			addChild(deleteBT);
			deleteBT.x = 5;
			
			addEventListener(MouseEvent.CLICK, mouseClick);
			addEventListener(MouseEvent.RIGHT_CLICK, rightClick);
			
			this.presetName = presetName;
			draw();
		}
		
		private function savePreset():void 
		{
			if (presetName == "null" || presetName == null) return;
			//trace("Save preset !");
			var fs:FileStream = new FileStream();
			fs.open(getPresetFile(), FileMode.WRITE);
			fs.writeUTFBytes(ConnectionPanel.instance.getXML().toXMLString());
			fs.close();
			TweenLite.fromTo(this, .3, { scaleX:1.2, scaleY:1.2 }, { scaleX:1, scaleY:1, ease:Back.easeOut } );
			Toaster.success("Preset " + presetName +" saved with " + ConnectionPanel.instance.connections.length +" connections");
			//trace("Config saved into preset : " + getPresetFile().name);
			
		}
		
		public function getXML():XML 
		{
			if (presetName == "null" || presetName == null) return new XML();
			var f:File = getPresetFile();
			if (!f.exists) savePreset();
			
			var fs:FileStream = new FileStream();
			fs.open(f, FileMode.READ);
			var xml:XML = new XML(fs.readUTFBytes(fs.bytesAvailable));
			fs.close();
			return xml;
			
		}
		
		public function getPresetFile():File
		{
			return File.applicationStorageDirectory.resolvePath("presets/" + presetName+".xml");
		}
		
		public function remove():void 
		{
			var f:File = getPresetFile();
			if(f.exists) f.deleteFile();
		}
		
		//HANDLERS
		
		private function rightClick(e:MouseEvent):void 
		{
			editing = true;
			
		}
		
		private function mouseClick(e:MouseEvent):void 
		{
			if (e.target == deleteBT)
			{
				dispatchEvent(new Event(Event.CANCEL));
				return;
			}
			
			if (e.shiftKey)
			{
				if(active) savePreset();
			}else
			{
				dispatchEvent(new Event(Event.SELECT));
			}
			
		}
		
		private function keyDown(e:KeyboardEvent):void 
		{
			switch(e.keyCode)
			{
				case Keyboard.ENTER:
				case Keyboard.NUMPAD_ENTER:
					editing = false;
					break;
			}
		}
		
		//UI
		
		private function draw():void 
		{
			graphics.clear();
			graphics.beginFill(0x666666);
			if (active) graphics.lineStyle(5,0xffff00);
			graphics.drawRoundRect( -nameTF.textWidth/2 - 20, -nameTF.textHeight/2 - 5, nameTF.textWidth + 50, nameTF.textHeight + 10, 30,30);
			graphics.endFill();
			
			deleteBT.x = nameTF.textWidth / 2 + 15;
		}
		
		
		//GETTER SETTER
		
		public function get active():Boolean 
		{
			return _active;
		}
		
		public function set active(value:Boolean):void 
		{
			_active = value;
			draw();
		}
		
		public function get presetName():String 
		{
			return _presetName;
		}
		
		public function set presetName(value:String):void 
		{
			if (_presetName == value) return;
			
			if (_presetName != null)
			{
				var f:File = getPresetFile();
			}
			
			_presetName = value;
			
			if(f !=null) f.moveTo(getPresetFile(),true);
			
			
			nameTF.text = presetName;
			
			
			nameTF.x = -nameTF.width / 2;
			nameTF.y = -nameTF.height / 2;
			draw();
		}
		
		public function get editing():Boolean 
		{
			return _editing;
		}
		
		public function set editing(value:Boolean):void 
		{
			_editing = value;
			nameTF.selectable = value;
			nameTF.type = value?TextFieldType.INPUT:TextFieldType.DYNAMIC;
			nameTF.background = value;
			nameTF.textColor = value?0x333333:0xefefef;
			if (!value)
			{
				presetName = nameTF.text;
			}
			
			if (value) stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDown);
			else stage.removeEventListener(KeyboardEvent.KEY_DOWN, keyDown);
		}
		
		
		
	}

}