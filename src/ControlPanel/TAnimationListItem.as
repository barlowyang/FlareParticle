package ControlPanel
{
    import flash.display.DisplayObjectContainer;
    import flash.display.Graphics;
    import flash.display.Shape;
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.FocusEvent;
    import flash.filters.DropShadowFilter;
    import flash.text.TextField;
    import flash.text.TextFieldAutoSize;
    import flash.text.TextFieldType;
    import flash.text.TextFormat;
    import flash.text.TextFormatAlign;
    
    import Data.TParticle3DAnimation;
    
    import ascb.drawing.Pen;
    
    import bit101.components.CheckBox;
    import bit101.components.ListItem;
    import bit101.components.PushButton;
    
    public class TAnimationListItem extends ListItem
    {
        private var FEnabled:CheckBox;
        
        private var FName:TextField;
        private var FNameBack:Shape;
        
        private var FParitcles:TextField;
        private var FBehaviors:TextField;
        
        private var FMoveUp:PushButton;
        private var FMoveDown:PushButton;
        
        private var FGrid:Shape;
        
        private var FBackground:Shape;
        
        private var FAnimation:TParticle3DAnimation;
        
        public function TAnimationListItem(parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0, data:Object=null)
        {
            super(parent, xpos, ypos, data);
        }
        
        override protected function addChildren():void
        {
            super.addChildren();
            
            var outline:Array = [new DropShadowFilter(0,0,0x333333,1,3,3,8)];
            var tf:TextFormat = new TextFormat("Arial",12,0xffffff,null,null,null,null,null,TextFormatAlign.CENTER);
            
            addChild(FBackground = new Shape());
            addChild(FGrid = new Shape());
            FNameBack = new Shape();
            FNameBack.x = 30;
            FNameBack.graphics.beginFill(0x666666);
            FNameBack.graphics.drawRect(1,1,99,28);
            FNameBack.graphics.beginFill(0x0);
            FNameBack.graphics.drawRect(2,2,97,26);
            FNameBack.graphics.endFill();
            FNameBack.visible = false;
            addChild(FNameBack);
            
            FGrid.graphics.beginFill(0,1);
            addCell(FGrid.graphics, 0,0,310,30);
            addCell(FGrid.graphics, 1, 1, 29, 28);
            FEnabled = new CheckBox(this, 10, 10);
            FEnabled.addEventListener(Event.CHANGE, SwitchAnimationEnabled);
            
            FName = addCell(FGrid.graphics, 31, 1, 99, 28, this, "名称" );
            FName.addEventListener(FocusEvent.FOCUS_IN, NameFocusHandle);
            FName.addEventListener(FocusEvent.FOCUS_OUT, NameFocusHandle);
            FName.mouseEnabled = true;
            FName.type = TextFieldType.INPUT;
            
            FParitcles = addCell(FGrid.graphics, 131, 1, 59, 28, this, 0 );
            
            FBehaviors = addCell(FGrid.graphics, 191, 1, 59, 28, this, 0 );
            
            addCell(FGrid.graphics, 251, 1, 58, 28);
            
            FMoveUp = new PushButton(this,261,5,"↑");
            FMoveUp.setSize(20,20);
            
            FMoveDown = new PushButton(this,280,5,"↓");
            FMoveDown.setSize(20,20);
        }
        
        private function addCell(gridShape:Graphics, x:int, y:int, width:int, height:int, container:DisplayObjectContainer = null, value:* = null):TextField
        {
            gridShape.moveTo(x, y);
            gridShape.lineTo(x+width, y);
            gridShape.lineTo(x+width, y+height);
            gridShape.lineTo(x, y+height);
            gridShape.lineTo(x, y);
            var text:TextField;
            if(value!=null)
            {
                text = new TextField();
                text.defaultTextFormat = new TextFormat("arial",12,0xdddddd,null,null,null,null,null,TextFormatAlign.CENTER);
                text.text = value + "";
                text.autoSize = TextFieldAutoSize.CENTER;
                text.x = x + ((width - text.textWidth)>>1);
                text.y = y + ((height - text.textHeight)>>1)-2;
                text.mouseEnabled = false;
                text.filters = [new DropShadowFilter(0,0,0x333333,1,3,3,8)];
                container.addChild(text);
            }
            return text;
        }
        
        protected function NameFocusHandle(e:FocusEvent):void
        {
            switch(e.type)
            {
                case FocusEvent.FOCUS_IN:
                {
                    FNameBack.visible = true;
                    break;
                }
                case FocusEvent.FOCUS_OUT:
                {
                    FNameBack.visible = false;
                    break;
                }
            }
        }
        
        override public function draw():void
        {
            var color:uint;
            var alpha:Number = 1;
            if(_mouseOver)
            {
                color = 0xccffcc;
            }
            else
            {
                if(_selected)
                {
                    color = 0x999999;
                }
                else
                {
                    color = 0x333333;
                }
            }
            FBackground.graphics.beginFill(color);
            FBackground.graphics.drawRect(0,0,310,30);
            FBackground.graphics.endFill();
        }
        
        override public function set data(value:Object):void
        {
            super.data = value;
            
            FAnimation = value as TParticle3DAnimation;
            visible = Boolean(FAnimation);
            if(FAnimation)
            {
                FEnabled.selected = FAnimation.Enabled;
            }
        }
            
        private function SwitchAnimationEnabled(e:Event):void
        {
            FAnimation.Enabled = FEnabled.selected;
        }
        
    }
}