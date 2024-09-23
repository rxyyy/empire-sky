local isStarted = false

function SKYGFX.onClientElementStreamIn()
	if getElementType(source) == 'vehicle' and not renderCache[source] then
		initVehicleRenderCache(source)
	end
end

function SKYGFX.onClientElementStreamOut()
	if renderCache[source] then
		destoryAllVehicleClassicLights(source)
		renderCache[source] = nil
	end
end

function SKYGFX.onClientRender()
	renderBuildings()
	renderVehicles()
	renderRotorEffect()
end

function SKYGFX.onClientPreRender()
	doClassicFXPreRender()
end

function SKYGFX.onClientHUDRender()
	renderPostProcessing()
end

function SKYGFX.onClientElementDestroy()
	destoryAllVehicleClassicLights(source)
end

function SKYGFX.start()
	if isStarted then
		return
	end

	resetColorFilter()
	resetSunColor()
	resetSkyGradient()
	resetSunSize()

	initializeBuildingShaders()
	initializeVehicleShaders()
	initializePostProcessingShaders()
	initializeWorldShaders()
	enableRotorPs2Fix()

	addEventHandlerEx('onClientElementStreamIn', root, SKYGFX.onClientElementStreamIn)
	addEventHandlerEx('onClientElementStreamOut', root, SKYGFX.onClientElementStreamOut)
	addEventHandlerEx('onClientRender', root, SKYGFX.onClientRender, false, 'low')
	addEventHandlerEx('onClientPreRender', root, SKYGFX.onClientPreRender, false, 'low')
	addEventHandlerEx('onClientHUDRender', root, SKYGFX.onClientHUDRender, false, 'low')
	addEventHandlerEx('onClientElementDestroy', root, SKYGFX.onClientElementDestroy)

	isStarted = true
end

function SKYGFX.stop()
	if not isStarted then
		return
	end

	resetColorFilter()
	resetSunColor()
	resetSkyGradient()
	resetSunSize()

	disableRotorPs2Fix()

	-- remove events
	removeEventHandlerEx('onClientElementStreamIn', root, SKYGFX.onClientElementStreamIn)
	removeEventHandlerEx('onClientElementStreamOut', root, SKYGFX.onClientElementStreamOut)
	removeEventHandlerEx('onClientRender', root, SKYGFX.onClientRender)
	removeEventHandlerEx('onClientPreRender', root, SKYGFX.onClientPreRender)
	removeEventHandlerEx('onClientHUDRender', root, SKYGFX.onClientHUDRender)
	removeEventHandlerEx('onClientElementDestroy', root, SKYGFX.onClientElementDestroy)

	isStarted = false
end

addEventHandler('onClientResourceStart', resourceRoot, function(startedRes)
	if SKYGFX.autoStart then
		SKYGFX.start()
	end
end)

addEventHandler('onClientResourceStop', resourceRoot, function()
	SKYGFX.stop()
end)
