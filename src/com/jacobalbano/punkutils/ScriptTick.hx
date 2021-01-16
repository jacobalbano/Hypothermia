package com.jacobalbano.punkutils;

import openfl.Assets;
import flash.errors.Error;
import com.thaumaturgistgames.slang.SlangInterpreter;
import net.hxpunk.Entity;
import net.hxpunk.HP;

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
        }
        
        var xml = Xml.parse(Assets.getText(script));
        for (e in xml.elementsNamed("launch"))
        {
            launch = e.nodeValue;
            break;
        }
        
        for (e in xml.elementsNamed("tick"))
        {
            tick = e.nodeValue;
            break;
        }
        
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
        
        if (++delay >= HP.frameRate / 4)
        {
            delay = 0;
            slang.doLine(tick);
        }
    }
}

