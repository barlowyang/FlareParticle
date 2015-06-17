package
{
	import flash.display.NativeWindow;
	import flash.display.NativeWindowInitOptions;
	import flash.display.Sprite;
	import flash.display3D.Context3DProfile;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import flare.apps.controls.ColorPicker;
	import flare.basic.Scene3D;
	import flare.basic.Viewer3D;
	import flare.core.Texture3D;
	import flare.ide.controls.TexturePicker;
	import flare.materials.Shader3D;
	import flare.system.Device3D;
	
	[SWF(width="1200",height="800",frameRate="60")]
	public class UI_Test extends Sprite
	{
		private var scene:Scene3D;
		private var preLoadedTexture0:Texture3D;
		private var preLoadedTexture1:Texture3D;
		private var preLoadedTexture2:Texture3D;
		private var shader:Shader3D;
		
		private var pick:TexturePicker;
		
		public function UI_Test()
		{
			pick = new TexturePicker(null,false);
			addChild(pick.view);
			
			var colorPicker:ColorPicker = new ColorPicker();
			colorPicker.x = colorPicker.y = 200;
			addChild(colorPicker.view);
			
			pick.addEventListener(Event.CHANGE, onLoadBmp);
			
			var initOpts:NativeWindowInitOptions = new NativeWindowInitOptions();
			var win:NativeWindow = new NativeWindow(initOpts);
			win.activate();
			win.stage.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			
			function mouseDownHandler(event:MouseEvent):void
			{
				win.startMove();
			}
		}
		
		private function onLoadBmp(evt:Event):void
		{
			var texture3d:Texture3D = pick.texture;
			trace(texture3d);
		}
	}
}