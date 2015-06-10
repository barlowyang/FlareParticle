package 
{
    import flash.display.DisplayObjectContainer;
    
    import flare.basic.Viewer3D;
    import flare.core.Particles3DExt;
    
    public class TPreviewArea extends Viewer3D
    {
        private var FParticle:Particles3DExt;
		
        public function TPreviewArea(container:DisplayObjectContainer, file:String="", smooth:Number=1, speedFactor:Number=0.5)
        {
			super(container, file, smooth, speedFactor);
			
			FParticle = new Particles3DExt();
			addChild(FParticle);
			
			this.camera.z = -300;
			this.camera.y = 0;
		}
		
		public function get particle():Particles3DExt
		{
			return FParticle;
		}
	}
}