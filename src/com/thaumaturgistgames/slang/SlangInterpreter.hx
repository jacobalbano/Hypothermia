package com.thaumaturgistgames.slang;

import flash.errors.ArgumentError;
import flash.errors.Error;
import haxe.Constraints.Function;

/**
	 * Interpreter for the Slang scripting language
	 * @author Jake Albano
	 */
class SlangInterpreter
{
    public var errorHandler(never, set) : String->Void;

    private static inline var DECLARATION : Int = 0;  //	The name of the function in string form  
    private static inline var FUNCTION : Int = 1;  //	The function or method closure  
    private static inline var ARG_TYPES : Int = 2;  //	An array of types for argument casting  
    private static inline var THIS_OBJ : Int = 3;  //	The object to use as the 'this' reference in a function call  
    private static inline var DOC : Int = 4;  //	The object to use as the 'this' reference in a function call  
    
    private var functions : Array<Dynamic>;
    private var callback : String->Void;
    private var errors : Array<Dynamic>;
    private var executing : Bool;
    
    public function new()
    {
        callback = defaultErrorHandler;
        functions = [];
        errors = [];
        executing = false;
        addFunction("help", help, [], this, "Displays this help screen");
        addFunction("if", opIf, [Bool], null, "Abort execution if a false value is recieved");
        addFunction("not", opNot, [Bool], null, "Return the inverse of a boolean value");
    }
    
    /**
		 * Evaluates a parameter, and aborts execution if it is false
		 * @param	val	The conditional parameter
		 */
    private function opIf(val : Bool) : Void
    {
        executing = val;
    }
    
    /**
		 * Invert a boolean variable
		 * @param	val	The variable to invert
		 * @return	The inverted parameter
		 */
    private function opNot(val : Bool) : Bool
    {
        return !val;
    }
    
    public function importModule(module : Module) : Void
    {
        module.bind(this);
    }
    
    /**
		 * Set the callback for text output
		 */
    private function set_errorHandler(handler : String->Void) : String->Void
    {
        if (handler == null)
        {
            callback = defaultErrorHandler;
            return handler;
        }
        
        try
        {
            handler("FLAKit console with Slang v" + getVersion() + "\nType help for a list of commands");
        }
        catch (e : ArgumentError)
        {
            callback = defaultErrorHandler;
            return callback;
        }
        
        callback = handler;
        return handler;
    }
    
    /**
		 * Get the version of the slang interpreter
		 * @return	The version as a number
		 */
    public function getVersion() : Float
    {
        return 0.5;
    }
    
    /**
		 * Adds a new function to the script interpreter
		 * @param	declaration	The string to be used when calling the function
		 * @param	func	The function or method closure to be used
		 * @param	argTypes	An array of types to cast arguments (can be empty or null)
		 * @param	thisObj	The object to use as the 'this' reference in the function call
		 * @param	documentation	An optional string to be displayed when the help command is called
		 */
    public function addFunction(declaration : String, func : Function, argTypes : Array<Dynamic> = null, thisObj : Dynamic = null, documentation : String = "") : Void
    {
        if (argTypes == null)
        {
            argTypes = [];
        }
        
        for (item in functions)
        {
            if (Reflect.field(item, Std.string(DECLARATION)) == declaration)
            {
                write(["Failed to bind function '", declaration, "': a function by that name already exists"]);
                return;
            }
        }
        
        functions.push([declaration, func, argTypes, thisObj, documentation]);
    }
    
    /**
		 * Executes a command or semicolon-separated series of commands
		 * @param	script The script to run
		 */
    public function doLine(script : String) : Void
    {
        doScript(separate(script));
    }
    
    /**
		 * Executes an array of commands or semicolon-separated series of commands
		 * @param	script	The array to run
		 */
    public function doScript(script : Array<Dynamic>) : Void
    {
        for (line in script)
        {
            executeLine(line);
            
            errors.reverse();
            while (errors.length > 0)
            {
                callback(errors.pop());
            }
        }
    }
    
