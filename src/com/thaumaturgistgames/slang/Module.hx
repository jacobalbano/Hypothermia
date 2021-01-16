package com.thaumaturgistgames.slang;


/**
	 * @author Jacob Albano
	 */
class Module
{
    private var slang : SlangInterpreter;
    
    public function new()
    {
    }
    
    /**
		 * Override this
		 * @param	slang	A reference to the interpreter
		 */
    public function bind(slang : SlangInterpreter) : Void
    {
        this.slang = slang;
    }
}

