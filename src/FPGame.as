package  
{
	import com.jacobalbano.cold.Ambiance;
	import com.jacobalbano.cold.Background;
	import com.jacobalbano.cold.Climate;
	import com.jacobalbano.cold.ClimateModifier;
	import com.jacobalbano.cold.Decal;
	import com.jacobalbano.cold.Hotspot;
	import com.jacobalbano.cold.Inventory;
	import com.jacobalbano.cold.InventoryItem;
	import com.jacobalbano.cold.ParticleEmitter;
	import com.jacobalbano.cold.WorldItem;
	import com.jacobalbano.cold.WorldReaction;
	import com.jacobalbano.cold.WorldSound;
	import com.jacobalbano.punkutils.CameraPan;
	import com.jacobalbano.punkutils.OgmoWorld;
	import com.jacobalbano.punkutils.ScriptTick;
	import com.jacobalbano.punkutils.Transition;
	import com.thaumaturgistgames.flakit.Library;
	import com.thaumaturgistgames.slang.Memory;
	import com.thaumaturgistgames.slang.Stdlib;
	import net.flashpunk.Engine;
	import net.flashpunk.FP;
	import net.flashpunk.Sfx;
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
		
		public function FPGame(width:uint, height:uint) 
		{
			super(width, height);
			lastWorld = "";
			currentWorld = "";
			inventory = new Inventory();
			climate = new Climate();
			FP.screen.smoothing = true;
		}
		
		override public function init():void 
		{
			super.init();
			
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
			Game.instance.console.slang.addFunction("lastWorld", loadLastWorld, [], this, "Load the previous world");
			Game.instance.console.slang.addFunction("worlds", listWorlds, [], this, "Load a world from an Ogmo level");
			
			Game.instance.console.slang.addFunction("playWorldSound", playWorldSound, [String], this, "Play a sound effect that was added to the world");
			
			Game.instance.console.slang.addFunction("hasInvItem", inventory.hasItem, [String], inventory, "Check if an item exists in the inventory");
			Game.instance.console.slang.addFunction("addInvItem", inventory.addItem, [String], inventory, "Add an item to the inventory");
			Game.instance.console.slang.addFunction("remInvItem", inventory.removeItem, [String], inventory, "Remove an item from the inventory");
			
			Game.instance.console.slang.addFunction("remWorldReaction", remWorldReaction, [String], this, "Remove a reaction trigger from the world");
			
			Game.instance.console.slang.addFunction("remClimateMod", remClimateMod, [String], this, "Remove a climate modifier from the world");
			Game.instance.console.slang.addFunction("getTemp", getTemp, [], this, "Get the current temperature");
			
			Game.instance.console.slang.addFunction("remWorldItem", remWorldItem, [String, Boolean], this, "Remove an item from the world");
			
			Game.instance.console.slang.importModule(new Stdlib);
			Game.instance.console.slang.importModule(new Memory);
			
			Game.instance.onReload = function():void { loadWorld(currentWorld); };
			
			//	TODO: Revert this
			loadWorld("start");
			
			//loadWorld("cabin");
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
		
		private function loadLastWorld():void 
		{
			loadWorld(lastWorld);
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
					return;
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
					}
					
					var tween:VarTween = new VarTween(realRemoveWorldItem, Tween.ONESHOT);
					tween.tween(item.graphic, "alpha", 0, 1, Ease.backOut);
					world.addTween(tween, true);
					return;
				}
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
		}
		
	}

}