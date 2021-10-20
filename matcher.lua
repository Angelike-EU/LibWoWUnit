--[[
This file includes all matcher functionality of the lib

All methodes are registred in the subtable matcher in the main lib

--]]

local lib = LibStub:GetLibrary("LibWoWUnit", 1);

-- get all global methodes in local user space

local _G, _L = _G, {};
local type = _G.type;

lib.matcher = _L;

-- restrict global environment, so we can't accidentally pollute it
setfenv(1, _L);

--[[
 Helper function to register custom mather to the lib

 -- arguments:
   name:string - name of the matcher
   callbackFn:function - the code of the matcher function

 -- returns:
    name:string - the name of the actual test suite
--]]
function lib:registerMatcher(name, fn)
	lib.matcher[name] = fn;
end

--[[
 Matcher function to compare values

 -- arguments:
   input:mixed - input data
   expected:mixed - expected data

 -- returns:
    result:boolean - the result, true if passed, otherwise false
--]]
function toBe(input, expected)
	return input == expected;
end

--[[
 Matcher function to compare values types

 -- arguments:
   input:mixed - input data
   expected:string - expected type as sting

 -- returns:
    result:boolean - the result, true if passed, otherwise false
--]]
function toBeType(input, expectedType)
	local inputType = type(input);
    local mt = getmetatable(input);
	
	if (inputType == 'table' and mt and mt.__index and mt.__index.IsForbidden and mt.__index.GetObjectType and not input:IsForbidden()) then
        return expectedType == input:GetObjectType();
	end

	return inputType == expectedType;
end