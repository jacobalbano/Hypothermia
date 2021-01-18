package com.jacobalbano.cold;

import com.jacobalbano.punkutils.XMLEntity;
import haxepunk.Sfx;
import haxepunk.Tween;
import haxepunk.tweens.misc.MultiVarTween;
import haxepunk.utils.Ease;
import haxepunk.HXP;

/**
	 * ...
	 * @author Jake Albano
	 */
class Heartbeat extends XMLEntity
{
    private var heartbeat : Sfx;
    
    private static inline var STOPPED : Int = 0;
    private static inline var SLOW : Int = 1;
    private static inline var FAST : Int = 2;
    private var state : Int;
    private var toState : Int;
    
    public function new()
    {
        super();
        heartbeat = new Sfx("sounds/singleBeatSlow.mp3", beatHeart);
        state = STOPPED;
    }
    
    override public function added() : Void
    {
        super.added();
    }
    
    public function stop() : Void
    {
        if (state == STOPPED)
        {
            return;
        }
        
        toState = STOPPED;
    }
    
    public function slow() : Void
    {
        if (state == SLOW)
        {
            return;
        }
        
        toState = SLOW;
        
        if (heartbeat != null && !heartbeat.playing)
        {
            beatHeart();
        }
    }
    
    public function fast() : Void
    {
        if (state == FAST)
        {
            return;
        }
        
        toState = FAST;
        
        if (heartbeat != null && !heartbeat.playing)
        {
            beatHeart();
        }
    }
    
    private function pulseIn() : Void
    {
        var tween = new MultiVarTween(TweenType.OneShot);
        tween.tween(HXP.screen, { scaleX: 1, scaleY : 1}, heartbeat.length / 2, Ease.sineOut);
        tween.onComplete.bind(pulseOut);
        world.addTween(tween, true);
    }
    
    private function pulseOut() : Void
    {
        HXP.screen.scaleX = HXP.screen.scaleY = 1.005;
    }
    
    private function beatHeart() : Void
    {
        switch (toState)
        {
            case STOPPED:
                heartbeat.stop();
                return;
            case SLOW:
                heartbeat = new Sfx("sounds/singleBeatSlow.mp3", beatHeart);
            case FAST:
                heartbeat = new Sfx("sounds/singleBeatFast.mp3", beatHeart);
            default:
                throw "WHAT'S GOING ON";
        }
        
        state = toState;
        
        pulseIn();
        heartbeat.play(1.5);
    }
}

