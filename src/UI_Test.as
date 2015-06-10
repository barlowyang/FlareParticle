package
{
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.display3D.Context3DProfile;
	import flash.events.Event;
	
	import bit101.components.Style;
	
	import flare.system.Device3D;
	
	[SWF(width="1200",height="800",frameRate="60")]
	public class UI_Test extends Sprite
	{
		private var FPreivewArea:TPreviewArea;
		private var FPanel:TControlPanel;
		
		public function UI_Test()
		{
			if(stage)
			{
				AddToStage();
			}
			else
			{
				addEventListener(Event.ADDED_TO_STAGE, AddToStage);
			}
		}
		
		private function AddToStage(e:Event = null):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, AddToStage);
			
			Style.embedFonts = false;
			Style.fontName = "simsun";
			Style.setStyle(Style.DARK);
			Style.fontSize = 12;
			
			Device3D.profile = Context3DProfile.STANDARD;
			FPreivewArea = new TPreviewArea(this);
			FPreivewArea.antialias = 4;
			FPreivewArea.skipFrames = true;
			
			FPanel = new TControlPanel(this, FPreivewArea);
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			stage.addEventListener(Event.RESIZE, Resize);
			Resize();
		}
		
		private function Resize(e:Event = null):void
		{
			var sw:int = stage.stageWidth;
			var sh:int = stage.stageHeight;
			var pw:int = FPanel.width;
			var vw:int = sw - pw;
			
			FPanel.setSize(FPanel.width, sh);
			FPanel.x = vw;
			FPreivewArea.setViewport(0, 0, vw, sh);
		}
		
	}
}