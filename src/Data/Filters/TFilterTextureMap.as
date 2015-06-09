package Data.Filters
{
    import Data.TParticle3DAnimation;
    
    import flare.core.Texture3D;
    import flare.materials.filters.TextureMapFilter;
    
    public class TFilterTextureMap extends TFilterBase
    {
        private var FTextureMapFilter:TextureMapFilter;
        private var FTextureData:Texture3D;
        private var FTextureId:String;
        
        private var FTextureOffsetX:Number;
        private var FTextureOffsetY:Number;
        private var FTextureRepeatX:Number;
        private var FTextureRepeatY:Number;
        private var FTextureAlpha:Number;
        private var FTextureRepeatType:int;
        
        public function TFilterTextureMap(instance:TParticle3DAnimation)
        {
            super(instance, new TextureMapFilter());
            FTextureMapFilter = Filter as TextureMapFilter;
            FTextureAlpha = 1;
            FTextureRepeatX = 1;
            FTextureRepeatY = 1;
            FTextureOffsetX = 0;
            FTextureOffsetY = 0;
        }
        
        override protected function DoDispose():void
        {
            if(FTextureData)
            {
                FTextureData.dispose();
            }
        }
        
        public function get TextureOffsetX():Number
        {
            return FTextureOffsetX;
        }
        
        public function get TextureOffsetY():Number
        {
            return FTextureOffsetY;
        }
        public function get TextureRepeatX():Number
        {
            return FTextureRepeatX;
        }
        
        public function get TextureRepeatY():Number
        {
            return FTextureRepeatY;
        }
        
        public function get Alpha():Number
        {
            return FTextureAlpha;
        }
        
        public function get TextureRepeatType():int
        {
            return FTextureRepeatType;
        }
        public function set TextureRepeatType(value:int):void
        {
            FTextureRepeatType = value;
            if(FTextureData)
            {
                FTextureData.wrapMode = FTextureRepeatType;
            }
            NotifyUpdate();
        }
        public function set Texture(texture:Texture3D):void
        {
            if(texture)
            {
                texture.wrapMode = FTextureRepeatType;
            }
            FTextureData = texture;
            FTextureMapFilter.texture = texture;
            NotifyUpdate();
        }
        public function get Texture():Texture3D
        {
            return FTextureData;
        }
        
        public function set TextureOffsetX(v:Number):void
        {
            FTextureOffsetX = v;
            FTextureMapFilter.offsetX = v;
            NotifyUpdate();
        }
        public function set TextureOffsetY(v:Number):void
        {
            FTextureOffsetY = v;
            FTextureMapFilter.offsetY = v;
            NotifyUpdate();
        }
        
        public function set TextureRepeatX(v:Number):void
        {
            FTextureRepeatX = v;
            FTextureMapFilter.repeatX = v;
            NotifyUpdate();
        }
        
        public function set TextureRepeatY(v:Number):void
        {
            FTextureRepeatY = v;
            FTextureMapFilter.repeatY = v;
            NotifyUpdate();
        }
        
        public function set Alpha(v:Number):void
        {
            FTextureAlpha = v;
            FTextureMapFilter.alpha = v;
            NotifyUpdate();
        }
    }
}