local buildingShaders = {}

local dayNightBalance = 1.0
local wetRoadsEffect = 0.0
local colorScale = 1.9921875

local function updateDayNightBalance(currentHour, currentMinute)
	local minute = currentHour * 60.0 + currentMinute
	local morningBegin = 6 * 60.0
	local morningEnd = 7 * 60.0
	local eveningBegin = 20 * 60.0
	local eveningEnd = 21 * 60.0

	--1.0 is night, 0.0 is day
	if minute < morningBegin then
		dayNightBalance = 1.0
	elseif minute < morningEnd then
		dayNightBalance = (morningEnd - minute) / (morningEnd - morningBegin)
	elseif minute < eveningBegin then
		dayNightBalance = 0.0
	elseif minute < eveningEnd then
		dayNightBalance = 1.0 - (eveningEnd - minute) / (eveningEnd - eveningBegin)
	else
		dayNightBalance = 1.0
	end
end

function renderBuildings()
	for _, buildingShader in ipairs(buildingShaders) do
		local amb = TIMECYC:getTimeCycleValue("amb")

		if not amb then
			return
		end

		local dirMult = TIMECYC:getTimeCycleValue("dirMult") * SKYGFX.buildingExtraBrightness

		if not dirMult then
			return
		end

		local r, g, b = unpack(amb)
		buildingAmbient = { r * dirMult / 0xFF, g * dirMult / 0xFF, b * dirMult / 0xFF, 0 }
		dxSetShaderValue(buildingShader, "ambient", buildingAmbient)
		-- texture material color
		dxSetShaderValue(buildingShader, "matCol", { 1, 1, 1, 1 })
		--day / night params
		local currentHour, currentMinute = getTime()
		updateDayNightBalance(currentHour, currentMinute)
		local dayparam = {}
		local nightparam = {}
		if SKYGFX.RSPIPE_PC_CustomBuilding_PipeID then
			dayparam = { 0, 0, 0, 1 }
			nightparam = { 1, 1, 1, 1 }
		else
			dayparam = { 1.0 - dayNightBalance, 1.0 - dayNightBalance, 1.0 - dayNightBalance, wetRoadsEffect }
			nightparam = { dayNightBalance, dayNightBalance, dayNightBalance, 1.0 - wetRoadsEffect }
		end
		dxSetShaderValue(buildingShader, "dayparam", dayparam)
		dxSetShaderValue(buildingShader, "nightparam", nightparam)
		dxSetShaderValue(buildingShader, "surfAmb", 1)
		--fog
		local fog_st = TIMECYC:getTimeCycleValue("fogSt")
		local fog_end = TIMECYC:getTimeCycleValue("farClp")
		local fog_range = math.abs(fog_st - fog_end)
		dxSetShaderValue(buildingShader, "fogStart", fog_st)
		dxSetShaderValue(buildingShader, "fogEnd", fog_end)
		dxSetShaderValue(buildingShader, "fogRange", fog_range)
		dxSetShaderValue(buildingShader, "fogDisable", SKYGFX.fogDisabled)
	end
end

function initializeBuildingShaders()
	local buildingDistance = SKYGFX.building_dist
	local buildingSimpleShader = dxCreateShader("shader/buildingSimplePSDual.fx", 0, buildingDistance, false, "world")

	if isElement(buildingSimpleShader) then
		dxSetShaderValue(buildingSimpleShader, "zwriteThreshold", SKYGFX.zwriteThreshold)

		table.insert(buildingShaders, buildingSimpleShader)
	else
		assert(false)
	end

	local buildingStochasticShader = dxCreateShader("shader/simpleStochasticPS.fx", 0, buildingDistance, false, "world")

	if isElement(buildingStochasticShader) then
		table.insert(buildingShaders, buildingStochasticShader)

		for texture, parameters in pairs(textureListTable.txddb) do
			if parameters.stochastic == 1 then
				engineApplyShaderToWorldTexture(buildingStochasticShader, texture)
			else
				engineApplyShaderToWorldTexture(buildingSimpleShader, texture)
			end
		end
	else
		assert(false)
	end

	for _, buildingShader in ipairs(buildingShaders) do
		dxSetShaderValue(buildingShader, "colorScale", colorScale)

		for _, texture in pairs(textureListTable.BuildingPSRemoveList) do
			engineRemoveShaderFromWorldTexture(buildingShader, texture)
		end
	end
end
