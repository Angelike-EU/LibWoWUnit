--[[
 _____         _   _             
|_   _|       | | (_)            
  | | ___  ___| |_ _ _ __   __ _ 
  | |/ _ \/ __| __| | '_ \ / _` |
  | |  __/\__ \ |_| | | | | (_| |
  \_/\___||___/\__|_|_| |_|\__, |
                            __/ |
                           |___/ 
--]]

local lib = LibStub('LibWoWUnit', 1);

local mt = {
    __index = _G,
    __newindex = function(t, name, value)
        if (type(value) ~= 'function' or name:match('^test[A-Z]') == nil) then
            rawset(t, name, value);
        else
            t.test(name, value);
        end
    end
}

local _L = setmetatable({}, mt);

lib.tests = _L;

setfenv(1, _L);

completedTestData = {};

--[[---------------------------------------------------------------------------
 resets library to it's defaults

 -- arguments:

 -- returns:
    nil
-----------------------------------------------------------------------------]]
function resetResults()
    lib.fatalErrors = nil;
    lib.results = {};
    lib.base.activeResult = nil;
    lib.suites = {};
    lib.tests2run = {};

    _L.name = nil;
    _L.error = nil;
end

--[[---------------------------------------------------------------------------
 save work data to module, so it can be analizen after test

 -- arguments:

 -- returns:
    nil
-----------------------------------------------------------------------------]]
function saveTestResult()
    tinsert(completedTestData,  {
        testError = _L.error,
        testName = _L.name,
        fatalErrors = lib.fatalErrors,
        runningResult = lib.base.activeResult,
        tests2run = lib.tests2run,
        suites = lib.suites,
        results = lib.results
    });
end

--[[---------------------------------------------------------------------------
 a simple test function

 -- arguments:
    name:string - name of the test
    testFn:function - the function with the test code
    
 -- returns:
    nil
-----------------------------------------------------------------------------]]
function test(name, callbackFn)
    resetResults();

    local result = { pcall(callbackFn) };

    _L.name = name;
    
    if (result[1] ~= true) then 
        print('|cffff0000Failed|r:', unpack(result));
        _L.error = result[2];
    end

    saveTestResult();
    resetResults();
end

function assertSame(a, b)
    if (a ~= b) then
        error(tostring(a) .. ' ~= ' .. tostring(b), 2); 
    end
end


--[[---------------------------------------------------------------------------
 a function th does nothing

 -- arguments:

 -- returns:
    nil
-----------------------------------------------------------------------------]]
function noopFunc()
end

--[[---------------------------------------------------------------------------
 a function that trows an error when executed

 -- arguments:

 -- returns:
    nil
-----------------------------------------------------------------------------]]
function throwFunc()
    error('An error thrown in a callback function');
end