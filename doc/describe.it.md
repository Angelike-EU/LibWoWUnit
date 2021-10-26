
The basic concept for this test framework are describe and it callback functions.

# Describe
.... your test and you never have to explain it.

### Syntax:

    describe([[suite name, ] block name, ] callbackFn);
    fdescribe([[suite name, ] block name, ] callbackFn);  
    xdescribe([[suite name, ] block name, ] callbackFn);

-   **[optional] suite name:** The name of the current test suite. Usually one suite/addon. When not set your current active addon path will used. This parameter is only valid in the first enclosing block, othwise it is ignored
-   **[optional] block name:** The name of the current block. Not required but highly recomended to fill out.
-   **[required] callbackFn:** The function with your nested test code

Describe block's should help you to organize and explain your test code. It also allows yout to run code before and after a test (see **beforeEach**/**afterEach**). It also holds the test method (**it**) inside.

There are 3 types of decribe calls

 - **describe** - This is the the ususal way to use it, it contains it/beaforeEach/afterEach statements and also scopen variables.
 - **fdescribe** - has the same purpose like describe, but it is forced and disable all other describe blocks in the same test suite. Usefull for specific testing in a suite.
 - **xdescribe** - disable all tests inside this block.

### Example

    describe('describe suite', 'describe example', function()
        -- this block will not be executed because the fdescribe block below
        describe('normal block', function() 
            it('a test', function()
	            expect(true).toBeDefined();
            end)
        end)
        fdescribe('forced block', function() 
            it('a test', function()
	            expect(true).toBeDefined();
            end)
        end)
        -- disabled blocks will never be executed
        xdescribe('disabled block', function() 
            it('a test', function()
	            expect(true).toBeDefined();
            end)
        end)
    end)
