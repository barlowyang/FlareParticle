package 
{
    import flash.display.DisplayObjectContainer;
    import flash.events.Event;
    import flash.events.EventPhase;
    import flash.geom.Vector3D;
    
    import Data.TParticle3DAnimation;
    
    import GT.Interface.ITickable;
    
    import flare.basic.Scene3D;
    import flare.core.Camera3D;
    import flare.system.Input3D;
    import flare.utils.Vector3DUtils;
    
    public class TPreviewArea extends Scene3D implements ITickable
    {
        private static const DISTANCE_FACTOR:int = 6;
        private static const GRID_SIZE:int = 50;
        private static const SUBDIVISION_SIZE:int = 20;
        
        private var FAxis:TTridentAxis;
        private var FGrid:TWireFrameGrid;
        private var FDrag:Boolean;
        private var FSpinX:Number;
        private var FSpinY:Number;
        private var FSpinZ:Number;
        private var FOut:Vector3D
        private var FSmooth:Number;
        private var FSpeedFactor:Number;
        private var FAnimationList:Vector.<TParticle3DAnimation>;
        
        public function TPreviewArea(container:DisplayObjectContainer, file:String="", smooth:Number=1, speedFactor:Number=0.5)
        {
            super(container, file);
            FSmooth = smooth;
            FSpeedFactor = speedFactor;
            FAnimationList = new Vector.<TParticle3DAnimation>();
            InitPreviewArea(container);
            Input3D.rightClickEnabled = true;
        }
        
        public function ResetCam():void
        {
            FSpinX = 0;
            FSpinY = 30;
            FSpinZ = -400;
            camera.dispose();
            camera = new Camera3D();
            UpdateCam(true);
            
        }
        
        public function AppendEffectAnimation(animation:TParticle3DAnimation):void
        {
            FAnimationList.push(animation);
        }
        public function RemoveEffectAnimation(animation:TParticle3DAnimation):void
        {
            var index:int = FAnimationList.indexOf(animation);
            if(index<0)
            {
                return;
            }
            FAnimationList.splice(index,1);
        }
        
        private function InitPreviewArea(container:DisplayObjectContainer):void
        {
            FGrid = new TWireFrameGrid(SUBDIVISION_SIZE, GRID_SIZE);
            FGrid.parent = this;
            
            FAxis = new TTridentAxis(GRID_SIZE * 1.5, true);
            FAxis.parent = this;

            addEventListener(Scene3D.UPDATE_EVENT, UpdateEvent);
            
            ResetCam();
        }
        
        private function UpdateCam(force:Boolean = false):void
        {
            if(FDrag && Input3D.mouseUp)
            {
                FDrag = false
            }
            
            if(!force )
            {
                if(Input3D.eventPhase>EventPhase.AT_TARGET)
                {
                    return;
                }
                
                if((Input3D.mouseHit) && (viewPort.contains(Input3D.mouseX,Input3D.mouseY)))
                {
                    FDrag = true;
                }
                
                if (!FDrag && Input3D.delta == 0)
                {
                    return;
                }
            }
            
            if (Input3D.keyDown(Input3D.SPACE))
            {
                camera.translateX((-Input3D.mouseXSpeed) * camera.getPosition().length / 300);
                camera.translateY(Input3D.mouseYSpeed * camera.getPosition().length / 300);
            }
            else
            {
                FSpinX = FSpinX + Input3D.mouseXSpeed * FSmooth * FSpeedFactor;
                FSpinY = FSpinY + Input3D.mouseYSpeed * FSmooth * FSpeedFactor;
            }
            
            if (Input3D.delta != 0)
            {
                if (viewPort.contains(Input3D.mouseX, Input3D.mouseY))
                {
                    FSpinZ = (camera.getPosition(false, FOut).length + 0.1) * FSpeedFactor * Input3D.delta / 20;
                }
            }
            
            camera.translateZ(FSpinZ);
            camera.rotateY(FSpinX, false, Vector3DUtils.ZERO);
            camera.rotateX(FSpinY, true, Vector3DUtils.ZERO);
            
            FSpinX = FSpinX * ( 1 - FSmooth );
            FSpinY = FSpinY * ( 1 - FSmooth );
            FSpinZ = FSpinZ * ( 1 - FSmooth );
        }
        
        private function UpdateEvent(event:Event) : void
        {
            UpdateCam();
        }
        
        public function set GridVisible(v:Boolean):void
        {
            if(v)
            {
                addChild(FGrid);
            }
            else
            {
                if(FGrid.parent)
                {
                    FGrid.parent.removeChild(FGrid);
                }
            }
        }
        
        public function get GridVisible():Boolean
        {
            return FGrid.parent;
        }
        
        public function set AxisVisible(v:Boolean):void
        {
            if(v)
            {
                addChild(FAxis);
            }
            else
            {
                if(FAxis.parent)
                {
                    FAxis.parent.removeChild(FAxis);
                }
            }
        }
        public function get AxisVisible():Boolean
        {
            return FAxis.parent;
        }
        
        public function get SpeedFactor():Number
        {
            return FSpeedFactor;
        }
        public function set SpeedFactor(value:Number):void
        {
            FSpeedFactor = value;
        }
        
        public function get Smooth():Number
        {
            return FSmooth;
        }
        public function set Smooth(value:Number):void
        {
            FSmooth = value;
        }
        
        public function Tick(delta:Number = 0):void
        {
            for(var i:int = FAnimationList.length-1; i>=0; i--)
            {
                if(FAnimationList[i].IsDisposed)
                {
                    FAnimationList.splice(i, 1);
                }
                else
                {
                    FAnimationList[i].Tick(delta);
                }
            }
        }
    }
}
import flash.geom.Vector3D;

