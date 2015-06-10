package
{
	import flash.display.Sprite;
	import flash.events.Event;
	
	import flare.basic.Scene3D;
	import flare.basic.Viewer3D;
	import flare.core.Texture3D;
	import flare.ide.controls.TexturePicker;
	import flare.materials.Shader3D;
	
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
			scene = new Viewer3D(this);
			scene.autoResize = true;
			scene.camera.setPosition( 0, 0, -250 );
			
			pick = new TexturePicker(null,false);
			addChild(pick.view);
			
			pick.addEventListener(Event.CHANGE, onLoadBmp);
		}
		
		private function onLoadBmp(evt:Event):void
		{
			var texture3d:Texture3D = pick.texture;
			trace(texture3d);
		}
		
	}
}