-- show all events for debugging
-- XXX for posterity. use /eventtrace  http://www.wowpedia.org/MACRO_eventtrace
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

-- disable /w stickyness
ChatTypeInfo.WHISPER.sticky = 0

--
-- restore old grid "By Class" layout
-- TODO make this work with grid disabled
local GridLayout = Grid:GetModule("GridLayout")
GridLayout:AddLayout("By Class w/Pets", {
	[1] = { groupFilter = "WARRIOR", },
	[2] = { groupFilter = "DEATHKNIGHT", },
	[3] = { groupFilter = "ROGUE", },
	[4] = { groupFilter = "PALADIN", },
	[5] = { groupFilter = "DRUID", },
	[6] = { groupFilter = "SHAMAN", },
	[7] = { groupFilter = "PRIEST", },
	[8] = { groupFilter = "MAGE", },
	[9] = { groupFilter = "WARLOCK", },
	[10] = { groupFilter = "HUNTER", },
	[11] = { isPetGroup = true, },
})

-- fixes the problem where grid is hidden on login until I switch layouts
GridLayout:ReloadLayout()


-- hide the clock attached to the minimap
TimeManagerClockButton:Hide()


-- bring back /rl
SLASH_JTEST1 = '/rl'
function SlashCmdList.JTEST(msg, editbox)
	ReloadUI()
end

-- hide chat frame tabs
CHAT_FRAME_TAB_SELECTED_NOMOUSE_ALPHA = 0
CHAT_FRAME_TAB_NORMAL_NOMOUSE_ALPHA = 0
for i = 1, NUM_CHAT_WINDOWS do
	local tab = _G["ChatFrame"..i.."Tab"]
	tab.noMouseAlpha = 0
	tab:SetAlpha(0)
end
-- make fadeout time same as fadein
CHAT_TAB_HIDE_DELAY = 0
CHAT_FRAME_FADE_OUT_TIME = CHAT_FRAME_FADE_TIME


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


--[[
-- hide the sql expander button (which I never use and can't disable)
SQLShowHiddenButton.Show = SQLShowHiddenButton.Hide
SQLShowHiddenButton:Hide()
]]--


-- hide 'N' on the minimap
MinimapNorthTag:Hide()


-- hide the chat window minimization buttons
for i = 1, 9 do
	_G['ChatFrame' .. i .. 'ButtonFrameMinimizeButton']:Hide()
end


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
	--[[
	print('hi')
	local t = lfgChatFrame:GetTimeVisible()
	print(t)
	lfgChatFrame:SetTimeVisible(0)
	-- XXX this doesn't seem to be working
	lfgChatFrame:ScrollToBottom()
	--ChatFrame3:SetTimeVisible(120)
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


-- /ri command that emulates /raidinfo now that it's borked
SLASH_JTEST_RAIDINFO1 = '/ri'
function SlashCmdList.JTEST_RAIDINFO(msg, editbox)
	for i = 1, GetNumSavedInstances() do
		local instanceName, instanceID, instanceReset, instanceDifficulty, locked, extended, instanceIDMostSig, isRaid, maxPlayers, difficultyName, maxBosses, defeatedBosses = GetSavedInstanceInfo(i)
		if locked and isRaid then
			print(GetSavedInstanceChatLink(i) ..
					  " (" .. defeatedBosses .. "/" .. maxBosses .. ")")
		end
	end
end


-- clear recount when logging out, to speed it up
-- XXX no longer using recount
--[[
local recountClearer = CreateFrame("Frame")
recountClearer:RegisterEvent("PLAYER_LOGOUT")
recountClearer:SetScript("OnEvent",
	function(self, event, ...)
		Recount:ResetData()
	end
)
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

--GetChildrenTree(Minimap, 0)
--GetChildrenTree(ConsolidatedBuffs, 0)
-- so there are some unnamed tables here
--GetChildrenTree(MinimapBackdrop) -- this is the "stuff" (buttons, etc) around the map
--GetChildrenTree(MiniMapTracking)

--notes
-- where did I see the word "blob"? I forget...
-- http://www.wowinterface.com/downloads/info19883-_MiniBlobs.html#comments
-- /run Minimap:SetArchBlobRingScalar( 0 ); Minimap:SetQuestBlobRingScalar( 0 );
-- ahahahaa  this works
-- so how could I have found this?
-- list methods?
-- http://wowprogramming.com/docs/widgets/Minimap -- it's here, but not documented


-- hide the minimap blob ring (so that's what it's called!)
Minimap:SetArchBlobRingScalar(0)
Minimap:SetQuestBlobRingScalar(0)


-- summon a random pet
-- http://www.wowinterface.com/forums/showthread.php?t=43896
-- interesting trivia - /randompet is taken and gives the same error as my old macro!
SLASH_JTEST_JRANDOMPET1 = '/jrandompet'
function SlashCmdList.JTEST_JRANDOMPET(msg, editbox)
	C_PetJournal.ClearSearchFilter()
	C_PetJournal.SetFlagFilter(LE_PET_JOURNAL_FLAG_COLLECTED, true) -- displays pets we do have
	C_PetJournal.SetFlagFilter(LE_PET_JOURNAL_FLAG_NOT_COLLECTED, false) -- ignores pets we don't have
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
