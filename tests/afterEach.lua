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

function testAfterEachInGlobalScope()
    assertSame(lib.fatalErrors, nil);
    assertSame(#lib.tests2run, 0);
    assertSame(#lib.results, 0);
    assertSame(lib.base.activeResult, nil);

    result = afterEach(noopFunc);

    assertSame(result, nil);
    assertSame(#lib.fatalErrors, 1);
    assert(lib.fatalErrors[1]:match('afterEach can only be called within describe blocks!') ~= nil);
    assertSame(#lib.tests2run, 0);
    assertSame(#lib.results, 0);
    assertSame(lib.base.activeResult, nil);
end

function testAfterEachInDescribeBlockWithoutParams()
    assertSame(lib.fatalErrors, nil);
    assertSame(#lib.tests2run, 0);
    assertSame(#lib.results, 0);
    assertSame(lib.base.activeResult, nil);

    describe('afterEach describe', function()
        afterEach();

        it(noopFunc);
        fit(noopFunc);
        xit(noopFunc);
    end);

    assertSame(lib.fatalErrors, nil);
    assertSame(#lib.tests2run, 3);
    assertSame(#lib.tests2run[1].after, 1);
    assertSame(#lib.tests2run[2].after, 1);
    assertSame(#lib.tests2run[3].after, 1);
    assertSame(#lib.results, 0);
    assertSame(lib.base.activeResult, nil);
end

function testAfterEachInDescribeBlock()
    local func = function() end;

    assertSame(lib.fatalErrors, nil);
    assertSame(#lib.tests2run, 0);
    assertSame(#lib.results, 0);
    assertSame(lib.base.activeResult, nil);

    describe('afterEach describe', function()
        afterEach(func);

        it(noopFunc);
        fit(noopFunc);
        xit(noopFunc);
    end);

    assertSame(lib.fatalErrors, nil);
    assertSame(#lib.tests2run, 3);
    assertSame(#lib.tests2run[1].after, 1);
    assertSame(lib.tests2run[1].after[1], func);
    assertSame(#lib.tests2run[2].after, 1);
    assertSame(lib.tests2run[2].after[1], func);
    assertSame(#lib.tests2run[3].after, 1);
    assertSame(lib.tests2run[3].after[1], func);
    assertSame(#lib.results, 0);
    assertSame(lib.base.activeResult, nil);
end

function testAfterEachInDescribeWithMiltipleOccurence()
    local func1 = function() end;
    local func2 = function() end;

    assertSame(lib.fatalErrors, nil);
    assertSame(#lib.tests2run, 0);
    assertSame(#lib.results, 0);
    assertSame(lib.base.activeResult, nil);

    describe('afterEach describe', function()
        afterEach(func1);
        afterEach(func2);

        it(noopFunc);
        fit(noopFunc);
        xit(noopFunc);
    end);

    assertSame(lib.fatalErrors, nil);
    assertSame(#lib.tests2run, 3);
    assertSame(#lib.tests2run[1].after, 2);
    assertSame(lib.tests2run[1].after[1], func1);
    assertSame(lib.tests2run[1].after[2], func2);
    assertSame(#lib.tests2run[2].after, 2);
    assertSame(lib.tests2run[2].after[1], func1);
    assertSame(lib.tests2run[2].after[2], func2);
    assertSame(#lib.tests2run[3].after, 2);
    assertSame(lib.tests2run[3].after[1], func1);
    assertSame(lib.tests2run[3].after[2], func2);
    assertSame(#lib.results, 0);
    assertSame(lib.base.activeResult, nil);
end

function testAfterEachInDescribeWithMiltipleOccurenceAfterIt()
    local func1 = function() end;
    local func2 = function() end;

    assertSame(lib.fatalErrors, nil);
    assertSame(#lib.tests2run, 0);
    assertSame(#lib.results, 0);
    assertSame(lib.base.activeResult, nil);

    describe('afterEach describe', function()
        afterEach(func1);

        it(noopFunc);
        fit(noopFunc);
        xit(noopFunc);

        afterEach(func2);
    end);

    assertSame(lib.fatalErrors, nil);
    assertSame(#lib.tests2run, 3);
    assertSame(#lib.tests2run[1].after, 2);
    assertSame(lib.tests2run[1].after[1], func1);
    assertSame(lib.tests2run[1].after[2], func2);
    assertSame(#lib.tests2run[2].after, 2);
    assertSame(lib.tests2run[2].after[1], func1);
    assertSame(lib.tests2run[2].after[2], func2);
    assertSame(#lib.tests2run[3].after, 2);
    assertSame(lib.tests2run[3].after[1], func1);
    assertSame(lib.tests2run[3].after[2], func2);
    assertSame(#lib.results, 0);
    assertSame(lib.base.activeResult, nil);
end

function testAfterEachInDescribeWithMiltipleOccurenceInDiffenrentBlocks()
    local func1 = function() end;
    local func2 = function() end;

    assertSame(lib.fatalErrors, nil);
    assertSame(#lib.tests2run, 0);
    assertSame(#lib.results, 0);
    assertSame(lib.base.activeResult, nil);

    describe('outer describe', function()
        afterEach(func1);

        describe('inner describe', function()
            afterEach(func2);

            it(noopFunc);
            fit(noopFunc);
            xit(noopFunc);
        end);
    end);

    assertSame(lib.fatalErrors, nil);
    assertSame(#lib.tests2run, 3);
    assertSame(#lib.tests2run[1].after, 2);
    assertSame(lib.tests2run[1].after[1], func2);
    assertSame(lib.tests2run[1].after[2], func1);
    assertSame(#lib.tests2run[2].after, 2);
    assertSame(lib.tests2run[2].after[1], func2);
    assertSame(lib.tests2run[2].after[2], func1);
    assertSame(#lib.tests2run[3].after, 2);
    assertSame(lib.tests2run[3].after[1], func2);
    assertSame(lib.tests2run[3].after[2], func1);
    assertSame(#lib.results, 0);
    assertSame(lib.base.activeResult, nil);
end
