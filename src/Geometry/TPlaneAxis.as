package Geometry
{
    import flash.geom.Matrix3D;
    import flash.geom.Vector3D;
    
    import flare.utils.Matrix3DUtils;
    /**
     * 平面朝向
     */
    public class TPlaneAxis
    {
        public static const A_XY:String = "+xy";
        public static const B_XY:String = "-xy";
        public static const A_XZ:String = "+xz";
        public static const B_XZ:String = "-xz";
        public static const A_YZ:String = "+yz";
        public static const B_YZ:String = "-yz";
        
        /**
         * 获取平面朝向的轴向量
         * @param axis  朝向
         */        
        public static function GetPlaneAxisVec(axis:String):Matrix3D
        {
            var dir:Matrix3D = new Matrix3D();
            if (axis == TPlaneAxis.A_XY)
            {
                Matrix3DUtils.setOrientation(dir, new Vector3D(0, 0, -1));
            }
            else if (axis == TPlaneAxis.B_XY)
            {
                Matrix3DUtils.setOrientation(dir, new Vector3D(0, 0, 1));
            }
            else if (axis == TPlaneAxis.A_XZ)
            {
                Matrix3DUtils.setOrientation(dir, new Vector3D(0, 1, 0));
            }
            else if (axis == TPlaneAxis.B_XZ)
            {
                Matrix3DUtils.setOrientation(dir, new Vector3D(0, -1, 0));
            }
            else if (axis == TPlaneAxis.A_YZ)
            {
                Matrix3DUtils.setOrientation(dir, new Vector3D(1, 0, 0));
            }
            else if (axis == TPlaneAxis.B_YZ)
            {
                Matrix3DUtils.setOrientation(dir, new Vector3D(-1, 0, 0));
            }
            return dir;
        }
    }
}