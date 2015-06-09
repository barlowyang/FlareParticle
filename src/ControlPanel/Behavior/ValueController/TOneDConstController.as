package ControlPanel.Behavior.ValueController
{
    import flash.display.DisplayObjectContainer;
    import flash.events.Event;
    
    import Data.Values.OneD.TOneDConst;
    
    import bit101.components.Label;
    import bit101.components.NumericStepper;
    
    public class TOneDConstController extends TValueControllerBase
    {
        private var FValue:NumericStepper;
        private var FTarget:TOneDConst;
        public function TOneDConstController(parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0)
        {
            super(parent, xpos, ypos);
        }
        
        override protected function addChildren():void
        {
            super.addChildren();
            new Label(this).text = "值:";
            FValue = new NumericStepper(this, 30);
            FValue.step = 0.01;
            FValue.labelPrecision = 2;
            FValue.addEventListener(Event.CHANGE, ChangeValue);
            
            height = 20;
        }
        
        private function ChangeValue(e:Event):void
        {
            if(FTarget)
            {
                FTarget.Value = FValue.value;
            }
        }
        
        override public function set Target(target:*):void
        {
            FTarget = target;
            if(target)
            {
                FValue.value = target.Value;
                dispatchEvent(new Event("Update", true));
            }
        }
        
        override public function set SupportMinus(v:Boolean):void
        {
            FValue.minimum = v?int.MIN_VALUE:0;
        }
    }
}