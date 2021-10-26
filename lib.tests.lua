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

local assert = assert;
local wipe = wipe;
local describe, expect, it = describe, expect, it;

setfenv(1, {});

local function resetResults()
    lib.fatalErrors = nil;
    lib.runningResult = nil;
    lib.runningTest = nil;
    wipe(lib.tests2run);
    wipe(lib.suites);
end

local function noop()
end

--[[
test expect outside, which is invalid and should log an fatal error
--]]
resetResults();

assert(lib.fatalErrors == nil);
assert(#lib.tests2run == 0);
assert(#lib.results == 0);
assert(lib.runningResult == nil);
assert(lib.runningTest == nil);

result = expect(true).toBe(true);

assert(result ~= nil);
assert(#lib.fatalErrors == 1);
assert(lib.fatalErrors[1]:match('expect can only called inside a it block!') ~= nil);
assert(#lib.tests2run == 0);
assert(#lib.results == 0);
assert(lib.runningResult == nil);
assert(lib.runningTest == nil);

--[[
test expect inside, which is valid and should not log any errors
--]]

resetResults();

lib.runningTest = {};
lib.runningResult = {expects = 0};

assert(lib.fatalErrors == nil);
assert(#lib.tests2run == 0);
assert(#lib.results == 0);
assert(lib.runningResult ~= nil);
assert(lib.runningTest ~= nil);

result = expect(true).toBe(true);

assert(lib.fatalErrors == nil);
assert(#lib.tests2run == 0);
assert(#lib.results == 0);
assert(lib.runningResult ~= nil);
assert(lib.runningResult.expects == 1);
assert(lib.runningResult.errors == nil);
assert(lib.runningTest ~= nil);

--[[
test expect inside, which is valid and should not log an errors becaus matcher failed
--]]

resetResults();

lib.runningTest = {};
lib.runningResult = {expects = 0};

assert(lib.fatalErrors == nil);
assert(#lib.tests2run == 0);
assert(#lib.results == 0);
assert(lib.runningResult ~= nil);
assert(lib.runningTest ~= nil);

result = expect(true).toBe(false);

assert(lib.fatalErrors == nil);
assert(#lib.tests2run == 0);
assert(#lib.results == 0);
assert(lib.runningResult ~= nil);
assert(lib.runningResult.expects == 1);
assert(#lib.runningResult.errors == 1);
assert(lib.runningResult.errors[1]:match('operator toBe failed.') ~= nil);
assert(lib.runningTest ~= nil);

--[[
test expect inside, call an unknown matcher, should log an error
--]]

resetResults();

lib.runningTest = {};
lib.runningResult = {expects = 0};

assert(lib.fatalErrors == nil);
assert(#lib.tests2run == 0);
assert(#lib.results == 0);
assert(lib.runningResult ~= nil);
assert(lib.runningTest ~= nil);

result = expect(true).toMatchAnUnknownMatcher();

assert(lib.fatalErrors == nil);
assert(#lib.tests2run == 0);
assert(#lib.results == 0);
assert(lib.runningResult ~= nil);
assert(lib.runningResult.expects == 1);
assert(#lib.runningResult.errors == 1);
assert(lib.runningResult.errors[1]:match('call an unknown matcher function: toMatchAnUnknownMatcher') ~= nil);
assert(lib.runningTest ~= nil);

--[[
test it in global environment, nothing set
--]]

resetResults();

assert(lib.fatalErrors == nil);
assert(#lib.tests2run == 0);
assert(#lib.results == 0);
assert(lib.runningResult == nil);
assert(lib.runningTest == nil);

it();

assert(#lib.fatalErrors == 1);
assert(lib.fatalErrors[1]:match('it must have at least one callback function!') ~= nil);
assert(#lib.tests2run == 0);
assert(#lib.results == 0);
assert(lib.runningResult == nil);
assert(lib.runningTest == nil);

--[[
test it in global environment, all anonymous
--]]

resetResults();

assert(lib.fatalErrors == nil);
assert(#lib.tests2run == 0);
assert(#lib.results == 0);
assert(lib.runningResult == nil);
assert(lib.runningTest == nil);

it(noop);

assert(lib.fatalErrors == nil);
assert(#lib.tests2run == 1);
assert(lib.tests2run[1].state == 'Normal');
assert(lib.tests2run[1].index == 1);
assert(lib.tests2run[1].suite == 'LibWoWUnit');
assert(#lib.tests2run[1].names == 2);
assert(lib.tests2run[1].names[1] == 'LibWoWUnit');
assert(lib.tests2run[1].names[2] == '');
assert(#lib.results == 0);
assert(lib.runningResult == nil);
assert(lib.runningTest == nil);

--[[
test it in global environment, only name set
--]]

resetResults();

assert(lib.fatalErrors == nil);
assert(#lib.tests2run == 0);
assert(#lib.results == 0);
assert(lib.runningResult == nil);
assert(lib.runningTest == nil);

it('name of test', noop);

assert(lib.fatalErrors == nil);
assert(#lib.tests2run == 1);
assert(lib.tests2run[1].state == 'Normal');
assert(lib.tests2run[1].index == 1);
assert(lib.tests2run[1].suite == 'LibWoWUnit');
assert(#lib.tests2run[1].names == 2);
assert(lib.tests2run[1].names[1] == 'LibWoWUnit');
assert(lib.tests2run[1].names[2] == 'name of test');
assert(#lib.results == 0);
assert(lib.runningResult == nil);
assert(lib.runningTest == nil);

--[[
test it in global environment, suite, name and fn set
--]]

resetResults();

assert(lib.fatalErrors == nil);
assert(#lib.tests2run == 0);
assert(#lib.results == 0);
assert(lib.runningResult == nil);
assert(lib.runningTest == nil);

it('name of suite', 'name of test', noop);

assert(lib.fatalErrors == nil);
assert(#lib.tests2run == 1);
assert(lib.tests2run[1].state == 'Normal');
assert(lib.tests2run[1].index == 1);
assert(lib.tests2run[1].suite == 'name of suite');
assert(#lib.tests2run[1].names == 2);
assert(lib.tests2run[1].names[1] == 'name of suite');
assert(lib.tests2run[1].names[2] == 'name of test');
assert(#lib.results == 0);
assert(lib.runningResult == nil);
assert(lib.runningTest == nil);


--[[
test describe in global environment, nothing set
--]]

resetResults();

assert(lib.fatalErrors == nil);
assert(#lib.tests2run == 0);
assert(#lib.results == 0);
assert(lib.runningResult == nil);
assert(lib.runningTest == nil);

describe();

assert(#lib.fatalErrors == 1);
assert(lib.fatalErrors[1]:match('describe must have at least one callback function!') ~= nil);
assert(#lib.tests2run == 0);
assert(#lib.results == 0);
assert(lib.runningResult == nil);
assert(lib.runningTest == nil);

--[[
test describe in global environment, anonymous, not test set
--]]

resetResults();

assert(lib.fatalErrors == nil);
assert(#lib.tests2run == 0);
assert(#lib.results == 0);
assert(lib.runningResult == nil);
assert(lib.runningTest == nil);

describe(noop);

assert(#lib.fatalErrors == 1);
assert(lib.fatalErrors[1]:match('describe must contain at least one test!') ~= nil);
assert(#lib.tests2run == 0);
assert(#lib.results == 0);
assert(lib.runningResult == nil);
assert(lib.runningTest == nil);

--[[
test describe in global environment, anonymous
--]]

resetResults();

assert(lib.fatalErrors == nil);
assert(#lib.tests2run == 0);
assert(#lib.results == 0);
assert(lib.runningResult == nil);
assert(lib.runningTest == nil);

describe(function() 
    it(noop) 
end);

assert(lib.fatalErrors == nil);
assert(#lib.tests2run == 1);
assert(lib.tests2run[1].state == 'Normal');
assert(lib.tests2run[1].index == 1);
assert(lib.tests2run[1].suite == 'LibWoWUnit');
assert(#lib.tests2run[1].names == 3);
assert(lib.tests2run[1].names[1] == 'LibWoWUnit');
assert(lib.tests2run[1].names[2] == '');
assert(lib.tests2run[1].names[3] == '');
assert(#lib.results == 0);
assert(lib.runningResult == nil);
assert(lib.runningTest == nil);

--[[
test describe in global environment, name set
--]]

resetResults();

assert(lib.fatalErrors == nil);
assert(#lib.tests2run == 0);
assert(#lib.results == 0);
assert(lib.runningResult == nil);
assert(lib.runningTest == nil);

describe('name of describe', function() 
    it(noop) 
end);

assert(lib.fatalErrors == nil);
assert(#lib.tests2run == 1);
assert(lib.tests2run[1].state == 'Normal');
assert(lib.tests2run[1].index == 1);
assert(lib.tests2run[1].suite == 'LibWoWUnit');
assert(#lib.tests2run[1].names == 3);
assert(lib.tests2run[1].names[1] == 'LibWoWUnit');
assert(lib.tests2run[1].names[2] == 'name of describe');
assert(lib.tests2run[1].names[3] == '');
assert(#lib.results == 0);
assert(lib.runningResult == nil);
assert(lib.runningTest == nil);

--[[
test describe in global environment, all set
--]]

resetResults();

assert(lib.fatalErrors == nil);
assert(#lib.tests2run == 0);
assert(#lib.results == 0);
assert(lib.runningResult == nil);
assert(lib.runningTest == nil);

describe('name of suite', 'name of describe', function() 
    it(noop) 
end);

assert(lib.fatalErrors == nil);
assert(#lib.tests2run == 1);
assert(lib.tests2run[1].state == 'Normal');
assert(lib.tests2run[1].index == 1);
assert(lib.tests2run[1].suite == 'name of suite');
assert(#lib.tests2run[1].names == 3);
assert(lib.tests2run[1].names[1] == 'name of suite');
assert(lib.tests2run[1].names[2] == 'name of describe');
assert(lib.tests2run[1].names[3] == '');
assert(#lib.results == 0);
assert(lib.runningResult == nil);
assert(lib.runningTest == nil);

--[[
test describe in global environment, all set, test name set
--]]

resetResults();

assert(lib.fatalErrors == nil);
assert(#lib.tests2run == 0);
assert(#lib.results == 0);
assert(lib.runningResult == nil);
assert(lib.runningTest == nil);

describe('name of suite', 'name of describe', function() 
    it('name of it', noop) 
end);

assert(lib.fatalErrors == nil);
assert(#lib.tests2run == 1);
assert(lib.tests2run[1].state == 'Normal');
assert(lib.tests2run[1].index == 1);
assert(lib.tests2run[1].suite == 'name of suite');
assert(#lib.tests2run[1].names == 3);
assert(lib.tests2run[1].names[1] == 'name of suite');
assert(lib.tests2run[1].names[2] == 'name of describe');
assert(lib.tests2run[1].names[3] == 'name of it');
assert(#lib.results == 0);
assert(lib.runningResult == nil);
assert(lib.runningTest == nil);

--[[
test describe in global environment, all set, test name set
--]]

resetResults();

assert(lib.fatalErrors == nil);
assert(#lib.tests2run == 0);
assert(#lib.results == 0);
assert(lib.runningResult == nil);
assert(lib.runningTest == nil);

describe('suite of describe', 'name of describe', function() 
    it('suite of it', 'name of it', noop) 
end);

assert(lib.fatalErrors == nil);
assert(#lib.tests2run == 1);
assert(lib.tests2run[1].state == 'Normal');
assert(lib.tests2run[1].index == 1);
assert(lib.tests2run[1].suite == 'suite of describe');
assert(#lib.tests2run[1].names == 3);
assert(lib.tests2run[1].names[1] == 'suite of describe');
assert(lib.tests2run[1].names[2] == 'name of describe');
assert(lib.tests2run[1].names[3] == 'name of it');
assert(#lib.results == 0);
assert(lib.runningResult == nil);
assert(lib.runningTest == nil);

