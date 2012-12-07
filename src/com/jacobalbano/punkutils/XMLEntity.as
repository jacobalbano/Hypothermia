package com.jacobalbano.punkutils 
{
	import net.flashpunk.Entity;
	
	/**
	 * ...
	 * @author Jacob Albano
	 */
	public class XMLEntity extends Entity 
	{
		
		public function XMLEntity() 
		{
			super();
		}
		
		public function load(entity:XML):void
		{
			for each (var attribute:XML in entity.attributes()) 
			{
				//	Explicit conversion to string is necessary here, for some reason.
				var name:String = attribute.name();
					
				try
				{
					this[name] = (entity.@[name] == "True" || entity.@[name] == "False") ? entity.@[name] == "True" : entity.@[name];
				}
				catch (e:ReferenceError)
				{
					//var re:RegExp = /\[.*:[0-9]+\]/;
					//if (!re.test(e.getStackTrace()))
					//{
						//return;
					//}
					//
					//	Couldn't create the property. No big deal; just log it and keep moving
					//var s:String = e.getStackTrace().split("\n")[0];
					//trace(s.substring(s.lastIndexOf(": ") + 2));
					continue;
				}
			}
		}
		
	}

}