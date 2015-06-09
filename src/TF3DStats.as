package 
{
    import flash.display.BitmapData;
    import flash.display.CapsStyle;
    import flash.display.Graphics;
    import flash.display.LineScaleMode;
    import flash.display.Shape;
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.events.TimerEvent;
    import flash.system.System;
    import flash.text.TextField;
    import flash.text.TextFieldAutoSize;
    import flash.text.TextFormat;
    import flash.utils.Timer;
    import flash.utils.getTimer;
    
    import flare.system.Device3D;
    
    public class TF3DStats extends Sprite
    {
        private static const WIDTH:Number = 125;
        private static const MAX_HEIGHT:Number = 105;
        private static const MIN_HEIGHT:Number = 71;
        
        private static const RAM_Y:Number = -1;
        private static const POLY_Y:Number = 9;
        private static const DRAW_Y:Number = 19;
        private static const DRIVE_Y:Number = 29;
        
        private static const DIAGRAM_HEIGHT:Number = MAX_HEIGHT - 60;
        private static const BOTTOM_BAR_HEIGHT:Number = 46;
        
        private static const POLY_COL:uint = 0xffcc00;
        private static const MEM_COL:uint = 0xff00cc;
        private static const DRAW_COL:uint = 0x80FF00;
        private static const DRIVE_COL:uint = 0xFEC041;
        
        private var FTimer:Timer;
        private var FLastFframeFtimestamp:Number;
        
        private var FFPS:uint;
        private var FRam:Number;
        private var FMaxFram:Number;
        private var FMinFPS:uint;
        private var FAvgFPS:Number;
        private var FMaxFPS:uint;
        
        private var FTrangleCount:uint;
        private var FDrawCount:uint;
        
        private var FNumFrames:uint;
        private var FFPSSum:uint;
        
        private var FTopBar:Sprite;
        private var FBtmBar:Sprite;
        private var FBtmBarHit:Sprite;
        
        private var FDataFormat:TextFormat;
        private var FLabelFormat:TextFormat;
        
        private var FFPSBar:Shape;
        private var FAvgFPSBar:Shape;
        private var FLowerFPSBar:Shape;
        private var FHigherFPSBar:Shape;
        private var FDiagram:Sprite;
        private var FDiagramBMD:BitmapData;
        
        private var FMemPoints:Array;
        private var FMemGraph:Shape;
        private var FUpdates:int;
        
        private var FStateSwitchBtn:Sprite;
        
        private var FFPSTxt:TextField;
        private var FAvgFPSTxt:TextField;
        private var FRamTxt:TextField;
        private var FPolyTxt:TextField;
        private var FDrawTxt:TextField;
        private var FDriveTxt:TextField;
        
        private var FDragOffsetX:Number;
        private var FDragOffsetY:Number;
        private var FDragging:Boolean;
        
        private var FMeanData:Array;
        private var FMeanDataLength:int;
        
        private var FEnableReset:Boolean;
        private var FEnableModFr:Boolean;
        private var FTransparent:Boolean;
        private var FMinimized:Boolean;
        private var FShowingDriveInfo:Boolean;
        
        public function TF3DStats()
        {
            super();
            
            FEnableReset = true;
            FEnableModFr = true;
            
            FFPS = 0;
            FNumFrames = 0;
            FAvgFPS = 0;
            FRam = 0;
            FMaxFram = 0;
            FTrangleCount = 0;
            FDrawCount = 0;
            
            Init();
        }
        
        public function Reset():void
        {
            var i:int;
            
            // Reset all values
            FUpdates = 0;
            FNumFrames = 0;
            FMinFPS = int.MAX_VALUE;
            FMaxFPS = 0;
            FAvgFPS = 0;
            FFPSSum = 0;
            FMaxFram = 0;
            
            // Reset RAM usage log
            for (i = 0; i < WIDTH/5; i++)
            {
                FMemPoints[i] = 0;
            }
            
            // Reset FPS log if any
            if (FMeanData) 
            {
                for (i = 0; i < FMeanData.length; i++)
                    FMeanData[i] = 0.0;
            }
            
            // Clear diagram graphics
            FMemGraph.graphics.clear();
            FDiagramBMD.fillRect(FDiagramBMD.rect, 0);
        }
        
        private function Init():void
        {
            InitMisc();
            InitTopBar();
            FinitBottomBar();
            FinitDiagrams();
            FinitInteraction();
            
            Reset();
            FredrawWindow();
            
            addEventListener(Event.ADDED_TO_STAGE, AddedToStage);
            addEventListener(Event.REMOVED_FROM_STAGE, RemovedFromStage);
        }
        
        private function InitMisc():void
        {
            FTimer = new Timer(200, 0);
            FTimer.addEventListener(TimerEvent.TIMER, Update);
            
            FLabelFormat = new TextFormat('_sans', 9, 0xffffff, true);
            FDataFormat = new TextFormat('_sans', 9, 0xffffff, false);
            
            if (FMeanDataLength > 0) 
            {
                var i:int;
                FMeanData = [];
                for (i = 0; i < FMeanDataLength; i++)
                {
                    FMeanData[i] = 0.0;
                }
            }
        }
        
        /**
         * @private
         * Draw logo and create title textfield.
         */
        private function InitTopBar():void
        {
            var logo:Shape;
            var markers:Shape;
            var fpslabel:TextField;
            var avgFPSLabel:TextField;
            
            FTopBar = new Sprite;
            FTopBar.graphics.beginFill(0, 0);
            FTopBar.graphics.drawRect(0, 0, WIDTH, 20);
            addChild(FTopBar);
            
            // Color markers 
            markers = new Shape;
            markers.graphics.beginFill(0xffffff);
            markers.graphics.drawRect(5, 7, 4, 4);
            markers.graphics.beginFill(0x3388dd);
            markers.graphics.drawRect(65, 7, 4, 4);
            FTopBar.addChild(markers);
            
            // CURRENT FPS
            fpslabel = new TextField();
            fpslabel.defaultTextFormat = FLabelFormat;
            fpslabel.autoSize = TextFieldAutoSize.LEFT;
            fpslabel.text = 'FR:';
            fpslabel.x = 9;
            fpslabel.y = 2;
            fpslabel.selectable = false;
            FTopBar.addChild(fpslabel);
            
            FFPSTxt = new TextField;
            FFPSTxt.defaultTextFormat = FDataFormat;
            FFPSTxt.autoSize = TextFieldAutoSize.LEFT;
            FFPSTxt.x = fpslabel.x + 16;
            FFPSTxt.y = fpslabel.y;
            FFPSTxt.selectable = false;
            FTopBar.addChild(FFPSTxt);
            
            // AVG FPS
            avgFPSLabel = new TextField;
            avgFPSLabel.defaultTextFormat = FLabelFormat;
            avgFPSLabel.autoSize = TextFieldAutoSize.LEFT;
            avgFPSLabel.text = 'A:';
            avgFPSLabel.x = 70;
            avgFPSLabel.y = 2;
            avgFPSLabel.selectable = false;
            FTopBar.addChild(avgFPSLabel);
            
            FAvgFPSTxt = new TextField;
            FAvgFPSTxt.defaultTextFormat = FDataFormat;
            FAvgFPSTxt.autoSize = TextFieldAutoSize.LEFT;
            FAvgFPSTxt.x = avgFPSLabel.x + 12;
            FAvgFPSTxt.y = avgFPSLabel.y;
            FAvgFPSTxt.selectable = false;
            FTopBar.addChild(FAvgFPSTxt);
            
            // Minimize / maximize button
            FStateSwitchBtn = new Sprite;
            FStateSwitchBtn.x = WIDTH - 8;
            FStateSwitchBtn.y = 7;
            FStateSwitchBtn.graphics.beginFill(0, 0);
            FStateSwitchBtn.graphics.lineStyle(1, 0xefefef, 1, true);
            FStateSwitchBtn.graphics.drawRect(-4, -4, 8, 8);
            FStateSwitchBtn.graphics.moveTo(-3, 2);
            FStateSwitchBtn.graphics.lineTo(3, 2);
            FStateSwitchBtn.buttonMode = true;
            FStateSwitchBtn.addEventListener(MouseEvent.CLICK, StateSwitchBtnClick);
            FTopBar.addChild(FStateSwitchBtn);
        }
        
        private function FinitBottomBar():void
        {
            var markers:Shape;
            
            var ramLabel:TextField;
            var polyLabel:TextField;
            var drawLabel:TextField;
            var driveLabel:TextField;
            
            FBtmBar = new Sprite();
            FBtmBar.graphics.beginFill(0, 0.2);
            FBtmBar.graphics.drawRect(0, 0, WIDTH, BOTTOM_BAR_HEIGHT);
            addChild(FBtmBar);
            
            // Hit area for bottom bar (to avoid having textfields
            // affect interaction badly.)
            FBtmBarHit = new Sprite;
            FBtmBarHit.graphics.beginFill(0xffcc00, 0);
            FBtmBarHit.graphics.drawRect(0, 1, WIDTH, BOTTOM_BAR_HEIGHT - 1);
            addChild(FBtmBarHit);
            
            // Color markers
            markers = new Shape;
            markers.graphics.beginFill(MEM_COL);
            markers.graphics.drawRect(5, 6, 4, 4);
            markers.graphics.beginFill(POLY_COL);
            markers.graphics.drawRect(5, 16, 4, 4);
            markers.graphics.beginFill(DRAW_COL);
            markers.graphics.drawRect(5, 26, 4, 4);
            markers.graphics.beginFill(DRIVE_COL);
            markers.graphics.drawRect(5, 36, 4, 4);
            markers.graphics.endFill();
            FBtmBar.addChild(markers);
            
            // CURRENT RAM
            ramLabel = new TextField;
            ramLabel.defaultTextFormat = FLabelFormat;
            ramLabel.autoSize = TextFieldAutoSize.LEFT;
            ramLabel.text = 'RAM:';
            ramLabel.x = 10;
            ramLabel.y = RAM_Y;
            ramLabel.selectable = false;
            ramLabel.mouseEnabled = false;
            FBtmBar.addChild(ramLabel);
            // RAM Txt
            FRamTxt = new TextField;
            FRamTxt.defaultTextFormat = FDataFormat;
            FRamTxt.autoSize = TextFieldAutoSize.LEFT;
            FRamTxt.x = ramLabel.x + 31;
            FRamTxt.y = ramLabel.y;
            FRamTxt.selectable = false;
            FRamTxt.mouseEnabled = false;
            FBtmBar.addChild(FRamTxt);
            
            // POLY COUNT
            polyLabel = new TextField;
            polyLabel.defaultTextFormat = FLabelFormat;
            polyLabel.autoSize = TextFieldAutoSize.LEFT;
            polyLabel.text = 'POLY:';
            polyLabel.x = 10;
            polyLabel.y = POLY_Y;
            polyLabel.selectable = false;
            polyLabel.mouseEnabled = false;
            FBtmBar.addChild(polyLabel);
            // POLY TXT
            FPolyTxt = new TextField;
            FPolyTxt.defaultTextFormat = FDataFormat;
            FPolyTxt.autoSize = TextFieldAutoSize.LEFT;
            FPolyTxt.x = polyLabel.x + 31;
            FPolyTxt.y = polyLabel.y;
            FPolyTxt.selectable = false;
            FPolyTxt.mouseEnabled = false;
            FBtmBar.addChild(FPolyTxt);
            
            // DRAW CALL
            drawLabel = new TextField;
            drawLabel.defaultTextFormat = FLabelFormat;
            drawLabel.autoSize = TextFieldAutoSize.LEFT;
            drawLabel.text = 'DRAW:';
            drawLabel.x = 10;
            drawLabel.y = DRAW_Y;
            drawLabel.selectable = false;
            drawLabel.mouseEnabled = false;
            FBtmBar.addChild(drawLabel);
            
            FDrawTxt = new TextField;
            FDrawTxt.defaultTextFormat = FDataFormat;
            FDrawTxt.autoSize = TextFieldAutoSize.LEFT;
            FDrawTxt.x = drawLabel.x + 31;
            FDrawTxt.y = drawLabel.y;
            FDrawTxt.selectable = false;
            FDrawTxt.mouseEnabled = false;
            FBtmBar.addChild(FDrawTxt); 
            
            // SOFTWARE RENDERER WARNING
            driveLabel = new TextField;
            driveLabel.defaultTextFormat = FLabelFormat;
            driveLabel.autoSize = TextFieldAutoSize.LEFT;
            driveLabel.text = 'DRIV:';
            driveLabel.x = 10;
            driveLabel.y = DRIVE_Y;
            driveLabel.selectable = false;
            driveLabel.mouseEnabled = false;
            FBtmBar.addChild(driveLabel);
            
            FDriveTxt = new TextField;
            FDriveTxt.defaultTextFormat = FDataFormat;
            FDriveTxt.autoSize = TextFieldAutoSize.LEFT;
            FDriveTxt.x = driveLabel.x + 31;
            FDriveTxt.y = driveLabel.y;
            FDriveTxt.selectable = false;
            FDriveTxt.mouseEnabled = false;
            FBtmBar.addChild(FDriveTxt);
        }
        
        private function FinitDiagrams():void
        {
            
            FDiagramBMD = new BitmapData(WIDTH, DIAGRAM_HEIGHT, true, 0);
            FDiagram = new Sprite;
            FDiagram.graphics.beginBitmapFill(FDiagramBMD);
            FDiagram.graphics.drawRect(0, 0, FDiagramBMD.width, FDiagramBMD.height);
            FDiagram.graphics.endFill();
            FDiagram.y = 17;
            addChild(FDiagram);
            
            FDiagram.graphics.lineStyle(1, 0xffffff, 0.03);
            FDiagram.graphics.moveTo(0, 0);
            FDiagram.graphics.lineTo(WIDTH, 0);
            FDiagram.graphics.moveTo(0, Math.floor(FDiagramBMD.height/2));
            FDiagram.graphics.lineTo(WIDTH, Math.floor(FDiagramBMD.height/2));
            
            // FRAME RATE BAR
            FFPSBar = new Shape;
            FFPSBar.graphics.beginFill(0xffffff);
            FFPSBar.graphics.drawRect(0, 0, WIDTH, 4);
            FFPSBar.x = 0;
            FFPSBar.y = 16;
            addChild(FFPSBar);
            
            // AVERAGE FPS
            FAvgFPSBar = new Shape;
            FAvgFPSBar.graphics.lineStyle(1, 0x3388dd, 1, false, LineScaleMode.NORMAL, CapsStyle.SQUARE);
            FAvgFPSBar.graphics.lineTo(0, 4);
            FAvgFPSBar.y = FFPSBar.y;
            addChild(FAvgFPSBar);
            
            // MINIMUM FPS
            FLowerFPSBar = new Shape;
            FLowerFPSBar.graphics.lineStyle(1, 0xff0000, 1, false, LineScaleMode.NORMAL, CapsStyle.SQUARE);
            FLowerFPSBar.graphics.lineTo(0, 4);
            FLowerFPSBar.y = FFPSBar.y;
            addChild(FLowerFPSBar);
            
            // MAXIMUM FPS
            FHigherFPSBar = new Shape;
            FHigherFPSBar.graphics.lineStyle(1, 0x00ff00, 1, false, LineScaleMode.NORMAL, CapsStyle.SQUARE);
            FHigherFPSBar.graphics.lineTo(0, 4);
            FHigherFPSBar.y = FFPSBar.y;
            addChild(FHigherFPSBar);
            
            FMemPoints = [];
            FMemGraph = new Shape;
            FMemGraph.y = FDiagram.y + FDiagram.height;
            addChildAt(FMemGraph, 0);
        }
        
        private function FinitInteraction():void
        {
            // Mouse down to drag on the title
            FTopBar.addEventListener(MouseEvent.MOUSE_DOWN, TopBarMouseDown);
            
            // Reset functionality
            if (FEnableReset) 
            {
                FBtmBar.mouseEnabled = false;
                FBtmBarHit.addEventListener(MouseEvent.CLICK, CountersClickReset);
                FAvgFPSTxt.addEventListener(MouseEvent.MOUSE_UP, FonAverageFpsClickFreset, false, 1);
            }
            
            // Framerate increase/decrease by clicking on the diagram
            if (FEnableModFr)
            {
                FDiagram.addEventListener(MouseEvent.CLICK, FonDiagramClick);
            }
        }
        
        private function FredrawWindow():void
        {
            var plateFheight:Number;
            
            plateFheight = FMinimized? MIN_HEIGHT : MAX_HEIGHT;
            
            // Main plate
            if (!FTransparent) 
            {
                this.graphics.clear();
                this.graphics.beginFill(0, 0.6);
                this.graphics.drawRect(0, 0, WIDTH, plateFheight);
            }
            
            // Minimize/maximize button
            FStateSwitchBtn.rotation = FMinimized? 180 : 0;
            
            // Position counters
            FBtmBar.y = plateFheight - BOTTOM_BAR_HEIGHT;
            FBtmBarHit.y = FBtmBar.y;
            
            // Hide/show diagram for minimized/maximized view respectively
            FDiagram.visible = !FMinimized;
            FMemGraph.visible = !FMinimized;
            FFPSBar.visible = FMinimized;
            FAvgFPSBar.visible = FMinimized;
            FLowerFPSBar.visible = FMinimized;
            FHigherFPSBar.visible = FMinimized;
            
            // Redraw memory graph
            if (!FMinimized)
            {
                FredrawMemGraph();
            }
        }
        
        private function FredrawStats():void
        {
            var diaFy:int;
            
            // Redraw counters
            FFPSTxt.text = FFPS.toString().concat('/', int(stage.frameRate));
            FAvgFPSTxt.text = Math.round(FAvgFPS).toString();
            FRamTxt.text = FgetRamString(FRam).concat(' / ', FgetRamString(FMaxFram));
            
            FDiagramBMD.scroll(1, 0);
            
            if (FDrawCount > 0) 
            {
                FPolyTxt.text = FTrangleCount + "";
                FDrawTxt.text = FDrawCount + "";
                    
                // Plot rendered faces
                diaFy = FDiagramBMD.height - Math.floor(FDrawCount/FTrangleCount*FDiagramBMD.height);
                FDiagramBMD.setPixel32(1, diaFy, POLY_COL + 0xff000000);
            } 
            else
            {
                FPolyTxt.text = 'n/a (no view)';
            }
            
            // Show software (SW) or hardware (HW)
            if (!FShowingDriveInfo) 
            {
                
                if(Device3D.context)
                {
                    var di:String = Device3D.context.driverInfo;
                    FDriveTxt.text = di;//.substr(0, di.indexOf(' '));
                    FShowingDriveInfo = true;
                }
                else
                {
                    FDriveTxt.text = 'n/a (no view)';
                }
            }
            
            // Plot current framerate
            diaFy = FDiagramBMD.height - Math.floor(FFPS/stage.frameRate*FDiagramBMD.height);
            FDiagramBMD.setPixel32(1, diaFy, 0xffffffff);
            
            // Plot average framerate
            diaFy = FDiagramBMD.height - Math.floor(FAvgFPS/stage.frameRate*FDiagramBMD.height);
            FDiagramBMD.setPixel32(1, diaFy, 0xff33bbff);
            
            // Redraw diagrams
            if (FMinimized) 
            {
                FFPSBar.scaleX = Math.min(1, FFPS/stage.frameRate);
                FAvgFPSBar.x = Math.min(1, FAvgFPS/stage.frameRate)*WIDTH;
                FLowerFPSBar.x = Math.min(1, FMinFPS/stage.frameRate)*WIDTH;
                FHigherFPSBar.x = Math.min(1, FMaxFPS/stage.frameRate)*WIDTH;
            }
            else if (FUpdates%5 == 0)
            {
                FredrawMemGraph();
            }
            
            // Move along regardless of whether the graph
            // was updated this time around
            FMemGraph.x = FUpdates%5;
            
            FUpdates++;
        }
        
        private function FredrawMemGraph():void
        {
            var i:int;
            var g:Graphics;
            var maxFval:Number = 0;
            
            // Redraw memory graph (only every 5th update)
            FMemGraph.scaleY = 1;
            g = FMemGraph.graphics;
            g.clear();
            g.lineStyle(.5, MEM_COL, 1, true, LineScaleMode.NONE);
            g.moveTo(5*(FMemPoints.length - 1), -FMemPoints[FMemPoints.length - 1]);
            for (i = FMemPoints.length - 1; i >= 0; --i) 
            {
                if (FMemPoints[i + 1] == 0 || FMemPoints[i] == 0) 
                {
                    g.moveTo(i*5, -FMemPoints[i]);
                    continue;
                }
                g.lineTo(i*5, -FMemPoints[i]);
                
                if (FMemPoints[i] > maxFval)
                {
                    maxFval = FMemPoints[i];
                }
            }
            FMemGraph.scaleY = FDiagramBMD.height/maxFval;
        }
        
        private function FgetRamString(ram:Number):String
        {
            var ramFunit:String = 'B';
            
            if (ram > 1048576) 
            {
                ram /= 1048576;
                ramFunit = 'M';
            } 
            else if (ram > 1024) 
            {
                ram /= 1024;
                ramFunit = 'K';
            }
            
            return ram.toFixed(1) + ramFunit;
        }
        
        private function EndDrag():void
        {
            if (this.x < -WIDTH)
            {
                this.x = -(WIDTH - 20);
            }
            else if (this.x > stage.stageWidth)
            {
                this.x = stage.stageWidth - 20;
            }
            
            if (this.y < 0)
            {
                this.y = 0;
            }
            else if (this.y > stage.stageHeight)
            {
                this.y = stage.stageHeight - 15;
            }
            
            // Round x/y position to make sure it's on
            // whole pixels to avoid weird anti-aliasing
            this.x = Math.round(this.x);
            this.y = Math.round(this.y);
            
            FDragging = false;
            stage.removeEventListener(Event.MOUSE_LEAVE, MouseUpOrLeave);
            stage.removeEventListener(MouseEvent.MOUSE_UP, MouseUpOrLeave);
            stage.removeEventListener(MouseEvent.MOUSE_MOVE, MouseMove);
        }
        
        private function AddedToStage(ev:Event):void
        {
            FTimer.start();
            addEventListener(Event.ENTER_FRAME, FonEnterFrame);
        }
        
        private function RemovedFromStage(ev:Event):void
        {
            FTimer.stop();
            removeEventListener(Event.ENTER_FRAME, Update);
        }
        
        private function Update(ev:Event):void
        {
            // Store current and max RAM
            FRam = System.totalMemory;
            if (FRam > FMaxFram)
            {
                FMaxFram = FRam;
            }
            
            // Remove first, add last
            if (FUpdates%5 == 0) 
            {
                FMemPoints.unshift(FRam/1024);
                FMemPoints.pop();
            }
            
            FTrangleCount = Device3D.trianglesDrawn;
            FDrawCount = Device3D.drawCalls;
            
            FredrawStats();
        }
        
        private function FonEnterFrame(ev:Event):void
        {
            var time:Number = getTimer() - FLastFframeFtimestamp;
            
            // Calculate current FPS
            FFPS = Math.floor(1000/time);
            FFPSSum += FFPS;
            
            // Update min/max fps
            if (FFPS > FMaxFPS)
            {
                FMaxFPS = FFPS;
            }
            else if (FFPS != 0 && FFPS < FMinFPS)
            {
                FMinFPS = FFPS;
            }
            
            // If using a limited length log of frames
            // for the average, push the latest recorded
            // framerate onto fifo, shift one off and
            // subtract it from the running sum, to keep
            // the sum reflecting the log entries.
            if (FMeanData) 
            {
                FMeanData.push(FFPS);
                FFPSSum -= Number(FMeanData.shift());
                
                // Average = sum of all log entries over
                // number of log entries.
                FAvgFPS = FFPSSum/FMeanDataLength;
            }
            else 
            {
                // Regular average calculation, i.e. using
                // a running sum since last reset
                FNumFrames++;
                FAvgFPS = FFPSSum/FNumFrames;
            }
            
            FLastFframeFtimestamp = getTimer();
        }
        
        private function FonDiagramClick(ev:MouseEvent):void
        {
            stage.frameRate -= Math.floor((FDiagram.mouseY - FDiagramBMD.height/2)/5);
        }
        
        /**
         * @private
         * Reset just the average FPS counter.
         */
        private function FonAverageFpsClickFreset(ev:MouseEvent):void
        {
            if (!FDragging) 
            {
                var i:int;
                
                FNumFrames = 0;
                FFPSSum = 0;
                
                if (FMeanData)
                {
                    for (i = 0; i < FMeanData.length; i++)
                        FMeanData[i] = 0.0;
                }
            }
        }
        
        private function CountersClickReset(ev:MouseEvent):void
        {
            Reset();
        }
        
        private function StateSwitchBtnClick(ev:MouseEvent):void
        {
            FMinimized = !FMinimized;
            FredrawWindow();
        }
        
        private function TopBarMouseDown(ev:MouseEvent):void
        {
            FDragOffsetX = this.mouseX;
            FDragOffsetY = this.mouseY;
            stage.addEventListener(MouseEvent.MOUSE_MOVE, MouseMove);
            stage.addEventListener(MouseEvent.MOUSE_UP, MouseUpOrLeave);
            stage.addEventListener(Event.MOUSE_LEAVE, MouseUpOrLeave);
        }
        
        private function MouseMove(ev:MouseEvent):void
        {
            FDragging = true;
            this.x = stage.mouseX - FDragOffsetX;
            this.y = stage.mouseY - FDragOffsetY;
        }
        
        private function MouseUpOrLeave(ev:Event):void
        {
            EndDrag();
        }
        
        public function get MaxRam():Number
        {
            return FMaxFram;
        }
        
        public function get Ram():Number
        {
            return FRam;
        }
        
        public function get AvgFPS():Number
        {
            return FAvgFPS;
        }
        
        public function get MaxFPS():uint
        {
            return FMaxFPS;
        }
        
        public function get FPS():int
        {
            return FFPS;
        }
        
    }
}
