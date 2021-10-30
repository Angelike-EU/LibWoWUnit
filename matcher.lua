--[[
This file includes all matcher functionality of the lib

All methodes are registred in the subtable matcher in the main lib

--]]

local lib = LibStub:GetLibrary("LibWoWUnit", 1);

-- get all global methodes in local user space

local _G, _L = _G, lib.matcher or {};
local pcall, print, tostring, type = pcall, print, tostring, type;
local getmetatable, setmetatable = getmetatable, setmetatable;
local math = math;

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
    msg:string - an error message
--]]
function toBe(input, expected)
    if (#input ~= 1) then
        return false, 'toBe expect only one input parameter, got ' .. #input;
    end

    if (#expected ~= 1) then
        return false, 'toBe expect only one compare parameter, got ' .. #expected;
    end

    if (input[1] ~= expected[1]) then
        return false, 'expected values to be "' .. tostring(expected[1]) .. '", but was "' .. tostring(input[1]) .. '".';
    end

	return true;
end

--[[
 Matcher function to compare values types

 -- arguments:
   input:mixed - input data
   expected:string - expected type as sting

 -- returns:
    result:boolean - the result, true if passed, otherwise false
    msg:string - an error message
--]]
function toBeType(input, expected)
    if (#input ~= 1) then
        return false, 'toBeType expect only one input parameter, got ' .. #input;
    end

    if (#expected ~= 1) then
        return false, 'toBeType expect only one compare parameter, got ' .. #expected;
    end

	local inputType = type(input[1]);
    local mt = getmetatable(input[1]);
	
	if (inputType == 'table' and mt and mt.__index and mt.__index.IsForbidden and mt.__index.GetObjectType and not input[1]:IsForbidden()) then
        inputType = input[1]:GetObjectType();
	end

    if (inputType ~= expected[1]) then
        return false, 'expected input to be type of "' .. tostring(expected[1]) .. '", but was "' .. inputType .. '".';
    end

	return true;
end

--[[
 Matcher function to check if an value is defined ( !== nil)

 -- arguments:
   input:mixed - input data
   expected:mixed - expected data

 -- returns:
    result:boolean - the result, true if passed, otherwise false
    msg:string - an error message
--]]
function toBeDefined(input, expected)
    if (#input > 1) then
        return false, 'toBeDefined expect only one input parameter, got ' .. #input;
    end

    if (#expected >= 1) then
        return false, 'toBeDefined expect no compare parameter, got ' .. #expected;
    end

	if (input[1] == nil) then
        return false, 'expect input to be defined, but was "' .. tostring(input[1]) .. '".';
    end

    return true
end

--[[
 Matcher function to check if an value is truthy

 -- arguments:
   input:mixed - input data
   expected:mixed - expected data

 -- returns:
    result:boolean - the result, true if passed, otherwise false
    msg:string - an error message
--]]
function toBeTruthy(input, expected)
    if (#input > 1) then
        return false, 'toBeTruthy expect only one input parameter, got ' .. #input;
    end

    if (#expected >= 1) then
        return false, 'toBeTruthy expect no compare parameter, got ' .. #expected;
    end

    if (not input[1]) then
        return false, 'expect input to be truthy, but was ' .. tostring(input[1]) .. ' (' .. tostring(not not input[1]) .. ')';
    end

	return true;
end

--[[
 Matcher function to check if an value is true

 -- arguments:
   input:mixed - input data
   expected:mixed - expected data

 -- returns:
    result:boolean - the result, true if passed, otherwise false
    msg:string - an error message
--]]
function toBeTrue(input, expected)
    if (#input > 1) then
        return false, 'toBeTrue expect only one input parameter, got ' .. #input;
    end

    if (#expected >= 1) then
        return false, 'toBeTrue expect no compare parameter, got ' .. #expected;
    end

    if (input[1] ~= true) then
        return false, 'expect input to be true, but was ' .. tostring(input[1]);
    end

	return true;
end


--[[
 Matcher function to check if an value is falsy

 -- arguments:
   input:mixed - input data
   expected:mixed - expected data

 -- returns:
    result:boolean - the result, true if passed, otherwise false
    msg:string - an error message
--]]
function toBeFalsy(input, expected)
    if (#input > 1) then
        return false, 'toBeFalsy expect only one input parameter, got ' .. #input;
    end

    if (#expected >= 1) then
        return false, 'toBeFalsy expect no compare parameter, got ' .. #expected;
    end

    if (input[1]) then
        return false, 'expect input to be falsy, but was ' .. tostring(input[1]) .. ' (' .. tostring(not not input[1]) .. ')';
    end

	return true;
end

--[[
 Matcher function to check if an value is false

 -- arguments:
   input:mixed - input data
   expected:mixed - expected data

 -- returns:
    result:boolean - the result, true if passed, otherwise false
    msg:string - an error message
--]]
function toBeFalse(input, expected)
    if (#input > 1) then
        return false, 'toBeFalse expect only one input parameter, got ' .. #input;
    end

    if (#expected >= 1) then
        return false, 'toBeFalse expect no compare parameter, got ' .. #expected;
    end

    if (input[1] ~= false) then
        return false, 'expect input to be false, but was ' .. tostring(input[1]);
    end

	return true;
end

local function substract(a, b)
    return math.abs(a - b);
end 

--[[
 Matcher function to check if an value is close to each other

 -- arguments:
   input:mixed - input data
   expected:mixed - expected data

 -- returns:
    result:boolean - the result, true if passed, otherwise false
    msg:string - an error message
--]]
function toBeCloseTo(input, expected)
    if (#input > 1) then
        return false, 'toBeCloseTo expect only one input parameter, got ' .. #input;
    end

    if (#expected < 1 or #expected > 2) then
        return false, 'toBeCloseTo expect no compare parameter, got ' .. #expected;
    end

    local precision = expected[2] or 2;

    if (type(precision) ~= 'number') then
        return false, 'toBeCloseTo(expected[, precision]): precision must be an number, got ' .. tostring(precision) .. ' (' .. type(precision) .. ')';
    end

    local success, result = pcall(substract, input[1], expected[1]);

    if (success == false) then
        return false, 'expect input/compare to be numerics.' .. result;
    end

    if (result * math.pow(10, precision) >= 1 ) then
        return false, 'expect input to be close to ' .. tostring(input[1]) .. ', but was ' .. tostring(expected[1]) .. ' (precicion '.. precision .. ')';
    end

	return true;
end
