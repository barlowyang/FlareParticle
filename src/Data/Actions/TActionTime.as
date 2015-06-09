package Data.Actions
{
    import flash.geom.Vector3D;
    
    import Data.TParticle3DInstance;
    import Data.Values.TValueBase;
    import Data.Values.OneD.TOneDConst;
    import Data.Values.OneD.TOneDRandom;

    public class TActionTime implements IAction
    {
        private static const PROPS_NAME:String = TActionPropsName.TIME;
        
        private var FStartTime:TValueBase;
        private var FEnableDuration:Boolean;
        private var FDurationTime:TValueBase;
        private var FEnableLoop:Boolean;
        private var FEnbaleDelay:Boolean;
        private var FDelay:TValueBase;
        
        private static const KEY_DURATION:String = "dur";
        private static const KEY_TIME:String = "t";
        private static const KEY_LOOP:String = "l";
        private static const KEY_DELAY:String = "d";
        
        public function TActionTime()
        {
            FStartTime = new TOneDRandom(0, 1);
            FEnableDuration = true;
            FDurationTime = new TOneDConst(1);
            FEnableLoop = true;
            FEnbaleDelay = false;
            FDelay = new TOneDRandom(0, 1);
        }
        
        public function get StartTime():TValueBase
        {
            return FStartTime;
        }
        
        public function set StartTime(value:TValueBase):void
        {
            FStartTime = value;
        }

        public function get EnableDuration():Boolean
        {
            return FEnableDuration;
        }
        public function set EnableDuration(value:Boolean):void
        {
            FEnableDuration = value;
        }
        
        public function get DurationTime():TValueBase
        {
            return FDurationTime;
        }
        public function set DurationTime(value:TValueBase):void
        {
            FDurationTime = value;
        }
        
        public function get EnableLoop():Boolean
        {
            return FEnableLoop;
        }
        public function set EnableLoop(value:Boolean):void
        {
            FEnableLoop = value;
        }

        public function get Delay():TValueBase
        {
            return FDelay;
        }
        public function set Delay(value:TValueBase):void
        {
            FDelay = value;
        }
        
        public function get EnbaleDelay():Boolean
        {
            return FEnbaleDelay;
        }
        
        public function set EnbaleDelay(value:Boolean):void
        {
            FEnbaleDelay = value;
        }
        
        public function Process(target:TParticle3DInstance, delta:Number):void
        {
            var params:Object = target.params[PROPS_NAME];
            if(params)
            {
                if(params[KEY_DELAY])
                {
                    params[KEY_DELAY]-=delta;
                    if(params[KEY_DELAY]>0)
                    {
                        return;
                    }
                    else
                    {
                        target.isReady = true;
                        target.visible = true;
                        delete params[KEY_DELAY];
                    }
                }
                
                params[KEY_TIME]+=delta;
                
                if(params[KEY_DURATION])
                {
                    if(params[KEY_TIME]>params[KEY_DURATION])
                    {
                        if(params[KEY_LOOP])
                        {
                            target.isFinished = false;
                            target.isReady = false;
                            target.params = {}
                            ResetInstance(target)
                        }
                        else
                        {
                            target.isFinished = true;
                        }
                    }
                }
            }
            else
            {
                
                ResetInstance(target);
            }
        }
        
        private function ResetInstance(target:TParticle3DInstance):void
        {
            var pos:Vector3D = target.params[TActionPropsName.INIT_POS] = target.root.GetPosition();
            var rot:Vector3D = target.params[TActionPropsName.INIT_ROTATE] = target.root.GetRotation();
            var scale:Number = target.params[TActionPropsName.INIT_SCALE] = target.root.Scale;
            
            target.setPosition(pos.x, pos.y, pos.z);
            target.setRotation(rot.x, rot.y, rot.z);
            target.setScale(scale, scale, scale);
            
            var params:Object = {};
            params[KEY_TIME] = FStartTime.GenerateOneValue();
            if(FEnableDuration)
            {
                params[KEY_DURATION] = FDurationTime.GenerateOneValue();
            }
            if(FEnableLoop)
            {
                params[KEY_LOOP] = true;
            }
            if(FEnbaleDelay)
            {
                params[KEY_DELAY] = FDelay.GenerateOneValue();
                target.isReady = false;
                target.visible = false;
            }
            else
            {
                target.isReady = true;
            }
            
            target.params[PROPS_NAME] = params;
        }
        
        public function get SortIndex():int
        {
            return TActionSortIndex.ACTION_TIME;
        }
    }
}