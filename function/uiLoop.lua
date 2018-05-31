local function TeamFormation_MakeIcon(index)
	if CustomProvTF.UI.Player[index] then return end

	local posLifeBar = (true and 14 or -14)

	CustomProvTF.UI.Player[index] = CreateControl(nil, CustomProvTF.UI, CT_TOPLEVELCONTROL)
	CustomProvTF.UI.Player[index]:SetDrawLevel(10)
	CustomProvTF.UI.Player[index]:SetHidden(true)
	CustomProvTF.UI.Player[index].data = {}

	CustomProvTF.UI.Player[index].Icon = WINDOW_MANAGER:CreateControl(nil, CustomProvTF.UI.Player[index], CT_TEXTURE)
	CustomProvTF.UI.Player[index].Icon:SetDimensions(24, 24)
	CustomProvTF.UI.Player[index].Icon:SetAnchor(CENTER, CustomProvTF.UI.Player[index], CENTER, 0, 0)
	CustomProvTF.UI.Player[index].Icon:SetTexture("/esoui/art/icons/mapkey/mapkey_groupmember.dds")
	CustomProvTF.UI.Player[index].Icon:SetDrawLevel(3)

	if index >= 100 then return end
	CustomProvTF.UI.Player[index].LifeBar = WINDOW_MANAGER:CreateControl(nil, CustomProvTF.UI.Player[index], CT_TEXTURE)
	CustomProvTF.UI.Player[index].LifeBar:SetDimensions(24, 2)
	CustomProvTF.UI.Player[index].LifeBar:SetColor(1, 0, 0)
	CustomProvTF.UI.Player[index].LifeBar:SetAnchor(CENTER, CustomProvTF.UI.Player[index], CENTER, 0, posLifeBar)
	CustomProvTF.UI.Player[index].LifeBar:SetDrawLevel(2)
end

local function outOfScreenRect(x1, y1, minX, minY, maxX, maxY)
	if x1 > minX and x1 < maxX and y1 > minY and y1 < maxY then
		return nil, nil
	end

	local ix = nil
	local iy = nil
	local x = nil
	local y = nil
	local m = y1 / (x1 ~= 0 and x1 or 1)

	if x1 < minX then
		y = m * minX
		if (y > minY and y < maxY) then ix = minX iy = y end
	else
		y = m * maxX
		if (y > minY and y < maxY) then ix = maxX iy = y end
	end

	if y1 < minY then
		x = minY / m
		if (x > minX and x < maxX) then ix = x iy = minY end
	else
		x = maxY / m
		if (x > minX and x < maxX) then ix = x iy = maxY end
	end

	return ix, iy
end

local function outOfScreenCircle(x1, y1, rx, ry)
	if (x1 * x1) / (rx * rx) + (y1 * y1) / (ry * ry) < 1 then
		return nil, nil
	end

	local a = math.atan2(y1, x1)
	local ix = rx * math.cos(a)
	local iy = ry * math.sin(a)

	return ix, iy
end

