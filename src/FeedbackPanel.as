package
{
	import assets.Assets;
	import assets.fonts.Fonts;
	import benkuper.nativeExtensions.Myo;
	import benkuper.nativeExtensions.NativeSerial;
	import benkuper.nativeExtensions.SerialPort;
	import com.greensock.easing.Strong;
	import com.greensock.TweenLite;
	import flash.display.Bitmap;
	import flash.display.Screen;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	/**
	 * ...
	 * @author Ben Kuper
	 */
	public class FeedbackPanel extends Panel
	{
		public static var instance:FeedbackPanel;
		
		public var feedbacks:Vector.<Feedback>;
		private var feedbackContainer:Sprite;
		
		private var _selectedFeedback:Feedback;
		
		private var infos:Sprite;
		private var infosTF:TextField;
		
		public function FeedbackPanel()
		{
			instance = this;
			super(0x333333, 0xE8F0D5);
			
			feedbacks = new Vector.<Feedback>;
			
			feedbackContainer = new Sprite();
			addChild(feedbackContainer);
			
			this.x = Screen.mainScreen.bounds.width / 4;
			this.y = Screen.mainScreen.bounds.height / 2;
			
			logo = new Assets.THALMIC() as Bitmap;
			logo.x = -logo.width / 2;
			logo.y = -logo.height / 2;
			container.addChild(logo);
			
			infos = new Sprite();
			addChild(infos);
			infos.alpha = 0;
			infosTF = Fonts.createTF("Infos", Fonts.normalCenterTF,TextFieldAutoSize.CENTER);
			infos.addChild(infosTF);
			
			feedbackContainer.addEventListener(MouseEvent.CLICK, containerClick);
		}
		//UI
		
		private function placeElements():void
		{
			for (var i:int = 0; i < feedbacks.length; i++)
			{
				var f:Feedback = feedbacks[i];
				var angle:Number = i * Math.PI * 2 / feedbacks.length;
				var dist:Number = INNER_RADIUS + Feedback.RADIUS + 5;
				f.x = Math.cos(angle) * dist;
				f.y = Math.sin(angle) * dist;
			}
		}
		
		
		private function showInfos(feedback:Feedback):void 
		{
			TweenLite.to(infos, .3, { alpha:feedback != null?1:0 } );
			TweenLite.to(logo, .3,  { alpha:feedback != null?0:1 } );
			
			if (feedback == null) return;
			infosTF.text = selectedFeedback.id;
			
			infosTF.x = -infosTF.textWidth/2;
			infosTF.y = -infosTF.textHeight / 2;
		}
		
		// DATA
		
		public function addMyo(myo:Myo):void
		{
			var f:MyoFeedback = new MyoFeedback(myo);
			feedbacks.push(f);
			feedbackContainer.addChild(f);
			placeElements();
			
			Toaster.success("New Myo added : "+myo.id);
		}
		
		
		//Glove addond
		public function addGlove(serial:NativeSerial):void 
		{
			var g:GloveFeedback = new GloveFeedback(serial);
			feedbacks.push(g);
			feedbackContainer.addChild(g);
			placeElements();
			Toaster.success("Glove added");
		}
		
		public function vibrateAllMyos(intensity:int = Myo.VIBRATION_SHORT):void 
		{
			for each(var f:Feedback in feedbacks)
			{
				if(f is MyoFeedback) (f as MyoFeedback).myo.vibrate(intensity);
			}
		}
		
		public function vibrateMyo(myoID:String, intensity:int  = Myo.VIBRATION_SHORT):void
		{
			for each(var f:Feedback in feedbacks)
			{
				if (f is MyoFeedback)  
				{
					if(f is  MyoFeedback) if((f as MyoFeedback).myo.id == myoID) (f as MyoFeedback).myo.vibrate(intensity);
				}
			}
		}
		
		
		
		// HANDLERS
		
		private function containerClick(e:MouseEvent):void 
		{
			selectedFeedback = e.target as Feedback;
		}
		
		
		
		//GETTER SETTER
		
		override public function set opened(value:Boolean):void
		{
			super.opened = value;
			for (var i:int = 0; i < feedbacks.length; i++)
			{
				TweenLite.to(feedbacks[i], .5, { scaleX:value?1:0, scaleY:value?1:0, ease:Strong.easeOut, delay:value?.3+.2*i:.1 * i } );
			}
		}
		
		public function get selectedFeedback():Feedback 
		{
			return _selectedFeedback;
		}
		
		public function set selectedFeedback(value:Feedback):void 
		{
			if (selectedFeedback == value && value != null) 
			{
				selectedFeedback = null;
				return;
			}
			
			if (selectedFeedback != null)
			{
				selectedFeedback.selected = false;
			}
			_selectedFeedback = value;
			
			if (selectedFeedback != null)
			{
				selectedFeedback.selected = true;
			}
			
			showInfos(selectedFeedback);
			
		}
		
		
	}

}