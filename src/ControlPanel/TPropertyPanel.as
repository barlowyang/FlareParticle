package ControlPanel
{
    import flash.display.DisplayObjectContainer;
    import flash.events.Event;
    
    import UI.TFoldPanelBase;
    
    import bit101.components.Label;
    import bit101.components.NumericStepper;
    
    import flare.core.Pivot3D;
    
    public class TPropertyPanel extends TFoldPanelBase
    {
        private var FTarget:Pivot3D;
		
		private var FTransform:TTransformProperty;
        
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
                
            new Label(this, xPos=5, yPos+=25, "几何类型:");
        }
        
        private function CreateNumericStepper(x:int, y:int, height:int, width:int, step:Number, labelPrecision:int, handle:Function):NumericStepper
        {
            var ns:NumericStepper = new NumericStepper(this, x, y);
            ns.addEventListener(Event.CHANGE, handle);
            ns.setSize(width, height);
            ns.labelPrecision = labelPrecision;
            ns.step = step;
            return ns;
        }
        
        public function set Target(target:Pivot3D):void
        {
			FTarget = target;
            /*
            var vec:Vector3D;
            
            vec = target.GetPosition();
            FPositionX.value = vec.x;
            FPositionY.value = vec.y;
            FPositionZ.value = vec.z;
            
            vec = target.GetRotation();
            FRotationX.value = vec.x;
            FRotationY.value = vec.y;
            FRotationX.value = vec.z;
			FScale.value = target.Scale;
            */
            
			FTransform.Target = target;
            
            draw();
        }
    }
}