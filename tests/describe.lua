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

function testDescribeWithoutParameters()
    assertSame(lib.fatalErrors, nil);
    assertSame(#lib.tests2run, 0);
    assertSame(#lib.results, 0);
    assertSame(lib.runningResult, nil);
    assertSame(lib.runningTest, nil);

    describe();

    assertSame(#lib.fatalErrors, 1);
    assert(lib.fatalErrors[1]:match('describe must have at least one callback function!') ~= nil);
    assertSame(#lib.tests2run, 0);
    assertSame(#lib.results, 0);
    assertSame(lib.runningResult, nil);
    assertSame(lib.runningTest, nil);
end

function testDescribeWithoutTestBlock()
    assertSame(lib.fatalErrors, nil);
    assertSame(#lib.tests2run, 0);
    assertSame(#lib.results, 0);
    assertSame(lib.runningResult, nil);
    assertSame(lib.runningTest, nil);

    describe(noopFunc);

    assertSame(#lib.fatalErrors, 1);
    assert(lib.fatalErrors[1]:match('describe must contain at least one test!') ~= nil);
    assertSame(#lib.tests2run, 0);
    assertSame(#lib.results, 0);
    assertSame(lib.runningResult, nil);
    assertSame(lib.runningTest, nil);
end

function testDescribeWithTestBlock()
    assertSame(lib.fatalErrors, nil);
    assertSame(#lib.tests2run, 0);
    assertSame(#lib.results, 0);
    assertSame(lib.runningResult, nil);
    assertSame(lib.runningTest, nil);

    describe(function() 
        it(noopFunc);
        fit(noopFunc);
        xit(noopFunc);
    end);

    assertSame(lib.fatalErrors, nil);
    assertSame(#lib.tests2run, 3);
    assertSame(#lib.results, 0);
    assertSame(lib.runningResult, nil);
    assertSame(lib.runningTest, nil);

    assertSame(lib.tests2run[1].state, 'Normal');
    assertSame(lib.tests2run[1].index, 1);
    assertSame(lib.tests2run[1].suite, 'LibWoWUnit');
    assertSame(#lib.tests2run[1].names, 3);
    assertSame(lib.tests2run[1].names[1], 'LibWoWUnit');
    assertSame(lib.tests2run[1].names[2], '');
    assertSame(lib.tests2run[1].names[3], '');

    assertSame(lib.tests2run[2].state, 'Forced');
    assertSame(lib.tests2run[2].index, 2);
    assertSame(lib.tests2run[2].suite, 'LibWoWUnit');
    assertSame(#lib.tests2run[2].names, 3);
    assertSame(lib.tests2run[2].names[1], 'LibWoWUnit');
    assertSame(lib.tests2run[2].names[2], '');
    assertSame(lib.tests2run[2].names[3], '');

    assertSame(lib.tests2run[3].state, 'Skipped');
    assertSame(lib.tests2run[3].index, 3);
    assertSame(lib.tests2run[3].suite, 'LibWoWUnit');
    assertSame(#lib.tests2run[3].names, 3);
    assertSame(lib.tests2run[3].names[1], 'LibWoWUnit');
    assertSame(lib.tests2run[3].names[2], '');
    assertSame(lib.tests2run[3].names[3], '');
end

function testDescribeWithNameAndTestBlock()
    assertSame(lib.fatalErrors, nil);
    assertSame(#lib.tests2run, 0);
    assertSame(#lib.results, 0);
    assertSame(lib.runningResult, nil);
    assertSame(lib.runningTest, nil);

    describe('name of describe', function() 
        it(noopFunc);
        fit(noopFunc);
        xit(noopFunc);
    end);

    assertSame(lib.fatalErrors, nil);
    assertSame(#lib.tests2run, 3);
    assertSame(#lib.results, 0);
    assertSame(lib.runningResult, nil);
    assertSame(lib.runningTest, nil);

    assertSame(lib.tests2run[1].state, 'Normal');
    assertSame(lib.tests2run[1].index, 1);
    assertSame(lib.tests2run[1].suite, 'LibWoWUnit');
    assertSame(#lib.tests2run[1].names, 3);
    assertSame(lib.tests2run[1].names[1], 'LibWoWUnit');
    assertSame(lib.tests2run[1].names[2], 'name of describe');
    assertSame(lib.tests2run[1].names[3], '');

    assertSame(lib.tests2run[2].state, 'Forced');
    assertSame(lib.tests2run[2].index, 2);
    assertSame(lib.tests2run[2].suite, 'LibWoWUnit');
    assertSame(#lib.tests2run[2].names, 3);
    assertSame(lib.tests2run[2].names[1], 'LibWoWUnit');
    assertSame(lib.tests2run[2].names[2], 'name of describe');
    assertSame(lib.tests2run[2].names[3], '');

    assertSame(lib.tests2run[3].state, 'Skipped');
    assertSame(lib.tests2run[3].index, 3);
    assertSame(lib.tests2run[3].suite, 'LibWoWUnit');
    assertSame(#lib.tests2run[3].names, 3);
    assertSame(lib.tests2run[3].names[1], 'LibWoWUnit');
    assertSame(lib.tests2run[3].names[2], 'name of describe');
    assertSame(lib.tests2run[3].names[3], '');
end

function testDescribeWithSuiteNameAndTestBlock()
    assertSame(lib.fatalErrors, nil);
    assertSame(#lib.tests2run, 0);
    assertSame(#lib.results, 0);
    assertSame(lib.runningResult, nil);
    assertSame(lib.runningTest, nil);

    describe('name of suite', 'name of describe', function() 
        it(noopFunc);
        fit(noopFunc);
        xit(noopFunc);
    end);

    assertSame(lib.fatalErrors, nil);
    assertSame(#lib.tests2run, 3);
    assertSame(#lib.results, 0);
    assertSame(lib.runningResult, nil);
    assertSame(lib.runningTest, nil);
    assertSame(lib.tests2run[1].state, 'Normal');
    assertSame(lib.tests2run[1].index, 1);
    assertSame(lib.tests2run[1].suite, 'name of suite');
    assertSame(#lib.tests2run[1].names, 3);
    assertSame(lib.tests2run[1].names[1], 'name of suite');
    assertSame(lib.tests2run[1].names[2], 'name of describe');
    assertSame(lib.tests2run[1].names[3], '');

    assertSame(lib.tests2run[2].state, 'Forced');
    assertSame(lib.tests2run[2].index, 2);
    assertSame(lib.tests2run[2].suite, 'name of suite');
    assertSame(#lib.tests2run[2].names, 3);
    assertSame(lib.tests2run[2].names[1], 'name of suite');
    assertSame(lib.tests2run[2].names[2], 'name of describe');
    assertSame(lib.tests2run[2].names[3], '');

    assertSame(lib.tests2run[3].state, 'Skipped');
    assertSame(lib.tests2run[3].index, 3);
    assertSame(lib.tests2run[3].suite, 'name of suite');
    assertSame(#lib.tests2run[3].names, 3);
    assertSame(lib.tests2run[3].names[1], 'name of suite');
    assertSame(lib.tests2run[3].names[2], 'name of describe');
    assertSame(lib.tests2run[3].names[3], '');
end

function testDescribeWithSuiteNameAndTestNameBlock()
    assertSame(lib.fatalErrors, nil);
    assertSame(#lib.tests2run, 0);
    assertSame(#lib.results, 0);
    assertSame(lib.runningResult, nil);
    assertSame(lib.runningTest, nil);

    describe('name of suite', 'name of describe', function() 
        it('name of it', noopFunc) 
        fit('name of fit', noopFunc) 
        xit('name of xit', noopFunc) 
    end);

    assertSame(lib.fatalErrors, nil);
    assertSame(#lib.tests2run, 3);
    assertSame(#lib.results, 0);
    assertSame(lib.runningResult, nil);
    assertSame(lib.runningTest, nil);

    assertSame(lib.tests2run[1].state, 'Normal');
    assertSame(lib.tests2run[1].index, 1);
    assertSame(lib.tests2run[1].suite, 'name of suite');
    assertSame(#lib.tests2run[1].names, 3);
    assertSame(lib.tests2run[1].names[1], 'name of suite');
    assertSame(lib.tests2run[1].names[2], 'name of describe');
    assertSame(lib.tests2run[1].names[3], 'name of it');

    assertSame(lib.tests2run[2].state, 'Forced');
    assertSame(lib.tests2run[2].index, 2);
    assertSame(lib.tests2run[2].suite, 'name of suite');
    assertSame(#lib.tests2run[2].names, 3);
    assertSame(lib.tests2run[2].names[1], 'name of suite');
    assertSame(lib.tests2run[2].names[2], 'name of describe');
    assertSame(lib.tests2run[2].names[3], 'name of fit');

    assertSame(lib.tests2run[3].state, 'Skipped');
    assertSame(lib.tests2run[3].index, 3);
    assertSame(lib.tests2run[3].suite, 'name of suite');
    assertSame(#lib.tests2run[3].names, 3);
    assertSame(lib.tests2run[3].names[1], 'name of suite');
    assertSame(lib.tests2run[3].names[2], 'name of describe');
    assertSame(lib.tests2run[3].names[3], 'name of xit');
end

function testDescribeWithSuiteNameAndTestSuiteNameBlock()
    assertSame(lib.fatalErrors, nil);
    assertSame(#lib.tests2run, 0);
    assertSame(#lib.results, 0);
    assertSame(lib.runningResult, nil);
    assertSame(lib.runningTest, nil);

    describe('suite of describe', 'name of describe', function() 
        it('suite of it', 'name of it', noopFunc) 
        fit('suite of fit', 'name of fit', noopFunc) 
        xit('suite of xit', 'name of xit', noopFunc) 
    end);

    assertSame(lib.fatalErrors, nil);
    assertSame(#lib.tests2run, 3);
    assertSame(#lib.results, 0);
    assertSame(lib.runningResult, nil);
    assertSame(lib.runningTest, nil);

    assertSame(lib.tests2run[1].state, 'Normal');
    assertSame(lib.tests2run[1].index, 1);
    assertSame(lib.tests2run[1].suite, 'suite of describe');
    assertSame(#lib.tests2run[1].names, 3);
    assertSame(lib.tests2run[1].names[1], 'suite of describe');
    assertSame(lib.tests2run[1].names[2], 'name of describe');
    assertSame(lib.tests2run[1].names[3], 'name of it');

    assertSame(lib.tests2run[2].state, 'Forced');
    assertSame(lib.tests2run[2].index, 2);
    assertSame(lib.tests2run[2].suite, 'suite of describe');
    assertSame(#lib.tests2run[2].names, 3);
    assertSame(lib.tests2run[2].names[1], 'suite of describe');
    assertSame(lib.tests2run[2].names[2], 'name of describe');
    assertSame(lib.tests2run[2].names[3], 'name of fit');

    assertSame(lib.tests2run[3].state, 'Skipped');
    assertSame(lib.tests2run[3].index, 3);
    assertSame(lib.tests2run[3].suite, 'suite of describe');
    assertSame(#lib.tests2run[3].names, 3);
    assertSame(lib.tests2run[3].names[1], 'suite of describe');
    assertSame(lib.tests2run[3].names[2], 'name of describe');
    assertSame(lib.tests2run[3].names[3], 'name of xit');
end

function testFdescribeWithoutParameters()
    assertSame(lib.fatalErrors, nil);
    assertSame(#lib.tests2run, 0);
    assertSame(#lib.results, 0);
    assertSame(lib.runningResult, nil);
    assertSame(lib.runningTest, nil);

    fdescribe();

    assertSame(#lib.fatalErrors, 1);
    assert(lib.fatalErrors[1]:match('describe must have at least one callback function!') ~= nil);
    assertSame(#lib.tests2run, 0);
    assertSame(#lib.results, 0);
    assertSame(lib.runningResult, nil);
    assertSame(lib.runningTest, nil);
end

function testFdescribeWithoutTestBlock()
    assertSame(lib.fatalErrors, nil);
    assertSame(#lib.tests2run, 0);
    assertSame(#lib.results, 0);
    assertSame(lib.runningResult, nil);
    assertSame(lib.runningTest, nil);

    fdescribe(noopFunc);

    assertSame(#lib.fatalErrors, 1);
    assert(lib.fatalErrors[1]:match('describe must contain at least one test!') ~= nil);
    assertSame(#lib.tests2run, 0);
    assertSame(#lib.results, 0);
    assertSame(lib.runningResult, nil);
    assertSame(lib.runningTest, nil);
end

function testFdescribeWithTestBlock()
    assertSame(lib.fatalErrors, nil);
    assertSame(#lib.tests2run, 0);
    assertSame(#lib.results, 0);
    assertSame(lib.runningResult, nil);
    assertSame(lib.runningTest, nil);

    fdescribe(function() 
        it(noopFunc);
        fit(noopFunc);
        xit(noopFunc);
    end);

    assertSame(lib.fatalErrors, nil);
    assertSame(#lib.tests2run, 3);
    assertSame(#lib.results, 0);
    assertSame(lib.runningResult, nil);
    assertSame(lib.runningTest, nil);

    assertSame(lib.tests2run[1].state, 'Semi-Forced');
    assertSame(lib.tests2run[1].index, 1);
    assertSame(lib.tests2run[1].suite, 'LibWoWUnit');
    assertSame(#lib.tests2run[1].names, 3);
    assertSame(lib.tests2run[1].names[1], 'LibWoWUnit');
    assertSame(lib.tests2run[1].names[2], '');
    assertSame(lib.tests2run[1].names[3], '');

    assertSame(lib.tests2run[2].state, 'Forced');
    assertSame(lib.tests2run[2].index, 2);
    assertSame(lib.tests2run[2].suite, 'LibWoWUnit');
    assertSame(#lib.tests2run[2].names, 3);
    assertSame(lib.tests2run[2].names[1], 'LibWoWUnit');
    assertSame(lib.tests2run[2].names[2], '');
    assertSame(lib.tests2run[2].names[3], '');

    assertSame(lib.tests2run[3].state, 'Skipped');
    assertSame(lib.tests2run[3].index, 3);
    assertSame(lib.tests2run[3].suite, 'LibWoWUnit');
    assertSame(#lib.tests2run[3].names, 3);
    assertSame(lib.tests2run[3].names[1], 'LibWoWUnit');
    assertSame(lib.tests2run[3].names[2], '');
    assertSame(lib.tests2run[3].names[3], '');
end

function testFdescribeWithNameAndTestBlock()
    assertSame(lib.fatalErrors, nil);
    assertSame(#lib.tests2run, 0);
    assertSame(#lib.results, 0);
    assertSame(lib.runningResult, nil);
    assertSame(lib.runningTest, nil);

    fdescribe('name of fdescribe', function() 
        it(noopFunc);
        fit(noopFunc);
        xit(noopFunc);
    end);

    assertSame(lib.fatalErrors, nil);
    assertSame(#lib.tests2run, 3);
    assertSame(#lib.results, 0);
    assertSame(lib.runningResult, nil);
    assertSame(lib.runningTest, nil);

    assertSame(lib.tests2run[1].state, 'Semi-Forced');
    assertSame(lib.tests2run[1].index, 1);
    assertSame(lib.tests2run[1].suite, 'LibWoWUnit');
    assertSame(#lib.tests2run[1].names, 3);
    assertSame(lib.tests2run[1].names[1], 'LibWoWUnit');
    assertSame(lib.tests2run[1].names[2], 'name of fdescribe');
    assertSame(lib.tests2run[1].names[3], '');

    assertSame(lib.tests2run[2].state, 'Forced');
    assertSame(lib.tests2run[2].index, 2);
    assertSame(lib.tests2run[2].suite, 'LibWoWUnit');
    assertSame(#lib.tests2run[2].names, 3);
    assertSame(lib.tests2run[2].names[1], 'LibWoWUnit');
    assertSame(lib.tests2run[2].names[2], 'name of fdescribe');
    assertSame(lib.tests2run[2].names[3], '');

    assertSame(lib.tests2run[3].state, 'Skipped');
    assertSame(lib.tests2run[3].index, 3);
    assertSame(lib.tests2run[3].suite, 'LibWoWUnit');
    assertSame(#lib.tests2run[3].names, 3);
    assertSame(lib.tests2run[3].names[1], 'LibWoWUnit');
    assertSame(lib.tests2run[3].names[2], 'name of fdescribe');
    assertSame(lib.tests2run[3].names[3], '');
end

function testFdescribeWithSuiteNameAndTestBlock()
    assertSame(lib.fatalErrors, nil);
    assertSame(#lib.tests2run, 0);
    assertSame(#lib.results, 0);
    assertSame(lib.runningResult, nil);
    assertSame(lib.runningTest, nil);

    fdescribe('name of suite', 'name of fdescribe', function() 
        it(noopFunc);
        fit(noopFunc);
        xit(noopFunc);
    end);

    assertSame(lib.fatalErrors, nil);
    assertSame(#lib.tests2run, 3);
    assertSame(#lib.results, 0);
    assertSame(lib.runningResult, nil);
    assertSame(lib.runningTest, nil);
    assertSame(lib.tests2run[1].state, 'Semi-Forced');
    assertSame(lib.tests2run[1].index, 1);
    assertSame(lib.tests2run[1].suite, 'name of suite');
    assertSame(#lib.tests2run[1].names, 3);
    assertSame(lib.tests2run[1].names[1], 'name of suite');
    assertSame(lib.tests2run[1].names[2], 'name of fdescribe');
    assertSame(lib.tests2run[1].names[3], '');

    assertSame(lib.tests2run[2].state, 'Forced');
    assertSame(lib.tests2run[2].index, 2);
    assertSame(lib.tests2run[2].suite, 'name of suite');
    assertSame(#lib.tests2run[2].names, 3);
    assertSame(lib.tests2run[2].names[1], 'name of suite');
    assertSame(lib.tests2run[2].names[2], 'name of fdescribe');
    assertSame(lib.tests2run[2].names[3], '');

    assertSame(lib.tests2run[3].state, 'Skipped');
    assertSame(lib.tests2run[3].index, 3);
    assertSame(lib.tests2run[3].suite, 'name of suite');
    assertSame(#lib.tests2run[3].names, 3);
    assertSame(lib.tests2run[3].names[1], 'name of suite');
    assertSame(lib.tests2run[3].names[2], 'name of fdescribe');
    assertSame(lib.tests2run[3].names[3], '');
end

function testFdescribeWithSuiteNameAndTestNameBlock()
    assertSame(lib.fatalErrors, nil);
    assertSame(#lib.tests2run, 0);
    assertSame(#lib.results, 0);
    assertSame(lib.runningResult, nil);
    assertSame(lib.runningTest, nil);

    fdescribe('name of suite', 'name of fdescribe', function() 
        it('name of it', noopFunc) 
        fit('name of fit', noopFunc) 
        xit('name of xit', noopFunc) 
    end);

    assertSame(lib.fatalErrors, nil);
    assertSame(#lib.tests2run, 3);
    assertSame(#lib.results, 0);
    assertSame(lib.runningResult, nil);
    assertSame(lib.runningTest, nil);

    assertSame(lib.tests2run[1].state, 'Semi-Forced');
    assertSame(lib.tests2run[1].index, 1);
    assertSame(lib.tests2run[1].suite, 'name of suite');
    assertSame(#lib.tests2run[1].names, 3);
    assertSame(lib.tests2run[1].names[1], 'name of suite');
    assertSame(lib.tests2run[1].names[2], 'name of fdescribe');
    assertSame(lib.tests2run[1].names[3], 'name of it');

    assertSame(lib.tests2run[2].state, 'Forced');
    assertSame(lib.tests2run[2].index, 2);
    assertSame(lib.tests2run[2].suite, 'name of suite');
    assertSame(#lib.tests2run[2].names, 3);
    assertSame(lib.tests2run[2].names[1], 'name of suite');
    assertSame(lib.tests2run[2].names[2], 'name of fdescribe');
    assertSame(lib.tests2run[2].names[3], 'name of fit');

    assertSame(lib.tests2run[3].state, 'Skipped');
    assertSame(lib.tests2run[3].index, 3);
    assertSame(lib.tests2run[3].suite, 'name of suite');
    assertSame(#lib.tests2run[3].names, 3);
    assertSame(lib.tests2run[3].names[1], 'name of suite');
    assertSame(lib.tests2run[3].names[2], 'name of fdescribe');
    assertSame(lib.tests2run[3].names[3], 'name of xit');
end

function testFdescribeWithSuiteNameAndTestSuiteNameBlock()
    assertSame(lib.fatalErrors, nil);
    assertSame(#lib.tests2run, 0);
    assertSame(#lib.results, 0);
    assertSame(lib.runningResult, nil);
    assertSame(lib.runningTest, nil);

    fdescribe('suite of fdescribe', 'name of fdescribe', function() 
        it('suite of it', 'name of it', noopFunc) 
        fit('suite of fit', 'name of fit', noopFunc) 
        xit('suite of xit', 'name of xit', noopFunc) 
    end);

    assertSame(lib.fatalErrors, nil);
    assertSame(#lib.tests2run, 3);
    assertSame(#lib.results, 0);
    assertSame(lib.runningResult, nil);
    assertSame(lib.runningTest, nil);

    assertSame(lib.tests2run[1].state, 'Semi-Forced');
    assertSame(lib.tests2run[1].index, 1);
    assertSame(lib.tests2run[1].suite, 'suite of fdescribe');
    assertSame(#lib.tests2run[1].names, 3);
    assertSame(lib.tests2run[1].names[1], 'suite of fdescribe');
    assertSame(lib.tests2run[1].names[2], 'name of fdescribe');
    assertSame(lib.tests2run[1].names[3], 'name of it');

    assertSame(lib.tests2run[2].state, 'Forced');
    assertSame(lib.tests2run[2].index, 2);
    assertSame(lib.tests2run[2].suite, 'suite of fdescribe');
    assertSame(#lib.tests2run[2].names, 3);
    assertSame(lib.tests2run[2].names[1], 'suite of fdescribe');
    assertSame(lib.tests2run[2].names[2], 'name of fdescribe');
    assertSame(lib.tests2run[2].names[3], 'name of fit');

    assertSame(lib.tests2run[3].state, 'Skipped');
    assertSame(lib.tests2run[3].index, 3);
    assertSame(lib.tests2run[3].suite, 'suite of fdescribe');
    assertSame(#lib.tests2run[3].names, 3);
    assertSame(lib.tests2run[3].names[1], 'suite of fdescribe');
    assertSame(lib.tests2run[3].names[2], 'name of fdescribe');
    assertSame(lib.tests2run[3].names[3], 'name of xit');
end

function testXdescribeWithoutParameters()
    assertSame(lib.fatalErrors, nil);
    assertSame(#lib.tests2run, 0);
    assertSame(#lib.results, 0);
    assertSame(lib.runningResult, nil);
    assertSame(lib.runningTest, nil);

    xdescribe();

    assertSame(#lib.fatalErrors, 1);
    assert(lib.fatalErrors[1]:match('describe must have at least one callback function!') ~= nil);
    assertSame(#lib.tests2run, 0);
    assertSame(#lib.results, 0);
    assertSame(lib.runningResult, nil);
    assertSame(lib.runningTest, nil);
end

function testXdescribeWithoutTestBlock()
    assertSame(lib.fatalErrors, nil);
    assertSame(#lib.tests2run, 0);
    assertSame(#lib.results, 0);
    assertSame(lib.runningResult, nil);
    assertSame(lib.runningTest, nil);

    xdescribe(noopFunc);

    assertSame(#lib.fatalErrors, 1);
    assert(lib.fatalErrors[1]:match('describe must contain at least one test!') ~= nil);
    assertSame(#lib.tests2run, 0);
    assertSame(#lib.results, 0);
    assertSame(lib.runningResult, nil);
    assertSame(lib.runningTest, nil);
end

function testXdescribeWithTestBlock()
    assertSame(lib.fatalErrors, nil);
    assertSame(#lib.tests2run, 0);
    assertSame(#lib.results, 0);
    assertSame(lib.runningResult, nil);
    assertSame(lib.runningTest, nil);

    xdescribe(function() 
        it(noopFunc);
        fit(noopFunc);
        xit(noopFunc);
    end);

    assertSame(lib.fatalErrors, nil);
    assertSame(#lib.tests2run, 3);
    assertSame(#lib.results, 0);
    assertSame(lib.runningResult, nil);
    assertSame(lib.runningTest, nil);

    assertSame(lib.tests2run[1].state, 'Semi-Skipped');
    assertSame(lib.tests2run[1].index, 1);
    assertSame(lib.tests2run[1].suite, 'LibWoWUnit');
    assertSame(#lib.tests2run[1].names, 3);
    assertSame(lib.tests2run[1].names[1], 'LibWoWUnit');
    assertSame(lib.tests2run[1].names[2], '');
    assertSame(lib.tests2run[1].names[3], '');

    assertSame(lib.tests2run[2].state, 'Semi-Skipped');
    assertSame(lib.tests2run[2].index, 2);
    assertSame(lib.tests2run[2].suite, 'LibWoWUnit');
    assertSame(#lib.tests2run[2].names, 3);
    assertSame(lib.tests2run[2].names[1], 'LibWoWUnit');
    assertSame(lib.tests2run[2].names[2], '');
    assertSame(lib.tests2run[2].names[3], '');

    assertSame(lib.tests2run[3].state, 'Skipped');
    assertSame(lib.tests2run[3].index, 3);
    assertSame(lib.tests2run[3].suite, 'LibWoWUnit');
    assertSame(#lib.tests2run[3].names, 3);
    assertSame(lib.tests2run[3].names[1], 'LibWoWUnit');
    assertSame(lib.tests2run[3].names[2], '');
    assertSame(lib.tests2run[3].names[3], '');
end

function testXdescribeWithNameAndTestBlock()
    assertSame(lib.fatalErrors, nil);
    assertSame(#lib.tests2run, 0);
    assertSame(#lib.results, 0);
    assertSame(lib.runningResult, nil);
    assertSame(lib.runningTest, nil);

    xdescribe('name of xdescribe', function() 
        it(noopFunc);
        fit(noopFunc);
        xit(noopFunc);
    end);

    assertSame(lib.fatalErrors, nil);
    assertSame(#lib.tests2run, 3);
    assertSame(#lib.results, 0);
    assertSame(lib.runningResult, nil);
    assertSame(lib.runningTest, nil);

    assertSame(lib.tests2run[1].state, 'Semi-Skipped');
    assertSame(lib.tests2run[1].index, 1);
    assertSame(lib.tests2run[1].suite, 'LibWoWUnit');
    assertSame(#lib.tests2run[1].names, 3);
    assertSame(lib.tests2run[1].names[1], 'LibWoWUnit');
    assertSame(lib.tests2run[1].names[2], 'name of xdescribe');
    assertSame(lib.tests2run[1].names[3], '');

    assertSame(lib.tests2run[2].state, 'Semi-Skipped');
    assertSame(lib.tests2run[2].index, 2);
    assertSame(lib.tests2run[2].suite, 'LibWoWUnit');
    assertSame(#lib.tests2run[2].names, 3);
    assertSame(lib.tests2run[2].names[1], 'LibWoWUnit');
    assertSame(lib.tests2run[2].names[2], 'name of xdescribe');
    assertSame(lib.tests2run[2].names[3], '');

    assertSame(lib.tests2run[3].state, 'Skipped');
    assertSame(lib.tests2run[3].index, 3);
    assertSame(lib.tests2run[3].suite, 'LibWoWUnit');
    assertSame(#lib.tests2run[3].names, 3);
    assertSame(lib.tests2run[3].names[1], 'LibWoWUnit');
    assertSame(lib.tests2run[3].names[2], 'name of xdescribe');
    assertSame(lib.tests2run[3].names[3], '');
end

function testXdescribeWithSuiteNameAndTestBlock()
    assertSame(lib.fatalErrors, nil);
    assertSame(#lib.tests2run, 0);
    assertSame(#lib.results, 0);
    assertSame(lib.runningResult, nil);
    assertSame(lib.runningTest, nil);

    xdescribe('name of suite', 'name of xdescribe', function() 
        it(noopFunc);
        fit(noopFunc);
        xit(noopFunc);
    end);

    assertSame(lib.fatalErrors, nil);
    assertSame(#lib.tests2run, 3);
    assertSame(#lib.results, 0);
    assertSame(lib.runningResult, nil);
    assertSame(lib.runningTest, nil);
    assertSame(lib.tests2run[1].state, 'Semi-Skipped');
    assertSame(lib.tests2run[1].index, 1);
    assertSame(lib.tests2run[1].suite, 'name of suite');
    assertSame(#lib.tests2run[1].names, 3);
    assertSame(lib.tests2run[1].names[1], 'name of suite');
    assertSame(lib.tests2run[1].names[2], 'name of xdescribe');
    assertSame(lib.tests2run[1].names[3], '');

    assertSame(lib.tests2run[2].state, 'Semi-Skipped');
    assertSame(lib.tests2run[2].index, 2);
    assertSame(lib.tests2run[2].suite, 'name of suite');
    assertSame(#lib.tests2run[2].names, 3);
    assertSame(lib.tests2run[2].names[1], 'name of suite');
    assertSame(lib.tests2run[2].names[2], 'name of xdescribe');
    assertSame(lib.tests2run[2].names[3], '');

    assertSame(lib.tests2run[3].state, 'Skipped');
    assertSame(lib.tests2run[3].index, 3);
    assertSame(lib.tests2run[3].suite, 'name of suite');
    assertSame(#lib.tests2run[3].names, 3);
    assertSame(lib.tests2run[3].names[1], 'name of suite');
    assertSame(lib.tests2run[3].names[2], 'name of xdescribe');
    assertSame(lib.tests2run[3].names[3], '');
end

function testXdescribeWithSuiteNameAndTestNameBlock()
    assertSame(lib.fatalErrors, nil);
    assertSame(#lib.tests2run, 0);
    assertSame(#lib.results, 0);
    assertSame(lib.runningResult, nil);
    assertSame(lib.runningTest, nil);

    xdescribe('name of suite', 'name of xdescribe', function() 
        it('name of it', noopFunc) 
        fit('name of fit', noopFunc) 
        xit('name of xit', noopFunc) 
    end);

    assertSame(lib.fatalErrors, nil);
    assertSame(#lib.tests2run, 3);
    assertSame(#lib.results, 0);
    assertSame(lib.runningResult, nil);
    assertSame(lib.runningTest, nil);

    assertSame(lib.tests2run[1].state, 'Semi-Skipped');
    assertSame(lib.tests2run[1].index, 1);
    assertSame(lib.tests2run[1].suite, 'name of suite');
    assertSame(#lib.tests2run[1].names, 3);
    assertSame(lib.tests2run[1].names[1], 'name of suite');
    assertSame(lib.tests2run[1].names[2], 'name of xdescribe');
    assertSame(lib.tests2run[1].names[3], 'name of it');

    assertSame(lib.tests2run[2].state, 'Semi-Skipped');
    assertSame(lib.tests2run[2].index, 2);
    assertSame(lib.tests2run[2].suite, 'name of suite');
    assertSame(#lib.tests2run[2].names, 3);
    assertSame(lib.tests2run[2].names[1], 'name of suite');
    assertSame(lib.tests2run[2].names[2], 'name of xdescribe');
    assertSame(lib.tests2run[2].names[3], 'name of fit');

    assertSame(lib.tests2run[3].state, 'Skipped');
    assertSame(lib.tests2run[3].index, 3);
    assertSame(lib.tests2run[3].suite, 'name of suite');
    assertSame(#lib.tests2run[3].names, 3);
    assertSame(lib.tests2run[3].names[1], 'name of suite');
    assertSame(lib.tests2run[3].names[2], 'name of xdescribe');
    assertSame(lib.tests2run[3].names[3], 'name of xit');
end

function testXdescribeWithSuiteNameAndTestSuiteNameBlock()
    assertSame(lib.fatalErrors, nil);
    assertSame(#lib.tests2run, 0);
    assertSame(#lib.results, 0);
    assertSame(lib.runningResult, nil);
    assertSame(lib.runningTest, nil);

    xdescribe('suite of xdescribe', 'name of xdescribe', function() 
        it('suite of it', 'name of it', noopFunc) 
        fit('suite of fit', 'name of fit', noopFunc) 
        xit('suite of xit', 'name of xit', noopFunc) 
    end);

    assertSame(lib.fatalErrors, nil);
    assertSame(#lib.tests2run, 3);
    assertSame(#lib.results, 0);
    assertSame(lib.runningResult, nil);
    assertSame(lib.runningTest, nil);

    assertSame(lib.tests2run[1].state, 'Semi-Skipped');
    assertSame(lib.tests2run[1].index, 1);
    assertSame(lib.tests2run[1].suite, 'suite of xdescribe');
    assertSame(#lib.tests2run[1].names, 3);
    assertSame(lib.tests2run[1].names[1], 'suite of xdescribe');
    assertSame(lib.tests2run[1].names[2], 'name of xdescribe');
    assertSame(lib.tests2run[1].names[3], 'name of it');

    assertSame(lib.tests2run[2].state, 'Semi-Skipped');
    assertSame(lib.tests2run[2].index, 2);
    assertSame(lib.tests2run[2].suite, 'suite of xdescribe');
    assertSame(#lib.tests2run[2].names, 3);
    assertSame(lib.tests2run[2].names[1], 'suite of xdescribe');
    assertSame(lib.tests2run[2].names[2], 'name of xdescribe');
    assertSame(lib.tests2run[2].names[3], 'name of fit');

    assertSame(lib.tests2run[3].state, 'Skipped');
    assertSame(lib.tests2run[3].index, 3);
    assertSame(lib.tests2run[3].suite, 'suite of xdescribe');
    assertSame(#lib.tests2run[3].names, 3);
    assertSame(lib.tests2run[3].names[1], 'suite of xdescribe');
    assertSame(lib.tests2run[3].names[2], 'name of xdescribe');
    assertSame(lib.tests2run[3].names[3], 'name of xit');
end


