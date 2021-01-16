package com.jacobalbano.cold;

import com.jacobalbano.punkutils.XMLEntity;
import net.hxpunk.Sfx;
import net.hxpunk.Tween;
import net.hxpunk.tweens.sound.SfxFader;

/**
	 * ...
	 * @author Jake Albano
	 */
class Ambiance extends XMLEntity
{
    
    public var loop : Bool;
    public var source : String;
    public var tween : Float;
    public var volume : Float;
    private var sound : Sfx;
    private var fader : SfxFader;
    
    public function new()
    {
        super();
    }
    
    override public function added() : Void
    {
        super.added();
        
        sound = new Sfx("sounds/" + source, repeat);
        
        repeat();
    }
    
    private function repeat() : Void
    {
        sound.play(0);
        fader = new SfxFader(sound, null, TweenType.ONESHOT);
        fader.fadeTo(volume, tween);
        addTween(fader, true);
    }
    
    override public function removed() : Void
    {
        super.removed();
        
        fader = new SfxFader(sound, sound.stop, TweenType.ONESHOT);
        fader.fadeTo(0, tween);
        
        world.addTween(fader, true);
    }
}

