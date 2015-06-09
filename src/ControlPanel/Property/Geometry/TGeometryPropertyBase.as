package ControlPanel.Property.Geometry
{
    import flash.display.DisplayObjectContainer;
    
    import bit101.components.Panel;
    
    public class TGeometryPropertyBase extends Panel
    {
        
        public function TGeometryPropertyBase(parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0)
        {
            super(parent, xpos, ypos);
            shadow = false;
        }
        
        public function get GeometryClass():Class
        {
            return null; 
        }
        
        private var FTarget:Function
        public function GetTarget():*
        {
            if(FTarget is Function)
            {
                return FTarget.apply();
            }
            else
            {
                return FTarget;
            }
        }
        public function SetTarget(target:Function):void
        {
            FTarget = target;
            var t:* = GetTarget();
            if(t)
            {
                InitTarget(t);
            }
        }
        protected function InitTarget(target:*):void
        {
            
        }
        
        public function get CouldChangeMaterial():Boolean
        {
            return true;
        }
    }
}