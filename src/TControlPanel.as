package
{
    import flash.display.DisplayObjectContainer;
    import flash.display.Shape;
    import flash.events.Event;
    import flash.events.MouseEvent;
    
    import ControlPanel.TAnimationPanel;
    import ControlPanel.TPropertyPanel;
    
    import Data.TParticle3DAnimation;
    
    import bit101.components.Component;
    import bit101.components.Panel;
    import bit101.components.VBox;
    import bit101.components.VScrollBar;
    
    public class TControlPanel extends Panel
    {
        private var FScrollbar:VScrollBar;
        private var FContainer:Panel;
        private var FContent:VBox;
        private var FMask:Shape;
        private var FPanelList:Vector.<Component>;
     //   private var FCustomPanel:TCustomPanel;
        private var FAnimationPanel:TAnimationPanel;
        private var FPropertyPanel:TPropertyPanel;
       // private var FBehaviorPanel:TBehaviorPanel;
        
        private var FPreviewArea:TPreviewArea;
        
        public function TControlPanel(parent:DisplayObjectContainer, previewArea:TPreviewArea)
        {
            FPreviewArea = previewArea;
            super(parent);
            width = 350;
        }
        
        override protected function addChildren():void
        {
            super.addChildren();
            
            FScrollbar = new VScrollBar(this);
            FScrollbar.addEventListener(Event.CHANGE, DragScroll);
            FScrollbar.lineSize = 50;
            FContainer = new Panel(this);
            
            FContent = new VBox(FContainer.content);
            FContent.spacing = 3;
            FContent.addEventListener(MouseEvent.MOUSE_WHEEL, MouseWheelHandle);
            FMask = new Shape();
            FContainer.y = 5;
            FScrollbar.y = 5;
            
            FPanelList = new Vector.<Component>();
           // FCustomPanel = InitPanel(TCustomPanel, true);
            FAnimationPanel = InitPanel(TAnimationPanel);
            FAnimationPanel.addEventListener(Event.SELECT, SelectedAnimation);
            FPropertyPanel = InitPanel(TPropertyPanel);
         //   FBehaviorPanel = InitPanel(TBehaviorPanel);
            FAnimationPanel.AppendAnimation();
        }
        
        private function SelectedAnimation(e:Event):void
        {
            var selectedItem:TParticle3DAnimation = FAnimationPanel.CurrentSelectAnimation;
            FPropertyPanel.Target = selectedItem.Particle;
          //  FBehaviorPanel.Target = selectedItem;
//			FAnimationPanel.visible = false;
        }
        
        private function InitPanel(panelClass:Class, fold:Boolean = false):*
        {
            var panel:Component = new panelClass(FContent, FPreviewArea);
            if(fold)
            {
                panel["SwitchFoldState"].apply();
            }
            panel.addEventListener(Event.RESIZE, UpdatePos);
            FPanelList.push(panel);
            return panel;
        }
        
        private function MouseWheelHandle(e:MouseEvent):void
        {
            FContent.y += e.delta * 10;
            UpdateScroll();
        }
        
        private function UpdateScroll():void
        {
            var maxValue:int = Math.max(FContent.height - FContainer.height, 0)
            var percent:Number =  Math.min(1, FContainer.height/FContent.height);
                
            if(FContent.y>0)
            {
                FContent.y = 0;
            }
            if(FContent.y<-maxValue)
            {
                FContent.y = -maxValue;
            }
            
            var currValue:int = -FContent.y;
            if(isNaN(percent))
            {
                percent = 0;
            }
            
            FScrollbar.setSliderParams(0, maxValue, currValue);
            FScrollbar.setThumbPercent(percent);
            FScrollbar.pageSize = 225;
            FScrollbar.draw();
        }
        
        private function DragScroll(e:Event):void
        {
            FContent.y = -FScrollbar.value;
        }
        
        private function UpdatePos(e:Event = null):void
        {
            FContent.draw();
            UpdateScroll();
        }   
        
        override public function draw():void
        {
            super.draw();
            
            FContainer.height = FScrollbar.height = _height - 10;
            FContainer.width = _width - 10 - FScrollbar.width;
            
            FContainer.x = 5;
            FScrollbar.x = FContainer.width + 5;
            
            var pw:int = FContainer.width;
            var len:int = FPanelList.length;
            for(var i:int = 0; i<len; i++)
            {
                FPanelList[i].width = pw;
            }
            
            UpdatePos();
        }
        
    }
}