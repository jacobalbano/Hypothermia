package com.jacobalbano.cold;

import com.jacobalbano.punkutils.XMLEntity;
import flash.geom.Point;
import flash.geom.Rectangle;
import haxepunk.HXP;
import haxepunk.input.Mouse;
import flash.ui.MouseCursor;
import FPGame;

/**
	 * @author Jake Albano
	 */
class Hotspot extends XMLEntity
{
    private var size : Point;
    private var contains : Bool;
    public var onClick : String;
    public var onEnter : String;
    public var onExit : String;
    
    public function new()
    {
        super();
    }
    
    override public function load(entity : Xml) : Void
    {
        super.load(entity);
        
        size = new Point(
            Std.parseFloat(entity.get("width")),
            Std.parseFloat(entity.get("height"))
        );
    }
    
    override public function removed() : Void
    {
        super.removed();
        if (contains)
        {
            flash.ui.Mouse.cursor = MouseCursor.ARROW;
        }
    }
    
    override public function update() : Void
    {
        super.update();
        
        var all = [];
        
        var inventory : Inventory = null;
        world.getClass(Inventory, all);
        if (all.length > 0)
        {
            inventory = cast all[0];
        }
        
        var lastContain : Bool = contains;
        contains = collidePoint(x, y, world.mouseX, world.mouseY);
        
        if (contains)
        {
            if (inventory != null && inventory.isOpen)
            {
                return;
            }
            else if (Mouse.mouseReleased)
            {
                callback(onClick);
            }
            
            flash.ui.Mouse.cursor = MouseCursor.BUTTON;
        }
        
        if (lastContain != contains)
        {
            if (contains)
            {
                callback(onEnter);
            }
            else
            {
                flash.ui.Mouse.cursor = MouseCursor.ARROW;
                callback(onExit);
            }
        }
    }
    
    private function callback(script : String) : Void
    {
        FPGame.slang.doLine(script);
    }
}

