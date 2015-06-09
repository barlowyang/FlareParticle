package ControlPanel.Property.Geometry
{
    import flash.display.DisplayObjectContainer;
    import flash.events.Event;
    
    import Geometry.TGeometryPlane;
    import Geometry.TPlaneAxis;
    
    import bit101.components.ComboBox;
    import bit101.components.Label;
    import bit101.components.NumericStepper;
    
    public class TGeometryPlaneProperty extends TGeometryPropertyBase
    {
        private var FWidth:NumericStepper;
        private var FHeight:NumericStepper;
        private var FAxis:ComboBox;
        
        public function TGeometryPlaneProperty(parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0)
        {
            super(parent, xpos, ypos);
            height = 25;
        }
        
        override protected function addChildren():void
        {
            super.addChildren();
            
            var xPos:int = 0
            var yPos:int = 0
            new Label(this, xPos=5, yPos+=5, "宽度:");
            FWidth = new NumericStepper(this, xPos += 32, yPos);
            FWidth.addEventListener(Event.CHANGE, ValueUpdate);
            FWidth.setSize(70, 20);
            FWidth.labelPrecision = 1;
            FWidth.step = 0.1;
            FWidth.minimum = 0;
                
            new Label(this, xPos+=73, yPos, "高度:");
            FHeight = new NumericStepper(this, xPos += 32, yPos);
            FHeight.addEventListener(Event.CHANGE, ValueUpdate);
            FHeight.setSize(70, 20);
            FHeight.labelPrecision = 1;
            FHeight.step = 0.1;
            FHeight.minimum = 0;
            
            new Label(this, xPos+=73, yPos, "轴向:");
            FAxis = new ComboBox(this, xPos+=32,yPos-2,"",[TPlaneAxis.A_XY, TPlaneAxis.B_XY, TPlaneAxis.A_XZ, TPlaneAxis.B_XZ, TPlaneAxis.A_YZ, TPlaneAxis.B_YZ]);
            FAxis.addEventListener(Event.SELECT, ValueUpdate);
            FAxis.width = 70;
        }
        
        override protected function InitTarget(target:*):void
        {
            FWidth.value = target.Width;
            FHeight.value = target.Height;
            FAxis.selectedItem = target.Axis;
            
        }
        
        private function ValueUpdate(e:Event):void
        {
            switch(e.currentTarget)
            {
                case FAxis:
                {
                    GetTarget().Axis = FAxis.selectedItem;
                }
                case FWidth:
                {
                    GetTarget().Width = FWidth.value;
                    break;
                }
                case FHeight:
                {
                    GetTarget().Height = FHeight.value;
                    break;
                }
            }
        }
        
        override public function get GeometryClass():Class
        {
            return TGeometryPlane;
        }
        
    }
}