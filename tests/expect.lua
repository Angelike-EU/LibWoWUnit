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

setfenv(1, lib.tests);

function testExpectOutsideIt()
    assertSame(lib.fatalErrors, nil);
    assertSame(lib.base.activeResult, nil);

    local returnValue = expect(true).toBe(true);

    assertSame(returnValue, true);
    assertSame(#lib.fatalErrors, 1);
    assert(lib.fatalErrors[1]:match('expect can only called inside a it block!') ~= nil);
    assertSame(lib.base.activeResult, nil);
end;

function testExpectInsideIt()
    local result = {};

    lib.base.activeResult = result;

    assertSame(lib.fatalErrors, nil);

    local returnValue = expect(true).toBeDefined();

    assertSame(returnValue, true);
    assertSame(lib.fatalErrors, nil);
    assertSame(#result.pendingExpect, 0);
    assertSame(result.errors, nil);
end

function testExpectWithoutParam()
    local result = {};

    lib.base.activeResult = result;

    assertSame(lib.fatalErrors, nil);

    local returnValue = expect().toBeDefined();

    assertSame(returnValue, false);
    assertSame(lib.fatalErrors, nil);
    assertSame(#lib.base.activeResult.errors, 2);
    assertSame(#result.pendingExpect, 0);
    assert(result.errors[1][1]:match('expect should have at least one paramater!') ~= nil);
    assert(result.errors[2]:match('operator toBeDefined failed.') ~= nil);
end

function testExpectWithMatcherFails()
    local result = {};

    lib.base.activeResult = result;

    assertSame(lib.fatalErrors, nil);

    local returnValue = expect(true).toBe(false);

    assertSame(returnValue, false);
    assertSame(lib.fatalErrors, nil);
    assertSame(#result.errors, 1);
    assertSame(#result.pendingExpect, 0);
    assert(result.errors[1]:match('operator toBe failed.') ~= nil);
end

function testExpectWithUnknownMatcher()
    local result = {};

    lib.base.activeResult = result;

    assertSame(lib.fatalErrors, nil);

    local returnValue = expect(true).toMatchAnUnknownMatcher();

    assertSame(returnValue, false);
    assertSame(lib.fatalErrors, nil);
    assertSame(#result.errors, 1);
    assertSame(#result.pendingExpect, 0);
    assert(lib.base.activeResult.errors[1]:match('call an unknown matcher function: toMatchAnUnknownMatcher') ~= nil);
end

function testExpectWithUncalledMatcher()
    local result = {};

    lib.base.activeResult = result;

    assertSame(lib.fatalErrors, nil);
    assertSame(type(result.pendingExpect), 'nil');

    local returnValue = expect(true);

    assertSame(type(returnValue), 'table');
    assertSame(lib.fatalErrors, nil);
    assertSame(#result.pendingExpect, 1);
    assertSame(lib.base.activeResult.errors, nil);
end
