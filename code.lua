-- show all events for debugging
--[[
local frame = CreateFrame('Frame')
frame:RegisterAllEvents()
frame:SetScript('OnEvent',
	function(self, event, ...)
		print(event)
		print(...)
	end
)
]]


local squeenixFixer = CreateFrame("Frame")
squeenixFixer:RegisterEvent("UNIT_PORTRAIT_UPDATE")
squeenixFixer:SetScript("OnEvent",
	function(self, event, ...)
		Minimap:SetMaskTexture("Interface\\AddOns\\Squeenix\\Mask.blp")
	end
)

-- disable /w stickyness
ChatTypeInfo.WHISPER.sticky = 0

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


-- move and style lfg and pvp icon
MiniMapLFGFrameBorder:Hide()
LFDSearchStatus:SetClampedToScreen(true)
MiniMapLFGFrame:ClearAllPoints()
MiniMapLFGFrame:SetPoint("BOTTOMLEFT", Minimap, "BOTTOMLEFT", -5, -5)

MiniMapBattlefieldFrame:ClearAllPoints()
MiniMapBattlefieldFrame:SetPoint("BOTTOMRIGHT", Minimap, "BOTTOMRIGHT", 5, -5)
MiniMapBattlefieldBorder:Hide()


-- hide the sql expander button (which I never use and can't disable)
SQLShowHiddenButton.Show = SQLShowHiddenButton.Hide
SQLShowHiddenButton:Hide()


-- hide 'N' on the minimap
MinimapNorthTag:Hide()
