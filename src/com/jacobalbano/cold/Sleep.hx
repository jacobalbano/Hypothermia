package com.jacobalbano.cold;

import haxepunk.graphics.Image;
import haxe.Constraints.Function;
import com.jacobalbano.punkutils.XMLEntity;
import haxepunk.HXP;
import haxepunk.graphics.Graphiclist;
import haxepunk.Tween;
import haxepunk.tweens.misc.VarTween;
import haxepunk.utils.Ease;

/**
	 * ...
	 * @author Jake Albano
	 */
class Sleep extends XMLEntity
{
    private var topLid : Image;
    private var bottomLid : Image;
    private static inline var DURATION : Float = 10;
    private var running : Bool;
    private var count : Int;
    
    public var onComplete : Function;
    
    public function new()
    {
        super();
        
        count = 0;
        
        topLid = new Image("art/ui/drowsy.png");
        bottomLid = new Image("art/ui/drowsy.png");
        
        topLid.x = 0;
        bottomLid.x = 0;
        
        topLid.scrollX = 0;
        bottomLid.scrollX = 0;
        
        topLid.scrollY = 0;
        bottomLid.scrollY = 0;
        
        //	Flip the bottom image around
        bottomLid.angle = 180;
        bottomLid.originX = bottomLid.width;
        bottomLid.originY = bottomLid.height;
        
        graphic = new Graphiclist([topLid, bottomLid]);
        
        stop();
    }
    
    public function start() : Void
    {
        if (!running)
        {
            var topTween : VarTween = new VarTween(TweenType.OneShot);
            topTween.onComplete.bind(onFinished);
            var bottomTween : VarTween = new VarTween(TweenType.OneShot);
            bottomTween.onComplete.bind(onFinished);
            
            topTween.tween(topLid, "y", 0, DURATION, Ease.bounceInOut);
            bottomTween.tween(bottomLid, "y", HXP.height - bottomLid.height, DURATION, Ease.bounceInOut);
            
            addTween(topTween, true);
            addTween(bottomTween, true);
            
            running = true;
        }
    }
    
    public function stop() : Void
    {
        clearTweens();
        
        topLid.y = -topLid.height;
        bottomLid.y = HXP.height;
        
        count = 0;
        running = false;
    }
    
    private function onFinished() : Void
    {
        if (++count == 2)
        {
            if (onComplete != null)
            {
                onComplete();
            }
            
            count = 0;
            running = false;
        }
    }
}

