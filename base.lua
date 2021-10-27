--[[
This file includes all base test functionality of the lib like describe, 
it, beforeEach, afterEach.

All methodes are registred in the subtable base in th main lib

--]]

local lib = LibStub:GetLibrary("LibWoWUnit", 1);

-- get all global methodes in local user space

local _G, _L = _G, lib.base or {};
local debugstack, print, select, type, xpcall = _G.debugstack, _G.print, _G.select, _G.type, _G.xpcall;
local strsplit, tostring = _G.strsplit, tostring;
local CopyTable, ipairs, pairs, tconcat, tinsert, tsort = CopyTable, _G.ipairs, _G.pairs, _G.table.concat, _G.table.insert, _G.table.sort;
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
}

-- define module vars
outerDescribe = nil;
file = debugstack(1, 1, 1):match('[Ii]nterface[^\'"]+');

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
function catchRuntimeError(msg)
    local test = lib.results[#lib.results];

    test.errors = test.errors or {};

	tinsert(test.errors, {msg, debugstack(2)});
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

local function normalizeBlockParams(...)
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

local function getState(state, parentState)
    local pState = parentState and testStates[parentState] ~= nil and parentState or 'Normal';

    if (state == 'Skipped') then
        return 'Skipped';
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

    if (type(callbackFn) ~= 'function') then
        catchOutsideError('describe must have at least one callback function!');
        
        return;
    end
    
	local current = createDescribe(name);
    local numTestsBefore = #lib.tests2run;
    
    if (outerDescribe == nil) then
        current.suite = getSuiteName(suite);
    end
	
	current.parent = outerDescribe;
    current.state = getState(state, outerDescribe and outerDescribe.state);

	outerDescribe = current;
	
	xpcall(callbackFn, catchOutsideError);

    if (numTestsBefore == #lib.tests2run) then
        catchOutsideError('describe must contain at least one test!');
    end
	
	outerDescribe = current.parent;
end

--[[
 Helper function to create a data object for a test

 -- argumnts:
   name:string - Name of the it block

 -- returns:
    data:table - a data object with all tables for each run
--]]
function createIt(name)
	return {
		['names'] = { name },
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
    local test, parent;
	local suite, name, callbackFn = normalizeBlockParams(...);

    if (type(callbackFn) ~= 'function') then
        if (state == 'Forced') then
            return catchOutsideError('fit must have at least one callback function!');
        end
        if (state == 'Skipped') then
            return catchOutsideError('xit must have at least one callback function!');
        end

        return catchOutsideError('it must have at least one callback function!');
    end

	parent = outerDescribe;

    test = createIt(name);
    test.callbackFn = callbackFn;
    test.state = getState(state, parent and parent.state);

    suite = parent and parent.suite or suite;

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

		parent = parent.parent;
	end

    suite = getSuiteName(suite);
    tinsert(test.names, 1, suite);

    test.suite = suite;

    if (lib.suites[suite] == nil) then
        lib.suites[suite] = {};
    end

    test.index = #lib.suites[suite] + 1;

	tinsert(lib.suites[suite], test);
	tinsert(lib.tests2run, test);
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
		return error('beforeEach can only be called within describe blocks', 2);
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
		return error('afterEach can only be called within describe blocks', 2);
	end

    if (outerDescribe.afterEach == nil) then
        outerDescribe.afterEach = {};
    end

	tinsert(outerDescribe.afterEach, callbackFn);
end

--[[
 detects forced tests in a test suite

 -- argumnts:
   suite:string - suite name to search in

 -- returns:
    result:boolean - true when forced tests are detected, otherwise false
--]]
function hasForcedTests(suite) 
	for _, test in ipairs(lib.suites[suite]) do
        if (test.state == 'Forced') then
            return true;
        end
	end
	
	return false;
end

--[[---------------------------------------------------------------------------
 - runs a single test and save it's result in the result table

 -- argumnts:
   test:table - suite name to test in

 -- returns:
    nil
-----------------------------------------------------------------------------]]
function runTest(test)
    local runningTest = {
        ['expects'] = 0,
        ['index'] = test.index,
        ['result'] = 'Risky',
        ['suite'] = test.suite,
    };

    tinsert(lib.results, runningTest);

    if (test.state == 'Skipped') then
        runningTest.result = 'Skipped';

        return;
    end

    if (forcesTests and test.state ~= 'Forced') then
        runningTest.result = 'Skipped-Implicit';

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

    if (runningTest.errors) then
        runningTest.result = 'Error';

        return
    end

    if (runningTest.failures) then
        runningTest.result = 'Failed';

        return;
    end

    if (runningTest.expects > 0) then
        runningTest.result = 'Success';
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
    nil
    --]]
    __call = function(t, ...)
        local mt = getmetatable(t)
        local input = mt.input;
        local operator = mt.operator;
        local expectedResult = operator:match('^not') ~= 'not';
        local errors = mt.result.errors or {};

        if (expectedResult == false) then
            -- delete leading not, correct first char case;
            operator = operator:sub(4, 4):lower() .. operator:sub(5) ;
        end

        mt.result.expects = mt.result.expects + 1;

        if (lib.matcher[operator] == nil) then
            tinsert(errors, 'call an unknown matcher function: ' .. operator);
            mt.result.errors = errors;
            
            return t;
        end

        local result, msg = lib.matcher[operator](input, ...);

        if (result == expectedResult) then
            return t;
        end

        tinsert(errors, 'operator ' .. operator .. ' failed.\n' .. tostring(msg))
        mt.result.errors = errors;

        return t;
    end,
    __index = function(t, name)
        local mt = getmetatable(t)

        mt.operator = name;

        return setmetatable(t, mt);
    end,
    operator = nil,
}

	
function expect(input)
    if (lib.runningTest == nil) then
        catchOutsideError('expect can only called inside a it block!');
    end

    local mt = CopyTable(expectMetatable);
    mt.result = lib.runningResult or {expects = 0};
    mt.input = input;

	return setmetatable({}, mt);
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