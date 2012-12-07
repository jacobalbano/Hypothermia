package  
{
	import com.jacobalbano.cold.*;
	import com.jacobalbano.punkutils.*;
	import com.thaumaturgistgames.flakit.Library;
	import com.thaumaturgistgames.slang.Memory;
	import com.thaumaturgistgames.slang.SlangInterpreter;
	import com.thaumaturgistgames.slang.Stdlib;
	import flash.utils.Dictionary;
	import net.flashpunk.Engine;
	import net.flashpunk.FP;
	import net.flashpunk.Tween;
	import net.flashpunk.tweens.misc.VarTween;
	import net.flashpunk.utils.Ease;
	
	/**
	 * @author Jacob Albano
	 */
	public class FPGame extends Engine 
	{
		private var currentWorld:String;
		private var lastWorld:String;
		private var world:OgmoWorld;
		private var inventory:Inventory;
		private var climate:Climate;
		private var pool:Dictionary;
		private var sleep:Sleep;
		
		public function FPGame(width:uint, height:uint) 
		{
			super(width, height);
			lastWorld = "";
			currentWorld = "";
			inventory = new Inventory();
			climate = new Climate();
			FP.screen.smoothing = true;
			pool = new Dictionary;
		}
		
		override public function init():void 
		{
			super.init();
			
			sleep = new Sleep();
			
			world = new OgmoWorld();
			FP.world = world;
			
			world.addClass("CameraPan", CameraPan);
			world.addClass("Background", Background);
			world.addClass("Hotspot", Hotspot);
			world.addClass("ParticleEmitter", ParticleEmitter);
			world.addClass("Ambiance", Ambiance);
			world.addClass("WorldItem", WorldItem);
			world.addClass("InventoryItem", InventoryItem);
			world.addClass("Decal", Decal);
			world.addClass("WorldReaction", WorldReaction);
			world.addClass("WorldSound", WorldSound);
			world.addClass("ClimateModifier", ClimateModifier);
			
			
			Game.instance.console.slang.addFunction("world", loadWorld, [String], this, "Load a world from an Ogmo level");
			Game.instance.console.slang.addFunction("worlds", listWorlds, [], this, "Load a world from an Ogmo level");
			
			Game.instance.console.slang.addFunction("playWorldSound", playWorldSound, [String], this, "Play a sound effect that was added to the world");
			
			Game.instance.console.slang.addFunction("hasInvItem", inventory.hasItem, [String], inventory, "Check if an item exists in the inventory");
			Game.instance.console.slang.addFunction("addInvItem", inventory.addItem, [String], inventory, "Add an item to the inventory");
			Game.instance.console.slang.addFunction("remInvItem", inventory.removeItem, [String], inventory, "Remove an item from the inventory");
			Game.instance.console.slang.addFunction("resetInv", inventory.reset, [], inventory, "Reset the inventory");
			
			Game.instance.console.slang.addFunction("remWorldReaction", remWorldReaction, [String], this, "Remove a reaction trigger from the world");
			
			Game.instance.console.slang.addFunction("remClimateMod", remClimateMod, [String], this, "Remove a climate modifier from the world");
			Game.instance.console.slang.addFunction("getTemp", getTemp, [], this, "Get the current temperature");
			Game.instance.console.slang.addFunction("resetTemp", climate.reset, [], climate, "Get the current temperature");
			
			Game.instance.console.slang.addFunction("remWorldItem", remWorldItem, [String, Boolean], this, "Remove an item from the world");
			Game.instance.console.slang.addFunction("restoreWorldItem", restoreWorldItem, [String, Boolean], this, "Restore a previously removed item to the world");
			
			Game.instance.console.slang.addFunction("remParticles", remParticles, [String], this, "Remove a particle emitter from the world");
			
			Game.instance.console.slang.addFunction("remDecal", remDecal, [String], this, "Remove a decal type from the world");
			
			Game.instance.console.slang.addFunction("stopAmbiance", stopAmbiance, [String], this, "Stop an ambient sound from playing");
			
			Game.instance.console.slang.addFunction("sleep", goToSleep, [], this, "Go to sleep");
			Game.instance.console.slang.addFunction("wake", sleep.stop, [], sleep, "Wake up");
			
			Game.instance.console.slang.importModule(new Stdlib);
			Game.instance.console.slang.importModule(new Memory);
			
			Game.instance.onReload = function():void { loadWorld(currentWorld); };
			
			//	TODO: Revert this
			//loadWorld("start");
			
			loadWorld("cabin");
			
			sleep.onComplete = function ():void { Game.instance.console.slang.doLine("world end"); };
			climate.onDeath = sleep.start;
		}
		
		private function remDecal(name:String):void 
		{
			var all:Array = [];
			world.getClass(Decal, all);
			
			for each (var item:Decal in all)
			{
				if (item.source == name)
				{
					world.remove(item);
				}
			}
		}
		
		private function goToSleep():void 
		{
			inventory.mouseItem = "";
			sleep.start();
		}
		
		private function getTemp():int
		{
			return climate.temperature;
		}
		
		private function remClimateMod(name:String):void 
		{
			var all:Array = [];
			world.getClass(ClimateModifier, all);
			
			for each (var item:ClimateModifier in all)
			{
				if (item.name == name)
				{
					item.remove();
					world.remove(item);
				}
			}
		}
		
		private function playWorldSound(type:String):void 
		{
			var all:Array = [];
			world.getClass(WorldSound, all);
			
			for each (var item:WorldSound in all) 
			{
				if (item.typeName == type)
				{
					item.play();
				}
			}
		}
		
		private function remWorldReaction(itemName:String):void 
		{
			var list:Array = [];
			world.getClass(WorldReaction, list);
			
			for each (var item:WorldReaction in list) 
			{
				if (item.match == itemName)
				{
					world.remove(item);
				}
			}
		}
		
		private function remParticles(name:String):void 
		{
			var list:Array = [];
			world.getClass(ParticleEmitter, list);
			
			for each (var item:ParticleEmitter in list) 
			{
				if (item.particleType == name)
				{
					world.remove(item);
				}
			}
		}
		
		private function stopAmbiance(name:String):void 
		{
			var list:Array = [];
			world.getClass(Ambiance, list);
			
			for each (var item:Ambiance in list) 
			{
				if (item.source == name)
				{
					world.remove(item);
				}
			}
		}
		
		private function listWorlds():void 
		{
			var lib:XML = Library.getXML("Library.xml");
			
			for each (var item:String in lib.xmls.children()) 
			{
				if (item.indexOf("map.oel") >= 0)
				{
					Game.instance.console.print(item.substring(0, item.lastIndexOf("/")));
				}
			}
		}
		
		private function remWorldItem(worldItem:String, instant:Boolean):void
		{
			var list:Array = [];
			world.getClass(WorldItem, list);
			
			for each (var item:WorldItem in list) 
			{
				if (item.typeName == worldItem)
				{
					if (instant)
					{
						realRemoveWorldItem();
						return;
					}
					
					function realRemoveWorldItem():void 
					{
						world.remove(item);
						pool[worldItem] = item;
					}
					
					var tween:VarTween = new VarTween(realRemoveWorldItem, Tween.ONESHOT);
					tween.tween(item.graphic, "alpha", 0, 1, Ease.backOut);
					world.addTween(tween, true);
					return;
				}
			}
		}
		
		private function restoreWorldItem(worldItem:String, instant:Boolean):void
		{
			var item:WorldItem = pool[worldItem];
			
			if (!item)
			{
				return;
			}
			
			world.add(item);
			
			if (instant)
			{
				(item.graphic as Image).alpha = 1;
			}
			else
			{
				(item.graphic as Image).alpha = 0;
				var tween:VarTween = new VarTween(null, Tween.ONESHOT);
				tween.tween(item.graphic, "alpha", 1, 1, Ease.backOut);
				world.addTween(tween, true);
			}
		}
		
		private function loadWorld(name:String):void 
		{
			try
			{
				Library.getXML("worlds." + name + ".map.oel");
			}
			catch (e:Error)
			{
				return;
			}
			
			if (name != currentWorld)
			{
				lastWorld = currentWorld;
			}
			
			currentWorld = name;
			
			if (currentWorld == "")
			{
				return;
			}
			
			world.buildWorld("worlds." + name + ".map.oel");
			world.add(new Transition);
			world.add(inventory);
			world.add(climate);
			world.add(new ScriptTick(Game.instance.console.slang, "worlds." + name + ".script.xml"));
			world.add(sleep);
		}
		
	}

}