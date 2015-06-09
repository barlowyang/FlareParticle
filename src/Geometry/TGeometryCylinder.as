package Geometry
{
    import flash.geom.Vector3D;
    
    import flare.core.Pivot3D;
    import flare.core.Surface3D;

    /**
     * 柱形几何体
     * @author zhuliping
     */
    public class TGeometryCylinder extends TGeometryBase
    {
        public static function get Type():int
        {
            return 2;
        }
        
        private var FTopRadius:Number;
        private var FBottomRadius:Number;
        private var FHeight:Number;
        private var FSegments:int;
        private var FTopClose:Boolean;
        private var FBottomClose:Boolean;
        
        public function TGeometryCylinder(name:String = "cylinder", topRadius:Number = 5, bottomRadius:Number = 5, height:Number = 20, segments:int = 12)
        {
            Segments = segments;
            Height = height;
            BottomRadius = bottomRadius;
            TopRadius = topRadius;
            super(name);
        }
        
        override public function clone():Pivot3D
        {
            var geometry:TGeometryCylinder = new TGeometryCylinder(name,FTopRadius, FBottomRadius, FHeight, FSegments);
            geometry.BottomClose = FBottomClose;
            geometry.TopClose = FTopClose;
            return CopyBaseInfo(geometry);
        }
        
        override protected function BuildGeometry():void
        {
//            var _loc_7:* = surfaces[0];
//            var _loc_8:int = 0;
//            var _loc_9:int = 0;
//            var _loc_10:Number = NaN;
//            var _loc_11:Number = NaN;
//            var _loc_12:Number = NaN;
//            var _loc_13:Number = NaN;
//            var _loc_14:* = new Vector3D();
//            var _loc_15:* = FSegments;
//            var _loc_16:int = 0;
//            var _loc_17:int = 0;
//            var _loc_18:Surface3D = null;
//            var _loc_19:Number = NaN;
//            
//            var param2:Number = FTopRadius;
//            var param3:Number = FBottomRadius;
//            var p
//            _loc_10 = 0;
//            while (_loc_10 <= _loc_15)
//            {
//                
//                _loc_12 = 0;
//                _loc_11 = 
//                _loc_14.x = _loc_11;
//                _loc_14.y = (param2 - param3) / param4;
//                _loc_14.z = _loc_13;
//                _loc_14.normalize();
//                _loc_7.vertexVector.push(_loc_11 * param2, 0, _loc_13 * param2, _loc_14.x, _loc_14.y, _loc_14.z, _loc_10 / param5, 1);
//                _loc_7.vertexVector.push(_loc_11 * param3, param4, _loc_13 * param3, _loc_14.x, _loc_14.y, _loc_14.z, _loc_10 / param5, 0);
//                _loc_8 = _loc_8 + 1;
//                _loc_10 = _loc_10 + 1;
//            }
//            if (param2 > 0)
//            {
//                _loc_16 = _loc_7.vertexVector.length / _loc_7.sizePerVertex;
//                _loc_10 = 0;
//                while (_loc_10 <= _loc_15)
//                {
//                    
//                    _loc_11 = Math.cos(_loc_10 / _loc_15 * Math.PI * 2) * param2;
//                    _loc_13 = (-Math.sin(_loc_10 / _loc_15 * Math.PI * 2)) * param2;
//                    _loc_7.vertexVector.push(_loc_11, 0, _loc_13, 0, -1, 0, _loc_11 / this._radius1 * 0.5, _loc_13 / this._radius1 * 0.5);
//                    _loc_10 = _loc_10 + 1;
//                }
//            }
//            if (param3 > 0)
//            {
//                _loc_17 = _loc_7.vertexVector.length / _loc_7.sizePerVertex;
//                _loc_10 = 0;
//                while (_loc_10 <= _loc_15)
//                {
//                    
//                    _loc_11 = Math.cos(_loc_10 / _loc_15 * Math.PI * 2) * param3;
//                    _loc_13 = (-Math.sin(_loc_10 / _loc_15 * Math.PI * 2)) * param3;
//                    _loc_7.vertexVector.push(_loc_11, param4, _loc_13, 0, 1, 0, _loc_11 / this._radius2 * 0.5, _loc_13 / this._radius2 * 0.5);
//                    _loc_10 = _loc_10 + 1;
//                }
//            }
//            _loc_8 = 0;
//            _loc_10 = 0;
//            while (_loc_10 < _loc_15)
//            {
//                
//                var _loc_20:* = _loc_8 ++;
//                _loc_7.indexVector[_loc_20] = _loc_10 * 2 + 2;
//                var _loc_21:* = _loc_8 ++;
//                _loc_7.indexVector[_loc_21] = _loc_10 * 2 + 1;
//                var _loc_22:* = _loc_8 ++;
//                _loc_7.indexVector[_loc_22] = _loc_10 * 2;
//                var _loc_23:* = _loc_8 ++;
//                _loc_7.indexVector[_loc_23] = _loc_10 * 2 + 2;
//                var _loc_24:* = _loc_8 ++;
//                _loc_7.indexVector[_loc_24] = _loc_10 * 2 + 3;
//                var _loc_25:* = _loc_8 ++;
//                _loc_7.indexVector[_loc_25] = _loc_10 * 2 + 1;
//                _loc_10 = _loc_10 ++;
//            }
//            if (param2 > 0)
//            {
//                _loc_10 = 1;
//                while (_loc_10 < (_loc_15 - 1))
//                {
//                    
//                    var _loc_20:* = _loc_8 ++;
//                    _loc_7.indexVector[_loc_20] = _loc_16 + _loc_10 + 1;
//                    var _loc_21:* = _loc_8 ++;
//                    _loc_7.indexVector[_loc_21] = _loc_16 + _loc_10;
//                    var _loc_22:* = _loc_8 ++;
//                    _loc_7.indexVector[_loc_22] = _loc_16;
//                    _loc_10 = _loc_10 ++;
//                }
//            }
//            if (param3 > 0)
//            {
//                _loc_10 = 1;
//                while (_loc_10 < (_loc_15 - 1))
//                {
//                    
//                    var _loc_20:* = _loc_8 ++;
//                    _loc_7.indexVector[_loc_20] = _loc_17;
//                    var _loc_21:* = _loc_8 ++;
//                    _loc_7.indexVector[_loc_21] = _loc_17 + _loc_10;
//                    var _loc_22:* = _loc_8 ++;
//                    _loc_7.indexVector[_loc_22] = _loc_17 + _loc_10 + 1;
//                    _loc_10 = _loc_10 ++;
//                }
//            }
//            
//            return;
            var surface:Surface3D = Surface;
            var target:uint = FSegments;
            var current:uint = 0;
            
            var topRadius:Number = FTopRadius;
            var bottomRadius:Number = FBottomRadius;
            
            var postion:Vector3D = new Vector3D();
            
            var normal:Vector3D = new Vector3D();
            normal.x = 0;
            normal.y = (topRadius - bottomRadius)/FHeight;
            normal.z = 0;
            normal.normalize();
            
            //设置顶点信息
            current = 0;
            while (current <= target)
            {
                postion.x = Math.cos(current / target * Math.PI * 2);
                postion.y = FHeight * 0.5;
                postion.z = Math.sin(current / target * Math.PI * 2);
                surface.vertexVector.push(postion.x * topRadius, postion.y, postion.z * topRadius, postion.x, normal.y, postion.z, current / target, 0);
                surface.vertexVector.push(postion.x * bottomRadius, -postion.y, postion.z * bottomRadius, postion.x, normal.y, postion.z, current / target, 1);
                current++;
            }
            var topRadiusFactor:int;
            if (FTopClose && topRadius > 0)
            {
                topRadiusFactor = surface.vertexVector.length / surface.sizePerVertex;
                current = target;
                while (current > 0)
                {
                    postion.x = Math.cos(current / target * Math.PI * 2) * topRadius;
                    postion.z = (-Math.sin(current / target * Math.PI * 2)) * topRadius;
                    surface.vertexVector.push(postion.x, FHeight*0.5, postion.z, postion.x, 1, postion.y, postion.x / topRadius * 0.5, postion.z / topRadius * 0.5);
                    current--;
                }
            }
            
            var bottomRadiusFactor:int;
            if (FBottomClose && bottomRadius > 0)
            {
                bottomRadiusFactor = surface.vertexVector.length / surface.sizePerVertex;
                current = target;
                while (current > 0)
                {
                    postion.x = Math.cos(current / target * Math.PI * 2) * bottomRadius;
                    postion.z = (-Math.sin(current / target * Math.PI * 2)) * bottomRadius;
                    surface.vertexVector.push(postion.x, -FHeight*.5, postion.z, 0, -1, 0, postion.x / bottomRadius * 0.5, postion.z / bottomRadius * 0.5);
                    current--;
                }
            }
            
            //设置索引
            var index:int = 0;
            current = 0;
            while (current < target)
            {
                surface.indexVector[index++] = current * 2 + 2;
                surface.indexVector[index++] = current * 2 + 1;
                surface.indexVector[index++] = current * 2;
                surface.indexVector[index++] = current * 2 + 2;
                surface.indexVector[index++] = current * 2 + 3;
                surface.indexVector[index++] = current * 2 + 1;
                current++
            }
            if (FTopClose && topRadius > 0)
            {
                current = 1;
                while (current < (target - 1))
                {
                    surface.indexVector[index++] = topRadiusFactor + current + 1;
                    surface.indexVector[index++] = topRadiusFactor + current;
                    surface.indexVector[index++] = topRadiusFactor;
                    current++;
                }
            }
            if (FBottomClose && bottomRadius > 0)
            {
                current = 1;
                while (current < (target - 1))
                {
                    surface.indexVector[index++] = bottomRadiusFactor;
                    surface.indexVector[index++] = bottomRadiusFactor + current;
                    surface.indexVector[index++] = bottomRadiusFactor + current + 1;
                    current++
                }
            }
        }

        /**
         * 顶部半径
         */        
        public function get TopRadius() : Number
        {
            return FTopRadius;
        }
        public function set TopRadius(value:Number):void
        {
            if(value<0)
            {
                value = 0;
            }
            if(FTopRadius==value)
            {
                return;
            }
            FTopRadius = value;
            RefreshShape();
        }
        
        /**
         * 底部半径
         */
        public function get BottomRadius() : Number
        {
            return FBottomRadius;
        }
        public function set BottomRadius(value:Number):void
        {
            if(value<0)
            {
                value = 0;
            }
            if(FBottomRadius==value)
            {
                return;
            }
            FBottomRadius = value;
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
            if(FHeight==value)
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
         * 封闭顶部
         */        
        public function get TopClose():Boolean
        {
            return FTopClose;
        }
        public function set TopClose(value:Boolean):void
        {
            FTopClose = value;
            RefreshShape();
        }
        
        /**
         * 封闭底部
         */        
        public function get BottomClose():Boolean
        {
            return FBottomClose;
        }
        public function set BottomClose(value:Boolean):void
        {
            FBottomClose = value;
            RefreshShape();
        }
    }
}