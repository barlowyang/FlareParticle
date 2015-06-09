package ControlPanel.Property.Geometry
{
    import flash.display.DisplayObjectContainer;
    import flash.events.Event;
    
    import bit101.components.Label;
    import bit101.components.NumericStepper;
    
    public class TGeometryCubeProperty extends TGeometryPropertyBase
    {
        private var FWidth:NumericStepper;
        private var FHeight:NumericStepper;
        private var FDepth:NumericStepper;
        
        public function TGeometryCubeProperty(parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0)
        {
            super(parent, xpos, ypos);
            height = 25;
        }
    
        override protected function addChildren():void
        {
            super.addChildren();
            
            var xPos:int = 0
            var yPos:int = 0
            new Label(this, xPos=5, yPos+=5, "宽度:");
            FWidth = new NumericStepper(this, xPos += 32, yPos);
            FWidth.addEventListener(Event.CHANGE, ValueUpdate);
            FWidth.setSize(70, 20);
            FWidth.labelPrecision = 1;
            FWidth.step = 0.1;
            FWidth.minimum = 0;
            
            new Label(this, xPos+=73, yPos, "高度:");
            FHeight = new NumericStepper(this, xPos += 32, yPos);
            FHeight.addEventListener(Event.CHANGE, ValueUpdate);
            FHeight.setSize(70, 20);
            FHeight.labelPrecision = 1;
            FHeight.step = 0.1;
            FHeight.minimum = 0;
            
            new Label(this, xPos+=73, yPos, "深度:");
            FDepth = new NumericStepper(this, xPos += 32, yPos);
            FDepth.addEventListener(Event.CHANGE, ValueUpdate);
            FDepth.setSize(70, 20);
            FDepth.labelPrecision = 1;
            FDepth.step = 0.1;
            FDepth.minimum = 0;
        }
        
        override protected function InitTarget(target:*):void
        {
            FWidth.value = target.Width;
            FHeight.value = target.Height;
            FDepth.value = target.Depth;
        }
        
        private function ValueUpdate(e:Event):void
        {
            switch(e.currentTarget)
            {
                case FWidth:
                {
                    GetTarget().Width = FWidth.value;
                    break;
                }
                case FHeight:
                {
                    GetTarget().Height = FHeight.value;
                    break;
                }
                case FDepth:
                {
                    GetTarget().Depth = FDepth.value;
                    break;
                }
            }
        }
    }
}