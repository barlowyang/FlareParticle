package
{
    import com.demonsters.debugger.MonsterDebugger;
    
    import flash.desktop.NativeApplication;
    import flash.display.DisplayObject;
    import flash.display.NativeWindow;
    import flash.display.Sprite;
    import flash.display.StageAlign;
    import flash.display.StageScaleMode;
    import flash.display3D.Context3DProfile;
    import flash.events.Event;
    import flash.filters.DropShadowFilter;
    import flash.text.TextField;
    import flash.text.TextFieldAutoSize;
    import flash.utils.getTimer;
    
    import bit101.components.Style;
    
    import flare.system.Device3D;
    
    [SWF(width="1200",height="800",frameRate="30")]
    public class Application extends Sprite
    {
        private var FPreivewArea:TPreviewArea;
        private var FPanel:TControlPanel;
        private var FMenu:TMenu;
        private var FStats:DisplayObject;
        private var FHelpArea:DisplayObject;
        
        private var FTimeStamp:Number;
        
        public function Application()
        {
            if(stage)
            {
                AddToStage();
            }
            else
            {
                addEventListener(Event.ADDED_TO_STAGE, AddToStage);
            }
        }
        
        private function AddToStage(e:Event = null):void
        {
            removeEventListener(Event.ADDED_TO_STAGE, AddToStage);
            
            MonsterDebugger.initialize(this);
            
            Style.embedFonts = false;
            Style.fontName = "simsun";
            Style.setStyle(Style.DARK);
            Style.fontSize = 12;
            
            FHelpArea = addChild(InitHelpArea());
            FStats = addChild(new TF3DStats());
            
            Device3D.profile = Context3DProfile.STANDARD;
            FPreivewArea = new TPreviewArea(this);
            FPreivewArea.antialias = 4;
            FPreivewArea.skipFrames = true;
            
            FPanel = new TControlPanel(this, FPreivewArea);
            FMenu = new TMenu(stage, FPreivewArea, FStats, FHelpArea);
            if(NativeWindow.supportsMenu)
            {
                stage.nativeWindow.menu = FMenu; 
            }
            if (NativeApplication.supportsMenu)
            { 
                NativeApplication.nativeApplication.menu = FMenu;
            }
            stage.align = StageAlign.TOP_LEFT;
            stage.scaleMode = StageScaleMode.NO_SCALE;
            stage.addEventListener(Event.RESIZE, Resize);
            
            FTimeStamp = getTimer();
            addEventListener(Event.ENTER_FRAME, OnEnterFrame);
            Resize();
        }
        
        private function OnEnterFrame(e:Event):void
        {
            var currTime:Number = getTimer();
            var delta:Number = (currTime - FTimeStamp) * 0.001;
            FTimeStamp = currTime;
            FPreivewArea.Tick(delta);
            
        }
        
        private function InitHelpArea():Sprite
        {
            var area:Sprite = new Sprite();
            var helpTxt:TextField = new TextField();
            helpTxt.textColor = 0xffffff;
            helpTxt.filters = [new DropShadowFilter(0,0,0,1,3,3,8)]
            helpTxt.text = "=====鼠标操作=====" +
                           "\n  [需同时按下Ctrl操作]" + 
                           "\n ♦ 左键控制水平旋转" + 
                           "\n ♦ 右键控制垂直旋转" +
                           "\n ♦ 左右键控制水平翻滚" +
                           "\n ♦ 中键滚控制缩放";
            helpTxt.autoSize = TextFieldAutoSize.LEFT;
            helpTxt.x = 5;
            helpTxt.y = 5;
            area.visible = false;
            area.addChild(helpTxt);
            area.graphics.beginFill(0,0.5);
            area.graphics.drawRect(0, 0, helpTxt.textWidth + 12, helpTxt.textHeight + 12);
            area.graphics.endFill();
            area.mouseChildren = false;
            area.mouseEnabled = false;
            return area;
        }
        
        private function Resize(e:Event = null):void
        {
            var sw:int = stage.stageWidth;
            var sh:int = stage.stageHeight;
            var pw:int = FPanel.width;
            var vw:int = sw - pw;
            
            FHelpArea.x = vw - FHelpArea.width;
            FPanel.setSize(FPanel.width, sh);
            FPanel.x = vw;
            FPreivewArea.setViewport(0, 0, vw, sh);
        }
        
    }
}