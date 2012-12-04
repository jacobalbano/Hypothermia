package com.jacobalbano.cold 
{
	import com.jacobalbano.punkutils.XMLEntity;
	
	/**
	 * @author Jake Albano
	 */
	public class ClimateModifier extends XMLEntity
	{
		public var temperature:int;
		
		private var parent:Climate;
		
		public function ClimateModifier() 
		{
			
		}
		
		public function remove():void
		{
			parent.temperature -= temperature;
		}
		
		override public function removed():void 
		{
			super.removed();
		}
		
		public function onAdded(parent:Climate):void
		{
			this.parent = parent;
		}
		
	}

}