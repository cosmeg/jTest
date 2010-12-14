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
