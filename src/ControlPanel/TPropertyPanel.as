package ControlPanel
{
    import flash.display.DisplayObjectContainer;
    
    import ControlPanel.Property.TGeneralProperty;
    import ControlPanel.Property.TParticlesProperty;
    import ControlPanel.Property.TTransformProperty;
    
    import UI.TFoldPanelBase;
    
    import bit101.components.Panel;
    import bit101.components.VBox;
    
    import flare.core.Pivot3D;
    
    public class TPropertyPanel extends TFoldPanelBase
    {
        private var FTarget:Pivot3D;
		
		private var FTransform:TTransformProperty;
		
		private var FGeneral:TGeneralProperty;
		
		private var FParticle:TParticlesProperty;
		
		private var FPanel:Panel;
		private var FVBox:VBox;
        
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
			
			FPanel = new Panel(this);
			
			FVBox = new VBox(FPanel.content);
			FVBox.spacing = 3;
//			FVBox.addEventListener(MouseEvent.MOUSE_WHEEL, MouseWheelHandle);
			FPanel.y = 5;
			
			FTransform = new TTransformProperty(FVBox);
			FGeneral = new TGeneralProperty(FVBox);
			FParticle = new TParticlesProperty(FVBox);
			
			height = FPanel.height = FTransform.height + FGeneral.height + FParticle.height + 10;
        }
		
		override public function set width(w:Number):void
		{
			super.width = w;
			
			FPanel.width = w;
			FTransform.width = w;
			FGeneral.width = w;
			FParticle.width = w;
		}
        
        public function set Target(target:Pivot3D):void
        {
			FTarget = target;
            
			FTransform.Target = target;
			FGeneral.Target = target;
			FParticle.Target = target;
        }
    }
}