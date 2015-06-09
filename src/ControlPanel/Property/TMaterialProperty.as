package ControlPanel.Property
{
    import flash.display.DisplayObjectContainer;
    import flash.events.Event;
    
    import ControlPanel.Property.Material.TMaterialColorProperty;
    import ControlPanel.Property.Material.TMaterialTextureMapProperty;
    
    import Data.TParticle3DAnimation;
    
    import Geometry.TBlendMode;
    import Geometry.TMaterialType;
    
    import bit101.components.CheckBox;
    import bit101.components.ComboBox;
    import bit101.components.Label;
    import bit101.components.Panel;
    
    public class TMaterialProperty extends Panel
    {
        private static const FACTORS:Array = [
            "ZERO",
            "ONE",
            "SOURCE ALPHA",
            "SOURCE COLOR",
            "DESTINATION ALPHA",
            "DESTINATION COLOR",
            "ONE MINUS SOURCE ALPHA",
            "ONE MINUS SOURCE COLOR",
            "ONE MINUS DESTINATION ALPHA",
            "ONE MINUS DESTINATION COLOR"
        ]
            
        private static const BLEND_MODE_LIST:Array = [ 
            "NONE", 
            "ADDITIVE", 
            "TRANSPARENT", 
            "MULTIPLY",
            "REPRODUCTION", 
            "SCREEN",
            "CUSTOM" 
        ]
        private static const BLEND_MODE_INDEX:Array = [ 
            TBlendMode.NONE, 
            TBlendMode.ADDITIVE, 
            TBlendMode.TRANSPARENT, 
            TBlendMode.MULTIPLY, 
            TBlendMode.REPRODUCTION, 
            TBlendMode.SCREEN, 
            TBlendMode.CUSTOM 
        ]
            
        private var FTarget:TParticle3DAnimation;
        private var FMaterialType:ComboBox;
        
        private var FBlendMode:ComboBox;
        private var FSourceFactor:ComboBox;
        private var FDestFactor:ComboBox;
        private var FCullFace:ComboBox;
        private var FEnabledLight:CheckBox;
        private var FEnabledTwoSideMaterial:CheckBox;
        private var FTexturePanel:TMaterialTextureMapProperty;
        private var FColorPanel:TMaterialColorProperty;
        
        private var FOnUpdateIndicate:Boolean;
        private var FDepthCompare:ComboBox;
        
        public function TMaterialProperty(parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0)
        {
            super(parent, xpos, ypos);
        }
        
        override public function draw():void
        {
            super.draw();
            height = content.height + 10;
            FColorPanel.width = FTexturePanel.width = width - 10;
        }
        
        override protected function addChildren():void
        {
            super.addChildren();
            var xPos:int = 0;
            var yPos:int = 0;
            new Label(this, xPos=5, yPos=5,   "混合模式:");
            FBlendMode = new ComboBox(this, xPos += 58, yPos-2);
            FBlendMode.items = BLEND_MODE_LIST;
            FBlendMode.numVisibleItems = 7;
            FBlendMode.width = 220;
            FBlendMode.selectedIndex = 0;
            FBlendMode.addEventListener(Event.SELECT, UpdateMaterialType);
            
            new Label(this, xPos=5, yPos+=25, "来源因素:");
            FSourceFactor = new ComboBox(this, xPos += 58, yPos-2);
            FSourceFactor.items = FACTORS;
            FSourceFactor.numVisibleItems = 10;
            FSourceFactor.selectedIndex = 2;
            FSourceFactor.width = 220;
            FSourceFactor.addEventListener(Event.SELECT, UpdateMaterialType);
            
            new Label(this, xPos=5, yPos+=25, "目标因素:");
            FDestFactor = new ComboBox(this, xPos += 58, yPos-2);
            FDestFactor.items = FACTORS;
            FDestFactor.numVisibleItems = 10;
            FDestFactor.selectedIndex = 2;
            FDestFactor.width = 220;
            FDestFactor.addEventListener(Event.SELECT, UpdateMaterialType);
            
            new Label(this, xPos=5, yPos+=25, "材质类型:"); 
            FMaterialType = new ComboBox(this, xPos += 58, yPos-2, "", ["实色", "贴图" ]);
            FMaterialType.numVisibleItems = 2;
            FMaterialType.selectedIndex = 0;
            FMaterialType.width = 220;
            FMaterialType.addEventListener(Event.SELECT, UpdateMaterialType);
            
            FEnabledLight = new CheckBox(this, xPos=5, yPos+=30, "启用灯光");
            FEnabledLight.addEventListener(Event.CHANGE, UpdateMaterialType);
            
            FEnabledTwoSideMaterial = new CheckBox(this, xPos+=76, yPos, "双面材质");
            FEnabledTwoSideMaterial.addEventListener(Event.CHANGE, UpdateMaterialType);
            
            new Label(this, xPos+=76, yPos-4, "不可见面:");
            FCullFace = new ComboBox(this, xPos+=58, yPos-5);
            FCullFace.items = [
                "BACK",
                "FRONT",
                "FRONT AND BACK",
                "NONE"
            ]
            FCullFace.numVisibleItems = 4
            FCullFace.addEventListener(Event.SELECT, UpdateMaterialType);
            
            new Label(this, xPos=5, yPos+=22, "深度比较:");
            FDepthCompare = new ComboBox(this, xPos+=58, yPos-1);
            FDepthCompare.items = [
                "LESS_EQUAL",
                "LESS",
                "GREATER_EQUAL",
                "GREATER",
                "ALWAYS",
                "NEVER",
                "EQUAL",
                "NOT_EQUAL"
            ];
            FDepthCompare.width = 252;
            FDepthCompare.numVisibleItems = 8;
            FDepthCompare.addEventListener(Event.SELECT, UpdateMaterialType);
            
            FTexturePanel = new TMaterialTextureMapProperty(this, xPos=5, yPos+=22);
            FTexturePanel.shadow = false;
            
            FColorPanel = new TMaterialColorProperty(this, xPos=5, yPos);
            FColorPanel.shadow = false;
        }
        
        private function UpdateMaterialType(e:Event):void
        {
            if(FOnUpdateIndicate)
            {
                return;
            }
            
            FOnUpdateIndicate = true;
            
            switch(e.currentTarget)
            {
                case FDepthCompare:
                {
                    FTarget.DepthCompare = FDepthCompare.selectedIndex;
                    break;
                }
                case FCullFace:
                {
                    FTarget.CullFace = FCullFace.selectedIndex
                    break;
                }
                case FMaterialType:
                {
                    FTarget.MaterialType = FMaterialType.selectedIndex;
                    switch(FMaterialType.selectedIndex)
                    {
                        case TMaterialType.SOLID_COLOR:
                        {
                            addChild(FColorPanel);
                            FTexturePanel.RemoveFromParent();
                            FColorPanel.Target = FTarget;
                            break;
                        }
                        case TMaterialType.TEXTURE:
                        {
                            FColorPanel.RemoveFromParent();
                            addChild(FTexturePanel);
                            FTexturePanel.Target = FTarget;
                            break;
                        }
                    }
                    break
                }
                case FBlendMode:
                {
                    var mode:int = BLEND_MODE_INDEX[FBlendMode.selectedIndex];
                    FTarget.BlendMode = mode;
                    FColorPanel.BlendMode = mode;
                    FSourceFactor.selectedIndex = FTarget.SourceFactor;
                    FDestFactor.selectedIndex = FTarget.DestFactor;
                    break;
                }
                case FSourceFactor:
                {
                    FTarget.SourceFactor = FSourceFactor.selectedIndex;
                    FBlendMode.selectedIndex = BLEND_MODE_INDEX.indexOf(FTarget.BlendMode);
                    break;
                }
                case FDestFactor:
                {
                    FTarget.DestFactor = FDestFactor.selectedIndex;
                    FBlendMode.selectedIndex = BLEND_MODE_INDEX.indexOf(FTarget.BlendMode);
                    break;
                }
                case FEnabledLight:
                {
                    FTarget.EnabledLight = FEnabledLight.selected;
                    break;
                }
                case FEnabledTwoSideMaterial:
                {
                    FTarget.EnabledTwoSideMaterial = FEnabledTwoSideMaterial.selected;
                    break;
                }
            }
            
            FOnUpdateIndicate = false;
        }
        
        public function set Target(target:TParticle3DAnimation):void
        {
            FTarget = target;
            if(target.BlendMode == TBlendMode.CUSTOM)
            {
                FSourceFactor.selectedIndex = target.SourceFactor;
                FDestFactor.selectedIndex = target.DestFactor;
            }
            else
            {
                FBlendMode.selectedIndex = BLEND_MODE_INDEX.indexOf(target.BlendMode);
            }
            
            FMaterialType.selectedIndex = target.MaterialType;
            FEnabledLight.selected = target.EnabledLight;
            FEnabledTwoSideMaterial.selected = target.EnabledTwoSideMaterial;
            FCullFace.selectedIndex = target.CullFace;
            FDepthCompare.selectedIndex = target.DepthCompare;
        }
    }
}
