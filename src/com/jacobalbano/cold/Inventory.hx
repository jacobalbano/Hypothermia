package com.jacobalbano.cold;

import flash.errors.Error;
import net.hxpunk.graphics.Image;
import com.jacobalbano.punkutils.XMLEntity;
import flash.display.Bitmap;
import flash.ui.Mouse;
import flash.ui.MouseCursor;
import net.hxpunk.Entity;
import net.hxpunk.masks.Pixelmask;
import net.hxpunk.Tween;
import net.hxpunk.tweens.misc.VarTween;
import net.hxpunk.utils.Ease;
import net.hxpunk.utils.Input;

/**
	 * @author Jake Albano
	 */
class Inventory extends XMLEntity
{
    public var itemCount(get, never) : Int;
    public var isOpen(get, never) : Bool;
    public var mouseItem(get, set) : String;

    private var _mouseItem : String;
    private var _itemCount : Int;
    private var items : Map<String, InventoryItem>;
    private var extended : Bool;
    private var everUsed : Bool;
    private var mouseEntity : Entity;
    private var contains : Bool;
    private static inline var ITEM_PADDING : Float = 20;
    private static inline var ITEM_SIZE : Float = 100;
    private var nextExtendState : Bool;
    
    public function new()
    {
        super();
        graphic = new Image("art/ui/inventory.png");
        mask = new Pixelmask("art/ui/inventoryMask.png", 0, 0);
        graphic.scrollX = 0;
        graphic.scrollY = 0;
        
        reset();
    }
    
    public function reset() : Void
    {
        items = new Map();
        mouseItem = "";
        y = -cast(graphic, Image).height;
        everUsed = false;
        _itemCount = 0;
    }
    
    override public function added() : Void
    {
        super.added();
        
        for (item in items)
        {
            world.add(item);
        }
    }
    
    override public function update() : Void
    {
        super.update();
        
        extended = nextExtendState;
        
        var lastContain : Bool = contains;
        contains = collidePoint(x, y, Input.mouseX, Input.mouseY);
        
        var count : Int = 0;
        for (item in items)
        {
            if (item.typeName == mouseItem)
            {
                item.x = Input.mouseX;
                item.y = Input.mouseY;
            }
            else
            {
                item.x = count++ * ITEM_SIZE + ITEM_PADDING + (ITEM_SIZE / 2);
                item.y = y + (ITEM_SIZE / 2) + 15;
            }
        }
        
        if (lastContain != contains)
        {
            if (contains)
            {
                Mouse.cursor = MouseCursor.BUTTON;
            }
            else
            {
                Mouse.cursor = MouseCursor.ARROW;
            }
        }
        
        if (Input.mouseReleased && contains)
        {
            if (mouseItem != "")
            {
                _mouseItem = "";
                extended = true;
                return;
            }
            
            if (extended)
            {
                close();
            }
            else
            {
                open();
                extended = true;
            }
        }
    }
    
    public function open() : Void
    {
        if (isOpen)
        {
            return;
        }
        
        var tween : VarTween = new VarTween(null, TweenType.ONESHOT);
        tween.tween(this, "y", 0, 0.8, Ease.bounceOut);
        addTween(tween, true);
        nextExtendState = true;
    }
    
    public function close() : Void
    {
        if (!isOpen)
        {
            return;
        }
        
        var tween : VarTween = new VarTween(null, TweenType.ONESHOT);
        tween.tween(this, "y", y - 150, 0.7, Ease.bounceOut);
        addTween(tween, true);
        nextExtendState = false;
    }
    
    public function hasItem(name : String) : Bool
    {
        return items.exists(name);
    }
    
    public function addItem(name : String) : Void
    {
        if (hasItem(name))
        {
            return;
        }
        
        var image : Image;
        
        try
        {
            image = new Image('art/invitems/${name}.png');
        }
        catch (e : Error)
        {
            //	Alternate image doesn't exist; don't worry about it
            image = new Image('art/worlditems/${name}.png');
        }
        
        var item : InventoryItem = new InventoryItem();
        item.typeName = name;
        item.graphic = image;
        item.onAdded(this);
        world.add(item);
        
        image.scrollX = 0;
        image.scrollY = 0;
        image.smooth = true;
        image.scale = ITEM_SIZE / Math.max(image.width, image.height);
        
        items.set(name, item);
        
        if (!everUsed && ++_itemCount == 1)
        {
                
            //	First item added to inventory, so show the button in a way that it'll be noticed.
            var tween : VarTween = new VarTween(null, TweenType.ONESHOT);
            tween.tween(this, "y", y + 50, 0.9, Ease.bounceOut);
            addTween(tween, true);
        }
        
        everUsed = true;
    }
    
    public function removeItem(name : String) : Void
    {
        if (!items.exists(name))
        {
            return;
        }
        
        if (name == mouseItem)
        {
            _mouseItem = "";
        }
        
        _itemCount--;
        world.remove(items.get(name));
        items.remove(name);
    }
    
    private function get_itemCount() : Int
    {
        return _itemCount;
    }
    
    private function get_isOpen() : Bool
    {
        return extended;
    }
    
    private function get_mouseItem() : String
    {
        return _mouseItem;
    }
    
    private function set_mouseItem(typeName : String) : String
    {
        if (typeName == mouseItem)
        {
            return typeName;
        }
        
        if (typeName == "")
        {
            _mouseItem = "";
            return typeName;
        }
        
        if (Reflect.field(items, typeName) != null)
        {
            _mouseItem = typeName;
            close();
        }
        return typeName;
    }
}

