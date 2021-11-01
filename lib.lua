--[[---------------------------------------------------------------------------

 _     _ _     _    _       _    _ _   _       _ _   
| |   (_) |   | |  | |     | |  | | | | |     (_) |  
| |    _| |__ | |  | | ___ | |  | | | | |_ __  _| |_ 
| |   | | '_ \| |/\| |/ _ \| |/\| | | | | '_ \| | __|
| |___| | |_) \  /\  / (_) \  /\  / |_| | | | | | |_ 
\_____/_|_.__/ \/  \/ \___/ \/  \/ \___/|_| |_|_|\__|

LibWoWUnit is an unit testing framewor inspired by Karma/Jasmine.

You can run your tests directly in WoW and vusialize them into an output window.

Author: Angelike/Gilneas/EU
Contact: https://www.curseforge.com/members/1202082-endymion172?username=endymion172
Mail: angelike-wow[a]gmx[.]net

-----------------------------------------------------------------------------]]

local libName = ...;

local lib, oldMajor = LibStub:NewLibrary("LibWoWUnit", 0);

if (not lib) then 
    return;
end

local _G = _G;
local CreateFrame = CreateFrame;
local type = type;
local CopyTable, pairs = CopyTable, pairs;

setfenv(1, lib);

suites = suites or {};
results = results or {};
tests2run = tests2run or {};

dbDefaults = {
    ['closed'] = true,
    ['height'] = 250,
    ['minimized'] = false,
    ['point'] = 'CENTER',
    ['width'] = 150,
    ['x'] = -120,
    ['y'] = 200,
};

db = CopyTable(dbDefaults);

anchorFrame = anchorFrame or CreateFrame('Frame', 'LibWoWUnit', UIParent, "LibWoWUnitAnchorFrame");

anchorFrame:UnregisterAllEvents();
anchorFrame:RegisterEvent('PLAYER_LOGIN');

anchorFrame:SetScript('OnEvent', function(self, event, ...)
    -- set database to save settings, only allowed when lib runs as seperate addon, otherwise it must be done seperately
    if (libName == 'LibWoWUnit') then
        _G.LibWoWUnitDB = _G.LibWoWUnitDB or {};
        lib:setDb(_G.LibWoWUnitDB);
    else
        lib:setDb(lib.db);
    end

    _G.LibWoWUnitLib = lib;

    lib.ui:createFrames();
    
    self:UnregisterAllEvents();
    self:SetScript('OnEvent', nil);
end)

function lib:setDb(refTable)
    if (type(refTable) ~= 'table') then
        refTable = {};
    end

    lib.db = refTable;

    for k, v in pairs(lib.dbDefaults) do
        if (type(lib.db[k]) ~= type(v)) then
            lib.db[k] = v;
        end
    end
end

_G['SLASH_LIBWOWUNIT_SHOW1'] = '/LibWoWUnit';
_G['SLASH_LIBWOWUNIT_SHOW2'] = '/libwowunit';
_G['SLASH_LIBWOWUNIT_SHOW3'] = '/WoWUnit';
_G['SLASH_LIBWOWUNIT_SHOW4'] = '/wowunit';
_G.SlashCmdList['LIBWOWUNIT_SHOW'] = function()
    db.closed = false;

    ui.mainFrame:Show();
end
