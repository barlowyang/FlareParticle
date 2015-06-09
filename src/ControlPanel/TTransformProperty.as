package ControlPanel
{
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.geom.Vector3D;
	
	import UI.TFoldPanelBase;
	
	import bit101.components.Label;
	import bit101.components.NumericStepper;
	
	import flare.core.Pivot3D;
	
	/**
	 * 变换属性
	 * 
	 * @author GameTrees
	 * 
	 */
	public class TTransformProperty extends TFoldPanelBase
	{
		private var FPivot:Pivot3D;
		
		private var FPosXNum:NumericStepper;
		private var FPosYNum:NumericStepper;
		private var FPosZNum:NumericStepper;
		
		private var FRotXNum:NumericStepper;
		private var FRotYNum:NumericStepper;
		private var FRotZNum:NumericStepper;
		
		private var FScaleXNum:NumericStepper;
		private var FScaleYNum:NumericStepper;
		private var FScaleZNum:NumericStepper;
		
		public function TTransformProperty(parent:DisplayObjectContainer=null)
		{
			super(parent, 0, 0, "Transform", 20);
		}
		
		override protected function addChildren():void
		{
			super.addChildren();
			
			var xPos:int = 0
			var yPos:int = 0
			
			//position
			new Label(this, xPos=5, yPos+=5, "Position X:");
			FPosXNum = CreateNumericStepper(xPos += 45, yPos, 20, 70, 0.01, 2, UpdateProperty);
			new Label(this, xPos+75, yPos, "Y:");
			FPosYNum = CreateNumericStepper(xPos += 90, yPos, 20, 70, 0.01, 2, UpdateProperty);
			new Label(this, xPos+75, yPos, "Z:");
			FPosZNum = CreateNumericStepper(xPos += 90, yPos, 20, 70, 0.01, 2, UpdateProperty);
			
			new Label(this, xPos=5, yPos+=25, "Rotation X:");
			FRotXNum = CreateNumericStepper(xPos += 45, yPos, 20, 70, 1, 0, UpdateProperty);
			new Label(this, xPos+75, yPos, "Y:");
			FRotYNum = CreateNumericStepper(xPos += 90, yPos, 20, 70, 1, 0, UpdateProperty);
			new Label(this, xPos+75, yPos, "Z:");
			FRotZNum = CreateNumericStepper(xPos += 90, yPos, 20, 70, 1, 0, UpdateProperty);
			
			new Label(this, xPos=5, yPos+=25, "Scale X:");
			FScaleXNum = CreateNumericStepper(xPos += 45, yPos, 20, 70, 0.01, 2, UpdateProperty);
			new Label(this, xPos+75, yPos, "Y:");
			FScaleYNum = CreateNumericStepper(xPos += 90, yPos, 20, 70, 1, 0, UpdateProperty);
			new Label(this, xPos+75, yPos, "Z:");
			FScaleZNum = CreateNumericStepper(xPos += 90, yPos, 20, 70, 1, 0, UpdateProperty);
		}
		
		private function UpdateProperty(e:Event):void
		{
			if (FPivot)
			{
				var RotVec:Vector3D;
				var Numeric:NumericStepper = e.currentTarget as NumericStepper;
				switch(Numeric)
				{
					case FPosXNum:
					{
						FPivot.x = Numeric.value;
						break;
					}
					case FPosYNum:
					{
						FPivot.y = Numeric.value;
						break;
					}
					case FPosZNum:
					{
						FPivot.z = Numeric.value;
						break;
					}
						
					case FRotXNum:
					{
						RotVec = FPivot.getRotation();
						FPivot.setRotation(Numeric.value, RotVec.y, RotVec.z);
						break;
					}
					case FRotYNum:
					{
						RotVec = FPivot.getRotation();
						FPivot.setRotation(RotVec.x, Numeric.value, RotVec.z);
						break;
					}
					case FRotZNum:
					{
						RotVec = FPivot.getRotation();
						FPivot.setRotation(RotVec.x, RotVec.y, Numeric.value);
						break;
					}
						
					case FScaleXNum:
					{
						FPivot.scaleX = Numeric.value;
						break;
					}
					case FScaleYNum:
					{
						FPivot.scaleY = Numeric.value;
						break;
					}
					case FScaleZNum:
					{
						FPivot.scaleZ = Numeric.value;
						break;
					}
				}
			}
		}
		
		private function CreateNumericStepper(x:int, y:int, height:int, width:int, step:Number, labelPrecision:int, handle:Function):NumericStepper
		{
			var ns:NumericStepper = new NumericStepper(this, x, y);
			ns.addEventListener(Event.CHANGE, handle);
			ns.setSize(width, height);
			ns.labelPrecision = labelPrecision;
			ns.step = step;
			return ns;
		}
		
		
		public function set Target(value:Pivot3D):void
		{
			FPivot = value;
			
			FPosXNum.value = FPivot.x;
			FPosYNum.value = FPivot.y;
			FPosZNum.value = FPivot.z;
			
			var RotVec:Vector3D = FPivot.getRotation();
			FRotXNum.value = RotVec.x;
			FRotYNum.value = RotVec.y;
			FRotZNum.value = RotVec.z;
			
			FScaleXNum.value = FPivot.scaleX;
			FScaleXNum.value = FPivot.scaleY;
			FScaleXNum.value = FPivot.scaleZ;
		}
	}
}