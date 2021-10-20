--[[
This file includes all base test functionality of the lib like describe, 
it, beforeEach, afterEach.

All methodes are registred in the subtable base in th main lib

--]]

local lib = LibStub:GetLibrary("LibWoWUnit", 1);

-- get all global methodes in local user space

local _G, _L = _G, {};
local debugstack, print, select, type, xpcall = _G.debugstack, _G.print, _G.select, _G.type, _G.xpcall;
local strsplit = _G.strsplit
local ipairs, pairs, tconcat, tinsert, tsort = _G.ipairs, _G.pairs, _G.table.concat, _G.table.insert, _G.table.sort;

lib.base = _L;

-- restrict global environment, so we can't accidentally pollute it
setfenv(1, _L);

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
 Helper function to catch all errors thrown outside test scope

 -- argumnts:
   error:string - error info
   stack:string - stacktrace (optional)

 -- returns:
    nil
--]]
function catchRuntimeError(msg)
    local test = lib.results[#lib.results];

    test.errors = test.errors or {};

	table.insert(test.errors, {msg, debugstack(2)});
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
    local suite, name, callbackFn;

    if (select('#', ...) == 3) then
        suite, name, callbackFn = ...;
    else
        if (select('#', ...) == 2) then
            name, callbackFn = ...;
        else
            if (select('#', ...) == 1) then
                callbackFn = 'anonymous describe', ...;
            end
        end
    end
    
	local current = createDescribe(name);
    
    if (outerDescribe == nil) then
        current.suite = getSuiteName(suite);
    end
	
	current.parent = outerDescribe;

    if (state == 'Skipped' or (outerDescribe and outerDescribe.state == 'Skipped')) then
        current.state = 'Skipped';
    else
        if (state == 'Forced' or (outerDescribe and outerDescribe.state == 'Forced')) then
            current.state = 'Forced';
        end
    end
	
	outerDescribe = current;
	
	xpcall(callbackFn, catchOutsideError);
	
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
	local suite, name, callbackFn, test, parent;

    if (select('#', ...) == 3) then
        suite, name, callbackFn = ...;
    else
        if (select('#', ...) == 2) then
            name, callbackFn = ...;
        else
            if (select('#', ...) == 1) then
                callbackFn = 'anonymous it', ...;
            end
        end
    end

    test = createIt(name);
    test.callbackFn = callbackFn;

	parent = outerDescribe;

    if (state == 'Skipped' or (parent and parent.state == 'Skipped')) then
        test.state = 'Skipped';
    else
        if (state == 'Forced' or (parent and parent.state == 'Forced')) then
            test.state = 'Forced';
        end
    end

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

    if (lib.suites[suite] == nil) then
        lib.suites[suite] = {};
    end

	tinsert(lib.suites[suite], test);
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

--[[
 run all tests in all test suites

 -- argumnts:

 -- returns:
    nil
--]]
function runTests()
    for suite in pairs(lib.suites) do
        runTestSuite(suite);
    end

    tsort(lib.results, function(a, b)
        local namesA = lib.suites[a.suite][a.index].names;
        local namesB = lib.suites[b.suite][b.index].names;

        return tconcat(namesA, ' -> ') < tconcat(namesB, ' -> ');
    end)

end

--[[
 run all tests in a specific test suite

 -- argumnts:
   suite:string - suite name to test in

 -- returns:
    nil
--]]
function runTestSuite(suite)
	local forcesTests = hasForcedTests(suite);

	for index, test in ipairs(lib.suites[suite]) do
		local runningTest = {
            ['expects'] = 0,
            ['index'] = index,
            ['result'] = 'Risky',
            ['suite'] = suite,
        };

	    tinsert(lib.results, runningTest);
		
        if (test.state == 'Skipped') then
            runningTest.result = 'Skipped';
        else
            if (forcesTests and test.state ~= 'Forced') then
                runningTest.result = 'Skipped-Implicit';
            else
                if (forcesTests and test.state == 'Forced') then
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
                end
            end
		end
		
		if (runningTest.errors) then
            runningTest.result = 'Error';
        else
            if (runningTest.failures) then
                runningTest.result = 'Failed';
            end
        end
	end
end

_G['it'] = function(...) it('Normal', ...); end;
_G['fit'] = function(...) it('Forced', ...); end;
_G['xit'] = function(...) it('Skipped', ...); end;
_G['describe'] = function(...) describe('Normal', ...) end;
_G['fdescribe'] = function(...) describe('Forced', ...) end;
_G['xdescribe'] = function(...) describe('Skipped', ...) end;
_G['beforeEach'] = function(...) beforeEach(...) end;
_G['afterEach'] = function(...) afterEach(...) end;
