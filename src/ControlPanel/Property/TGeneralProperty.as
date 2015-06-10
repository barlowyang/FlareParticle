package ControlPanel.Property
{
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	
	import UI.TFoldPanelBase;
	
	import bit101.components.CheckBox;
	import bit101.components.Label;
	import bit101.components.NumericStepper;
	
	import flare.core.Pivot3D;
	
	/**
	 * 常规 
	 * @author GameTrees
	 * 
	 */
	public class TGeneralProperty extends TFoldPanelBase
	{
		private var FPivot:Pivot3D;
		
		private var FStaticCheckBox:CheckBox;
		private var FVisibleCheckBox:CheckBox;
		private var FLayerNum:NumericStepper;
		
		public function TGeneralProperty(parent:DisplayObjectContainer=null)
		{
			super(parent, 0, 0, "General");
		}
		
		override protected function addChildren():void
		{
			super.addChildren();
			
			var xPos:int = 0;
			var yPos:int = 0;
			
			const Num_Step:Number = 1;
			
			//position
			FStaticCheckBox = new CheckBox(this, xPos = 7, yPos += 10, "Static");
			FStaticCheckBox.addEventListener(Event.CHANGE, CheckBoxValueUpdate);
			FVisibleCheckBox = new CheckBox(this, xPos += 70, yPos, "Visible");
			FVisibleCheckBox.addEventListener(Event.CHANGE, CheckBoxValueUpdate);
			
			new Label(this, xPos += 75, yPos -= 5, "Layer:");
			FLayerNum = CreateNumericStepper(xPos += 40, yPos, 20, 70, Num_Step, 2, UpdateProperty);
		}
		
		private function CheckBoxValueUpdate(evt:Event):void
		{
			if (FPivot)
			{
				var checkbox:CheckBox = evt.currentTarget as CheckBox;
				switch(checkbox)
				{
					case FStaticCheckBox:
					{
						FPivot.isStatic = checkbox.selected;
						break;
					}
					case FVisibleCheckBox:
					{
						FPivot.visible = checkbox.selected;
						break;
					}
				}
			}
		}
		
		private function UpdateProperty(e:Event):void
		{
			if (FPivot)
			{
				var Numeric:NumericStepper = e.currentTarget as NumericStepper;
				switch(Numeric)
				{
					case FLayerNum:
					{
						FPivot.setLayer(Numeric.value);
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
			
			FVisibleCheckBox.selected = FPivot.visible;
			FStaticCheckBox.selected = FPivot.isStatic;
			
			FLayerNum.value = FPivot.layer;
			
			draw();
		}
	}
}