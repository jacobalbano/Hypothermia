package com.jacobalbano.punkutils 
{
	import com.thaumaturgistgames.slang.SlangInterpreter;
	import flash.utils.Dictionary;
	import net.flashpunk.Entity;
	import com.thaumaturgistgames.flakit.Library;
	import net.flashpunk.FP;
	
	/**
	 * @author Jacob Albano
	 */
	public class ScriptTick extends Entity
	{
		private var launch:String, tick:String;
		private var messages:Dictionary;
		private var slang:SlangInterpreter;
		private var delay:int;
		private var failed:Boolean;
		
		public function ScriptTick(slang:SlangInterpreter, script:String) 
		{
			try
			{
				var xml:XML = Library.getXML(script);
			}
			catch (e:Error)
			{
				trace("Failed to load script file \"", script, "\"");
				failed = true;
				return;
			}
			
			delay = 0;
			
			this.slang = slang;
			launch = xml.launch || "";
			tick = xml.tick || "";
			
			messages = new Dictionary;
			for each (var message:XML in xml.message.children())
			{
				messages[message.name()] = new String(message);
			}
			
		}
		
		override public function added():void 
		{
			super.added();
			
			if (failed)
			{
				world.remove(this);
				return;
			}
			
			slang.doLine(launch);
		}
		
		override public function update():void 
		{
			super.update();
			
			if (++delay >= FP.frameRate / 4)
			{
				delay = 0;
				slang.doLine(tick);
			}
		}
		
		public function onMessage(message:String):void
		{
			var m:String = messages[message]
			if (m)
			{
				slang.doLine(m);
			}
		}
		
	}

}