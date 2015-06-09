package ControlPanel.Behavior
{
    import flash.events.Event;
    
    import ControlPanel.Behavior.ValueController.TValueCombox;
    
    import Data.Actions.TActionPosition;
    import Data.Actions.TActionTime;
    import Data.Actions.TActionVelocity;
    import Data.Values.ThreeD.TThreeDComposite;
    import Data.Values.ThreeD.TThreeDConst;
    import Data.Values.ThreeD.TThreeDCylinder;
    import Data.Values.ThreeD.TThreeDSphere;

    public class TPositionController extends TActionControllerBase
    {
        public static const NAME:String = "初始位置控制";
        public static const VALUE_DEF:Class = TActionPosition;
        
        private var FPosition:TValueCombox;
        
        public function TPositionController()
        {
            super(NAME);
        }
        
        override protected function addChildren():void
        {
            super.addChildren();
            FPosition = new TValueCombox(this, [TThreeDConst, TThreeDComposite, TThreeDCylinder, TThreeDSphere], NAME+":");
            FPosition.addEventListener(Event.RESIZE, CorrectControllerSize);
            CorrectControllerSize();
        }
        
        override protected function InitTarget():void
        {
            FPosition.SetTarget(ActionPosition, "Position");
        }
        
        private function get ActionPosition():TActionPosition
        {
            return Target as TActionPosition;
        }
    }
}