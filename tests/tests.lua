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

successTest = {};
failedTest = {};

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
function saveTestResult(name, testOk, error)
    local resultSet = {
        testError = testOk ~= true and error or nil,
        testName = name,
        fatalErrors = lib.fatalErrors,
        runningResult = lib.base.activeResult,
        tests2run = #lib.tests2run > 0 and lib.tests2run or nil,
        suites = lib.suites,
        results = #lib.results > 0 and lib.results or nil
    };

    if (testOk == true) then
        tinsert(successTest, resultSet);
    else 
        tinsert(failedTest, resultSet);
    end
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

    local testOk, error = pcall(callbackFn);

    if (testOk ~= true) then 
        print('|cffff0000Failed|r:', testOk,  error);
    end

    saveTestResult(name, testOk, error);
    resetResults();
end

function assertSame(a, b)
    if (a ~= b) then
        error(tostring(a) .. ' ~= ' .. tostring(b), 2); 
    end
end

function assertType(obj, isType)
    local objType = type(obj) == 'table' and obj.GetObjectType and obj.IsForbidden and obj:IsForbidden() ~= true and obj:GetObjectType() or type(obj);

    if (objType ~= isType and type(obj) ~= isType) then
        error(objType .. '/' .. type(obj) .. ' ~= ' .. tostring(isType), 2); 
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