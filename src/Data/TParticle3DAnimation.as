package Data
{
    import flash.display3D.Context3DBlendFactor;
    import flash.display3D.Context3DCompareMode;
    import flash.display3D.Context3DTriangleFace;
    import flash.events.Event;
    import flash.geom.Vector3D;
    import flash.utils.ByteArray;
    
    import Data.Actions.IAction;
    import Data.Actions.TActionTime;
    import Data.Actions.TActionVelocity;
    import Data.Filters.TFilterBase;
    import Data.Filters.TFilterSolidColor;
    import Data.Filters.TFilterTextureMap;
    import Data.Spaces.Particle3DSpace;
    import Data.Values.OneD.TOneDRandom;
    import Data.Values.ThreeD.TThreeDSphere;
    
    import GT.Interface.IDisposable;
    
    import Geometry.TBlendMode;
    import Geometry.TGeometryBase;
    import Geometry.TGeometryCapsule;
    import Geometry.TGeometryCube;
    import Geometry.TGeometryCylinder;
    import Geometry.TGeometryPlane;
    import Geometry.TGeometrySphere;
    import Geometry.TGeometryThreePrism;
    import Geometry.TMaterialType;
    
    import flare.core.MeshBatch3D;
    import flare.core.Particles3DExt;
    import flare.core.Pivot3D;
    import flare.materials.Shader3D;

    use namespace Particle3DSpace;
    
    public class TParticle3DAnimation implements IDisposable
    {
        private static const GEOMETRY_TYPES_CLASS:Array = [
            TGeometryPlane, 
            TGeometryCube, 
            TGeometryCylinder, 
            TGeometryCapsule, 
            TGeometrySphere, 
            null, 
            TGeometryThreePrism
        ];
        
        private static const CULL_FACES:Array = [
            Context3DTriangleFace.BACK,
            Context3DTriangleFace.FRONT,
            Context3DTriangleFace.FRONT_AND_BACK,
            Context3DTriangleFace.NONE
        ];
        
        private static const BLEND_FACTORS:Array = [
            Context3DBlendFactor.ZERO, // 0
            Context3DBlendFactor.ONE,  
            Context3DBlendFactor.SOURCE_ALPHA, // 2
            Context3DBlendFactor.SOURCE_COLOR,
            Context3DBlendFactor.DESTINATION_ALPHA, // 4
            Context3DBlendFactor.DESTINATION_COLOR,
            Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA, // 6
            Context3DBlendFactor.ONE_MINUS_SOURCE_COLOR,
            Context3DBlendFactor.ONE_MINUS_DESTINATION_ALPHA,  //8
            Context3DBlendFactor.ONE_MINUS_DESTINATION_COLOR
        ];
        
        private static const DEPTH_COMPARES:Array = [
            Context3DCompareMode.LESS_EQUAL,
            Context3DCompareMode.LESS,
            Context3DCompareMode.GREATER_EQUAL,
            Context3DCompareMode.GREATER,
            Context3DCompareMode.ALWAYS,
            Context3DCompareMode.NEVER,
            Context3DCompareMode.EQUAL,
            Context3DCompareMode.NOT_EQUAL
        ];
            
        private var FFilterList:Array = [];
        
        private var FFollow:Pivot3D;
        private var FShapeType:int;
        private var FShape:TGeometryBase;
        private var FBatch:MeshBatch3D;
        private var FBatchMaterial:Shader3D;
        
        private var FPosition:Vector3D;
        private var FRotation:Vector3D;
        private var FScale:Number;
        
        private var FParticleCount:int;
        
        private var FPlaySpeed:Number;
        private var FTimeOffset:Number;
        
        private var FMaterialType:int = -1;
        private var FBlendMode:int;
        private var FSourceFactor:int;
        private var FDestFactor:int;
        private var FCullFace:int;
        private var FEnabledLight:Boolean;
        private var FEnabledTwoSideMaterial:Boolean;
        
        private var FCurrentFilter:TFilterBase;
        
        private var FInstanceList:Vector.<TParticle3DInstance>;
        
        private var FDepthCompare:int;
        private var FIsDisposed:Boolean;
        private var FIsEnabled:Boolean;
        
        private var FContainer:Pivot3D;
        
        private var FActionList:Vector.<IAction>;
		
		private var FParticle:Particles3DExt;
		
		private static var par_id:uint = 0;
        
        public function TParticle3DAnimation(container:Pivot3D = null):void
        {
            Init(container);
        }
        
        private function Init(container:Pivot3D):void
        {
            if(container)
            {
                FContainer = container;
            }
			
			FParticle = new Particles3DExt("par_" + par_id);
			FParticle.parent = FContainer;
			
			++par_id;
            
            FActionList = new Vector.<IAction>();
            var actionTime:TActionTime = new TActionTime();
            actionTime.StartTime = new TOneDRandom(0,2)
            actionTime.DurationTime = new TOneDRandom(0,2);
            actionTime.EnableDuration = true;
            actionTime.EnableLoop = true;
            
            var actionVelocity:TActionVelocity = new TActionVelocity();
            actionVelocity.Velocity = new TThreeDSphere(300,500);
            
            FActionList.push(actionTime, actionVelocity);
                
            FIsEnabled = true;
            
            FRotation = new Vector3D();
            FPosition = new Vector3D();
            FScale = 1;
            FInstanceList = new Vector.<TParticle3DInstance>();
            
            ShapeType = 0;
            BlendMode = 0;// TBlendMode.NONE;
            SourceFactor = 1;// Context3DBlendFactor.ONE;
            DestFactor = 0;// Context3DBlendFactor.ZERO;
            ParticleCount = 200;
            CullFace = 0;
            EnabledLight = false;
            MaterialType = 0;
        }
        
        private function SortActions(a1:IAction, a2:IAction):Number
        {
            return a1.SortIndex - a2.SortIndex;
        }
        
        public function AppendAction(action:IAction):void
        {
			return;
			
            FActionList.push(action);
            FActionList.sort(SortActions);
            ClearBatch();
        }
        
        public function RemoveAction(action:IAction):void
        {
			return;
			
            var index:int = FActionList.indexOf(action);
            if(index<0)
            {
                return;
            }
            FActionList.splice(index, 1);
            ClearBatch();
        }
        
        public function GetActionList():Vector.<IAction>
        {
            return FActionList.concat();
        }
        
        public function GetShape():TGeometryBase
        {
            return FShape;
        }
        
        public function Tick(delta:Number=0):void
        {
			return;
			
            if(!FIsEnabled || !FShape)
            {
                ClearBatch();
                return;
            }
            
            FShape.CheckShapeVaildate();
            
            if(!FBatch)
            {
                FBatch = new MeshBatch3D(FShape);
                FBatch.parent = FContainer;
                FBatch.enableCameraCulling = true;
                
                
                var material:Shader3D = FBatchMaterial = FBatch.surfaces[0].material as Shader3D;
                material.sourceFactor = BLEND_FACTORS[FSourceFactor];
                material.destFactor = BLEND_FACTORS[FDestFactor];
                material.cullFace = CULL_FACES[FCullFace];
                material.depthCompare = DEPTH_COMPARES[FDepthCompare];
                material.twoSided = FEnabledTwoSideMaterial;
                material.enableLights = FEnabledLight;
            }
            
            var child:TParticle3DInstance;
            
            if(FInstanceList.length<FParticleCount)
            {
                while(FInstanceList.length<FParticleCount)
                {
                    child = new TParticle3DInstance();
                    child.parent = FBatch;
                    child.root = this;
                    FInstanceList.push(child);
                }
            }
            else if(FInstanceList.length>FParticleCount)
            {
                while(FInstanceList.length>FParticleCount)
                {
                    FInstanceList.pop().dispose();
                }
            }
            
            var pos:Vector3D;
            var rotate:Vector3D;
            var scale:Number = FScale;
            
            var px:Number = isNaN(FPosition.x)?0:FPosition.x;
            var py:Number = isNaN(FPosition.y)?0:FPosition.y;
            var pz:Number = isNaN(FPosition.z)?0:FPosition.z;
            
            var rx:Number = isNaN(FRotation.x)?0:FRotation.x;
            var ry:Number = isNaN(FRotation.y)?0:FRotation.y;
            var rz:Number = isNaN(FRotation.z)?0:FRotation.z;
            
            
            var len:int = FInstanceList.length;
            for ( var i:int = 0; i <len ; i++ )
            {
                FInstanceList[i].ApplyActions(FActionList, delta);
            }
        }
		
        Particle3DSpace function ClearBatch(e:Event = null):void
        {
            if(FBatch)
            {
                FBatch.dispose();
                FBatch = null;
                FBatchMaterial = null;
                if(FInstanceList.length)
                {
                    try
                    {
                        while(FInstanceList.length)
                        {
                            FInstanceList.pop().dispose();
                        }
                    } 
                    catch(error:Error) { }
                    FInstanceList.length = 0;
                }
            }
        }

        private function DrawShape():void
        {
            var cls:Class = GEOMETRY_TYPES_CLASS[FShapeType];
            if(FShape)
            {
                FShape.removeEventListener("Update", ClearBatch);
                FShape.dispose();
                FShape = null
            }
            
            if(cls != null)
            {
                FShape = new cls();
                FShape.addEventListener("Update", ClearBatch);
                if(FCurrentFilter)
                {
                    FShape.UpdateFilter(FCurrentFilter.Filter);
                }
                FShape.DestFactor = BLEND_FACTORS[FDestFactor];
                FShape.SourceFactor = BLEND_FACTORS[FSourceFactor];
            }
            
            ClearBatch();
        }
        
        public function set Scale(value:Number):void
        {
            FScale = value;
        }
        public function get Scale():Number
        {
            return FScale
        }
        
        public function SetPosition(x:Number, y:Number, z:Number, smooth:Number=1, local:Boolean=true):void
        {
            FPosition.setTo(x,y,z);
        }
        public function GetPosition():Vector3D
        {
            return FPosition.clone();
        }
        
        public function SetRotation(x:Number, y:Number, z:Number):void
        {
            FRotation.setTo(x,y,z);
        }
        public function GetRotation():Vector3D
        {
            return FRotation.clone();
        }
        
        Particle3DSpace function get Shape():TGeometryBase
        {
            return FShape;
        }
        
        public function get Follow():Pivot3D { return FFollow; }
        public function set Follow(target:Pivot3D):void
        {
            FFollow = target;
        }
        
        public function get ShapeType():int
        {
            return FShapeType;
        }
        
        public function set ShapeType(value:int):void
        {
            if(FShape && FShapeType == value)
            {
                return;
            }
            FShapeType = value;
            DrawShape();
        }
        
        public function get PlaySpeed():Number
        {
            return FPlaySpeed;
        }
        public function set PlaySpeed(value:Number):void
        {
            FPlaySpeed = value;
        }
        
        public function get TimeOffset():Number
        {
            return FTimeOffset;
        }
        public function set TimeOffset(value:Number):void
        {
            FTimeOffset = value;
        }
        
        public function get BlendMode():int
        {
            return FBlendMode;
        }
        public function set BlendMode(v:int):void
        {
            FBlendMode = v;
            var factors:Array = TBlendMode.GetFactorsByMode(v);
            if(factors)
            {
                FSourceFactor = factors[0];
                FDestFactor = factors[1];
                if(FShape)
                {
                    FShape.SourceFactor = BLEND_FACTORS[factors[0]];
                    FShape.DestFactor = BLEND_FACTORS[factors[1]];
                }
            }
        }
        
        public function get SourceFactor():int
        {
            return FSourceFactor;
        }
        public function set SourceFactor(v:int):void
        {
            FSourceFactor = v;
            if(FShape)
            {
                FShape.SourceFactor = BLEND_FACTORS[v];
            }
            FBlendMode = TBlendMode.GetModeByFactor(v, FDestFactor);
        }
        
        public function get DestFactor():int
        {
            return FDestFactor;
        }
        public function set DestFactor(v:int):void
        {
            FDestFactor = v;
            if(FShape)
            {
                FShape.DestFactor = BLEND_FACTORS[v];
            }
            FBlendMode = TBlendMode.GetModeByFactor(FSourceFactor, v);
        }
        
        public function get EnabledLight():Boolean
        {
            return FEnabledLight;
        }
        public function set EnabledLight(v:Boolean):void
        {
            FEnabledLight = v;
            if(FBatchMaterial)
            {
                FBatchMaterial.enableLights = v;
            }
        }
        
        public function get EnabledTwoSideMaterial():Boolean
        {
            return FEnabledTwoSideMaterial;
        }
        public function set EnabledTwoSideMaterial(v:Boolean):void
        {
            FEnabledTwoSideMaterial = v;
            if(FShape)
            {
                FShape.EnabledTwoSideMaterial = v;
            }
            if(FBatchMaterial)
            {
                FBatchMaterial.twoSided = v;
            }
        }
        
        public function get CullFace():int
        {
            return FCullFace
        }
        public function set CullFace(cullFace:int):void
        {
            FCullFace = cullFace;
            if(FBatchMaterial)
            {
                FBatchMaterial.cullFace = CULL_FACES[cullFace];
            }
        }
        
        public function get MaterialType():int
        {
            return FMaterialType;
        }
        public function set MaterialType(value:int):void
        {
            
            if(FMaterialType == value)
            {
                return;
            }
            
            FMaterialType = value;
            
            if(FCurrentFilter)
            {
                FCurrentFilter.Dispose();
            }
            switch(value)
            {
                case TMaterialType.SOLID_COLOR:
                {
                    FCurrentFilter = new TFilterSolidColor(this);
                    break;
                }
                case TMaterialType.TEXTURE:
                {
                    FCurrentFilter = new TFilterTextureMap(this);
                    break;
                }
            }
            
            if(FShape)
            {
                FShape.UpdateFilter(FCurrentFilter.Filter);
            }
        }
        
        public function get ParticleCount():int
        {
            return FParticleCount;
        }
        public function set ParticleCount(value:int):void
        {
            FParticleCount = value;
        }
        
        public function get DepthCompare():int
        {
            return FDepthCompare;
        }
        
        public function set DepthCompare(value:int):void
        {
            FDepthCompare = value;
            if(FBatchMaterial)
            {
                FBatchMaterial.depthCompare = DEPTH_COMPARES[value];
            }
        }
        
        public function get CurrentFilter():TFilterBase
        {
            return FCurrentFilter;
        }
        
        public function Dispose():void
        {
            if(!FIsDisposed)
            {
                FIsDisposed = true;
                ClearBatch();
                if(FShape)
                {
                    FShape.dispose();
                }
            }
        }
        
        public function get IsDisposed():Boolean
        {
            return FIsDisposed;
        }
        
        public function get Enabled():Boolean
        {
            return FIsEnabled;
        }
        public function set Enabled(value:Boolean):void
        {
            FIsEnabled = value;
        }
        
		public function get Particle():Particles3DExt
		{
			return FParticle;
		}
    }
}