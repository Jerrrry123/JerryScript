
util.require_natives(1651208000)
if not filesystem.exists(filesystem.scripts_dir() .. 'lib/natives-1651208000.lua') then
    util.stop_script()
end

function yieldModelLoad(hash)
    while not STREAMING.HAS_MODEL_LOADED(hash) do util.yield() end
end

function getTotalDelay(delayTable)
    return (delayTable.ms + (delayTable.s * 1000) + (delayTable.min * 1000 * 60))
end

function sliderToScreenPos(pos)
    return pos / 200
end

function startBusySpinner(message)
    HUD.BEGIN_TEXT_COMMAND_BUSYSPINNER_ON("STRING")
    HUD.ADD_TEXT_COMPONENT_SUBSTRING_PLAYER_NAME(message)
    HUD.END_TEXT_COMMAND_BUSYSPINNER_ON(5)
end

new = {
    color = function(R, G, B, A)
        return {r = R, g = G, b = B, a = A}
    end,
    hudSettings = function(X, Y, ALIGNMENT)
        return {xOffset = X, yOffset = Y, scale = 0.5, alignment = ALIGNMENT, textColor = new.color(1, 1, 1, 1)}
    end,
    delay = function(MS, S, MIN)
        return {ms = MS, s = S, min = MIN}
    end,
}

--memory stuff skidded from heist control
local Int_PTR = memory.alloc_int()
local mpChar = util.joaat('mpply_last_mp_char')

function getMPX()
    STATS.STAT_GET_INT(mpChar, Int_PTR, -1)
    return memory.read_int(Int_PTR) == 0 and 'MP0_' or 'MP1_'
end

function STAT_SET_INT(Stat, Value)
    STATS.STAT_SET_INT(util.joaat(getMPX() .. Stat), Value, true)
end

function STAT_GET_INT(Stat)
    STATS.STAT_GET_INT(util.joaat(getMPX() .. Stat), Int_PTR, -1)
    return memory.read_int(Int_PTR)
end

function STAT_GET_INT_MPPLY(Stat)
    STATS.STAT_GET_INT(util.joaat(Stat), Int_PTR, -1)
    return memory.read_int(Int_PTR)
end

function STAT_SET_INT_MPPLY(Stat, Value)
    STATS.STAT_SET_INT(util.joaat(Stat), Value, true)
end

function STAT_SET_BOOL_MPPLY(Stat, Value)
    STATS.STAT_SET_BOOL(util.joaat(Stat), Value, true)
end

function STAT_GET_BOOL_MPPLY(Stat)
    STATS.STAT_GET_BOOL(util.joaat(Stat), Int_PTR, -1)
    return memory.read_int(Int_PTR)
end

function STAT_SET_BOOL(Stat, Value)
    STATS.STAT_SET_BOOL(util.joaat(getMPX() .. Stat), Value, true)
end

function STAT_SET_INCREMENT(Stat, Value)
    STATS.STAT_INCREMENT(util.joaat(getMPX() .. Stat), Value)
end

function SET_INT_GLOBAL(Global, Value)
    memory.write_int(memory.script_global(Global), Value)
end

function GET_INT_GLOBAL(Global)
    return memory.read_int(memory.script_global(Global))
end

