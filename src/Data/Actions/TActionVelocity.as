package Data.Actions
{
    import flash.geom.Vector3D;
    
    import Data.TParticle3DInstance;
    import Data.Values.TValueBase;
    import Data.Values.ThreeD.TThreeDSphere;

    public class TActionVelocity implements IAction
    {
        private static const PROPS_NAME:String = TActionPropsName.VELOCITY;
        
        private var FVelocity:TValueBase;
        
        public function TActionVelocity()
        {
            FVelocity = new TThreeDSphere()
        }
        
        public function Process(target:TParticle3DInstance, delta:Number):void
        {
            var velocity:Vector3D = target.params[PROPS_NAME]
            var orginPoint:Vector3D = target.params[TActionPropsName.INIT_POS];
            if(!velocity)
            {
                velocity = FVelocity.GenerateOneValue();
                velocity.decrementBy(orginPoint);
                target.params[PROPS_NAME] = velocity;
                return;
            }
            
            var time:Number = target.params[TActionPropsName.TIME].t;
            target.x = orginPoint.x - velocity.x * time;
            target.y = orginPoint.y - velocity.y * time;
            target.z = orginPoint.z - velocity.z * time;
        }
        
        public function get Velocity():TValueBase
        {
            return FVelocity;
        }
        public function set Velocity(value:TValueBase):void
        {
            FVelocity = value;
        }
        
        public function get SortIndex():int
        {
            return TActionSortIndex.ACTION_VELOCITY;
        }
    }
}