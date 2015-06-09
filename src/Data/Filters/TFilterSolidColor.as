package Data.Filters
{
    import Data.TParticle3DAnimation;
    
    import flare.materials.filters.ColorFilter;
    
    public class TFilterSolidColor extends TFilterBase
    {
        private var FColorFilter:ColorFilter;
        private var FColor:uint;
        private var FAlpha:Number;
        public function TFilterSolidColor(instance:TParticle3DAnimation, color:uint = 0xff0000, alpha:Number = 1)
        {
            super(instance, new ColorFilter(color, alpha));
            FColorFilter = Filter as ColorFilter;
            FColor = color;
            FAlpha = alpha;
        }
        
        public function get Alpha():Number {return FAlpha; }
        public function set Alpha(value:Number):void
        {
            FAlpha = value;
            FColorFilter.a = value;
            NotifyUpdate()
        }
        
        public function get Color():uint {return FColor; }
        public function set Color(value:uint):void
        {
            FColor = value;
            FColorFilter.color = value;
            NotifyUpdate();
        }
    }
}