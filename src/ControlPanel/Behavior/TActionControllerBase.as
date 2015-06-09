package ControlPanel.Behavior
{
    import flash.display.CapsStyle;
    import flash.display.JointStyle;
    import flash.display.LineScaleMode;
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.text.TextFormat;
    
    import Data.Actions.IAction;
    
    import GT.Errors.AbstractMethodError;
    
    import UI.TFoldPanelBase;
    
    import bit101.components.VBox;
    
    public class TActionControllerBase extends TFoldPanelBase
    {
        private var FClose:Sprite;
        
        private var FTarget:IAction;
        
        public function TActionControllerBase(title:String="Window", couldRemove:Boolean = true)
        {
            if(couldRemove)
            {
                FClose = new Sprite();
            }
            super(null, 0, 0, title, 25, new VBox());
            SwitchFoldState();
        }
        
        protected function InitTarget():void
        {
            throw new AbstractMethodError();
        }
        
        public final function get Target():IAction
        {
            return FTarget;
        }
        public final function set Target(value:IAction):void
        {
            FTarget = value;
            InitTarget();
        }

        protected function CorrectControllerSize(e:Event = null):void
        {
            Content.draw();
            height = Content.height + 35;
        }
        
        override protected function addChildren():void
        {
            super.addChildren();
            
            TitleBar.DefaultTextFormat = new TextFormat("simsun", "12", 0xffffff, false);
            
            if(FClose)
            {
                FClose.graphics.beginFill(0,0.5);
                FClose.graphics.drawRect(-5, -5, 10, 10);
                FClose.graphics.endFill();
                FClose.graphics.lineStyle(2,0xffffff,1,true,LineScaleMode.NONE, CapsStyle.SQUARE, JointStyle.BEVEL);
                FClose.graphics.moveTo(-3,-3);
                FClose.graphics.lineTo(3,3);
                FClose.graphics.moveTo(3,-3);
                FClose.graphics.lineTo(-3,3);
                FClose.useHandCursor = true;
                FClose.buttonMode = true;
                FClose.alpha = 0.5;
                FClose.addEventListener(MouseEvent.CLICK, CloseHandle);
                FClose.addEventListener(MouseEvent.ROLL_OUT, CloseHandle);
                FClose.addEventListener(MouseEvent.ROLL_OVER, CloseHandle);
                TitleBar.addChild(FClose);
            }
        }
        
        protected function CloseHandle(e:MouseEvent):void
        {
            e.stopImmediatePropagation();
            e.stopPropagation();
            switch(e.type)
            {
                case MouseEvent.CLICK:
                {
                    dispatchEvent(new Event(Event.CLOSE));
                    break;
                }
                case MouseEvent.ROLL_OUT:
                {
                    FClose.alpha = 0.5;
                    break;
                }
                case MouseEvent.ROLL_OVER:
                {
                    FClose.alpha = 1;
                    break;
                }
            }
        }
        override public function draw():void
        {
            super.draw();
            if(FClose)
            {
                FClose.x = TitleBar.width - 12;
                FClose.y = TitleBar.height>>1
            }
        }
    }
}