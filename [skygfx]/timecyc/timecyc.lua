Timecyc = {}
Weather = {
    numHours = 8,-- for normal sa timecyc.dat 
    old = 0,
    new = 0,
    interpolation = 0,
    data ={},
}
-- SA Timecyc.dat mapping
T = {
    ambR =1 , ambG =2 , ambB =3,
    ambR_obj =4 , ambG_obj =5 , ambB_obj =6,
    dirR =7, dirG =8, dirB =9,
    skyTopR = 10, skyTopG =11, skyTopB =12,
    skyBotR = 13, skyBotG =14, skyBotB =15,
    sunCoreR = 16, sunCoreG =17, sunCoreB =18,
    sunCoronaR = 19, sunCoronaG =20, sunCoronaB =21,
    sunSz = 22, sprSz =23, sprBght =24,
    shad = 25, lightShad =26, poleShad =27,
    farClp = 28, fogSt =29, lightGnd =30,
    cloudR = 31, cloudG =32, cloudB =33,
    fluffyBotR =34, fluffyBotG =35, fluffyBotB =36,
    waterR = 37,waterG =38, waterB=39, waterA=40,
    postfx1A =41, postfx1R =42, postfx1G = 43, postfx1B = 44,
    postfx2A =45, postfx2R = 46, postfx2G =47, postfx2B = 48,
    cloudAlpha = 49, radiosityLimit = 50, waterFogAlpha = 51, dirMult = 52
}

function loadTimeCycle(filename) 
    local f = fileOpen(filename)
    local lines = fileRead(f,fileGetSize(f))
    lines = split(lines:gsub("\r",""),'\n')
    fileClose(f)
    local weather_id = 0
    for i=1,#lines do 
        if string.find(lines[i],"////////////") then
            weather_id = weather_id + 1
        end
        if lines[i]:sub(1, 1) ~= '/' and lines[i]:sub(2, 1) ~= '/' then
            local data = split(lines[i]:gsub("\t"," ")," ")
            if Timecyc[weather_id] == nil then
                Timecyc[weather_id] = {}
            end
            table.insert(Timecyc[weather_id],data)

        end
    end
end
-- timecyc interpolation shits from here
function clampTimeIndex(time,min) 
    local clampRange = {
        -- FROM,TO,DATA_INDEX
        {0,5,1},-- 0 - 5 AM
        {5,6,2},
        {6,7,3},
        {7,12,4},
        {12,19,5},
        {19,20,6},
        {20,22,7},
        {22,24,8},
    }
    for _,range in ipairs(clampRange) do 
        if time >= range[1] and time < range[2] then 
            return range[3]
        end
    end
    return 1
end

function getTimeIntervalLength(hour,min)
    --[[
        Time Range: 
            0,5,6,7,12,19,20,22
    ]]
    if hour >= 0 and hour < 5 and min >= 0 and min <= 59 then -- from 0 -> 4:59
        return 5
    elseif hour >= 5 and hour < 6 and min >= 0 and min <= 59 then -- from 5 -> 5:59
        return 1
    elseif hour >= 6 and hour < 7 and min >= 0 and min <= 59 then -- from 6 -> 6:59
        return 1
    elseif hour >= 7 and hour < 12 and min >= 0 and min <= 59 then -- from 7 -> 11:59
        return 5
    elseif hour >= 12 and hour < 19 and min >= 0 and min <= 59 then -- from 12 -> 18:59
        return 7
    elseif hour >= 19 and hour < 20 and min >= 0 and min <= 59 then -- from 19 -> 19:59
        return 1
    elseif hour >= 20 and hour < 22 and min >= 0 and min <= 59 then -- from 20 -> 21:59
        return 2
    elseif hour >= 22 then -- from 22 -> 23:59
        return 2
    end
end
function getTimeIntervalLengthFromIndex(index)
    --[[
        Time Range: 
            0,5,6,7,12,19,20,22
    ]]
    local lengthMapping = {
        5,1,1,5,7,1,2,2
    }
    local length = 0
    for i = 1,index-1 do 
        length = length + lengthMapping[i]
    end
    return length
end

function getInterpolationValue(a,b,hour,min) 
    a = tonumber(a)
    b = tonumber(b)
    local length = getTimeIntervalLength(hour,min)
    local intervalIndex = clampTimeIndex(hour,min)
    local current = (hour-getTimeIntervalLengthFromIndex(intervalIndex)) + min/60 
    local progress = current/length -- get time escapted percentage & normalized to 0-1 range
   
    local result = a * (1-progress) + b * progress
	if result >= b then
		result = b
	elseif result <= a then
		result = a
	end
	return result
