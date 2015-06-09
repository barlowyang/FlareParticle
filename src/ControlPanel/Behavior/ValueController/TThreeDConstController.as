package ControlPanel.Behavior.ValueController
{
    import flash.display.DisplayObjectContainer;
    import flash.events.Event;
    
    import bit101.components.Label;
    import bit101.components.NumericStepper;
    
    public class TThreeDConstController extends TValueControllerBase
    {
        private var FX:NumericStepper;
        private var FY:NumericStepper;
        private var FZ:NumericStepper;
        
        public function TThreeDConstController(parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0)
        {
            super(parent, xpos, ypos);
        }
        
        override protected function addChildren():void
        {
            super.addChildren();
            var xPos:int = 0;
            var yPos:int = 0;
            new Label(this, xPos = 0, yPos = 3).text = "X:";
            FX = new NumericStepper(this, xPos+18, yPos-2);
            FX.step = 0.01;
            FX.labelPrecision = 2;
            FX.addEventListener(Event.CHANGE, ChangeValue);
            
            new Label(this, xPos = 0, yPos += 22).text = "Y:";
            FY = new NumericStepper(this, xPos+18, yPos-2);
            FY.step = 0.01;
            FY.labelPrecision = 2;
            FY.addEventListener(Event.CHANGE, ChangeValue);
            
            new Label(this, xPos = 0, yPos += 22).text = "Z:";
            FZ = new NumericStepper(this, xPos+18, yPos-2);
            FZ.step = 0.01;
            FZ.labelPrecision = 2;
            FZ.addEventListener(Event.CHANGE, ChangeValue);
            
            height = 60;
        }
        
        override public function set SupportMinus(v:Boolean):void
        {
            FX.minimum = FY.minimum = FZ.minimum = v?0:int.MIN_VALUE;
        }
        
        override public function set Target(value:*):void
        {
            FTarget = value;
            if(value)
            {
                FX.value = value.X;
                FY.value = value.Y;
                FZ.value = value.Z;
            }
        }
        
        private function ChangeValue(e:Event):void
        {
            if(FTarget)
            {
                switch(e.currentTarget)
                {
                    case FX:
                    {
                        FTarget.X = FX.value;
                        break;
                    }
                    case FY:
                    {
                        FTarget.Y = FY.value;
                        break;
                    }
                    case FZ:
                    {
                        FTarget.Z = FZ.value;
                        break;
                    }
                }
                dispatchEvent(new Event("Update", true));
            }
        }
        
    }
}