The basic concept for this test framework are describe and it callback functions.

# Describe
.... your test.

Describe block's should help you to organize and explain your test code. 

### Syntax:

    describe([[suite name, ] block name, ] callbackFn);
    fdescribe([[suite name, ] block name, ] callbackFn);  
    xdescribe([[suite name, ] block name, ] callbackFn);

-   **[optional] suite name:** The name of the current test suite. Usually one suite/addon. When not set your current active addon path will used. This parameter is only valid in the first enclosing block, othwise it is ignored
-   **[optional] block name:** The name of the current block. Not required but highly recomended to fill out.
-   **[required] callbackFn:** The function with your nested test code
