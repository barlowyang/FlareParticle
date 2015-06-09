package ControlPanel.Property.Geometry
{
    import flash.display.DisplayObjectContainer;
    import flash.events.Event;
    
    import bit101.components.Label;
    import bit101.components.PushButton;
    import bit101.components.Text;
    
    public class TGeometryCustomProperty extends TGeometryPropertyBase
    {
        private var FPath:Text;
        
        public function TGeometryCustomProperty(parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0)
        {
            super(parent, xpos, ypos);
            height = 25;
        }
        
        override protected function addChildren():void
        {
            super.addChildren();
            
            new Label(this, 5, 5, "外部模型路径:");
            FPath = new Text(this, 85, 3, "null");
            FPath.editable = false;
            FPath.setSize(180,20);
            var btn:PushButton = new PushButton(this,268,3,"选择", ToSelectModel);
            btn.setSize(50,20);
        }
        
        private function ToSelectModel(e:Event):void
        {
            
        }
        
        override public function get CouldChangeMaterial():Boolean
        {
            return false;
        }
        
        
    }
}