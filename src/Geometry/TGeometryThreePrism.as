package Geometry
{
    import flash.geom.Vector3D;
    
    import flare.core.Pivot3D;
    import flare.core.Surface3D;
    
    /**
     * 三角棱柱几何
     */    
    public class TGeometryThreePrism extends TGeometryBase
    {
        public static function get Type():int
        {
            return 5;
        }
        /**
         * 长度
         */        
        private var FLength:Number;
        /**
         * 宽度
         */        
        private var FWidth:Number;
        /**
         * 高度
         */        
        private var FHeight:Number;
        
        /**
         * 三角棱柱几何
         * @param name      名字
         * @param length    长度
         * @param width     宽度
         * @param height    高度
         * 
         */        
        public function TGeometryThreePrism(name:String = "threePrism", length:Number = 20, width:Number = 5, height:Number = 5)
        {
            Height = height;
            Width = width;
            Length = length;
            super(name);
        }
        
        override public function clone():Pivot3D
        {
            return new TGeometryCylinder()//CopyBaseInfo(new TGeometryCylinder(name,FLength, FWidth, FHeight));
        }
        
        override protected function BuildGeometry():void
        {
            var i:int;
            var j:int;
            var k:int;
            var xpos:Number;
            var ypos:Number;
            var zpos:Number;
            
            var surface:Surface3D = Surface;
            
            var normal:Vector3D = new Vector3D();
            
            var hArray:Array = [0, 0, 1, 0];
            var xArray:Array = [1, -1, 1];
            var zArray:Array = [-1, 1, 0, -1];
            
            i = 0;
            while (i < 2) 
            {
                j = 0;
                while (j <= 3)
                {
                    zpos = FWidth / 2 * zArray[j];
                    xpos = FLength / 2 * xArray[i];
                    ypos = FHeight * hArray[j];
                    normal.x = xpos;
                    normal.y = ypos;
                    normal.z = zpos;
                    normal.normalize();
                    surface.vertexVector.push(xpos, ypos, zpos, normal.x, normal.y, normal.z, 1 - j / 3, 1 - i / 2 );
                    j++;
                }
                i++;
            }
            
            k = 0;
            j = 0;
            while (j < 3) 
            {
                surface.indexVector[k++] =  j + 1 ;
                surface.indexVector[k++] = j + 5;
                surface.indexVector[k++] = j + 4;
                surface.indexVector[k++] = j + 4;
                surface.indexVector[k++] = j;
                surface.indexVector[k++] = j + 1 ;
                j++;
            }
            surface.indexVector[k++] = 0;
            surface.indexVector[k++] = 2;
            surface.indexVector[k++] = 1;
            surface.indexVector[k++] = 4;
            surface.indexVector[k++] = 5;
            surface.indexVector[k++] = 6;
            
            
        }
        /**
         * 长度
         */        
        public function get Length():Number
        {
            return FLength;
        }
        public function set Length(value:Number):void
        {
            if(value<0)
            {
                value = 0;
            }
            if(FLength==value)
            {
                return;
            }
            FLength = value;
            RefreshShape();
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
            if(FWidth==value)
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
            if(FHeight==value)
            {
                return;
            }
            FHeight = value;
            RefreshShape();
        }
        
    }
}