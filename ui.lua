--[[
This file includes all ui functionality of the lib. it creates the
result window

All methodes are registred in the subtable ui in the main lib

--]]

local lib = LibStub:GetLibrary("LibWoWUnit", 1);

-- get all global methodes in local user space

local _G = _G;
local setfenv, setmetatable, type = _G.setfenv, setmetatable, _G.type;
local CreateFrame = _G.CreateFrame;
local ipairs, pairs = _G.ipairs, _G.pairs;
local tinsert, wipe = tinsert, wipe;
local print = print;

lib.ui = {};

-- restrict global environment, so we can't accidentally pollute it
setfenv(1, lib.ui);

--[[
 creates a result frame to display all results

 -- argumnts:

 -- returns:
    nil
--]]
function createFrames()
    mainFrame = CreateFrame('Frame', lib.anchorFrame:GetName() .. '-Main', lib.anchorFrame);
    titleFrame = CreateFrame('Frame', mainFrame:GetName() .. '-Title', mainFrame); 
    closeButton = CreateFrame('Button', titleFrame:GetName() .. '-Close', titleFrame);
    minimizeButton = CreateFrame('Button', titleFrame:GetName() .. '-Minimize', titleFrame);
    scrollFrame = CreateFrame('ScrollFrame', mainFrame:GetName() .. '-Scroll', mainFrame);
    resultFrame = CreateFrame('Frame', scrollFrame:GetName() .. '-Result', scrollFrame);

    loadScripts(mainFrame, lib.mixins.MainFrame);
    loadScripts(closeButton, lib.mixins.CloseButton);
    loadScripts(minimizeButton, lib.mixins.MinimizeButton);
    loadScripts(titleFrame, lib.mixins.TitleFrame);
    loadScripts(scrollFrame, lib.mixins.ScrollFrame);
    loadScripts(resultFrame, lib.mixins.ResultFrame);
end

--[[---------------------------------------------------------------------------
 load scripts into a frame an rgister event handler

 -- argumnts:
   target:UiObject - element to register callbacks
   scripts:table - table with data/scripts to assign

 -- returns:
    nil
-----------------------------------------------------------------------------]]
function loadScripts(target, scripts)
    if (type(target) ~= 'table' or type(target.IsForbidden) ~= 'function' or type(scripts) ~= 'table') then
        return;
    end
    
    for name, data in pairs(scripts) do
        if (type(data) == 'function' and name:match('^On')) then
            target:SetScript(name, function(...) data(target, ...) end);
        else 
            target[name] = data;        
        end
    end

    if (type(scripts.OnLoad) == 'function') then
        scripts:OnLoad(target);
    end
end

local shortTestIndicators = {
    ['Error'] = 'E',
    ['Failed'] = 'F',
    ['Skipped'] = 'S',
    ['Skipped-Implicit'] = 's',
    ['Risky'] = 'R',
    ['Success'] = '.',
}

--[[---------------------------------------------------------------------------
 Gets a short, single char, result indicator for short summary

 -- argumnts:
   result:string - the normal result of a test

 -- returns:
    shortResult:string - the short result indicator
-----------------------------------------------------------------------------]]
function getIndicatorText(result)
    return shortTestIndicators[result] or '_';
end


--[[---------------------------------------------------------------------------
   _____   .__         .__                 
  /     \  |__|___  ___|__|  ____    ______
 /  \ /  \ |  |\  \/  /|  | /    \  /  ___/
/    Y    \|  | >    < |  ||   |  \ \___ \ 
\____|__  /|__|/__/\_ \|__||___|  //____  >
        \/           \/         \/      \/ 
-----------------------------------------------------------------------------]]

lib.mixins = {}

local mt = {
    ["__index"] = lib.ui
};

setmetatable(lib.mixins, mt)
setfenv(1, lib.mixins);

MainFrame = {};

function MainFrame:OnLoad(self)
    self:ClearAllPoints();
    self:SetPoint('CENTER', 0, 0);
    self:SetHeight(200);
    self:SetWidth(400);
    self:Show();

    self:EnableMouse(true);
    self:SetMovable(true);
    self:SetClampedToScreen(true);

    self.background1 = self:CreateTexture();
    self.background1:ClearAllPoints();
    self.background1:SetAllPoints();
    self.background1:SetColorTexture(0.16, 0.19, 0.19);

    self.background2 = self:CreateTexture();
    self.background2:ClearAllPoints();
    self.background2:SetAllPoints();
    self.background2:SetColorTexture(0.16, 0.19, 0.19);

    self.background3 = self:CreateTexture();
    self.background3:ClearAllPoints();
    self.background3:SetAllPoints();
    self.background3:SetColorTexture(0.16, 0.19, 0.19);
end

function MainFrame:OnUpdate(self, elapse)
    if (self.updated ~= nil) then
        return;
    end

    self.updated = true;

    lib.base:runTests();
    lib.ui.resultFrame.update = true;
end


TitleFrame = {};

function TitleFrame:OnLoad(self)
    self:ClearAllPoints();
    self:SetPoint('TOPLEFT', 0, 0)
    self:SetPoint('TOPRIGHT', 0, 0)
    self:SetHeight(24);

    self:EnableMouse(true);
    self:RegisterForDrag('LeftButton');

    self.text = self:CreateFontString(nil, "ARTWORK", "GameFontNormal");
    
    self.text:SetText('LibWoWUnit');
    self.text:ClearAllPoints();
    self.text:SetPoint('LEFT', 4, 0);
