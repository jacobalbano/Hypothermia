package com.jacobalbano.punkutils;

import haxe.rtti.CType.Rights;
import net.hxpunk.Entity;
import haxe.xml.Access;
import haxe.rtti.Rtti;

/**
	 * ...
	 * @author Jacob Albano
     */
@:rtti
class XMLEntity extends Entity
{
    
    public function new()
    {
        super();
    }
    
    public function load(entity:Xml) : Void
    {
        var thisClass = Type.getClass(this);
        var className:String;
        var mapper = mappers.get(className = Type.getClassName(thisClass));
        if (mapper == null)
            mappers.set(className, mapper = createMapper(thisClass));


        for (attribute in entity.attributes())
        {
            var handler = mapper.handlers.get(attribute);
            if (handler == null) continue;
            handler(this, entity.get(attribute));
        }

    }

    private static var mappers(default, never):Map<String, XMLEntityMapper> = new Map();

    private static function createMapper(entClass:Class<XMLEntity>):XMLEntityMapper
    {
        var result = new XMLEntityMapper();
        var thisRtti = Rtti.getRtti(entClass);
        for (field in thisRtti.fields)
        {
            if (field.set == Rights.RNo)
                continue;

            var handler:String->Dynamic = switch (field.type)
            {
                case CAbstract(name, params):
                    switch (name)
                    {
                        case "Int": (s) -> Std.parseInt(s);
                        case "Float": (s) -> Std.parseFloat(s);
                        case "Bool": (s) -> s.toLowerCase() == "true";
                        case _: null;
                    };
                case CClass(name, params):
                    switch (name)
                    {
                        case "String": (s) -> s;
                        case _: null;
                    }
                case _: null;
            };

            if (handler != null)
                result.handlers.set(field.name, (entity:XMLEntity, attr:String) -> Reflect.setField(entity, field.name, handler(attr)));
        }

        return result;
    }
}

class XMLEntityMapper
{
    public function new() {};
    public var handlers(default, never):Map<String, XMLEntity->String->Void> = new Map();
}