end
function getGradientInterpolationValue(startGrident,endGradient,hour,min)
    local s_r,s_g,s_b = unpack(startGrident)
    local e_r,e_g,e_b = unpack(endGradient)
    local r = getInterpolationValue(s_r,e_r,hour,min)
    local g = getInterpolationValue(s_g,e_g,hour,min)
    local b = getInterpolationValue(s_b,e_b,hour,min)
    return {r,g,b}
end

function update(weather_id,hour,min) 
    weather_id = weather_id + 1 -- due to sa weather start from 0
    local intervalIndex = clampTimeIndex(hour,min)
    local WT_S = Timecyc[weather_id][intervalIndex]
    local endTntervalIndex = intervalIndex + 1 > #Timecyc[weather_id] and 1 or intervalIndex + 1
    local WT_E = Timecyc[weather_id][endTntervalIndex]

    --SKY
    local skyTR,skyTG,skyTB = unpack(getGradientInterpolationValue({WT_S[T["skyTopR"]],WT_S[T["skyTopG"]],WT_S[T["skyTopB"]]},{WT_E[T["skyTopR"]],WT_E[T["skyTopG"]],WT_E[T["skyTopB"]]},hour,min)) -- SkytopGradient

    local skyBR,skyBG,skyBB = unpack(getGradientInterpolationValue({WT_S[T["skyBotR"]],WT_S[T["skyBotG"]],WT_S[T["skyBotB"]]},{WT_E[T["skyBotR"]],WT_E[T["skyBotG"]],WT_E[T["skyBotB"]]},hour,min)) -- SkyBottomGradient
    setSkyGradient(skyTR,skyTG,skyTB,skyBR,skyBG,skyBB)

    --SUN
    local sunCoreR,sunCoreG,sunCoreB = unpack(getGradientInterpolationValue({WT_S[T["sunCoreR"]],WT_S[T["sunCoreG"]],WT_S[T["sunCoreB"]]},{WT_E[T["sunCoreR"]],WT_E[T["sunCoreG"]],WT_E[T["sunCoreB"]]},hour,min))
    local sunCoronaR,sunCoronaG,sunCoronaB = unpack(getGradientInterpolationValue({WT_S[T["sunCoronaR"]],WT_S[T["sunCoronaG"]],WT_S[T["sunCoronaB"]]},{WT_E[T["sunCoronaR"]],WT_E[T["sunCoronaG"]],WT_E[T["sunCoronaB"]]},hour,min))
    --setSunColor(sunCoreR,sunCoreG,sunCoreB,sunCoronaR,sunCoronaG,sunCoronaB)
    local sunSize = getInterpolationValue(WT_S[T["sunSz"]],WT_E[T["sunSz"]],hour,min)
    --setSunSize(sunSize)
    print("original")
    print(WT_S[T["sunSz"]])
    print(WT_E[T["sunSz"]])

end
-- shits port from aap's euryopa.exe
function interpolateValue(a,b,fa,fb) 
    return fa * a + fb * b
end

function interpolateRGB(a1,b1,fa,fb) 
    local r = fa * a1[1] + fb * b1[1]
    local g = fa * a1[2] + fb * b1[2]
    local b = fa * a1[3] + fb * b1[3]
    return {r,g,b}
end

function interpolateRGBA(a1,b1,fa,fb) 
    local r = fa * a1[1] + fb * b1[1]
    local g = fa * a1[2] + fb * b1[2]
    local b = fa * a1[3] + fb * b1[3]
    local a = fa * a1[4] + fb * b1[4]
    return {r,g,b,a}
end

