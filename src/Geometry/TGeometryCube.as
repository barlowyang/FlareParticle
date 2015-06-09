package Geometry
{
    import flash.geom.Matrix3D;
    import flash.geom.Vector3D;
    
    import flare.core.Pivot3D;
    import flare.core.Surface3D;
    import flare.utils.Matrix3DUtils;
    
    /**
     * 方形几何体
     */    
    public class TGeometryCube extends TGeometryBase
    {
        public static function get Type():int
        {
            return 1;
        }
        /**
         * 深度
         */        
        private var FDepth:Number;
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
         * 方形几何
         * @param name          名字
         * @param width         宽度
         * @param height        高度
         * @param depth         深度
         * @param segments      描述片段数
         * 
         */        
        public function TGeometryCube(name:String="cube", width:Number = 10, height:Number = 10, depth:Number = 10, segments:int = 1)
        {
            Depth = depth;
            Height = height;
            Width = width;
            Segments = segments;
            super(name);
        }
        
        override public function clone():Pivot3D
        {
            return CopyBaseInfo(new TGeometryCube(name,FWidth,FHeight,FDepth,FSegments));
        }
        
        override protected function BuildGeometry():void
        {
            createPlane(FWidth, FHeight, FDepth * 0.5,  FSegments, TPlaneAxis.A_XY);
            createPlane(FWidth, FHeight, FDepth * 0.5,  FSegments, TPlaneAxis.B_XY);
            
            createPlane(FWidth, FDepth,  FHeight * 0.5, FSegments, TPlaneAxis.A_XZ);
            createPlane(FWidth, FDepth,  FHeight * 0.5, FSegments, TPlaneAxis.B_XZ);
            
            createPlane(FDepth, FHeight, FWidth * 0.5,  FSegments, TPlaneAxis.A_YZ);
            createPlane(FDepth, FHeight, FWidth * 0.5,  FSegments, TPlaneAxis.B_YZ);
            
        }
        /**
         * 创建面
         */ 
        private function createPlane(width:Number, height:Number, depth:Number, segment:int, axis:String) : void
        {
            var j:Number;
            var i:Number;
            var tw:Number;
            var th:Number;
            
            var surface:Surface3D = Surface;
            var direction:Matrix3D = TPlaneAxis.GetPlaneAxisVec(axis);
            Matrix3DUtils.setScale(direction, width, height, 1);
            Matrix3DUtils.translateZ(direction, depth);
            
            var rawData:Vector.<Number> = direction.rawData;
            var rawVec:Vector3D = Matrix3DUtils.getDir(direction);
            var offset:int = surface.vertexVector.length / surface.sizePerVertex;;
            i = 0;
            while (i <= segment)
            {
                j = 0;
                while (j <= segment)
                {
                    tw = j / segment - 0.5;
                    th = i / segment - 0.5;
                    surface.vertexVector.push(tw * rawData[0] + th * rawData[4] + rawData[12], tw * rawData[1] + th * rawData[5] + rawData[13], tw * rawData[2] + th * rawData[6] + rawData[14], rawVec.x, rawVec.y, rawVec.z, 1 - j / segment, 1 - i / segment);
                    j++
                }
                i++
            }
            var index:int = surface.indexVector.length;
            i = 0;
            while (i < segment)
            {
                j = 0;
                while (j < segment)
                {
                    surface.indexVector[index++] = (j + 1) + i * (segment + 1) + offset;
                    surface.indexVector[index++] = (j + 1) + (i + 1) * (segment + 1) + offset;
                    surface.indexVector[index++] = j + (i + 1) * (segment + 1) + offset;
                    surface.indexVector[index++] = j + i * (segment + 1) + offset;
                    surface.indexVector[index++] = (j + 1) + i * (segment + 1) + offset;
                    surface.indexVector[index++] = j + (i + 1) * (segment + 1) + offset;
                    j++
                }
                i++
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
         * 深度
         */ 
        public function get Depth():Number
        {
            return FDepth;
        }
        public function set Depth(value:Number):void
        {
            if(value<0)
            {
                value = 0;
            }
            if(FDepth == value)
            {
                return;
            }
            FDepth = value;
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

    }
}