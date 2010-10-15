
--frame:RegisterEvent("GUILD_ROSTER_UPDATE")
--frame:RegisterAllEvents()

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
--GridLayout:AddLayout("By Class w/Pets", {
--	[1] = { groupFilter = "WARRIOR", },
--	[2] = { groupFilter = "DEATHKNIGHT", },
--	[3] = { groupFilter = "ROGUE", },
--	[4] = { groupFilter = "PALADIN", },
--	[5] = { groupFilter = "DRUID", },
--	[6] = { groupFilter = "SHAMAN", },
--	[7] = { groupFilter = "PRIEST", },
--	[8] = { groupFilter = "MAGE", },
--	[9] = { groupFilter = "WARLOCK", },
--	[10] = { groupFilter = "HUNTER", },
--	[11] = { isPetGroup = true, },
--})

-- hmm so the icon comes back when you change tabs
-- what's the event for that?