function interpolate(a,b,fa,fb,isCurrent)
    isCurrent = isCurrent or false
    --[[
        unused 
        Interpolate(&dst->amb_bl, &a->amb_bl, &b->amb_bl, fa, fb);
	    Interpolate(&dst->amb_obj_bl, &a->amb_obj_bl, &b->amb_obj_bl, fa, fb);
    ]]
    local weather = {}
    if not isCurrent then -- interpolate direct from timecyc data
        weather.amb = interpolateRGB({a[T["ambR"]],a[T["ambG"]],a[T["ambB"]]}, {b[T["ambR"]],b[T["ambG"]],b[T["ambB"]]}, fa, fb)
        weather.amb_obj = interpolateRGB({a[T["ambR_obj"]],a[T["ambG_obj"]],b[T["ambB_obj"]]},{b[T["ambR_obj"]],b[T["ambG_obj"]],b[T["ambB_obj"]]}, fa, fb)
        --weather.dir = interpolateRGB({a[T["dirR"]],a[T["dirG"]],a[T["dirB"]]}, {b[T["dirR"]],b[T["dirG"]],b[T["dirB"]]}, fa, fb)
        weather.sky_top = interpolateRGB({a[T["skyTopR"]],a[T["skyTopG"]],a[T["skyTopB"]]}, {b[T["skyTopR"]],b[T["skyTopG"]],b[T["skyTopB"]]}, fa, fb)
        weather.sky_bot = interpolateRGB({a[T["skyBotR"]],a[T["skyBotG"]],a[T["skyBotB"]]}, {b[T["skyBotR"]],b[T["skyBotG"]],b[T["skyBotB"]]}, fa, fb)
        weather.sun_core = interpolateRGB({a[T["sunCoreR"]],a[T["sunCoreG"]],a[T["sunCoreB"]]}, {b[T["sunCoreR"]],b[T["sunCoreG"]],b[T["sunCoreB"]]}, fa, fb)
        weather.sun_corona = interpolateRGB({a[T["sunCoronaR"]],a[T["sunCoronaG"]],a[T["sunCoronaB"]]}, {b[T["sunCoronaR"]],b[T["sunCoronaG"]],b[T["sunCoronaB"]]}, fa, fb)
        weather.sun_size = interpolateValue(a[T["sunSz"]], b[T["sunSz"]], fa, fb)
        weather.postfx1 =  interpolateRGBA({a[T["postfx1R"]],a[T["postfx1G"]],a[T["postfx1B"]],a[T["postfx1A"]]}, {b[T["postfx1R"]],b[T["postfx1G"]],b[T["postfx1B"]],b[T["postfx1A"]]}, fa, fb)
        weather.postfx2 = interpolateRGBA({a[T["postfx2R"]],a[T["postfx2G"]],a[T["postfx2B"]],a[T["postfx2A"]]}, {b[T["postfx2R"]],b[T["postfx2G"]],b[T["postfx2B"]],b[T["postfx2A"]]}, fa, fb)
        weather.dirMult = interpolateValue(a[T["dirMult"]],b[T["dirMult"]],fa,fb)
        weather.fogSt = interpolateValue(a[T["fogSt"]],b[T["fogSt"]],fa,fb)
        weather.farClp = interpolateValue(a[T["farClp"]],b[T["farClp"]],fa,fb)

    else -- interpolate from exiting
        weather.amb = interpolateRGB(a.amb, b.amb, fa, fb)
        weather.amb_obj = interpolateRGB(a.amb_obj, b.amb_obj, fa, fb)
        --weather.dir = interpolateRGB(a.dir, b.dir, fa, fb)    
        weather.sky_top = interpolateRGB(a.sky_top, b.sky_top, fa, fb)
        weather.sky_bot = interpolateRGB(a.sky_bot, b.sky_bot, fa, fb)
        weather.sun_core = interpolateRGB(a.sun_core, b.sun_core, fa, fb)
        weather.sun_corona = interpolateRGB(a.sun_corona, b.sun_corona, fa, fb)
        weather.sun_size = interpolateValue(a.sun_size, b.sun_size, fa, fb)
        weather.postfx1 = interpolateRGBA(a.postfx1, b.postfx1, fa, fb)
        weather.postfx2 = interpolateRGBA(a.postfx2, b.postfx2, fa, fb)
        weather.dirMult = interpolateValue(a.dirMult, b.dirMult, fa,fb)
        weather.fogSt = interpolateValue(a.fogSt, b.fogSt, fa,fb)
        weather.farClp = interpolateValue(a.farClp, b.farClp, fa,fb)
    end
    
    --[[
	dst->sprSz = fa * a->sprSz + fb * b->sprSz;
	dst->sprBght = fa * a->sprBght + fb * b->sprBght;
	dst->shdw = fa * a->shdw + fb * b->shdw;
	dst->lightShd = fa * a->lightShd + fb * b->lightShd;
	dst->poleShd = fa * a->poleShd + fb * b->poleShd;
	dst->farClp = fa * a->farClp + fb * b->farClp;
	dst->lightOnGround = fa * a->lightOnGround + fb * b->lightOnGround;
	Interpolate(&dst->lowCloud, &a->lowCloud, &b->lowCloud, fa, fb);
	Interpolate(&dst->fluffyCloudTop, &a->fluffyCloudTop, &b->fluffyCloudTop, fa, fb);
	Interpolate(&dst->fluffyCloudBottom, &a->fluffyCloudBottom, &b->fluffyCloudBottom, fa, fb);
	Interpolate(&dst->water, &a->water, &b->water, fa, fb);
	Interpolate(&dst->postfx1, &a->postfx1, &b->postfx1, fa, fb);
	Interpolate(&dst->postfx2, &a->postfx2, &b->postfx2, fa, fb);
	dst->cloudAlpha = fa * a->cloudAlpha + fb * b->cloudAlpha;
	dst->radiosityLimit = fa * a->radiosityLimit + fb * b->radiosityLimit;
	dst->radiosityIntensity = fa * a->radiosityIntensity + fb * b->radiosityIntensity;
	dst->waterFogAlpha = fa * a->waterFogAlpha + fb * b->waterFogAlpha;
	dst->dirMult = fa * a->dirMult + fb * b->dirMult;
	dst->lightMapIntensity = fa * a->lightMapIntensity + fb * b->lightMapIntensity;
    ]]
    return weather
