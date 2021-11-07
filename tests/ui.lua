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

function testFrameCreation()
    lib.ui.createFrames();
    
    assertType(lib.anchorFrame.main, 'Frame');
    assertType(lib.anchorFrame.main.title, 'Frame');
    assertType(lib.anchorFrame.main.title.close, 'Button');
    assertType(lib.anchorFrame.main.title.minimize, 'Button');
    assertType(lib.anchorFrame.main.scroll, 'ScrollFrame');
    assertType(lib.anchorFrame.main.scroll.results, 'Frame');
    assertType(lib.anchorFrame.main.resize, 'Button');
end