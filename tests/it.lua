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

function testItWithoutParamaters()
    assertSame(lib.fatalErrors, nil);
    assertSame(#lib.tests2run, 0);
    assertSame(#lib.results, 0);
    assertSame(lib.runningResult, nil);
    assertSame(lib.runningTest, nil);

    it();

    assertSame(#lib.fatalErrors, 1);
    assert(lib.fatalErrors[1]:match('it must have at least one callback function!') ~= nil);
    assertSame(#lib.tests2run, 0);
    assertSame(#lib.results, 0);
    assertSame(lib.runningResult, nil);
    assertSame(lib.runningTest, nil);
end

function testItWithoutNameAndSuite()
    assertSame(lib.fatalErrors, nil);
    assertSame(#lib.tests2run, 0);
    assertSame(#lib.results, 0);
    assertSame(lib.runningResult, nil);
    assertSame(lib.runningTest, nil);

    it(noopFunc);

    assertSame(lib.fatalErrors, nil);
    assertSame(#lib.tests2run, 1);
    assertSame(lib.tests2run[1].state, 'Normal');
    assertSame(lib.tests2run[1].index, 1);
    assertSame(lib.tests2run[1].suite, 'LibWoWUnit');
    assertSame(#lib.tests2run[1].names, 2);
    assertSame(lib.tests2run[1].names[1], 'LibWoWUnit');
    assertSame(lib.tests2run[1].names[2], '');
    assertSame(#lib.results, 0);
    assertSame(lib.runningResult, nil);
    assertSame(lib.runningTest, nil);
end

function testItWithoutSuite()
    assertSame(lib.fatalErrors, nil);
    assertSame(#lib.tests2run, 0);
    assertSame(#lib.results, 0);
    assertSame(lib.runningResult, nil);
    assertSame(lib.runningTest, nil);

    it('name of test', noopFunc);

    assertSame(lib.fatalErrors, nil);
    assertSame(#lib.tests2run, 1);
    assertSame(lib.tests2run[1].state, 'Normal');
    assertSame(lib.tests2run[1].index, 1);
    assertSame(lib.tests2run[1].suite, 'LibWoWUnit');
    assertSame(#lib.tests2run[1].names, 2);
    assertSame(lib.tests2run[1].names[1], 'LibWoWUnit');
    assertSame(lib.tests2run[1].names[2], 'name of test');
    assertSame(#lib.results, 0);
    assertSame(lib.runningResult, nil);
    assertSame(lib.runningTest, nil);
end

function testItWithSuiteAndNameSet()
    assertSame(lib.fatalErrors, nil);
    assertSame(#lib.tests2run, 0);
    assertSame(#lib.results, 0);
    assertSame(lib.runningResult, nil);
    assertSame(lib.runningTest, nil);

    it('name of suite', 'name of test', noopFunc);

    assertSame(lib.fatalErrors, nil);
    assertSame(#lib.tests2run, 1);
    assertSame(lib.tests2run[1].state, 'Normal');
    assertSame(lib.tests2run[1].index, 1);
    assertSame(lib.tests2run[1].suite, 'name of suite');
    assertSame(#lib.tests2run[1].names, 2);
    assertSame(lib.tests2run[1].names[1], 'name of suite');
    assertSame(lib.tests2run[1].names[2], 'name of test');
    assertSame(#lib.results, 0);
    assertSame(lib.runningResult, nil);
    assertSame(lib.runningTest, nil);
end

function testFitWithoutParamaters()
    assertSame(lib.fatalErrors, nil);
    assertSame(#lib.tests2run, 0);
    assertSame(#lib.results, 0);
    assertSame(lib.runningResult, nil);
    assertSame(lib.runningTest, nil);

    fit();

    assertSame(#lib.fatalErrors, 1);
    assert(lib.fatalErrors[1]:match('fit must have at least one callback function!') ~= nil);
    assertSame(#lib.tests2run, 0);
    assertSame(#lib.results, 0);
    assertSame(lib.runningResult, nil);
    assertSame(lib.runningTest, nil);
end

function testFitWithoutNameAndSuite()
    assertSame(lib.fatalErrors, nil);
    assertSame(#lib.tests2run, 0);
    assertSame(#lib.results, 0);
    assertSame(lib.runningResult, nil);
    assertSame(lib.runningTest, nil);

    fit(noopFunc);

    assertSame(lib.fatalErrors, nil);
    assertSame(#lib.tests2run, 1);
    assertSame(lib.tests2run[1].state, 'Forced');
    assertSame(lib.tests2run[1].index, 1);
    assertSame(lib.tests2run[1].suite, 'LibWoWUnit');
    assertSame(#lib.tests2run[1].names, 2);
    assertSame(lib.tests2run[1].names[1], 'LibWoWUnit');
    assertSame(lib.tests2run[1].names[2], '');
    assertSame(#lib.results, 0);
    assertSame(lib.runningResult, nil);
    assertSame(lib.runningTest, nil);
end

function testFitWithoutSuite()
    assertSame(lib.fatalErrors, nil);
    assertSame(#lib.tests2run, 0);
    assertSame(#lib.results, 0);
    assertSame(lib.runningResult, nil);
    assertSame(lib.runningTest, nil);

    fit('name of test', noopFunc);

    assertSame(lib.fatalErrors, nil);
    assertSame(#lib.tests2run, 1);
    assertSame(lib.tests2run[1].state, 'Forced');
    assertSame(lib.tests2run[1].index, 1);
    assertSame(lib.tests2run[1].suite, 'LibWoWUnit');
    assertSame(#lib.tests2run[1].names, 2);
    assertSame(lib.tests2run[1].names[1], 'LibWoWUnit');
    assertSame(lib.tests2run[1].names[2], 'name of test');
    assertSame(#lib.results, 0);
    assertSame(lib.runningResult, nil);
    assertSame(lib.runningTest, nil);
end

function testFitWithSuiteAndNameSet()
    assertSame(lib.fatalErrors, nil);
    assertSame(#lib.tests2run, 0);
    assertSame(#lib.results, 0);
    assertSame(lib.runningResult, nil);
    assertSame(lib.runningTest, nil);

    fit('name of suite', 'name of test', noopFunc);

    assertSame(lib.fatalErrors, nil);
    assertSame(#lib.tests2run, 1);
    assertSame(lib.tests2run[1].state, 'Forced');
    assertSame(lib.tests2run[1].index, 1);
    assertSame(lib.tests2run[1].suite, 'name of suite');
    assertSame(#lib.tests2run[1].names, 2);
    assertSame(lib.tests2run[1].names[1], 'name of suite');
    assertSame(lib.tests2run[1].names[2], 'name of test');
    assertSame(#lib.results, 0);
    assertSame(lib.runningResult, nil);
    assertSame(lib.runningTest, nil);
end

function testXitWithoutParamaters()
    assertSame(lib.fatalErrors, nil);
    assertSame(#lib.tests2run, 0);
    assertSame(#lib.results, 0);
    assertSame(lib.runningResult, nil);
    assertSame(lib.runningTest, nil);

    xit();

    assertSame(#lib.fatalErrors, 1);
    assert(lib.fatalErrors[1]:match('xit must have at least one callback function!') ~= nil);
    assertSame(#lib.tests2run, 0);
    assertSame(#lib.results, 0);
    assertSame(lib.runningResult, nil);
    assertSame(lib.runningTest, nil);
end

function testXitWithoutNameAndSuite()
    assertSame(lib.fatalErrors, nil);
    assertSame(#lib.tests2run, 0);
    assertSame(#lib.results, 0);
    assertSame(lib.runningResult, nil);
    assertSame(lib.runningTest, nil);

    xit(noopFunc);

    assertSame(lib.fatalErrors, nil);
    assertSame(#lib.tests2run, 1);
    assertSame(lib.tests2run[1].state, 'Skipped');
    assertSame(lib.tests2run[1].index, 1);
    assertSame(lib.tests2run[1].suite, 'LibWoWUnit');
    assertSame(#lib.tests2run[1].names, 2);
    assertSame(lib.tests2run[1].names[1], 'LibWoWUnit');
    assertSame(lib.tests2run[1].names[2], '');
    assertSame(#lib.results, 0);
    assertSame(lib.runningResult, nil);
    assertSame(lib.runningTest, nil);
end

function testXitWithoutSuite()
    assertSame(lib.fatalErrors, nil);
    assertSame(#lib.tests2run, 0);
    assertSame(#lib.results, 0);
    assertSame(lib.runningResult, nil);
    assertSame(lib.runningTest, nil);

    xit('name of test', noopFunc);

    assertSame(lib.fatalErrors, nil);
    assertSame(#lib.tests2run, 1);
    assertSame(lib.tests2run[1].state, 'Skipped');
    assertSame(lib.tests2run[1].index, 1);
    assertSame(lib.tests2run[1].suite, 'LibWoWUnit');
    assertSame(#lib.tests2run[1].names, 2);
    assertSame(lib.tests2run[1].names[1], 'LibWoWUnit');
    assertSame(lib.tests2run[1].names[2], 'name of test');
    assertSame(#lib.results, 0);
    assertSame(lib.runningResult, nil);
    assertSame(lib.runningTest, nil);
end

function testXitWithSuiteAndNameSet()
    assertSame(lib.fatalErrors, nil);
    assertSame(#lib.tests2run, 0);
    assertSame(#lib.results, 0);
    assertSame(lib.runningResult, nil);
    assertSame(lib.runningTest, nil);

    xit('name of suite', 'name of test', noopFunc);

    assertSame(lib.fatalErrors, nil);
    assertSame(#lib.tests2run, 1);
    assertSame(lib.tests2run[1].state, 'Skipped');
    assertSame(lib.tests2run[1].index, 1);
    assertSame(lib.tests2run[1].suite, 'name of suite');
    assertSame(#lib.tests2run[1].names, 2);
    assertSame(lib.tests2run[1].names[1], 'name of suite');
    assertSame(lib.tests2run[1].names[2], 'name of test');
    assertSame(#lib.results, 0);
    assertSame(lib.runningResult, nil);
    assertSame(lib.runningTest, nil);
end
