package com.thaumaturgistgames.slang;

/**
	 * @author Jacob Albano
	 */
class Stdlib extends Module
{
    public function new()
    {
        super();
    }
    
    override public function bind(slang : SlangInterpreter) : Void
    {
        super.bind(slang);
        slang.addFunction("print", print, [String], null, "Print a string to the console");
        slang.addFunction("equals", equals, [Dynamic, Dynamic], null, "Tests two objects for equality");
    }
    
    private function print(s : String) : Void
    {
        slang.write([s]);
    }
    
    private function equals(o1 : Dynamic, o2 : Dynamic) : Bool
    {
        return o1 == o2;
    }
}

