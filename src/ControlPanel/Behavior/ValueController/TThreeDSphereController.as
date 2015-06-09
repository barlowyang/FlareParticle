package ControlPanel.Behavior.ValueController
{
    import flash.display.DisplayObjectContainer;
    import flash.events.Event;
    
    import bit101.components.Label;
    import bit101.components.NumericStepper;
    
    public class TThreeDSphereController extends TValueControllerBase
    {
        public function TThreeDSphereController(parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0)
        {
            super(parent, xpos, ypos);
        }
        private var FInnerRadius:NumericStepper;
        private var FOuterRadius:NumericStepper;
        private var FCenterX:NumericStepper;
        private var FCenterY:NumericStepper;
        private var FCenterZ:NumericStepper;
        
        override protected function addChildren():void
        {
            super.addChildren();
            var xPos:int = -10;
            var yPos:int = 0;
            new Label(this, xPos = 0, yPos + 2, "　内径:");
            FInnerRadius = new NumericStepper(this, xPos+=45, yPos);
            FInnerRadius.addEventListener(Event.CHANGE, UpdateValue);
            FInnerRadius.width = 120;
            new Label(this, xPos = 0, yPos += 22, "　外径:");
            FOuterRadius = new NumericStepper(this, xPos+=45, yPos);
            FOuterRadius.addEventListener(Event.CHANGE, UpdateValue);
            FOuterRadius.width = 120;
            
            FOuterRadius.minimum = FInnerRadius.minimum = 0;
            
            new Label(this, xPos = 0, yPos += 25, " 中心X:");
            FCenterX = new NumericStepper(this, xPos+=45, yPos);
            FCenterX.addEventListener(Event.CHANGE, UpdateValue);
            FCenterX.width = 120;
            new Label(this, xPos = 0, yPos += 22, " 中心Y:");
            FCenterY = new NumericStepper(this, xPos+=45, yPos);
            FCenterY.addEventListener(Event.CHANGE, UpdateValue);
            FCenterY.width = 120;
            new Label(this, xPos = 0, yPos += 22, " 中心Z:");
            FCenterZ = new NumericStepper(this, xPos+=45, yPos);
            FCenterZ.addEventListener(Event.CHANGE, UpdateValue);
            FCenterZ.width = 120;
            
            height = yPos+18;
        }
        
        private function UpdateValue(e:Event):void
        {
            if(FTarget)
            {
                switch(e.currentTarget)
                {
                    case FInnerRadius:
                    {
                        FTarget.InnerRadius = FInnerRadius.value;
                        break;
                    }
                    case FOuterRadius:
                    {
                        FTarget.OuterRadius = FOuterRadius.value;
                        break;
                    }
                    case FCenterX:
                    {
                        FTarget.CenterX = FCenterX.value;
                        break;
                    }
                    case FCenterY:
                    {
                        FTarget.CenterY = FCenterY.value;
                        break;
                    }
                    case FCenterZ:
                    {
                        FTarget.CenterZ = FCenterZ.value;
                        break;
                    }
                }
                dispatchEvent(new Event("Update", true));
            }
        }
        override public function set Target(value:*):void
        {
            FTarget = value;
            if(value)
            {
                FInnerRadius.value = value.InnerRadius;
                FOuterRadius.value = value.OuterRadius;
                FCenterX.value = value.CenterX;
                FCenterY.value = value.CenterY;
                FCenterZ.value = value.CenterZ;
            }
        }
        override public function set SupportMinus(v:Boolean):void
        {
            
        }
    }
}