function doClassicFXPreRender()
	for veh, vehicle in pairs(renderCache) do
		if isElement(veh) and getElementType(veh) == 'vehicle' then
			if isElementOnScreen(veh) and areVehicleLightsOn(veh) then
				doVehicleClassicLight(veh)
			else
				destoryAllVehicleClassicLights(veh)
			end
		end
	end
end

function initializeWorldShaders()
	worldShaderGrass = dxCreateShader('shader/grass.fx', 0, 0, false, 'world,object')

	if isElement(worldShaderGrass) then
		engineApplyShaderToWorldTexture(worldShaderGrass, 'tx*')
		dxSetShaderValue(worldShaderGrass, 'backfacecull', SKYGFX.grassBackfaceCull)
	else
		assert(false)
	end

	for _, vehicle in ipairs(getElementsByType('vehicle', root, true)) do
		initVehicleRenderCache(vehicle)
	end

	COR:setCoronasDistFade(20, 3)
	COR:enableDepthBiasScale(true)
end