end

function TitleFrame:OnDragStart(self)
    self:GetParent():StartMoving();    
end

function TitleFrame:OnDragStop(self)
    self:GetParent():StopMovingOrSizing();    
end

CloseButton = {};

function CloseButton:OnLoad(self)
    self:ClearAllPoints();
    self:SetPoint('TOPRIGHT', -4, -4);
    self:SetHeight(20);
    self:SetWidth(20);

    self.bg = self:CreateTexture();
    self.bg:ClearAllPoints();
    self.bg:SetAllPoints();
    self.bg:SetColorTexture(1, 1, 1, 0.1);

    self.texture = self:CreateTexture();
    self.texture:ClearAllPoints();
    self.texture:SetPoint('TOPLEFT', 3, -3);
    self.texture:SetPoint('BOTTOMRIGHT', -3, 3);
    self.texture:SetColorTexture(0.5, 0, 0, 0.75);
end

function CloseButton:OnClick(self, button, ...)
    lib.ui.mainFrame:Hide();
end

MinimizeButton = {};

function MinimizeButton:OnClick(self, button, ...)
    self.minized = not self.minized;

    if (self.minized) then
        lib.ui.scrollFrame:Hide();
        lib.ui.mainFrame:SetHeight(lib.ui.titleFrame:GetHeight());
    else
        lib.ui.scrollFrame:Show();
        lib.ui.mainFrame:SetHeight(lib.ui.titleFrame:GetHeight() + lib.ui.scrollFrame:GetHeight());
    end
end

function MinimizeButton:OnLoad(self)
    self:ClearAllPoints();
    self:SetPoint('TOPRIGHT', -28, -4);
    self:SetHeight(20);
    self:SetWidth(20);

    self.bg = self:CreateTexture();
    self.bg:ClearAllPoints();
    self.bg:SetAllPoints();
    self.bg:SetColorTexture(1, 1, 1, 0.1);

    self.texture = self:CreateTexture();
    self.texture:ClearAllPoints();
    self.texture:SetPoint('TOPLEFT', self, 'BOTTOMLEFT', 3, 6);
    self.texture:SetPoint('BOTTOMRIGHT', -3, 3);
    self.texture:SetColorTexture(0, 0.5, 0, 0.75);
end

ScrollFrame = {};

function ScrollFrame:OnLoad(self)
    self:ClearAllPoints();
    self:SetPoint('TOPLEFT', 4, -28);
    self:SetPoint('BOTTOMRIGHT', -4, 4);

    self:SetScrollChild(lib.ui.resultFrame);
end


ResultFrame = {};

ResultFrame.lineCache = {
    ['lines'] = {},
    ['used'] = {}
};

function ResultFrame:resetLines()
    wipe(self.lineCache.used);
end

function ResultFrame:getLine()
    local cache = self.lineCache;

    if (cache.lines[#cache.used + 1]) then
        tinsert(cache.used, cache.lines[#cache.used + 1])

        return cache.lines[#cache.used];
    end

    local line = CreateFrame('Frame', nil, self);

    line.text = line:CreateFontString(nil, "ARTWORK", "GameFontNormal");

    tinsert(cache.lines, line);

    return self:getLine();
end

function ResultFrame:addResultLine(deepth, text)
    local lastLine = self.lineCache.used[#self.lineCache.used];
    local line = self:getLine();

    line:ClearAllPoints();
    line:SetPoint('TOPLEFT', lastLine, 'BOTTOMLEFT');
    line:SetPoint('LEFT');
    line:SetPoint('RIGHT');

    line.text:SetText(text);
    line.text:ClearAllPoints();
    line.text:SetPoint('LEFT', (deepth) * 8, 0);
    line.text:SetPoint('RIGHT');

    line:Show();
    line.text:Show();
end



function ResultFrame:OnLoad(self)
    self.shortIndicator = self:CreateFontString(nil, "ARTWORK", "GameFontNormal");
    self.shortIndicator:SetWordWrap(true);
    self.shortIndicator:SetJustifyH('LEFT');
    self.shortIndicator:ClearAllPoints();
    self.shortIndicator:SetPoint('TOPLEFT');
    self.shortIndicator:SetPoint('TOPRIGHT');
    self.shortIndicator.names = {};
    self.shortIndicator:Show();

    self:SetHeight(200);
    self:SetWidth(150);

    tinsert(self.lineCache.lines, self.shortIndicator);
end


function ResultFrame:OnUpdate(self, elapsed, ...)
    if (self.update == true) then
        return;
    end

    self.update = true;

    self:resetLines();

	local line, lastLine, lastTest;
    local indicatorText, text, sumText = self:getLine(), '', '';

    indicatorText:SetText('');

	for _, result in ipairs(lib.results) do
        local test = lib.suites[result.suite][result.index];

        sumText = sumText .. lib.ui:getIndicatorText(test.result);
        indicatorText:SetText(sumText);

        for i = 1, #test.names - 1, 1 do
            if (not lastTest or lastTest.names[i] ~= test.names[i]) then
                lastTest = nil;
                self:addResultLine(i - 1, test.names[i]);
            end
        end

        self:addResultLine(#test.names - 1, test.names[#test.names] .. ' (' .. result.result .. ')');

        lastTest = test;
	end

    print(resultFrame, resultFrame:GetWidth(), resultFrame:GetHeight());

    lib.ui.scrollFrame:UpdateScrollChildRect();
end
        