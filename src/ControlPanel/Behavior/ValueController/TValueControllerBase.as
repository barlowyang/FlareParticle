package ControlPanel.Behavior.ValueController
{
    import flash.display.DisplayObjectContainer;
    
    import GT.Errors.AbstractMethodError;
    
    import avmplus.getQualifiedClassName;
    
    import bit101.components.Component;
    
    public class TValueControllerBase extends Component
    {
        protected var FTarget:*;
        
        public function TValueControllerBase(parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0)
        {
            super(parent, xpos, ypos);
        }
        
        public function get Target():*
        {
            return FTarget;
        }
        public function set Target(value:*):void
        {
            FTarget = value;
        }

        public function set SupportMinus(v:Boolean):void
        {
            throw new AbstractMethodError("Must override by sub Class[" + getQualifiedClassName(this) + "]");
        }
    }
}