package com.jacobalbano.cold;

import com.jacobalbano.punkutils.XMLEntity;
import haxepunk.graphics.emitter.Emitter;
import haxepunk.HXP;

/**
	 * @author Jake Albano
	 */
class ParticleEmitter extends XMLEntity
{
    private var lastTime : Float;
    public var particleType : String;
    public var vary : Float;
    public var max : Int;
    public var emitter : Emitter;
    public var angle : Int;
    public var distance : Float;
    public var duration : Float;
    public var angleRange : Float;
    public var distanceRange : Float;
    public var durationRange : Float;
    public var fadeOut : Bool;
    
    public function new()
    {
        super();
        lastTime = 0;
    }
    
    override public function load(entity : Xml) : Void
    {
        super.load(entity);

        emitter = new Emitter('art/particles/${particleType}.png');
        graphic = emitter;
        
        emitter.relative = false;
        emitter.newType(particleType);
        emitter.setMotion(particleType, -angle, distance, duration, angleRange, distanceRange, durationRange);
        emitter.setAlpha(particleType, 1, (fadeOut) ? 0 : 1);
        for (x in 0...100)
        {
            update();
            emitter.update();
        }
    }
    
    override public function update() : Void
    {
        super.update();
        
        emitter.emit(particleType, x, y);
    }
}

