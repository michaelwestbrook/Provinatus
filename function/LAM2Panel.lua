local function colorizePseudo(rgb, pseudo)
	local color = ZO_ColorDef:New(unpack(rgb))
	return "|c" .. color:ToHex() .. "|t24:24:EsoUI/Art/Miscellaneous/Gamepad/gp_charNameIcon.dds:inheritcolor|t " .. pseudo
end

local function TeamFormation_mapChoices(func, array)
	local new_array = {}

	if not array then return array end

	for k, v in pairs(array) do
		table.insert(new_array, func(v, k))
	end

	return new_array
end

local function TeamFormation_mapJRULES()
	return TeamFormation_mapChoices(colorizePseudo, ProvTF.vars.jRules)
end

local function ResetCrownPointer()
	CrownPointerThing.SavedVars.CrownPointer.Enabled = ProvinatusConfig.CrownPointer.Enabled;
	CrownPointerThing.SavedVars.CrownPointer.Alpha = ProvinatusConfig.CrownPointer.Alpha;
	CrownPointerThing.SavedVars.CrownPointer.Size = ProvinatusConfig.CrownPointer.Size
	CrownPointerThing.SavedVars.Debug = ProvinatusConfig.Debug;
	CrownPointerThing.SavedVars.DebugSettings.Reticle.AngleToTarget = ProvinatusConfig.DebugSettings.Reticle.AngleToTarget
end

