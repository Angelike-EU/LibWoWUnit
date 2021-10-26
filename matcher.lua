--[[
This file includes all matcher functionality of the lib

All methodes are registred in the subtable matcher in the main lib

--]]

local lib = LibStub:GetLibrary("LibWoWUnit", 1);

-- get all global methodes in local user space

local _G, _L = _G, lib.matcher or {};
local print, tostring, type = print, tostring, type;
local getmetatable, setmetatable = getmetatable, setmetatable;

lib.matcher = _L;

-- restrict global environment, so we can't accidentally pollute it
setfenv(1, _L);



--[[
 Matcher function to compare values

 -- arguments:
   input:mixed - input data
   expected:mixed - expected data

 -- returns:
    result:boolean - the result, true if passed, otherwise false
--]]
function toBe(input, expected)
    local result, msg = input == expected;

    if (result == false) then
        msg = 'expected values to be ' .. tostring(expected) .. ', got: ' .. tostring(input);
    end

	return result, msg;
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

--[[
 Matcher function to check if an value is defined ( !== nil)

 -- arguments:
   input:mixed - input data

 -- returns:
    result:boolean - the result, true if passed, otherwise false
--]]
function toBeDefined(input)
	return input ~= nil;
end

--[[
 Matcher function to check if an value is truthy

 -- arguments:
   input:mixed - input data

 -- returns:
    result:boolean - the result, true if passed, otherwise false
--]]
function toBeTruthy(input)
	return not not input;
end

--[[
 Matcher function to check if an value is true

 -- arguments:
   input:mixed - input data

 -- returns:
    result:boolean - the result, true if passed, otherwise false
--]]
function toBeTrue(input)
	return input == true;
end


--[[
 Matcher function to check if an value is falsy

 -- arguments:
   input:mixed - input data

 -- returns:
    result:boolean - the result, true if passed, otherwise false
--]]
function toBeFalsy(input)
	return not input;
end

--[[
 Matcher function to check if an value is false

 -- arguments:
   input:mixed - input data

 -- returns:
    result:boolean - the result, true if passed, otherwise false
--]]
function toBeFalse(input)
	return input == false;
end

