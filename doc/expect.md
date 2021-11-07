
# Expects
Expects are the main test function in this framework. You can put an input into an an expect function and then you can match the result.

## The expect function
The expect function usually has one paramter and returns an object with all matchers (see below) to check with.

    expect(input [, ...]);

But expect's only make sense when you define your expextations, otherwise they are pointless. An more useful example:

    expect(true).toBe(true);
In this example we compare the input (true) with the expected value (true), which will pass and don't log an error.

    local tbl = {};
    
    expect(tbl).toBe(tbl); -- will pass
    expect({}).toBe(tbl); -- will fail
This example has two expects, the first one will pass because we have the same object reference. The socond expect fails on two different references. To compare tables, you should use the toEqual matcher.

Each test should execute at least one expect -> to[...] combination, otherwise the test will be marked as risky.

## Matcher
The matcher functions are a main component of LibWoWUnit. There are build in matchers, but you can also write your own matchers and extend the testing framework. It's important to difference between two kinds of matchers.

#### toBe or notToBe
(Hamlet, William Shakespeare)

In Jasmine we can use the **.not.** chain to negate an expectation, which is in Lua not possible, because the keyword not is a reseved word in lua syntax.

    expect(true).toBe(true); -- is ok
    expect(true).not.toBe(false); -- raise an runtime error
To avoid this problem, the framework automatic creates a method for every matcher with the prefix not.

    expect(true).notToBe(false); -- ok
    expect(true).notToBe(true); -- will fail on the same way below
    expect(true).toBe(false); 

### toBe
The simplest matcher is the toBe matcher. It compares directly two values by reference.

**Syntax:**

    expect(input).toBe(expectedResult);
    expect(input).notToBe(expectedResult);

**Examples:**

    expect(1).toBe(1); -- ok
    expect('foo').notToBe('bar'); --ok
    expect(UIParent).toBe(WorldFrame); -- fail
    expect({}).notToBe({}); -- ok

### toBeCloseTo
This matcher ceck's if an value is equal or close to an other value. The gap can pe set by a second compare parameter. It describes the precision after the comma.

**Syntax:**

    expect(input).toBeCloseTo(expectedResult[, precision = 2]);
    expect(input).toToBeCloseTo(expectedResult[, precision = 2]);

**Examples:**

    expect(1).toBeCloseTo(1); -- ok
    expect(1).toToBeCloseTo(2); --ok
    expect(1.01).toBeCloseTo(1, 2); -- fail
    expect(1.0099).toToBeCloseTo(1, 2); -- ok

### toBeDefined
In this matcher will be checkt, if an input is be defined (means not null). The compare function has no paramter.

**Syntax:**

    expect(input).toBeDefined();
    expect(input).notToBeDefined();

**Examples:**

    expect(1).toBeDefined(); -- ok
    expect(nil).notToBeDefined(); --ok
    expect(nil).toBeDefined(); -- fail
    expect(nil).notToBeDefined(); -- ok

### toBeFalsy
Checks that the input value is falsy. Please note that in Lua only false and nil are falsy (Empty string '' and 0 are truthy values). 

**Syntax:**

    expect(input).toBeFalsy();
    expect(input).notToBeFalsy();

**Examples:**

    expect(false).toBeFalsy(); -- ok
    expect(1).notToBeFalsy(); --ok
    expect(0).toBeFalsy(); -- fail
    expect(42).notToBeFalsy(); -- ok

### toBeFalse
Checks that the input value is false.

**Syntax:**

    expect(input).toBeFalse();
    expect(input).notToBeFalse();

**Examples:**

    expect(false).toBeFalsy(); -- ok
    expect(1).notToBeFalsy(); --ok
    expect(0).toBeFalsy(); -- fail
    expect(42).notToBeFalsy(); -- ok
### toBeGreaterThan
NYI
### toBeGreaterThanOrEqual
NYI
### toBeLessThan
NYI
### toBeLessThanOrEqual
NYI
### toBeNil
NYI
### toBeTrue
This matcher checks a value to be true.

**Syntax:**

    expect(input).toBeTrue();
    expect(input).notToBeTrue();

**Examples:**

    expect(true).toBeTrue(); -- ok
    expect('true').notToBeTrue(); --ok
    expect(false).toBeTrue(); -- fail


### toBeTruthy
This matcher checks a value is truthy. Please note, that every value is truthy exept false or nil.

**Syntax:**

    expect(input).toBeTruthy();
    expect(input).notToBeTruthy();

**Examples:**

    expect(true).toBeTruthy(); -- ok
    expect(false).notToBeTruthy(); --ok
    expect(false).toBeTruthy(); -- fail
    expect(nil).notToBeTruthy(); -- ok

### toBeType
Check's an input of an type representance. Valid are the default lua types and also the UI Object types.

**Syntax:**

    expect(input).toBeType(expectedType);
    expect(input).notToBeType(expectedType);

**Examples:**

    expect(true).toBeType('boolean'); -- ok
    expect(false).notToBeType('Frame'); --ok
    expect(false).toBeType('Button'); -- fail
    expect(nil).notToBeType('nil'); -- ok
    expect(UIParent).toBeType('Frame'); -- ok
    expect(UIParent).toBeType('table'); -- also ok

### toContain
NYI
### toEqual
NYI
### toHaveBeenCalled
NYI
### toHaveBeenCalledBefore
NYI
### toHaveBeenCalledTimes
NYI
### toHaveBeenCalledWith
NYI
### toMatch
NYI
### toThrow
NYI
