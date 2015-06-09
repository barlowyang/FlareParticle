package Data.Values
{
    import GT.Errors.AbstractMethodError;

    public class TValueBase
    {
        
        public function TValueBase()
        {
        }
        
        public function GenerateOneValue():*
        {
            throw new AbstractMethodError("Must override by sub class!");
        }
    }
}