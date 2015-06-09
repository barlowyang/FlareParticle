package ControlPanel.Property.Material
{
    import flash.display.DisplayObjectContainer;
    import flash.events.Event;
    
    import Data.TParticle3DAnimation;
    import Data.Filters.TFilterSolidColor;
    
    import Geometry.TBlendMode;
    
    import bit101.components.ColorChooser;
    import bit101.components.Label;
    import bit101.components.NumericStepper;
    import bit101.components.Panel;
    
    public class TMaterialColorProperty extends Panel
    {
        private var FColor:ColorChooser;
        private var FColorAlpha:NumericStepper;
        private var FTarget:TFilterSolidColor;
        
        public function TMaterialColorProperty(container:DisplayObjectContainer, xPos:Number, yPos:Number)
        {
            super(container, xPos, yPos);
            height = 25;
        }
        override protected function addChildren():void
        {
            super.addChildren();
            new Label(this, 3, 5, "填充实色:");
            FColor = new ColorChooser(this, 62, 5);
            FColor.popupAlign = ColorChooser.BOTTOM;
            FColor.usePopup = true;
            FColor.width = 80;
            FColor.addEventListener(Event.CHANGE, UpdateColor);
            FColor.addEventListener("Update", UpdateColor);
            
            FColorAlpha = new NumericStepper(this, 199,5);
            new Label(FColorAlpha, -48, 0, "透明度:");
            FColorAlpha.maximum = 1;
            FColorAlpha.minimum = 0;
            FColorAlpha.step = 0.01;
            FColorAlpha.labelPrecision = 2;
            FColorAlpha.addEventListener(Event.CHANGE, UpdateColor);
            
            height = 25;
        }
        
        public function RemoveFromParent():void
        {
            if(parent)
            {
                parent.removeChild(this);
            }
        }
        
        private function UpdateColor(e:Event):void
        {
            switch(e.currentTarget)
            {
                case FColor:
                {
                    FTarget.Color = FColor.value;
                    break;
                }
                case FColorAlpha:
                {
                    FTarget.Alpha = FColorAlpha.value;
                    break;
                }
            }
        }
        
        public function set Target(target:TParticle3DAnimation):void
        {
            FTarget = target.CurrentFilter as TFilterSolidColor;
            FColor.value = FTarget.Color;
            FColorAlpha.value = FTarget.Alpha;
        }
        
        public function set BlendMode(mode:int):void
        {
            FColorAlpha.enabled = Boolean(mode == TBlendMode.TRANSPARENT);
        }
            
    }
}