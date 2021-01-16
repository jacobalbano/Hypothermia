package com.jacobalbano.cold;

import com.jacobalbano.punkutils.XMLEntity;
import net.hxpunk.Sfx;

/**
	 * ...
	 * @author Jake Albano
	 */
class WorldSound extends XMLEntity
{
    public var source : String;
    public var typeName : String;
    private var sound : Sfx;
    
    public function new()
    {
        super();
    }
    
    override public function added() : Void
    {
        super.added();
        
        sound = new Sfx("sounds/" + source);
    }
    
    public function play() : Void
    {
        if (!sound.isPlaying)
        {
            sound.play();
        }
    }
}

