--[[
    POST FX PIPELINE (PORT FROM SKYGFX)
]]
shaderBlurPS = nil
shaderRadiosityPS = nil
shaderAddblend = nil
screenSource = nil
screenSource_2 = nil
screenSource_3 = nil

local m_YUV2RGB = {
	{ 0.299, -0.168736, 0.500 },
	{ 0.587, -0.331264, -0.418688 },
	{ 0.114, 0.500,     -0.081312 },
	{ 0.000, 0.000,     0.000 },
}
local m_RGB2YUV = {
	{ 0.299, -0.168736, 0.500 },
	{ 0.587, -0.331264, -0.418688 },
	{ 0.114, 0.500,     -0.081312 },
	{ 0.000, 0.000,     0.000 },
}

function doRadiosity(intensityLimit, filterPasses, renderPasses, intensity)
	params = {}
	params[1] = 0
	params[2] = 1 / h
	params[3] = bitLShift(1, filterPasses)
	params[3] = params[3] * w / 640.0

	--Blur vertically
	dxUpdateScreenSource(screenSource, true)

	local rt = nil
	local rt_blurVertical = RTPool.GetUnused(w, h)
	dxSetRenderTarget(rt_blurVertical)
	rt = rt_blurVertical
	dxSetShaderValue(shaderBlurPS, 'tex', screenSource)
	dxSetShaderValue(shaderBlurPS, 'pxSz', { params[1], params[2], params[3] })
	dxDrawImage(0, 0, w, h, shaderBlurPS)

	--Blur horizontally
	local rt_blurHorizontal = RTPool.GetUnused(w, h)
	dxSetRenderTarget(rt_blurHorizontal)

	params[1] = 1 / w
	params[2] = 0
	dxSetShaderValue(shaderBlurPS, 'tex', rt)
	dxSetShaderValue(shaderBlurPS, 'pxSz', { params[1], params[2], params[3] })
	dxDrawImage(0, 0, w, h, shaderBlurPS)

	rt = rt_blurHorizontal
	dxSetRenderTarget()
	dxDrawImage(0, 0, w, h, rt, 0, 0, 0, tocolor(255, 255, 255, intensity))


	-- do radiosity
	intensityLimit = intensityLimit / 255.0;
	intensity = intensity / 255.0;
	dxSetShaderValue(shaderRadiosityPS, 'limit', intensityLimit)
	dxSetShaderValue(shaderRadiosityPS, 'intensity', intensity)
	dxSetShaderValue(shaderRadiosityPS, 'passes', renderPasses)

	local off = ((bitLShift(1, filterPasses)) - 1)
	-- only for upper left corner actually
	-- other one has 2,2 harcoded but since these are 2 by default, we'll reuse them
	local m_RadiosityFilterUCorrection, m_RadiosityFilterVCorrection = 2, 2
	local offu = off * m_RadiosityFilterUCorrection
	local offv = off * m_RadiosityFilterVCorrection
	local minu = offu
	local minv = offv
	local maxu = w - offu --off*2;
	local maxv = h - offv --off*2;
	local cu = (offu * (w + 0.5) + offu * 0.5) / w
	local cv = (offv * (h + 0.5) + offv * 0.5) / h

	params[1] = cu / w;
	params[2] = cv / h;
	params[3] = (maxu - minu) / w;
	params[4] = (maxv - minv) / h;
	dxSetShaderValue(shaderRadiosityPS, 'xform', { params[1], params[2], params[3], params[4] })
	dxSetShaderValue(shaderRadiosityPS, 'tex', screenSource)
	-- render radiosity
	local rt_radiosity = RTPool.GetUnused(w, h)
	dxSetRenderTarget(rt_radiosity)
	dxDrawImage(0, 0, w, h, shaderRadiosityPS)
	rt = rt_radiosity
	dxSetRenderTarget()
	dxSetShaderValue(shaderAddblend, 'src', rt_radiosity)
	dxDrawImage(0, 0, w, h, shaderAddblend, 0, 0, 0, tocolor(255, 255, 255, SKYGFX.radiosityIntensity))
end

