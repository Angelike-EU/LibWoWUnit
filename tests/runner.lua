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

local function runAllTests()
    while (#lib.tests2run > 0) do
        lib.base.runTest(tremove(lib.tests2run, 1));
    end
end

function testRunWithEmptyDescribe()
    assertSame(lib.fatalErrors, nil);
    assertSame(#lib.tests2run, 0);
    assertSame(#lib.results, 0);

    describe();

    assertSame(lib.fatalErrors, nil);
    assertSame(#lib.tests2run, 1);
    assertSame(#lib.results, 0);

    runAllTests();

    assertSame(lib.fatalErrors, nil);
    assertSame(#lib.tests2run, 0);
    assertSame(#lib.results, 1);
    assertSame(lib.results[1].result, 'Error');
    assertSame(lib.results[1].errors[1][1], 'describe must have at least one callback function!');
end

function testRunWithDescribeAndNoTest()
    assertSame(lib.fatalErrors, nil);
    assertSame(#lib.tests2run, 0);
    assertSame(#lib.results, 0);

    describe(noopFunc);

    assertSame(lib.fatalErrors, nil);
    assertSame(#lib.tests2run, 1);
    assertSame(#lib.results, 0);

    runAllTests();

    assertSame(lib.fatalErrors, nil);
    assertSame(#lib.tests2run, 0);
    assertSame(#lib.results, 1);
    assertSame(lib.results[1].result, 'Error');
    assertSame(lib.results[1].errors[1][1], 'describe must contain at least one test!');
end

function testRunWithDescribeAndRuntimeError()
    assertSame(lib.fatalErrors, nil);
    assertSame(#lib.tests2run, 0);
    assertSame(#lib.results, 0);

    describe(throwFunc);

    assertSame(lib.fatalErrors, nil);
    assertSame(#lib.tests2run, 1);
    assertSame(#lib.results, 0);

    runAllTests();

    assertSame(lib.fatalErrors, nil);
    assertSame(#lib.tests2run, 0);
    assertSame(#lib.results, 1);
    assertSame(lib.results[1].result, 'Error');
    assert(lib.results[1].errors[1][1]:match('An error thrown in a callback function') ~= nil);
end

function testRunWithDescribeAndEmptyTests()
    assertSame(lib.fatalErrors, nil);
    assertSame(#lib.tests2run, 0);
    assertSame(#lib.results, 0);

    describe(function()
        it();
        fit();
        xit();
    end);

    assertSame(lib.fatalErrors, nil);
    assertSame(#lib.tests2run, 3);
    assertSame(#lib.results, 0);

    runAllTests();

    assertSame(lib.fatalErrors, nil);
    assertSame(#lib.tests2run, 0);
    assertSame(#lib.results, 3);
    assertSame(lib.results[1].result, 'Error');
    assert(lib.results[1].errors[1][1]:match('it must have at least one callback function!') ~= nil);
    assertSame(lib.results[2].result, 'Error');
    assert(lib.results[2].errors[1][1]:match('it must have at least one callback function!') ~= nil);
    assertSame(lib.results[3].result, 'Error');
    assert(lib.results[3].errors[1][1]:match('it must have at least one callback function!') ~= nil);
end

function testRunWithDescribeAndNoopTests()
    assertSame(lib.fatalErrors, nil);
    assertSame(#lib.tests2run, 0);
    assertSame(#lib.results, 0);

    describe(function()
        it(noopFunc);
        fit(noopFunc);
        xit(noopFunc);
    end);

    assertSame(lib.fatalErrors, nil);
    assertSame(#lib.tests2run, 3);
    assertSame(#lib.results, 0);

    runAllTests();

    assertSame(lib.fatalErrors, nil);
    assertSame(#lib.tests2run, 0);
    assertSame(#lib.results, 3);
    assertSame(lib.results[1].result, 'Skipped-Implicit');
    assertSame(lib.results[1].expects, 0);
    assertSame(lib.results[2].result, 'Risky');
    assertSame(lib.results[2].expects, 0);
    assertSame(lib.results[3].result, 'Skipped');
    assertSame(lib.results[3].expects, 0);
end

function testRunWithDescribeAndValidTests()
    assertSame(lib.fatalErrors, nil);
    assertSame(#lib.tests2run, 0);
    assertSame(#lib.results, 0);

    describe(function()
        it(function() expect(true).toBeDefined(); end);
        fit(function() expect(true).toBeDefined(); end);
        xit(function() expect(true).toBeDefined(); end);
    end);

    assertSame(lib.fatalErrors, nil);
    assertSame(#lib.tests2run, 3);
    assertSame(#lib.results, 0);

    runAllTests();

    assertSame(lib.fatalErrors, nil);
    assertSame(#lib.tests2run, 0);
    assertSame(#lib.results, 3);
    assertSame(lib.results[1].result, 'Skipped-Implicit');
    assertSame(lib.results[1].expects, 0);
    assertSame(lib.results[2].result, 'Success');
    assertSame(lib.results[2].expects, 1);
    assertSame(lib.results[3].result, 'Skipped');
    assertSame(lib.results[3].expects, 0);
end
