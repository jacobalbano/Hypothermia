package com.thaumaturgistgames.slang;

/**
	 * @author Jacob Albano
	 */
class Memory extends Module
{
    private var vars:Map<String, Dynamic>;
    
    public function new()
    {
        super();
        vars = new Map();
    }
    
    override public function bind(slang : SlangInterpreter) : Void
    {
        super.bind(slang);
        
        slang.addFunction("clearMemory", clear, [], this, "Remove all values from memory");
        slang.addFunction("remember", remember, [String, Dynamic], this, "Store a value in memory");
        slang.addFunction("forget", forget, [String], this, "Remove a value from memory");
        slang.addFunction("var", getVar, [String], this, "Retrive a value from memory");
    }
    
    private function clear() : Void
    {
        vars = new Map();
    }
    
    private function remember(s : String, o : Dynamic) : Void
    {
        vars.set(s, o);
    }
    
    private function forget(s : String) : Dynamic
    {
        var o = vars.get(s);
        vars.remove(s);
        return o;
    }
    
    private function getVar(s : String) : Dynamic
    {
        var o = vars.get(s);
        if (o != null) return o;
        
        return false;
    }
}

