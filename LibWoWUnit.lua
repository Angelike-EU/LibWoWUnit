local lib, oldMajor = LibStub:NewLibrary("LibWoWUnit", 1);

if (not lib) then 
    return;
end

lib.suites = lib.suites or {};
lib.fatalErrors = lib.fatalErrors or {};
lib.results = lib.results or {};

lib.anchorFrame = lib.anchorFrame or CreateFrame('Frame', 'LibWoWUnit', UIParent);

lib.anchorFrame:UnregisterAllEvents();
lib.anchorFrame:RegisterEvent('PLAYER_LOGIN');
lib.anchorFrame:SetWidth(1);
lib.anchorFrame:SetHeight(1);
lib.anchorFrame:ClearAllPoints();
lib.anchorFrame:SetPoint('CENTER', -100, 150);

lib.anchorFrame:SetScript('OnEvent', function(self, event, ...)
    lib.ui:createFrames();
    
    self:UnregisterAllEvents();
    self:SetScript('OnEvent', nil);
    _G.LibWoWUnitDB = lib;
end)