    /**
		 * Execute a single line of Slang code
		 * @param	line	The line to execute
		 */
    private function executeLine(stack : Array<Dynamic>) : Void
    {
        executing = true;
        //var stack:Array = separate(line);
        
        var callstack : Array<Dynamic> = [];
        var argstack : Array<Dynamic> = [];
        var bytecode : Array<Dynamic> = [];
        var checkCall:Void->Void;

        //	Sexy stuff happening right here
        function pushArg(arg : Dynamic) : Void
        {
            argstack.push(arg);
            checkCall();
        };
        
        function pushCall(funcID : Int) : Void
        {
            callstack.push(funcID);
            checkCall();
        }
        
        checkCall = function() : Void
        {
            if (callstack.length > 0)
            {
                var definition : Array<Dynamic> = Reflect.field(functions, Std.string(callstack[callstack.length - 1]));
                var types : Array<Dynamic> = definition[ARG_TYPES];
                var paramCount : Int = types.length;
                
                if (argstack.length >= paramCount)
                {
                    var result : Dynamic = executeCall(callstack.pop(), argstack);
                    
                    while (paramCount >= 0)
                    {
                        paramCount--;
                        argstack.pop();
                    }
                    
                    if (result != null)
                    {
                        pushArg(result);
                    }
                }
            }
        }
        
        for (word in stack)
        {
            if (!executing)
            {
                return;
            }
            
            var funcIndex : Int = findFunction(word);
            
            if (funcIndex < 0)
            {
                //Function not found, so assume it's a value, like a single-word string
                
                if (callstack.length != 0)
                {
                    pushArg(word);
                }
            }
            else
            {
                pushCall(funcIndex);
            }
        }
        
        checkCall();
    }
    
    /**
		 * Execute a script function and return the result
		 * @param	funcID	The ID of the function to execute
		 * @param	argstack	The argument stack from which to pull parameters
		 * @return	The return value of the executing function, if any
		 */
    private function executeCall(funcID : Int, argstack : Array<Dynamic>) : Dynamic
    {
        var thisObj : Dynamic = functions[funcID][THIS_OBJ];
        var func : Function = functions[funcID][FUNCTION];
        var paramCount : Int = functions[funcID][ARG_TYPES].length;
        var params : Array<Dynamic> = [];
        
        for (i in 0...paramCount)
        {
            params.push(param_cast(funcID, i, argstack[i]));
        }
        
        //	Call the function
        try
        {
            return Reflect.callMethod(thisObj, func, params);
        }
        catch (e : Error)
        {
            raiseError(e.getStackTrace().split("\n")[0]);
            return null;
        }
    }
    
    /**
		 * Cast a value to the appropriate type to be used in a function
		 * @param	funcID	The function to be called
		 * @param	param	The index of the parameter type
		 * @param	value	The generic value to be converted
		 * @return	The value as the correct type
		 */
    private function param_cast(funcID : Int, param : Int, value : Dynamic) : Dynamic
    {
        if (functions[funcID][ARG_TYPES][param] == Bool)
        {
            if (value == null || value == null)
            {
                return value;
            }
            else if (Std.is(value, String))
            {
                var string : String = Std.string(value);
                return (string.indexOf("true") >= 0 || string.indexOf("1") >= 0);
            }
            else
            {
                return try cast(value, Bool) catch(e:Dynamic) null;
            }
            
            return false;
        }
        else if (functions[funcID][ARG_TYPES][param] == String)
        {
            var slice : String = value;
            if (slice.charAt(0) == "'" && slice.charAt(slice.length - 1) == "'")
            {
                return slice.substring(1, slice.length - 1);
            }
            
            return slice;
        }
        else
        {
            var type : Class<Dynamic> = functions[funcID][ARG_TYPES][param];
            return Type.createInstance(type, [value]);
        }
        
        return null;
    }
    
    /**
		 * Search for a registered function by name and return its index, or -1 if it doesn't exist
		 * @param	fn	The function declaration
		 * @return	The function index or -1 on failure
		 */
    private function findFunction(fn : String) : Int
    {
        var findFunc : Int = 0;
        while (findFunc < functions.length)
        {
            if (functions[findFunc][DECLARATION] == fn)
            {
                return findFunc;
            }
            ++findFunc;
        }
        
        return -1;
    }
    
