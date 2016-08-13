if Grid then
  -- restore old grid "By Class" layout
  local GridLayout = Grid:GetModule("GridLayout")
  GridLayout:AddLayout("By Class w/Pets", {
    [1] = { groupFilter = "WARRIOR", },
    [2] = { groupFilter = "DEATHKNIGHT", },
    [3] = { groupFilter = "DEMONHUNTER", },
    [4] = { groupFilter = "ROGUE", },
    [5] = { groupFilter = "PALADIN", },
    [6] = { groupFilter = "DRUID", },
    [7] = { groupFilter = "MONK", },
    [8] = { groupFilter = "SHAMAN", },
    [9] = { groupFilter = "PRIEST", },
    [10] = { groupFilter = "MAGE", },
    [11] = { groupFilter = "WARLOCK", },
    [12] = { groupFilter = "HUNTER", },
    [13] = { isPetGroup = true, },
  })

  -- fixes the problem where grid is hidden on login until I switch layouts
  GridLayout:ReloadLayout()
end


-- bring back /rl
SLASH_JTEST1 = '/rl'
function SlashCmdList.JTEST(msg, editbox)
  ReloadUI()
end


---- clear lfg chat window when entering an instance
---- also scroll down when changing zones (is this a good time?)
--local LFG_CHAT_FRAME_NUMBER = 5
--
--for i = 1, 9 do
--  if _G["ChatFrame" .. i .. "Tab"]:GetText() == "lfg" then
--    LFG_CHAT_FRAME_NUMBER = i
--  end
--end
--
--local lfgChatFrame = _G["ChatFrame" .. LFG_CHAT_FRAME_NUMBER]
--local lfgChatFrameFader = CreateFrame("Frame")
--lfgChatFrameFader:RegisterEvent("ZONE_CHANGED_NEW_AREA")
--lfgChatFrameFader:SetScript("OnEvent",
--  function(self, event, ...)
--    if not lfgChatFrame:AtBottom() then
--      lfgChatFrame:ScrollToBottom()
--    end
--    if IsInInstance() then
--      lfgChatFrame:Clear()
--    end
--  end
--)
--
---- fade out the lfg (and loot) frame quicker
--lfgChatFrame:SetTimeVisible(15)
--
---- /clear to clear the lfg chat frame
--SLASH_JTEST_CLEAR1 = '/clear'
--function SlashCmdList.JTEST_CLEAR(msg, editbox)
--  lfgChatFrame:Clear()
--  -- It would be neat if the chat would fade out instead of suddenly, but I
--  -- couldn't get this to work.
--  --[[
--  local t = lfgChatFrame:GetTimeVisible()
--  print(t)
--  lfgChatFrame:SetTimeVisible(0)
--  lfgChatFrame:ScrollToBottom()
--  -- if I set this back right away, it won't finish the fade
--  --lfgChatFrame:SetTimeVisible(t)
--  --]]
--end


-- /framestack shortcut
SLASH_JTEST_FS1 = '/fs'
function SlashCmdList.JTEST_FS(msg, editbox)
  SlashCmdList.FRAMESTACK(msg)
end

-- /eventtrace shortcut
SLASH_JTEST_ET1 = '/et'
function SlashCmdList.JTEST_ET(msg, editbox)
  SlashCmdList.EVENTTRACE(msg)
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


-- say something in chat when the dungeon queue pops
local queueAlerter = CreateFrame("Frame")
queueAlerter:SetScript("OnEvent", function(self, ...) print(...) end)
queueAlerter:RegisterEvent("LFG_PROPOSAL_SHOW")
-- pet battles too
queueAlerter:RegisterEvent("PET_BATTLE_QUEUE_PROPOSE_MATCH")


-- disable right-click on SUF's focus frame
SUFUnitfocus:RegisterForClicks("LeftButtonUp")


-- for reference, useful with /dump
--ChatFrame1:SetMaxLines(1024)


-- slash command to open bugsack
SLASH_JTESTBS1 = '/bs'
function SlashCmdList.JTESTBS(msg, editbox)
  BugSack:OpenSack()
end
-- TODO command to clear bugs


SLASH_JTEST_GARRISON1 = '/gar'
SLASH_JTEST_GARRISON2 = '/garrison'
function SlashCmdList.JTEST_GARRISON(msg, editbox)
  GarrisonLandingPage_Toggle()
end

SLASH_JTEST_MISSIONS1 = '/miss'
SLASH_JTEST_MISSIONS2 = '/missions'
function SlashCmdList.JTEST_MISSIONS(msg, editbox)
  -- TODO can I find the max somewhere?
  for followerType = 1,10 do
    local missions = {}
    C_Garrison.GetInProgressMissions(missions, followerType)
    for i, m in ipairs(missions) do
      print(m.name.." - "..m.timeLeft)
    end
  end
end


-- apparently this is reset at each login
SetCVar("cameraDistanceMaxFactor", 2.6)
