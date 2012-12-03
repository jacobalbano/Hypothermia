package com.jacobalbano.cold 
{
	import com.jacobalbano.punkutils.XMLEntity;
	import net.flashpunk.FP;
	
	/**
	 * @author Jake Albano
	 */
	public class Climate extends XMLEntity 
	{
		public var temperature:int;
		private var bodyTemp:Number;
		private var delay:int;
		
		private static const IDEAL_BODY_TEMPERATURE:int = 98;
		private static const MIN_BODY_TEMPERATURE:int = 70;
		private static const MIN_NEUTRAL_CLIMATE:int = 50;
		
		public function Climate() 
		{
			bodyTemp = IDEAL_BODY_TEMPERATURE;
		}
		
		override public function removed():void 
		{
			super.removed();
		}
		
		override public function added():void 
		{
			super.added();
			
			var all:Array = [];
			world.getClass(ClimateModifier, all);
			
			if (all.length > 0)
			{
				temperature = 0;
			
				for each (var item:ClimateModifier in all) 
				{
					temperature += item.temperature;
					item.onAdded(this);
				}
			}
			
			trace(temperature);
		}
		
		override public function update():void 
		{
			super.update();
			
			const seconds:int = 5;
			
			if (++delay > FP.frameRate * seconds)
			{
				if (temperature < MIN_NEUTRAL_CLIMATE)
				{
					bodyTemp -= (MIN_NEUTRAL_CLIMATE / temperature) * 0.75;
				}
				
				delay = 0;
				
				if (bodyTemp < MIN_BODY_TEMPERATURE)
				{
					trace("you are dead");
				}
			}
		}
		
	}

}