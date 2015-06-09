package Data.Values.ThreeD
{
    import flash.geom.Vector3D;
    
    import Data.Values.TValueBase;

    public class TThreeDConst extends TValueBase
    {
        private var FValue:Vector3D;
        
        public function TThreeDConst(x:Number = 0, y:Number = 0, z:Number = 0)
        {
            FValue = new Vector3D(x,y,z);
        }
        
        public function get X():Number
        {
            return FValue.x;
        }
        public function get Y():Number
        {
            return FValue.y;
        }
        public function get Z():Number
        {
            return FValue.z;
        }
        
        public function set X(value:Number):void
        {
            FValue.x = value;
        }
        public function set Y(value:Number):void
        {
            FValue.y = value;
        }
        public function set Z(value:Number):void
        {
            FValue.z = value;
        }
        
        override public function GenerateOneValue():*
        {
            return FValue.clone();
        }
    }
}