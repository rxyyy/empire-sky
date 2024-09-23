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
	local vehicles = getElementsByType('vehicle', root, true)

	for _, vehicle in ipairs(vehicles) do
		initVehicleRenderCache(vehicle)
	end

	COR:setCoronasDistFade(20, 3)
	COR:enableDepthBiasScale(true)
end
