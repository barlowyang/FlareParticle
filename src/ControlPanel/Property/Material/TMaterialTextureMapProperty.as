package ControlPanel.Property.Material
{
    import flash.display.Bitmap;
    import flash.display.DisplayObjectContainer;
    import flash.display.Loader;
    import flash.events.Event;
    import flash.filesystem.File;
    import flash.filesystem.FileMode;
    import flash.filesystem.FileStream;
    import flash.net.FileFilter;
    import flash.utils.ByteArray;
    
    import Data.TParticle3DAnimation;
    import Data.Filters.TFilterTextureMap;
    
    import bit101.components.ComboBox;
    import bit101.components.Label;
    import bit101.components.NumericStepper;
    import bit101.components.Panel;
    import bit101.components.PushButton;
    import bit101.components.Text;
    
    import flare.core.Texture3D;

    public class TMaterialTextureMapProperty extends Panel
    {
        private var FTarget:TFilterTextureMap;
        
        private var FTexturePath:Text;
        private var FAlpha:NumericStepper;
        
        private var FOffsetX:NumericStepper;
        private var FOffsetY:NumericStepper;
        
        private var FRepeatX:NumericStepper;
        private var FRepeatY:NumericStepper;
        private var FRepeatType:ComboBox;
        
        
        public function TMaterialTextureMapProperty(container:DisplayObjectContainer, xPos:Number, yPos:Number)
        {
            super(container, xPos, yPos);
            height = 105;
        }
        
        public function RemoveFromParent():void
        {
            if(parent)
            {
                parent.removeChild(this);
            }
        }
        
        override protected function addChildren():void
        {
            super.addChildren();
            
            var xPos:int;
            var yPos:int;
            
            new Label(this, xPos = 5, yPos = 5, "贴图路径:");
            FTexturePath = new Text(this, xPos+=59, yPos-2, "null");
            FTexturePath.editable = false;
            FTexturePath.setSize(183,20);
            var btn:PushButton = new PushButton(this,xPos+=186, yPos-2,"选择", ToSelectTexture);
            btn.setSize(60,20);
            
            new Label(this, xPos = 5, yPos+=25, "　透明度:");
            FAlpha = new NumericStepper(this, xPos+=60,yPos);
            FAlpha.minimum = 0;
            FAlpha.maximum = 1;
            FAlpha.step = 0.01;
            FAlpha.labelPrecision = 2;
            FAlpha.addEventListener(Event.CHANGE, UpdateProperty);
            
            new Label(this, xPos+=95, yPos,"重复类型:")
            FRepeatType = new ComboBox(this, xPos+=60, yPos);
            FRepeatType.items = ["ONCE","REPEAT", "REPEAT_V", "REPEAT_U"   ];
            FRepeatType.addEventListener(Event.SELECT, UpdateProperty);
            FRepeatType.width = 80
            new Label(this, xPos = 5, yPos+=25, "水平重复:");
            FRepeatX = new NumericStepper(this, xPos+=60, yPos);
            FRepeatX.step = 0.01;
            FRepeatX.labelPrecision = 2;
            FRepeatX.addEventListener(Event.CHANGE, UpdateProperty);
            
            new Label(this, xPos += 95, yPos, "垂直重复:");
            FRepeatY = new NumericStepper(this, xPos+=60, yPos);
            FRepeatY.step = 0.01;
            FRepeatY.labelPrecision = 2;
            FRepeatY.addEventListener(Event.CHANGE, UpdateProperty);
            
            
            new Label(this, xPos = 5, yPos+=25, "水平偏移:");
            FOffsetX = new NumericStepper(this, xPos+=60, yPos);
            FOffsetX.step = 0.01;
            FOffsetX.labelPrecision = 2;
            FOffsetX.addEventListener(Event.CHANGE, UpdateProperty);
            
            new Label(this, xPos += 95, yPos, "垂直偏移:");
            FOffsetY = new NumericStepper(this, xPos+=60, yPos);
            FOffsetY.step = 0.01;
            FOffsetY.labelPrecision = 2;
            FOffsetY.addEventListener(Event.CHANGE, UpdateProperty);
            
        }
        //    private static const REPEAT_TYPES:Array = [ 
        //        Texture3D.WRAP_REPEAT,
        //        Texture3D.WRAP_CLAMP_V,
        //        Texture3D.WRAP_CLAMP_U,
        //        Texture3D.WRAP_CLAMP
        //    ]
        
        private function UpdateProperty(e:Event):void
        {
            switch(e.currentTarget)
            {
                case FRepeatType:
                {
                    FTarget.TextureRepeatType = FRepeatType.selectedIndex;
                    break;
                }
                case FAlpha:
                {
                    FTarget.Alpha = FAlpha.value;
                    break;
                }
                    
                case FOffsetX:
                {
                    FTarget.TextureOffsetX = FOffsetX.value;
                    break;
                }
                case FOffsetY:
                {
                    FTarget.TextureOffsetY = FOffsetX.value;
                    break;
                }
                case FRepeatX:
                {
                    FTarget.TextureRepeatX = FRepeatX.value;
                    break;
                }
                case FRepeatY:
                {
                    FTarget.TextureRepeatY = FRepeatY.value;
                    break;
                }
            }
        }
        
        private function ToSelectTexture(e:Event):void
        {
            var file:File = new File();
            file.browseForOpen("选择贴图", [new FileFilter("支持的贴图格式 *.jpg; *.bmp; *.png; *.atf", "*.jpg; *.bmp; *.png; *.atf", "*.jpg; *.bmp; *.png; *.atf")]);
            file.addEventListener(Event.CANCEL, SelectedTexture);
            file.addEventListener(Event.SELECT, SelectedTexture);
        }
        
        private function SelectedTexture(e:Event):void
        {
            var file:File = e.currentTarget as File;
            file.removeEventListener(Event.CANCEL, SelectedTexture);
            file.removeEventListener(Event.SELECT, SelectedTexture);
            if(e.type == Event.SELECT)
            {
                var fs:FileStream = new FileStream();
                fs.open(file, FileMode.READ);
                var bytes:ByteArray = new ByteArray();
                fs.readBytes(bytes);
                fs.close();
                
                FTexturePath.text = file.url;
                
                if(file.extension == "atf")
                {
                    FTarget.Texture = new Texture3D(bytes);
                }
                else
                {
                    var loader:Loader = new Loader();
                    loader.contentLoaderInfo.addEventListener(Event.COMPLETE, TextureLoaded);
                    loader.loadBytes(bytes);
                }
            }
        }
        
        private function TextureLoaded(e:Event):void
        {
            var loader:Loader = e.currentTarget.loader;
            loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, TextureLoaded);
            if(loader.content is Bitmap)
            {
                FTarget.Texture = new Texture3D((loader.content as Bitmap).bitmapData);
            }
        }
        public function set Target(target:TParticle3DAnimation):void
        {
            FTarget = target.CurrentFilter as TFilterTextureMap;
            FAlpha.value = FTarget.Alpha;
            FRepeatType.selectedIndex = FTarget.TextureRepeatType;
            FRepeatX.value = FTarget.TextureRepeatX;
            FRepeatY.value = FTarget.TextureRepeatY;
            FOffsetX.value = FTarget.TextureOffsetX;
            FOffsetY.value = FTarget.TextureOffsetY;
        }
    }
}