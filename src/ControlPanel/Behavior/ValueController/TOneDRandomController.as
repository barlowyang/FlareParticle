package ControlPanel.Behavior.ValueController
{
    import flash.display.DisplayObjectContainer;
    import flash.events.Event;
    
    import bit101.components.Label;
    import bit101.components.NumericStepper;
    
    public class TOneDRandomController extends TValueControllerBase
    {
        private var FMax:NumericStepper;
        private var FMin:NumericStepper;
        
        public function TOneDRandomController(parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0)
        {
            super(parent, xpos, ypos);
        }
        
        override protected function addChildren():void
        {
            new Label(this).text = "高值:";
            FMax = new NumericStepper(this, 32);
            FMax.step = 0.01;
            FMax.labelPrecision = 2;
            FMax.addEventListener(Event.CHANGE, ChangeValue);
            
            new Label(this, 0, 25).text = "低值:";
            FMin = new NumericStepper(this, 32, 25);
            FMin.step = 0.01;
            FMin.labelPrecision = 2;
            FMin.addEventListener(Event.CHANGE, ChangeValue);
            
            height = 45;
        }
        
        private function ChangeValue(e:Event):void
        {
            if(!FTarget)
            {
                return;
            }
            switch(e.currentTarget)
            {
                case FMax:
                {
                    FTarget.Max = FMax.value;
                    break
                }
                case FMin:
                {
                    FTarget.Min = FMin.value;
                    break;
                }
            }
            dispatchEvent(new Event("Update", true));
        }
        
        override public function set Target(value:*):void
        {
            FTarget = value;
            if(value)
            {
                FMax.value = value.Max;
                FMin.value = value.Min
            }
        }
        override public function set SupportMinus(v:Boolean):void
        {
            FMin.minimum = FMax.minimum = v?int.MIN_VALUE:0;
        }
    }
}