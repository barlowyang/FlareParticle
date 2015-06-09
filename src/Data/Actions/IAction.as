package Data.Actions
{
    import Data.TParticle3DInstance;

    public interface IAction
    {
        function get SortIndex():int
        function Process(target:TParticle3DInstance, delta:Number):void 
    }
}