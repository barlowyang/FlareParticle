package ControlPanel.Behavior.ValueController
{
    import flash.display.DisplayObjectContainer;
    import flash.events.Event;
    
    import Data.Values.OneD.TOneDConst;
    import Data.Values.OneD.TOneDRandom;
    
    import bit101.components.CheckBox;
    import bit101.components.VBox;
    
    public class TThreeDCompositeController extends TValueControllerBase
    {
        private var FContainer:VBox;
        private var FIsometric:CheckBox;
        private var FX:TValueCombox;
        private var FY:TValueCombox;
        private var FZ:TValueCombox;
        
        public function TThreeDCompositeController(parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0)
        {
            super(parent, xpos, ypos);
        }
        
        override protected function addChildren():void
        {
            super.addChildren();
            FIsometric = new CheckBox(this, 5,5,"叁轴相同");
            FIsometric.addEventListener(Event.CHANGE, UseIsometric);
            FContainer = new VBox(this, -15, 15);
            FContainer.spacing = 2;
            FX = new TValueCombox(FContainer, [TOneDConst, TOneDRandom], "X:",false, true, x);
            FX.addEventListener(Event.RESIZE, OnResize);
            FY = new TValueCombox(FContainer, [TOneDConst, TOneDRandom], "Y:",false, true, x);
            FY.addEventListener(Event.RESIZE, OnResize);
            FZ = new TValueCombox(FContainer, [TOneDConst, TOneDRandom], "Z:",false, true, x);
            FZ.addEventListener(Event.RESIZE, OnResize);
            
            OnResize();
        }
        
        private function UseIsometric(e:Event):void
        {
            if(FTarget)
            {
                FTarget.Isometric = FIsometric.selected;
                dispatchEvent(new Event("Update", true));
            }
            
            FY.enabled = FZ.enabled = !FIsometric.selected;
        }
        
        private function OnResize(e:Event = null):void
        {
            FContainer.draw();
            height = FContainer.y + FContainer.height + 5;
        }
        
        override public function set Target(value:*):void
        {
            FTarget = value;
            if(value)
            {
                FIsometric.selected = value.Isometric;
                FX.SetTarget(value, "X");
                FY.SetTarget(value, "Y");
                FZ.SetTarget(value, "Z");
                dispatchEvent(new Event("Update", true));
            }
            else
            {
                FY.SetTarget(null);
                FX.SetTarget(null);
                FZ.SetTarget(null);
            }
        }
        
        override public function set SupportMinus(v:Boolean):void
        {
            FZ.SupportMinus = FY.SupportMinus = FX.SupportMinus = v;
        }
    }
}