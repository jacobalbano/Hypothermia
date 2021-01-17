package com.jacobalbano.punkutils;

import haxe.xml.Access;
import openfl.Assets;
import flash.errors.Error;
import com.thaumaturgistgames.slang.SlangInterpreter;
import haxepunk.Entity;
import haxepunk.HXP;

/**
	 * @author Jacob Albano
	 */
class ScriptTick extends Entity
{
    private var launch : String = "";
    private var tick : String = "";
    private var slang : SlangInterpreter;
    private var delay : Int;
    private var failed : Bool;
    
    public function new(slang : SlangInterpreter, script : String)
    {
        super();
        if (!Assets.exists(script))
        {
            trace("Failed to load script file \"", script, "\"");
            failed = true;
            return;
        }
        
        var xml = new Access(Xml.parse(Assets.getText(script)));
        var maybeLaunch = xml.node.script.node.launch.innerData;
        if (maybeLaunch != null)
            launch = maybeLaunch;
        
        var maybeTick = xml.node.script.node.tick.innerData;
        if (maybeTick != null)
            tick = maybeTick;
        
        delay = 0;
        this.slang = slang;
    }
    
    override public function added() : Void
    {
        super.added();
        
        if (failed)
        {
            world.remove(this);
            return;
        }
        
        slang.doLine(launch);
    }
    
    override public function update() : Void
    {
        super.update();
        
        if (++delay >= HXP.frameRate / 4)
        {
            delay = 0;
            slang.doLine(tick);
        }
    }
}

