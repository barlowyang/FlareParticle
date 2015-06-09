package ControlPanel.Behavior
{
    import flash.events.Event;
    
    import ControlPanel.Behavior.ValueController.TValueCombox;
    
    import Data.Actions.TActionVelocity;
    import Data.Values.ThreeD.TThreeDComposite;
    import Data.Values.ThreeD.TThreeDConst;
    import Data.Values.ThreeD.TThreeDCylinder;
    import Data.Values.ThreeD.TThreeDSphere;

    public class TVelocityController extends TActionControllerBase
    {
        public static const NAME:String = "速度控制";
        public static const VALUE_DEF:Class = TActionVelocity;
        
        private var FVelocity:TValueCombox;
        
        public function TVelocityController()
        {
            super(NAME);
        }
        
        override protected function addChildren():void
        {
            super.addChildren();
            FVelocity = new TValueCombox(this, [TThreeDConst, TThreeDComposite, TThreeDCylinder, TThreeDSphere], NAME+":");
            FVelocity.addEventListener(Event.RESIZE, CorrectControllerSize);
            
            CorrectControllerSize();
        }
        
        override protected function InitTarget():void
        {
            FVelocity.SetTarget(ActionVelocity, "Velocity");
        }
        
        private function get ActionVelocity():TActionVelocity
        {
            return Target as TActionVelocity;
        }
    }
}