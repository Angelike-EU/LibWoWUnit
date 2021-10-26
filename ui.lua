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
local select, tconcat, tinsert, tremove, tsort,  wipe = select, table.concat, tinsert, tremove, table.sort, wipe;
local print = print;
local math, fastrandom = math, fastrandom;

lib.ui = {};

-- restrict global environment, so we can't accidentally pollute it
setfenv(1, lib.ui);

-- frame refs
local anchorFrame, mainFrame, titleFrame, closeButton, minimizeButton, resizeButton, scrollFrame, resultFrame;

--[[
 creates a result frame to display all results

 -- argumnts:

 -- returns:
    nil
--]]
function createFrames()
    anchorFrame = lib.anchorFrame;
    mainFrame = CreateFrame('Frame', nil, anchorFrame, 'LibWoWUnitMainFrame');
    titleFrame = CreateFrame('Frame', nil, mainFrame, 'LibWoWUnitTitleFrame'); 
    closeButton = CreateFrame('Button', nil, titleFrame, 'LibWoWUnitCloseButton');
    minimizeButton = CreateFrame('Button', nil, titleFrame, 'LibWoWUnitMinimizeButton');
    resizeButton = CreateFrame('Button', nil, mainFrame, 'LibWoWUnitResizeButton');
    scrollFrame = CreateFrame('ScrollFrame', nil, mainFrame, 'LibWoWUnitScrollFrame');
    resultFrame = CreateFrame('Frame', nil, scrollFrame, 'LibWoWUnitResultFrame');

    loadScripts(anchorFrame, AnchorFrame);
    loadScripts(mainFrame, MainFrame);
    loadScripts(closeButton, CloseButton);
    loadScripts(minimizeButton, MinimizeButton);
    loadScripts(resizeButton, ResizeButton);
    loadScripts(titleFrame, TitleFrame);
    loadScripts(scrollFrame, ScrollFrame);
    loadScripts(resultFrame, ResultFrame);
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
            target:SetScript(name, function(...) data(...); end);
        else 
            target[name] = data;        
        end
    end

    if (type(scripts.OnLoad) == 'function') then
        scripts.OnLoad(target);
    end
end

local shortTestIndicators = {
    ['Error'] = 'E',
    ['Failed'] = 'F',
    ['Skipped'] = 'S',
    ['Skipped-Implicit'] = 's',
    ['Risky'] = '|cffff0000R|r',
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
___  ____      _           
|  \/  (_)    (_)          
| .  . |___  ___ _ __  ___ 
| |\/| | \ \/ / | '_ \/ __|
| |  | | |>  <| | | | \__ \
\_|  |_/_/_/\_\_|_| |_|___/
-----------------------------------------------------------------------------]]