function TeamFormation_createLAM2Panel()
	local panelData =
	{
		type = "panel",
		name = ProvTF.namePublic,
		displayName = ProvTF.nameColor,
		author = ProvTF.author,
		version = ProvTF.version,
		slashCommand = "/tf",
		registerForRefresh = true,
		registerForDefaults = true,
		resetFunc = function()
			ProvTF.vars = nil
			ProvTF.vars = ProvTF.defaults
			ProvTF.vars.jRules = nil
			ProvTF.vars.jRules = {}

			ProvTF.UI:SetAnchor(CENTER, GuiRoot, CENTER, ProvTF.vars.posx, ProvTF.vars.posy)
			TeamFormation_SetHidden(not ProvTF.vars.enabled)

			TeamFormation_ResetRefreshRate()
			ResetCrownPointer()
		end,
	}

	local optionsData =
	{
		{
			type = "description",
			text = GetString(SI_TF_DESC_TEAMFORMATION),
		},
		{
			type = "checkbox",
			name = GetString(SI_TF_SETTING_ENABLED),
			tooltip = GetString(SI_TF_SETTING_ENABLED_TOOLTIP),
			getFunc = function() return ProvTF.vars.enabled end,
			setFunc = function(value)
				ProvTF.vars.enabled = value
				TeamFormation_SetHidden(not ProvTF.vars.enabled)
			end,
			width = "full",
		},
		{
			type = "description",
			text = GetString(SI_TF_SETTING_SHOWNOW_TOOLTIP),
			width = "half",
		},
		{
			type = "button",
			name = GetString(SI_TF_SETTING_SHOWNOW),
			tooltip = GetString(SI_TF_SETTING_SHOWNOW_TOOLTIP),
			func = function()
				if ProvTF.vars.enabled then
					TeamFormation_SetHidden(false)
				end
			end,
			width = "half"
		},
		{
			type = "submenu",
			name = GetString(SI_TF_SETTING_SIZEOPTIONS),
			controls =
			{
				[1] = {
					type = "description",
					text = GetString(SI_TF_SETTING_SIZEOPTIONS_TOOLTIP),
				},
				[2] = {
					type = "slider",
					name = GetString(SI_TF_SETTING_X),
					tooltip = GetString(SI_TF_SETTING_X_TOOLTIP),
					min = -zo_round(GuiRoot:GetWidth() / 2), max = zo_round(GuiRoot:GetWidth() / 2), step = 1,
					getFunc = function() return ProvTF.vars.posx end,
					setFunc = function(value)
						ProvTF.vars.posx = value
						ProvTF.UI:SetAnchor(CENTER, GuiRoot, CENTER, ProvTF.vars.posx, ProvTF.vars.posy)
					end,
					width = "half",
				},
				[3] = {
					type = "slider",
					name = GetString(SI_TF_SETTING_Y),
					tooltip = GetString(SI_TF_SETTING_Y_TOOLTIP),
					min = -zo_round(GuiRoot:GetHeight() / 2), max = zo_round(GuiRoot:GetHeight() / 2), step = 1,
					getFunc = function() return ProvTF.vars.posy end,
					setFunc = function(value)
						ProvTF.vars.posy = value
						ProvTF.UI:SetAnchor(CENTER, GuiRoot, CENTER, ProvTF.vars.posx, ProvTF.vars.posy)
					end,
					width = "half",
				},
				[4] = {
					type = "slider",
					name = GetString(SI_TF_SETTING_WIDTH),
					tooltip = GetString(SI_TF_SETTING_WIDTH_TOOLTIP),
					min = 20, max = zo_round(GuiRoot:GetWidth()), step = 1,
					getFunc = function() return ProvTF.vars.width end,
					setFunc = function(value)
						ProvTF.vars.width = value
						ProvTF.UI:SetDimensions(ProvTF.vars.width, ProvTF.vars.height)
					end,
					width = "half",
				},
				[5] = {
					type = "slider",
					name = GetString(SI_TF_SETTING_HEIGHT),
					tooltip = GetString(SI_TF_SETTING_HEIGHT_TOOLTIP),
					min = 20, max = zo_round(GuiRoot:GetHeight()), step = 1,
					getFunc = function() return ProvTF.vars.height end,
					setFunc = function(value)
						ProvTF.vars.height = value
						ProvTF.UI:SetDimensions(ProvTF.vars.width, ProvTF.vars.height)
					end,
					width = "half",
				}
			},
		},
		{
			type = "submenu",
			name = GetString(SI_TF_SETTING_FOCUSOPTIONS),
			controls =
			{
				[1] = {
					type = "description",
					text = GetString(SI_TF_SETTING_FOCUSOPTIONS_TOOLTIP),
				},
				[2] = {
					type = "slider",
					name = GetString(SI_TF_SETTING_REFRESHRATE),
					tooltip = GetString(SI_TF_SETTING_REFRESHRATE_TOOLTIP),
					warning = GetString(SI_TF_SETTING_REFRESHRATE_WARNING),
					min = 10, max = 100, step = 1,
					getFunc = function() return ProvTF.vars.refreshRate end,
					setFunc = function(value)
						ProvTF.vars.refreshRate = value

						TeamFormation_ResetRefreshRate()
					end,
					width = "full",
				},
				[3] = {
					type = "dropdown",
					name = GetString(SI_TF_SETTING_SHAPE),
					tooltip = GetString(SI_TF_SETTING_SHAPE_TOOLTIP),
					choices = { GetString(SI_TF_SETTING_SHAPE_RECTANGULAR), GetString(SI_TF_SETTING_SHAPE_CIRCULAR) },
					getFunc = function()
						return (ProvTF.vars.circle and GetString(SI_TF_SETTING_SHAPE_CIRCULAR) or GetString(SI_TF_SETTING_SHAPE_RECTANGULAR))
					end,
					setFunc = function(var)
						ProvTF.vars.circle = (var == GetString(SI_TF_SETTING_SHAPE_CIRCULAR))
					end,
				},
				[4] =
				{
					type = "checkbox",
					name = GetString(SI_TF_SETTING_CAMROTATION),
					tooltip = GetString(SI_TF_SETTING_CAMROTATION_TOOLTIP),
					getFunc = function() return ProvTF.vars.camRotation end,
					setFunc = function(value)
						ProvTF.vars.camRotation = value
					end,
					width = "full",
				},
				[5] = {
					type = "slider",
					name = GetString(SI_TF_SETTING_SCALE),
					tooltip = GetString(SI_TF_SETTING_SCALE_TOOLTIP),
					min = 10, max = 200, step = 1,
					getFunc = function() return ProvTF.vars.scale end,
					setFunc = function(value)
						ProvTF.vars.scale = value
					end,
					width = "full",
				},
				[6] = {
					type = "slider",
					name = GetString(SI_TF_SETTING_LOGDIST) .. " (%)",
					tooltip = GetString(SI_TF_SETTING_LOGDIST_TOOLTIP),
					min = 0, max = 100, step = 1,
					getFunc = function() return ProvTF.vars.logdist * 100 end,
					setFunc = function(value)
						ProvTF.vars.logdist = value / 100
					end,
					width = "full",
				},
				[7] = {
					type = "slider",
					name = GetString(SI_TF_SETTING_CARDINAL) .. " (%)",
					tooltip = GetString(SI_TF_SETTING_CARDINAL_TOOLTIP),
					min = 0, max = 100, step = 1,
					getFunc = function() return ProvTF.vars.cardinal * 100 end,
					setFunc = function(value)
						ProvTF.vars.cardinal = value / 100
					end,
					width = "full",
				},
				[8] =
				{
					type = "checkbox",
					name = GetString(SI_TF_SETTING_SIEGE),
					tooltip = GetString(SI_TF_SETTING_SIEGE_TOOLTIP),
					getFunc = function() return ProvTF.vars.siege end,
					setFunc = function(value)
						ProvTF.vars.siege = value
					end,
					width = "full",
				},
			},
		},
		{
			type = "submenu",
			name = GetString(CROWN_POINTER_THING),
			controls ={
			{
				type = "checkbox",
				name = GetString(CROWN_POINTER_ENABLE),
				tooltip = GetString(CROWN_POINTER_ENABLE_TOOLTIP),
				getFunc = function() 
					return CrownPointerThing.SavedVars.CrownPointer.Enabled
				end,
				setFunc = function(value)
					CrownPointerThing.SavedVars.CrownPointer.Enabled = value
				end,
				width = "full",
			},
			{
				type = "slider",
				name = GetString(CROWN_POINTER_OPACITY),
				tooltip = GetString(CROWN_POINTER_OPACITY_TOOLTIP),
				min = 0, max = 100, step = 1,
				getFunc = function()
					return CrownPointerThing.SavedVars.CrownPointer.Alpha * 100
				end,
				setFunc = function(value)
					CrownPointerThing.SavedVars.CrownPointer.Alpha = value / 100
				end,
				width = "half",
				disabled = function() 
					return not CrownPointerThing.SavedVars.CrownPointer.Enabled
				end,
			},
			{
				type = "slider",
				name = GetString(CROWN_POINTER_SIZE),
				tooltip = GetString(CROWN_POINTER_SIZE_TOOLTIP),
				min = 20, max = 100, step = 1,
				getFunc = function()
					return CrownPointerThing.SavedVars.CrownPointer.Size
				end,
				setFunc = function(value)
					CrownPointerThing.SavedVars.CrownPointer.Size = value
				end,
				width = "half",
				disabled = function() 
					return not CrownPointerThing.SavedVars.CrownPointer.Enabled
				end
			},
			{
				type = "description",
				text = GetString(CROWN_POINTER_DEBUG_SETTINGS),
			},
			{
				type = "checkbox",
				name = GetString(CROWN_POINTER_ENABLE_DEBUG),
				tooltip = GetString(CROWN_POINTER_ENABLE_DEBUG_TOOLTIP),
				getFunc = function() 
					return CrownPointerThing.SavedVars.Debug
				end,
				setFunc = function(value)
					DebugSlashCommands.SetDebug(value)
				end,
				width = "full",
				disabled = function() 
					return not CrownPointerThing.SavedVars.CrownPointer.Enabled
				end
			},
			{
					type = "slider",
					name = GetString(CROWN_POINTER_DIRECTION),
					tooltip = GetString(CROWN_POINTER_DIRECTION_TOOLTIP),
					min = tonumber(string.format("%." .. (2 or 0) .. "f", -math.pi)), max = tonumber(string.format("%." .. (2 or 0) .. "f", math.pi)), step = math.pi / 16,
					getFunc = function()
						return tonumber(string.format("%." .. (2 or 0) .. "f", CrownPointerThing.SavedVars.DebugSettings.Reticle.AngleToTarget))
					end,
					setFunc = function(value)
						CrownPointerThing.SavedVars.DebugSettings.Reticle.AngleToTarget = value
					end,
					width = "half",
					disabled = function() 
						return not CrownPointerThing.SavedVars.CrownPointer.Enabled or not CrownPointerThing.SavedVars.Debug
					end
			}
		}
		},
	}

	SLASH_COMMANDS["/tfrainbow"] = function()
		local r, g, b, pseudo
		for i = 1, 24 do
			pseudo = GetUnitName("group" .. i)
			if pseudo ~= "" then
				r, g, b = HSV2RGB(0.1 * ((i - 1) % 10), 0.5, 1.0)
				ProvTF.vars.jRules[pseudo] = { r, g, b }
				d(colorizePseudo({ r, g, b }, pseudo))
			end
		end

		local ctrl_dropdown = WINDOW_MANAGER:GetControlByName("ProvTF#jRulesList")
		if ctrl_dropdown then
			ctrl_dropdown:UpdateChoices(TeamFormation_mapJRULES())
		end
	end

	ProvTF.CPL = LAM2:RegisterAddonPanel(ProvTF.name .. "LAM2Panel", panelData)
	LAM2:RegisterOptionControls(ProvTF.name .. "LAM2Panel", optionsData)
end
