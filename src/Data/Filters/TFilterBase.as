package Data.Filters
{
    import Data.TParticle3DAnimation;
    import Data.Spaces.Particle3DSpace;
    
    import flare.flsl.FLSLFilter;

    use namespace Particle3DSpace;
    public class TFilterBase
    {
        private var FInstance:TParticle3DAnimation;
        private var FFilter:FLSLFilter;
        private var FIsDisposed:Boolean;
        
        public function TFilterBase(instance:TParticle3DAnimation, filter:FLSLFilter)
        {
            FInstance = instance;
            FFilter = filter;
        }
        
        public final function Dispose():void
        {
            if(!IsDisposed)
            {
                DoDispose();
                FIsDisposed = true;
            }
        }
        
        protected function DoDispose():void
        {
            
        }
        
        protected function NotifyUpdate():void
        {
            FFilter.build();
            FInstance.ClearBatch();
        }
        
        public function get Filter():FLSLFilter
        {
            return FFilter;
        }
        
        public function get IsDisposed():Boolean
        {
            return FIsDisposed;
        }
        
    }
}