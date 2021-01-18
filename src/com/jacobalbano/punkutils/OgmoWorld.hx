package com.jacobalbano.punkutils;

import openfl.geom.Point;
import haxepunk.World;

class OgmoWorld extends World
{
    public var size(default, null):Point;
    public var wraps:Bool;

    public function new(size:Point) {
        super();

        this.size = size;
        preRender.bind(function doubleRender():Void
        {
            if (!wraps) return;
            var original = camera.x;
            
            camera.x = original + size.x;
            renderEntities();

            camera.x = original - size.x;
            renderEntities();
            
            camera.x = original;
        });
    }
    
    override private function get_mouseX() : Int
    {
        var mx : Int = super.mouseX;
        if (wraps)
        {
            if (mx < 0)
            {
                mx += Std.int(size.x);
            }
            else
            {
                mx %= Std.int(size.x);
            }
        }
        
        return mx;
    }
}