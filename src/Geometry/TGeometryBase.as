package Geometry
{
    import flash.events.Event;
    
    import flare.core.Mesh3D;
    import flare.core.Surface3D;
    import flare.materials.Shader3D;
    import flare.materials.filters.NullFilter;
    
    /**
     * 几何体基类
     */    
    public class TGeometryBase extends Mesh3D
    {
        private static const NULL_FILTER:NullFilter = new NullFilter();
        
        private var FNeedRefreshShape:Boolean;
        
        private var FMaterial:Shader3D;
        private var FUseLight:Boolean;
        private var FTwoSideMaterial:Boolean;
        private var FSourceFactor:String;
        private var FDestFactor:String;
        
        /**
         * 几何体基类
         * @param name  名字
         */        
        public function TGeometryBase(name:String = "")
        {
            super(name);
            FMaterial = new Shader3D(name + "Material");
            UpdateShape();
        }
        
        public function CheckShapeVaildate():void
        {
            if(FNeedRefreshShape)
            {
                UpdateShape();
                FNeedRefreshShape = false;
            }
        }
        
        /**
         * 刷新形状
         */        
        protected function RefreshShape():void
        {
            FNeedRefreshShape = true;
        }
        
        private function NotifyUpdate():void
        {
            dispatchEvent(new Event("Update"));
        }
        
        /**
         * 绘制
         */        
        protected function BuildGeometry():void
        {
            
        }
        
        protected function CopyBaseInfo(geometry:TGeometryBase):TGeometryBase
        {
            geometry.SourceFactor = FSourceFactor;
            geometry.DestFactor = FDestFactor;
            geometry.EnabledTwoSideMaterial = FTwoSideMaterial;
            geometry.EnabledLight = FUseLight;
            return geometry;
        }
        
        /**
         * 重建模型
         */        
        private function UpdateShape():void
        {
            if(surfaces.length)
            {
                surfaces[0].dispose();
            }
            
            var surface:Surface3D = surfaces[0] = new Surface3D();
            surface.addVertexData(Surface3D.POSITION);
            surface.addVertexData(Surface3D.NORMAL);
            surface.addVertexData(Surface3D.UV0);
            surface.vertexVector = new Vector.<Number>();
            surface.indexVector = new Vector.<uint>();
            BuildGeometry();
            for each (surface in surfaces)
            {
                surface.updateBoundings();
            }
            bounds = surfaces[0].bounds.clone();
            UpdateFilter();
        }
        
        /**
         * 刷新材质
         */        
        public function UpdateFilter(...filters):void
        {
            if(filters.length)
            {
                FMaterial.filters = filters;
            }
            Surface.material = FMaterial;
            NotifyUpdate();
        }
        
        protected function get Surface():Surface3D
        {
            return surfaces[0];
        }
        
        public function get SourceFactor():String { return FSourceFactor; }
        public function set SourceFactor(v:String):void
        {
            if(SourceFactor == v) return;
            FSourceFactor = v;
            FMaterial.sourceFactor = v;
            NotifyUpdate();
        }
            
        public function get DestFactor():String { return FDestFactor; }
        public function set DestFactor(v:String):void
        {
            if(FDestFactor == v) return;
            FDestFactor = v;
            FMaterial.destFactor = v;
            NotifyUpdate();
        }
        
        public function set EnabledTwoSideMaterial(v:Boolean):void
        {
            if(FTwoSideMaterial == v) return;
            FTwoSideMaterial = v;
            FMaterial.twoSided = v;
            NotifyUpdate();
        }
        
        public function set EnabledLight(v:Boolean):void
        {
            if(FUseLight == v) return;
            FUseLight = v;
            FMaterial.enableLights = v;
            NotifyUpdate();
        }
        
        
    }
}