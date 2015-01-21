-- show all events for debugging
-- NOTE for posterity. use /eventtrace  http://www.wowpedia.org/MACRO_eventtrace
--[[
local frame = CreateFrame('Frame')
frame:RegisterAllEvents()
frame:SetScript('OnEvent',
  function(self, event, ...)
    print(event)
    print(...)
  end
)
--]]


local squeenixFixer = CreateFrame("Frame")
squeenixFixer:RegisterEvent("UNIT_PORTRAIT_UPDATE")
squeenixFixer:SetScript("OnEvent",
  function(self, event, ...)
    Minimap:SetMaskTexture("Interface\\AddOns\\Squeenix\\Mask.blp")
  end
)


-- restore old grid "By Class" layout
-- TODO make this work with grid disabled
local GridLayout = Grid:GetModule("GridLayout")
GridLayout:AddLayout("By Class w/Pets", {
  [1] = { groupFilter = "WARRIOR", },
  [2] = { groupFilter = "DEATHKNIGHT", },
  [3] = { groupFilter = "ROGUE", },
  [4] = { groupFilter = "PALADIN", },
  [5] = { groupFilter = "DRUID", },
  [6] = { groupFilter = "MONK", },
  [7] = { groupFilter = "SHAMAN", },
  [8] = { groupFilter = "PRIEST", },
  [9] = { groupFilter = "MAGE", },
  [10] = { groupFilter = "WARLOCK", },
  [11] = { groupFilter = "HUNTER", },
  [12] = { isPetGroup = true, },
})

-- fixes the problem where grid is hidden on login until I switch layouts
GridLayout:ReloadLayout()


-- bring back /rl
SLASH_JTEST1 = '/rl'
function SlashCmdList.JTEST(msg, editbox)
  ReloadUI()
end


-- move and style lfg and pvp icon (now merged)
QueueStatusMinimapButtonBorder:Hide()
QueueStatusFrame:SetClampedToScreen(true)
QueueStatusMinimapButton:ClearAllPoints()
QueueStatusMinimapButton:SetPoint("BOTTOMLEFT", Minimap, "BOTTOMLEFT", -5, -5)

-- same for mail icon
-- TODO better icon available? w/o black background
MiniMapMailBorder:Hide()
MiniMapMailFrame:ClearAllPoints()
MiniMapMailFrame:SetPoint("TOPRIGHT", Minimap, "TOPRIGHT", 10, 8)
MiniMapMailIcon:SetTexCoord(0.07, 0.93, 0.07, 0.93)


-- clear lfg chat window when entering an instance
-- also scroll down when changing zones (is this a good time?)
local LFG_CHAT_FRAME_NUMBER = 5

for i = 1, 9 do
  if _G["ChatFrame" .. i .. "Tab"]:GetText() == "lfg" then
    LFG_CHAT_FRAME_NUMBER = i
  end
end

local lfgChatFrame = _G["ChatFrame" .. LFG_CHAT_FRAME_NUMBER]
local lfgChatFrameFader = CreateFrame("Frame")
lfgChatFrameFader:RegisterEvent("ZONE_CHANGED_NEW_AREA")
lfgChatFrameFader:SetScript("OnEvent",
  function(self, event, ...)
    if not lfgChatFrame:AtBottom() then
      lfgChatFrame:ScrollToBottom()
    end
    if IsInInstance() then
      lfgChatFrame:Clear()
    end
  end
)

-- fade out the lfg (and loot) frame quicker
lfgChatFrame:SetTimeVisible(15)

-- /clear to clear the lfg chat frame
SLASH_JTEST_CLEAR1 = '/clear'
function SlashCmdList.JTEST_CLEAR(msg, editbox)
  lfgChatFrame:Clear()
  -- It would be neat if the chat would fade out instead of suddenly, but I
  -- couldn't get this to work.
  --[[
  local t = lfgChatFrame:GetTimeVisible()
  print(t)
  lfgChatFrame:SetTimeVisible(0)
  lfgChatFrame:ScrollToBottom()
  -- if I set this back right away, it won't finish the fade
  --lfgChatFrame:SetTimeVisible(t)
  --]]
end


-- finding rogues for pilgim's bounty (from cladhaire)
--[[
local frame = CreateFrame("Frame")
frame:RegisterEvent("UPDATE_MOUSEOVER_UNIT")
frame:RegisterEvent("CRITERIA_UPDATE")

local status = {}
_G["hestatus"] = status

for i = 1, 8 do
  local race, _, complete = GetAchievementCriteriaInfo(3559, i)
  status[race] = complete
end

frame:SetScript("OnEvent", function(self, event, ...)
  if event == "CRITERIA_UPDATE" then
    for i = 1, 8 do
      local race, _, complete = GetAchievementCriteriaInfo(3559, i)
      status[race] = complete
    end
  elseif event == "UPDATE_MOUSEOVER_UNIT" then
    if not UnitIsPlayer("mouseover") then return end
    local race = UnitRace("mouseover")
    local class = UnitClass("mouseover")

    if class ~= "Rogue" then return end
    if race == "Worgen" then return end
    if race == "Goblin" then return end

    local key = race .. " " .. class

    if not status[key] then
      local msg = string.format("Quick, shoot %s, they're a %s", UnitName("mouseover"), key)
      RaidNotice_AddMessage(RaidBossEmoteFrame, msg, ChatTypeInfo["RAID_WARNING"])
    end
  end
end)
--]]


