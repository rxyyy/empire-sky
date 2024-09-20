local fixablePlanes = {
	[548] = true,
	[425] = true,
	[417] = true,
	[487] = true,
	[488] = true,
	[497] = true,
	[563] = true,
	[447] = true,
	[469] = true
}

local renderList = {}
local rotor_txd = dxCreateTexture('fx/rotor/model/black64aa.dds', 'argb', true, 'clamp')

-- better way of handling that use shader
function applyHeliRotorFix(heli)
	--create shader
	local v_type = getVehicleType(getElementModel(heli))
	if not v_type then
		return
	end

	renderList[heli] = {}
	renderList[heli].shader = dxCreateShader('fx/rotor/rotor.fx')

	dxSetShaderValue(renderList[heli].shader, 'Tex0', rotor_txd)
	dxSetShaderValue(renderList[heli].shader, 'alpha', 1)

	engineApplyShaderToWorldTexture(renderList[heli].shader, 'cargobobrotorblack*', heli)
	engineApplyShaderToWorldTexture(renderList[heli].shader, '*prop64black*', heli)
end

function removeHeliRotorFix(heli)
	if renderList[heli] ~= nil then
		destroyElement(renderList[heli].shader)
		renderList[heli] = nil
	end
end

function renderRotorEffect()
	for heli, v in pairs(renderList) do
		if isElement(heli) then
			local spd = getHelicopterRotorSpeed(heli) * 70
			local a = spd / 0.051 > 255 and SKYGFX.rotorMaxAlpha or spd / 0.051

			dxSetShaderValue(renderList[heli].shader, 'alpha', a / 255)
		end
	end
end

function handleHeliStreamIn()
	if getElementType(source) == 'vehicle' then
		if fixablePlanes[getElementModel(source)] ~= nil then
			if renderList[source] == nil then
				applyHeliRotorFix(source)
			end
		end
	end
end

function handleHeliStreamOut()
	if getElementType(source) == 'vehicle' then
		if fixablePlanes[getElementModel(source)] ~= nil then
			if renderList[source] ~= nil then
				removeHeliRotorFix(source)
			end
		end
	end
end

function enableRotorPs2Fix()
	addEventHandler('onClientElementStreamIn', root, handleHeliStreamIn)
	addEventHandler('onClientElementStreamOut', root, handleHeliStreamOut)

	-- apply all rendered heli effect
	for key, source in ipairs(getElementsByType('vehicle')) do
		if fixablePlanes[getElementModel(source)] ~= nil then
			applyHeliRotorFix(source)
		end
	end

	setWaterDrawnLast(false)
end

function disableRotorPs2Fix()
	removeEventHandler('onClientElementStreamIn', root, handleHeliStreamIn)
	removeEventHandler('onClientElementStreamOut', root, handleHeliStreamOut)

	for heli, v in pairs(renderList) do
		destroyElement(renderList[heli].shader)
	end

	renderList = {}
	setWaterDrawnLast(true)
end
