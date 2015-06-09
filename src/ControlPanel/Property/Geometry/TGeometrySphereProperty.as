package ControlPanel.Property.Geometry
{
    import flash.display.DisplayObjectContainer;
    import flash.events.Event;
    
    import bit101.components.Label;
    import bit101.components.NumericStepper;
    
    public class TGeometrySphereProperty extends TGeometryPropertyBase
    {
        private var FRadius:NumericStepper;
        private var FSegments:NumericStepper;
        public function TGeometrySphereProperty(parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0)
        {
            super(parent, xpos, ypos);
            height = 25;
        }
        
        override protected function addChildren():void
        {
            super.addChildren();
            
            var xPos:int = 0
            var yPos:int = 0
            new Label(this, xPos=5, yPos+=5, "半径:");
            FRadius = new NumericStepper(this, xPos += 32, yPos);
            FRadius.addEventListener(Event.CHANGE, ValueUpdate);
            FRadius.setSize(70, 20);
            FRadius.labelPrecision = 1;
            FRadius.step = 0.1;
            FRadius.minimum = 0.1;
            
            new Label(this, xPos+=73, yPos, "段数:");
            FSegments = new NumericStepper(this, xPos += 32, yPos);
            FSegments.addEventListener(Event.CHANGE, ValueUpdate);
            FSegments.setSize(70, 20);
            FSegments.labelPrecision = 1;
            FSegments.step = 1;
            FSegments.minimum = 0;
            FSegments.maximum = 36;
            
        }
        
        override protected function InitTarget(target:*):void
        {
            FRadius.value = target.Radius;
            FSegments.value = target.Segments;
        }
        
        private function ValueUpdate(e:Event):void
        {
            switch(e.currentTarget)
            {
                case FRadius:
                {
                    GetTarget().Radius = FRadius.value;
                    break;
                }
                case FSegments:
                {
                    GetTarget().Segments = FSegments.value;
                    break;
                }
            }
        }
    }
}