-- some basic introspection
local function pad(n)
  local s = ""
  for i = 1, n do
    s = s .. "  "
  end
  return s
end

-- Dridzt @ http://www.wowinterface.com/forums/showthread.php?t=32011
-- modified
function GetChildrenTree(frame, depth)
  if not frame then return end

  local frameName = frame:GetName() or "NONAME"
  print(pad(depth) .. frameName .. "(" .. type(frame) .. "):")
  if frame.GetTexture then
    print(" texture: " .. frame:GetTexture())
  end
  --if frameName == "NONAME" then  -- XXX wtf is this?
  for k,v in pairs(frame) do
    print(k, v)
  end
  --end
  if frame:GetChildren() then
    for _, child in pairs({ frame:GetChildren() }) do
      GetChildrenTree(child, depth + 1);
    end
  end
end


-- summon a random pet
-- http://www.wowinterface.com/forums/showthread.php?t=43896
-- interesting trivia - /randompet is taken and gives the same error as my old macro!
SLASH_JTEST_JRANDOMPET1 = '/jrandompet'
function SlashCmdList.JTEST_JRANDOMPET(msg, editbox)
  C_PetJournal.ClearSearchFilter()
  -- displays pets we do have:
  C_PetJournal.SetFlagFilter(LE_PET_JOURNAL_FLAG_COLLECTED, true)
  -- ignores pets we don't have:
  C_PetJournal.SetFlagFilter(LE_PET_JOURNAL_FLAG_NOT_COLLECTED, false)
  local numPets = C_PetJournal.GetNumPets(false)
  local petIndex = math.random(numPets)
  local petID, _ = C_PetJournal.GetPetInfoByIndex(petIndex, false)
  C_PetJournal.SummonPetByID(petID)
end


-- shortcut
SLASH_JTEST_FS1 = '/fs'
function SlashCmdList.JTEST_FS(msg, editbox)
  SlashCmdList.FRAMESTACK()
end


-- key binds so I don't need to use bars for this stuff
SetBindingSpell(",", "Fishing")


-- Create a binding to use ExtraActionButton1 but on the focus target.
local jExtraActionButton = CreateFrame("Button", "jExtraActionButton",
                                       UIParent, "SecureActionButtonTemplate")
jExtraActionButton:SetAttribute("type", "action")
jExtraActionButton:SetAttribute("action", 169)  -- ExtraActionButton1
jExtraActionButton:SetAttribute("unit", "focus")
if GetMacroIndexByName("jEAB") == 0 then
  CreateMacro("jEAB", "INV_MISC_QUESTIONMARK", "/click jExtraActionButton", nil)
end
SetBindingMacro("SHIFT-Q", "jEAB")


-- make quest poi buttons semi-transparent
local function FadePOIButton(parentName, buttonType, buttonIndex, questId)
  -- from blizz code
  local buttonName = "poi"..parentName..buttonType.."_"..buttonIndex;
  _G[buttonName]:SetAlpha(0.5)
  if QUEST_POI_SWAP_BUTTONS[parentName] then
    QUEST_POI_SWAP_BUTTONS[parentName]:SetAlpha(0.5)
  end
end
hooksecurefunc("QuestPOI_DisplayButton", FadePOIButton)


-- slash commands to toggle various tracking
-- jt = j track
local TRACKING  = { }
for index = 1,GetNumTrackingTypes() do
  local name, _ = GetTrackingInfo(index)
  TRACKING[name] = index
  --print(index.." "..name)
end
SLASH_JTEST_JT1 = "/jt"
function SlashCmdList.JTEST_JT(msg, editbox)

  if msg == "pet" or msg == "pets" then
    -- battle pets
    local index = TRACKING["Track Pets"]
    local name, _, active, _ = GetTrackingInfo(index)
    SetTracking(index, not active)

  elseif msg == "mail" or msg == "mailbox" then
    local index = TRACKING["Mailbox"]
    local name, _, active, _ = GetTrackingInfo(index)
    SetTracking(index, not active)
  end
end


-- say something in chat when the dungeon queue pops
local queueAlerter = CreateFrame("Frame")
queueAlerter:SetScript("OnEvent", function(self, ...) print(...) end)
queueAlerter:RegisterEvent("LFG_PROPOSAL_SHOW")
-- pet battles too
queueAlerter:RegisterEvent("PET_BATTLE_QUEUE_PROPOSE_MATCH")


-- disable right-click on SUF's focus frame
SUFUnitfocus:RegisterForClicks("LeftButtonUp")


-- workaround for taint issue introduced in 5.4.1
-- TODO remove once this is fixed by blizzard
-- http://us.battle.net/wow/en/forum/topic/10388659115
-- http://us.battle.net/wow/en/forum/topic/10388639018
-- this may break changing talents:
-- C_StorePublic.IsDisabledByParentalControls = function () return false end
-- this will only dismiss the dialog, the error will still be shown in bugsack
UIParent:HookScript("OnEvent", function(s, e, a1, a2) if e:find("ACTION_FORBIDDEN") and ((a1 or "")..(a2 or "")):find("IsDisabledByParentalControls") then StaticPopup_Hide(e) end; end)
