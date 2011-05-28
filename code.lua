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

--[[
-- ldb launcher for the lfg icon
-- modeled from angry_LFG
-- and http://wowprogramming.com/utils/xmlbrowser/live/FrameXML/Minimap.lua
local ldb = LibStub:GetLibrary("LibDataBroker-1.1", true)
local launcher = ldb:NewDataObject("jLFG", {
	type = "quicklauncher",
	-- XXX why can't I default this a nil and have it come up when I queue?
	icon = "Interface\\LFGFrame\\BattlenetWorking0",
	OnClick = function(clickedframe, button)
		if button == "RightButton" then 			
			ToggleDropDownMenu(1, nil, MiniMapLFGFrameDropDown, clickedframe, 0, 0)
		elseif button == "LeftButton" then 
			ToggleLFDParentFrame()
		end
	end,
	--OnEnter = MiniMapLFGFrame_OnEnter,
	-- TODO I *do* want this to be anchored correctly
	OnEnter = function(self)
		local mode, submode = GetLFGMode();
		if ( mode == "queued" ) then
			LFDSearchStatus:Show();
		elseif ( mode == "proposal" ) then
			GameTooltip:SetOwner(self, "ANCHOR_LEFT");
			GameTooltip:SetText(LOOKING_FOR_DUNGEON);
			GameTooltip:AddLine(DUNGEON_GROUP_FOUND_TOOLTIP, NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b, 1);
			GameTooltip:AddLine(" ");
			GameTooltip:AddLine(CLICK_HERE_FOR_MORE_INFO, NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b, 1);
			GameTooltip:Show();
		elseif ( mode == "rolecheck" ) then
			GameTooltip:SetOwner(self, "ANCHOR_LEFT");
			GameTooltip:SetText(LOOKING_FOR_DUNGEON);
			GameTooltip:AddLine(ROLE_CHECK_IN_PROGRESS_TOOLTIP, NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b, 1);
			GameTooltip:Show();
		elseif ( mode == "listed" ) then
			GameTooltip:SetOwner(self, "ANCHOR_LEFT");
			GameTooltip:SetText(LOOKING_FOR_RAID);
			GameTooltip:AddLine(YOU_ARE_LISTED_IN_LFR, NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b, 1);
			GameTooltip:Show();
		elseif ( mode == "lfgparty" ) then
			GameTooltip:SetOwner(self, "ANCHOR_LEFT");
			GameTooltip:SetText(LOOKING_FOR_DUNGEON);
			GameTooltip:AddLine(YOU_ARE_IN_DUNGEON_GROUP, NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b, 1);
			GameTooltip:Show();
		end
	end,
	OnLeave = MiniMapLFGFrame_OnLeave
})

MiniMapLFG_UpdateIsShown = function()
	--print "MiniMapLFG_UpdateIsShown"
	local mode, submode = GetLFGMode()
	if (mode) then
		--print "in q"
		launcher.icon = "Interface\\LFGFrame\\BattlenetWorking0"
	else
		launcher.icon = nil
	end
end

-- XXX hiding this seems to interfere with my addon
--MiniMapLFGFrame:SetScript("OnShow", function(self) self:Hide() end)
--MiniMapLFGFrame:Hide()

--SQLShowHiddenButton:Hide()
]]--
