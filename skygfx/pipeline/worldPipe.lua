trianglestrip = {}

trianglestrip.quad1x1 = {
    {-1, -1, 0, tocolor(255, 255, 255), 0, 0}, 
    {-1, 1, 0, tocolor(255, 255, 255), 0, 1}, 
    {1, -1, 0, tocolor(255, 255, 255), 1, 0},
    {1, 1, 0, tocolor(255, 255, 255), 1, 1}
}

function doSunFX()
	if not sunShader then
		return
	end

    -- check time rage
    local h,m = getTime()
    if h >= 5 and h <= 19 then
        local c1r, c1g, c1b, c2r, c2g, c2b = getSunColor()
        local sunSize = getSunSize()
        dxSetShaderValue( sunShader, "sSunColor1", c1r / 255, c1g / 255, c1b / 255, 0  )
        dxSetShaderValue( sunShader, "sSunColor2", c2r / 255, c2g / 255, c2b / 255, 1  )
        dxSetShaderValue( sunShader, "sSunSize", sunSize  )
        -- update the sun position
        local h,m =	getTime()
        s = m
        sunAngle = (m + 60 * h + s/60.0) * 0.0043633231;
        x = 0.7 + math.sin(sunAngle);
        y = -0.7;
        z = 0.2 - math.cos(sunAngle);
        dxSetShaderValue( sunShader, "sSunVec",{x,y,z} )
        dxDrawMaterialPrimitive3D( "trianglestrip", sunShader, false, unpack( trianglestrip.quad1x1 ) )	

        local vecPlayer = getCamera().matrix:getPosition()
        local sunVec = vecPlayer + Vector3(x,y,z) * SKYGFX.sunZTestLength
        local isClear = isLineOfSightClear (vecPlayer.x,vecPlayer.y,vecPlayer.z,sunVec.x,sunVec.y,sunVec.z, true,  true,  true,
        true, false, true, false, localPlayer )

        dxSetShaderValue( sunShader, "zTest",not isClear)
    else
        dxSetShaderValue( sunShader, "sSunSize", 0 )
    end
end

function doClassicFXPreRender()
    for veh,vehicle in pairs(renderCache) do 
        if isElement(veh) and getElementType(veh) == "vehicle" then
            if isElementOnScreen(veh) and areVehicleLightsOn(veh) then
                doVehicleClassicLight(veh) 
            else
                destoryAllVehicleClassicLights(veh)
            end
        end
    end
end

function initWorldMiscFx()
    -- grass
    shaderGrassFx = dxCreateShader("shader/grass.fx", 0, 0, false, "world,object")
    engineApplyShaderToWorldTexture(shaderGrassFx, "tx*")
    dxSetShaderValue(shaderGrassFx, "backfacecull",SKYGFX.grassBackfaceCull)

    for k,v in ipairs(getElementsByType ("vehicle",root, true) ) do 
        initVehicleRenderCache(v) 
    end

    if SKYGFX.vehicleClassicFx then
        COR:setCoronasDistFade(20,3)
        COR:enableDepthBiasScale(true)
    end
end
