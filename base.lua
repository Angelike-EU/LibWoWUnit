--[[
This file includes all base test functionality of the lib like describe, 
it, beforeEach, afterEach.

All methodes are registred in the subtable base in th main lib

--]]

local lib = LibStub:GetLibrary("LibWoWUnit", 1);

-- get all global methodes in local user space

local _G, _L = _G, lib.base or {};
local debugstack, error, pcall, print, select, type, xpcall = _G.debugstack, error, pcall, _G.print, _G.select, _G.type, _G.xpcall;
local strsplit, tostring = _G.strsplit, tostring;
local CopyTable, ipairs, pairs, tconcat, tinsert, tremove, tsort = CopyTable, _G.ipairs, _G.pairs, _G.table.concat, _G.table.insert, table.remove, _G.table.sort;
local getmetatable, setmetatable = getmetatable, setmetatable;

lib.base = _L;

-- restrict global environment, so we can't accidentally pollute it
setfenv(1, _L);

testStates = {
    ["Forced"] = 5,
    ["Semi-Forced"] = 4,
    ["Normal"] = 3,
    ["Semi-Skipped"] = 2,
    ["Skipped"] = 1,
    ["Ignore"] = 0
}

-- define module vars
outerDescribe = nil;
file = debugstack(1, 1, 1):match('[Ii]nterface[^\'"]+');
test2build = {};
activeResult = nil;

--[[
 Helper function to catch all errors thrown outside test scope

 -- argumnts:
   error:string - error info
   stack:string - stacktrace (optional)

 -- returns:
    nil
--]]
function catchOutsideError(e)
    lib.fatalErrors = lib.fatalErrors or {};
    tinsert(lib.fatalErrors, e)
end

--[[
 Helper function to catch all errors thrown inside tests

 -- argumnts:
   error:string - error info
   stack:string - stacktrace (optional)

 -- returns:
    nil
--]]
function catchRuntimeError(msg, stack)
    stack = stack and stack or debugstack(2)

    activeResult.errors = activeResult.errors or {};

	tinsert(activeResult.errors, {msg, strsplit('\n', stack)});
end

--[[
 Helper function to get the current suite name

 -- argumnts:
   name:string/nil - Name of the suite

 -- returns:
    name:string - the name of the actual test suite
--]]
function getSuiteName(name)
    if (type(name) == 'string') then
        return name;
    end

    for _, path in ipairs({strsplit('\n', debugstack())}) do
        if (path:match(file) == nil) then
            return path:match('[Ii]nterface[^%w]+[Aa]dd[Oo]ns[^%w]+([%w_-]+)') or 'Global';
        end
    end

    return 'Global';
end

function normalizeBlockParams(...)
    if (select('#', ...) == 3) then
        return ...;
    end

    if (select('#', ...) == 2) then
        return nil, ...;
    end

    if (select('#', ...) == 1) then
        return nil, '', ...;
    end
end

function getState(state, parentState)
    local pState = parentState and testStates[parentState] ~= nil and parentState or 'Normal';

    if (state == 'Skipped' or state == 'Ignore') then
        return state;
    end

    if (testStates[pState] < testStates.Normal) then
        return 'Semi-Skipped';
    end

    if (state == 'Forced' and testStates[pState] >= testStates.Normal ) then
        return 'Forced';
    end

    if (testStates[pState] > testStates.Normal and testStates[state] >= testStates.Normal) then
        return 'Semi-Forced';
    end

    return 'Normal';
end

--[[---------------------------------------------------------------------------
 builds an test object that can be runned by the runner

 -- argumnts:
   testData:table - information about the test data

 -- returns:
    nil
-----------------------------------------------------------------------------]]
function buildTestObject(testData)
    if (type(testData) ~= 'table') then
        return;
    end

    local test, parent = createIt(), testData;

    test.callbackFn = testData.callbackFn;
    test.state = getState(testData.state, testData.parent and testData.parent.state);

	while (parent) do
		tinsert(test.names, 1, parent.name);
		
        if (parent.beforeEach) then
            test.before = test.before or {};
            for k, v in ipairs(parent.beforeEach) do 
                tinsert(test.before, k, v)
            end
        end
		
        if (parent.afterEach) then
            test.after = test.after or {};
            for k, v in ipairs(parent.afterEach) do 
                tinsert(test.after, v)
            end
		end

		if (parent.parent == nil and suite == nil) then
            suite = parent.suite;              
        end

        if (parent.parent == nil) then
            break;
        end

		parent = parent.parent;
	end

    test.suite = getSuiteName(parent.suite);
    tinsert(test.names, 1, test.suite);

    if (lib.suites[test.suite] == nil) then
        lib.suites[test.suite] = {};
    end

    test.index = #lib.suites[test.suite] + 1;

	tinsert(lib.suites[test.suite], test);
	tinsert(lib.tests2run, test);