import flare.core.Lines3D;
import flare.core.Pivot3D;
import flare.materials.Shader3D;
import flare.materials.filters.ColorFilter;
import flare.primitives.Cone;
import flare.primitives.Sphere;

class TWireFrameGrid extends Lines3D
{
    public function TWireFrameGrid( subDivision:int, gridSize:int, thickness:Number = .5, color:uint = 0xaaaaaa)
    {
        var lineLen:int = gridSize * subDivision * 0.5;
        lineStyle(thickness, color);
        for(var i:int = 0; i<subDivision+1; i++)
        {
            moveTo(gridSize * i - lineLen, 0, -lineLen);
            lineTo(gridSize * i - lineLen, 0, lineLen);
            moveTo(-lineLen, 0, gridSize * i - lineLen);
            lineTo(lineLen, 0, gridSize * i - lineLen);
        }
    }
}

class TTridentAxis extends Pivot3D
{
    private var FLine:Lines3D;
    
    public function TTridentAxis(length:int = 20, showLetter:Boolean = false):void
    {
        
        FLine = new Lines3D();
        FLine.parent = this;
       
        var scaleH:Number = length/10;
        var scaleW:Number = length/20;
        var scl1:Number = scaleW*1.5;
        var scl2:Number = scaleH*3;
        var scl3:Number = scaleH*2;
        var scl4:Number = scaleH*3.4;
        var cross:Number = length + (scl3) + (((length + scl4) - (length + scl3))/3*2);
        var letterPath:Vector.<Vector3D>;
        
        //x
        if(showLetter)
        {
            letterPath = Vector.<Vector3D>([
                new Vector3D(length + scl2, scl1, 0),
                new Vector3D(length + scl3, -scl1, 0),
                new Vector3D(length + scl3, scl1, 0),
                new Vector3D(length + scl2, -scl1, 0)
            ]);
        }
        createAxis(0xff0000, length, Vector3D.X_AXIS, new Vector3D( 0, 0, -1), letterPath);
        //y
        if(showLetter)
        {
            letterPath = Vector.<Vector3D>([
                new Vector3D(-scaleW*1.2, length + scl4, 0),
                new Vector3D(0, cross, 0),
                new Vector3D(scaleW*1.2, length + scl4, 0),
                new Vector3D(0, cross, 0),
                new Vector3D(0, cross, 0),
                new Vector3D(0, length + scl3, 0)
            ]);
        }   
        createAxis(0x00ff00, length, Vector3D.Y_AXIS, new Vector3D( 0, 1, 0), letterPath);
        //z
        if(showLetter)
        {
            letterPath = Vector.<Vector3D>([
                new Vector3D(0, scl1, length + scl2),
                new Vector3D(0, scl1, length + scl3),
                new Vector3D(0, -scl1, length + scl2),
                new Vector3D(0, -scl1, length + scl3),
                new Vector3D(0, -scl1, length + scl3),
                new Vector3D(0, scl1, length + scl2)
            ]);
        }
        createAxis(0x0000ff, length, Vector3D.Z_AXIS, new Vector3D(1, 0, 0), letterPath);
        //origin
        var shader:Shader3D = new Shader3D("",[new ColorFilter(0xaaaaaa)])
        shader.enableLights = false;
        addChild(new Sphere("",length/30, 6, shader));
    }
    
    private function createAxis(color:uint, distance:uint, axis:Vector3D, rotate:Vector3D, letterPath:Vector.<Vector3D>):void
    {
        var shader:Shader3D = new Shader3D("", [new ColorFilter(color)]);
        shader.enableLights = false;
        
        var axisCone:Cone = new Cone("", distance/30,0,distance/6,3,shader);
        axisCone.translateAxis(distance, axis);
        axisCone.rotateAxis(90, rotate);
        axisCone.parent = this;
        axis = axis.clone();
        axis.scaleBy(distance);
        
        FLine.lineStyle(2, color);
        FLine.moveTo(0,0,0);
        FLine.lineTo(axis.x,axis.y,axis.z);
        
        if(letterPath)
        {
            FLine.lineStyle(2, color);
            var lp0:Vector3D;
            var lp1:Vector3D;
            for (var i:uint = 0; i < letterPath.length; i+=2) 
            {
                lp0 = letterPath[i];
                lp1 = letterPath[i + 1];
                FLine.moveTo(lp0.x, lp0.y, lp0.z);
                FLine.lineTo(lp1.x, lp1.y, lp1.z);
            }
        }
        
    }
    
}