----------------------------------
-- Whitelist
----------------------------------
    --returns a table of all players that aren't whitelisted
    function getNonWhitelistedPlayers(whitelistListTable, whitelistGroups, whitelistedName)
        local playerList = players.list(whitelistGroups.user, whitelistGroups.friends, whitelistGroups.strangers)
        local notWhitelisted = {}
        for i = 1, #playerList do
            if not whitelistListTable[playerList[i]] and not (players.get_name(playerList[i]) == whitelistedName) then
                notWhitelisted[#notWhitelisted + 1] = playerList[i]
            end
        end
        return notWhitelisted
    end

----------------------------------
-- Generating menu options
----------------------------------
    function generateTableList(list, table, value, label, unfocus)
        for k, v in pairsByKeys(table) do
            menu.action(list, string.space(k), {}, '', function()
                value[1] = v
                menu.set_menu_name(list, label .. string.space(k))
                if unfocus[1] then
                    menu.focus(list)
                end
            end)
        end
    end
    --i only use this one once
    function generateTableListI(list, table, value, label, index, unfocus)
        for i = index, #table do
            menu.action(list, table[i], {}, '', function()
                value[1] = i
                menu.set_menu_name(list, label .. table[i])
                if unfocus[1] then
                    menu.focus(list)
                end
            end)
        end
    end

    function generateHudSettings(root, prefix, settingsTable)
        menu.slider(root, 'X position', {prefix..'XPos'}, '', -200, 0, settingsTable.xOffset, 1, function(value)
            settingsTable.xOffset = value
        end)
        menu.slider(root, 'Y position', {prefix..'YPos'}, '', -5, 195, settingsTable.yOffset, 1, function(value)
            settingsTable.yOffset = value
        end)
        menu.slider(root, 'Scale', {prefix..'scale'}, 'The size of the text.', 200, 1500, 500, 1, function(value)
            settingsTable.scale = value / 1000
        end)
        menu.slider(root, 'Text alignment', {prefix..'alignment'}, '1 is center, 2 is left and 3 is right.', 1, 3, settingsTable.alignment, 1, function(value)
            settingsTable.alignment = value
        end)
        menu.colour(root, 'Text colour', {prefix..'colour'}, 'Sets the colour of the text overlay.', settingsTable.textColor, true, function(colour)
            settingsTable.textColor = colour
        end)
    end

    function getDelayDisplayValue(delayTable)
        if delayTable.min > 0 then
            return delayTable.min ..'min'
        elseif delayTable.s > 0 then
            return delayTable.s + delayTable.ms / 1000 ..'s'
        else
            return delayTable.ms ..'ms'
        end
    end

    local function setDelayDisplay(root, name, delayTable)
        menu.set_menu_name(root, name..': '..getDelayDisplayValue(delayTable))
    end

    function generateDelaySettings(root, name, delayTable)
        menu.slider(root, 'Ms', {'JS'..name..'DelayMs'}, 'The delay is the added total of ms, sec and min values.', 1, 999, delayTable.ms, 1, function(value)
            delayTable.ms = value
            setDelayDisplay(root, name, delayTable)
        end)
        menu.slider(root, 'Seconds', {'JS'..name..'DelaySec'}, 'The delay is the added total of ms, sec and min values.', 0, 59, delayTable.s, 1, function(value)
            delayTable.s = value
            setDelayDisplay(root, name, delayTable)
        end)
        menu.slider(root, 'Minutes', {'JS'..name..'DelayMin'}, 'The delay is the added total of ms, sec and min values.', 0, 60, delayTable.min, 1, function(value)
            delayTable.min = value
            setDelayDisplay(root, name, delayTable)
        end)
    end

    function generateToggles(table, root, reversed)
        for i = 1, #table do
            if not reversed then
                menu.toggle(root, table[i].name, {table[i].command}, table[i].description, function(toggle)
                    table[i].toggle = toggle
                end, table[i].toggle)
            else
                menu.toggle(root, table[i].name, {table[i].command}, table[i].description, function(toggle)
                    table[i].toggle = not toggle
                end, not table[i].toggle)
            end

        end
    end

    --only warns on the first opening, credit to sai for providing this workaround
    function listWarning(listRoot, firstOpening)
        if not firstOpening[1] then return end
        menu.show_warning(listRoot, CLICK_MENU, 'I can\'t guarantee that these options are 100% safe. I tested them on my main, but im stupid.', function()
            firstOpening[1] = false
            menu.trigger_command(listRoot, '')
        end)
    end

    --this function is from wiriScripts functions
    function pairsByKeys(t, f)
        local a = {}
        for n in pairs(t) do table.insert(a, n) end
        table.sort(a, f)
        local i = 0
        local iter = function()
            i = i + 1
            if a[i] == nil then return nil
            else return a[i], t[a[i]]
            end
        end
        return iter
    end

    function string.capitalize(str)
        return str:sub(1,1):upper()..str:sub(2):lower()
    end

    function string.space(str)
        return string.gsub(str, "_", " ")
    end

----------------------------------
-- Stuff for aiming and guns
----------------------------------
    --aiming functions are skidded from lanceScript, credit to nowiry for probably helping lance with then
    function get_offset_from_gameplay_camera(distance)
        local cam_rot = CAM.GET_GAMEPLAY_CAM_ROT(2)
        local cam_pos = CAM.GET_GAMEPLAY_CAM_COORD()
        local direction = rotation_to_direction(cam_rot)
        local destination =
        {
            x = cam_pos.x + direction.x * distance,
            y = cam_pos.y + direction.y * distance,
            z = cam_pos.z + direction.z * distance
        }
        return destination
    end

    function raycast_gameplay_cam(flag, distance)
        local ptr1, ptr2, ptr3, ptr4 = memory.alloc(), memory.alloc(), memory.alloc(), memory.alloc()
        local cam_rot = CAM.GET_GAMEPLAY_CAM_ROT(0)
        local cam_pos = CAM.GET_GAMEPLAY_CAM_COORD()
        local direction = rotation_to_direction(cam_rot)
        local destination =
        {
            x = cam_pos.x + direction.x * distance,
            y = cam_pos.y + direction.y * distance,
            z = cam_pos.z + direction.z * distance
        }
        SHAPETEST.GET_SHAPE_TEST_RESULT(
            SHAPETEST.START_EXPENSIVE_SYNCHRONOUS_SHAPE_TEST_LOS_PROBE(
                cam_pos.x,
                cam_pos.y,
                cam_pos.z,
                destination.x,
                destination.y,
                destination.z,
                flag,
                -1,
                1
            ), ptr1, ptr2, ptr3, ptr4)
        local p1 = memory.read_int(ptr1)
        local p2 = memory.read_vector3(ptr2)
        local p3 = memory.read_vector3(ptr3)
        local p4 = memory.read_int(ptr4)
        memory.free(ptr1)
        memory.free(ptr2)
        memory.free(ptr3)
        memory.free(ptr4)
        return {p1, p2, p3, p4}
    end

    function rotation_to_direction(rotation)
        local adjusted_rotation =
        {
            x = (math.pi / 180) * rotation.x,
            y = (math.pi / 180) * rotation.y,
            z = (math.pi / 180) * rotation.z
        }
        local direction =
        {
            x = -math.sin(adjusted_rotation.z) * math.abs(math.cos(adjusted_rotation.x)),
            y =  math.cos(adjusted_rotation.z) * math.abs(math.cos(adjusted_rotation.x)),
            z =  math.sin(adjusted_rotation.x)
        }
        return direction
    end

    function direction()
        local c1 = ENTITY.GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(PLAYER.PLAYER_PED_ID(), 0, 5, 0)
        local res = raycast_gameplay_cam(-1, 1000)
        local c2

        if res[1] ~= 0 then
            c2 = res[2]
        else
            c2 = get_offset_from_gameplay_camera(1000)
        end

        c2.x = (c2.x - c1.x) * 1000
        c2.y = (c2.y - c1.y) * 1000
        c2.z = (c2.z - c1.z) * 1000
        return c2, c1
    end

----------------------------------
-- Functions for exploding a player
----------------------------------
    local function addFx(pos, currentFx, colour)
        STREAMING.REQUEST_NAMED_PTFX_ASSET(currentFx.asset)
        while not STREAMING.HAS_NAMED_PTFX_ASSET_LOADED(currentFx.asset) do util.yield() end
        GRAPHICS.USE_PARTICLE_FX_ASSET(currentFx.asset)
        if currentFx.colour then
            GRAPHICS.SET_PARTICLE_FX_NON_LOOPED_COLOUR(colour.r, colour.g, colour.b)
        end
        GRAPHICS.START_NETWORKED_PARTICLE_FX_NON_LOOPED_AT_COORD(
            currentFx.name,
            pos.x,
            pos.y,
            pos.z,
            0,
            0,
            0,
            1.0,
            false, false, false, false
        )
    end
    local function explosion(pos, expSettings)
        if expSettings.currentFx then
            if expSettings.currentFx.exp then
                FIRE.ADD_EXPLOSION(pos.x, pos.y, pos.z, expSettings.currentFx.exp, 10, expSettings.audible, true, 0, expSettings.noDamage)
                FIRE.ADD_EXPLOSION(pos.x, pos.y, pos.z, 1, 10, false, true, expSettings.camShake, expSettings.noDamage)
            else
                FIRE.ADD_EXPLOSION(pos.x, pos.y, pos.z, 1, 10, false, true, expSettings.camShake, expSettings.noDamage)
            end
            if not expSettings.invisible then
                addFx(pos, expSettings.currentFx, expSettings.colour)
            end
        else
            FIRE.ADD_EXPLOSION(pos.x, pos.y, pos.z, expSettings.expType, 10, expSettings.audible, expSettings.invisible, expSettings.camShake, expSettings.noDamage)
        end
    end
    local function ownedExplosion(ped, pos, expSettings)
        if expSettings.currentFx then
            if expSettings.currentFx.exp then
                FIRE.ADD_OWNED_EXPLOSION(ped, pos.x, pos.y, pos.z, expSettings.currentFx.exp, 10, expSettings.audible, true, expSettings.camShake)
                FIRE.ADD_OWNED_EXPLOSION(ped, pos.x, pos.y, pos.z, 1, 10, false, true, expSettings.camShake)
            else
                FIRE.ADD_OWNED_EXPLOSION(ped, pos.x, pos.y, pos.z, 1, 10, false, true, expSettings.camShake)
            end
            if not expSettings.invisible then
                addFx(pos, expSettings.currentFx, expSettings.colour)
            end
        else
            FIRE.ADD_OWNED_EXPLOSION(ped, pos.x, pos.y, pos.z, expSettings.expType, 10, expSettings.audible, expSettings.invisible, expSettings.camShake)
        end
    end
    function explodePlayer(ped, loop, expSettings)
        local pos = ENTITY.GET_ENTITY_COORDS(ped)
        --if any blame is enabled this decides who should be blamed
        local blamedPlayer = PLAYER.PLAYER_PED_ID()
        if expSettings.blamedPlayer and expSettings.blamed then
            blamedPlayer = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(expSettings.blamedPlayer)
        elseif expSettings.blamed then
            local playerList = players.list(true, true, true)
            blamedPlayer = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(playerList[math.random(1, #playerList)])
        end
        if not loop and PED.IS_PED_IN_ANY_VEHICLE(ped, true) then
            for i = 0, 50, 1 do --50 explosions to account for most armored vehicles
                if expSettings.owned or expSettings.blamed then
                    ownedExplosion(blamedPlayer, pos, expSettings)
                else
                    explosion(pos, expSettings)
                end
                util.yield(10)
            end
        elseif expSettings.owned or expSettings.blamed then
            ownedExplosion(blamedPlayer, pos, expSettings)
        else
            explosion(pos, expSettings)
        end
        util.yield(10)
    end

----------------------------------
-- Functions for blocking areas
----------------------------------
    function block(cord)
        local hash = 309416120
        STREAMING.REQUEST_MODEL(hash)
        yieldModelLoad(hash)
        for i = 0, 180, 8 do
            local wall = OBJECT.CREATE_OBJECT_NO_OFFSET(hash, cord[1], cord[2], cord[3], true, true, true)
            ENTITY.SET_ENTITY_HEADING(wall, i)
            netItAll(wall)
            util.yield(10)
        end
        STREAMING.SET_MODEL_AS_NO_LONGER_NEEDED(hash)
    end
    --skidded from keramisScript
    function netItAll(entity)
        local netID = NETWORK.NETWORK_GET_NETWORK_ID_FROM_ENTITY(entity)
        while not NETWORK.NETWORK_HAS_CONTROL_OF_ENTITY(entity) do
            NETWORK.NETWORK_REQUEST_CONTROL_OF_ENTITY(entity)
        end
        util.yield(10)
        NETWORK.NETWORK_REQUEST_CONTROL_OF_NETWORK_ID(netID)
        util.yield(10)
        NETWORK.SET_NETWORK_ID_EXISTS_ON_ALL_MACHINES(netID)
        util.yield(10)
        NETWORK.SET_NETWORK_ID_CAN_MIGRATE(netID, false)
        util.yield(10)
        local playerList = players.list(true, true, true)
        for i = 1, #playerList do
            if NETWORK.NETWORK_IS_PLAYER_CONNECTED(i) then
                util.toast(playerList[i])
                NETWORK.SET_NETWORK_ID_ALWAYS_EXISTS_FOR_PLAYER(netID, playerList[i], true)
                util.yield(10)
            end
        end
        ENTITY.SET_ENTITY_AS_MISSION_ENTITY(entity, true, false)
        util.yield(10)
        ENTITY._SET_ENTITY_CLEANUP_BY_ENGINE(entity, false)
        util.yield(10)
        if ENTITY.IS_ENTITY_AN_OBJECT(entity) then
            NETWORK.OBJ_TO_NET(entity)
        end
        util.yield(10)
        ENTITY.SET_ENTITY_VISIBLE(entity, false, 0)
    end

----------------------------------
-- player info functions
----------------------------------
    function getMk2Rounds(ped, weaponHash)
        local ammoType = WEAPON.GET_PED_AMMO_TYPE_FROM_WEAPON(ped, weaponHash)
        if mkIIammoTable[weaponHash] and mkIIammoTable[weaponHash][ammoType] then
            return HUD._GET_LABEL_TEXT(mkIIammoTable[weaponHash][ammoType])
        end
    end

    function getDamageType(ped, weaponHash)
        local damageType = WEAPON.GET_WEAPON_DAMAGE_TYPE(weaponHash)
        if damageType == 0 then return 'Unknown'
        elseif damageType == 1 then return 'No damage'
        elseif damageType == 2 then return 'Melee'
        elseif damageType == 3 then
            local rounds = getMk2Rounds(ped, weaponHash)
            if rounds then return rounds
            else return 'Bullets'
        end
        elseif damageType == 4 then return 'Force ragdoll fall'
        elseif damageType == 5 then return 'Explosive'
        elseif damageType == 6 then return 'Fire'
        elseif damageType == 8 then return 'Fall'
        elseif damageType == 10 then return 'Electric'
        elseif damageType == 11 then return 'Barbed wire'
        elseif damageType == 12 then return 'Extinguisher'
        elseif damageType == 13 then return 'Gas'
        elseif damageType == 14 then return 'Water'
        end
    end

    function getWeaponHash(ped)
        local weaponHash = WEAPON.GET_SELECTED_PED_WEAPON(ped)
        local vehWeaponHash = nil
        local wpn_ptr = memory.alloc_int()
        if WEAPON.GET_CURRENT_PED_VEHICLE_WEAPON(ped, wpn_ptr) then -- only returns true if the weapon is a vehicle weapon
            vehWeaponHash = memory.read_int(wpn_ptr)
            memory.free(wpn_ptr)
        end
        return (vehWeaponHash and vehWeaponHash or weaponHash)
    end

    function getWeaponName(weaponHash)
        if weaponHashToLabel[weaponHash] then
            return HUD._GET_LABEL_TEXT(weaponHashToLabel[weaponHash])
        elseif weaponHashToString[weaponHash] then
            return weaponHashToString[weaponHash]
        elseif vehicleWeaponHashToLabel[weaponHash] then
            return HUD._GET_LABEL_TEXT(vehicleWeaponHashToLabel[weaponHash])
        elseif vehicleWeaponHashToString[weaponHash] then
            return vehicleWeaponHashToString[weaponHash]
        end
    end

    function getPlayerVehicleName(ped)
        local playersVehicle = PED.GET_VEHICLE_PED_IS_IN(ped)
        local vehHash = ENTITY.GET_ENTITY_MODEL(playersVehicle)
        if vehHash == 0 then return end
        return HUD._GET_LABEL_TEXT(VEHICLE.GET_DISPLAY_NAME_FROM_VEHICLE_MODEL(vehHash))
    end

    function isPlayerMoving(ped)
        if not PED.IS_PED_IN_ANY_VEHICLE(ped, true) and ENTITY.GET_ENTITY_SPEED(ped) > 1 then return true end
        if ENTITY.GET_ENTITY_SPEED(PED.GET_VEHICLE_PED_IS_IN(ped, false)) > 1 then return true end
    end

    taskTable = {
        [1] = {1, 'climbing Ladder'},
        [2] = {2, 'exiting vehicle'},
        [3] = {160, 'entering vehicle'},
        [4] = {335, 'parachuting'},
        [5] = {422, 'jumping'},
        [6] = {423, 'falling'},
    }
    function getMovementType(ped)
        if PED.IS_PED_RAGDOLL(ped) then
            return 'ragdolling'
        elseif PED.IS_PED_CLIMBING(ped) then
            return 'climbing'
        elseif PED.IS_PED_VAULTING(ped) then
            return 'vaulting'
        end
        for i = 1, #taskTable do
            if TASK.GET_IS_TASK_ACTIVE(ped, taskTable[i][1]) then return taskTable[i][2] end
        end
        if not isPlayerMoving(ped) then return end
        if PED.IS_PED_IN_ANY_VEHICLE(ped, true) then
            if PED.IS_PED_IN_ANY_PLANE(ped) then
                return 'flying a plane'
            elseif PED.IS_PED_IN_ANY_HELI(ped) then
                return 'flying a helicopter'
            elseif PED.IS_PED_IN_ANY_BOAT(ped) then
                return 'driving a boat'
            elseif PED.IS_PED_IN_ANY_SUB(ped) then
                return 'driving a submarine'
            elseif PED.IS_PED_ON_ANY_BIKE(ped) then
                return 'biking'
            end
            return 'driving'
        elseif PED.IS_PED_SWIMMING(ped) then
            return 'swimming'
        elseif TASK.IS_PED_SPRINTING(ped) then
            return 'sprinting'
        elseif PED.GET_PED_STEALTH_MOVEMENT(ped) then
            return 'sneaking'
        elseif PED.IS_PED_GOING_INTO_COVER(ped) then
            return 'going into cover'
        elseif PED.IS_PED_IN_COVER(ped) then
            return 'moving in cover'
        else
            return 'moving'
        end
    end

----------------------------------
-- Safe monitor functions
----------------------------------
    function getNightclubDailyEarnings()
        local popularity = math.floor(STAT_GET_INT('CLUB_POPULARITY') / 10)
        if popularity > 90 then return 10000
        elseif popularity > 85 then return 9000
        elseif popularity > 80 then return 8000
        elseif popularity > 75 then return 7000
        elseif popularity > 70 then return 6000
        elseif popularity > 65 then return 5500
        elseif popularity > 60 then return 5000
        elseif popularity > 55 then return 4500
        elseif popularity > 50 then return 4000
        elseif popularity > 45 then return 3500
        elseif popularity > 40 then return 3000
        elseif popularity > 35 then return 2500
        elseif popularity > 30 then return 2000
        elseif popularity > 25 then return 1500
        elseif popularity > 20 then return 1000
        elseif popularity > 15 then return 750
        elseif popularity > 10 then return 500
        elseif popularity > 5 then return 250
        else return 100
        end
    end

    function getAgencyDailyEarnings(securityContracts)
        if securityContracts >= 200 then return 20000 end
        return math.floor(securityContracts / 5) * 500
    end

----------------------------------
-- Tables
----------------------------------
    local joaat = util.joaat
    expTypeTable = {
        [-1] = 'DONTCARE',
        [0]  = 'GRENADE',
        [1]  = 'GRENADELAUNCHER',
        [2]  = 'STICKYBOMB',
        [3]  = 'MOLOTOV',
        [4]  = 'ROCKET',
        [5]  = 'TANKSHELL',
        [6]  = 'HI OCTANE',
        [7]  = 'CAR',
        [8]  = 'PLAN',
        [9]  = 'PETROL PUMP',
        [10] = 'BIKE',
        [11] = 'DIR STEAM',
        [12] = 'DIR FLAME',
        [13] = 'WATER HYDRAN',
        [14] = 'DIR GAS CANISTER',
        [15] = 'BOAT',
        [16] = 'SHIP DESTROY',
        [17] = 'TRUCK',
        [18] = 'BULLET',
        [19] = 'SMOKEGRENADELAUNCHER',
        [20] = 'SMOKEGRENADE',
        [21] = 'BZGAS',
        [22] = 'FLARE',
        [23] = 'GAS CANISTER',
        [24] = 'EXTINGUISHER',
        [25] = 'PROGRAMMABLEAR',
        [26] = 'TRAIN',
        [27] = 'BARREL',
        [28] = 'PROPANE',
        [29] = 'BLIMP',
        [30] = 'DIR FLAME EXPLODE',
        [31] = 'TANKER',
        [32] = 'PLANE ROCKET',
        [33] = 'VEHICLE BULLET',
        [34] = 'GAS TANK',
        [35] = 'BIRD CRAP',
        [36] = 'RAILGUN',
        [37] = 'BLIMP2',
        [38] = 'FIREWORK',
        [39] = 'SNOWBALL',
        [40] = 'PROXMINE',
        [41] = 'VALKYRIE CANNON',
        [42] = 'AIR DEFENCE',
        [43] = 'PIPEBOMB',
        [44] = 'VEHICLEMINE',
        [45] = 'EXPLOSIVEAMMO',
        [46] = 'APCSHELL',
        [47] = 'BOMB CLUSTER',
        [48] = 'BOMB GAS',
        [49] = 'BOMB INCENDIARY',
        [50] = 'BOMB STANDARD',
        [51] = 'TORPEDO',
        [52] = 'TORPEDO UNDERWATER',
        [53] = 'BOMBUSHKA CANNON',
        [54] = 'BOMB CLUSTER SECONDARY',
        [55] = 'HUNTER BARRAGE',
        [56] = 'HUNTER CANNON',
        [57] = 'ROGUE CANNON',
        [58] = 'MINE UNDERWATER',
        [59] = 'ORBITAL CANNON',
        [60] = 'BOMB STANDARD WIDE',
        [61] = 'EXPLOSIVEAMMO SHOTGUN',
        [62] = 'OPPRESSOR2 CANNON',
        [63] = 'MORTAR KINETIC',
        [64] = 'VEHICLEMINE KINETIC',
        [65] = 'VEHICLEMINE EMP',
        [66] = 'VEHICLEMINE SPIKE',
        [67] = 'VEHICLEMINE SLICK',
        [68] = 'VEHICLEMINE TAR',
        [69] = 'SCRIPT DRONE',
        [70] = 'UP-N-ATOMIZER',
        [71] = 'BURIEDMINE',
        [72] = 'SCRIPT MISSILE',
        [73] = 'RCTANK ROCKET',
        [74] = 'BOMB WATER',
        [75] = 'BOMB WATER SECONDARY',
        [76] = 'Unknown1',
        [77] = 'Unknown2',
        [78] = 'FLASHGRENADE',
        [79] = 'STUNGRENADE',
        [80] = 'Unknown3',
        [81] = 'SCRIPT MISSILE LARGE',
        [82] = 'SUBMARINE BIG',
        [83] = 'EMPLAUNCHER EMP',
    }
    effects = {
        ['Clown Explosion'] = {
            asset  	= 'scr_rcbarry2',
            name	= 'scr_exp_clown',
            colour 	= false,
            exp     = 31,
        },
        ['Clown Appears'] = {
            asset	= 'scr_rcbarry2',
            name 	= 'scr_clown_appears',
            colour  = false,
            exp     = 71,
        },
        ['FW Trailburst'] = {
            asset 	= 'scr_rcpaparazzo1',
            name 	= 'scr_mich4_firework_trailburst_spawn',
            colour 	= true,
            exp     = 66,

        },
        ['FW Starburst'] = {
            asset	= 'scr_indep_fireworks',
            name	= 'scr_indep_firework_starburst',
            colour 	= true,
        },
        ['FW Fountain'] = {
            asset 	= 'scr_indep_fireworks',
            name	= 'scr_indep_firework_fountain',
            colour 	= true,
        },
        ['Alien Disintegration'] = {
            asset	= 'scr_rcbarry1',
            name 	= 'scr_alien_disintegrate',
            colour 	= false,
            exp     = 3,
        },
        ['Clown Flowers'] = {
            asset	= 'scr_rcbarry2',
            name	= 'scr_clown_bul',
            colour 	= false,
        },
        ['FW Ground Burst'] = {
            asset 	= 'proj_indep_firework',
            name	= 'scr_indep_firework_grd_burst',
            colour 	= false,
            exp     = 25,
        }
    }
    --credit to aaron for this pog table
    weaponHashToLabel = {
        [joaat('weapon_unarmed')] = 'WT_UNARMED',
        [joaat('weapon_pistol')] = 'WT_PIST',
        [joaat('weapon_combatpistol')] = 'WT_PIST_CBT',
        [joaat('weapon_appistol')] = 'WT_PIST_AP',
        [joaat('weapon_smg')] = 'WT_SMG',
        [joaat('weapon_microsmg')] = 'WT_SMG_MCR',
        [joaat('weapon_assaultrifle')] = 'WT_RIFLE_ASL',
        [joaat('weapon_carbinerifle')] = 'WT_RIFLE_CBN',
        [joaat('weapon_advancedrifle')] = 'WT_RIFLE_ADV',
        [joaat('weapon_mg')] = 'WT_MG',
        [joaat('weapon_combatmg')] = 'WT_MG_CBT',
        [joaat('weapon_pumpshotgun')] = 'WT_SG_PMP',
        [joaat('weapon_sawnoffshotgun')] = 'WT_SG_SOF',
        [joaat('weapon_assaultshotgun')] = 'WT_SG_ASL',
        [joaat('weapon_heavysniper')] = 'WT_SNIP_HVY',
        [joaat('weapon_remotesniper')] = 'WT_SNIP_RMT',
        [joaat('weapon_sniperrifle')] = 'WT_SNIP_RIF',
        [joaat('weapon_grenadelauncher')] = 'WT_GL',
        [joaat('weapon_rpg')] = 'WT_RPG',
        [joaat('weapon_minigun')] = 'WT_MINIGUN',
        [joaat('weapon_grenade')] = 'WT_GNADE',
        [joaat('weapon_smokegrenade')] = 'WT_GNADE_SMK',
        [joaat('weapon_stickybomb')] = 'WT_GNADE_STK',
        [joaat('weapon_molotov')] = 'WT_MOLOTOV',
        [joaat('weapon_stungun')] = 'WT_STUN',
        [joaat('weapon_petrolcan')] = 'WT_PETROL',
        [joaat('weapon_electric_fence')] = 'WT_ELCFEN',
        [joaat('object')] = 'WT_OBJECT',
        [joaat('gadget_parachute')] = 'WT_PARA',
        [joaat('AMMO_RPG')] = 'WT_A_RPG',
        [joaat('AMMO_TANK')] = 'WT_A_TANK',
        [joaat('AMMO_SPACE_ROCKET')] = 'WT_A_SPACERKT',
        [joaat('AMMO_PLAYER_LASER')] = 'WT_A_PLRLSR',
        [joaat('AMMO_ENEMY_LASER')] = 'WT_A_ENMYLSR',
        [joaat('weapon_knife')] = 'WT_KNIFE',
        [joaat('weapon_nightstick')] = 'WT_NGTSTK',
        [joaat('weapon_hammer')] = 'WT_HAMMER',
        [joaat('weapon_bat')] = 'WT_BAT',
        [joaat('weapon_crowbar')] = 'WT_CROWBAR',
        [joaat('weapon_golfclub')] = 'WT_GOLFCLUB',
        [joaat('weapon_rammed_by_car')] = 'WT_PIST',
        [joaat('weapon_run_over_by_car')] = 'WT_PIST',
        [joaat('weapon_assaultsmg')] = 'WT_SMG_ASL',
        [joaat('weapon_bullpupshotgun')] = 'WT_SG_BLP',
        [joaat('weapon_pistol50')] = 'WT_PIST_50',
        [joaat('weapon_bottle')] = 'WT_BOTTLE',
        [joaat('weapon_gusenberg')] = 'WT_GUSENBERG',
        [joaat('weapon_snspistol')] = 'WT_SNSPISTOL',
        [joaat('weapon_vintagepistol')] = 'WT_VPISTOL',
        [joaat('weapon_dagger')] = 'WT_DAGGER',
        [joaat('weapon_flaregun')] = 'WT_FLAREGUN',
        [joaat('weapon_heavypistol')] = 'WT_HEAVYPSTL',
        [joaat('weapon_specialcarbine')] = 'WT_RIFLE_SCBN',
        [joaat('weapon_musket')] = 'WT_MUSKET',
        [joaat('weapon_firework')] = 'WT_FWRKLNCHR',
        [joaat('weapon_marksmanrifle')] = 'WT_MKRIFLE',
        [joaat('weapon_heavyshotgun')] = 'WT_HVYSHOT',
        [joaat('weapon_proxmine')] = 'WT_PRXMINE',
        [joaat('weapon_hominglauncher')] = 'WT_HOMLNCH',
        [joaat('weapon_hatchet')] = 'WT_HATCHET',
        [joaat('weapon_railgun')] = 'WT_RAILGUN',
        [joaat('weapon_combatpdw')] = 'WT_COMBATPDW',
        [joaat('weapon_knuckle')] = 'WT_KNUCKLE',
        [joaat('weapon_marksmanpistol')] = 'WT_MKPISTOL',
        [joaat('weapon_bullpuprifle')] = 'WT_BULLRIFLE',
        [joaat('weapon_machete')] = 'WT_MACHETE',
        [joaat('weapon_machinepistol')] = 'WT_MCHPIST',
        [joaat('weapon_flashlight')] = 'WT_FLASHLIGHT',
        [joaat('weapon_dbshotgun')] = 'WT_DBSHGN',
        [joaat('weapon_compactrifle')] = 'WT_CMPRIFLE',
        [joaat('weapon_switchblade')] = 'WT_SWBLADE',
        [joaat('weapon_revolver')] = 'WT_REVOLVER',
        [joaat('weapon_autoshotgun')] = 'WT_AUTOSHGN',
        [joaat('weapon_battleaxe')] = 'WT_BATTLEAXE',
        [joaat('weapon_compactlauncher')] = 'WT_CMPGL',
        [joaat('weapon_minismg')] = 'WT_MINISMG',
        [joaat('weapon_pipebomb')] = 'WT_PIPEBOMB',
        [joaat('weapon_poolcue')] = 'WT_POOLCUE',
        [joaat('weapon_wrench')] = 'WT_WRENCH',
        [joaat('weapon_cougar')] = 'WT_RAGE',
        [-159960575] = 'WT_VEH_WEP',
        [joaat('weapon_pistol_mk2')] = 'WT_PIST2',
        [joaat('weapon_smg_mk2')] = 'WT_SMG2',
        [joaat('weapon_heavysniper_mk2')] = 'WT_SNIP_HVY2',
        [joaat('weapon_combatmg_mk2')] = 'WT_MG_CBT2',
        [joaat('weapon_assaultrifle_mk2')] = 'WT_RIFLE_ASL2',
        [joaat('weapon_carbinerifle_mk2')] = 'WT_RIFLE_CBN2',
        [joaat('weapon_pumpshotgun_mk2')] = 'WT_SG_PMP2',
        [joaat('weapon_specialcarbine_mk2')] = 'WT_SPCARBINE2',
        [joaat('weapon_snspistol_mk2')] = 'WT_SNSPISTOL2',
        [joaat('weapon_marksmanrifle_mk2')] = 'WT_MKRIFLE2',
        [joaat('weapon_revolver_mk2')] = 'WT_REVOLVER2',
        [joaat('weapon_bullpuprifle_mk2')] = 'WT_BULLRIFLE2',
        [joaat('weapon_doubleaction')] = 'WT_REV_DA',
        [joaat('weapon_stone_hatchet')] = 'WT_SHATCHET',
        [joaat('weapon_raypistol')] = 'WT_RAYPISTOL',
        [joaat('weapon_raycarbine')] = 'WT_RAYCARBINE',
        [joaat('weapon_rayminigun')] = 'WT_RAYMINIGUN',
        [joaat('weapon_navyrevolver')] = 'WT_REV_NV',
        [joaat('weapon_ceramicpistol')] = 'WT_CERPST',
        [joaat('weapon_gadgetpistol')] = 'WT_GDGTPST',
        [joaat('weapon_militaryrifle')] = 'WT_MLTRYRFL',
        [joaat('weapon_combatshotgun')] = 'WT_CMBSHGN',
        [joaat('weapon_fertilizercan')] = 'WT_FERTCAN',
        [joaat('weapon_heavyrifle')] = 'WT_HEAVYRIFLE',
        [joaat('weapon_emplauncher')] = 'WT_EMPL',
        [joaat('weapon_stungun_mp')] = 'WT_STNGUNMP',
        --added by me
        [joaat('weapon_fireextinguisher')] = 'WT_FIRE',
        [joaat('weapon_ball')] = 'WT_BALL',
        [joaat('weapon_bzgas')] = 'WT_BZGAS',
        [joaat('weapon_flare')] = 'WT_FLARE',
        [joaat('weapon_snowball')] = 'WT_SNWBALL',
    }
    weaponHashToString = {
        [joaat('weapon_hazardcan')] = 'Hazardous Jerry Can', --label was null in data dumps, wut?
    }
    local pistolMk2Ammo = {
        [joaat('AMMO_PISTOL_TRACER')]      = 'WCT_CLIP_TR',
        [joaat('AMMO_PISTOL_INCENDIARY')]  = 'WCT_CLIP_INC',
        [joaat('AMMO_PISTOL_HOLLOWPOINT')] = 'WCT_CLIP_HP',
        [joaat('AMMO_PISTOL_FMJ')]         = 'WCT_CLIP_FMJ',
    }
    local rifleMk2Ammo = {
        [joaat('AMMO_RIFLE_TRACER')]        = 'WCT_CLIP_TR',
        [joaat('AMMO_RIFLE_INCENDIARY')]    = 'WCT_CLIP_INC',
        [joaat('AMMO_RIFLE_ARMORPIERCING')] = 'WCT_CLIP_AP',
        [joaat('AMMO_RIFLE_FMJ')]           = 'WCT_CLIP_FMJ',
    }
    mkIIammoTable = {
        [joaat('weapon_pistol_mk2')] = pistolMk2Ammo,
        [joaat('weapon_snspistol_mk2')] = pistolMk2Ammo,
        [joaat('weapon_revolver_mk2')] = pistolMk2Ammo,
        [joaat('weapon_smg_mk2')] = {
            [joaat('AMMO_SMG_TRACER')]      = 'WCT_CLIP_TR',
            [joaat('AMMO_SMG_INCENDIARY')]  = 'WCT_CLIP_INC',
            [joaat('AMMO_SMG_HOLLOWPOINT')] = 'WCT_CLIP_HP',
            [joaat('AMMO_SMG_FMJ')]         = 'WCT_CLIP_FMJ',
        },
        [joaat('weapon_combatmg_mk2')] = {
            [joaat('AMMO_MG_TRACER')]        = 'WCT_CLIP_TR',
            [joaat('AMMO_MG_INCENDIARY')]    = 'WCT_CLIP_INC',
            [joaat('AMMO_MG_ARMORPIERCING')] = 'WCT_CLIP_AP',
            [joaat('AMMO_MG_FMJ')]           = 'WCT_CLIP_FMJ',
        },
        [joaat('weapon_assaultrifle_mk2')] = rifleMk2Ammo,
        [joaat('weapon_bullpuprifle_mk2')] = {
            [joaat('AMMO_RIFLE_TRACER')]        = 'WCT_CLIP_TR',
            [joaat('AMMO_RIFLE_INCENDIARY')]    = 'WCT_CLIP_INC',
            [joaat('AMMO_RIFLE_ARMORPIERCING')] = 'WCT_CLIP_AP',
            [joaat('AMMO_RIFLE_FMJ')]           = 'WCT_CLIP_FMJ',
        },
        [joaat('weapon_carbinerifle_mk2')] = rifleMk2Ammo,
        [joaat('weapon_specialcarbine_mk2')] = rifleMk2Ammo,
        [joaat('weapon_pumpshotgun_mk2')] = {
            [joaat('AMMO_SHOTGUN_INCENDIARY')]    = 'WCT_SHELL_INC',
            [joaat('AMMO_SHOTGUN_HOLLOWPOINT')]   = 'WCT_SHELL_HP',
            [joaat('AMMO_SHOTGUN_ARMORPIERCING')] = 'WCT_SHELL_AP',
            [joaat('AMMO_SHOTGUN_EXPLOSIVE')]     = 'WCT_SHELL_EX',
        },
        [joaat('weapon_heavysniper_mk2')] = {
            [joaat('AMMO_SNIPER_INCENDIARY')]    = 'WCT_CLIP_INC',
            [joaat('AMMO_SNIPER_ARMORPIERCING')] = 'WCT_CLIP_AP',
            [joaat('AMMO_SNIPER_FMJ')]           = 'WCT_CLIP_FMJ',
            [joaat('AMMO_SNIPER_EXPLOSIVE')]     = 'WCT_CLIP_EX',
        },
        [joaat('weapon_marksmanrifle_mk2')] = {
            [joaat('AMMO_SNIPER_TRACER')]        = 'WCT_CLIP_TR',
            [joaat('AMMO_SNIPER_INCENDIARY')]    = 'WCT_CLIP_INC',
            [joaat('AMMO_SNIPER_ARMORPIERCING')] = 'WCT_CLIP_AP',
            [joaat('AMMO_SNIPER_FMJ')]           = 'WCT_CLIP_FMJ',
        },
    }
    local vehWeaponLabels = {
        missiles = 'WT_V_PLANEMSL',
        machineGun = 'WT_V_TURRET',
        machineGun2 = 'WT_V_PLRBUL', --returns the same text as the one above
        cannon  = 'WT_V_LZRCAN',
        rockets = 'WT_V_SPACERKT',
        tankCannon = 'WT_V_TANK',
        laser = 'WT_V_PLRLSR',
        grenadeLauncher = 'WT_V_KHA_GL',
        minigun = 'WT_MINIGUN',
        flameThrower = 'WT_V_FLAME',
        dual50cal = 'WT_V_MG50_2',
        dualLasers = 'WT_V_MG50_2L',
        explosiveCannon = 'WT_V_ROG_CANN',
        mine = 'WT_VEHMINE',
    }
    --i assume many of these are accurate, but many of them aren't tested
    vehicleWeaponHashToLabel = {
        [joaat('vehicle_weapon_cannon_blazer')] = vehWeaponLabels.machineGun2, --tested
        [joaat('vehicle_weapon_enemy_laser')] = 'WT_A_ENMYLSR',
        [joaat('vehicle_weapon_plane_rocket')] = vehWeaponLabels.missiles,
        [joaat('vehicle_weapon_player_bullet')] = vehWeaponLabels.machineGun2,
        [joaat('vehicle_weapon_player_buzzard')] = vehWeaponLabels.machineGun2,
        [joaat('vehicle_weapon_player_hunter')] = vehWeaponLabels.machineGun2,
        [joaat('vehicle_weapon_player_laser')] = vehWeaponLabels.laser,
        [joaat('vehicle_weapon_player_lazer')] = vehWeaponLabels.cannon,   --tested on the hydra, and lazer
        [joaat('vehicle_weapon_rotors')] = 'WT_INVALID',
        [joaat('vehicle_weapon_ruiner_bullet')] = vehWeaponLabels.machineGun2,
        [joaat('vehicle_weapon_ruiner_rocket')] = vehWeaponLabels.missiles,
        [joaat('vehicle_weapon_searchlight')] = 'WT_INVALID',
        [joaat('vehicle_weapon_radar')] = 'WT_INVALID',
        [joaat('vehicle_weapon_space_rocket')] = vehWeaponLabels.missiles, --tested on seasparrow, seems weird that it isnt rocket
        [joaat('vehicle_weapon_turret_boxville')] = vehWeaponLabels.machineGun,
        [joaat('vehicle_weapon_tank')] = vehWeaponLabels.tankCannon,          --tested
        [joaat('vehicle_weapon_akula_missile')] = vehWeaponLabels.missiles,
        [joaat('vehicle_weapon_ardent_mg')] = vehWeaponLabels.machineGun,
        [joaat('vehicle_weapon_comet_mg')] = vehWeaponLabels.machineGun,
        [joaat('vehicle_weapon_granger2_mg')] = vehWeaponLabels.machineGun,
        [joaat('vehicle_weapon_menacer_mg')] = vehWeaponLabels.machineGun,
        [joaat('vehicle_weapon_nightshark_mg')] = vehWeaponLabels.machineGun,
        [joaat('vehicle_weapon_revolter_mg')] = vehWeaponLabels.machineGun,
        [joaat('vehicle_weapon_savestra_mg')] = vehWeaponLabels.machineGun,
        [joaat('vehicle_weapon_viseris_mg')] = vehWeaponLabels.machineGun,
        [joaat('vehicle_weapon_akula_turret_single')] = vehWeaponLabels.machineGun,
        [joaat('vehicle_weapon_avenger_cannon')] = vehWeaponLabels.cannon,
        [joaat('vehicle_weapon_mobileops_cannon')] = vehWeaponLabels.cannon,
        [joaat('vehicle_weapon_akula_minigun')] = vehWeaponLabels.machineGun,
        [joaat('vehicle_weapon_insurgent_minigun')] = vehWeaponLabels.minigun,   --tested
        [joaat('vehicle_weapon_technical_minigun')] = vehWeaponLabels.minigun,
        [joaat('vehicle_weapon_brutus_50cal')] = vehWeaponLabels.dual50cal,
        [joaat('vehicle_weapon_dominator4_50cal')] = vehWeaponLabels.dual50cal,
        [joaat('vehicle_weapon_impaler2_50cal')] = vehWeaponLabels.dual50cal,
        [joaat('vehicle_weapon_imperator_50cal')] = vehWeaponLabels.dual50cal,
        [joaat('vehicle_weapon_slamvan4_50cal')] = vehWeaponLabels.dual50cal, --tested
        [joaat('vehicle_weapon_zr380_50cal')] = vehWeaponLabels.dual50cal,   --tested
        [joaat('vehicle_weapon_brutus2_50cal_laser')] = vehWeaponLabels.dualLasers,
        [joaat('vehicle_weapon_impaler3_50cal_laser')] = vehWeaponLabels.dualLasers,
        [joaat('vehicle_weapon_imperator2_50cal_laser')] = vehWeaponLabels.dualLasers,
        [joaat('vehicle_weapon_slamvan5_50cal_laser')] = vehWeaponLabels.dualLasers,
        [joaat('vehicle_weapon_zr3802_50cal_laser')] = vehWeaponLabels.dualLasers,
        [joaat('vehicle_weapon_dominator5_50cal_laser')] = vehWeaponLabels.dualLasers,
        --pretty much 99% accurate
        [joaat('vehicle_weapon_khanjali_cannon_heavy')] = 'WT_V_KHA_HCA',
        [joaat('vehicle_weapon_khanjali_gl')] = vehWeaponLabels.grenadeLauncher,
        [joaat('vehicle_weapon_khanjali_mg')] = 'WT_V_KHA_MG',
        [joaat('vehicle_weapon_khanjali_cannon')] = 'WT_V_KHA_CA',
        [joaat('vehicle_weapon_volatol_dualmg')] = 'WT_V_VOL_MG',
        [joaat('vehicle_weapon_akula_barrage')] = 'WT_V_AKU_BA',
        [joaat('vehicle_weapon_akula_turret_dual')] = 'WT_V_AKU_TD',
        [joaat('vehicle_weapon_tampa_missile')] = 'WT_V_TAM_MISS',
        [joaat('vehicle_weapon_tampa_dualminigun')] = 'WT_V_TAM_DMINI',
        [joaat('vehicle_weapon_tampa_fixedminigun')] = 'WT_V_TAM_FMINI',
        [joaat('vehicle_weapon_tampa_mortar')] = 'WT_V_TAM_MORT',
        [joaat('vehicle_weapon_apc_cannon')] = 'WT_V_APC_C',
        [joaat('vehicle_weapon_apc_missile')] = 'WT_V_APC_M',
        [joaat('vehicle_weapon_apc_mg')] = 'WT_V_APC_S',
        [joaat('vehicle_weapon_kosatka_torpedo')] = 'WT_V_KOS_TO',
        [joaat('vehicle_weapon_seasparrow2_minigun')] = 'WT_V_SPRW_MINI',
        [joaat('vehicle_weapon_annihilator2_barrage')] = 'WT_V_ANTOR_BA',
        [joaat('vehicle_weapon_annihilator2_missile')] = 'WT_V_ANTOR_MI',
        [joaat('vehicle_weapon_annihilator2_mini')] = vehWeaponLabels.machineGun2,
        [joaat('vehicle_weapon_rctank_gun')] = 'WT_V_RCT_MG',
        [joaat('vehicle_weapon_rctank_flame')] = 'WT_V_RCT_FL',
        [joaat('vehicle_weapon_rctank_rocket')] = 'WT_V_RCT_RK',
        [joaat('vehicle_weapon_rctank_lazer')] = 'WT_V_RCT_LZ',
        [joaat('vehicle_weapon_cherno_missile')] = 'WT_V_CHE_MI',
        [joaat('vehicle_weapon_barrage_top_mg')] = 'WT_V_BAR_TMG',
        [joaat('vehicle_weapon_barrage_top_minigun')] = 'WT_V_BAR_TMI',
        [joaat('vehicle_weapon_barrage_rear_mg')] = 'WT_V_BAR_RMG',
        [joaat('vehicle_weapon_barrage_rear_minigun')] = 'WT_V_BAR_RMI',
        [joaat('vehicle_weapon_barrage_rear_gl')] = 'WT_V_BAR_RGL',
        [joaat('vehicle_weapon_deluxo_mg')] = 'WT_V_DEL_MG',
        [joaat('vehicle_weapon_deluxo_missile')] = 'WT_V_DEL_MI',
        [joaat('vehicle_weapon_subcar_mg')] = 'WT_V_SUB_MG',
        [joaat('vehicle_weapon_subcar_missile')] = 'WT_V_SUB_MI',
        [joaat('vehicle_weapon_subcar_torpedo')] = 'WT_V_SUB_TO',
        [joaat('vehicle_weapon_thruster_mg')] = 'WT_V_THR_MG',
        [joaat('vehicle_weapon_thruster_missile')] = 'WT_V_THR_MI',
        [joaat('vehicle_weapon_mogul_nose')] = 'WT_V_MOG_NOSE',
        [joaat('vehicle_weapon_mogul_dualnose')] = 'WT_V_MOG_DNOSE',
        [joaat('vehicle_weapon_mogul_dualturret')] = 'WT_V_MOG_DTURR',
        [joaat('vehicle_weapon_mogul_turret')] = 'WT_V_MOG_TURR',
        [joaat('vehicle_weapon_tula_mg')] = 'WT_V_TUL_MG',
        [joaat('vehicle_weapon_tula_minigun')] = 'WT_V_TUL_MINI',
        [joaat('vehicle_weapon_tula_nosemg')] = 'WT_V_TUL_NOSE',
        [joaat('vehicle_weapon_tula_dualmg')] = 'WT_V_TUL_DUAL',
        [joaat('vehicle_weapon_vigilante_mg')] = 'WT_V_VGL_MG',
        [joaat('vehicle_weapon_vigilante_missile')] = 'WT_V_VGL_MISS',
        [joaat('vehicle_weapon_seabreeze_mg')] = 'WT_V_SBZ_MG',
        [joaat('vehicle_weapon_bombushka_cannon')] = 'WT_V_BSHK_CANN',
        [joaat('vehicle_weapon_bombushka_dualmg')] = 'WT_V_BSHK_DUAL',
        [joaat('vehicle_weapon_hunter_mg')] = 'WT_V_HUNT_MG',
        [joaat('vehicle_weapon_hunter_missile')] = 'WT_V_HUNT_MISS',
        [joaat('vehicle_weapon_hunter_barrage')] = 'WT_V_HUNT_BARR',
        [joaat('vehicle_weapon_hunter_cannon')] = 'WT_V_HUNT_CANN',
        [joaat('vehicle_weapon_microlight_mg')] = 'WT_V_MCRL_MG',
        [joaat('vehicle_weapon_caracara_mg')] = 'WT_V_TURRET',
        [joaat('vehicle_weapon_caracara_minigun')] = 'WT_V_TEC_MINI',
        [joaat('vehicle_weapon_deathbike_dualminigun')] = 'WT_V_DBK_MINI',
        [joaat('vehicle_weapon_deathbike2_minigun_laser')] = vehWeaponLabels.dualLasers,
        [joaat('vehicle_weapon_trailer_quadmg')] = 'WT_V_TR_QUADMG',
        [joaat('vehicle_weapon_trailer_dualaa')] = 'WT_V_TR_DUALAA',
        [joaat('vehicle_weapon_trailer_missile')] = 'WT_V_TR_MISS',
        [joaat('vehicle_weapon_halftrack_dualmg')] = 'WT_V_HT_DUALMG',
        [joaat('vehicle_weapon_halftrack_quadmg')] = 'WT_V_HT_QUADMG',
        [joaat('vehicle_weapon_oppressor_mg')] = 'WT_V_OP_MG',
        [joaat('vehicle_weapon_oppressor_missile')] = 'WT_V_OP_MISS',
        [joaat('vehicle_weapon_dune_mg')] = 'WT_V_DU_MG',
        [joaat('vehicle_weapon_dune_grenadelauncher')] = 'WT_V_DU_GL',
        [joaat('vehicle_weapon_dune_minigun')] = 'WT_V_DU_MINI',
        [joaat('vehicle_weapon_nose_turret_valkyrie')] = vehWeaponLabels.machineGun2,
        [joaat('vehicle_weapon_turret_valkyrie')] = vehWeaponLabels.machineGun,
        [joaat('vehicle_weapon_turret_technical')] = vehWeaponLabels.machineGun,
        [joaat('vehicle_weapon_player_savage')] = vehWeaponLabels.cannon,
        [joaat('vehicle_weapon_turret_limo')] = vehWeaponLabels.machineGun,
        [joaat('vehicle_weapon_speedo4_mg')] = 'WT_V_COM_MG',
        [joaat('vehicle_weapon_speedo4_turret_mg')] = 'WT_V_SPD_TMG',
        [joaat('vehicle_weapon_speedo4_turret_mini')] = 'WT_V_SPD_TMI',
        [joaat('vehicle_weapon_pounder2_mini')] = 'WT_V_COM_MG',
        [joaat('vehicle_weapon_pounder2_missile')] = 'WT_V_TAM_MISS',
        [joaat('vehicle_weapon_pounder2_barrage')] = 'WT_V_POU_BA',
        [joaat('vehicle_weapon_pounder2_gl')] = vehWeaponLabels.grenadeLauncher,
        [joaat('vehicle_weapon_rogue_mg')] = 'WT_V_ROG_MG',
        [joaat('vehicle_weapon_rogue_cannon')] = vehWeaponLabels.explosiveCannon,
        [joaat('vehicle_weapon_rogue_missile')] = 'WT_V_ROG_MISS',
        [joaat('vehicle_weapon_monster3_glkin')] = 'WT_V_GREN_KIN',
        [joaat('vehicle_weapon_mortar_kinetic')] = 'WT_V_MORTAR_KIN', --??? idk
        [joaat('vehicle_weapon_mortar_explosive')] = 'WT_V_TAM_MORT', --??? idk
        [joaat('vehicle_weapon_scarab_50cal')] = vehWeaponLabels.dual50cal,
        [joaat('vehicle_weapon_scarab2_50cal_laser')] = vehWeaponLabels.dualLasers,
        [joaat('vehicle_weapon_strikeforce_barrage')] = 'WT_V_HUNT_BARR',
        [joaat('vehicle_weapon_strikeforce_cannon')] = vehWeaponLabels.explosiveCannon,
        [joaat('vehicle_weapon_strikeforce_missile')] = 'WT_V_HUNT_MISS',
        [joaat('vehicle_weapon_hacker_missile')] = vehWeaponLabels.cannon, --(hacker means terrorbyte, im gonna have to test if these are accuate)
        [joaat('vehicle_weapon_hacker_missile_homing')] = vehWeaponLabels.cannon,
        [joaat('vehicle_weapon_flamethrower')] = vehWeaponLabels.flameThrower,     --tested
        [joaat('vehicle_weapon_flamethrower_scifi')] = vehWeaponLabels.flameThrower,    --tested, this is the flamethrower on the future shock cerberus
        [joaat('vehicle_weapon_havok_minigun')] = 'WT_V_HAV_MINI',
        [joaat('vehicle_weapon_dogfighter_mg')] = 'WT_V_DGF_MG',
        [joaat('vehicle_weapon_dogfighter_missile')] = 'WT_V_DGF_MISS',
        [joaat('vehicle_weapon_paragon2_mg')] = 'WT_V_COM_MG',
        [joaat('vehicle_weapon_scramjet_mg')] = 'WT_V_VGL_MG',
        [joaat('vehicle_weapon_scramjet_missile')] = 'WT_V_VGL_MISS',
        [joaat('vehicle_weapon_oppressor2_mg')] = 'WT_V_OP_MG',
        [joaat('vehicle_weapon_oppressor2_cannon')] = vehWeaponLabels.explosiveCannon,
        [joaat('vehicle_weapon_oppressor2_missile')] = 'WT_V_OP_MISS',
        [joaat('vehicle_weapon_mule4_mg')] = 'WT_V_COM_MG',
        [joaat('vehicle_weapon_mule4_missile')] = 'WT_V_TAM_MISS',
        [joaat('vehicle_weapon_mule4_turret_gl')] = vehWeaponLabels.grenadeLauncher,
        [joaat('vehicle_weapon_mine')] = vehWeaponLabels.mine, --unsure about these mines
        [joaat('vehicle_weapon_mine_emp')] = vehWeaponLabels.mine,
        [joaat('vehicle_weapon_mine_emp_rc')] = vehWeaponLabels.mine,
        [joaat('vehicle_weapon_mine_kinetic')] = vehWeaponLabels.mine,
        [joaat('vehicle_weapon_mine_kinetic_rc')] = vehWeaponLabels.mine,
        [joaat('vehicle_weapon_mine_slick')] = vehWeaponLabels.mine,
        [joaat('vehicle_weapon_mine_slick_rc')] = vehWeaponLabels.mine,
        [joaat('vehicle_weapon_mine_spike')] = vehWeaponLabels.mine,
        [joaat('vehicle_weapon_mine_spike_rc')] = vehWeaponLabels.mine,
        [joaat('vehicle_weapon_mine_tar')] = vehWeaponLabels.mine,
        [joaat('vehicle_weapon_mine_tar_rc')] = vehWeaponLabels.mine,
        [joaat('vehicle_weapon_issi4_50cal')] = vehWeaponLabels.dual50cal,
        [joaat('vehicle_weapon_issi5_50cal_laser')] = vehWeaponLabels.dualLasers,
        [joaat('vehicle_weapon_turret_insurgent')] = vehWeaponLabels.machineGun,
        [joaat('vehicle_weapon_jb700_mg')] = 'WT_V_COM_MG',
        [joaat('vehicle_weapon_patrolboat_dualmg')] = 'WT_V_PAT_DUAL',
        [joaat("vehicle_weapon_turret_dinghy5_50cal")] = 'WT_V_PAT_TURRET',
        [joaat('vehicle_weapon_turret_patrolboat_50cal')] = 'WT_V_PAT_TURRET',
        [joaat('vehicle_weapon_bruiser_50cal')] = vehWeaponLabels.dual50cal,
        [joaat('vehicle_weapon_bruiser2_50cal_laser')] = vehWeaponLabels.dualLasers,
    }
    vehicleWeaponHashToString = {
        [joaat('vehicle_weapon_bomb')] = 'Bomb',
        [joaat('vehicle_weapon_bomb_cluster')] = 'Cluster Bomb',
        [joaat('vehicle_weapon_bomb_gas')] = 'Gas Bomb',
        [joaat('vehicle_weapon_bomb_incendiary')] = 'Incendiary Bomb',
        [joaat('vehicle_weapon_bomb_standard_wide')] = 'Standard Wide Bomb',
        [joaat('vehicle_weapon_sub_missile_homing')] = 'Homing Missiles',
        [joaat('vehicle_weapon_water_cannon')] = 'Water Cannon',
    }
