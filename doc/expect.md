
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

In Jasmine we can use the **.not.** chain to negate an expectation, which is in Lua not possible, because the keyword not is a reseved word in luy syntax.

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
