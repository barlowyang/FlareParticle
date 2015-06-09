package Geometry
{
    import flash.geom.Vector3D;
    
    import flare.core.Pivot3D;
    import flare.core.Surface3D;
    
    /**
     * 球形几何体
     */    
    public class TGeometrySphere extends TGeometryBase
    {
        public static function get Type():int
        {
            return 4;
        }
        /**
         * 半径
         */   
        private var FRadius:Number;
        /**
         * 描述片段数
         */  
        private var FSegments:int;
        
        /**
         * 球形几何
         * @param name          名字
         * @param radius        半径
         * @param segments      描述片段数
         */        
        public function TGeometrySphere(name:String="sphere", radius:Number = 5, segments:int = 12)
        {
            Radius = radius;
            Segments = segments;
            super(name);
        }
        
        override public function clone():Pivot3D
        {
            return CopyBaseInfo(new TGeometrySphere(name,FRadius,Segments));
        }
        
        override protected function BuildGeometry():void
        {
            var surface:Surface3D = Surface;
            var normal:Vector3D = new Vector3D();
            var index:int;
            var n:int = FSegments;
            var m:int = FSegments + 1;
            var j:int;
            var i:int;
            
            var tx:Number = NaN;
            var ty:Number = NaN;
            var tz:Number = NaN;
            
            i = 0;
            while (i <= m)
            {
                j = 0;
                while (j <= n)
                {
                    ty = (-Math.cos(i / m * Math.PI)) * FRadius;
                    tx = Math.cos(j / n * Math.PI * 2) * FRadius * Math.sin(i / m * Math.PI);
                    tz = (-Math.sin(j / n * Math.PI * 2)) * FRadius * Math.sin(i / m * Math.PI);
                    normal.x = tx;
                    normal.y = ty;
                    normal.z = tz;
                    normal.normalize();
                    surface.vertexVector.push(tx, ty, tz, normal.x, normal.y, normal.z, 1 - j / FSegments, 1 - i / FSegments);
                    index++;
                    j++;
                }
                i++;
            }
            index = 0;
            i = 0;
            while (i < m)
            {
                
                j = 0;
                while (j < n)
                {
                    surface.indexVector[index++] = j + i * (n + 1);
                    surface.indexVector[index++] = (j + 1) + i * (n + 1);
                    surface.indexVector[index++] = j + (i + 1) * (n + 1);
                    surface.indexVector[index++] = (j + 1) + i * (n + 1);
                    surface.indexVector[index++] = (j + 1) + (i + 1) * (n + 1);
                    surface.indexVector[index++] = j + (i + 1) * (n + 1);
                    j++;
                }
                i++;
            }
            
        }
        
        /**
         * 描述片段数
         */  
        public function get Segments() : int
        {
            return FSegments;
        }
        public function set Segments(value:int):void
        {
            if(value<0)
            {
                value = 0;
            }
            if(FSegments == value)
            {
                return;
            }
            FSegments = value;
            RefreshShape();
        }
        
        /**
         * 半径
         */        
        public function get Radius() : Number
        {
            return FRadius;
        }
        public function set Radius(value:Number):void
        {
            if(value<0)
            {
                value = 0;
            }
            if(FRadius == value)
            {
                return;
            }
            FRadius = value;
            RefreshShape();
        }
    }
}