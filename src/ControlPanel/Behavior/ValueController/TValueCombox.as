package ControlPanel.Behavior.ValueController
{
    import flash.display.DisplayObjectContainer;
    import flash.events.Event;
    
    import Data.Values.TValueBase;
    import Data.Values.OneD.TOneDConst;
    import Data.Values.OneD.TOneDRandom;
    import Data.Values.ThreeD.TThreeDComposite;
    import Data.Values.ThreeD.TThreeDConst;
    import Data.Values.ThreeD.TThreeDCylinder;
    import Data.Values.ThreeD.TThreeDSphere;
    
    import bit101.components.CheckBox;
    import bit101.components.ComboBox;
    import bit101.components.Component;
    import bit101.components.Label;
    
    public class TValueCombox extends Component
    {
        private static const SUPPORT_TYPE_NAMES:Array = [
            "一维固定",
            "一维随机",
            "三维固定",
            "三维复合",
            "三维柱体",
            "三维球体"
        ]
            
        private static const SUPPORT_TYPE_LIST:Array = [
            TOneDConst,
            TOneDRandom,
            TThreeDConst,
            TThreeDComposite,
            TThreeDCylinder,
            TThreeDSphere
        ];
        
        private static const SUPPORT_TYPE_CONTROLLER:Array = [
            TOneDConstController,
            TOneDRandomController,
            TThreeDConstController,
            TThreeDCompositeController,
            TThreeDCylinderController,
            TThreeDSphereController
        ];
        
        private var FSupportClasses:Array;
        
        private var FTypeList:ComboBox;
        
        private var FValueController:TValueControllerBase
        
        private var FSupportMinus:Boolean;
        
        private var FLabelStr:String;
        
        private var FLabel:Label;
        
        private var FSwitch:CheckBox;
        
        private var FCouldDisable:Boolean;
        
        private var FOffset:int;
        
        private var FTarget:Object;
        
        private var FPropName:String;
        
        public function TValueCombox(parent:DisplayObjectContainer=null, ClassList:Array = null, label:String = "", couldDisable:Boolean = false, supportMinus:Boolean = true, offset:int = 0)
        {
            FSupportClasses = FilterSupportClass(ClassList);
            FSupportMinus = supportMinus;
            FLabelStr = label;
            FCouldDisable = couldDisable;
            FOffset = offset;
            super(parent);
        }
        
        public function SetTarget(target:Object, propName:String = ""):void
        {
            FValueController.Target = null;
            FTarget = target;
            FPropName = propName;
            
            if(!target) return;
            
            for(var i:int = SUPPORT_TYPE_LIST.length - 1; i>=0; i--)
            {
                if(target[propName] is SUPPORT_TYPE_LIST[i])
                {
                    FTypeList.selectedItem = SUPPORT_TYPE_NAMES[i];
                    return;
                }
            }
            
            FTypeList.selectedIndex = 0;
        }
        
        private function FilterSupportClass(list:Array):Array
        {
            var filters:Array = [];
            for(var i:int = 0; i<list.length; i++)
            {
                if(SUPPORT_TYPE_LIST.indexOf(list[i])<0)
                {
                    continue;
                }
                filters.push(list[i]);
            }
            return filters;
        }
        
        override protected function addChildren():void
        {
            super.addChildren();
            
            FTypeList = new ComboBox(this, 0, 5);
            if(FCouldDisable)
            {
                FSwitch = new CheckBox(this, 5, 10, FLabelStr);
                FSwitch.addEventListener(Event.CHANGE, SwitchState);
                FTypeList.x = FSwitch.x + FSwitch.width;
            }
            else
            {
                FLabel = new Label(this, 17, 7, FLabelStr);
                FTypeList.x = FLabel.x + FLabel.width;
            }
            
            FTypeList.items = GetSupportTypes();
            FTypeList.numVisibleItems = FTypeList.items.length;
            FTypeList.width = 315 - FTypeList.x - FOffset;
            FTypeList.addEventListener(Event.SELECT, ChangeType);
            FTypeList.selectedIndex = 0;
        }
        
        protected function SwitchState(e:Event):void
        {
            FTypeList.enabled = FSwitch.selected;
            dispatchEvent(new Event(Event.CHANGE)); 
        }
        
        public function get ValueEnabled():Boolean { return FSwitch.selected;}
        public function set ValueEnabled(value:Boolean):void
        {
            FSwitch.selected = value
            FTypeList.enabled = value;
            dispatchEvent(new Event(Event.CHANGE)); 
        }
        
        public function get SupportMinus():Boolean
        {
            return FSupportMinus;
        }
        public function set SupportMinus(v:Boolean):void
        {
            FSupportMinus = v;
            if(FValueController)
            {
                FValueController.SupportMinus = v;
            }
        }
        
        public function get MethodEnabled():Boolean
        {
            return FSwitch.selected;
        }
        
        private function ChangeType(e:Event):void
        {
            var cls:Class = FSupportClasses[FTypeList.selectedIndex];
            
            if(FTarget)
            {
                var value:TValueBase;
                if(FTarget[FPropName] is cls)
                {
                    value = FTarget[FPropName];
                }
                else
                {
                    value = FTarget[FPropName] = new cls();
                }
            }
            
            var index:int = SUPPORT_TYPE_LIST.indexOf(cls);
            var valueCls:Class = SUPPORT_TYPE_CONTROLLER[index];
            if(FValueController)
            {
                FValueController.removeEventListener(Event.RESIZE, OnResize);
                removeChild(FValueController);
                FValueController.Target = null;
                FValueController = null;
            }
            
            if(valueCls)
            {
                FValueController = new valueCls(this,FTypeList.x,FTypeList.y + FTypeList.height + 3);
                FValueController.SupportMinus = FSupportMinus;
                FValueController.addEventListener(Event.RESIZE, OnResize);
                
                FValueController.Target = value;
            }
            OnResize();
        }
        
        private function OnResize(event:Event = null):void
        {
            if(FValueController)
            {
                height = FValueController.height + 20;
            }
            else
            {
                height = 20;
            }
        }
        
        private function GetSupportTypes():Array
        {
            var list:Array = [];
            var len:int = FSupportClasses.length;
            for(var i:int = 0; i<len; i++)
            {
                list[i] = SUPPORT_TYPE_NAMES[SUPPORT_TYPE_LIST.indexOf(FSupportClasses[i])];
            }
            return list;
        }
    }
}