package ControlPanel.Property
{
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Vector3D;
	
	import UI.TFoldPanelBase;
	
	import bit101.components.CheckBox;
	import bit101.components.ComboBox;
	import bit101.components.InputText;
	import bit101.components.Label;
	import bit101.components.NumericStepper;
	
	import flare.apps.controls.GradientColor;
	import flare.core.Particles3DExt;
	import flare.core.Pivot3D;
	import flare.naruto.particle.emitter.ThreeD.TThreeDConst;
	import flare.naruto.particle.emitter.ThreeD.TThreeDCylinder;
	import flare.naruto.particle.emitter.ThreeD.TThreeDSphere;
	
	/**
	 * 粒子 
	 * @author GameTrees
	 * 
	 */
	public class TParticlesProperty extends TFoldPanelBase
	{
		private static const BLEND_MODE_LIST:Array = [ 
			"NONE", 
			"ADDITIVE", 
			"TRANSPARENT", 
			"MULTIPLY",
			"REPRODUCTION", 
			"SCREEN",
			"CUSTOM" 
		];
		private static const AREA_CLS_L:Array = new Array(TThreeDConst, TThreeDSphere, TThreeDCylinder);
			
		private var FParticle3D:Particles3DExt;
		private var FBlendMode:ComboBox;
		private var FSortMode:ComboBox;
		private var FAreaMode:ComboBox;
		private var FUseRndGradientColor:CheckBox;
		private var FGradientColor:GradientColor;
		private var FGradientAlpha:GradientColor;
		private var FTintColor:InputText;
		
		private var FSpinNum:NumericStepper;
		private var FRandomSpinNum:NumericStepper;
		
		private var FStartSizeNum:NumericStepper;
		private var FEndSizeNum:NumericStepper;
		private var FRandomScaleNum:NumericStepper;
		
		private var FVelocityXNum:NumericStepper;
		private var FVelocityYNum:NumericStepper;
		private var FVelocityZNum:NumericStepper;
		private var FGravityXNum:NumericStepper;
		private var FGravityYNum:NumericStepper;
		private var FGravityZNum:NumericStepper;
		private var FRandomVelocityNum:NumericStepper;
		private var FGravityPowerNum:NumericStepper;
		
		private var FNumberNum:NumericStepper;
		private var FDurationNum:NumericStepper;
		private var FLoopsNum:NumericStepper;
		private var FDelayNum:NumericStepper;
		private var FShotsNum:NumericStepper;
		
		private var FAreaXNum:NumericStepper;
		private var FAreaYNum:NumericStepper;
		private var FAreaZNum:NumericStepper;
		
		private var FEnergyXNum:NumericStepper;
		private var FEnergyYNum:NumericStepper;
		private var FEnergyZNum:NumericStepper;
		
		private var FHemisphere:CheckBox;
		private var FReverse:CheckBox;
		private var FWorldPos:CheckBox;
		private var FWorldVel:CheckBox;
		
		
		public function TParticlesProperty(parent:DisplayObjectContainer=null)
		{
			super(parent, 0, 0, "Particle", 25);
		}
		
		override protected function addChildren():void
		{
			super.addChildren();
			var xPos:int = 0;
			var yPos:int = 0;
			
			new Label(this, xPos=5, yPos=5,   "Blend Mode:");
			FBlendMode = new ComboBox(this, xPos += 80, yPos-2);
			FBlendMode.items = BLEND_MODE_LIST;
			FBlendMode.width = 220;
			FBlendMode.addEventListener(Event.SELECT, onUpdateMode);
			
			new Label(this, xPos=5, yPos+=25,   "Sort Mode:");
			FSortMode = new ComboBox(this, xPos += 80, yPos-=2);
			FSortMode.items = ["None", "Youngest First", "Oldest First"];
			FSortMode.width = 220;
			FSortMode.addEventListener(Event.SELECT, onUpdateMode);
			
			new Label(this, xPos=5, yPos+=15, "-----------------------------------------------------------------------");
			const Num_Step:Number = 1;
			//position
			new Label(this, xPos=5, yPos+=15,   "Sort Mode:");
			FAreaMode = new ComboBox(this, xPos += 80, yPos-=2);
			FAreaMode.items = ["Const", "Sphere", "Cylinder"];
			FAreaMode.width = 220;
			FAreaMode.addEventListener(Event.SELECT, onUpdateMode);
			
			new Label(this, xPos=5, yPos+=25, "Area: ");
			FAreaXNum = CreateNumericStepper(xPos += 70, yPos, 20, 70, Num_Step, 2, onUpdateNum);
			FAreaYNum = CreateNumericStepper(xPos += 90, yPos, 20, 70, Num_Step, 2, onUpdateNum);
			FAreaZNum = CreateNumericStepper(xPos += 90, yPos, 20, 70, Num_Step, 2, onUpdateNum);
			
			new Label(this, xPos=5, yPos+=25, "Energy: ");
			FEnergyXNum = CreateNumericStepper(xPos += 70, yPos, 20, 70, Num_Step, 2, onUpdateNum);
			FEnergyYNum = CreateNumericStepper(xPos += 90, yPos, 20, 70, Num_Step, 2, onUpdateNum);
			FEnergyZNum = CreateNumericStepper(xPos += 90, yPos, 20, 70, Num_Step, 2, onUpdateNum);
			
			FHemisphere = new CheckBox(this, xPos = 7, yPos += 25, "Hemisphere:");
			FHemisphere.addEventListener(Event.CHANGE, onUpdateCheckbox);
			
			FReverse = new CheckBox(this, xPos = 7, yPos += 25, "Reverse:");
			FReverse.addEventListener(Event.CHANGE, onUpdateCheckbox);
			
			FWorldPos = new CheckBox(this, xPos = 7, yPos += 25, "World Position:");
			FWorldPos.addEventListener(Event.CHANGE, onUpdateCheckbox);
			
			FWorldVel = new CheckBox(this, xPos = 7, yPos += 25, "World Velocities:");
			FWorldVel.addEventListener(Event.CHANGE, onUpdateCheckbox);
			
			new Label(this, xPos=5, yPos+=15, "-----------------------------------------------------------------------");
			new Label(this, xPos=5, yPos+=15, "Number: ");
			FNumberNum = CreateNumericStepper(xPos += 70, yPos, 20, 70, Num_Step, 2, onUpdateNum);
			new Label(this, xPos=5, yPos+=25, "Duration: ");
			FDurationNum = CreateNumericStepper(xPos += 70, yPos, 20, 70, Num_Step, 2, onUpdateNum);
			new Label(this, xPos=5, yPos+=25, "Loops: ");
			FLoopsNum = CreateNumericStepper(xPos += 70, yPos, 20, 70, Num_Step, 2, onUpdateNum);
			new Label(this, xPos=5, yPos+=25, "Delay: ");
			FDelayNum = CreateNumericStepper(xPos += 70, yPos, 20, 70, Num_Step, 2, onUpdateNum);
			new Label(this, xPos=5, yPos+=25, "Shots: ");
			FShotsNum = CreateNumericStepper(xPos += 70, yPos, 20, 70, Num_Step, 2, onUpdateNum);
			
			
			new Label(this, xPos=5, yPos+=15, "-----------------------------------------------------------------------");
			new Label(this, xPos=5, yPos+=15, "Velocity: ");
			FVelocityXNum = CreateNumericStepper(xPos += 70, yPos, 20, 70, Num_Step, 2, onUpdateNum);
			FVelocityYNum = CreateNumericStepper(xPos += 90, yPos, 20, 70, Num_Step, 2, onUpdateNum);
			FVelocityZNum = CreateNumericStepper(xPos += 90, yPos, 20, 70, Num_Step, 2, onUpdateNum);
			new Label(this, xPos=5, yPos+=25, "Gravity: ");
			FGravityXNum = CreateNumericStepper(xPos += 70, yPos, 20, 70, Num_Step, 2, onUpdateNum);
			FGravityYNum = CreateNumericStepper(xPos += 90, yPos, 20, 70, Num_Step, 2, onUpdateNum);
			FGravityZNum = CreateNumericStepper(xPos += 90, yPos, 20, 70, Num_Step, 2, onUpdateNum);
			new Label(this, xPos=5, yPos+=25, "Random Velocity: ");
			FRandomVelocityNum = CreateNumericStepper(xPos += 70, yPos, 20, 70, Num_Step, 2, onUpdateNum);
			new Label(this, xPos=5, yPos+=25, "Gravity Power: ");
			FGravityPowerNum = CreateNumericStepper(xPos += 70, yPos, 20, 70, Num_Step, 2, onUpdateNum);
			
			new Label(this, xPos=5, yPos+=15, "-----------------------------------------------------------------------");
			new Label(this, xPos=5, yPos+=15, "Start Size: ");
			FStartSizeNum = CreateNumericStepper(xPos += 70, yPos, 20, 70, Num_Step, 2, onUpdateNum);
			new Label(this, xPos=5, yPos+=25, "End Size: ");
			FEndSizeNum = CreateNumericStepper(xPos += 70, yPos, 20, 70, Num_Step, 2, onUpdateNum);
			new Label(this, xPos=5, yPos+=25, "Random Scale: ");
			FRandomScaleNum = CreateNumericStepper(xPos += 70, yPos, 20, 70, Num_Step, 2, onUpdateNum);
			
			new Label(this, xPos=5, yPos+=15, "-----------------------------------------------------------------------");
			new Label(this, xPos=5, yPos+=15, "Spin: ");
			FSpinNum = CreateNumericStepper(xPos += 70, yPos, 20, 70, Num_Step, 2, onUpdateNum);
			new Label(this, xPos=5, yPos+=25, "Random Spin: ");
			FRandomSpinNum = CreateNumericStepper(xPos += 70, yPos, 20, 70, Num_Step, 2, onUpdateNum);
			
			new Label(this, xPos=5, yPos+=15, "-----------------------------------------------------------------------");
			FUseRndGradientColor = new CheckBox(this, xPos = 100, yPos += 15, "Use Random Gradient Color:");
			FUseRndGradientColor.addEventListener(Event.CHANGE, onUpdateCheckbox);
			
			new Label(this, xPos=5, yPos+=25, "Color: ");
			FGradientColor = new GradientColor("color_gradient", 100, 100, 200, 20);
			FGradientColor.mode = 2;
			FGradientColor.x = xPos + 70;
			FGradientColor.y = yPos;
			FGradientColor.addEventListener(Event.CHANGE, onUpdateColor);
			addChild(FGradientColor.view);
			
			new Label(this, xPos=5, yPos+=25, "Alpha: ");
			FGradientAlpha = new GradientColor("alpha_gradient", 100, 100, 200, 20);
			FGradientAlpha.mode = 2;
			FGradientAlpha.x = xPos + 70;
			FGradientAlpha.y = yPos;
			FGradientAlpha.addEventListener(Event.CHANGE, onUpdateColor);
			addChild(FGradientAlpha.view);
			
			new Label(this, xPos=5, yPos+=25, "Tint: ");
			FTintColor = new InputText(this, xPos += 70, yPos, "0xffffffff", function (evt:Event):void
			{
				var tintColor:uint = uint("0x" + FTintColor.text);
				FParticle3D.setTint((tintColor >> 24) & 0xff, (tintColor >> 16) & 0xff, (tintColor >> 8) & 0xff, tintColor & 0xff);
			});
			
			height = 1000;
		}
		
		private function onUpdateColor(evt:Event):void
		{
			var tar_color:GradientColor = evt.currentTarget as GradientColor;
			switch(tar_color)
			{
				case FGradientColor:
				{
					FParticle3D.setColors(FGradientColor.colors, FGradientColor.ratios);
					break;
				}
				case FGradientAlpha:
				{
					FParticle3D.setAlphas(FGradientAlpha.alphas, FGradientAlpha.ratios);
					break;
				}
			}
		}
		
		private function onUpdateNum(evt:Event):void
		{
			var tar_num:NumericStepper = evt.currentTarget as NumericStepper;
			switch(tar_num)
			{
				case FEnergyXNum:
				{
					FParticle3D.energy = new Vector3D(tar_num.value, FParticle3D.energy.y, FParticle3D.energy.z);
					break;
				}
				case FEnergyYNum:
				{
					FParticle3D.energy = new Vector3D(FParticle3D.energy.x, tar_num.value, FParticle3D.energy.z);// = tar_num.value;
					break;
				}
				case FEnergyZNum:
				{
					FParticle3D.energy = new Vector3D(FParticle3D.energy.x, FParticle3D.energy.y, tar_num.value);// = tar_num.value;
					break;
				}
				case FNumberNum:
				{
					FParticle3D.numParticles = tar_num.value;
					break;
				}
				case FDurationNum:
				{
					FParticle3D.duration = tar_num.value;
					break;
				}
				case FLoopsNum:
				{
					FParticle3D.loops = tar_num.value;
					break;
				}
				case FDelayNum:
				{
					FParticle3D.delay = tar_num.value;
					break;
				}
				case FShotsNum:
				{
					FParticle3D.shots = tar_num.value;
					break;
				}
				case FVelocityXNum:
				{
					FParticle3D.velocity = new Vector3D(tar_num.value, FParticle3D.velocity.y, FParticle3D.velocity.z);
					break;
				}
				case FVelocityYNum:
				{
					FParticle3D.velocity = new Vector3D(FParticle3D.velocity.x, tar_num.value, FParticle3D.velocity.z);
					break;
				}
				case FVelocityZNum:
				{
					FParticle3D.velocity = new Vector3D(FParticle3D.velocity.x, FParticle3D.velocity.y, tar_num.value);
					break;
				}
				case FGravityXNum:
				{
					FParticle3D.gravity = new Vector3D(tar_num.value, FParticle3D.gravity.y, FParticle3D.gravity.z);
					break;
				}
				case FGravityYNum:
				{
					FParticle3D.gravity = new Vector3D(FParticle3D.gravity.x, tar_num.value, FParticle3D.gravity.z);
					break;
				}
				case FGravityZNum:
				{
					FParticle3D.gravity = new Vector3D(FParticle3D.gravity.x, FParticle3D.gravity.y, tar_num.value);
					break;
				}
				case FRandomVelocityNum:
				{
					FParticle3D.randomVelocity = tar_num.value;
					break;
				}
				case FGravityPowerNum:
				{
					FParticle3D.gravityPower = tar_num.value;
					break;
				}
				case FStartSizeNum:
				{
					FParticle3D.startSize = new Point(tar_num.value, tar_num.value);
					break;
				}
				case FEndSizeNum:
				{
					FParticle3D.endSize = new Point(tar_num.value, tar_num.value);
					break;
				}
				case FRandomScaleNum:
				{
					FParticle3D.randomScale = tar_num.value;
					break;
				}
				case FSpinNum:
				{
					FParticle3D.spin = tar_num.value;
					break;
				}
				case FRandomSpinNum:
				{
					FParticle3D.randomSpin = tar_num.value;
					break;
				}
				case FTintColor:
				{
					/*
					var tintColor:uint = tar_num.value;
					FParticle3D.setTint((tintColor >> 24) & 0xff, (tintColor >> 16) & 0xff, (tintColor >> 8) & 0xff, tintColor & 0xff);
					*/
					break;
				}
			}
		}
		
		private function onUpdateMode(evt:Event):void
		{
			var tar_mode:ComboBox = evt.currentTarget as ComboBox;
			switch(tar_mode)
			{
				case FBlendMode:
				{
					FParticle3D.blendMode = tar_mode.selectedIndex;
					break;
				}
					
				case FSortMode:
				{
					FParticle3D.sortMode = tar_mode.selectedIndex;
					break;
				}
					
				case FAreaMode:
				{
					var area_cls:Class = AREA_CLS_L[tar_mode.selectedIndex];
					FParticle3D.area = new area_cls();
					break;
				}
					
			}
		}
		
		private function onUpdateCheckbox(evt:Event):void
		{
			var tar_checkbox:CheckBox = evt.currentTarget as CheckBox;
			switch(tar_checkbox)
			{
				case FHemisphere:
				{
					FParticle3D.hemisphere = tar_checkbox.selected;
					break;
				}
					
				case FReverse:
				{
					FParticle3D.reverse = tar_checkbox.selected;
					break;
				}
					
				case FWorldPos:
				{
					FParticle3D.worldPositions = tar_checkbox.selected;
					break;
				}
					
				case FWorldVel:
				{
					FParticle3D.worldVelocities = tar_checkbox.selected;
					break;
				}
					
				case FUseRndGradientColor:
				{
					FParticle3D.useRandomColors = tar_checkbox.selected;
					break;
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
			FParticle3D = value as Particles3DExt;
			
			FBlendMode.selectedIndex = FParticle3D.blendMode;
			FSortMode.selectedIndex = FParticle3D.sortMode;
			
			FAreaMode.selectedIndex = AREA_CLS_L.indexOf(FParticle3D.area["constructor"]);
			
			var vec3D:Vector3D;
			
			vec3D = FParticle3D.area.GeneratePos();
			FAreaXNum.value = vec3D.x;
			FAreaYNum.value = vec3D.y;
			FAreaZNum.value = vec3D.z;
			
			vec3D = FParticle3D.energy;
			FEnergyXNum.value = vec3D.x;
			FEnergyYNum.value = vec3D.y;
			FEnergyZNum.value = vec3D.z;
			
			FHemisphere.selected = FParticle3D.hemisphere;
			FReverse.selected = FParticle3D.reverse;
			FWorldPos.selected = FParticle3D.worldPositions;
			FWorldVel.selected = FParticle3D.worldVelocities;
			
			FNumberNum.value = FParticle3D.numParticles;
			FDurationNum.value = FParticle3D.duration;
			FLoopsNum.value = FParticle3D.loops;
			FDelayNum.value = FParticle3D.delay;
			FShotsNum.value = FParticle3D.shots;
			
			vec3D = FParticle3D.velocity;
			FVelocityXNum.value = vec3D.x;
			FVelocityYNum.value = vec3D.y;
			FVelocityZNum.value = vec3D.z;
			
			vec3D = FParticle3D.gravity;
			FGravityXNum.value = vec3D.x;
			FGravityYNum.value = vec3D.y;
			FGravityZNum.value = vec3D.z;
			
			FRandomVelocityNum.value = FParticle3D.randomVelocity;
			FGravityPowerNum.value = FParticle3D.gravityPower;
			
			FStartSizeNum.value = FParticle3D.startSize.x;
			FEndSizeNum.value = FParticle3D.endSize.x;
			FRandomScaleNum.value = FParticle3D.randomScale;
			
			FSpinNum.value = FParticle3D.spin;
			FRandomSpinNum.value = FParticle3D.randomSpin;
			
			FUseRndGradientColor.selected = FParticle3D.useRandomColors;
			
			FGradientColor.setColors(FParticle3D.colors, FParticle3D.alphas, FParticle3D.colorRatios);
			FGradientAlpha.setColors(FParticle3D.colors, FParticle3D.alphas, FParticle3D.colorRatios);
			
			var colorVec:Vector.<Number> = FParticle3D.tint;
			FTintColor.text = uint(uint(colorVec[0] * 255 << 24) + uint(colorVec[1] * 255 << 16) + uint(colorVec[2] * 255 << 8) + uint(colorVec[3] * 255)).toString(16);
//			FTintColor.value = uint(colorVec[0] * 255 << 16) + uint(colorVec[1] * 255 << 8) + int(colorVec[2] * 255);
			
			draw();
		}
	}
}