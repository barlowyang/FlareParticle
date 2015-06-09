package
{
	import flash.display.Sprite;
	
	import bit101.components.ColorChooser;
	
	public class UI_Test extends Sprite
	{
		public function UI_Test()
		{
			super();
			
			addChild(new ColorChooser());
		}
	}
}