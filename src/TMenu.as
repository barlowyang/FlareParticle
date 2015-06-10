package
{
    import flash.display.DisplayObject;
    import flash.display.NativeMenu;
    import flash.display.NativeMenuItem;
    import flash.display.Stage;
    import flash.events.Event;
    import flash.events.KeyboardEvent;
    import flash.filesystem.File;
    import flash.ui.Keyboard;

    public class TMenu extends NativeMenu
    {
        private var FPreviewArea:TPreviewArea;
        
        private var recentDocuments:Array;
        private var FFileMenu:NativeMenuItem; 
        private var FViewMenu:NativeMenuItem;

        private var FNewCommand:NativeMenuItem;
        private var FOpenCommand:NativeMenuItem;
        private var FSaveCommand:NativeMenuItem;
        private var FOpenRecentMenu:NativeMenuItem;

        private var FGridVisibleCommand:NativeMenuItem;
        private var FAxisVisibleCommand:NativeMenuItem;
        private var FResetCamCommand:NativeMenuItem;
        
        private var FQuickHelpCommnad:NativeMenuItem;
        
        private var FQuickHelp:DisplayObject;
        private var FRenderStats:DisplayObject;
        private var FRenderStatsCommand:NativeMenuItem;
        
        public function TMenu(stage:Stage, previewArea:TPreviewArea, stats:DisplayObject, help:DisplayObject)
        {
            InitMenu(stage, previewArea, stats, help);
        }
        
        private function InitMenu(stage:Stage, previewArea:TPreviewArea, stats:DisplayObject, help:DisplayObject):void
        {
            FPreviewArea = previewArea;
            FRenderStats = stats;
            FQuickHelp = help;
            
            recentDocuments = [];
            if(stage)
            {
                stage.addEventListener(KeyboardEvent.KEY_UP, ProcessKeyUp);
                addItem(new NativeMenuItem("文件")).submenu = CreateFileMenu(); 
                addItem(new NativeMenuItem("视图")).submenu = CreateViewMenu(); 
                addItem(new NativeMenuItem("帮助")).submenu = CreateHelpMenu(); 
                CheckHasRecentFile();
            }
        }
        
        private function ProcessKeyUp(e:KeyboardEvent):void
        {
            switch(e.keyCode)
            {
                case Keyboard.F1:
                {
                    SwitchQuickHelpVisible();
                    break;
                }
                case Keyboard.F2:
                {
                    SwitcRenderStatsVisible();
                    break;
                }
            }
        }
        
        private function SwitchQuickHelpVisible(e:Event = null):void
        {
            FQuickHelp.visible = FQuickHelpCommnad.checked = !FQuickHelpCommnad.checked;
        }
        
        private function SwitcRenderStatsVisible(e:Event = null):void
        {
            FRenderStats.visible = FRenderStatsCommand.checked = !FRenderStatsCommand.checked;
        }
        
        private function CheckHasRecentFile():void
        {
            FOpenRecentMenu.enabled = Boolean(recentDocuments.length)
        }
        
        private function CreateFileMenu():NativeMenu
        { 
            var subMenu:NativeMenu = new NativeMenu(); 
            
            FNewCommand = subMenu.addItem(new NativeMenuItem("新建特效")); 
            FNewCommand.addEventListener(Event.SELECT, SelectCommand); 
            
            FOpenCommand = subMenu.addItem(new NativeMenuItem("打开特效"));
            FOpenCommand.addEventListener(Event.SELECT, SelectCommand);
            
            FSaveCommand = subMenu.addItem(new NativeMenuItem("保存特效")); 
            FSaveCommand.addEventListener(Event.SELECT, SelectCommand);
            
            FOpenRecentMenu = subMenu.addItem(new NativeMenuItem("最近打开的特效"));  
            FOpenRecentMenu.submenu = new NativeMenu(); 
            FOpenRecentMenu.submenu.addEventListener(Event.DISPLAYING, UpdateRecentDocumentMenu); 
            
            return subMenu; 
        } 
        
        private function CreateViewMenu():NativeMenu 
        { 
            var subMenu:NativeMenu = new NativeMenu(); 
            
            FGridVisibleCommand = subMenu.addItem(new NativeMenuItem("显示网格")); 
            FGridVisibleCommand.addEventListener(Event.SELECT, SelectCommand); 
            FGridVisibleCommand.checked = true;
            
            FAxisVisibleCommand = subMenu.addItem(new NativeMenuItem("显示轴心")); 
            FAxisVisibleCommand.addEventListener(Event.SELECT, SelectCommand); 
            FAxisVisibleCommand.checked = true;
            
            FResetCamCommand = subMenu.addItem(new NativeMenuItem("重置摄像机")); 
            FResetCamCommand.addEventListener(Event.SELECT, SelectCommand); 
            
            return subMenu; 
        } 
        
        private function CreateHelpMenu():NativeMenu
        {
            var subMenu:NativeMenu = new NativeMenu();
            
            FQuickHelpCommnad = subMenu.addItem(new NativeMenuItem("快速帮助"));
            FQuickHelpCommnad.keyEquivalent = "|f1|";
            FQuickHelpCommnad.keyEquivalentModifiers = [];
            FQuickHelpCommnad.addEventListener(Event.SELECT, SwitchQuickHelpVisible);
            
            FRenderStatsCommand = subMenu.addItem(new NativeMenuItem("渲染统计"));
            FRenderStatsCommand.keyEquivalent = "|f2|";
            FRenderStatsCommand.keyEquivalentModifiers = [];
            FRenderStatsCommand.addEventListener(Event.SELECT, SwitcRenderStatsVisible);
            FRenderStatsCommand.checked = true;
            return subMenu;
        }
        
        private function UpdateRecentDocumentMenu(event:Event):void
        { 
            trace("Updating recent document menu."); 
            var docMenu:NativeMenu = NativeMenu(event.target); 
            
            for each (var item:NativeMenuItem in docMenu.items) 
            { 
                docMenu.removeItem(item); 
            } 
            
            for each (var file:File in recentDocuments) 
            { 
                var menuItem:NativeMenuItem = docMenu.addItem(new NativeMenuItem(file.name)); 
                menuItem.data = file; 
                menuItem.addEventListener(Event.SELECT, SelectRecentDocument); 
            } 
        } 
        
        private function SelectRecentDocument(event:Event):void
        { 
            trace("Selected recent document: " + event.target.data.name); 
        } 
        
        private function SelectCommand(e:Event):void 
        { 
            switch(e.currentTarget)
            {
                case FQuickHelpCommnad:
                {
                    SwitchQuickHelpVisible();
                    break;
                }
                    
                default:
                {
                    return;
                }
            }
            trace(e.type);
            trace("Selected command: " + e.target.label); 
        } 
    } 
}