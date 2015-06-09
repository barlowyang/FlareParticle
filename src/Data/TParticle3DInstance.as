package Data
{
    import Data.Actions.IAction;
    
    import flare.core.Pivot3D;
    
    public class TParticle3DInstance extends Pivot3D
    {
        
        public var root:TParticle3DAnimation;
        public var params:Object;
        public var isReady:Boolean;
        public var isFinished:Boolean;
        public function TParticle3DInstance(name:String="")
        {
            super(name);
            params = {};
        }
        
        public function ApplyActions(FActionList:Vector.<IAction>, delta:Number):void
        {
            var len:int = FActionList.length;

            for(var i:int = 0; i<len; i++)
            {
                if(isFinished)
                {
                    return;
                }
                
                FActionList[i].Process(this, delta);
                
                if(!isReady)
                {
                    return;
                }
            }
        }
    }
}