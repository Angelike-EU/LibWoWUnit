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
    assertSame(lib.base.activeResult, nil);

    it();

    assertSame(lib.fatalErrors, nil);
    assertSame(#lib.tests2run, 1);
    assertSame(lib.tests2run[1].state, 'Ignore');
    assertSame(lib.tests2run[1].index, 1);
    assertSame(lib.tests2run[1].suite, 'LibWoWUnit');
    assertSame(#lib.tests2run[1].names, 2);
    assertSame(lib.tests2run[1].names[1], 'LibWoWUnit');
    assertSame(lib.tests2run[1].names[2], '#Generated: Invalid callback function!');
    assertSame(#lib.results, 0);
    assertSame(lib.base.activeResult, nil);
end

function testItWithoutNameAndSuite()
    assertSame(lib.fatalErrors, nil);
    assertSame(#lib.tests2run, 0);
    assertSame(#lib.results, 0);
    assertSame(lib.base.activeResult, nil);

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
    assertSame(lib.base.activeResult, nil);
end

function testItWithoutSuite()
    assertSame(lib.fatalErrors, nil);
    assertSame(#lib.tests2run, 0);
    assertSame(#lib.results, 0);
    assertSame(lib.base.activeResult, nil);

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
    assertSame(lib.base.activeResult, nil);
end

function testItWithSuiteAndNameSet()
    assertSame(lib.fatalErrors, nil);
    assertSame(#lib.tests2run, 0);
    assertSame(#lib.results, 0);
    assertSame(lib.base.activeResult, nil);

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
    assertSame(lib.base.activeResult, nil);
end

function testFitWithoutParamaters()
    assertSame(lib.fatalErrors, nil);
    assertSame(#lib.tests2run, 0);
    assertSame(#lib.results, 0);
    assertSame(lib.base.activeResult, nil);

    fit();

    assertSame(lib.fatalErrors, nil);
    assertSame(#lib.tests2run, 1);
    assertSame(lib.tests2run[1].state, 'Ignore');
    assertSame(lib.tests2run[1].index, 1);
    assertSame(lib.tests2run[1].suite, 'LibWoWUnit');
    assertSame(#lib.tests2run[1].names, 2);
    assertSame(lib.tests2run[1].names[1], 'LibWoWUnit');
    assertSame(lib.tests2run[1].names[2], '#Generated: Invalid callback function!');
    assertSame(#lib.results, 0);
    assertSame(lib.base.activeResult, nil);
end

function testFitWithoutNameAndSuite()
    assertSame(lib.fatalErrors, nil);
    assertSame(#lib.tests2run, 0);
    assertSame(#lib.results, 0);
    assertSame(lib.base.activeResult, nil);

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
    assertSame(lib.base.activeResult, nil);
end

function testFitWithoutSuite()
    assertSame(lib.fatalErrors, nil);
    assertSame(#lib.tests2run, 0);
    assertSame(#lib.results, 0);
    assertSame(lib.base.activeResult, nil);

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
    assertSame(lib.base.activeResult, nil);
end

function testFitWithSuiteAndNameSet()
    assertSame(lib.fatalErrors, nil);
    assertSame(#lib.tests2run, 0);
    assertSame(#lib.results, 0);
    assertSame(lib.base.activeResult, nil);

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
    assertSame(lib.base.activeResult, nil);
end

function testXitWithoutParamaters()
    assertSame(lib.fatalErrors, nil);
    assertSame(#lib.tests2run, 0);
    assertSame(#lib.results, 0);
    assertSame(lib.base.activeResult, nil);

    xit();

    assertSame(lib.fatalErrors, nil);
    assertSame(#lib.tests2run, 1);
    assertSame(lib.tests2run[1].state, 'Ignore');
    assertSame(lib.tests2run[1].index, 1);
    assertSame(lib.tests2run[1].suite, 'LibWoWUnit');
    assertSame(#lib.tests2run[1].names, 2);
    assertSame(lib.tests2run[1].names[1], 'LibWoWUnit');
    assertSame(lib.tests2run[1].names[2], '#Generated: Invalid callback function!');
    assertSame(#lib.results, 0);
    assertSame(lib.base.activeResult, nil);
end

function testXitWithoutNameAndSuite()
    assertSame(lib.fatalErrors, nil);
    assertSame(#lib.tests2run, 0);
    assertSame(#lib.results, 0);
    assertSame(lib.base.activeResult, nil);

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
    assertSame(lib.base.activeResult, nil);
end

function testXitWithoutSuite()
    assertSame(lib.fatalErrors, nil);
    assertSame(#lib.tests2run, 0);
    assertSame(#lib.results, 0);
    assertSame(lib.base.activeResult, nil);

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
    assertSame(lib.base.activeResult, nil);
end

function testXitWithSuiteAndNameSet()
    assertSame(lib.fatalErrors, nil);
    assertSame(#lib.tests2run, 0);
    assertSame(#lib.results, 0);
    assertSame(lib.base.activeResult, nil);

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
    assertSame(lib.base.activeResult, nil);
end
