local buildingShaders = {}

local dayNightBalance = 1.0
local wetRoadsEffect = 0.0
local colorScale = 1.9921875

local stochasticTextures = {
	'ab_plasicwrapa',
	'ab_plasicwrapa',
	'ab_sheetSteel',
	'ab_sheetSteel',
	'ab_sheetSteel',
	'AH_dirt64b2',
	'Alumox64',
	'Alumox64',
	'ap_tarmac',
	'backstageceiling1_128',
	'beige_64',
	'beige_64',
	'beigehotel_128',
	'beigehotel_128',
	'bfraxa1',
	'BLUE_FABRIC',
	'BLUE_FABRIC',
	'blueash',
	'bluecab4_256',
	'bluestucco1',
	'Bow_Abattoir_Conc2',
	'Bow_Abattoir_Conc2',
	'Bow_Abpave_Gen_2notherbuildsfe',
	'Bow_Abpave_Gen',
	'Bow_church_dirt',
	'Bow_church_grass_alt',
	'Bow_church_grass_gen',
	'Bow_dlct_plstrb_gen',
	'Bow_grass_gryard',
	'Bow_Smear_Cement',
	'bpiced1',
	'brnstucco1',
	'brwall_128',
	'bzelka1',
	'carlot1_LAn',
	'carlot1_sfw',
	'carlot1',
	'carpet_red_256',
	'carpet1kb',
	'carpet1kb',
	'ceaserwall06_128',
	'ceaserwall06_128',
	'chatwall01_law',
	'CJ_BLUE_WOOD',
	'CJ_BLUE_WOOD',
	'CJ_GALVANISED',
	'CJ_GREENMETAL',
	'CJ_GREENMETAL',
	'CJ_GREENMETAL',
	'cj_sheetmetal',
	'cj_sheetmetal',
	'cj_sheetmetal',
	'CJ_WOOD1',
	'CJ_WOOD1',
	'CJ_WOOD1',
	'cliffmid1',
	'cof_tile1',
	'concrete_64HV',
	'Concrete_rough_256',
	'concretebig3_256',
	'concretebig4256',
	'concretebig4256128',
	'concretebigb256128',
	'concretebigblu4256128',
	'concretebuild64',
	'concretedust2_lod',
	'concretemanky',
	'concretemanky',
	'concretenew_lod',
	'concretenew256',
	'concretenewb256',
	'concretenewb256',
	'concretenewgery256',
	'concroadslab_256',
	'corclawn_lod',
	'craproad3_LAe',
	'crenhous2',
	'cs_rockdetail2',
	'cst_rock_coast_sfw',
	'cst_rock_undersea_sfw',
	'ct_hole',
	'ctmall04_64',
	'ctmall18_64',
	'cw2_mountdirt',
	'darkgrey_carpet_256',
	'darkgrey_carpet_256',
	'des_adobewall2',
	'des_adobewall3',
	'des_crackeddirt1',
	'des_dam_conc',
	'des_dirt1_cs_mountain',
	'des_dirt1',
	'des_dirt2',
	'des_dirt2',
	'des_dirt2LOD',
	'des_dirtgrassmixb',
	'des_dirtgrassmixbmp',
	'des_dirtgrassmixc',
	'des_dustconc',
	'des_motelwall3',
	'des_oldrunway',
	'des_scrub1',
	'desclifftypebs',
	'desertgravel256',
	'desertgryard256_lod_countn2',
	'desertgryard256',
	'desertstones256_ce_farmxref',
	'desertstones256',
	'desertstones256LOD',
	'desgreengrass',
	'desmud',
	'dirt64b2',
	'dirtgrass',
	'dirtgrn128',
	'dirtKB_64HV',
	'dirty256',
	'dirtywhite',
	'dock1',
	'drkbrownmetal',
	'drvin_ground1',
	'dt_bmx_grass',
	'dts_elevator_carpet2',
	'dustyconcrete',
	'dustyjade_128',
	'dustyjade_128',
	'dustyjade_128',
	'dustytar_64HV',
	'eastwall4_LAe2',
	'Est_corridor_ceiling',
	'Est_Gen_stone',
	'examwall1_LAe',
	'excaliburwall01_128',
	'excaliburwall02_128',
	'ferry_build14',
	'flmngo06_128',
	'forestfloor3',
	'forestfloor4',
	'forestfloor256_cs_lod',
	'forestfloor256',
	'forestfloorbranch256_ce_farmxref',
	'forumstand1_LAe_cj_exp',
	'forumstand1_LAe',
	'garage_roof',
	'garage2b_sfw',
	'GB_nastybar02',
	'GB_nastybar02',
	'gm_LAcarpark1',
	'gnhotelwall02_128',
	'golf_fairway1',
	'golf_heavygrass',
	'Grass_128HV',
	'Grass_128HV',
	'Grass_dry_64HV',
	'Grass_lod',
	'Grass',
	'grass4dirty_mountainsfs',
	'grass4dirtyb',
	'grass10_grassdeep1',
	'grassdead1',
	'grassdead1LOD',
	'grassdeadbrn_lod',
	'grassdeadbrn256',
	'grassdeep1',
	'grassdeep2',
	'grassdeep256',
	'grassdry_128HV',
	'grassgrn256',
	'grassgrnbrnx256',
	'grasslong256',
	'grassshort2long256',
	'grasstype3',
	'grasstype4',
	'grasstype5',
	'grasstype7',
	'grasstype10',
	'grasstype510',
	'gravelground128',
	'gravelkb_128',
	'greenwall3',
	'greyground256',
	'greyground12802',
	'greyrockbig',
	'greystones01_128',
	'grifnewtex1x_LAS',
	'gry_roof',
	'gun_floor1',
	'gun_floor1',
	'hay',
	'Heliconcrete_gang2hous1_lae',
	'helipad_grey1',
	'hiwaygravel1_lod',
	'LAnconcmankLOD',
	'larock256',
	'lasjmflat1',
	'lasjmslumgrnd',
	'lasjmslumwall',
	'lasnude9',
	'lasunion7',
	'law_archthing3',
	'law_gazwhite1',
	'law_terra2',
	'law_yellow2',
	'ltgreenwallc1',
	'ltgreenwallc1',
	'luxorfloor02_128',
	'mallfloor2',
	'marble01_128',
	'Metalox64',
	'Metalox64',
	'mottled_creme_64HV',
	'mottled_grey_64HV',
	'mp_CJ_GALVANISED',
	'mp_gimp_oilfloor',
	'mp_gimp_oilfloor',
	'mp_jet_roof',
	'mp_jet_roof',
	'mp_snow',
	'mudyforest256',
	'musk2',
	'newall_harling_sless',
	'newall9',
	'newcrop3',
	'newgrnd1_128',
	'newgrnd1brn_128',
	'newgrnd1brn_128',
	'oldflowerbed',
	'orange2',
	'p_floor3',
	'parking1plain',
	'parking2plain',
	'pierwall03_law',
	'pierwall04_law',
	'pinkpave',
	'pinkwall01_64',
	'plaintarmac1',
	'plaintarmac1',
	'policesablack16',
	'pord_conc_128',
	'quarry_ground1',
	'redmetal',
	'redstones01_256',
	'rest_wall4',
	'rock_country128_cuntrockcs_t',
	'rock_country128',
	'rock1_128',
	'rock1b_128',
	'rocklaeLOD1',
	'rocktb128',
	'rocktbrn128_ce_ground01',
	'rocktbrn128LOD',
	'rocktq128',
	'rocktr128',
	'roughmotwall1',
	'rustb256128',
	'rustd64',
	'sandgrnd128',
	'sandnew_law_santamonicalaw2',
	'sandstonemixb',
	'sandytar_64HV',
	'scratchedmetal_cszerocupboard',
	'scratchedmetal',
	'seabed',
	'sf_concrete1',
	'sf_junction3',
	'sf_spray1',
	'sfe_rock1',
	'sfe_rock2',
	'sfe_rock3',
	'sfn_grass1',
	'simplewall256',
	'sjmALLEY',
	'sjmgrund2b',
	'sjmlahus21',
	'sjmlahus28',
	'sjmlascumpth',
	'sjmlawarwall3',
	'sjmlawarwall5',
	'sjmlawarwall5',
	'sjmloda4',
	'sjmloda5',
	'sjmloda97',
	'sjmlodc94',
	'sjmscorclawn',
	'sjmscorclawn3',
	'sjmshopBK',
	'sl_dtwn2wall1',
	'sl_dwntwnvicconc',
	'sl_LAbedingsoil',
	'sl_LAbedingsoil',
	'sl_sfndirt01',
	'sl_sfngrass01',
	'slab256',
	'sm_rock2_desert',
	'sm_rock2_desert',
	'sphinxbody01_128',
	'stones256',
	'stormdrain5_nt_ammu_lan2',
	'stormdrain7',
	'sw_copgrass01',
	'sw_dirt01',
	'sw_flatroof01',
	'sw_gasground',
	'sw_grass01',
	'sw_grass01LOD',
	'sw_rockgrass1',
	'sw_rockgrass1LOD',
	'sw_sand',
	'sw_stones',
	'sw_stonesLOD',
	'tardor9',
	'tarmacplain_bank',
	'tenwhitebrick64',
	'tislandwall04_64',
	'tislndrock01_128',
	'vegaspawnwall_128',
	'venbuildwh_law2',
	'vgncarwash2_128',
	'vgngewall1_256',
	'vgnhsepsh7_128',
	'vgs_shopwall01_128',
	'vgs_shopwall02_128',
	'vgschapelwall01_64',
	'vgsclubwall08_256',
	'vgshopwall05_64',
	'Was_dier',
	'Was_scrpyd_baler_pit_dbris',
	'waterclear256',
	'waterclear256',
	'waterdirty256',
	'whitesand_256',
	'ws_algae_concrete',
	'ws_alley_conc1',
	'ws_alley2_128_plain',
	'ws_alley5_256_blank',
	'ws_altz_wall7_top',
	'ws_altz_wall8_top',
	'ws_altz_wall10b',
	'ws_asphalt',
	'ws_asphalt2',
	'ws_badplaster',
	'ws_baseballdirt',
	'ws_carpark2_imrancomp_las2',
	'ws_carparkmanky1',
	'ws_carparknew2a',
	'ws_chipboard',
	'ws_chipboard',
	'ws_chipboard',
	'ws_drysand',
	'ws_greyfoam',
	'ws_greymetal_lod',
	'ws_oldpainted',
	'ws_oldpainted2',
	'ws_oldpainted2',
	'ws_patchygravel',
	'ws_plasterwall2',
	'ws_rooftarmac1_paynspray_lae',
	'ws_rooftarmac1',
	'ws_rooftarmac2',
	'ws_rooftarmaclod',
	'ws_rotten_concrete1',
	'ws_rotten_concrete1',
	'ws_stucco_white_2',
	'ws_sub_pen_conc2',
	'ws_sub_pen_conc3',
	'ws_traingravel',
	'ws_tunnelwall2',
	'ws_whiteplaster_top',
	'ws_whitewall2_top',
	'yardgrass1',
	'yellowbeige_128',
	'yelowmankywall_lae2'
}

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
		local amb = TIMECYC:getTimeCycleValue('amb')

		if not amb then
			return
		end

		local dirMult = TIMECYC:getTimeCycleValue('dirMult')

		if not dirMult then
			return
		end

		dirMult = dirMult * SKYGFX.buildingExtraBrightness

		local r, g, b = unpack(amb)
		local buildingAmbient = { r * dirMult / 0xFF, g * dirMult / 0xFF, b * dirMult / 0xFF, 0 }

		dxSetShaderValue(buildingShader, 'ambient', buildingAmbient)
		dxSetShaderValue(buildingShader, 'matCol', { 1, 1, 1, 1 })

		--day / night params
		local currentHour, currentMinute = getTime()

		updateDayNightBalance(currentHour, currentMinute)

		local dayParameters = { 0, 0, 0, 1 }
		local nightParameters = { 1, 1, 1, 1 }

		if not SKYGFX.RSPIPE_PC_CustomBuilding_PipeID then
			dayParameters = { 1.0 - dayNightBalance, 1.0 - dayNightBalance, 1.0 - dayNightBalance, wetRoadsEffect }
			nightParameters = { dayNightBalance, dayNightBalance, dayNightBalance, 1.0 - wetRoadsEffect }
		end

		dxSetShaderValue(buildingShader, 'dayparam', dayParameters)
		dxSetShaderValue(buildingShader, 'nightparam', nightParameters)
		dxSetShaderValue(buildingShader, 'surfAmb', 1)

		local fogBegin = TIMECYC:getTimeCycleValue('fogSt')
		local fogEnd = TIMECYC:getTimeCycleValue('farClp')
		local fogRange = math.abs(fogBegin - fogEnd)

		dxSetShaderValue(buildingShader, 'fogStart', fogBegin)
		dxSetShaderValue(buildingShader, 'fogEnd', fogEnd)
		dxSetShaderValue(buildingShader, 'fogRange', fogRange)
	end
end

function initializeBuildingShaders()
	local buildingDistance = SKYGFX.building_dist
	local buildingSimpleShader = dxCreateShader('shader/buildingSimplePSDual.fx', 0, buildingDistance, false, 'world')

	if isElement(buildingSimpleShader) then
		dxSetShaderValue(buildingSimpleShader, 'zwriteThreshold', SKYGFX.zwriteThreshold)

		table.insert(buildingShaders, buildingSimpleShader)
	else
		assert(false)
	end

	local buildingStochasticShader = dxCreateShader('shader/simpleStochasticPS.fx', 0, buildingDistance, false, 'world')

	if isElement(buildingStochasticShader) then
		table.insert(buildingShaders, buildingStochasticShader)

		for _, texture in ipairs(stochasticTextures) do
			local result = engineApplyShaderToWorldTexture(buildingStochasticShader, texture)

			assert(result)
		end

		stochasticTextures = {}
	else
		assert(false)
	end

	for _, buildingShader in ipairs(buildingShaders) do
		dxSetShaderValue(buildingShader, 'colorScale', colorScale)

		for _, texture in pairs(textureListTable.BuildingPSRemoveList) do
			engineRemoveShaderFromWorldTexture(buildingShader, texture)
		end
	end
end