local function TeamFormation_getDivisor() -- RangeReticle function (Author: Adein - http://www.esoui.com/downloads/info177-RangeReticle.html)
	local mapWidth, mapHeight = GetMapNumTiles()
	local mapType = GetMapType()
	local mapContentType = GetMapContentType()

	local divisor = mapType * mapWidth

	if mapContentType == MAP_CONTENT_NONE then
		if mapType == MAPTYPE_SUBZONE then
			divisor = 1.00
		elseif mapType == MAPTYPE_ZONE then
			divisor = 0.20
		end
	elseif mapContentType == MAP_CONTENT_AVA then
		if mapType == MAPTYPE_SUBZONE then
			divisor = 1.75
		elseif mapType == MAPTYPE_ZONE then
			divisor = 0.08
		end
	elseif mapContentType == MAP_CONTENT_DUNGEON then
		if mapType == MAPTYPE_SUBZONE then
			divisor = 1.45
		elseif mapType == MAPTYPE_ZONE then
			divisor = 1.79
		end
	end

	return divisor
end

local function TeamFormation_MoveIcon(index, x, y)
	local unitTag = (index ~= 0) and ("group" .. index) or "player"

	local mx = (CustomProvTF.vars.width / 2)
	local my = (CustomProvTF.vars.height / 2)

	local bx, by
	if CustomProvTF.vars.circle then
		bx, by = outOfScreenCircle(x, y, mx, my)
	else
		bx, by = outOfScreenRect(x, y, -mx, -my, mx, my)
	end

	if bx ~= nil then x = bx y = by end

	CustomProvTF.UI.Player[index].data.isOut = (bx == nil)
	CustomProvTF.UI.Player[index]:SetAnchor(CENTER, CustomProvTF.UI, CENTER, x, y)
end

local function updateIsNecessary(index, key, value)
	if not CustomProvTF.UI.Player[index] then return end

	local oldValue = CustomProvTF.UI.Player[index].data[key]
	CustomProvTF.UI.Player[index].data[key] = value
	return (oldValue ~= value)
end

local function SetIcon(unitTag, icon)
	local class = tostring(CLASS_ID2NAME[GetUnitClassId(unitTag)])

	icon:SetTextureRotation(0)
	icon:SetHidden(false)
	if DoesUnitHaveResurrectPending(unitTag) or IsUnitBeingResurrected(unitTag) then
		icon:SetTexture(CrownPointerThing.SavedVars.PlayerIcons.ResurrectionPending)
		icon:SetColor(1, 1, 1)
		-- TODO lower alpha if they are being helped already. icon:SetAlpha(0.5, 0.5)
	elseif IsUnitDead(unitTag) then
		icon:SetColor(1, 0, 0)
		if IsUnitGroupLeader(unitTag) then
			icon:SetDimensions(48, 48)
			icon:SetTexture(CrownPointerThing.SavedVars.PlayerIcons.Dead)
		else
			icon:SetTexture(CrownPointerThing.SavedVars.PlayerIcons.Dead)
			icon:SetDimensions(32, 32)
		end
	elseif CustomProvTF.vars.roleIcon then
		local isDps, isHealer, isTank = GetGroupMemberRoles(unitTag)
		local role = "dps"
		if isTank then
			role = "tank"
		elseif isHealer then
			role = "healer"
		end
		icon:SetTexture(CrownPointerThing.SavedVars.PlayerIcons[role].Alive)
		icon:SetDimensions(32, 32)
	elseif IsUnitGroupLeader(unitTag) then
		icon:SetTexture(CrownPointerThing.SavedVars.PlayerIcons.Crown.Alive)
		icon:SetDimensions(32, 32)
	elseif class ~= "nil" then
		icon:SetTexture("/esoui/art/icons/class/class_" .. class .. ".dds")
	else
		icon:SetTexture("/esoui/art/icons/mapkey/mapkey_groupmember.dds")
		icon:SetDimensions(16, 16)
		-- TODO Why is this needed? CustomProvTF.UI.Player[index].data.name = nil -- WHY?
		--d("[TF] bug n69: " .. name .. " " .. unitTag)
	end
end

-- Used to keep track of what mode we are in. Since we don't want to set the icon on every update,
-- update icon if this value changes
local RoleMode
local function TeamFormation_UpdateIcon(index, sameZone, isDead, isInCombat)
	if GetUnitName(unitTag) == GetUnitName("player") then  return end
	local unitTag = (index ~= 0) and ("group" .. index) or "player"
	local name = GetUnitName(unitTag)
	if name == GetUnitName("player") then
		CustomProvTF.UI.Player[index].Icon:SetAlpha(0) 
		CustomProvTF.UI.Player[index].LifeBar:SetAlpha(0) 
		return 
	end
	local health, maxHealth, _ = GetUnitPower(unitTag, POWERTYPE_HEALTH)
	local sizeHealthBar = zo_round(24 * health / maxHealth)
	local isUnitBeingResurrected = isDead and IsUnitBeingResurrected(unitTag)
	local doesUnitHaveResurrectPending = isDead and DoesUnitHaveResurrectPending(unitTag)
	local updateIsNecessaryOnDead = (updateIsNecessary(index, "isDead", isDead) or
		updateIsNecessary(index, "isUnitBeingResurrected", isUnitBeingResurrected) or
		updateIsNecessary(index, "doesUnitHaveResurrectPending", doesUnitHaveResurrectPending)
	)
	local updateIsNecessaryOnSameZone = updateIsNecessary(index, "sameZone", sameZone)
	local isGroupLeader = IsUnitGroupLeader(unitTag)
	local updateIsNecessaryOnGrLeader = updateIsNecessary(index, "isGroupLeader", isGroupLeader)
	local r, g, b = unpack(CustomProvTF.vars.jRules[name] or {1, 1, 1})

	-- Set Icon
	if updateIsNecessary(index, "name", name) or updateIsNecessaryOnGrLeader or updateIsNecessaryOnDead or RoleMode ~= CustomProvTF.vars.roleIcon then
		if updateIsNecessaryOnDead then CustomProvTF.UI.Player[index].LifeBar:SetHidden(isDead) end 
		RoleMode = CustomProvTF.vars.roleIcon
		SetIcon(unitTag, CustomProvTF.UI.Player[index].Icon)
	end

	-- Set Life
	if updateIsNecessary(index, "sizeHealthBar", sizeHealthBar) then
		CustomProvTF.UI.Player[index].LifeBar:SetDimensions(sizeHealthBar, 1 / GetSetting(SETTING_TYPE_UI, UI_SETTING_CUSTOM_SCALE))
		CustomProvTF.UI.Player[index].Icon:SetColor(r, g * health / maxHealth, b * health / maxHealth)
	end

	-- Set Zone
	if updateIsNecessaryOnSameZone or updateIsNecessaryOnGrLeader or updateIsNecessaryOnDead then
		if isGroupLeader then
			CustomProvTF.UI.Player[index]:SetDrawLevel((sameZone and not isDead) and 11 or 6)
		else
			CustomProvTF.UI.Player[index]:SetDrawLevel((sameZone and not isDead) and 10 or 5)
		end
		CustomProvTF.UI.Player[index].LifeBar:SetHidden(not sameZone)
	end

	-- Set LifeBar Color
	if updateIsNecessary(index, "isInCombat", isInCombat) then
		if isInCombat and name ~= GetUnitName("player") then
			CustomProvTF.UI.Player[index].LifeBar:SetAlpha(1)
			CustomProvTF.UI.Player[index].LifeBar:SetColor(1, 0, 0)
		else
			CustomProvTF.UI.Player[index].LifeBar:SetAlpha(0)
		end
	end

	local IconAlpha
	if unitTag == GetGroupLeaderUnitTag() then
		if isDead then
			IconAlpha = CrownPointerThing.SavedVars.PlayerIconSettings.CrownDeadAlpha
		else
			IconAlpha = CrownPointerThing.SavedVars.PlayerIconSettings.CrownAlpha
		end
	elseif isDead then
		IconAlpha = CrownPointerThing.SavedVars.PlayerIconSettings.NonCrownDeadAlpha
	else
		IconAlpha = CrownPointerThing.SavedVars.PlayerIconSettings.NonCrownAlpha
	end

	CustomProvTF.UI.Player[index]:SetAlpha(IconAlpha)
end

local function TeamFormation_CalculateXY(x, y)
	if x == nil or y == nil then
		return nil, nil
	end
	local fX, fY, fHeading = GetMapPlayerPosition("player")
	local gameScale = 100 * CustomProvTF.vars.scale / TeamFormation_getDivisor()

	x = (x - fX)
	y = (y - fY)

	local head = (CustomProvTF.vars.camRotation and GetPlayerCameraHeading() or fHeading)
	local vx = (math.cos(head) * x) - (math.sin(head) * y)
	local vy = (math.sin(head) * x) + (math.cos(head) * y)

	if CustomProvTF.vars.logdist ~= 0 then
		local denominator = math.log(1000)
		if vx ~= 0 then vx = vx + (vx * math.log(math.abs(vx)) / denominator * CustomProvTF.vars.logdist) end
		if vy ~= 0 then vy = vy + (vy * math.log(math.abs(vy)) / denominator * CustomProvTF.vars.logdist) end
	end

	x = zo_round(vx * gameScale)
	y = zo_round(vy * gameScale)

	return x, y
end

local function TeamFormation_GetOrder()
	local order = {}
	local numChildren = WINDOW_MANAGER:GetControlByName("ZO_GroupListListContents"):GetNumChildren()
	local str, text
	for i = 1, numChildren do
		if WINDOW_MANAGER:GetControlByName("ZO_GroupListList1Row" .. i .. "CharacterName") then
			text = WINDOW_MANAGER:GetControlByName("ZO_GroupListList1Row" .. i .. "CharacterName"):GetText()
			str = string.match(text, "^[0-9]+\. (.+)$")
			if str and str ~= "" then
				order[i] = str
			end
		end
	end
	return order
end

CustomProvTF.lastSize = nil
CustomProvTF.numUpdate = 0
local function inTable(tbl, item)
    for key, value in pairs(tbl) do
        if value == item then return key end
    end
    return false
end

local function TeamFormation_uiLoop()
	if not CustomProvTF.vars.enabled then
		CustomTeamFormation_SetHidden(true)
		return
	end

	local groupSize = GetGroupSize()

	CustomProvTF.numUpdate = CustomProvTF.numUpdate + 1

	local LAM2Panel = WINDOW_MANAGER:GetControlByName("ProvinatusLAM2Panel")

	if updateIsNecessary(1, "LAM2PanelisHidden", not LAM2Panel:IsHidden()) then
		if not LAM2Panel:IsHidden() then
			CustomTeamFormation_SetHidden(false)
			CustomProvTF.UI:SetAnchor(TOPLEFT, GuiRoot, TOPLEFT, LAM2Panel:GetWidth() + LAM2Panel:GetLeft() + 40, LAM2Panel:GetTop())
		else
			CustomProvTF.UI:SetAnchor(CENTER, GuiRoot, CENTER, CustomProvTF.vars.posx, CustomProvTF.vars.posy)
		end
	end

	if CustomProvTF.lastSize and groupSize < CustomProvTF.lastSize then
		for i = math.max(1, groupSize), CustomProvTF.lastSize do
			CustomProvTF.UI.Player[i]:SetHidden(true)
		end
	end

	if groupSize == 0 then
		CustomProvTF.lastSize = 0
		CustomTeamFormation_SetHidden(true)
		return
	elseif CustomProvTF.lastSize == 0 then
		CustomTeamFormation_SetHidden(false)
	end

	local ABCOrder = TeamFormation_GetOrder()

	local myName = GetUnitName("player")
	local fX, fY, fHeading = GetMapPlayerPosition("player")
	local myIndex = 1

	local unitTag, name, x, y, heading, xi, yi, isOnline
	local zone, sameZone, dist, text, ctrl_class

	for i = 1, groupSize do
		unitTag = (i ~= 0) and ("group" .. i) or "player"
		name = GetUnitName(unitTag)
		x, y, heading = GetMapPlayerPosition(unitTag)
		zone = GetUnitZone(unitTag)
		isOnline = IsUnitOnline(unitTag) and not (name == "" or (x == 0 and y == 0)) -- last condition prevent issue (What issue? -Albino)

		if CustomProvTF.debug.enabled and CustomProvTF.debug.pos.num == i and CustomProvTF.debug.pos.x ~= nil and myName ~= name then
			x = CustomProvTF.debug.pos.x
			y = CustomProvTF.debug.pos.y
			zone = CustomProvTF.debug.pos.zone
			heading = CustomProvTF.debug.pos.heading
			isOnline = true

			--[[ debug
			if CustomProvTF.debug.enabled and CustomProvTF.debug.pos.num == i and CustomProvTF.debug.pos.x ~= nil and myName ~= GetUnitName(unitTag) then
				local fX, fY, fHeading = GetMapPlayerPosition("player")
				x = (x - fX)
				y = (y - fY)
				local dist = math.sqrt(x * x + y * y) * 800 / TeamFormation_getDivisor() -- meter
				local dist = zo_round(dist * 100) / 100
				CustomProvTF.UI.LblMyPosition:SetText("Distance avec " .. i .. " : " .. dist .. " mètres ")
			end
			--]]
		end

		TeamFormation_MakeIcon(i)

		if isOnline then
			xi, yi = TeamFormation_CalculateXY(x, y)
			sameZone = GetUnitZone("player") == zone

			if CustomProvTF.UI.Player[i].data.name ~= name then
				CustomProvTF.UI.Player[i].data = {}
			end

			TeamFormation_MoveIcon(i, xi, yi)
			TeamFormation_UpdateIcon(i, sameZone, IsUnitDead(unitTag), IsUnitInCombat(unitTag))

			if sameZone and myName ~= name then
				x = (x - fX)
				y = (y - fY)
				dist = math.sqrt(x * x + y * y) * 800 / TeamFormation_getDivisor() -- meter

				if dist < 1000 then
					dist = zo_round(dist)
					text = "~ " .. dist .. " m"
				else
					dist = zo_round(dist / 10) / 100
					text = "~ " .. dist .. " Km"
				end
			else
				text = zo_strformat(SI_SOCIAL_LIST_LOCATION_FORMAT, zone)
				if myName == name then
					text = "|c00C000" .. text .. "|r"
				end
			end

			if inTable(ABCOrder, name) ~= false and WINDOW_MANAGER:GetControlByName("ZO_GroupListList1Row" .. inTable(ABCOrder, name) .. "Zone") then
				WINDOW_MANAGER:GetControlByName("ZO_GroupListList1Row" .. inTable(ABCOrder, name) .. "Zone"):SetText(text)

				ctrl_class = WINDOW_MANAGER:GetControlByName("ZO_GroupListList1Row" .. inTable(ABCOrder, name) .. "ClassIcon")
				ctrl_class:SetColor(unpack(CustomProvTF.vars.jRules[name] or {1, 1, 1}))
			end
		end

		if updateIsNecessary(i, "isOnline", isOnline) then
			CustomProvTF.UI.Player[i]:SetHidden(not isOnline)
		end

		if myName == name then
			myIndex = i
		end
	end

	TeamFormation_MakeIcon(100)
	x, y = GetMapPlayerWaypoint()
	if x ~= 0 and y ~= 0 then
		x, y = TeamFormation_CalculateXY(x, y)
		TeamFormation_MoveIcon(100, x, y)
		CustomProvTF.UI.Player[100].Icon:SetTexture("/esoui/art/compass/compass_waypoint.dds")
		CustomProvTF.UI.Player[100]:SetHidden(false)
	else
		CustomProvTF.UI.Player[100]:SetHidden(true)
	end

	local cx, cy, ca

	local mx = (CustomProvTF.vars.width / 2)
	local my = (CustomProvTF.vars.height / 2)

	for i = 1, 4 do
		ca = (i - 2) * math.pi / 2 + (CustomProvTF.vars.camRotation and GetPlayerCameraHeading() or GetMapPlayerPosition("player"))
		cx = zo_round((CustomProvTF.vars.width / 2) * math.cos(ca))
		cy = zo_round((CustomProvTF.vars.height / 2) * math.sin(ca))

		if not CustomProvTF.vars.circle then
			cx, cy = outOfScreenRect(cx * 2, cy * 2, -mx, -my, mx, my)
		end

		CustomProvTF.UI.Cardinal[i]:SetAnchor(CENTER, CustomProvTF.UI, CENTER, cx, cy)
		CustomProvTF.UI.Cardinal[i]:SetAlpha(CustomProvTF.vars.cardinal)
	end

	CustomProvTF.lastSize = groupSize
end

function CustomTeamFormation_OnUpdate()
	CustomTeamFormation_ErrorSniffer(TeamFormation_uiLoop)
end