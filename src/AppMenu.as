package
{
    import flash.desktop.NativeApplication;
    import flash.display.NativeMenu;
    import flash.display.NativeMenuItem;
    import flash.display.NativeWindow;
    import flash.display.Stage;
    import flash.events.Event;
    import flash.filesystem.File;

    public class AppMenu
    {
        private var FPreviewArea:TPreviewArea;
        
        private var recentDocuments:Array;
        private var FFileMenu:NativeMenuItem; 
        private var FViewMenu:NativeMenuItem;


        private var FNewCommand:NativeMenuItem;
        private var FSaveCommand:NativeMenuItem;
        private var FOpenRecentMenu:NativeMenuItem;

		
        private var FGridVisibleCommand:NativeMenuItem;

        private var FAxisVisibleCommand:NativeMenuItem;
        private var FResetCamCommand:NativeMenuItem;
        
        public function AppMenu(stage:Stage, previewArea:TPreviewArea)
        {
            FPreviewArea = previewArea;
            InitMenu(stage);
        }
        
        private function InitMenu(stage:Stage):void
        {
            recentDocuments = [];
            var rootMenu:NativeMenu;
            
            if(NativeWindow.supportsMenu)
            {
                rootMenu = stage.nativeWindow.menu = new NativeMenu(); 
                rootMenu.addEventListener(Event.SELECT, selectCommandMenu); 
            }
            
            if (NativeApplication.supportsMenu)
            { 
                NativeApplication.nativeApplication.menu.addEventListener(Event.SELECT, selectCommandMenu); 
                rootMenu = NativeApplication.nativeApplication.menu = new NativeMenu();
            }
            
            rootMenu.addItem(new NativeMenuItem("文件")).submenu = createFileMenu(); 
            rootMenu.addItem(new NativeMenuItem("视图")).submenu = createViewMenu(); 
                        
            checkHasRecentFile();
        }
        
        private function checkHasRecentFile():void
        {
            FOpenRecentMenu.enabled = Boolean(recentDocuments.length)
        }
        
        private function createFileMenu():NativeMenu
        { 
            var subMenu:NativeMenu = new NativeMenu(); 
            subMenu.addEventListener(Event.SELECT, selectCommandMenu); 
            
            FNewCommand = subMenu.addItem(new NativeMenuItem("新建特效")); 
            FNewCommand.addEventListener(Event.SELECT, selectCommand); 
            
            FSaveCommand = subMenu.addItem(new NativeMenuItem("保存特效")); 
            FSaveCommand.addEventListener(Event.SELECT, selectCommand);
            
            FOpenRecentMenu = subMenu.addItem(new NativeMenuItem("最近打开的特效"));  
            FOpenRecentMenu.submenu = new NativeMenu(); 
            FOpenRecentMenu.submenu.addEventListener(Event.DISPLAYING, updateRecentDocumentMenu); 
            FOpenRecentMenu.submenu.addEventListener(Event.SELECT, selectCommandMenu); 
            
            return subMenu; 
        } 
        
        private function createViewMenu():NativeMenu 
        { 
            var subMenu:NativeMenu = new NativeMenu(); 
            subMenu.addEventListener(Event.SELECT, selectCommandMenu); 
            
            FGridVisibleCommand = subMenu.addItem(new NativeMenuItem("显示网格")); 
            FGridVisibleCommand.addEventListener(Event.SELECT, selectCommand); 
            FGridVisibleCommand.checked = true;
            
            FAxisVisibleCommand = subMenu.addItem(new NativeMenuItem("显示轴心")); 
            FAxisVisibleCommand.addEventListener(Event.SELECT, selectCommand); 
            FAxisVisibleCommand.checked = true;
            
            FResetCamCommand = subMenu.addItem(new NativeMenuItem("重置摄像机")); 
            FResetCamCommand.addEventListener(Event.SELECT, selectCommand); 
            
//            subMenu.addItem(new NativeMenuItem("", true)); 
//            
//            var FPreferencesCommand:NativeMenuItem = subMenu.addItem(new NativeMenuItem("Preferences")); 
//            FPreferencesCommand.addEventListener(Event.SELECT, selectCommand); 
            
            return subMenu; 
        } 
        
        private function updateRecentDocumentMenu(event:Event):void
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
                menuItem.addEventListener(Event.SELECT, selectRecentDocument); 
            } 
        } 
        
        private function selectRecentDocument(event:Event):void
        { 
            trace("Selected recent document: " + event.target.data.name); 
        } 
        
        private function selectCommand(e:Event):void 
        { 
            switch(e.currentTarget)
            {
                case FGridVisibleCommand:
                {
                    FGridVisibleCommand.checked = FPreviewArea.GridVisible = !FPreviewArea.GridVisible;
                    break;
                }
                case FAxisVisibleCommand:
                {
                    FAxisVisibleCommand.checked = FPreviewArea.AxisVisible = !FPreviewArea.AxisVisible;
                    break;
                }
            }
            trace("Selected command: " + e.target.label); 
        } 
        
        private function selectCommandMenu(event:Event):void 
        { 
            if (event.currentTarget.parent != null) 
            { 
                var menuItem:NativeMenuItem = findItemForMenu(NativeMenu(event.currentTarget)); 
                if (menuItem != null) 
                { 
                    trace("Select event for \"" + event.target.label + "\" command handled by menu: " + menuItem.label); 
                } 
            } 
            else 
            { 
                trace("Select event for \"" + event.target.label + "\" command handled by root menu."); 
            } 
        } 
        
        private function findItemForMenu(menu:NativeMenu):NativeMenuItem 
        { 
            for each (var item:NativeMenuItem in menu.parent.items) 
            { 
                if (item != null) 
                { 
                    if (item.submenu == menu) 
                    { 
                        return item; 
                    } 
                } 
            } 
            return null; 
        } 
    } 
}