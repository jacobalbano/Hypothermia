import haxepunk.Graphic.ImageType;
import openfl.display.BitmapData;
import haxepunk.debug.Console;
import haxepunk.World;
import openfl.Assets;
import haxepunk.graphics.Image;
import haxepunk.Entity;
import flash.errors.Error;
import com.jacobalbano.cold.*;
import com.jacobalbano.punkutils.*;
import com.thaumaturgistgames.slang.Memory;
import com.thaumaturgistgames.slang.SlangInterpreter;
import com.thaumaturgistgames.slang.Stdlib;
import haxepunk.Engine;
import haxepunk.HXP;
import haxepunk.Tween;
import haxepunk.tweens.misc.VarTween;
import haxepunk.utils.Ease;

/**
	 * @author Jacob Albano
	 */
class FPGame extends Engine
{
    private var inventory : Inventory;
    private var climate : Climate;
    private var pool : Map<String, WorldItem>;
    private var sleep : Sleep;
    private var transition:Entity;
    private var loader:OgmoLoader = new OgmoLoader();
    public static var slang(default, never):SlangInterpreter = new SlangInterpreter();

    public static function main() { new FPGame(); }

    public function new()
    {
        super(800, 400, 60, true);
    }

    override public function init() : Void
    {
        super.init();
        Console.enable();

        inventory = new Inventory();
        climate = new Climate();
        pool = new Map();

        var fadeImage = Image.createRect(HXP.width, HXP.height, 0x333333);
        fadeImage.scrollX = fadeImage.scrollY = 0;
        transition = new Entity(0, 0, fadeImage);
        transition.layer = -100000;
        
        sleep = new Sleep();
        
        climate.onDeath = sleep.start;
        sleep.onComplete = () ->  {
            inventory.mouseItem = "";
            inventory.close();
            slang.doLine("world end");
        };
        
        loader.addClass("CameraPan", CameraPan);
        loader.addClass("Background", Background);
        loader.addClass("Hotspot", Hotspot);
        loader.addClass("ParticleEmitter", ParticleEmitter);
        loader.addClass("Ambiance", Ambiance);
        loader.addClass("WorldItem", WorldItem);
        loader.addClass("InventoryItem", InventoryItem);
        loader.addClass("Decal", Decal);
        loader.addClass("WorldReaction", WorldReaction);
        loader.addClass("WorldSound", WorldSound);
        loader.addClass("ClimateModifier", ClimateModifier);
        
        setupSlang();
        
        //	TODO: Revert this
        loadWorld("start");
    }
    
    private var loading:Bool = false;
    private function loadWorld(name : String) : Void
    {
        if (loading) return;
        var path = 'worlds/${name}/map.oel';
        if (!Assets.exists(path))
            return;
        
        loading = true;
        var persistant:Array<Entity> = [inventory, climate, sleep, transition];
        var xml = Xml.parse(Assets.getText(path));
        var newWorld = loader.buildWorld(path);
        var oldWorld = world;

        var fadeOut = new VarTween(TweenType.OneShot);
        fadeOut.tween(transition.graphic, "alpha", 1, 0.5);
        fadeOut.onComplete.bind(() -> {
            oldWorld.removeList(persistant);
            oldWorld.updateLists(true);

            newWorld.addList(persistant);
            newWorld.updateLists(true);
            newWorld.add(new ScriptTick(slang, 'worlds/${name}/script.xml'));

            var fadeIn = new VarTween(TweenType.OneShot);
            fadeIn.tween(transition.graphic, "alpha", 0, 0.5);
            fadeIn.onComplete.bind(() -> loading = false );
            newWorld.addTween(fadeIn, true);
            
            world = newWorld;
        });
        

        oldWorld.addTween(fadeOut, true);
    }

    private function setupSlang()
    {
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
    }
    
    private function remDecal(name : String) : Void
    {
        var all : Array<Decal> = [];
        world.getClass(Decal, all);
        
        for (item in all)
        {
            if (item.source == name)
            {
                world.remove(item);
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
        var all : Array<ClimateModifier> = [];
        world.getClass(ClimateModifier, all);
        for (item in all.filter(x -> x.name == name))
        {
            item.remove();
            world.remove(item);
        }
    }
    
    private function playWorldSound(type : String) : Void
    {
        var all : Array<WorldSound> = [];
        world.getClass(WorldSound, all);
        
        for (item in all.filter(x -> x.typeName == type))
            item.play();
    }
    
    private function remWorldReaction(itemName : String) : Void
    {
        var list : Array<WorldReaction> = [];
        world.getClass(WorldReaction, list);
        
        for (item in list.filter(x -> x.match == itemName))
            world.remove(item);
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
        var list : Array<Ambiance> = [];
        world.getClass(Ambiance, list);
        
        for (item in list.filter(x -> x.source == name))
            world.remove(item);
    }
    
    private function remWorldItem(worldItem : String, instant : Bool) : Void
    {
        var list : Array<WorldItem> = [];
        world.getClass(WorldItem, list);
        
        for (item in list.filter(x -> x.typeName == worldItem))
        {
            function realRemoveWorldItem() : Void
            {
                world.remove(item);
                pool.set(worldItem, item);
            }

            if (instant)
                realRemoveWorldItem();
            else
            {
                var tween : VarTween = new VarTween(TweenType.OneShot);
                tween.onComplete.bind(realRemoveWorldItem);
                tween.tween(item.graphic, "alpha", 0, 1, Ease.backOut);
                world.addTween(tween, true);
            }
        }
    }
    
    private function restoreWorldItem(worldItem : String, instant : Bool) : Void
    {
        var item = pool.get(worldItem);
        if (item == null) return;
        
        world.add(item);
        
        var img:Image = cast item.graphic;
        if (instant)
            img.alpha = 1;
        else
        {
            img.alpha = 0;
            var tween : VarTween = new VarTween(TweenType.OneShot);
            tween.tween(item.graphic, "alpha", 1, 1, Ease.backOut);
            world.addTween(tween, true);
        }
    }
}

