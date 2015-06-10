package ControlPanel
{
    import flash.display.DisplayObjectContainer;
    
    import ControlPanel.Property.TGeneralProperty;
    import ControlPanel.Property.TTransformProperty;
    
    import UI.TFoldPanelBase;
    
    import flare.core.Pivot3D;
    
    public class TPropertyPanel extends TFoldPanelBase
    {
        private var FTarget:Pivot3D;
		
		private var FTransform:TTransformProperty;
		
		private var FGeneral:TGeneralProperty;
        
        public function TPropertyPanel(parent:DisplayObjectContainer, previewArea:TPreviewArea)
        {
            super(parent, 0, 0, "属性");
        }
        
        override public function draw():void
        {
            super.draw();
			
        }
        
        override protected function addChildren():void
        {
            super.addChildren();
            
            var xPos:int = 0;
            var yPos:int = 0;
			
			FTransform = new TTransformProperty(this);
			FGeneral = new TGeneralProperty(this);
			FGeneral.y = 100;
        }
		
		override public function set width(w:Number):void
		{
			super.width = w;
			
			FTransform.width = w;
			FGeneral.width = w;
		}
        
        public function set Target(target:Pivot3D):void
        {
			FTarget = target;
            
			FTransform.Target = target;
			FGeneral.Target = target;
        }
    }
}