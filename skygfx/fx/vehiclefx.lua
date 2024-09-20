renderCache = {}

function initVehicleRenderCache(v) 
    if not renderCache[v] then
        renderCache[v] = {
            veh = v,
            trail_fl = {},
            trail_fr = {},
            trail_rl = {},
            trail_rr = {},
            dummy = {},
            cor = {
                front_l = nil,
                front_c = nil,
                front_r = nil,
                back_l = nil,
                back_r = nil,
            },
        }
        -- get the constants
        local x,y,z = getVehicleDummyPosition (v,"light_front_main")
        local rx,ry,rz = getVehicleDummyPosition (v,"light_rear_main")
        renderCache[v].dummy["light_front_main"] = {x,y,z}
        renderCache[v].dummy["light_rear_main"] = {rx,ry,rz}
    end
end

function doVehicleClassicLight(veh) 
    local vec_cam = getCamera().matrix:getForward()
    local vec_veh = veh.matrix:getForward()
    local angle = math.deg(math.acos(vec_veh:dot(vec_cam) / vec_veh:getSquaredLength() * vec_cam:getSquaredLength()))
    local fade_front = angle > 90 and 1-vec_veh:dot(vec_cam) or 0
    local fade_back = angle <= 90 and vec_veh:dot(vec_cam) or 0
    
    -- front 
    local function createFrontLight() 
        local cor = COR:createCorona(0,0,0,1,0,0,0,0)
        --COR:setCoronaSizeXY(cor,1,0.1)
        return cor
    end
    local function createHeadLight() 
        local cor = COR:createCorona(0,0,0,1,0,0,0,0)
        COR:setCoronaSizeXY(cor,3,0.2)
        return cor
    end
    local function createRearLight() 
        local cor = COR:createCorona(0,0,0,1,0,0,0,0)
        COR:setCoronaSizeXY(cor,0.8,0.2)
        return cor
    end

    local function createOrUpateVehicleLight(key,dummy,dir) 
        dir = dir or "l"
        local offset = dir == "l" and 1 or dir == "c" and 0 or -1
        if dummy == "light_front_main" then
            if renderCache[veh].cor[key] == nil then
                local cLight = dir == "c" and createHeadLight or createFrontLight
                local cor = cLight()
                renderCache[veh].cor[key] = cor
            else
                local dx,dy,dz = unpack(renderCache[veh].dummy[dummy])
                local x,y,z = getPositionFromElementOffset(veh,offset*dx,dy,dz)
                COR:setCoronaPosition(renderCache[veh].cor[key],x,y,z)
                COR:setCoronaColor(renderCache[veh].cor[key],255,255,255,SKYGFX.vehicleHeadLightAlpha*fade_front)
            end
        end
        if dummy == "light_rear_main" then
            if renderCache[veh].cor[key] == nil then
                local cor = createRearLight() 
                renderCache[veh].cor[key] = cor
            else
                local dx,dy,dz = unpack(renderCache[veh].dummy[dummy])
                local x,y,z = getPositionFromElementOffset(veh,offset*dx,dy,dz)
                COR:setCoronaPosition(renderCache[veh].cor[key],x,y,z)
                COR:setCoronaColor(renderCache[veh].cor[key],255,0,0,SKYGFX.vehicleRearLightAlpha*fade_back)
            end
        end

    end

    local function destroyVehicleLight(key) 
        if renderCache[veh].cor[key] then
            COR:destroyCorona(renderCache[veh].cor[key])
            renderCache[veh].cor[key] = nil
        end
    end

    if getVehicleLightState(veh,2) == 0 then
        createOrUpateVehicleLight("back_l","light_rear_main","l")
    else
        destroyVehicleLight("back_l") 
    end
    
    if getVehicleLightState(veh,3) == 0 then
        createOrUpateVehicleLight("back_r","light_rear_main","r")
    else
        destroyVehicleLight("back_r") 
    end
end

function destoryAllVehicleClassicLights(veh) 
    if renderCache[veh] then
        if renderCache[veh].cor.front_l then
            COR:destroyCorona(renderCache[veh].cor.front_l)
            renderCache[veh].cor.front_l = nil
        end
        if renderCache[veh].cor.front_c then
            COR:destroyCorona(renderCache[veh].cor.front_c)
            renderCache[veh].cor.front_c = nil
        end
        if renderCache[veh].cor.front_r then
            COR:destroyCorona(renderCache[veh].cor.front_r)
            renderCache[veh].cor.front_r = nil
        end
        if renderCache[veh].cor.back_l then
            COR:destroyCorona(renderCache[veh].cor.back_l)
            renderCache[veh].cor.back_l = nil
        end
        if renderCache[veh].cor.back_r then
            COR:destroyCorona(renderCache[veh].cor.back_r)
            renderCache[veh].cor.back_r = nil
        end
    end
end
