package ControlPanel.Property.Geometry
{
    import flash.display.DisplayObjectContainer;
    import flash.events.Event;
    
    import bit101.components.CheckBox;
    import bit101.components.Label;
    import bit101.components.NumericStepper;
    
    public class TGeometryCylinderProperty extends TGeometryPropertyBase
    {
        private var FTopRadius:NumericStepper;
        private var FBottomRadius:NumericStepper;
        private var FHeight:NumericStepper;
        private var FSegments:NumericStepper;
        private var FTopClose:CheckBox;
        private var FBottomClose:CheckBox;
        
        public function TGeometryCylinderProperty(parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0)
        {
            super(parent, xpos, ypos);
            height = 65;
        }
        
        override protected function addChildren():void
        {
            super.addChildren();
            
            var xPos:int = 0
            var yPos:int = 0
            new Label(this, xPos=5, yPos+=5, "顶部半径:");
            FTopRadius = new NumericStepper(this, xPos += 58, yPos);
            FTopRadius.addEventListener(Event.CHANGE, ValueUpdate);
            FTopRadius.setSize(70, 20);
            FTopRadius.labelPrecision = 1;
            FTopRadius.step = 0.1;
            FTopRadius.minimum = 0.1;
            
            new Label(this, xPos+=73, yPos, "高度:");
            FHeight = new NumericStepper(this, xPos += 32, yPos);
            FHeight.addEventListener(Event.CHANGE, ValueUpdate);
            FHeight.setSize(70, 20);
            FHeight.labelPrecision = 1;
            FHeight.step = 0.1;
            FHeight.minimum = 0.1;
            
            new Label(this, xPos=5, yPos+=20, "底部半径:");
            FBottomRadius = new NumericStepper(this, xPos += 58, yPos);
            FBottomRadius.addEventListener(Event.CHANGE, ValueUpdate);
            FBottomRadius.setSize(70, 20);
            FBottomRadius.labelPrecision = 1;
            FBottomRadius.step = 0.1;
            FBottomRadius.minimum = 0.1;

            new Label(this, xPos+=73, yPos, "段数:");
            FSegments = new NumericStepper(this, xPos += 32, yPos);
            FSegments.addEventListener(Event.CHANGE, ValueUpdate);
            FSegments.setSize(70, 20);
            FSegments.labelPrecision = 0;
            FSegments.step =1;
            FSegments.minimum = 0;
            FSegments.maximum = 36;
            
            FTopClose = new CheckBox(this, xPos=7, yPos+=25, "封闭顶部");
            FTopClose.addEventListener(Event.CHANGE, ValueUpdate);
            FBottomClose = new CheckBox(this, xPos+=80, yPos, "封闭底部");
            FBottomClose.addEventListener(Event.CHANGE, ValueUpdate);
                
        }
        
        override protected function InitTarget(target:*):void
        {
            FTopRadius.value = target.TopRadius;
            FBottomRadius.value = target.BottomRadius;
            FSegments.value = target.Segments;
            FHeight.value = target.Height;
            FTopClose.selected = target.TopClose;
            FBottomClose.selected = target.BottomClose;
        }
        
        private function ValueUpdate(e:Event):void
        {
            switch(e.currentTarget)
            {
                case FTopClose:
                {
                    GetTarget().TopClose = FTopClose.selected;
                    break;
                }
                case FBottomClose:
                {
                    GetTarget().BottomClose = FBottomClose.selected;
                    break;
                }
                case FTopRadius:
                {
                    GetTarget().TopRadius = FTopRadius.value;
                    break;
                }
                case FBottomRadius:
                {
                    GetTarget().BottomRadius = FBottomRadius.value;
                    break;
                }
                case FSegments:
                {
                    GetTarget().Segments = FSegments.value;
                    break;
                }
                case FHeight:
                {
                    GetTarget().Height = FHeight.value;
                    break;
                }
            }
        }
    }
}