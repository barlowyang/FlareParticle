package Geometry
{
    public class TBlendMode
    {
        
        public static function GetFactorsByMode(mode:int):Array
        {
            switch(mode)
            {
                case TBlendMode.NONE:
                case TBlendMode.ADDITIVE:
                case TBlendMode.TRANSPARENT:
                case TBlendMode.MULTIPLY:
                case TBlendMode.REPRODUCTION:
                case TBlendMode.SCREEN:
                {
                    return BLEND_MODE_FACTORS[mode].split("|");
                }
                    
                default:
                {
                    return null;
                }
            }
        }
        
        public static function GetModeByFactor(sourceFactor:int, destFactor:int):int
        {
            var factor:String = sourceFactor + "|" + destFactor;
            return BLEND_MODE_FACTORS.indexOf(factor);
        }
        
        private static const BLEND_MODE_FACTORS:Array = [
            1 + "|" + 0, // 0
            1 + "|" + 1, // 1
            2 + "|" + 6, // 2
            5 + "|" + 6, // 3
            5 + "|" + 0, // 4
            1 + "|" + 7  // 5
        ]
            
        public static const NONE:int = 0;
        public static const ADDITIVE:int = 1;
        public static const TRANSPARENT:int = 2;
        public static const MULTIPLY:int = 3;
        public static const REPRODUCTION:int =  4;
        public static const SCREEN:int = 5;
        public static const CUSTOM:int = -1;
    }
}