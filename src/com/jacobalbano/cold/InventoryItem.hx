package com.jacobalbano.cold;

import haxepunk.input.Mouse;
import haxepunk.graphics.Image;
import com.jacobalbano.punkutils.XMLEntity;
import flash.geom.Rectangle;
import haxepunk.input.Input;

/**
	 * @author Jake Albano
	 */
class InventoryItem extends XMLEntity
{
    private var owner : Inventory;
    public var typeName : String;
    
    public function new()
    {
        super();
    }
    
    public function onAdded(owner : Inventory) : Void
    {
        this.owner = owner;
    }
    
    override public function added() : Void
    {
        super.added();
        var img:Image = cast graphic;
        img.centerOrigin();
    }
    
    override public function update() : Void
    {
        super.update();
        
        var image : Image = cast graphic;
        var rect : Rectangle = new Rectangle(x - (image.originX * (image.scale)), y - (image.originY * (image.scale)), image.width * image.scale, image.height * image.scale);
        
        if (rect.contains(Mouse.mouseX, Mouse.mouseY))
        {
            if (Mouse.mouseReleased)
            {
                //	Set this as the type at the mouse
                owner.mouseItem = typeName;
            }
        }
    }
}

