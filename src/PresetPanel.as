package
{
	import assets.Assets;
	import com.greensock.TweenLite;
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	import flash.ui.Keyboard;
	
	/**
	 * ...
	 * @author Ben Kuper
	 */
	public class PresetPanel extends Sprite
	{
		private var container:Sprite;
		private var presets:Vector.<Preset>;
		
		private var _activePreset:Preset;
		private var addPresetBT:Button;
		
		public function PresetPanel()
		{
			super();
			presets = new Vector.<Preset>;
			container = new Sprite();
			addChild(container);
			
			addEventListener(Event.ADDED_TO_STAGE, addedToStage);
			
			addPresetBT = new Button(new Assets.ADD_PRESET_BT() as Bitmap);
			addPresetBT.x = 150;
			addPresetBT.y = 40;
			addPresetBT.addEventListener(MouseEvent.CLICK, addPresetBTClick);
			addChild(addPresetBT);
			
		}
		
		private function loadPresets():void
		{
			var f:File = File.applicationStorageDirectory.resolvePath("presets/");
			
			if (!f.exists) return;
			var files:Array = f.getDirectoryListing();
			
			for each (var tf:File in files)
			{
				var p:Preset = addPreset(tf.name.slice(0, tf.name.length - 4));
			}
			
			Toaster.success(files.length+" presets loaded");
		}
		
		private function addPresetBTClick(e:MouseEvent):void
		{
			addPreset("Preset "+ presets.length);
		} 
		
		private function addedToStage(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, addedToStage);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDown);
			container.x = stage.stageWidth / 2;
			container.y = 40;
			
			loadPresets();
		}
		
		private function keyDown(e:KeyboardEvent):void
		{
			switch (e.keyCode)
			{
				case Keyboard.NUMPAD_ADD: 
					addPreset("Preset " + presets.length);
					break;
			}
		}
		
		private function addPreset(pName:String):Preset
		{
			var p:Preset = new Preset(pName);
			presets.push(p);
			container.addChild(p);
			
			p.addEventListener(Event.SELECT, presetSelect);
			p.addEventListener(Event.CANCEL, presetRemove);
			p.x = stage.stageWidth / 2;
			placeElements();
			
			return p;
		}
		
		private function presetRemove(e:Event):void 
		{
			removePreset(e.currentTarget as Preset);
		}
		
		private function removePreset(p:Preset):void 
		{
			p.remove();
			presets.splice(presets.indexOf(p),1);
			container.removeChild(p);
			p.removeEventListener(Event.SELECT, presetSelect);
			p.removeEventListener(Event.CANCEL, presetRemove);
			placeElements();
		}
		
		private function presetSelect(e:Event):void
		{
			activePreset = e.target as Preset;
		}
		
		private function placeElements():void
		{
			var numCols:int = 6;
			for (var i:int = 0; i < presets.length; i++)
			{
				var curRow:int = Math.floor(i / numCols);
				var curCol:int = i % numCols;
				var numInRow:int = Math.min(presets.length - curRow * numCols, numCols);
				//trace("num In Row ," + numInRow);
				var tx:Number = (curCol - numInRow / 2 + .5) * (Preset.WIDTH + 10);
				
				var ty:Number = curRow * (Preset.HEIGHT + 10);
				TweenLite.to(presets[i], .3, {x: tx, y: ty});
			}
		}
		
		public function get activePreset():Preset
		{
			return _activePreset;
		}
		
		public function set activePreset(value:Preset):void
		{
			if (activePreset == value) return;
			
			if (activePreset != null)
			{
				activePreset.active = false;
				ConnectionPanel.instance.clear();
			}
			_activePreset = value;
			
			if (activePreset != null)
			{
				activePreset.active = true;
				ConnectionPanel.instance.loadPreset(activePreset.getXML());
			}
		}
	
	}

}