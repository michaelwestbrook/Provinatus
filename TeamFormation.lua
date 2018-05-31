function CustomTeamFormation_Keypress()
	CustomTeamFormation_SetHidden(CustomProvTF.vars.enabled)
	CustomProvTF.vars.enabled = not CustomProvTF.vars.enabled

	if CustomProvTF.vars.enabled then
		d(GetString(SI_TF_ENABLED))
	else
		d(GetString(SI_TF_DISABLED))
	end
end

function CustomTeamFormation_SetHidden(bool)
	CustomProvTF.UI:SetHidden(GetGroupSize() == 0 or bool)
end

function CustomTeamFormation_ResetRefreshRate()
	EVENT_MANAGER:UnregisterForEvent(CustomProvTF.name .. "Update")
	EVENT_MANAGER:RegisterForUpdate(CustomProvTF.name .. "Update", CustomProvTF.vars.refreshRate, function() CustomTeamFormation_OnUpdate() end)
end

local function TeamFormation_OnAddOnLoad(eventCode, addOnName)
	if (CustomProvTF.name ~= addOnName) then return end

	CrownPointerThing.EVENT_ADD_ON_LOADED(eventCode, addOnName)
	CustomProvTF.vars = ZO_SavedVars:NewAccountWide("CustomProvTFSV", 1, nil, CustomProvTF.defaults)

	SLASH_COMMANDS["/tf"] = function()
		LAM2:OpenToPanel(CustomProvTF.CPL)
	end

	CustomProvTF.UI = WINDOW_MANAGER:CreateControl(nil, GuiRoot, CT_TOPLEVELCONTROL)
	CustomProvTF.UI:SetMouseEnabled(false)
	CustomProvTF.UI:SetClampedToScreen(true)
	CustomProvTF.UI:SetDimensions(CustomProvTF.vars.width, CustomProvTF.vars.height)
	CustomProvTF.UI:SetDrawLevel(0)
	CustomProvTF.UI:SetDrawLayer(0)
	CustomProvTF.UI:SetDrawTier(0)

	CustomProvTF.UI:SetHidden(not CustomProvTF.vars.enabled)
	CustomProvTF.UI:ClearAnchors()
	CustomProvTF.UI:SetAnchor(CENTER, GuiRoot, CENTER, CustomProvTF.vars.posx, CustomProvTF.vars.posy)

	CustomProvTF.UI.Cardinal = {}
	for i = 1, 4 do
		CustomProvTF.UI.Cardinal[i] = WINDOW_MANAGER:CreateControl(nil, CustomProvTF.UI, CT_LABEL)
		CustomProvTF.UI.Cardinal[i]:SetAnchor(CENTER, CustomProvTF.UI, CENTER, 0, 0)
		CustomProvTF.UI.Cardinal[i]:SetFont("ZoFontHeader4")
		CustomProvTF.UI.Cardinal[i]:SetDrawLevel(0)
		CustomProvTF.UI.Cardinal[i]:SetAlpha(CustomProvTF.vars.cardinal)
	end

	CustomProvTF.UI.Cardinal[1]:SetText(GetString(SI_COMPASS_NORTH_ABBREVIATION))
	CustomProvTF.UI.Cardinal[2]:SetText(GetString(SI_COMPASS_EAST_ABBREVIATION))
	CustomProvTF.UI.Cardinal[3]:SetText(GetString(SI_COMPASS_SOUTH_ABBREVIATION))
	CustomProvTF.UI.Cardinal[4]:SetText(GetString(SI_COMPASS_WEST_ABBREVIATION))


	CustomProvTF.UI.Player = {}

	local fragment = ZO_SimpleSceneFragment:New(CustomProvTF.UI)
	SCENE_MANAGER:GetScene('hud'):AddFragment(fragment)
	SCENE_MANAGER:GetScene('hudui'):AddFragment(fragment)

	EVENT_MANAGER:UnregisterForEvent(CustomProvTF.name, EVENT_ADD_ON_LOADED)

	CustomTeamFormation_createLAM2Panel()
	EVENT_MANAGER:RegisterForUpdate(CustomProvTF.name .. "Update", CustomProvTF.vars.refreshRate, function() CustomTeamFormation_OnUpdate() end)

	EVENT_MANAGER:RegisterForEvent(CustomProvTF.name, EVENT_BEGIN_SIEGE_CONTROL, function()
		if CustomProvTF.vars.enabled then
			CustomTeamFormation_SetHidden(not CustomProvTF.vars.siege)
		end
	end)
end

function CustomTeamFormation_OnInitialized()
	EVENT_MANAGER:RegisterForEvent(CustomProvTF.name, EVENT_ADD_ON_LOADED, function(...) TeamFormation_OnAddOnLoad(...) end)
end
