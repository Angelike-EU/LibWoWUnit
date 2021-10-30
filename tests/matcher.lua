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

function testToBeFailureByCompare()
    lib.base.activeResult = {};

    expect(true).toBe(false);

    assert(lib.base.activeResult.errors[1]:match('expected values to be \"false\", but was \"true\".') ~= nil);
end

function testToBeFailureWithToManyExpectParams()
    lib.base.activeResult = {};

    expect(true, 2).toBe(true);

    assert(lib.base.activeResult.errors[1]:match('toBe expect only one input parameter, got 2') ~= nil);
end

function testToBeFailureWithToManyCompareParams()
    lib.base.activeResult = {};

    expect(true).toBe(true, 2);

    assert(lib.base.activeResult.errors[1]:match('toBe expect only one compare parameter, got 2') ~= nil);
end

function testToBeFailureWithToNoCompareParams()
    lib.base.activeResult = {};

    expect(true).toBe();

    assert(lib.base.activeResult.errors[1]:match('toBe expect only one compare parameter, got 0') ~= nil);
end

function testToBeSuccess()
    lib.base.activeResult = {};

    expect(true).toBe(true);

    assertSame(lib.base.activeResult.errors, nil);
end


function testToBeTypeFailureByCompare()
    lib.base.activeResult = {};

    expect(true).toBeType(false);

    assert(lib.base.activeResult.errors[1]:match('expected input to be type of \"false\", but was \"boolean\".') ~= nil);
end

function testToBeTypeFailureWithToManyExpectParams()
    lib.base.activeResult = {};

    expect(true, 2).toBeType('boolean');

    assert(lib.base.activeResult.errors[1]:match('toBeType expect only one input parameter, got 2') ~= nil);
end

function testToBeTypeFailureWithToManyCompareParams()
    lib.base.activeResult = {};

    expect(true).toBeType('boolean', 2);

    assert(lib.base.activeResult.errors[1]:match('toBeType expect only one compare parameter, got 2') ~= nil);
end

function testToBeTypeFailureWithToNoCompareParams()
    lib.base.activeResult = {};

    expect(true).toBeType();

    assert(lib.base.activeResult.errors[1]:match('toBeType expect only one compare parameter, got 0') ~= nil);
end

function testToBeTypeSuccessWithSimpleType()
    lib.base.activeResult = {};

    expect(true).toBeType('boolean');

    assertSame(lib.base.activeResult.errors, nil);
end

function testToBeTypeSuccessWithObjectType()
    lib.base.activeResult = {};

    expect(UIParent).toBeType('Frame');

    assertSame(lib.base.activeResult.errors, nil);
end


function testToBeDefinedFailureByCompare()
    lib.base.activeResult = {};

    expect(nil).toBeDefined();

    assert(lib.base.activeResult.errors[1]:match('expect input to be defined, but was "nil".') ~= nil);
end

function testToBeDefinedFailureWithToManyExpectParams()
    lib.base.activeResult = {};

    expect(true, 2).toBeDefined();

    assert(lib.base.activeResult.errors[1]:match('toBeDefined expect only one input parameter, got 2') ~= nil);
end

function testToBeDefinedFailureWithToManyCompareParams()
    lib.base.activeResult = {};

    expect(true).toBeDefined(2);

    assert(lib.base.activeResult.errors[1]:match('toBeDefined expect no compare parameter, got 1') ~= nil);
end

function testToBeDefinedSuccessWithSimpleType()
    lib.base.activeResult = {};

    expect(true).toBeDefined();

    assertSame(lib.base.activeResult.errors, nil);
end


function testToBeTruthyFailureByCompare()
    lib.base.activeResult = {};

    expect(nil).toBeTruthy();

    assert(lib.base.activeResult.errors[1]:match('expect input to be truthy, but was nil') ~= nil);
end

function testToBeTruthyFailureWithToManyExpectParams()
    lib.base.activeResult = {};

    expect(true, 2).toBeTruthy();

    assert(lib.base.activeResult.errors[1]:match('toBeTruthy expect only one input parameter, got 2') ~= nil);
end

function testToBeTruthyFailureWithToManyCompareParams()
    lib.base.activeResult = {};

    expect(true).toBeTruthy(2);

    assert(lib.base.activeResult.errors[1]:match('toBeTruthy expect no compare parameter, got 1') ~= nil);
end

function testToBeTruthySuccessWithSimpleType()
    lib.base.activeResult = {};

    expect(true).toBeTruthy();

    assertSame(lib.base.activeResult.errors, nil);
end


function testToBeTrueFailureByCompare()
    lib.base.activeResult = {};

    expect(nil).toBeTrue();

    assert(lib.base.activeResult.errors[1]:match('expect input to be true, but was nil') ~= nil);
end

function testToBeTrueFailureWithToManyExpectParams()
    lib.base.activeResult = {};

    expect(true, 2).toBeTrue();

    assert(lib.base.activeResult.errors[1]:match('toBeTrue expect only one input parameter, got 2') ~= nil);
end

function testToBeTrueFailureWithToManyCompareParams()
    lib.base.activeResult = {};

    expect(true).toBeTrue(2);

    assert(lib.base.activeResult.errors[1]:match('toBeTrue expect no compare parameter, got 1') ~= nil);
end

function testToBeTrueSuccessWithSimpleType()
    lib.base.activeResult = {};

    expect(true).toBeTrue();

    assertSame(lib.base.activeResult.errors, nil);
end


function testToBeFalsyFailureByCompare()
    lib.base.activeResult = {};

    expect(1).toBeFalsy();

    assert(lib.base.activeResult.errors[1]:match('expect input to be falsy, but was 1') ~= nil);
end

function testToBeFalsyFailureWithToManyExpectParams()
    lib.base.activeResult = {};

    expect(nil, 2).toBeFalsy();

    assert(lib.base.activeResult.errors[1]:match('toBeFalsy expect only one input parameter, got 2') ~= nil);
end

function testToBeFalsyFailureWithToManyCompareParams()
    lib.base.activeResult = {};

    expect(nil).toBeFalsy(2);

    assert(lib.base.activeResult.errors[1]:match('toBeFalsy expect no compare parameter, got 1') ~= nil);
end

function testToBeFalsySuccessWithSimpleType()
    lib.base.activeResult = {};

    expect(nil).toBeFalsy();

    assertSame(lib.base.activeResult.errors, nil);
end


function testToBeFalseFailureByCompare()
    lib.base.activeResult = {};

    expect(1).toBeFalse();

    assert(lib.base.activeResult.errors[1]:match('expect input to be false, but was 1') ~= nil);
end

function testToBeFalseFailureWithToManyExpectParams()
    lib.base.activeResult = {};

    expect(nil, 2).toBeFalse();

    assert(lib.base.activeResult.errors[1]:match('toBeFalse expect only one input parameter, got 2') ~= nil);
end

function testToBeFalseFailureWithToManyCompareParams()
    lib.base.activeResult = {};

    expect(nil).toBeFalse(2);

    assert(lib.base.activeResult.errors[1]:match('toBeFalse expect no compare parameter, got 1') ~= nil);
end

function testToBeFalseSuccessWithSimpleType()
    lib.base.activeResult = {};

    expect(false).toBeFalse();

    assertSame(lib.base.activeResult.errors, nil);
end


function testToBeCloseToFailedByCompare()
    lib.base.activeResult = {};

    expect(1).toBeCloseTo(1.1);

    assert(lib.base.activeResult.errors[1]:match('expect input to be close to 1, but was 1.1 %(precicion 2%)') ~= nil);
end