end


function getColourSet(h,s) 
    h = h == 8 and 1 or h
    return Timecyc[s][h] 
end
function updateSA(weather_id,currentHour,currentMinute) 
    Weather.old = weather_id

    local hours = { 0, 5, 6, 7, 12, 19, 20, 22, 24}
    local time = currentHour + currentMinute/60.0;

    local curHour = 0 local nextHour = 0
	local curHourSel = 1 local nextHourSel = 1

    -- find current time in hour index
    while(time >= hours[curHourSel+1]) do
        curHourSel = curHourSel + 1
    end
    curHourSel = curHourSel == 0 and 1 or curHourSel
    
    nextHourSel = (curHourSel + 1) % Weather.numHours
    nextHourSel = nextHourSel == 0 and 1 or nextHourSel

	curHour = hours[curHourSel]
	nextHour = hours[curHourSel+1]

    local timeInterp = (time - curHour) / (nextHour - curHour)
    local curOld = getColourSet(curHourSel,Weather.old+1)
    local curNew = getColourSet(curHourSel, Weather.new+1)
	local nextOld = getColourSet(nextHourSel, Weather.old+1)
	local nextNew = getColourSet(nextHourSel, Weather.new+1)

    --interpolation
    local oldInterp = interpolate(curOld,nextOld, 1.0-timeInterp, timeInterp)
	local newInterp = interpolate(curNew,nextNew, 1.0-timeInterp, timeInterp)
	local currentColours = interpolate(oldInterp,newInterp, 1.0-Weather.interpolation, Weather.interpolation,true)
    -- more accurate gradient from https://github.com/GTAmodding/timecycle24/blob/master/src/TimeCycle.cpp
    -- thanks to aap's help
    --[[
    currentColours.sky_top[1] = currentColours.sky_top[1] * currentColours.dirMult
    currentColours.sky_top[1] = currentColours.sky_top[1] > 0xFF and 0xFF or currentColours.sky_top[1]
    currentColours.sky_top[2] = currentColours.sky_top[2] * currentColours.dirMult
    currentColours.sky_top[2] = currentColours.sky_top[2] > 0xFF and 0xFF or currentColours.sky_top[2]
    currentColours.sky_top[3] = currentColours.sky_top[3] * currentColours.dirMult
    currentColours.sky_top[3] = currentColours.sky_top[3] > 0xFF and 0xFF or currentColours.sky_top[3]
    currentColours.sky_bot[1] = currentColours.sky_top[1] * currentColours.dirMult
    currentColours.sky_bot[1] = currentColours.sky_bot[1] > 0xFF and 0xFF or currentColours.sky_bot[1]
    currentColours.sky_bot[2] = currentColours.sky_top[2] * currentColours.dirMult
    currentColours.sky_bot[2] = currentColours.sky_bot[2] > 0xFF and 0xFF or currentColours.sky_bot[2]
    currentColours.sky_bot[3] = currentColours.sky_top[3] * currentColours.dirMult
    currentColours.sky_bot[3] = currentColours.sky_bot[3] > 0xFF and 0xFF or currentColours.sky_bot[3]
    --]]
    --sky 
    setSkyGradient(currentColours.sky_top[1],currentColours.sky_top[2],currentColours.sky_top[3],currentColours.sky_bot[1],currentColours.sky_bot[2],currentColours.sky_bot[3])
    --sun
    setSunColor(currentColours.sun_core[1],currentColours.sun_core[2],currentColours.sun_core[3],currentColours.sun_corona[1],currentColours.sun_corona[2],currentColours.sun_corona[3])
    setSunSize(currentColours.sun_size)
    -- fog
    setFogDistance(currentColours.fogSt)
    setFarClipDistance(currentColours.farClp)
    Weather.data = currentColours
end 
function getTimeCycleValue(key) 
    --local h,m = getTime()
    --local time = clampTimeIndex(h)
    --return tonumber(Timecyc[weather_id+1][time][offset])
    return Weather.data[key]
end
addEventHandler( "onClientResourceStart",resourceRoot,function ()
    loadTimeCycle("timecyc.dat")
    addEventHandler("onClientRender",root,function()
        local h,m = getTime()
        local wea = getWeather()
        updateSA(wea,h,m)
    end)
end)