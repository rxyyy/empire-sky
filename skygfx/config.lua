TIMECYC = exports.timecyc
COR = exports.custom_coronas

textureListTable = {}

textureListTable.BuildingPSRemoveList = {
	'?emap*',
	'',
	'*cloud*', -- clouds
	'*icon',
	'*shad*', -- shadows
	'*smoke*', -- smoke
	'basketball2',
	'boatwake*',
	'cameracrosshair', -- hud
	'carsplash_*',
	'cheerybox03_weights',
	'cj_*',
	'cj_w_grad',        -- checkpoint texture
	'coronaheadlightline', -- coronas
	'coronamoon',
	'coronaringa',
	'coronastar',
	'fire*', -- unnamed
	'fist',
	'font*',
	'gensplash',
	'headlight*',
	'lunar', -- moon
	'newaterfal1_256',
	'pinebranch*',
	'plaintarmac*',
	'radar*',
	'sitem16',
	'siterocket',   -- hud
	'skybox_tex*',  -- other
	'snipercrosshair', -- hud
	'sphere_cj',    -- nitro heat haze mask
	'sphere',
	'splash_up',
	'tx*', -- grass effect
	'unnamed',
	'vehiclegeneric*',
	'vehiclegrunge256',
	'water*'
}

textureListTable.VehiclePSApplyList = {
	'?emap*',
	'andromeda92body',
	'andromeda92wing',
	'artict1logos',
	'at400_92_256',
	'beagle256',
	'cargobob92body256',
	'coach92interior128',
	'combinetexpage128',
	'cropdustbody256',
	'dash92interior128',
	'dodo92body8bit256',
	'fcr90092body128',
	'hotdog92body256',
	'hotknifebody128a',
	'hotknifebody128b',
	'hunterbody8bit256a',
	'hydrabody256',
	'leviathnbody8bit256',
	'maverick92body128',
	'monstera92body256a',
	'monsterb92body256a',
	'nevada92body256',
	'petrotr92interior128',
	'polmavbody128a',
	'predator92body128',
	'raindance92body128',
	'rcbaron92texpage64',
	'rcgoblin92texpage128',
	'rcraider92texpage128',
	'rctiger92body128',
	'rhino92texpage256',
	'rumpo92adverts256',
	'rustler92body256',
	'seasparrow92floats64',
	'shamalbody256',
	'skimmer92body128',
	'sparrow92body128',
	'stunt256',
	'vehiclegrunge256'
}

SKYGFX = {
	-- start by default
	autoStart = true,
	-- vehicle
	envPower = 1.0, --Env specular light power (the higher the smaller the highlight)
	-- postfx
	blurLeft = 0.0012, -- Override PS2 color filter blur offset
	blurTop = 0.0012, -- to disable blur set these to 0
	blurRight = 0.0012,
	blurBottom = 0.0012,
	radiosityFilterPasses = 2,
	radiosityRenderPasses = 1,
	radiosityIntensity = 40,
	RSPIPE_PC_CustomBuilding_PipeID = true,
	buildingExtraBrightness = 1,
	vehicleExtraBrightness = 1,
	ps_modulate_scale = 0.6,
	-- grass
	grassAddAmbient = false, --0x5DAEC8, need fuck the memory, not fully done.
	--grassFixPlacement=true, 0x5DADB7, need fuck the memory
	-- world fx
	ps2Modulate = true,
	dualPass = true,
	zwriteThreshold = 128,
	disableZTest = false, -- if you want ps2 big sun lens
	sunZTestLength = 3000, -- sun ztest length
	-- misc
	-- Modify final colors in YCbCr space
	YCbCrCorrection = 0, -- turns this on or off (default 0)
	lumaScale = 0.8588, -- multiplier for Y (default 0.8588)
	lumaOffset = 0.0627, -- this is added to Y (default 0.0627)
	CbScale = 1.22,   -- like above with Cb and Cr (default 1.22)
	CbOffset = 0.0,   -- (default 0.0)
	CrScale = 1.22,   -- (default 1.22)
	CrOffset = 0.0,   -- (default 0.0)
	rotorMaxAlpha = 120, -- max alpha for rotor
	-- special
	vehicleHeadLightAlpha = 255,
	vehicleRearLightAlpha = 120,
	stochastic = true,
	building_dist = 1000,
}

w, h = guiGetScreenSize()