function doColorFilter(pipeline, rgba1, rgba2)
	pipeline = pipeline or 'PS2'
	if not rgba1 then return end

	local r1, g1, b1, a1 = unpack(rgba1)
	local r2, g2, b2, a2 = unpack(rgba2)

	-- Apply MODULATE2X if pipeline is PS2
	if pipeline == 'PS2' then
		r1, g1, b1, a1 = r1 * 2, g1 * 2, b1 * 2, a1 * 2
		r2, g2, b2, a2 = r2 * 2, g2 * 2, b2 * 2, a2 * 2

		-- Clamp the values to 255
		r1, g1, b1, a1 = math.min(r1, 255), math.min(g1, 255), math.min(b1, 255), math.min(a1, 255)
		r2, g2, b2, a2 = math.min(r2, 255), math.min(g2, 255), math.min(b2, 255), math.min(a2, 255)

		-- Scale down to compensate for brightness
		local scale = SKYGFX.ps_modulate_scale
		r1, g1, b1, a1 = r1 * scale, g1 * scale, b1 * scale, a1 * scale
		r2, g2, b2, a2 = r2 * scale, g2 * scale, b2 * scale, a2 * scale
	end

	dxUpdateScreenSource(screenSource_2, true)
	local w, h = dxGetMaterialSize(screenSource_2)
	local rt_ps2ColorFilter = RTPool.GetUnused(w, h)

	dxSetRenderTarget(rt_ps2ColorFilter)
	dxSetShaderValue(shaderColorFilterPS, 'tex', screenSource_2)

	dxSetShaderValue(shaderColorFilterPS, 'rgb1', { r1 / 255, g1 / 255, b1 / 255, a1 / 255 })
	dxSetShaderValue(shaderColorFilterPS, 'rgb2', { r2 / 255, g2 / 255, b2 / 255, a2 / 255 })

	dxDrawImage(0, 0, w, h, shaderColorFilterPS, 0, 0, 0, tocolor(255, 255, 255, 255))

	dxSetShaderValue(shaderPs2ColorBlendPS, 'src', rt_ps2ColorFilter)
	dxSetShaderValue(shaderPs2ColorBlendPS, 'dst', screenSource_2)
	dxSetShaderValue(shaderPs2ColorBlendPS, 'srcAlpha', a1 / 255)

	dxSetRenderTarget()
	dxDrawImage(0, 0, w, h, shaderPs2ColorBlendPS, 0, 0, 0, tocolor(255, 255, 255, 255))
end

function initializePostProcessingShaders()
	resetColorFilter()
	shaderBlurPS = dxCreateShader('shader/blurPS.fx', 0, 0, false)
	shaderRadiosityPS = dxCreateShader('shader/radiosity.fx', 0, 0, false)
	shaderAddblend = dxCreateShader('shader/addblend.fx', 0, 0, false)
	shaderColorFilterPS = dxCreateShader('shader/colorFilterPS.fx', 0, 0, false)
	shaderPs2ColorBlendPS = dxCreateShader('shader/ps2ColorBlend.fx', 0, 0, false)
	shaderGradingPS = dxCreateShader('shader/gradingPS.fx', 0, 0, false)

	local width, height = guiGetScreenSize()
	screenSource = dxCreateScreenSource(width, height)
	screenSource_2 = dxCreateScreenSource(width, height)
	screenSource_3 = dxCreateScreenSource(width, height)

	setColorFilter(0, 0, 0, 0, 0, 0, 0, 0)
	local offset_x = math.abs(SKYGFX.blurLeft + SKYGFX.blurRight) / 2
	local offset_y = math.abs(SKYGFX.blurTop + SKYGFX.blurBottom) / 2
	dxSetShaderValue(shaderColorFilterPS, 'offset_x', offset_x)
	dxSetShaderValue(shaderColorFilterPS, 'offset_y', offset_y)

	local m = matrix({
		{ SKYGFX.lumaScale, 0,              0,              SKYGFX.lumaOffset },
		{ 0,                SKYGFX.CbScale, 0,              SKYGFX.CbOffset },
		{ 0,                0,              SKYGFX.CrScale, SKYGFX.CrOffset },
	})

	local m_RGB2YUV = matrix(m_RGB2YUV)
	local m_YUV2RGB = matrix(m_YUV2RGB)

	m = matrix.mul(m, m_RGB2YUV)
	m = matrix.mul(m, m_YUV2RGB)

	local r = { m[1][1], m[1][2], m[1][3], 0 }
	local g = { m[2][1], m[2][2], m[2][3], 0 }
	local b = { m[3][1], m[3][2], m[3][3], 0 }

	dxSetShaderValue(shaderGradingPS, 'redGrade', r)
	dxSetShaderValue(shaderGradingPS, 'greenGrade', g)
	dxSetShaderValue(shaderGradingPS, 'blueGrade', b)
end

function renderPostProcessing()
	RTPool.frameStart()
	DebugResults.frameStart()

	if SKYGFX.doRadiosity == true then
		local radiosityIntensityLimit = SKYGFX.radiosityIntensityLimit == 0 and
			TIMECYC:getTimeCycleValue('radiosityLimit') or SKYGFX.radiosityIntensityLimit
		doRadiosity(radiosityIntensityLimit, SKYGFX.radiosityFilterPasses, SKYGFX.radiosityRenderPasses,
			SKYGFX.radiosityIntensity)
	end

	local rgba1 = TIMECYC:getTimeCycleValue('postfx1')
	local rgba2 = TIMECYC:getTimeCycleValue('postfx2')

	if SKYGFX.colorFilter == 'PS2' then
		-- Gotta fix alpha for effects that assume PC alpha range
		-- clamping this is important!
		if rgba1[4] >= 128 then
			rgba1[4] = 255
		else
			rgba1[4] = rgba1[4] * 2
		end

		if rgba2[4] >= 128 then
			rgba2[4] = 255
		else
			rgba2[4] = rgba2[4] * 2
		end

		doColorFilter('PS2', rgba1, rgba2)
	end
end
