package ControlPanel
{
    import flash.display.DisplayObjectContainer;
    
    import UI.TFoldPanelBase;
    
    public class TCustomPanel extends TFoldPanelBase
    {
        public function TCustomPanel(parent:DisplayObjectContainer, preivewArea:TPreviewArea)
        {
            super(parent, 0, 0, "自定义");
        }
    }
}