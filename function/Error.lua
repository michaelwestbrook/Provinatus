local tickError = 0
local arrayErrTF = {}

local function TeamFormation_ErrorHandler(error)
	tickError = tickError + 1
	if not CustomProvTF.ErrorUI then
		CustomProvTF.ErrorUI = WINDOW_MANAGER:CreateControl(nil, GuiRoot, CT_TOPLEVELCONTROL)
		CustomProvTF.ErrorUI:SetAnchor(TOPLEFT, GuiRoot, TOPLEFT, 0, 0)
		CustomProvTF.ErrorUI:SetDrawLevel(100)
		CustomProvTF.ErrorUI.ErrLabel = WINDOW_MANAGER:CreateControl(nil, CustomProvTF.ErrorUI, CT_LABEL)
		CustomProvTF.ErrorUI.ErrLabel:SetAnchor(TOPLEFT, CustomProvTF.ErrorUI, TOPLEFT, 10, 80)
		CustomProvTF.ErrorUI.ErrLabel:SetFont("ZoFontGame")

		local fragment2 = ZO_SimpleSceneFragment:New(CustomProvTF.ErrorUI)
		SCENE_MANAGER:GetScene('hud'):AddFragment(fragment2)
		SCENE_MANAGER:GetScene('hudui'):AddFragment(fragment2)
	end

	local message = "--- [[ Prov's TeamFormation - Error L48 - Msg n°" .. tickError .. " ]] --- " .. GetTimeString() .. "." .. GetFrameTimeSeconds() .. "\n" .. error

	message = message
	:gsub("/AddOns/Provinatus/", "")
	:gsub("...C.: in function 'xpcall'(.*)", "")
	:gsub("\nstack traceback:\n.", "\n    from: ")
	:gsub("\n[^\n]*$", "")


	table.insert(arrayErrTF, message)

	if (arrayErrTF[tickError - 1]) then
		message = arrayErrTF[tickError - 1] .. "\n\n" .. message
	end

	CustomProvTF.ErrorUI.ErrLabel:SetText(message)
	CustomProvTF.ErrorUI.ErrLabel:SetHidden(false)

	local name = "CustomProvTFerrorTimeout485"
	EVENT_MANAGER:UnregisterForUpdate(name)
	EVENT_MANAGER:RegisterForUpdate(name, 12000, function ()
		CustomProvTF.ErrorUI.ErrLabel:SetHidden(true)
		EVENT_MANAGER:UnregisterForUpdate(name)
	end)
end

local tickErrLoop = 0
local function TeamFormation_ErrorFeedback(bool)
	if not bool then
		tickErrLoop = tickErrLoop + 1
	else
		tickErrLoop = 0
	end
end

local tick = 0
function CustomTeamFormation_ErrorSniffer(loopfunction)
	tick = tick + 1
	if tickErrLoop <= 10 or tick * CustomProvTF.vars.refreshRate > 15000 then
		TeamFormation_ErrorFeedback(xpcall(loopfunction, TeamFormation_ErrorHandler))
		tick = 0
	end
end