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

function testBeforeEachInGlobalScope()
    assertSame(lib.fatalErrors, nil);
    assertSame(#lib.tests2run, 0);
    assertSame(#lib.results, 0);
    assertSame(lib.base.activeResult, nil);

    result = beforeEach(noopFunc);

    assertSame(result, nil);
    assertSame(#lib.fatalErrors, 1);
    assert(lib.fatalErrors[1]:match('beforeEach can only be called within describe blocks!') ~= nil);
    assertSame(#lib.tests2run, 0);
    assertSame(#lib.results, 0);
    assertSame(lib.base.activeResult, nil);
end

function testBeforeEachInDescribeBlockWithoutParams()
    assertSame(lib.fatalErrors, nil);
    assertSame(#lib.tests2run, 0);
    assertSame(#lib.results, 0);
    assertSame(lib.base.activeResult, nil);

    describe('beforeEach describe', function()
        beforeEach();

        it(noopFunc);
        fit(noopFunc);
        xit(noopFunc);
    end);

    assertSame(lib.fatalErrors, nil);
    assertSame(#lib.tests2run, 3);
    assertSame(#lib.tests2run[1].before, 1);
    assertSame(#lib.tests2run[2].before, 1);
    assertSame(#lib.tests2run[3].before, 1);
    assertSame(#lib.results, 0);
    assertSame(lib.base.activeResult, nil);
end

function testBeforeEachInDescribeBlock()
    local func = function() end;

    assertSame(lib.fatalErrors, nil);
    assertSame(#lib.tests2run, 0);
    assertSame(#lib.results, 0);
    assertSame(lib.base.activeResult, nil);

    describe('beforeEach describe', function()
        beforeEach(func);

        it(noopFunc);
        fit(noopFunc);
        xit(noopFunc);
    end);

    assertSame(lib.fatalErrors, nil);
    assertSame(#lib.tests2run, 3);
    assertSame(#lib.tests2run[1].before, 1);
    assertSame(lib.tests2run[1].before[1], func);
    assertSame(#lib.tests2run[2].before, 1);
    assertSame(lib.tests2run[2].before[1], func);
    assertSame(#lib.tests2run[3].before, 1);
    assertSame(lib.tests2run[3].before[1], func);
    assertSame(#lib.results, 0);
    assertSame(lib.base.activeResult, nil);
end

function testBeforeEachInDescribeWithMiltipleOccurence()
    local func1 = function() end;
    local func2 = function() end;

    assertSame(lib.fatalErrors, nil);
    assertSame(#lib.tests2run, 0);
    assertSame(#lib.results, 0);
    assertSame(lib.base.activeResult, nil);

    describe('beforeEach describe', function()
        beforeEach(func1);
        beforeEach(func2);

        it(noopFunc);
        fit(noopFunc);
        xit(noopFunc);
    end);

    assertSame(lib.fatalErrors, nil);
    assertSame(#lib.tests2run, 3);
    assertSame(#lib.tests2run[1].before, 2);
    assertSame(lib.tests2run[1].before[1], func1);
    assertSame(lib.tests2run[1].before[2], func2);
    assertSame(#lib.tests2run[2].before, 2);
    assertSame(lib.tests2run[2].before[1], func1);
    assertSame(lib.tests2run[2].before[2], func2);
    assertSame(#lib.tests2run[3].before, 2);
    assertSame(lib.tests2run[3].before[1], func1);
    assertSame(lib.tests2run[3].before[2], func2);
    assertSame(#lib.results, 0);
    assertSame(lib.base.activeResult, nil);
end

function testBeforeEachInDescribeWithMiltipleOccurenceAfterIt()
    local func1 = function() end;
    local func2 = function() end;

    assertSame(lib.fatalErrors, nil);
    assertSame(#lib.tests2run, 0);
    assertSame(#lib.results, 0);
    assertSame(lib.base.activeResult, nil);

    describe('beforeEach describe', function()
        beforeEach(func1);

        it(noopFunc);
        fit(noopFunc);
        xit(noopFunc);

        beforeEach(func2);
    end);

    assertSame(lib.fatalErrors, nil);
    assertSame(#lib.tests2run, 3);
    assertSame(#lib.tests2run[1].before, 2);
    assertSame(lib.tests2run[1].before[1], func1);
    assertSame(lib.tests2run[1].before[2], func2);
    assertSame(#lib.tests2run[2].before, 2);
    assertSame(lib.tests2run[2].before[1], func1);
    assertSame(lib.tests2run[2].before[2], func2);
    assertSame(#lib.tests2run[3].before, 2);
    assertSame(lib.tests2run[3].before[1], func1);
    assertSame(lib.tests2run[3].before[2], func2);
    assertSame(#lib.results, 0);
    assertSame(lib.base.activeResult, nil);
end

function testBeforeEachInDescribeWithMiltipleOccurenceInDiffenrentBlocks()
    local func1 = function() end;
    local func2 = function() end;

    assertSame(lib.fatalErrors, nil);
    assertSame(#lib.tests2run, 0);
    assertSame(#lib.results, 0);
    assertSame(lib.base.activeResult, nil);

    describe('outer describe', function()
        beforeEach(func1);

        describe('inner describe', function()
            beforeEach(func2);

            it(noopFunc);
            fit(noopFunc);
            xit(noopFunc);
        end);
    end);

    assertSame(lib.fatalErrors, nil);
    assertSame(#lib.tests2run, 3);
    assertSame(#lib.tests2run[1].before, 2);
    assertSame(lib.tests2run[1].before[1], func1);
    assertSame(lib.tests2run[1].before[2], func2);
    assertSame(#lib.tests2run[2].before, 2);
    assertSame(lib.tests2run[2].before[1], func1);
    assertSame(lib.tests2run[2].before[2], func2);
    assertSame(#lib.tests2run[3].before, 2);
    assertSame(lib.tests2run[3].before[1], func1);
    assertSame(lib.tests2run[3].before[2], func2);
    assertSame(#lib.results, 0);
    assertSame(lib.base.activeResult, nil);
end
