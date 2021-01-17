import openfl.Assets;
import net.hxpunk.graphics.Image;
import net.hxpunk.Entity;
import flash.errors.Error;
import com.jacobalbano.cold.*;
import com.jacobalbano.punkutils.*;
import com.thaumaturgistgames.slang.Memory;
import com.thaumaturgistgames.slang.SlangInterpreter;
import com.thaumaturgistgames.slang.Stdlib;
import net.hxpunk.Engine;
import net.hxpunk.HP;
import net.hxpunk.Tween;
import net.hxpunk.tweens.misc.VarTween;
import net.hxpunk.utils.Ease;

/**
	 * @author Jacob Albano
	 */
class FPGame extends Engine
{
    private var currentWorld : String;
    private var lastWorld : String;
    private var world : OgmoWorld;
    private var inventory : Inventory;
    private var climate : Climate;
    private var pool : Map<String, WorldItem>;
    private var sleep : Sleep;
    public static var slang(default, never):SlangInterpreter = new SlangInterpreter();

    public function new()
    {
        super(800, 400);
        lastWorld = "";
        currentWorld = "";
        inventory = new Inventory();
        climate = new Climate();
        HP.screen.smoothing = true;
        pool = new Map();
    }

    override public function init() : Void
    {
        super.init();
        HP.console.enable();
        
        sleep = new Sleep();
        
        world = new OgmoWorld();
        HP.world = world;
        
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
        
        
        slang.addFunction("world", loadWorld, [String], this, "Load a world from an Ogmo level");
        
        slang.addFunction("playWorldSound", playWorldSound, [String], this, "Play a sound effect that was added to the world");
        
        slang.addFunction("hasInvItem", inventory.hasItem, [String], inventory, "Check if an item exists in the inventory");
        slang.addFunction("addInvItem", inventory.addItem, [String], inventory, "Add an item to the inventory");
        slang.addFunction("remInvItem", inventory.removeItem, [String], inventory, "Remove an item from the inventory");
        slang.addFunction("resetInv", inventory.reset, [], inventory, "Reset the inventory");
        
        slang.addFunction("remWorldReaction", remWorldReaction, [String], this, "Remove a reaction trigger from the world");
        
        slang.addFunction("remClimateMod", remClimateMod, [String], this, "Remove a climate modifier from the world");
        slang.addFunction("getTemp", getTemp, [], this, "Get the current temperature");
        slang.addFunction("resetTemp", climate.reset, [], climate, "Get the current temperature");
        
        slang.addFunction("remWorldItem", remWorldItem, [String, Bool], this, "Remove an item from the world");
        slang.addFunction("restoreWorldItem", restoreWorldItem, [String, Bool], this, "Restore a previously removed item to the world");
        
        slang.addFunction("remParticles", remParticles, [String], this, "Remove a particle emitter from the world");
        
        slang.addFunction("remDecal", remDecal, [String], this, "Remove a decal type from the world");
        
        slang.addFunction("stopAmbiance", stopAmbiance, [String], this, "Stop an ambient sound from playing");
        
        slang.addFunction("sleep", goToSleep, [], this, "Go to sleep");
        slang.addFunction("wake", sleep.stop, [], sleep, "Wake up");
        
        slang.importModule(new Stdlib());
        slang.importModule(new Memory());
        
        //	TODO: Revert this
        loadWorld("start");
        
        climate.onDeath = function() : Void
        {
            sleep.start();
        };

        sleep.onComplete = function() : Void
        {
            inventory.mouseItem = "";
            inventory.close();
            slang.doLine("world end");
        };
    }
    
    private function remDecal(name : String) : Void
    {
        var all : Array<Entity> = [];
        world.getClass(Decal, all);
        
        for (item in all)
        {
            var decal:Decal = cast item;
            if (decal.source == name)
            {
                world.remove(decal);
            }
        }
    }
    
    private function goToSleep() : Void
    {
        inventory.mouseItem = "";
        sleep.start();
    }
    
    private function getTemp() : Int
    {
        return climate.temperature;
    }
    
    private function remClimateMod(name : String) : Void
    {
        var all : Array<Entity> = [];
        world.getClass(ClimateModifier, all);
        
        for (item in all)
        {
            var mod:ClimateModifier = cast item;
            if (item.name == name)
            {
                mod.remove();
                world.remove(mod);
            }
        }
    }
    
    private function playWorldSound(type : String) : Void
    {
        var all : Array<Entity> = [];
        world.getClass(WorldSound, all);
        
        for (item in all)
        {
            var worldSound:WorldSound = cast item;
            if (worldSound.typeName == type)
            {
                worldSound.play();
            }
        }
    }
    
    private function remWorldReaction(itemName : String) : Void
    {
        var list : Array<Entity> = [];
        world.getClass(WorldReaction, list);
        
        for (item in list)
        {
            var reaction:WorldReaction = cast item;
            if (reaction.match == itemName)
            {
                world.remove(reaction);
            }
        }
    }
    
    private function remParticles(name : String) : Void
    {
        var list : Array<Entity> = [];
        world.getClass(ParticleEmitter, list);
        
        for (item in list)
        {
            var emitter:ParticleEmitter = cast item;
            if (emitter.particleType == name)
            {
                world.remove(emitter);
            }
        }
    }
    
    private function stopAmbiance(name : String) : Void
    {
        var list : Array<Entity> = [];
        world.getClass(Ambiance, list);
        
        for (item in list)
        {
            var ambiance:Ambiance = cast item;
            if (ambiance.source == name)
            {
                world.remove(item);
            }
        }
    }
    
    private function remWorldItem(worldItem : String, instant : Bool) : Void
    {
        var list : Array<Entity> = [];
        world.getClass(WorldItem, list);
        
        for (item in list)
        {
            var wItem:WorldItem = cast item;
            if (wItem.typeName == worldItem)
            {
                function realRemoveWorldItem() : Void
                {
                    world.remove(item);
                    pool.set(worldItem, wItem);
                }

                if (instant)
                {
                    realRemoveWorldItem();
                    return;
                }
                
                var tween : VarTween = new VarTween(realRemoveWorldItem, TweenType.ONESHOT);
                tween.tween(item.graphic, "alpha", 0, 1, Ease.backOut);
                world.addTween(tween, true);
                return;
            }
        }
    }
    
    private function restoreWorldItem(worldItem : String, instant : Bool) : Void
    {
        var item = pool.get(worldItem);
        
        if (item == null)
        {
            return;
        }
        
        world.add(item);
        
        var img:Image = cast item.graphic;
        if (instant)
        {
            img.alpha = 1;
        }
        else
        {
            img.alpha = 0;
            var tween : VarTween = new VarTween(null, TweenType.ONESHOT);
            tween.tween(item.graphic, "alpha", 1, 1, Ease.backOut);
            world.addTween(tween, true);
        }
    }
    
    private function loadWorld(name : String) : Void
    {
        var path = 'worlds/${name}/map.oel';
        if (!Assets.exists(path))
            return;
        
        var xml = Xml.parse(Assets.getText(path));
        
        if (name != currentWorld)
        {
            lastWorld = currentWorld;
        }
        
        currentWorld = name;
        
        if (currentWorld == "")
        {
            return;
        }
        
        world.buildWorld(path);
        world.add(new Transition());
        world.add(inventory);
        world.add(climate);
        world.add(new ScriptTick(slang, 'worlds/${name}/script.xml'));
        world.add(sleep);
    }
}

