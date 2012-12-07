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
		public var onDeath:Function;
		private var bodyTemp:Number;
		private var delay:int;
		
		private static const IDEAL_BODY_TEMPERATURE:int = 98;
		private static const MIN_BODY_TEMPERATURE:int = 70;
		private static const MIN_NEUTRAL_CLIMATE:int = 50;
		private var heartbeat:Heartbeat;
		
		public function Climate() 
		{
			heartbeat = new Heartbeat;
			reset();
		}
		
		override public function removed():void 
		{
			super.removed();
			world.remove(heartbeat);
		}
		
		override public function added():void 
		{
			super.added();
			world.add(heartbeat);
			
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
		}
		
		override public function update():void 
		{
			super.update();
			
			const seconds:int = 10;
			
			if (++delay > FP.frameRate * seconds)
			{
				if (temperature < MIN_NEUTRAL_CLIMATE)
				{
					bodyTemp -= (MIN_NEUTRAL_CLIMATE / temperature) * 0.75;
				}
				else
				{
					bodyTemp += (MIN_NEUTRAL_CLIMATE / temperature) * 0.75;
					bodyTemp = Math.min(bodyTemp, IDEAL_BODY_TEMPERATURE);
				}
				
				delay = 0;
			}
			
			
			if (bodyTemp - MIN_BODY_TEMPERATURE <= 0)
			{
				heartbeat.stop();
				
				if (onDeath != null)
				{
					onDeath();
				}
				
				return;
			}
			
			if (bodyTemp - MIN_BODY_TEMPERATURE < 10)
			{
				heartbeat.fast();
				return;
			}
			
			if (bodyTemp - MIN_BODY_TEMPERATURE < 20)
			{
				heartbeat.slow();
				return;
			}
			
		}
		
		public function reset():void 
		{
			bodyTemp = IDEAL_BODY_TEMPERATURE;
			heartbeat.stop();
		}
		
	}

}