package Geometry
{
    import flash.geom.Matrix3D;
    import flash.geom.Vector3D;
    
    import flare.core.Pivot3D;
    import flare.core.Surface3D;
    import flare.utils.Matrix3DUtils;

    /**
     * 平面几何体
     */
    public class TGeometryPlane extends TGeometryBase
    {
        public static function get Type():int
        {
            return 0;
        }
        /**
         * 高度
         */        
        private var FHeight:Number;
        /**
         * 宽度
         */        
        private var FWidth:Number;
        /**
         * 描述片段数
         */        
        private var FSegments:int;
        /**
         * 轴朝向
         */        
        private var FAxis:String;
        /**
         * 平面几何体
         * @param name              名字
         * @param width             宽度
         * @param height            高度
         * @param segments          描述片段数
         * @param axis              轴朝向
         */        
        public function TGeometryPlane(name:String="", width:Number = 10, height:Number = 10, segments:int = 1, axis:String = "+xy")
        {
            Height = height;
            Width = width;
            Segments = segments;
            Axis = axis;
            super(name);
        }
        
        override public function clone():Pivot3D
        {
            return CopyBaseInfo(new TGeometryPlane(name,FWidth,FHeight,FSegments,FAxis));
        }
        
        override protected function BuildGeometry():void
        {
            var index:int;
            var j:Number;
            var i:Number;
            var tw:Number;
            var th:Number;
            
            var direction:Matrix3D = TPlaneAxis.GetPlaneAxisVec(FAxis);
            
            Matrix3DUtils.setScale(direction, FWidth, FHeight, 1);
            
            var rawData:Vector.<Number> = direction.rawData;
            var rawVec:Vector3D = Matrix3DUtils.getDir(direction);
            var surface:Surface3D = Surface;
            
            index = 0;
            i = 0;
            while (i <= FSegments)
            {
                j = 0;
                while (j <= FSegments)
                {
                    tw = j / FSegments - 0.5;
                    th = i / FSegments - 0.5;
                    surface.vertexVector.push(tw * rawData[0] + th * rawData[4] + rawData[12], tw * rawData[1] + th * rawData[5] + rawData[13], tw * rawData[2] + th * rawData[6] + rawData[14], rawVec.x, rawVec.y, rawVec.z, 1 - j / FSegments, 1 - i / FSegments);
                    j++;
                }
                i++;
            }
            
            index = 0;
            i = 0;
            while (i < FSegments)
            {
                j = 0;
                while (j < FSegments)
                {
                    surface.indexVector[index++] = (j + 1) + i * (FSegments + 1);
                    surface.indexVector[index++] = (j + 1) + (i + 1) * (FSegments + 1);
                    surface.indexVector[index++] = j + (i + 1) * (FSegments + 1);
                    surface.indexVector[index++] = j + i * (FSegments + 1);
                    surface.indexVector[index++] = (j + 1) + i * (FSegments + 1);
                    surface.indexVector[index++] = j + (i + 1) * (FSegments + 1);
                    j++;
                }
                i++;
            }
        }
        /**
         * 宽度
         */        
        public function get Width():Number
        {
            return FWidth;
        }
        public function set Width(value:Number):void
        {
            if(value<0)
            {
                value = 0;
            }
            if(FWidth == value)
            {
                return;
            }
            FWidth = value;
            RefreshShape();
        }
        /**
         * 高度
         */        
        public function get Height():Number
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
         * 朝向
         * @see TPlaneAxis
         */        
        public function set Axis(value:String):void
        {
            if(FAxis == value)
            {
                return;
            }
            switch(value)
            {
                case TPlaneAxis.A_XY:
                case TPlaneAxis.B_XY:
                case TPlaneAxis.A_XZ:
                case TPlaneAxis.B_XZ:
                case TPlaneAxis.A_YZ:
                case TPlaneAxis.B_YZ:
                {
                    break;
                }
                default:
                {
                    return;
                }
            }
            FAxis = value;
            RefreshShape();
        }
        public function get Axis():String
        {
            return FAxis;
        }
    }
}