--[[
  ___             _               ______                        
 / _ \           | |              |  ___|                       
/ /_\ \_ __   ___| |__   ___  _ __| |_ _ __ __ _ _ __ ___   ___ 
|  _  | '_ \ / __| '_ \ / _ \| '__|  _| '__/ _` | '_ ` _ \ / _ \
| | | | | | | (__| | | | (_) | |  | | | | | (_| | | | | | |  __/
\_| |_/_| |_|\___|_| |_|\___/|_|  \_| |_|  \__,_|_| |_| |_|\___|
--]]

AnchorFrame = {};

--[[---------------------------------------------------------------------------
initializes the anchor frame
------------------------------------------------------------------------------]]
function AnchorFrame:OnLoad()
    self:SetMovable(true);
    self:SetWidth(1);
    self:SetHeight(1);
    self:ClearAllPoints();
    self:SetPoint(lib.db.point, lib.db.x, lib.db.y);
end

function AnchorFrame:OnUpdate(elapsed)
    if (#lib.tests2run == 0) then
        return;
    end

    local tests2run = {};

    while (#lib.tests2run > 0) do
        local index = fastrandom(#lib.tests2run);
        
        tinsert(tests2run, tremove(lib.tests2run, index));
    end

    lib.tests2run = tests2run;
    
    lib.base.runTest(tremove(tests2run));

    if (#tests2run == 0) then
        tsort(lib.results, function(a, b)
            local namesA = lib.suites[a.suite][a.index].names;
            local namesB = lib.suites[b.suite][b.index].names;

            return tconcat(namesA, ' -> ') < tconcat(namesB, ' -> ');
        end)
    end

    resultFrame.updated = false;
end

function AnchorFrame:savePosition()
    lib.db.point, lib.db.x, lib.db.y = select(3, self:GetPoint(1));
end

--[[
___  ___      _      ______                        
|  \/  |     (_)     |  ___|                       
| .  . | __ _ _ _ __ | |_ _ __ __ _ _ __ ___   ___ 
| |\/| |/ _` | | '_ \|  _| '__/ _` | '_ ` _ \ / _ \
| |  | | (_| | | | | | | | | | (_| | | | | | |  __/
\_|  |_/\__,_|_|_| |_\_| |_|  \__,_|_| |_| |_|\___|
--]]

MainFrame = {};

function MainFrame:OnLoad()
    self:ClearAllPoints();
    self:SetPoint('TOPLEFT');

    self:SetResizable(true);
    self:EnableMouse(true);
    self:SetShown(not lib.db.closed);

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

    self:updateFrame();
end

function MainFrame:saveSize()
    lib.db.width = self:GetWidth();
    lib.db.height = self:GetHeight();
end

function MainFrame:updateFrame()
    if (lib.db.minimized) then
        resizeButton:Hide();
        scrollFrame:Hide();
        self:SetHeight(24);
        self:SetWidth(150);
    else
        resizeButton:Show();
        scrollFrame:Show();
        self:SetHeight(lib.db.width);
        self:SetWidth(lib.db.height);
        resultFrame:SetWidth(scrollFrame:GetWidth() - 20);

        resultFrame.updated = false;
    end
end

--[[
 _____ _ _   _     ______       _   _              
|_   _(_) | | |    | ___ \     | | | |             
  | |  _| |_| | ___| |_/ /_   _| |_| |_ ___  _ __  
  | | | | __| |/ _ \ ___ \ | | | __| __/ _ \| '_ \ 
  | | | | |_| |  __/ |_/ / |_| | |_| || (_) | | | |
  \_/ |_|\__|_|\___\____/ \__,_|\__|\__\___/|_| |_|
--]]

TitleFrame = {};

function TitleFrame:OnLoad()
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

function TitleFrame:OnDragStart()
    anchorFrame:StartMoving();
end

function TitleFrame:OnDragStop()
    anchorFrame:StopMovingOrSizing();
    anchorFrame:savePosition();
end

--[[
 _____ _               ______       _   _              
/  __ \ |              | ___ \     | | | |             
| /  \/ | ___  ___  ___| |_/ /_   _| |_| |_ ___  _ __  
| |   | |/ _ \/ __|/ _ \ ___ \ | | | __| __/ _ \| '_ \ 
| \__/\ | (_) \__ \  __/ |_/ / |_| | |_| || (_) | | | |
 \____/_|\___/|___/\___\____/ \__,_|\__|\__\___/|_| |_|
--]]

CloseButton = {};

function CloseButton:OnLoad()
    self:ClearAllPoints();
    self:SetPoint('RIGHT', -4, 0);
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

function CloseButton:OnClick(button, ...)
    mainFrame:Hide();
end

--[[
___  ____       _           _        ______       _   _              
|  \/  (_)     (_)         (_)       | ___ \     | | | |             
| .  . |_ _ __  _ _ __ ___  _ _______| |_/ /_   _| |_| |_ ___  _ __  
| |\/| | | '_ \| | '_ ` _ \| |_  / _ \ ___ \ | | | __| __/ _ \| '_ \ 
| |  | | | | | | | | | | | | |/ /  __/ |_/ / |_| | |_| || (_) | | | |
\_|  |_/_|_| |_|_|_| |_| |_|_/___\___\____/ \__,_|\__|\__\___/|_| |_|
--]]

MinimizeButton = {};

function MinimizeButton:OnClick(button, ...)
    lib.db.minimized = not lib.db.minimized;

    mainFrame:updateFrame();
end

function MinimizeButton:OnLoad()
    self:ClearAllPoints();
    self:SetPoint('RIGHT', -28, 0);
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

--[[
______          _        ______       _   _              
| ___ \        (_)       | ___ \     | | | |             
| |_/ /___  ___ _ _______| |_/ /_   _| |_| |_ ___  _ __  
|    // _ \/ __| |_  / _ \ ___ \ | | | __| __/ _ \| '_ \ 
| |\ \  __/\__ \ |/ /  __/ |_/ / |_| | |_| || (_) | | | |
\_| \_\___||___/_/___\___\____/ \__,_|\__|\__\___/|_| |_|
--]]

ResizeButton = {};

function ResizeButton:OnLoad()
    self:ClearAllPoints();
    self:SetPoint('BOTTOMRIGHT');

    self:SetWidth(12);
    self:SetHeight(12);

    self:SetNormalTexture('Interface/ChatFrame/UI-ChatIM-SizeGrabber-Up');
    self:SetHighlightTexture('Interface/ChatFrame/UI-ChatIM-SizeGrabber-Highlight');
    self:SetPushedTexture('Interface/ChatFrame/UI-ChatIM-SizeGrabber-Down');

end

function ResizeButton:OnMouseDown(button)
    self.updateTime = 0.25;
    self:SetButtonState('PUSHED', true);
    self:GetHighlightTexture():Hide();
    --SetCursor('UI-Cursor-Size');	--Hide the cursor
    mainFrame:StartSizing('BOTTOMRIGHT');
end

function ResizeButton:OnMouseUp(button)
    self:SetButtonState('NORMAL', false);
    self:GetHighlightTexture():Show();
    --SetCursor(nil); --Show the cursor again

    mainFrame:StopMovingOrSizing();
    -- reattach point, because frame:StartSizing deattach all points
    mainFrame:ClearAllPoints();
    mainFrame:SetPoint('TOPLEFT');

    mainFrame:saveSize();
end

function ResizeButton:OnUpdate(elapsed)
    if (self:GetButtonState() == 'NORMAL') then
        return;
    end

    self.updateTime = self.updateTime - elapsed;

    if (self.updateTime > 0) then
        return;
    end

    self.updateTime = 0.25;

    resultFrame:SetWidth(scrollFrame:GetWidth() - 20);
    resultFrame.updated = false;
end

--[[
 _____                _ _______                        
/  ___|              | | |  ___|                       
\ `--.  ___ _ __ ___ | | | |_ _ __ __ _ _ __ ___   ___ 
 `--. \/ __| '__/ _ \| | |  _| '__/ _` | '_ ` _ \ / _ \
/\__/ / (__| | | (_) | | | | | | | (_| | | | | | |  __/
\____/ \___|_|  \___/|_|_\_| |_|  \__,_|_| |_| |_|\___|
--]]

ScrollFrame = {};

function ScrollFrame:OnLoad()
    self:ClearAllPoints();
    self:SetPoint('TOPLEFT', 4, -28);
    self:SetPoint('BOTTOMRIGHT', -4, 4);

    self:SetScrollChild(resultFrame);
    self:EnableMouseWheel(true);
end

function ScrollFrame:OnMouseWheel(delta)
    local height = self:GetHeight();
    local offset, range = self:GetVerticalScroll(), self:GetVerticalScrollRange();
    local step = height * 0.10 * delta; -- 10%
    local newOffset = offset - step;
    
    if (newOffset < 0) then
        return self:SetVerticalScroll(0);
    end

    if (newOffset > range) then
        return self:SetVerticalScroll(range);
    end

    self:SetVerticalScroll(offset - step);
end

--[[
______                _ _  ______                        
| ___ \              | | | |  ___|                       
| |_/ /___  ___ _   _| | |_| |_ _ __ __ _ _ __ ___   ___ 
|    // _ \/ __| | | | | __|  _| '__/ _` | '_ ` _ \ / _ \
| |\ \  __/\__ \ |_| | | |_| | | | | (_| | | | | | |  __/
\_| \_\___||___/\__,_|_|\__\_| |_|  \__,_|_| |_| |_|\___|
--]]

ResultFrame = {};

function ResultFrame:resetLines()
    while (#self.usedLines > 0) do
        tremove(self.usedLines):reset();
    end
end

function ResultFrame:getLine()
    if (self.lines[#self.usedLines + 1]) then
        tinsert(self.usedLines, self.lines[#self.usedLines + 1])

        return self.lines[#self.usedLines];
    end

    local line = CreateFrame('Frame', nil, self, 'LibWoWUnitLineFrame');

    loadScripts(line, ResultLine);

    line:setRandomColor();

    return self:getLine();
end

function ResultFrame:addResultLine(deepth, text)
    local lastLine = self.usedLines[#self.usedLines];
    local line = self:getLine();

    line:ClearAllPoints();
    line:SetPoint('TOPLEFT', lastLine, 'BOTTOMLEFT');
    line:SetPoint('TOPRIGHT', lastLine, 'BOTTOMRIGHT');

    line.text:SetText(text);
    line.text:ClearAllPoints();
    line.text:SetPoint('TOPLEFT', (deepth) * 8, 0);
    line.text:SetPoint('TOPRIGHT');
    --line.text:SetJustifyH('LEFT');

    line:Show();
    line.text:Show();
end



function ResultFrame:OnLoad()
    self.lines = {};
    self.usedLines = {};

    self:ClearAllPoints();
    self:SetPoint('TOPLEFT');
    self:SetHeight(1);
    self:SetWidth(scrollFrame:GetWidth() - 20);
end


function ResultFrame:OnUpdate(elapsed, ...)
    if (self.updated == true) then
        return;
    end

    self.updated = true;

    self:resetLines();

	local line, lastLine, lastTest;
    local indicatorLine, text, sumText = self:getLine(), '', '';

    indicatorLine.text:SetText('');
    indicatorLine.text:SetMaxLines(0);
    indicatorLine.text:SetWordWrap(true);
    indicatorLine:ClearAllPoints();
    indicatorLine:SetPoint('TOPLEFT');
    indicatorLine:SetPoint('TOPRIGHT');
    indicatorLine:Show();


	for _, result in ipairs(lib.results) do
        local test = lib.suites[result.suite][result.index];

        sumText = sumText .. lib.ui.getIndicatorText(result.result);
        indicatorLine.text:SetText(sumText);

        for i = 1, #test.names - 1, 1 do
            if (not lastTest or lastTest.names[i] ~= test.names[i]) then
                lastTest = nil;
                self:addResultLine(i - 1, test.names[i]);
            end
        end

        self:addResultLine(#test.names - 1, '* ' .. test.names[#test.names] .. ' (' .. result.result .. ')');

        lastTest = test;
	end

    self:SetHeight(indicatorLine.text:GetHeight() + (#self.usedLines * 15));
    
    for i = 1, resultFrame:GetNumPoints(), 1 do
        local point, relativeTo, relativePoint, x, y = resultFrame:GetPoint(i);
    end

    scrollFrame:UpdateScrollChildRect();
end

--[[
______                _ _   _     _            
| ___ \              | | | | |   (_)           
| |_/ /___  ___ _   _| | |_| |    _ _ __   ___ 
|    // _ \/ __| | | | | __| |   | | '_ \ / _ \
| |\ \  __/\__ \ |_| | | |_| |___| | | | |  __/
\_| \_\___||___/\__,_|_|\__\_____/_|_| |_|\___|
--]]

ResultLine = {}

function ResultLine:OnLoad()
    local text = self.text or self:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall");

    self:SetHeight(text:GetLineHeight());
    self:SetWidth(1);

    text:ClearAllPoints();
    text:SetPoint('TOPLEFT');
    text:SetPoint('TOPRIGHT');
    text:SetJustifyH('LEFT');
    text:SetMaxLines(1);
    text:SetWordWrap(false);

    self.text = text;
end

function ResultLine:reset()
    ResultLine.OnLoad(self);

    self:Hide();
end

function ResultLine:setRandomColor()
    local bg = self.bg or self:CreateTexture();

    bg:SetAllPoints();

    local r = math.random(1, 8) / 8;
    local b = math.random(1, 8) / 8;
    local g = math.random(1, 8) / 8;

    bg:SetColorTexture(r, g, b);

    self.bg = bg;
end
