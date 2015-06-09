package ControlPanel.Behavior
{
    import flash.events.Event;
    
    import ControlPanel.Behavior.ValueController.TValueCombox;
    
    import Data.Actions.TActionTime;
    import Data.Values.OneD.TOneDConst;
    import Data.Values.OneD.TOneDRandom;
    
    import bit101.components.CheckBox;

    public class TTimeController extends TActionControllerBase
    {
        public static const NAME:String = "时间控制";
        public static const VALUE_DEF:Class = TActionTime;
        
        private var FStartTime:TValueCombox;
        private var FDuration:TValueCombox;
        private var FDelay:TValueCombox;
        private var FEnableLoop:CheckBox;
        private var FActionTime:TActionTime;
        
        public function TTimeController()
        {
            super(NAME, false);
        }
        
        override protected function addChildren():void
        {
            super.addChildren();
            
            FStartTime = new TValueCombox(this,[TOneDConst, TOneDRandom],"开始时间:");
            FStartTime.addEventListener(Event.RESIZE, CorrectControllerSize);
            
            FDuration = new TValueCombox(this,[TOneDConst, TOneDRandom], "持续时间:",true, false);
            FDuration.addEventListener(Event.RESIZE, CorrectControllerSize);
            FDuration.addEventListener(Event.CHANGE, ChangeState);
            
            FEnableLoop = new CheckBox(this,5,0,"循环");
            FEnableLoop.addEventListener(Event.CHANGE, ChangeState);
            
            FDelay = new TValueCombox(this,[TOneDConst, TOneDRandom], "延迟时间:", true, false);
            FDelay.addEventListener(Event.RESIZE, CorrectControllerSize);
            FDelay.addEventListener(Event.CHANGE, ChangeState);
            
            CorrectControllerSize();
        }
        
        protected function ChangeState(e:Event):void
        {
            var enabled:Boolean;
            switch(e.currentTarget)
            {
                case FDuration:
                {
                    enabled = FDuration.MethodEnabled;
                    FEnableLoop.enabled = enabled;
                    FDelay.enabled = enabled;
                    
                    if(ActionTime)
                    {
                        ActionTime.EnableDuration = enabled;
                    }
                    break;
                }
                case FEnableLoop:
                {
                    FDelay.enabled = enabled = FEnableLoop.selected;
                    if(ActionTime)
                    {
                        ActionTime.EnableLoop = enabled;
                    }
                    break;
                }
                case FDelay:
                {
                    if(ActionTime)
                    {
                        ActionTime.EnbaleDelay = FDelay.ValueEnabled;
                    }
                    break;
                }
            }
            dispatchEvent(new Event("Update",true));
        }
        
        override protected function InitTarget():void
        {
            if(ActionTime)
            {
                FDelay.SetTarget(ActionTime,"Delay");
                FDelay.ValueEnabled = ActionTime.EnbaleDelay;
                FEnableLoop.selected = ActionTime.EnableLoop;
                FDuration.ValueEnabled = ActionTime.EnableDuration;
                FDuration.SetTarget(ActionTime,"DurationTime");
                FStartTime.SetTarget(ActionTime, "StartTime");
            }
            else
            {
                FDelay.SetTarget(null);
                FDuration.SetTarget(null);
                FStartTime.SetTarget(null);
            }
        }
        
        private function get ActionTime():TActionTime
        {
            return Target as TActionTime;
        }
    }
}