package ControlPanel
{
    import flash.display.DisplayObjectContainer;
    import flash.display.GradientType;
    import flash.display.Shape;
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.filters.DropShadowFilter;
    import flash.geom.Matrix;
    import flash.text.TextField;
    import flash.text.TextFieldAutoSize;
    import flash.text.TextFormat;
    import flash.text.TextFormatAlign;
    
    import Data.TParticle3DAnimation;
    
    import UI.TFoldPanelBase;
    
    import bit101.components.List;
    import bit101.components.PushButton;
    
    public class TAnimationPanel extends TFoldPanelBase
    {
        private var FList:List;
        private var FAppend:PushButton
        private var FRemove:PushButton;
        private var FPreviewArea:TPreviewArea;
        
        public function TAnimationPanel(parent:DisplayObjectContainer, container:TPreviewArea)
        {
            super(parent, 0, 0, "动画");
            FPreviewArea = container;
        }
        
        override protected function addChildren():void
        {
            super.addChildren();
            
            FAppend = new PushButton(this, 5, 5,"增加动画");
            FAppend.addEventListener(MouseEvent.CLICK, AppendAnimation);
            FRemove = new PushButton(this, 5, 5, "移除动画");
            FRemove.addEventListener(MouseEvent.CLICK, RemoveAnimation);
            
            var title:Sprite = new Sprite();
            title.graphics.beginFill(0);
            addTitleCell(title, 0, 0, 310, 26, null);
            addTitleCell(title, 1, 1, 29, 24, "可见");
            addTitleCell(title, 31, 1, 99, 24, "名称");
            addTitleCell(title, 131, 1, 59, 24, "粒子数");
            addTitleCell(title, 191, 1, 59, 24, "表现数");
            addTitleCell(title, 251, 1, 58, 24, "层次");
            title.graphics.endFill();
            
            var titleBack:Shape = new Shape();
            var mat:Matrix = new Matrix();
            mat.createGradientBox(310,30,90);
            titleBack.graphics.beginGradientFill(GradientType.LINEAR,[ 0x666666,0x333333],[1,1], [0,255], mat);
            titleBack.graphics.drawRect(0,0,310,26);
            titleBack.graphics.endFill();
            
            titleBack.x = title.x = 5;
            titleBack.y = title.y = 30;
            
            addChild(titleBack);
            addChild(title);
            
            FList = new List(this, 5, 55);
            FList.listItemClass = TAnimationListItem;
            FList.listItemHeight = 29;
            FList.addEventListener(Event.SELECT, dispatchEvent);
            CorrectSize();
        }
        
        private function addTitleCell(title:Sprite, x:int, y:int, width:int, height:int, cellName:String):void
        {
            title.graphics.moveTo(x, y);
            title.graphics.lineTo(x+width, y);
            title.graphics.lineTo(x+width, y+height);
            title.graphics.lineTo(x, y+height);
            title.graphics.lineTo(x, y);
            
            if(cellName)
            {
                var text:TextField = new TextField();
                text.defaultTextFormat = new TextFormat("arial",12,0xdddddd,null,null,null,null,null,TextFormatAlign.CENTER);
                text.text = cellName;
                text.autoSize = TextFieldAutoSize.LEFT;
                text.x = x + ((width - text.textWidth)>>1)-2;
                text.y = y + ((height - text.textHeight)>>1)-2;
                text.mouseEnabled = false;
                text.filters = [new DropShadowFilter(0,0,0x333333,1,3,3,8)]
                title.addChild(text);
            }
        }
        
        public function AppendAnimation(e:MouseEvent = null):void
        {
            var animation:TParticle3DAnimation = new TParticle3DAnimation(FPreviewArea);
            FPreviewArea.AppendEffectAnimation(animation);
            FList.addItem(animation);
            CorrectSize();
            FList.selectedItem = animation;
        }
        
        private function RemoveAnimation(event:MouseEvent):void
        {
            if(FList.selectedItem)
            {
                var animation:TParticle3DAnimation = FList.selectedItem as TParticle3DAnimation;
                FPreviewArea.RemoveEffectAnimation(animation);
                animation.Dispose();
                FList.removeItem(animation);
            }
            CorrectSize();
        }
        
        private function CorrectSize():void
        {
            FList.height = Math.min(291,Math.max(88,1+FList.items.length*29));
            height = 0;
        }
        
        override public function draw():void
        {
            super.draw();
			
            FRemove.x = width-FRemove.width-5;
            FList.width = width-10;
        }
        
        public function get CurrentSelectAnimation():TParticle3DAnimation
        {
            return FList.selectedItem as TParticle3DAnimation;
        }
        
    }
}