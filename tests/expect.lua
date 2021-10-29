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
    assertSame(#lib.tests2run, 0);
    assertSame(#lib.results, 0);
    assertSame(lib.base.activeResult, nil);

    result = expect(true).toBe(true);

    assert(result ~= nil);
    assertSame(#lib.fatalErrors, 1);
    assert(lib.fatalErrors[1]:match('expect can only called inside a it block!') ~= nil);
    assertSame(#lib.tests2run, 0);
    assertSame(#lib.results, 0);
    assertSame(lib.base.activeResult, nil);
end;

function testExpectInsideIt()
    lib.base.activeResult = {expects = 0};

    assertSame(lib.fatalErrors, nil);
    assertSame(#lib.tests2run, 0);
    assertSame(#lib.results, 0);
    assert(lib.base.activeResult ~= nil);

    result = expect(true).toBe(true);

    assertSame(lib.fatalErrors, nil);
    assertSame(#lib.tests2run, 0);
    assertSame(#lib.results, 0);
    assert(lib.base.activeResult ~= nil);
    assertSame(lib.base.activeResult.expects, 1);
    assertSame(lib.base.activeResult.errors, nil);
end

function testExpectWithMatcherFails()
    lib.base.activeResult = {expects = 0};

    assertSame(lib.fatalErrors, nil);
    assertSame(#lib.tests2run, 0);
    assertSame(#lib.results, 0);
    assert(lib.base.activeResult ~= nil);

    result = expect(true).toBe(false);

    assertSame(lib.fatalErrors, nil);
    assertSame(#lib.tests2run, 0);
    assertSame(#lib.results, 0);
    assert(lib.base.activeResult ~= nil);
    assertSame(lib.base.activeResult.expects, 1);
    assertSame(#lib.base.activeResult.errors, 1);
    assert(lib.base.activeResult.errors[1]:match('operator toBe failed.') ~= nil);
end

function testExpectWithUnknownMatcher()
    lib.base.activeResult = {expects = 0};

    assertSame(lib.fatalErrors, nil);
    assertSame(#lib.tests2run, 0);
    assertSame(#lib.results, 0);
    assert(lib.base.activeResult ~= nil);

    result = expect(true).toMatchAnUnknownMatcher();

    assertSame(lib.fatalErrors, nil);
    assertSame(#lib.tests2run, 0);
    assertSame(#lib.results, 0);
    assert(lib.base.activeResult ~= nil);
    assertSame(lib.base.activeResult.expects, 1);
    assertSame(#lib.base.activeResult.errors, 1);
    assert(lib.base.activeResult.errors[1]:match('call an unknown matcher function: toMatchAnUnknownMatcher') ~= nil);
end
