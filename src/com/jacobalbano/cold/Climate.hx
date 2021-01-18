package com.jacobalbano.cold;

import haxe.Constraints.Function;
import com.jacobalbano.punkutils.XMLEntity;
import haxepunk.HXP;

/**
	 * @author Jake Albano
	 */
class Climate extends XMLEntity
{
    public var temperature : Int;
    public var onDeath : Function;
    private var bodyTemp : Float;
    private var delay : Int = 0;
    
    private static inline var IDEAL_BODY_TEMPERATURE : Int = 98;
    private static inline var MIN_BODY_TEMPERATURE : Int = 70;
    private static inline var MIN_NEUTRAL_CLIMATE : Int = 50;
    private var heartbeat : Heartbeat;
    
    public function new()
    {
        super();
        heartbeat = new Heartbeat();
        reset();
    }
    
    override public function removed() : Void
    {
        super.removed();
        world.remove(heartbeat);
    }
    
    override public function added() : Void
    {
        super.added();
        world.add(heartbeat);
        
        var all = [];
        world.getClass(ClimateModifier, all);
        
        if (all.length > 0)
        {
            temperature = 0;
            
            for (item in all)
            {
                var mod:ClimateModifier = cast item;
                temperature += mod.temperature;
                mod.onAdded(this);
            }
        }
    }
    
    override public function update() : Void
    {
        super.update();
        
        var seconds : Int = 10;
        
        if (++delay > HXP.frameRate * seconds)
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
    
    public function reset() : Void
    {
        bodyTemp = IDEAL_BODY_TEMPERATURE;
        heartbeat.stop();
    }
}

