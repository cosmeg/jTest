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
-- TODO show tabs when mousing over the chat frame
for i = 1, NUM_CHAT_WINDOWS do
	_G["ChatFrame"..i.."Tab"]:GetFontString():SetTextColor(1, 0, 0, 0)

	_G["ChatFrame"..i.."TabLeft"]:Hide()
	_G["ChatFrame"..i.."TabMiddle"]:Hide()
	_G["ChatFrame"..i.."TabRight"]:Hide()

	_G["ChatFrame"..i.."TabHighlightLeft"]:Hide()
	_G["ChatFrame"..i.."TabHighlightMiddle"]:Hide()
	_G["ChatFrame"..i.."TabHighlightRight"]:Hide()

	_G["ChatFrame"..i.."TabSelectedLeft"]:Hide()
	_G["ChatFrame"..i.."TabSelectedMiddle"]:Hide()
	_G["ChatFrame"..i.."TabSelectedRight"]:Hide()
end

FCFTab_UpdateColors = function(self, selected)
	print(self)
	if (selected) then
		self:GetFontString():SetTextColor(1, 1, 1, 0)
	else
		self:GetFontString():SetTextColor(1, 1, 1, 0)
		self.leftSelectedTexture:Hide()
		self.middleSelectedTexture:Hide()
		self.rightSelectedTexture:Hide()
	end
end
