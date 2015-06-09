package Data.Actions
{
    import flash.geom.Vector3D;
    
    import Data.TParticle3DInstance;
    import Data.Values.TValueBase;
    import Data.Values.ThreeD.TThreeDComposite;

    public class TActionPosition implements IAction
    {
        private static const PROPS_NAME:String = TActionPropsName.POSITION;
        
        private var FPosition:TValueBase;
        
        public function TActionPosition()
        {
            FPosition = new TThreeDComposite();
        }
        public function Process(target:TParticle3DInstance, delta:Number):void
        {
            if(!target.params[PROPS_NAME])
            {
                var position:Vector3D = target.params[PROPS_NAME] = FPosition.GenerateOneValue();
                target.params[TActionPropsName.INIT_POS].x = (target.x += position.x);
                target.params[TActionPropsName.INIT_POS].y = (target.y += position.y);
                target.params[TActionPropsName.INIT_POS].z = (target.z += position.z);
                
                target.params[PROPS_NAME] = true;
            }
        }
        
        public function get Position():TValueBase
        {
            return FPosition;
        }
        public function set Position(value:TValueBase):void
        {
            FPosition = value;
        }
        
        public function get SortIndex():int
        {
            return TActionSortIndex.ACTION_VELOCITY;
        }
    }
}