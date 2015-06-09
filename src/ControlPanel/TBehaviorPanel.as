package ControlPanel
{
    import flash.display.DisplayObject;
    import flash.display.DisplayObjectContainer;
    import flash.events.Event;
    
    import ControlPanel.Behavior.TActionControllerBase;
    import ControlPanel.Behavior.TPositionController;
    import ControlPanel.Behavior.TTimeController;
    import ControlPanel.Behavior.TVelocityController;
    
    import Data.TParticle3DAnimation;
    import Data.Actions.IAction;
    import Data.Spaces.Particle3DSpace;
    
    import UI.TFoldPanelBase;
    
    import bit101.components.ComboBox;
    import bit101.components.VBox;
    
    use namespace Particle3DSpace;
    
    public class TBehaviorPanel extends TFoldPanelBase
    {
        private static const BEHAVIOR_LIST:Array = [
            TTimeController,
            TVelocityController,
            TPositionController
        ]
        
        private var FBehaviorDict:Object;
            
        private var FTarget:TParticle3DAnimation;
        
        private var FAppendBehavior:ComboBox;
        
        private var FBehaviorList:VBox;
        
        private var FNoticeLabelStr:String;
        
        public function TBehaviorPanel(parent:DisplayObjectContainer, previewArea:TPreviewArea)
        {
            super(parent, 0, 0, "表现");
        }
        
        override public function set width(w:Number):void
        {
            super.width = w;
            updateListItemWidth();
        }
        
        private function updateListItemWidth():void
        {
            var pw:int = width - 10;
            var len:int = FBehaviorList.numChildren;
            for(var i:int = 0; i<len; i++)
            {
                FBehaviorList.getChildAt(i).width = pw;
            }
        }
        
        override protected function addChildren():void
        {
            super.addChildren();
            
            FBehaviorDict = {};
            
            FNoticeLabelStr = "添加一种新的表现方式"
            FAppendBehavior = new ComboBox(this, 5, 5, FNoticeLabelStr);
            FAppendBehavior.width = 320;
            FAppendBehavior.addEventListener("dropDown", RefreshBehaviorAvailable);
            FAppendBehavior.addEventListener(Event.SELECT, AddBehaviorHandle);
            FBehaviorList = new VBox(this, 5, 30);
            FBehaviorList.spacing = 2;
            FBehaviorList.addEventListener("Update", RefreshInstance)
        }
        
        protected function RefreshInstance(e:Event):void
        {
            if(FTarget)
            {
                FTarget.ClearBatch();
            }
        }
        
        protected function AddBehaviorHandle(e:Event):void
        {
            if(FAppendBehavior.selectedItem)
            {
                var behaviorName:String = String(FAppendBehavior.selectedItem);
                for(var i:int = BEHAVIOR_LIST.length-1; i>=0; i--)
                {
                    if(BEHAVIOR_LIST[i].NAME == behaviorName)
                    {
                        AppendBehavior(BEHAVIOR_LIST[i]);
                        break;
                    }
                }
                FAppendBehavior.selectedItem = null;
            }
        }
        
        private function ClearBehaviorList():void
        {
            while(FBehaviorList.numChildren)
            {
                (FBehaviorList.removeChildAt(0) as TActionControllerBase).Target = null;
            }
        }
        
        private function AppendBehavior(cls:Class, action:IAction = null):void
        {
            var controller:TActionControllerBase;
            if(FBehaviorDict[cls])
            {
                controller = FBehaviorDict[cls];
            }
            else
            {
                controller = new cls();
                FBehaviorDict[cls] = controller;
            }
            controller.addEventListener(Event.CLOSE, PanelEventHandle);
            controller.addEventListener(Event.RESIZE, PanelEventHandle);
            FBehaviorList.addChild(controller);
            FBehaviorList.draw();
            
            updateListItemWidth();
            if(action)
            {
                controller.Target = action;
            }
            else
            {
                action = new cls.VALUE_DEF();
                FTarget.AppendAction(action);
                FTarget.ClearBatch();
                controller.Target = action;
            }
        }
        
        private function PanelEventHandle(e:Event):void
        {
            switch(e.type)
            {
                case Event.CLOSE:
                {
                    var controller:TActionControllerBase = e.currentTarget as TActionControllerBase;
                    controller.removeEventListener(Event.CLOSE, PanelEventHandle);
                    controller.removeEventListener(Event.RESIZE, PanelEventHandle);
                    FBehaviorList.removeChild(controller);
                    var action:IAction = controller.Target;
                    FTarget.RemoveAction(action);
                }
                case Event.RESIZE:
                {
                    FBehaviorList.draw();
                    break;
                }
            }
            height = FBehaviorList.y + FBehaviorList.height + 35
        }
        
        private function RefreshBehaviorAvailable(e:Event):void
        {
            var availableBehaviorList:Array = BEHAVIOR_LIST.concat();
            
            var list:Vector.<IAction> = FTarget.GetActionList();
            var len:int = list.length;
            var action:IAction;
            var controllerClass:Class;
            var j:int;
            var k:int;
            for(var i:int = 0; i<len; i++)
            {
                action = list[i];
                for (j = availableBehaviorList.length-1; j>=0; j--)
                {
                    if(action is availableBehaviorList[j].VALUE_DEF)
                    {
                        availableBehaviorList.splice(j, 1);
                        break;
                    }
                }
            }
            
            var items:Array = [];
            len = availableBehaviorList.length
            for(i = 0; i<len; i++)
            {
                items.push(availableBehaviorList[i].NAME);
            }
            FAppendBehavior.items = items;
            FAppendBehavior.numVisibleItems = Math.min(items.length, 8);
            FAppendBehavior.invalidate();
        }
        
        public function set Target(target:TParticle3DAnimation):void
        {
            FTarget = target;
            
            ClearBehaviorList();
            
            var list:Vector.<IAction> = target.GetActionList();
            var len:int = list.length;
            var action:IAction;
            var controllerClass:Class;
            
            for(var i:int = 0; i<len; i++)
            {
                action = list[i];
                for each(controllerClass in BEHAVIOR_LIST)
                {
                    if(action is controllerClass.VALUE_DEF)
                    {
                        AppendBehavior(controllerClass, action);
                        break;
                    }
                }
            }
        }
    }
}