    /**
		 * Separate a string into chunks at the spaces, keeping text surrounded by quotation marks contiguous
		 * @param	str	The string to separate
		 * @return	An array containing the chunks
		 */
    private function separateWords(str : String) : Array<Dynamic>
    {
        var inString : Bool = false;
        var builder : String = "";
        var result : Array<Dynamic> = [];
        
        var i : Int = 0;
        while (i < str.length)
        {
            switch (str.charAt(i))
            {
                case " ", "\n", "\t", "\r":
                    if (inString)
                    {
                        builder += str.charAt(i);
                    }
                    else if (builder.length > 0)
                    {
                        result.push(builder);
                        builder = "";
                    }
                case "\"":
                    inString = !inString;
                    builder += "'";
                    if (!inString)
                    {
                        result.push(builder);
                        builder = "";
                    }
                default:
                    builder += str.charAt(i);
            }
            ++i;
        }
        
        if (builder != " ")
        {
            result.push(builder);
        }
        
        return result;
    }
    
    /**
		 * Separate a string into lines at semicolons, keeping text surrounded by quotation marks contiguous
		 * @param	str	The string to separate
		 * @return	An array containing the lines
		 */
    private function separateLines(string : String) : Array<String>
    {
        var inString : Bool = false;
        var builder : String = "";
        var result : Array<String> = [];
        
        var pushAndReset : Void->Void = function() : Void
        {
            result.push(builder);
            builder = "";
        }
        
        var i : Int = 0;
        while (i < string.length)
        {
            var char : String = string.charAt(i);
            
            switch (char)
            {
                case ";":
                    if (inString)
                    {
                        builder += char;
                    }
                    else if (builder.length > 0)
                    {
                        pushAndReset();
                    }
                case "\"":
                    inString = !inString;
                    builder += char;
                default:
                    builder += char;
            }
            ++i;
        }
        
        if (builder != " ")
        {
            pushAndReset();
        }
        
        return result;
    }
    
    /**
		 * Separate a string into chunks at the spaces, keeping text surrounded by quotation marks contiguous
		 * @param	str	The string to separate
		 * @return	An array containing the chunks
		 */
    private function separate(str : String) : Array<Dynamic>
    {
        var done : Array<Dynamic> = [];
        
        for (item in separateLines(str))
        {
            done.push(separateWords(item));
        }
        
        return done;
    }
    
    /**
		 * Raise an error to be reported on execution end
		 * @param	message	The error message
		 * @return	The error message
		 */
    private function raiseError(message : String) : String
    {
        errors.push(message);
        return message;
    }
    
    /**
		 * List the registered functions in the console
		 */
    public function help() : Void
    {
        callback("Commands:");
        
        var command : Int = 0;
        while (command < functions.length)
        {
            var argTypes : String = "";
            var doc : String = "";
            
            if (functions[command][ARG_TYPES].length > 0)
            {
                argTypes = new String(functions[command][ARG_TYPES]);
                argTypes = replaceChar(argTypes, "[class ", "");
                argTypes = replaceChar(argTypes, "]", "");
                argTypes = replaceChar(argTypes, ",", ", ");
            }
            
            if (functions[command][DOC] != "")
            {
                doc = "\n\t-- " + functions[command][DOC];
            }
            
            callback("\t" + functions[command][DECLARATION] + " " + argTypes + doc);
            ++command;
        }
    }
    
    /**
		 * Replace patterns in a string
		 * @param	s	The in string
		 * @param	a	The pattern to replace
		 * @param	b	The string with which to replace
		 * @return	The in string with the specified pattern replaced
		 */
    private function replaceChar(s : String, a : String, b : String) : String
    {
        var ar : Array<Dynamic> = s.split(a);
        s = "";
        var i : Float = 0;
        while (i < ar.length)
        {
            s += (i < ar.length - 1) ? Reflect.field(ar, Std.string(i)) + b : Reflect.field(ar, Std.string(i));
            i++;
        }
        return s;
    }
    
    /**
		 * Print a message to the callback
		 * @param	...rest	Variable parameters
		 */
    public function write(rest : Array<Dynamic> = null) : Void
    {
        if (rest == null) rest = [];
        callback(rest.join(" "));
    }
    
    /**
		 * Used as the fallback when an invalid function is set as the error handler
		 * @param	message
		 */
    private function defaultErrorHandler(message : String) : Void
    {
        trace(message);
    }
}