end

--[[
 Helper function to create a data object for describes

 -- argumnts:
   name:string - Name of the describe block

 -- returns:
    data:table - a data object with all tables for each run
--]]
function createDescribe(name)
	return {
		['state'] = 'Normal',
		['name'] = name
	}
end

--[[
 A function to arrange and group your test code

 -- argumnts:
   suite:string - Name of the current test suite. If not set the name will be auto detected
   name:string - Name of the describe block
   callbackFn:function - function that contains other test relevent callbacks (it, describe, before-/afterEach)

 -- returns:
    nil
--]]
function describe(state, ...)
	local suite, name, callbackFn = normalizeBlockParams(...);
	local currentDescribe, numTestsBefore = createDescribe(name), #test2build;
    local stack = debugstack(2);

    if (type(callbackFn) ~= 'function') then
        tinsert(test2build, {
            ['callbackFn'] = function()
                catchRuntimeError('describe must have at least one callback function!', stack);
            end,
            ['name'] = '#Generated: Invalid callback function!',
            ['parent'] = currentDescribe,
            ['state'] = 'Ignore',
            ['suite'] = getSuiteName(suite),
        });
        callbackFn = function() end;
    end
    
	currentDescribe.parent = outerDescribe;
    currentDescribe.name = name and name or '';
    currentDescribe.state = getState(state, outerDescribe and outerDescribe.state);
    currentDescribe.suite = suite;

	outerDescribe = currentDescribe;
	
	local success, msg = pcall(callbackFn);

	outerDescribe = currentDescribe.parent;

    if (success ~= true) then
        tinsert(test2build, {
            ['callbackFn'] = function()
                catchRuntimeError(msg, stack);
            end,
            ['name'] = '#Generated: Error in callback function!',
            ['parent'] = currentDescribe,
            ['state'] = 'Ignore',
            ['suite'] = getSuiteName(suite),
        });
    end

    if (numTestsBefore == #test2build) then
        tinsert(test2build, {
            ['callbackFn'] = function()
                catchRuntimeError('describe must contain at least one test!', stack);
            end,
            ['name'] = '#Generated: No tests found in describe!',
            ['parent'] = currentDescribe,
            ['state'] = 'Ignore',
            ['suite'] = getSuiteName(suite),
        });
    end

    if (outerDescribe == nil) then
        while (#test2build > 0) do
            buildTestObject(tremove(test2build, 1));
        end 
    end
end

--[[
 Helper function to create a data object for a test

 -- argumnts:
   name:string - Name of the it block

 -- returns:
    data:table - a data object with all tables for each run
--]]
function createIt()
	return {
		['names'] = {},
		['state'] = 'Normal',
	}
end

--[[
 A function that includes your test code

 -- argumnts:
   suite:string - Name of the current test suite. If not set the name will be auto detected
   name:string - Name of the describe block
   callbackFn:function - function that contains other test relevent callbacks (it, describe, before-/afterEach)

 -- returns:
    nil
--]]
function it(state, ...)
	local suite, name, callbackFn = normalizeBlockParams(...);

    if (type(callbackFn) ~= 'function') then
        local stack = debugstack(2);

        callbackFn = function()
            catchRuntimeError('it must have at least one callback function!', stack);
        end
        name = '#Generated: Invalid callback function!';
        state = 'Ignore';
    end

    local testData = {
        ['callbackFn'] = callbackFn,
        ['name'] = name,
        ['parent'] = outerDescribe,
        ['state'] = getState(state, outerDescribe and outerDescribe.state),
        ['suite'] = getSuiteName(suite),
    };

    if (outerDescribe == nil) then
        return buildTestObject(testData);
    end

    tinsert(test2build, testData);
end

--[[
 A function that is called before each test. Only valid in describe blocks

 -- argumnts:
   callbackFn:function - function that is called

 -- returns:
    nil
--]]
function beforeEach(callbackFn)
	if (outerDescribe == nil) then
		return catchOutsideError('beforeEach can only be called within describe blocks!');
	end

    if (type(callbackFn) ~= 'function') then
        local stack = debugstack(2);
        callbackFn = function()
            catchRuntimeError('beforeEach must have a callback function!', stack);
        end
	end

    if (outerDescribe.beforeEach == nil) then
        outerDescribe.beforeEach = {};
    end

	tinsert(outerDescribe.beforeEach, callbackFn);
end

--[[
 A function that is called after each test. Only valid in describe blocks

 -- argumnts:
   callbackFn:function - function that is called

 -- returns:
    nil
--]]
function afterEach(callbackFn)
	if (outerDescribe == nil) then
		return catchOutsideError('afterEach can only be called within describe blocks!');
	end

    if (type(callbackFn) ~= 'function') then
        local stack = debugstack(2);
        callbackFn = function()
            catchRuntimeError('afterEach must have a callback function!', stack);
        end
	end

    if (outerDescribe.afterEach == nil) then
        outerDescribe.afterEach = {};
    end

	tinsert(outerDescribe.afterEach, callbackFn);
end

--[[
 gets the maximum run state of a suite

 -- argumnts:
   suite:string - suite name to search in

 -- returns:
    result:string - run level for suite
--]]
function getSuiteState(suite)
    local maxRunState = 'Normal';

	for _, test in ipairs(lib.suites[suite]) do
        if (testStates[test.state] > testStates[maxRunState]) then
            maxRunState = test.state;
        end

        if (maxRunState == 'Forced') then
            break;
        end
	end
	
	return maxRunState;
end

--[[---------------------------------------------------------------------------
 - runs a single test and save it's result in the result table

 -- argumnts:
   test:table - suite name to test in

 -- returns:
    nil
-----------------------------------------------------------------------------]]
function runTest(test)
    local currentResult = {
        ['index'] = test.index,
        ['result'] = 'Risky',
        ['suite'] = test.suite,
    };
    local suiteState = getSuiteState(test.suite);

    tinsert(lib.results, currentResult);
    activeResult = currentResult;

    if (testStates[test.state] < testStates[suiteState] and test.state ~= 'Ignore') then
        currentResult.result = test.state == 'Skipped' and test.state or 'Skipped-Implicit';

        return;
    end

    if (test.before) then
        for _, beforeFn in ipairs(test.before) do
            xpcall(beforeFn, catchRuntimeError);
        end
    end

    xpcall(test.callbackFn, catchRuntimeError);

    if (test.after) then
        for _, afterFn in ipairs(test.after) do
            xpcall(afterFn, catchRuntimeError);
        end
    end

    activeResult = nil;

    if (currentResult.errors) then
        currentResult.result = 'Error';

        return
    end

    if (currentResult.failures) then
        currentResult.result = 'Failed';

        return;
    end

    if (currentResult.pendingExpect and #currentResult.pendingExpect == 0) then
        currentResult.result = 'Success';
    end
end

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
metatable to handle expect calls
--]]
local expectMetatable = {
    --[[
    meta method ist executed when the table is called

    -- arguments
    t:table - the table the method was called in
    ...:mixed - the argumets the method was called with, to be passed thoug the matcher method

    -- returns:
        success:boolean - status of the operation
    --]]
    __call = function(t, ...)
        local mt = getmetatable(t);
        local input = mt.input;
        local operator = mt.operator;
        local expectedResult = operator:match('^not') ~= 'not';
        local errors = mt.result.errors or {};

        for k, v in ipairs(mt.result.pendingExpect) do
            if (v == t) then
                tremove(mt.result.pendingExpect, k);
                break;
            end
        end

        if (expectedResult == false) then
            -- delete leading not, correct first char case;
            operator = operator:sub(4, 4):lower() .. operator:sub(5) ;
        end

        if (lib.matcher[operator] == nil) then
            tinsert(errors, 'call an unknown matcher function: ' .. operator);
            mt.result.errors = errors;
            
            return false;
        end

        local result, msg = lib.matcher[operator](input, {...});

        if (result == expectedResult) then
            return true;
        end

        tinsert(errors, 'operator ' .. operator .. ' failed.\n' .. tostring(msg))
        mt.result.errors = errors;

        return false;
    end,
    __index = function(t, name)
        getmetatable(t).operator = name;

        return t;
    end,
    operator = nil,
}

	
function expect(...)
    local mt, t, result = CopyTable(expectMetatable), {}, activeResult or {};

    if (activeResult == nil) then
       catchOutsideError('expect can only called inside a it block!');
    end

    if (select('#', ...) == 0) then
        catchRuntimeError('expect should have at least one paramater!');
    end
    
    setmetatable(t, mt);

    result.pendingExpect = result.pendingExpect or {};
    tinsert(result.pendingExpect, t);

    mt.result = result;
    mt.input = {...};

	return t;
end

_G['it'] = function(...) it('Normal', ...); end;
_G['fit'] = function(...) it('Forced', ...); end;
_G['xit'] = function(...) it('Skipped', ...); end;
_G['describe'] = function(...) describe('Normal', ...) end;
_G['fdescribe'] = function(...) describe('Forced', ...) end;
_G['xdescribe'] = function(...) describe('Skipped', ...) end;
_G['beforeEach'] = function(...) beforeEach(...) end;
_G['afterEach'] = function(...) afterEach(...) end;
_G['expect'] = function(...) return expect(...) end;