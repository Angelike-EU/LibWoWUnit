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

function testRunWithDescribeAndFailingTests()
    assertSame(lib.fatalErrors, nil);
    assertSame(#lib.tests2run, 0);
    assertSame(#lib.results, 0);

    describe(function()
        it(function() expect(nil).toBeDefined(); end);
        fit(function() expect(nil).toBeDefined(); end);
        xit(function() expect(nil).toBeDefined(); end);
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
    assertSame(lib.results[2].result, 'Error');
    assertSame(lib.results[2].expects, 1);
    assertSame(lib.results[3].result, 'Skipped');
    assertSame(lib.results[3].expects, 0);
end

function testRunWithMultipleDescribeAndValidTests()
    assertSame(lib.fatalErrors, nil);
    assertSame(#lib.tests2run, 0);
    assertSame(#lib.results, 0);

    describe(function()
        it(function() expect(true).toBeDefined(); end);
        fit(function() expect(true).toBeDefined(); end);
        xit(function() expect(true).toBeDefined(); end);
    end);
    fdescribe(function()
        it(function() expect(true).toBeDefined(); end);
        fit(function() expect(true).toBeDefined(); end);
        xit(function() expect(true).toBeDefined(); end);
    end);
    xdescribe(function()
        it(function() expect(true).toBeDefined(); end);
        fit(function() expect(true).toBeDefined(); end);
        xit(function() expect(true).toBeDefined(); end);
    end);

    assertSame(lib.fatalErrors, nil);
    assertSame(#lib.tests2run, 9);
    assertSame(#lib.results, 0);

    runAllTests();

    assertSame(lib.fatalErrors, nil);
    assertSame(#lib.tests2run, 0);
    assertSame(#lib.results, 9);
    assertSame(lib.results[1].result, 'Skipped-Implicit');
    assertSame(lib.results[1].expects, 0);
    assertSame(lib.results[2].result, 'Success');
    assertSame(lib.results[2].expects, 1);
    assertSame(lib.results[3].result, 'Skipped');
    assertSame(lib.results[3].expects, 0);
    assertSame(lib.results[4].result, 'Skipped-Implicit');
    assertSame(lib.results[4].expects, 0);
    assertSame(lib.results[5].result, 'Success');
    assertSame(lib.results[5].expects, 1);
    assertSame(lib.results[6].result, 'Skipped');
    assertSame(lib.results[6].expects, 0);
    assertSame(lib.results[7].result, 'Skipped-Implicit');
    assertSame(lib.results[7].expects, 0);
    assertSame(lib.results[8].result, 'Skipped-Implicit');
    assertSame(lib.results[8].expects, 0);
    assertSame(lib.results[9].result, 'Skipped');
    assertSame(lib.results[9].expects, 0);
end

function testRunWithMultipleDescribeExecutionOrder()
    assertSame(lib.fatalErrors, nil);
    assertSame(#lib.tests2run, 0);
    assertSame(#lib.results, 0);

    local expectedOrder = {
        'callback outer describe',
        'callback inner describe',
        'callback inner fdescribe',
        'callback inner xdescribe',
        "beforeEach outer top",
        "beforeEach outer bottom",
        "beforeEach inner describe top",
        "beforeEach inner describe bottom",
        "fit inner describe",
        "afterEach inner describe top",
        "afterEach inner describe bottom",
        "afterEach outer top",
        "afterEach outer bottom",
        "beforeEach outer top",
        "beforeEach outer bottom",
        "beforeEach inner fdescribe top",
        "beforeEach inner fdescribe bottom",
        "fit inner fdescribe",
        "afterEach inner fdescribe top",
        "afterEach inner fdescribe bottom",
        "afterEach outer top",
        "afterEach outer bottom",
        "beforeEach outer top",
        "beforeEach outer bottom",
        "fit outer describe",
        "afterEach outer top",
        "afterEach outer bottom",
    };


    local excecutedOrder = {};

    describe(function()
        tinsert(excecutedOrder, 'callback outer describe');

        beforeEach(function() tinsert(excecutedOrder, 'beforeEach outer top'); end)
        afterEach(function() tinsert(excecutedOrder, 'afterEach outer top'); end)

        describe(function()
            tinsert(excecutedOrder, 'callback inner describe');

            beforeEach(function() tinsert(excecutedOrder, 'beforeEach inner describe top'); end)
            afterEach(function() tinsert(excecutedOrder, 'afterEach inner describe top'); end)
            it(function() tinsert(excecutedOrder, 'it inner describe'); end);
            fit(function() tinsert(excecutedOrder, 'fit inner describe'); end);
            xit(function() tinsert(excecutedOrder, 'xit inner describe'); end);
            beforeEach(function() tinsert(excecutedOrder, 'beforeEach inner describe bottom'); end)
            afterEach(function() tinsert(excecutedOrder, 'afterEach inner describe bottom'); end)
        end);

        fdescribe(function()
            tinsert(excecutedOrder, 'callback inner fdescribe');

            beforeEach(function() tinsert(excecutedOrder, 'beforeEach inner fdescribe top'); end)
            afterEach(function() tinsert(excecutedOrder, 'afterEach inner fdescribe top'); end)
            it(function() tinsert(excecutedOrder, 'it inner fdescribe'); end);
            fit(function() tinsert(excecutedOrder, 'fit inner fdescribe'); end);
            xit(function() tinsert(excecutedOrder, 'xit inner fdescribe'); end);
            beforeEach(function() tinsert(excecutedOrder, 'beforeEach inner fdescribe bottom'); end)
            afterEach(function() tinsert(excecutedOrder, 'afterEach inner fdescribe bottom'); end)
        end);

        xdescribe(function()
            tinsert(excecutedOrder, 'callback inner xdescribe');

            beforeEach(function() tinsert(excecutedOrder, 'beforeEach inner xdescribe top'); end)
            afterEach(function() tinsert(excecutedOrder, 'afterEach inner xdescribe top'); end)
            it(function() tinsert(excecutedOrder, 'it inner xdescribe'); end);
            fit(function() tinsert(excecutedOrder, 'fit inner xdescribe'); end);
            xit(function() tinsert(excecutedOrder, 'xit inner xdescribe'); end);
            beforeEach(function() tinsert(excecutedOrder, 'beforeEach inner xdescribe bottom'); end)
            afterEach(function() tinsert(excecutedOrder, 'afterEach inner xdescribe bottom'); end)
        end);

        it(function() tinsert(excecutedOrder, 'it outer describe'); end);
        fit(function() tinsert(excecutedOrder, 'fit outer describe'); end);
        xit(function() tinsert(excecutedOrder, 'xit outer describe'); end);

        beforeEach(function() tinsert(excecutedOrder, 'beforeEach outer bottom'); end)
        afterEach(function() tinsert(excecutedOrder, 'afterEach outer bottom'); end)
    end);

    assertSame(lib.fatalErrors, nil);
    assertSame(#lib.tests2run, 12);
    assertSame(#lib.results, 0);
    assertSame(#excecutedOrder, 4);

    runAllTests();

    assertSame(lib.fatalErrors, nil);
    assertSame(#lib.tests2run, 0);
    assertSame(#lib.results, 12);
    
    tinsert(lib.results, t);
    
    assertSame(#excecutedOrder, #expectedOrder);

    for i = 1, #expectedOrder, 1 do
        assertSame(excecutedOrder[i], expectedOrder[i]);
    end
end