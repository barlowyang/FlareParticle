package Geometry
{
    import flash.geom.Vector3D;
    
    import flare.core.Pivot3D;
    import flare.core.Surface3D;

    /**
     * 胶囊几何体
     */    
    public class TGeometryCapsule extends TGeometryBase
    {
        public static function get Type():int
        {
            return 3;
        }
        
        /**
         * 半径
         */        
        private var FRadius:Number;
        /**
         * 高度
         */        
        private var FHeight:Number;
        /**
         * 描述片段数
         */        
        private var FSegments:int;
        /**
         * 胶囊几何体
         * @param name              名字
         * @param radius            半径
         * @param height            高度
         * @param segments          描述片段数
         */        
        public function TGeometryCapsule(name:String = "capsule", radius:Number = 3, height:Number = 10, segments:int = 12)
        {
            Radius = radius;
            Height = height;
            Segments = segments;
            super(name);
        }
        
        override public function clone():Pivot3D
        {
            return CopyBaseInfo(new TGeometryCapsule(name,FRadius,FHeight,FSegments));
        }
        
        override protected function BuildGeometry():void
        {
            var surface:Surface3D = Surface;
            var normal:Vector3D = new Vector3D();
            var index:int = 0;
            var j:Number;
            var i:Number;
            var m:int = FSegments;
            var n:int = FSegments + 1;
            var tx:Number;
            var currentRadius:Number;
            var radiusFactor:Number;
            var tz:Number;
            var targetRadius:Number = FHeight - FRadius * 2;
            
            i = 0;
            while (i <= n)
            {
                currentRadius = (-Math.cos(i / n * Math.PI)) * FRadius;
                radiusFactor = i > n / 2 ? (targetRadius / 2) : ((-targetRadius) / 2);
                j = 0;
                while (j <= m)
                {
                    
                    tx = Math.cos(j / m * Math.PI * 2) * FRadius * Math.sin(i / n * Math.PI);
                    tz = (-Math.sin(j / m * Math.PI * 2)) * FRadius * Math.sin(i / n * Math.PI);
                    normal.x = tx;
                    normal.y = currentRadius;
                    normal.z = tz;
                    normal.normalize();
                    surface.vertexVector.push(tx, currentRadius + radiusFactor, tz, normal.x, normal.y, normal.z, 1 - j / FSegments, 1 - i / FSegments);
                    j++;
                }
                i++;
            }
            index = 0;
            i = 0;
            while (i < n)
            {
                j = 0;
                while (j < m)
                {
                    surface.indexVector[index++] = j + i * (m + 1);
                    surface.indexVector[index++] = (j + 1) + i * (m + 1);
                    surface.indexVector[index++] = j + (i + 1) * (m + 1);
                    surface.indexVector[index++] = (j + 1) + i * (m + 1);
                    surface.indexVector[index++] = (j + 1) + (i + 1) * (m + 1);
                    surface.indexVector[index++] = j + (i + 1) * (m + 1);
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
        /**
         * 高度
         */        
        public function get Height() : Number
        {
            return FHeight;
        }
        public function set Height(value:Number):void
        {
            if(value<0)
            {
                value = 0;
            }
            if(FHeight == value)
            {
                return;
            }
            FHeight = value;
            RefreshShape();
        }
    }
}