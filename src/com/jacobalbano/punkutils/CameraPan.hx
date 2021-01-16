package com.jacobalbano.punkutils;

import flash.geom.Rectangle;
import net.hxpunk.Entity;
import net.hxpunk.tweens.misc.VarTween;
import net.hxpunk.utils.Input;
import net.hxpunk.HP;
import com.jacobalbano.punkutils.XMLEntity;
import com.jacobalbano.punkutils.OgmoWorld;

/**
	 * @author Jacob Albano
	 */
class CameraPan extends XMLEntity
{
    public var wrapAround : Bool;
    public var worldWidth : Int;
    public var worldHeight : Int;
    public var buffer : Int;
    public var scrollSpeed : Int;
    
    private var leftBuffer : Rectangle;
    private var rightBuffer : Rectangle;
    private var topBuffer : Rectangle;
    private var bottomBuffer : Rectangle;
    
    private var tween : VarTween;
    public var speedX : Float;
    public var speedY : Float;
    private var mouseInXBuffer : Bool;
    private var mouseInYBuffer : Bool;
    
    public function new()
    {
        super();
        worldWidth = 0;  //	default  
        worldHeight = 0;  //	default  
        tween = new VarTween();
        addTween(tween, true);
        speedX = 0;
        speedY = 0;
    }
    
    override public function added() : Void
    {
        super.added();
        
        HP.camera.x = x;
        HP.camera.y = y;
        
        if (!Std.is(world, OgmoWorld))
            return;
        
        var oWorld : OgmoWorld = cast world;
        this.worldWidth = Std.int(oWorld.size.x);
        this.worldHeight = Std.int(oWorld.size.y);
        oWorld.wraparound = this.wrapAround;
        
        leftBuffer = new Rectangle(0, 0, buffer, HP.height);
        rightBuffer = new Rectangle(HP.width - buffer, 0, buffer, HP.height);
        topBuffer = new Rectangle(0, 0, HP.width, buffer);
        bottomBuffer = new Rectangle(0, HP.height - buffer, HP.width, buffer);
    }
    
    override public function update() : Void
    {
        super.update();
        
        if (wrapAround || (HP.camera.x >= 0 && HP.camera.x + HP.width <= worldWidth))
        {
            if (leftBuffer.contains(Input.mouseX, Input.mouseY))
            {
                onEnterLeft();
            }
            else if (rightBuffer.contains(Input.mouseX, Input.mouseY))
            {
                onEnterRight();
            }
            else
            {
                speedX = 0;
                mouseInXBuffer = false;
            }
        }
        
        if (!wrapAround && HP.camera.y >= 0 && HP.camera.y + HP.height <= worldHeight)
        {
            if (topBuffer.contains(Input.mouseX, Input.mouseY))
            {
                onEnterTop();
            }
            else if (bottomBuffer.contains(Input.mouseX, Input.mouseY))
            {
                onEnterBottom();
            }
            else
            {
                speedY = 0;
                mouseInYBuffer = false;
            }
        }
        
        HP.camera.x += speedX;
        HP.camera.y += speedY;
        
        if (!wrapAround)
        {
            if (HP.width <= worldWidth)
            {
                if (HP.camera.x < 0)
                {
                    HP.camera.x = 0;
                }
                else if (HP.camera.x + HP.width >= worldWidth)
                {
                    HP.camera.x = worldWidth - HP.width;
                }
            }
            
            if (HP.height <= worldHeight)
            {
                if (HP.camera.y < 0)
                {
                    HP.camera.y = 0;
                }
                else if (HP.camera.y + HP.height >= worldHeight)
                {
                    HP.camera.y = worldHeight - HP.height;
                }
            }
        }
        else
        {
            HP.camera.x = HP.camera.x % worldWidth;
            HP.camera.y = HP.camera.y % worldHeight;
        }
    }
    
    private function onEnterRight() : Void
    {
        if (!mouseInXBuffer)
        {
            mouseInXBuffer = true;
            speedX = 0;
            tween.tween(this, "speedX", scrollSpeed, 0.25);
        }
    }
    
    private function onEnterLeft() : Void
    {
        if (!mouseInXBuffer)
        {
            mouseInXBuffer = true;
            speedX = 0;
            tween.tween(this, "speedX", -scrollSpeed, 0.25);
        }
    }
    
    private function onEnterBottom() : Void
    {
        if (!mouseInYBuffer)
        {
            mouseInYBuffer = true;
            speedY = 0;
            tween.tween(this, "speedY", scrollSpeed, 0.25);
        }
    }
    
    private function onEnterTop() : Void
    {
        if (!mouseInYBuffer)
        {
            mouseInYBuffer = true;
            speedY = 0;
            tween.tween(this, "speedY", -scrollSpeed, 0.25);
        }
    }
}

