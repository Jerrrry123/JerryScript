--[[coded by Jerry123#4508

    skids from:
    LanceScript by lance#8213
    WiriScript by Nowiry#2663
    KeramisScript by scriptCat#6566
    Heist control by IceDoomfist#0001
    LAZScript

    thx to Sai, ren, aaron, Nowry, JayMontana, IceDoomfist and scriptCat and everyone else that helped me in #programming :)
]]

require 'JSfuncsNtables'
local menu_root = menu.my_root()

local whitelistGroups = {user = true, friends = true, strangers  = true}
----------------------------------
-- Settings
----------------------------------
    local settings_root = menu.list(menu_root, 'Settings', {}, '')

    ----------------------------------
    -- Script settings
    ----------------------------------
        local script_settings_root = menu.list(settings_root, 'Script settings', {'JSsettings'}, '')

        notifications = true
        menu.toggle(script_settings_root, 'Disable JS notifications', {'JSnoNotify'}, 'Makes the script not notify when stuff happens. These can be pretty useful so I don\'t recommend turning them off.', function(toggle)
            notifications = not toggle
            if not toggle then
                util.toast('Notifications on')
            end
        end)

        local maxTimeBetweenPress = 300
        menu.slider(script_settings_root, 'Double tap interval', {'JSdoubleTapInterval'}, 'Lets you set the maximum time between double taps in ms.', 1, 1000, 300, 1, function(value)
            maxTimeBetweenPress = value
        end)

        local unFocusLists = {true}
        menu.toggle(script_settings_root, 'Stay in choosable lists', {'JSstayInLists'}, 'Makes you stay in lists after you\ve chosen an option.', function(toggle)
            unFocusLists[1] = not toggle
        end)

    ----------------------------------
    -- Player info settings
    ----------------------------------
        local pi_settings_root = menu.list(settings_root, 'Player info settings', {'JSplayerInfoSettings'}, '')

        local piSettings = new.hudSettings(-151, 1, 3)
        generateHudSettings(pi_settings_root, 'PI', piSettings)

    ----------------------------------
    -- Player info toggles
    ----------------------------------
        local pi_display_options_root = menu.list(pi_settings_root, 'Display options', {'PIDisplay'}, '')

        local playerInfoTogglesOptions = {
            {
                name = 'Disable name', command = 'PIdisableName', description = '', toggle = true,
                displayText = function(pid) return 'Player: ' .. players.get_name(pid) end
            },
            {
                name = 'Disable weapon', command = 'PIdisableWeapon', description = '', toggle = true,
                displayText = function(pid, ped, weaponHash)
                    local weaponName = getWeaponName(weaponHash)
                    return weaponName and 'Weapon: '.. weaponName
                end
            },
            {
                name = 'Disable ammo info', command = 'PIdisableAmmo', description = 'Displays ', toggle = true,
                displayText = function(pid, ped, weaponHash)
                    local damageType = WEAPON.GET_WEAPON_DAMAGE_TYPE(weaponHash)
                    if not (damageType == 12 or damageType == 1 or damageType == 3 or damageType == 5 or damageType == 13) or util.joaat('weapon_raypistol') == weaponHash then return end
                    local maxAmmo = WEAPON.GET_AMMO_IN_PED_WEAPON(ped, weaponHash)
                    local ammoCount = nil
                    local ammo_ptr = memory.alloc_int()
                    if WEAPON.GET_AMMO_IN_CLIP(ped, weaponHash, ammo_ptr) and WEAPON.GET_WEAPONTYPE_GROUP(weaponHash) ~= util.joaat('GROUP_THROWN') then
                        ammoCount = memory.read_int(ammo_ptr)
                        memory.free(ammo_ptr)
                        local clipSize = WEAPON.GET_MAX_AMMO_IN_CLIP(ped, weaponHash, 1)
                        if ammoCount == maxAmmo then return 'Total: ' .. maxAmmo .. ' / ' .. (clipSize < 10000 and clipSize or 9999) end
                        return ammoCount and 'Clip: ' .. ammoCount .. ' / ' .. clipSize .. ' || Total: ' .. maxAmmo
                    end
                    if not WEAPON.GET_CURRENT_PED_VEHICLE_WEAPON(ped, 'any') then
                        return 'Total: ' .. maxAmmo
                    end
                end
            },
            {   name = 'Disable damage type', command = 'PIdisableDamage', description = 'Displays the type of damage the players weapon does, like melee / fire / bullets / mk2 ammo.', toggle = true,
                displayText = function(pid, ped, weaponHash)
                    local damageType = getDamageType(ped, weaponHash)
                    return damageType and 'Damage type: ' .. damageType
                end
            },
            {
                name = 'Disable vehicle', command = 'PIdisableVehicle', description = '', toggle = true,
                displayText = function(pid, ped)
                    local vehicleName = getPlayerVehicleName(ped)
                    return vehicleName and 'Vehicle: ' .. vehicleName
                end
            },
            {
                name = 'Disable score', command = 'PIdisableScore', description = 'Only shows when you or they have kills.', toggle = true,
                displayText = function(pid)
                    local myScore = GET_INT_GLOBAL(2863967 + 386 + 1 + pid)
                    local theirScore = GET_INT_GLOBAL(2863967 + 353 + 1 + pid)
                    return (myScore > 0 or theirScore > 0) and (myScore ..' Vs '.. theirScore) --only returns score if either part has kills
                end
            },
            {
                name = 'Disable moving indicator', command = 'PIdisableMovement', description = '', toggle = true,
                displayText = function(pid, ped)
                    local movement = getMovementType(ped)
                    return movement and 'Player is ' .. movement
                end
            },
            {
                name = 'Disable aiming indicator', command = 'PIdisableAiming', description = '', toggle = true,
                displayText = function(pid)
                    return PLAYER.IS_PLAYER_TARGETTING_ENTITY(pid, PLAYER.PLAYER_PED_ID()) and 'Player is aiming at you'
                end
            },
            {
                name = 'Disable reload indicator', command = 'PIdisableReload', description = '', toggle = true,
                displayText = function(pid, ped)
                    return PED.IS_PED_RELOADING(ped) and 'Player is reloading'
                end
            },
        }
        generateToggles(playerInfoTogglesOptions, pi_display_options_root, true)

    -----------------------------------
    -- Safe monitor settings
    -----------------------------------
        local sm_settings_root = menu.list(settings_root, 'Safe monitor settings', {'SMsettings'},'Settings for the on screen text')

        smSettings = new.hudSettings(-3, 0, 2)
        generateHudSettings(sm_settings_root, 'SM', smSettings)

    -----------------------------------
    -- Explosion settings
    -----------------------------------
        local epx_settings_root = menu.list(settings_root, 'Explosion settings', {'JSexpSettings'}, '')

        local expLoopDelay = new.delay(250, 0, 0)
        local loop_delay_root = menu.list(epx_settings_root, 'Loop delay: '.. getDelayDisplayValue(expLoopDelay), {'JSexpDelay'}, 'Lets you set a custom delay between looped explosions.')

        generateDelaySettings(loop_delay_root, 'Loop delay', expLoopDelay)

        -----------------------------------
        -- Fx explosion settings
        -----------------------------------
            local expSettings = {
                camShake = 0, invisible = false, audible = true, noDamage = false, owned = false, blamed = false, blamedPlayer = false, expType = 0,
                --stuff for fx explosions
                currentFx = effects['Clown_Explosion'],
                colour = new.color(1, 0, 1)
            }

            local exp_type_root = menu.list(epx_settings_root,'Explosion type: Grenade', {'JSexpType'}, 'Choose between 85 different (but not very different) explosions.')
            local exp_fx_root = menu.list(epx_settings_root,'FX explosions', {'JSfxExp'}, 'Lets you choose effects instead of explosion type.')
            local exp_fx_type_root = menu.list(exp_fx_root, 'FX type: none', {'JSfxExpType'}, 'Choose a fx explosion type.')
            for i = -1, #expTypeTable do
                menu.action(exp_type_root, string.capitalize(expTypeTable[i]), {}, '', function()
                    if expSettings.currentFx then expSettings.currentFx = nil end
                    expSettings.expType = i
                    menu.set_menu_name(exp_type_root, 'Explosion type: ' .. string.capitalize(expTypeTable[i]))
                    menu.set_menu_name(exp_fx_type_root, 'FX type: none')
                    if unFocusLists[1] then
                        menu.focus(exp_type_root)
                    end
                end)
            end

            for k, table in pairsByKeys(effects) do
                local helpText = ''
                if effects[k].colour and not effects[k].exp then
                    helpText = helpText .. 'Colour can be changed.\nCan\'t be silenced.'
                elseif effects[k].colour then
                    helpText = helpText .. 'Colour can be changed.'
                elseif not effects[k].exp then
                    helpText = helpText .. 'Can\'t be silenced.'
                end
                menu.action(exp_fx_type_root, k, {}, helpText, function()
                    expSettings.currentFx = effects[k]
                    menu.set_menu_name(exp_type_root, 'Explosion type: Fx active')
                    menu.set_menu_name(exp_fx_type_root, 'FX type: ' .. k)
                    if unFocusLists[1] then
                        menu.focus(exp_fx_type_root)
                    end
                end)
            end

            menu.rainbow(menu.colour(exp_fx_root, 'FX color', {'JSPfxColor'}, 'Only works on some pfx\'s.',  new.color(1, 0, 1, 1), false, function(colour)
                expSettings.colour = colour
            end))
        -----------------------------------

        menu.slider(epx_settings_root, 'Camera shake', {'JSexpCamShake'}, 'How much explosions shake the camera.', 0, 1000, expSettings.camShake, 1, function(value)
            expSettings.camShake = value
        end)

        menu.toggle(epx_settings_root, 'Invisible explosions', {'JSexpInvis'}, '', function(toggle)
            expSettings.invisible = toggle
        end)

        menu.toggle(epx_settings_root, 'Silent explosions', {'JSexpSilent'}, '', function(toggle)
            expSettings.audible = not toggle
        end)

        menu.toggle(epx_settings_root, 'Disable explosion damage', {'JSnoExpDamage'}, '', function(toggle)
            expSettings.noDamage = toggle
        end)

        local blame_settings_root = menu.list(epx_settings_root,'Blame settings', {'JSblameSettings'}, 'Lets you blame yourself or other players for your explosions, go to the player list to chose a specific player to blame.')

        local runningToggling = false
        local function mutuallyExclusiveToggles(toggle)
            if menu.get_value(toggle) == 1 then
                runningToggling = true
                menu.trigger_command(toggle)
                util.yield()
                runningToggling = false
            end
        end

        local exp_blame_toggle
        local exp_own_toggle = menu.toggle(blame_settings_root, 'Owned explosions', {'JSownExp'}, 'Will overwrite "Disable explosion damage".', function(toggle)
            expSettings.owned = toggle
            if not runningToggling then
                mutuallyExclusiveToggles(exp_blame_toggle)
            end
        end)

        exp_blame_toggle = menu.toggle(blame_settings_root, 'Blame: Random', {'JSblameExp'}, 'Will overwrite "Disable explosion damage" and if you haven\'t chosen a player random players will be blamed for each explosion.', function(toggle)
            expSettings.blamed = toggle
            if not runningToggling then
                mutuallyExclusiveToggles(exp_own_toggle)
            end
        end)

        local blame_list_root = menu.list(blame_settings_root, 'Blame player list', {'JSblameList'}, 'Custom player list for selecting blames.')

        local blamesTogglesTable = {}
        players.on_join(function(pid)
            local playerName = players.get_name(pid)
            blamesTogglesTable[pid] = menu.action(blame_list_root, playerName, {'JSblame' .. playerName}, 'Blame ' .. playerName .. ' for your explosions.', function()
                expSettings.blamedPlayer = pid
                if menu.get_value(exp_blame_toggle) == 0 then
                    menu.trigger_command(exp_blame_toggle)
                end
                menu.set_menu_name(exp_blame_toggle, 'Blame: ' .. playerName)
                if unFocusLists[1] then
                    menu.focus(blame_list_root)
                end
            end)
        end)
        players.on_leave(function(pid)
            menu.delete(blamesTogglesTable[pid])
            if expSettings.blamedPlayer == pid then
                local playerList = players.list(true, true, true)
                for i = 1, #playerList do
                    menu.trigger_commands('JSexplodeLoop' .. players.get_name(playerList[i]) .. ' off')
                end
                menu.trigger_command(explodeLoopAll, 'off')
                expSettings.blamedPlayer = false
                menu.set_menu_name(exp_blame_toggle, 'Blame: Random')
                if notifications then
                    util.toast('Explosions stopped because the player you\'re blaming left.')
                end
            end
        end)

        menu.action(blame_settings_root, 'Random blames', {'JSblameRandomExp'}, 'Switches blamed explosions back to random if you already chose a player to blame.', function()
            expSettings.blamedPlayer = false
            if menu.get_value(exp_blame_toggle) == 0 then
                menu.trigger_command(exp_blame_toggle)
            end
            menu.set_menu_name(exp_blame_toggle, 'Blame: Random')
        end)

        local hornBoostMultiplier = 1.000
        menu.slider(settings_root, 'Horn boost multiplier', {'JShornBoostMultiplier'}, 'Set the force applied to the car when you or another player uses horn boost.', -100000, 100000, hornBoostMultiplier * 1000, 1, function(value)
            hornBoostMultiplier = value / 1000
        end)

-----------------------------------
-- Self
-----------------------------------
    local self_root = menu.list(menu_root, 'Self', {'JSself'}, '')

    --Transition points
    -- 49 -> 50
    -- 87 -> 88
    -- 159 -> 160
    -- 207 -> 208
    local alphaPoints = {0, 87, 159, 207, 255}
    menu.slider(self_root, 'Ghost', {'JSghost'}, 'Makes your player different levels off see through.',0,4, 4, 1, function(value)
        ENTITY.SET_ENTITY_ALPHA(PLAYER.PLAYER_PED_ID(),alphaPoints[value + 1], false)
    end)

    -----------------------------------
    -- Ped customization
    -----------------------------------
        --local custom_Ped_root = menu.list(self_root, 'Ped customization', {'JScustomPed'}, 'Options to customize how your ped looks, none of these options stick after game restart.')

        local faceFeature = {0}
        menu.slider(self_root, 'Customize face feature', {}, 'Set a value for the current face feature',0, 10, 1, 1, function(value)
            PED._SET_PED_MICRO_MORPH_VALUE(PLAYER.PLAYER_PED_ID(), faceFeature[1], value/ 10)
        end)

        local faceTable = {
            [0]  = 'Nose Width',
            [1]  = 'Nose Peak Hight',
            [2]  = 'Nose Peak Length',
            [3]  = 'Nose Bone High',
            [4]  = 'Nose Peak Lowering',
            [5]  = 'Nose Bone Twist',
            [6]  = 'EyeBrown High',
            [7]  = 'EyeBrown Forward',
            [8]  = 'Cheeks Bone High',
            [9]  = 'Cheeks Bone Width',
            [10] = 'Cheeks Width',
            [11] = 'Eyes Opening',
            [12] = 'Lips Thickness',
            [13] = 'Jaw Bone Width',
            [14] = 'Jaw Bone Back Length',
            [15] = 'Chimp Bone Lowering',
            [16] = 'Chimp Bone Length',
        }
        local face_feature_list = menu.list(self_root,'Current feature: Nose Width', {}, 'Choose a face feature to edit.')
        generateTableListI(face_feature_list, faceTable, faceFeature, 'Current face feature: ', 0, unFocusLists)
    -----------------------------------
    -- Ragdoll types
    -----------------------------------
        local ragdoll_types = menu.list(self_root, 'Ragdoll types', {'JSragdollTypes'}, 'Different options for making yourself ragdoll.')

        menu.toggle_loop(ragdoll_types, 'Better clumsiness', {'JSclumsy'}, 'Like stands clumsiness, but you can get up after you fall.', function()
            if PED.IS_PED_RAGDOLL(PLAYER.PLAYER_PED_ID()) then util.yield(3000) return end
            PED.SET_PED_RAGDOLL_ON_COLLISION(PLAYER.PLAYER_PED_ID(), true)
        end)

        menu.action(ragdoll_types, 'Trip', {'JStrip'}, 'Makes you fall over, works best when running.', function()
            local vector = ENTITY.GET_ENTITY_FORWARD_VECTOR(PLAYER.PLAYER_PED_ID())
            PED.SET_PED_TO_RAGDOLL_WITH_FALL(PLAYER.PLAYER_PED_ID(), 1500, 2000, 2, vector.x, -vector.y, vector.z, 1, 0, 0, 0, 0, 0, 0)
        end)

        -- credit to LAZScript for inspiring this
        local fallTimeout = false
        menu.toggle(ragdoll_types, 'Don\'t get back up', {'JSfallen'}, 'Makes you fall over and prevents you from getting back up.', function(toggle)
            if toggle then
                local vector = ENTITY.GET_ENTITY_FORWARD_VECTOR(PLAYER.PLAYER_PED_ID())
                PED.SET_PED_TO_RAGDOLL_WITH_FALL(PLAYER.PLAYER_PED_ID(), 1500, 2000, 2, vector.x, -vector.y, vector.z, 1, 0, 0, 0, 0, 0, 0)
            end
            fallTimeout = toggle
            while fallTimeout do
                PED.RESET_PED_RAGDOLL_TIMER(PLAYER.PLAYER_PED_ID())
                util.yield()
            end
        end)

        -- credit to aaron for telling me this :p
        menu.toggle_loop(ragdoll_types, 'Ragdoll', {'JSragdoll'}, 'Just makes you ragdoll.', function()
            PED.SET_PED_TO_RAGDOLL( PLAYER.PLAYER_PED_ID(), 2000, 2000, 0, true, true, true)
        end)
    -----------------------------------

    menu.toggle(self_root, 'Cold blooded', {'JScoldBlooded'}, 'Removes your thermal signature.\nOther players still see it tho.', function(toggle)
        if toggle then
            PED.SET_PED_HEATSCALE_OVERRIDE(PLAYER.PLAYER_PED_ID(), 0)
        else
            PED.SET_PED_HEATSCALE_OVERRIDE(PLAYER.PLAYER_PED_ID(), 1)
        end
    end)

    menu.toggle(self_root, 'Quiet footsteps', {'JSquietSteps'}, 'Disables the sound of your footsteps.', function(toggle)
        AUDIO._SET_PED_AUDIO_FOOTSTEP_LOUD(PLAYER.PLAYER_PED_ID(), not toggle)
     end)

-----------------------------------
-- Weapons
-----------------------------------
    local weapons_root = menu.list(menu_root, 'Weapons', {'JSweapons'}, '')

    local thermal_command = menu.ref_by_path('Game>Rendering>Thermal Vision', 34)
    menu.toggle_loop(weapons_root, 'Thermal guns', {'JSthermalGuns'}, 'Makes it so when you aim any gun you can toggle thermal vision on "E".', function()
        if PLAYER.IS_PLAYER_FREE_AIMING(PLAYER.PLAYER_PED_ID()) then
            if PAD.IS_CONTROL_JUST_PRESSED(2, 38) then
                if not GRAPHICS.GET_USINGSEETHROUGH() then
                    menu.trigger_command(thermal_command, 'on')
                    GRAPHICS._SEETHROUGH_SET_MAX_THICKNESS(50)
                else
                    menu.trigger_command(thermal_command, 'off')
                    GRAPHICS.SET_SEETHROUGH(false)
                    GRAPHICS._SEETHROUGH_SET_MAX_THICKNESS(1) --default value is 1
                end
            end
        elseif GRAPHICS.GET_USINGSEETHROUGH() then
            menu.trigger_command(thermal_command, 'off')
            GRAPHICS._SEETHROUGH_SET_MAX_THICKNESS(1)
        end
    end)

    -----------------------------------
    -- Proxy stickys
    -----------------------------------
        local proxy_sticky_root = menu.list(weapons_root, 'Proxy stickys', {}, '')

        local proxyStickySettings = {players = true, npcs = false, radius = 2}
        local function autoExplodeStickys(ped)
            local pos = ENTITY.GET_ENTITY_COORDS(ped, true)
            if not MISC.IS_PROJECTILE_TYPE_WITHIN_DISTANCE(pos.x, pos.y, pos.z, util.joaat('weapon_stickybomb'), proxyStickySettings.radius, true) then return end
            WEAPON.EXPLODE_PROJECTILES(PLAYER.PLAYER_PED_ID(), util.joaat('weapon_stickybomb'))
        end

        menu.toggle_loop(proxy_sticky_root, 'Proxy stickys', {'JSrollReload'}, 'Makes your sticky bombs automatically detonate around players or npcs, works with the player whitelist.', function()
            if proxyStickySettings.players then
                local playerList = getNonWhitelistedPlayers(whitelistListTable, {false,  whitelistGroups.friends, whitelistGroups.strangers}, whitelistedName)
                for i = 1, #playerList do
                    local ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(playerList[i])
                    autoExplodeStickys(ped)
                end
            end
            if proxyStickySettings.npcs then
                local pedHandles = entities.get_all_peds_as_handles()
                for i = 1, #pedHandles do
                    if not PED.IS_PED_A_PLAYER(pedHandles[i]) then
                        autoExplodeStickys(pedHandles[i])
                    end
                end
            end
            util.yield(5)
        end)

        menu.toggle(proxy_sticky_root, 'Detonate near players', {'JSStickyProxyPlayers'}, 'If your sticky bombs automatically detonate near players.', function(toggle)
            proxyStickySettings.players = toggle
        end, proxyStickySettings.players)

        menu.toggle(proxy_sticky_root, 'Detonate near npcs', {'JSStickyProxyNpcs'}, 'If your sticky bombs automatically detonate near npcs.', function(toggle)
            proxyStickySettings.npcs = toggle
        end, proxyStickySettings.npcs)

        menu.slider(proxy_sticky_root, 'Detonation radius', {'JSstickyRadius'}, 'How close the sticky bombs have to be to the target to detonate.', 1, 10, proxyStickySettings.radius, 1, function(value)
            proxyStickySettings.radius = value
        end)

        menu.action(proxy_sticky_root, 'Remove all sticky bombs', {'JSremoveStickys'}, 'Removes every single sticky bomb that exists (not only yours).', function()
            WEAPON.REMOVE_ALL_PROJECTILES_OF_TYPE(util.joaat('weapon_stickybomb'), false)
        end)
    -----------------------------------

    menu.toggle(weapons_root, 'Friendly fire', {'JSfriendlyFire'}, 'Makes you able to shoot peds the game count as your friends.', function(toggle)
        PED.SET_CAN_ATTACK_FRIENDLY(PLAYER.PLAYER_PED_ID(), toggle, false)
    end)

    menu.toggle_loop(weapons_root, 'Reload when rolling', {'JSrollReload'}, 'Reloads your weapon when doing a roll.', function()
        if TASK.GET_IS_TASK_ACTIVE(PLAYER.PLAYER_PED_ID(), 4) and PAD.IS_CONTROL_PRESSED(2, 22) and not PED.IS_PED_SHOOTING(PLAYER.PLAYER_PED_ID())  then --checking if player is rolling
            util.yield(900)
            WEAPON.REFILL_AMMO_INSTANTLY(PLAYER.PLAYER_PED_ID())
        end
    end)

    local remove_projectiles = false
    local function disableProjectileLoop(projectile)
        util.create_thread(function()
            util.create_tick_handler(function()
                WEAPON.REMOVE_ALL_PROJECTILES_OF_TYPE(projectile, false)
                return remove_projectiles
            end)
        end)
    end

    local exp_animal_toggle --so options above it have access to the toggle option

    local nuke_running = false
    local grenade_running = false
    local animals_running = false

    local nuke_height = 40
    local function executeNuke(pos)
        for a = 0, nuke_height, 4 do
            FIRE.ADD_EXPLOSION(pos.x, pos.y, pos.z + a, 8, 10, true, false, 1, false)
            util.yield(50)
        end
        FIRE.ADD_EXPLOSION(pos.x +8, pos.y +8, pos.z + nuke_height, 82, 10, true, false, 1, false)
        FIRE.ADD_EXPLOSION(pos.x +8, pos.y -8, pos.z + nuke_height, 82, 10, true, false, 1, false)
        FIRE.ADD_EXPLOSION(pos.x -8, pos.y +8, pos.z + nuke_height, 82, 10, true, false, 1, false)
        FIRE.ADD_EXPLOSION(pos.x -8, pos.y -8, pos.z + nuke_height, 82, 10, true, false, 1, false)
    end

    --credit to lance for the entity gun, but i edited it a bit
    local nuke_gun_toggle = menu.toggle(weapons_root, 'Nuke gun', {'JSnukeGun'}, 'Makes the rpg fire nukes', function(toggle)
        nuke_running = toggle
        if nuke_running then
            if animals_running then menu.trigger_command(exp_animal_toggle, 'off') end
            util.create_tick_handler(function()
                if WEAPON.GET_SELECTED_PED_WEAPON(PLAYER.PLAYER_PED_ID()) == -1312131151 then --if holding homing launcher
                    if PED.IS_PED_SHOOTING(PLAYER.PLAYER_PED_ID()) then
                        if not remove_projectiles then
                            remove_projectiles = true
                            disableProjectileLoop(-1312131151)
                        end
                        util.create_thread(function()
                            local hash = util.joaat('w_arena_airmissile_01a')
                            STREAMING.REQUEST_MODEL(hash)
                            yieldModelLoad(hash)
                            local cam_rot = CAM.GET_FINAL_RENDERED_CAM_ROT(2)
                            local dir, pos = direction()
                            local bomb = OBJECT.CREATE_OBJECT_NO_OFFSET(hash, pos.x, pos.y, pos.z, true, true, false)
                            ENTITY.APPLY_FORCE_TO_ENTITY(bomb, 0, dir.x, dir.y, dir.z, 0.0, 0.0, 0.0, 0, true, false, true, false, true)
                            ENTITY.SET_ENTITY_ROTATION(bomb, cam_rot.x, cam_rot.y, cam_rot.z, 1, true)
                            while not ENTITY.HAS_ENTITY_COLLIDED_WITH_ANYTHING(bomb) do util.yield() end
                            local nukePos = ENTITY.GET_ENTITY_COORDS(bomb, true)
                            entities.delete(bomb)
                            executeNuke(nukePos)
                        end)
                    else
                        remove_projectiles = false
                    end
                else
                    remove_projectiles = false
                end
                return nuke_running
            end)
        end
    end)

    --credit to scriptCat (^-^)
    local function get_waypoint_pos2()
        if HUD.IS_WAYPOINT_ACTIVE() then
            local blip = HUD.GET_FIRST_BLIP_INFO_ID(8)
            local waypoint_pos = HUD.GET_BLIP_COORDS(blip)
            return waypoint_pos
        else
            util.toast('No waypoint set.')
        end
    end

    menu.action(weapons_root, 'Nuke waypoint', {'JSnukeWP'}, 'Drops a nuke on your selected Waypoint.', function ()
        local waypointPos = get_waypoint_pos2()
        if waypointPos then
            local hash = util.joaat('w_arena_airmissile_01a')
            STREAMING.REQUEST_MODEL(hash)
            yieldModelLoad(hash)
            local bomb = OBJECT.CREATE_OBJECT_NO_OFFSET(hash, waypointPos.x, waypointPos.y, waypointPos.z + 30, true, true, false)
            ENTITY.SET_ENTITY_ROTATION(bomb, -90, 0, 0,  2, true)
            ENTITY.APPLY_FORCE_TO_ENTITY(bomb, 0, 0, 0, 0, 0.0, 0.0, 0.0, 0, true, false, true, false, true)
            STREAMING.SET_MODEL_AS_NO_LONGER_NEEDED(hash)
            while not ENTITY.HAS_ENTITY_COLLIDED_WITH_ANYTHING(bomb) do util.yield() end
            entities.delete(bomb)
            executeNuke(waypointPos)
        end
    end)
    menu.slider(weapons_root, 'Nuke height', {'JSnukeHeight'}, 'Drops a nuke on your selected Waypoint.', 10, 100, nuke_height, 10, function(value)
        nuke_height = value
    end)

    --this is heavily skidded from wiriScript so credit to wiri
    local launcherThrowable = {util.joaat('weapon_grenade')}
    local grenade_gun_toggle = menu.toggle(weapons_root, 'Throwables launcher', {'JSgrenade'}, 'Makes the grenade launcher able to shoot throwables, gives you the throwable if you don\'t have it so you can shoot it..', function(toggle)
        grenade_running = toggle
        if grenade_running then
            if animals_running then menu.trigger_command(exp_animal_toggle, "off") end
            util.create_tick_handler(function()
                if WEAPON.GET_SELECTED_PED_WEAPON(PLAYER.PLAYER_PED_ID()) == -1568386805 then --if holding grenade launcher
                    if PED.IS_PED_SHOOTING(PLAYER.PLAYER_PED_ID()) then
                        if not remove_projectiles then
                            remove_projectiles = true
                            disableProjectileLoop(-1568386805)
                        end
                        util.create_thread(function()
                            local currentWeapon = WEAPON.GET_CURRENT_PED_WEAPON_ENTITY_INDEX(PLAYER.PLAYER_PED_ID(), false)
                            local pos1 = ENTITY._GET_ENTITY_BONE_POSITION_2(currentWeapon, ENTITY.GET_ENTITY_BONE_INDEX_BY_NAME(currentWeapon, 'gun_muzzle'))
                            local pos2 = get_offset_from_gameplay_camera(30)
                            if not WEAPON.HAS_PED_GOT_WEAPON(PLAYER.PLAYER_PED_ID(), launcherThrowable[1], false) then
                                WEAPON.GIVE_WEAPON_TO_PED(PLAYER.PLAYER_PED_ID(), launcherThrowable[1], 9999, false, false)
                            end
                            util.yield()
                            MISC.SHOOT_SINGLE_BULLET_BETWEEN_COORDS(pos1.x, pos1.y, pos1.z, pos2.x, pos2.y, pos2.z, 200, true, launcherThrowable[1], PLAYER.PLAYER_PED_ID(), true, false, 2000.0)
                        end)
                    else
                        remove_projectiles = false
                    end
                else
                    remove_projectiles = false
                end
                return grenade_running
            end)
        end
    end)

    local throwablesTable = {
        Grenade = util.joaat('weapon_grenade'),
        Sticky_Bomb = util.joaat('weapon_stickybomb'),
        Proximity_Mine = util.joaat('weapon_proxmine'),
        BZ_Gas = util.joaat('weapon_bzgas'),
        Tear_Gas =  util.joaat('weapon_smokegrenade'),
        Molotov = util.joaat('weapon_molotov'),
        Flare = util.joaat('weapon_flare'),
        Snowball = util.joaat('weapon_snowball'),
        Ball = util.joaat('weapon_ball'),
        Pipe_Bomb = util.joaat('weapon_pipebomb'),
    }
    local throwable_list = menu.list(weapons_root, 'Current throwable: Grenade', {}, 'Choose what animal the explosive animal gun has.')
    generateTableList(throwable_list, throwablesTable, launcherThrowable, 'Current throwable: ', unFocusLists)

    local disable_firing = false
    local function disableFiringLoop()
        util.create_tick_handler(function()
            PLAYER.DISABLE_PLAYER_FIRING(PLAYER.PLAYER_PED_ID(), true)
            return disable_firing
        end)
    end

    local exp_animal = {'a_c_killerwhale'}
    exp_animal_toggle = menu.toggle(weapons_root, 'Explosive animal gun', {'JSexpAnimalGun'}, 'Inspired by impulses explosive whale gun, but can fire other animals too.', function(toggle)
        animals_running = toggle
        if animals_running then
            if nuke_running then menu.trigger_command(nuke_gun_toggle, 'off') end
            if grenade_running then menu.trigger_command(grenade_gun_toggle, 'off') end
            while animals_running do
                local weaponHash = WEAPON.GET_SELECTED_PED_WEAPON(PLAYER.PLAYER_PED_ID())
                local weaponType = WEAPON.GET_WEAPON_DAMAGE_TYPE(weaponHash)
                if weaponType == 3 or (weaponType == 5 and WEAPON.GET_WEAPONTYPE_GROUP(weaponHash) ~= 1548507267) then --weapons that shoot bullets or explosions and isn't in the throwables category (grenades, proximity mines etc...)
                    disable_firing = true
                    disableFiringLoop()
                    if PAD.IS_DISABLED_CONTROL_PRESSED(2,24) and PLAYER.IS_PLAYER_FREE_AIMING(PLAYER.PLAYER_PED_ID()) then
                        util.create_thread(function()
                            local hash = util.joaat(exp_animal[1])
                            STREAMING.REQUEST_MODEL(hash)
                            yieldModelLoad(hash)
                            local dir, c1 = direction()
                            local animal = entities.create_ped(28, hash, c1, 0)
                            local cam_rot = CAM.GET_FINAL_RENDERED_CAM_ROT(2)
                            ENTITY.APPLY_FORCE_TO_ENTITY(animal, 0, dir.x, dir.y, dir.z, 0.0, 0.0, 0.0, 0, true, false, true, false, true)
                            ENTITY.SET_ENTITY_ROTATION(animal, cam_rot.x, cam_rot.y, cam_rot.z, 1, true)
                            while not ENTITY.HAS_ENTITY_COLLIDED_WITH_ANYTHING(animal) do util.yield() end
                            local animalPos = ENTITY.GET_ENTITY_COORDS(animal, true)
                            entities.delete(animal)
                            FIRE.ADD_EXPLOSION(animalPos.x, animalPos.y,animalPos.z, 1, 10, true, false, 1, false)
                        end)
                    end
                else
                    disable_firing = false
                end
                util.yield(200)
            end
        else
            disable_firing = false
        end
    end)

    local animalsTable = {
        Cat = 'a_c_cat_01',
        Pug = 'a_c_pug',
        Killerwhale = 'a_c_killerwhale',
        Dolphin = 'a_c_dolphin',
        Hen = 'a_c_hen',
        Pig = 'a_c_pig',
        Chimp = 'a_c_chimp',
        Rat = 'a_c_rat',
        Fish = 'a_c_fish',
        Retriever = 'a_c_retriever',
        Rottweiler = 'a_c_rottweiler',
    }
    local exp_type_list = menu.list(weapons_root,'Current animal: Killerwhale', {}, 'Choose wat animal the explosive animal gun has.')
    generateTableList(exp_type_list, animalsTable, exp_animal, 'Current animal: ', unFocusLists)

-----------------------------------
-- Vehicle
-----------------------------------
    local my_vehicle_root = menu.list(menu_root, 'Vehicle', {'JSVeh'}, '')

    local my_cur_car = entities.get_user_vehicle_as_handle() --gets updated in the tick loop at the bottom of the script
    local carDoors = {
        "Driver Door",
        "Passenger Door",
        "Rear Left",
        "Rear Right",
        "Hood",
        "Trunk"
    }
    local carSettings carSettings = { --makes carSettings available inside this table
        disableExhaustPops = {on = false, setOption = function(toggle)
            AUDIO.ENABLE_VEHICLE_EXHAUST_POPS(my_cur_car, not toggle)
        end},
        launchControl = {on = false, setOption = function(toggle)
            PHYSICS._SET_LAUNCH_CONTROL_ENABLED(toggle)
        end},
        ghostCar = {on = true, value = 4, setOption = function(toggle)
            if carSettings.ghostCar.value ~= 4 then
                local index = toggle and carSettings.ghostCar.value + 1 or 5
                ENTITY.SET_ENTITY_ALPHA(my_cur_car, alphaPoints[index], true)
            end
        end},
        slipstream = {on = false, setOption = function(toggle)
            VEHICLE.SET_ENABLE_VEHICLE_SLIPSTREAMING(toggle)
        end},
        alternateHandling = {on = false, setOption = function(toggle)
            VEHICLE.SET_VEHICLE_USE_ALTERNATE_HANDLING(my_cur_car, toggle)
        end},
        raceHandling = {on = false, setOption = function(toggle)
            VEHICLE.SET_VEHICLE_IS_RACING(my_cur_car, toggle)
        end},
        indestructibleDoors = {on = false, setOption = function(toggle)
            local vehicleDoorCount =  VEHICLE._GET_NUMBER_OF_VEHICLE_DOORS(my_cur_car)
            for i = -1, vehicleDoorCount do
                VEHICLE._SET_VEHICLE_DOOR_CAN_BREAK(my_cur_car, i, not toggle)
            end
        end},
        npcHorn = {on = false, setOption = function(toggle)
            VEHICLE._SET_VEHICLE_SILENT(my_cur_car, toggle)
        end},
    }
    local function setCarOptions(toggle)
        for k, option in pairs(carSettings) do
            if option.on then option.setOption(toggle) end
        end
    end

    -----------------------------------
    -- Speed and handling
    -----------------------------------
        local speedHandling_root = menu.list(my_vehicle_root, 'Speed and handling', {'JSspeedHandling'}, '')

        menu.toggle(speedHandling_root, 'Alternate handling', {'JSaltHandling'}, 'Might slightly increase the turning rate, top speed and acceleration on some vehicles', function(toggle)
            carSettings.alternateHandling.on = toggle
            carSettings.alternateHandling.setOption(toggle)
        end)

        menu.toggle(speedHandling_root, 'Race mode', {'JSraceMode'}, 'Might increase handling.', function(toggle)
            carSettings.raceHandling.on = toggle
            carSettings.raceHandling.setOption(toggle)
        end)

        menu.toggle(speedHandling_root, 'Launch control', {'JSlaunchControl'}, 'Limits how much force your car applies when accelerating so it doesn\'t burnout, very noticeable in a Emerus.', function(toggle)
            carSettings.launchControl.on = toggle
            carSettings.launchControl.setOption(toggle)
        end)

        menu.toggle(speedHandling_root, 'Enable slipstreaming', {'JSslipstream'}, 'Enables global slipstream physics', function(toggle)
            carSettings.slipstream.on = toggle
            carSettings.slipstream.setOption(toggle)
        end)

        local my_torque = 1000
        menu.slider(speedHandling_root, 'Set torque', {'JSsetSelfTorque'}, 'Modifies the speed of your vehicle.', -1000000, 1000000, my_torque, 1, function(value)
            my_torque = value
            util.create_tick_handler(function()
                VEHICLE.SET_VEHICLE_CHEAT_POWER_INCREASE(my_cur_car, my_torque/1000)
                return (my_torque ~= 1000)
            end)
        end)

        local quickBrakeLvL = 1.5
        menu.toggle_loop(speedHandling_root, 'Quick brake', {'JSquickBrake'}, 'Slows down your speed more when pressing "S".', function(toggle)
            if PAD.IS_CONTROL_JUST_PRESSED(2, 72) and ENTITY.GET_ENTITY_SPEED(my_cur_car) >= 0 and not ENTITY.IS_ENTITY_IN_AIR(my_cur_car) and VEHICLE.GET_PED_IN_VEHICLE_SEAT(my_cur_car, -1, false) == PLAYER.PLAYER_PED_ID() then
                VEHICLE.SET_VEHICLE_FORWARD_SPEED(my_cur_car, ENTITY.GET_ENTITY_SPEED(my_cur_car) / quickBrakeLvL)
                util.yield(250)
            end
        end)

        menu.slider(speedHandling_root, 'Quick brake force', {'JSquickBrakeForce'}, '100 is ordinary brakes.', 100, 999, 150, 1,  function(value)
            quickBrakeLvL = value / 100
        end)

    -----------------------------------
    -- Boosts
    -----------------------------------
        local boosts_root = menu.list(my_vehicle_root, 'Boosts', {'JSboosts'}, '')

        menu.toggle_loop(boosts_root, 'Horn boost', {'JShornBoost'}, 'Makes your car speed up when you honking your horn or activating your siren.', function()
            if not (AUDIO.IS_HORN_ACTIVE(my_cur_car) or VEHICLE.IS_VEHICLE_SIREN_ON(my_cur_car)) then return end
            VEHICLE.SET_VEHICLE_FORWARD_SPEED(my_cur_car, ENTITY.GET_ENTITY_SPEED(my_cur_car) + hornBoostMultiplier)
        end)

        local pressedW = util.current_time_millis()
        menu.toggle_loop(boosts_root, 'Vehicle jump', {'JSVehJump'}, 'Lets you jump with your car if you double tap "W".', function()
            if VEHICLE.GET_PED_IN_VEHICLE_SEAT(my_cur_car, -1, false) == PLAYER.PLAYER_PED_ID() and PED.IS_PED_IN_VEHICLE(PLAYER.PLAYER_PED_ID(), my_cur_car, true) then
                if PAD.IS_CONTROL_JUST_PRESSED(2, 32) then
                    if not (util.current_time_millis() - pressedW <= maxTimeBetweenPress) then
                        pressedW = util.current_time_millis()
                        return
                    end
                    local mySpeed = ENTITY.GET_ENTITY_SPEED(my_cur_car)
                    ENTITY.APPLY_FORCE_TO_ENTITY_CENTER_OF_MASS(my_cur_car, 1, 0, 2, (mySpeed / 10) + 14, 0, true, true, true)
                    AUDIO.PLAY_SOUND_FROM_ENTITY(-1, 'Hydraulics_Down', PLAYER.PLAYER_PED_ID(), 'Lowrider_Super_Mod_Garage_Sounds', true, 20)
                end
            end
        end)

        -----------------------------------
        -- Nitro
        -----------------------------------
            local nitro_root = menu.list(boosts_root, 'Nitro', {}, '')

            local nitroSettings = {level = new.delay(500, 2, 0), power = 1, rechargeTime = new.delay(200, 1, 0)}

            local nitroBoostActive = false
            menu.toggle(nitro_root, 'Enable nitro', {'JSnitro'}, 'Enable nitro boost on any vehicle, use it by pressing "X".', function(toggle)
                nitroBoostActive = toggle
                if not STREAMING.HAS_NAMED_PTFX_ASSET_LOADED('veh_xs_vehicle_mods') then
                    STREAMING.REQUEST_NAMED_PTFX_ASSET('veh_xs_vehicle_mods')
                    while not STREAMING.HAS_NAMED_PTFX_ASSET_LOADED('veh_xs_vehicle_mods') do util.yield() end
                end
                while nitroBoostActive do
                    if PAD.IS_CONTROL_JUST_PRESSED(2, 357) and PED.IS_PED_IN_ANY_VEHICLE(PLAYER.PLAYER_PED_ID(), true) then --control is x
                        VEHICLE._SET_VEHICLE_NITRO_ENABLED(my_cur_car, true, getTotalDelay(nitroSettings.level) / 10, nitroSettings.power, 999999999999999999, false)
                        util.yield(getTotalDelay(nitroSettings.level))
                        VEHICLE._SET_VEHICLE_NITRO_ENABLED(my_cur_car, false, getTotalDelay(nitroSettings.level) / 10, nitroSettings.power, 999999999999999999, false)
                        local startTime = util.current_time_millis()
                        while util.current_time_millis() < startTime + getTotalDelay(nitroSettings.rechargeTime) do util.yield() end
                    end
                    util.yield()
                end
            end)

            local nitro_duration_root = menu.list(nitro_root, 'Duration: '.. getDelayDisplayValue(nitroSettings.level), {'JSnitroDuration'}, 'Lets you set a customize how long the nitro lasts.')
            generateDelaySettings(nitro_duration_root, 'Duration', nitroSettings.level)

            local nitro_recharge_root = menu.list(nitro_root, 'Recharge time: '.. getDelayDisplayValue(nitroSettings.rechargeTime), {'JSnitroRecharge'}, 'Lets you set a custom delay of how long it takes for nitro to recharge.')
            generateDelaySettings(nitro_recharge_root, 'Recharge time', nitroSettings.rechargeTime)

        -----------------------------------
        -- Shunt boost
        -----------------------------------
            local shunt_root = menu.list(boosts_root, 'Shunt boost', {'JSshunt'}, '')

            local shuntSettings = {
                maxForce = 30, force = 30, disableRecharge = false,
                lastPress = {
                    A = util.current_time_millis(), D = util.current_time_millis()
                }
            }
            local function forceRecharge()
                util.create_thread(function()
                    shuntSettings.force = 0
                    while shuntSettings.force < shuntSettings.maxForce and not shuntSettings.disableRecharge do
                        shuntSettings.force = shuntSettings.force + 1
                        util.yield(100)
                    end
                    shuntSettings.force = shuntSettings.maxForce
                    if notifications and not shuntSettings.disableRecharge then
                        util.toast('Shunt boost fully recharged')
                    end
                end)
            end
            local function shunt(dir)
                ENTITY.APPLY_FORCE_TO_ENTITY_CENTER_OF_MASS(my_cur_car, 1, shuntSettings.force * dir, 0, 0, 0, true, true, true)
                AUDIO.PLAY_SOUND_FROM_ENTITY(-1, 'Hydraulics_Down', PLAYER.PLAYER_PED_ID(), 'Lowrider_Super_Mod_Garage_Sounds', true, 20)
                forceRecharge()
            end
            menu.toggle_loop(shunt_root, 'Shunt boost', {'JSshuntBoost'}, 'Lets you shunt boost in any vehicle by double tapping "A" or "D".', function()
                util.create_thread(function()
                    if VEHICLE.GET_PED_IN_VEHICLE_SEAT(my_cur_car, -1, false) == PLAYER.PLAYER_PED_ID() and PED.IS_PED_IN_VEHICLE(PLAYER.PLAYER_PED_ID(), my_cur_car, true) then
                        if PAD.IS_CONTROL_JUST_PRESSED(2, 35) then --D
                            if not (util.current_time_millis() - shuntSettings.lastPress.D <= maxTimeBetweenPress) then
                                shuntSettings.lastPress.D = util.current_time_millis()
                                return
                            end
                            shunt(1)
                        elseif PAD.IS_CONTROL_JUST_PRESSED(2, 34) then --A
                            if not (util.current_time_millis() - shuntSettings.lastPress.A <= maxTimeBetweenPress) then
                                shuntSettings.lastPress.A = util.current_time_millis()
                                return
                            end
                            shunt(-1)
                        end
                    end
                end)
            end)

            menu.toggle(shunt_root, 'Disable recharge', {'JSnoShutRecharge'}, 'Removes the force build-up of the shunt boost.', function(toggle)
                shuntSettings.disableRecharge = toggle
            end)
            menu.slider(shunt_root, 'Force', {'JSshuntForce'}, 'How much force is applied to your car.', 0, 1000, 30, 1, function(value)
                shuntSettings.maxForce = value
            end)

    -----------------------------------
    -- Vehicle doors
    -----------------------------------
        local veh_door_root = menu.list(my_vehicle_root, 'Vehicle doors', {'JSvehDoors'}, '')

        menu.toggle(veh_door_root, 'Indestructible doors', {'JSinvincibleDoors'}, 'Makes it so your vehicle doors can\'t break off.', function(toggle)
            carSettings.indestructibleDoors.on = toggle
            local vehicleDoorCount =  VEHICLE._GET_NUMBER_OF_VEHICLE_DOORS(my_cur_car)
            for i = -1, vehicleDoorCount do
                VEHICLE._SET_VEHICLE_DOOR_CAN_BREAK(my_cur_car, i, not toggle)
            end
        end)

        menu.toggle_loop(veh_door_root, 'Shut doors when driving', {'JSautoClose'}, 'Closes all the vehicle doors when you start driving.', function()
            if VEHICLE.GET_PED_IN_VEHICLE_SEAT(my_cur_car, -1, false) == PLAYER.PLAYER_PED_ID() and ENTITY.GET_ENTITY_SPEED(my_cur_car) > 1 then --over a speed of 1 because car registers as moving then doors move
                if ENTITY.GET_ENTITY_SPEED(my_cur_car) < 10 then util.yield(800) else util.yield(600) end
                local closed = false
                for i, door in ipairs(carDoors) do
                    if VEHICLE.GET_VEHICLE_DOOR_ANGLE_RATIO(my_cur_car, (i-1)) > 0 and not VEHICLE.IS_VEHICLE_DOOR_DAMAGED(my_cur_car, (i-1)) then
                        VEHICLE.SET_VEHICLE_DOOR_SHUT(my_cur_car, (i-1), false)
                        closed = true
                    end
                end
                if notifications and closed then
                    util.toast('Closed your car doors.')
                end
            end
        end)

        --credit to Wiri, I couldn't get the trunk to close/open so I copied him
        menu.action(veh_door_root, 'Open all doors', {'JScarDoorsOpen'}, 'Made this to test door stuff.', function()
            for i, door in ipairs(carDoors) do
                VEHICLE.SET_VEHICLE_DOOR_OPEN(my_cur_car, (i-1), false, false)
            end
        end)

        menu.action(veh_door_root, 'Close all doors', {'JScarDoorsClosed'}, 'Made this to test door stuff.', function()
            VEHICLE.SET_VEHICLE_DOORS_SHUT(my_cur_car, false)
        end)

    -----------------------------------
    -- Plane options
    -----------------------------------
        local plane_root = menu.list(my_vehicle_root, 'Plane options', {'JSplane'}, '')

        local afterBurnerState = false
        local afterburnerToggle = false
        menu.toggle(plane_root, 'Toggle plane afterburner', {'JSafterburner'}, 'Makes you able to toggle afterburner on planes by pressing "left shift".', function(toggle)
            afterburnerToggle = toggle
            util.create_tick_handler(function()
                if PAD.IS_CONTROL_JUST_PRESSED(2, 61) then
                    afterBurnerState = not afterBurnerState
                    VEHICLE.SET_VEHICLE_FORCE_AFTERBURNER(my_cur_car, afterBurnerState)
                end
                return afterburnerToggle
            end)
            VEHICLE.SET_VEHICLE_FORCE_AFTERBURNER(my_cur_car, false)
        end)

        menu.toggle(plane_root, 'Lock vtol', {'JSlockVtol'}, 'Locks the angle of planes vtol propellers.', function(toggle)
            VEHICLE._SET_DISABLE_VEHICLE_FLIGHT_NOZZLE_POSITION(my_cur_car, toggle)
        end)
    -----------------------------------

    menu.slider(my_vehicle_root, 'Ghost vehicle', {'JSghostVeh'}, 'Makes your vehicle different levels off see through.',0 , 4, 4, 1, function(value)
        carSettings.ghostCar.value = value
        if PED.IS_PED_IN_ANY_VEHICLE(PLAYER.PLAYER_PED_ID(), true) then
            ENTITY.SET_ENTITY_ALPHA(my_cur_car,alphaPoints[value + 1], true)
        end
    end)

    menu.toggle(my_vehicle_root, 'Disable exhaust pops', {'JSdisablePops'}, 'Disables those annoying exhaust pops that your car makes if it has a non-stock exhaust option.', function(toggle)
        carSettings.disableExhaustPops.on = toggle
        carSettings.disableExhaustPops.setOption(toggle)
    end)

    menu.toggle(my_vehicle_root, 'Npc horn', {'JSnpcHorn'}, 'Makes you horn like a npc. Also makes your car doors silent.', function(toggle)
        carSettings.npcHorn.on = toggle
        VEHICLE._SET_VEHICLE_SILENT(my_cur_car, toggle)
    end)

    menu.toggle_loop(my_vehicle_root, 'To the moon', {'JStoMoon'}, 'Forces you info the sky if you\'re in a vehicle.', function(toggle)
        NETWORK.NETWORK_REQUEST_CONTROL_OF_ENTITY(my_cur_car)
        ENTITY.APPLY_FORCE_TO_ENTITY(my_cur_car, 1, 0, 0, 100, 0, 0, 0.5, 0, false, false, true)
    end)
    menu.toggle_loop(my_vehicle_root, 'Anchor', {'JSanchor'}, 'Forces you info the ground if you\'re in a air born vehicle.', function(toggle)
        if ENTITY.IS_ENTITY_IN_AIR(my_cur_car) then
            NETWORK.NETWORK_REQUEST_CONTROL_OF_ENTITY(my_cur_car)
            ENTITY.APPLY_FORCE_TO_ENTITY(my_cur_car, 1, 0, 0, -100, 0, 0, 0.5, 0, false, false, true)
        end
    end)

-----------------------------------
-- Online
-----------------------------------
    local online_root = menu.list(menu_root, 'Online', {'JSonline'}, '')

    -----------------------------------
    -- Safe monitor
    -----------------------------------
        local SM_root = menu.list(online_root, "Safe monitor", {"JSsm"}, 'Safe monitor allows you to monitor your safes. It does NOT affect the money being generated.')

        local toggleSafeMonitor = false
        menu.toggle(SM_root, 'Toggle all selected', {'SMtoggleAllSelected'}, 'Toggles every option.', function(toggle)
            toggleSafeMonitor = toggle
        end)

        local safeManagerToggles = {
            {
                name = 'Nightclub Safe', command = 'SMclub', description = 'Monitors nightclub safe cash, this does NOT affect income.', toggle = true,
                displayText = function() return 'Nightclub Cash: ' .. STAT_GET_INT('CLUB_SAFE_CASH_VALUE')  / 1000  .. 'k / 210k' end
            },
            {
                name = 'Nightclub Popularity', command = 'SMclubPopularity', description = 'Nightclub popularity.\nMaximum daily earnings at 100% and 95% popularity.', toggle = false,
                displayText = function() return 'Nightclub Popularity: ' .. math.floor(STAT_GET_INT('CLUB_POPULARITY') / 10)  .. '%' end
            },
            {   name = 'Nightclub Daily Earnings', command = 'SMnightclubEarnings', description = 'Nightclub daily earnings.\nMaximum daily earnings is 10k.', toggle = false,
                displayText = function() return 'Nightclub Daily Earnings: ' .. getNightclubDailyEarnings() / 1000  .. 'k / day' end
            },
            {
                name = 'Arcade safe', command = 'SMarcade', description = 'Monitors arcade safe cash, this does NOT affect income.\nMaximum daily earnings is 5k if you have all the arcade games.', toggle = true,
                displayText = function() return 'Arcade Cash: ' .. STAT_GET_INT('ARCADE_SAFE_CASH_VALUE') / 1000  .. 'k / 100k' end
            },
            {
                name = 'Agency safe', command = 'SMagency', description = 'Monitors agency safe cash, this does NOT affect income.\nMaximum daily earnings is 20k.', toggle = true,
                displayText = function() return 'Agency Cash: ' .. STAT_GET_INT("FIXER_SAFE_CASH_VALUE") / 1000  .. 'k / 250k' end
            },
            {
                name = 'Security contracts', command = 'SMsecurity', description = 'Displays the number of agency security missions you have completed.', toggle = false,
                displayText = function() return 'Security contracts: ' .. STAT_GET_INT('FIXER_COUNT') end
            },
            {
                name = 'Agency daily Earnings', command = 'SMagencyEarnings', description = 'Agency daily earnings.\nMaximum daily earnings is 20k if you have completed 200 contracts.', toggle = false,
                displayText = function() return 'Agency Daily Earnings: ' .. getAgencyDailyEarnings(STAT_GET_INT('FIXER_COUNT')) / 1000 .. 'k / day' end
            },
        }
        generateToggles(safeManagerToggles, SM_root, false)

        local first_open_SM_earnings = {true}
        SM_earnings_root = menu.list(SM_root, 'Increase safe earnings', {'SMearnings'}, 'Might be risky.', function()
            listWarning(SM_earnings_root, first_open_SM_earnings)
        end)

        menu.toggle_loop(SM_earnings_root, 'Auto nightclub popularity', {'SMautoClubPop'}, 'Automatically sets the nightclubs popularity to 100 if it results in less than max daily income.', function(toggle)
            if getNightclubDailyEarnings() < 10000 then
                menu.trigger_commands('clubPopularity 100')
            end
        end)

        local fixer_count_cooldown = false
        menu.action(SM_earnings_root, 'Increment security contracts completed', {'SMsecurityComplete'}, 'Will put you in a new lobby to make the increase stick.\nI added a cooldown to this button so you cant spam it.\nAlso doesn\'t work past 200', function()
            if fixer_count_cooldown then util.toast('Cooldown active') return end
            if util.is_session_transition_active() then util.toast('You can only use this while in a session.') return end
            if STAT_GET_INT('FIXER_COUNT') >= 200 then util.toast('You already reached 200 completions.') return end

            fixer_count_cooldown = true
            STAT_SET_INCREMENT('FIXER_COUNT', 1)
            util.yield(10)
            menu.trigger_commands('go soloPublic')
            util.yield(7000)
            fixer_count_cooldown = false
        end)

    -----------------------------------
    -- Cooldowns
    -----------------------------------
        -- credit to people in Kiddions lua scripting mega thread and the gta structs and offsets thread on unknownC    heats for finding these cooldowns

        local first_open_cooldowns = {true}
        cooldown_root = menu.list(online_root, 'Cooldowns', {'JScooldowns'}, '', function()
            listWarning(cooldown_root, first_open_cooldowns)
        end)

        menu.toggle_loop(cooldown_root, 'Cayo cutter progress', {'JScayoCutter'}, 'This will reduce the time of the plasma cutter when collecting the primary target.', function()
            local pos = ENTITY.GET_ENTITY_COORDS(PLAYER.PLAYER_PED_ID(), true)
            local interior = INTERIOR.GET_INTERIOR_AT_COORDS(pos.x, pos.y, pos.z)
            if interior == 281601 then --the room behind the bars where the primary target is
                local cutterProgress = memory.script_local('fm_mission_controller_2020', 28269 + 3)
                local cutterProgress = memory.read_float(cutterProgress)
                if cutterProgress then
                    if cutterProgress > 0 and cutterProgress < 99.999 then
                        memory.write_float(cutterProgress, 99.999)
                        if notifications then util.toast('Skipped cutting') end
                    end
                end
            end
        end)

        local fixer_CD_root = menu.list(cooldown_root, 'Agency', {'JSagencyCooldowns'}, '')
        local terbyte_CD_root = menu.list(cooldown_root, 'Terrorbyte', {'JSterbyteCooldowns'}, '')
        local casino_CD_root = menu.list(cooldown_root, 'Casino', {'JScasinoCooldowns'}, '')
        local ceo_CD_root = menu.list(cooldown_root, 'CEO/VIP', {'JSCeoVipCooldowns'}, '')

        local cooldownActions = {
            --agency missions
            { root = fixer_CD_root, name = 'Payphone hits',      command = 'JSpayphoneCooldown', description = 'Use this before picking up the payphone.', global = 262145+31407 },
            { root = fixer_CD_root, name = 'Security contracts', command = 'JSsecurityCooldown', description = 'Use this after completing the job.',       global = 262145+31329 },
            --terrorbyte jobs
            { root = terbyte_CD_root, name = 'Between jobs',        command = 'JSterbyteBetweenCooldown', description = 'Use this after completing the job.', global = 262145+24390 },
            { root = terbyte_CD_root, name = 'Robbery in progress', command = 'JSterbyteRIPCooldown',     description = 'Use this before starting the job.',  global = 262145+24391 },
            { root = terbyte_CD_root, name = 'Data sweep',          command = 'JSterbyteDSCooldown',      description = 'Use this before starting the job.',  global = 262145+24392 },
            { root = terbyte_CD_root, name = 'Targeted data',       command = 'JSterbyteTDCooldown',      description = 'Use this before starting the job.',  global = 262145+24393 },
            { root = terbyte_CD_root, name = 'Diamond shopping',    command = 'JSterbyteDSCooldown',      description = 'Use this before starting the job.',  global = 262145+24394 },
            --casino work
            { root = casino_CD_root, name = 'Casino work', command = 'JScasinoWorkCooldown', description = 'Use this after completing the job.', global = 62145+26902 },
            --ceo work
            { root = ceo_CD_root, name = 'CEO/VIP work',   command = 'JSCeoVipWorkCooldown', description = 'Stand has this as a toggle, but that option doesn\'t work if you activate it when the cooldown has started, this does.', global = 262145+12870 },
            { root = ceo_CD_root, name = 'Headhunter',     command = 'JSheadhunterCooldown', description = 'Use this before starting the mission.', global = 262145+15275 },
            { root = ceo_CD_root, name = 'Sightseer',      command = 'JSsightseeCooldown',   description = 'Use this before starting the mission.', global = 262145+12767 },
            { root = ceo_CD_root, name = 'Asset recovery', command = 'JSarCooldown',         description = 'Use this before starting the mission.', global = 262145+12727 },
        }
        for i = 1, #cooldownActions do
            menu.action(cooldownActions[i].root, cooldownActions[i].name, {cooldownActions[i].command}, cooldownActions[i].description, function()
                SET_INT_GLOBAL(cooldownActions[i].global, 0)
            end)
        end

    ----------------------------------
    -- Casino
    ----------------------------------
        local casino_root = menu.list(online_root, 'Casino', {'JScasino'}, 'No theres no recoveries here.')

        local last_LW_seconds = 0
        menu.toggle_loop(casino_root, 'Lucky wheel cooldown', {'JSlwCool'}, 'Tells you if the lucky wheel is available or how much time is left until it is.', function()
            if STAT_GET_INT_MPPLY('mpply_lucky_wheel_usage') < util.current_unix_time_seconds() then util.toast('Lucky wheel is available.') return end
            local secondsLeft = STAT_GET_INT_MPPLY('mpply_lucky_wheel_usage') - util.current_unix_time_seconds()
            local hours = math.floor(secondsLeft / 3600)
            local minutes = math.floor((secondsLeft / 60) % 60)
            local seconds = secondsLeft % 60
            if last_LW_seconds ~= seconds then
                util.toast((hours < 10 and ('0' .. hours) or hours) .. ':' .. (minutes < 10 and ('0' .. minutes) or minutes) .. ':' .. (seconds < 10 and ('0' .. seconds) or seconds))
                last_LW_seconds = seconds
            end
        end)

        menu.action(casino_root, 'Casino loss/profit', {'JScasinoLP'}, 'Tells you how much you made or lost in the casino.', function()
            local chips = STAT_GET_INT_MPPLY('mpply_casino_chips_won_gd')
            if chips > 0 then
                util.toast('You\'ve made ' .. chips .. ' chips.')
            elseif chips < 0 then
                util.toast('You\'ve lost ' .. chips * -1 .. ' chips.')
            else
                util.toast('You haven\'t made or lost any chips.')
            end
        end)

    ----------------------------------
    -- Time trial
    ----------------------------------
        local tt_root = menu.list(online_root, 'Time trials', {'JStt'}, '', function()end)

        menu.toggle_loop(tt_root, 'Best rc time trial time', {'JSbestRcTT'}, '', function()
            util.toast('Best Time: ' .. ttTimeToString(STAT_GET_INT_MPPLY('mpply_rcttbesttime')))
            util.yield(100)
        end)

        function ttTimeToString(time)
            local min = math.floor(time / 60000)
            local sec = (time % 60000) / 1000
            return (min == 0 and '' or min .. 'min ') .. sec .. 's'
        end

        menu.toggle_loop(tt_root, 'Best time trial time', {'JSbestTT'}, '', function()
            util.toast('Best Time: ' .. ttTimeToString((STAT_GET_INT_MPPLY('mpply_timetrialbesttime'))))
            util.yield(100)
        end)

    ----------------------------------
    -- Block areas
    ----------------------------------
        local block_root = menu.list(online_root, 'Block areas', {'JSblock'}, 'Block areas in online with invisible walls, but if you over use it it will crash you lol.')

        local blockInProgress = false
        function blockAvailable(areaBlocked, areaName)
            if blockInProgress then util.toast('A block is already being run.') return false end
            if areaBlocked then util.toast(areaName..' already blocked.') return false end
            return true
        end

        function setBlockStatus(on, areaName)
            if on then
                blockInProgress = true
                startBusySpinner('Blocking')
                return
            end
            HUD.BUSYSPINNER_OFF()
            if notifications then util.toast('Successfully blocked '.. areaName ..'.') end
            blockInProgress = false
        end

        menu.toggle_loop(block_root, 'Custom block', {}, 'Makes you able to block an area in front of you by pressing "B".', function()
            local dir, c1 = direction()
            GRAPHICS._DRAW_SPHERE(c1.x, c1.y, c1.z, 0.3, 52, 144, 233, 0.5)
            if PAD.IS_CONTROL_JUST_PRESSED(2, 29) then
                if blockInProgress then util.toast('A block is already being run.') return end
                setBlockStatus(true)
                block({c1.x, c1.y, c1.z - 0.6})
                setBlockStatus(false, 'area')
            end
        end)

        local block_lsc_root = menu.list(block_root, 'Block LSC', {'JSblockLSC'}, 'Block lsc from being accessed.')
        local block_casino_root = menu.list(block_root, 'Block casino', {'JSblockCasino'}, 'Block casino from being accessed.')
        local block_maze_root = menu.list(block_root, 'Block maze bank', {'JSblockCasino'}, 'Block maze bank from being accessed.')

        local blockAreasActions = {
            --Orbital block
            {root = block_root, name = 'orbital room', coordinates = {{335.95837, 4834.216, -60.99977}}, blocked = false},
            -- Lsc blocks
            {root = block_lsc_root, name = 'burton', coordinates = {{-357.66544, -134.26419, 38.23775}}, blocked = false},
            {root = block_lsc_root, name = 'LSIA', coordinates = {{-1144.0569, -1989.5784, 12.9626}}, blocked = false},
            {root = block_lsc_root, name = 'la meza', coordinates = {{721.08496, -1088.8752, 22.046721}}, blocked = false},
            {root = block_lsc_root, name = 'blaine county', coordinates = {{115.59574, 6621.5693, 31.646144}, {110.460236, 6615.827, 31.660228}}, blocked = false},
            {root = block_lsc_root, name = 'paleto bay', coordinates = {{115.59574, 6621.5693, 31.646144}, {110.460236, 6615.827, 31.660228}}, blocked = false},
            {root = block_lsc_root, name = 'benny\'s', coordinates = {{-205.6571, -1309.4313, 31.093222}}, blocked = false},
            -- Casino blocks
            {root = block_casino_root, name = 'casino entrance', coordinates = {{923.7327, 47.40581, 81.10634}}, blocked = false},
            {root = block_casino_root, name = 'casino garage', coordinates = {{935.29553, -0.5328601, 78.56404}}, blocked = false},
            {root = block_casino_root, name = 'lucky wheel', coordinates = {{1110.1014, 228.71582, -49.935845}}, blocked = false},
            --Maze bank block
            {root = block_maze_root, name = 'maze bank entrance', coordinates = {{-81.18775, -795.82874, 44.227295}}, blocked = false},
            {root = block_maze_root, name = 'maze bank garage', coordinates = {{-81.538155, -783.13257, 38.43969}}, blocked = false},
            --Mc block
            {root = block_root, name = 'hawick clubhouse', coordinates = {{-17.48541, -195.7588, 52.370953}, {-23.452509, -193.01324, 52.36245}}, blocked = false},
            --Arena war garages
            {root = block_root, name = 'arena war garages', coordinates = {{-365.07288, -1872.5387, 20.32783}, {-377.01108, -1876.4001, 20.327832}, {-388.02557, -1882.2357, 20.327838}}, blocked = false},
        }

        for i = 1, #blockAreasActions do
            local areaName = blockAreasActions[i].name
            menu.action(blockAreasActions[i].root, 'Block '..areaName, {}, '', function ()
                if not blockAvailable(blockAreasActions[i].blocked, (areaName == 'LSIA' and areaName or string.capitalize(areaName))) then return end
                setBlockStatus(true)
                blockAreasActions[i].blocked = true
                for j = 1, #blockAreasActions[i].coordinates do
                    block(blockAreasActions[i].coordinates[j])
                end
                setBlockStatus(false, areaName)
            end)
        end

-----------------------------------
-- Players
-----------------------------------
    local players_root = menu.list(menu_root, 'Players', {'JSplayers'}, '')

    -----------------------------------
    -- Whitelist
    -----------------------------------
        local Whitelist_settings_root = menu.list(players_root, 'Whitelist', {'JSwhitelist'}, 'Applies to all options in this section.')

        menu.toggle(Whitelist_settings_root, 'Exclude self', {'JSWhitelistSelf'}, 'Will make you not explode yourself. Pretty cool option if you ask me ;P', function(toggle)
            whitelistGroups.user = not toggle
        end)

        menu.toggle(Whitelist_settings_root, 'Exclude friends', {'JSWhitelistFriends'}, 'Will make you not explode your friends... if you have any. (;-;)', function(toggle)
            whitelistGroups.friends = not toggle
        end)

        menu.toggle(Whitelist_settings_root, 'Exclude strangers', {'JSWhitelistStrangers'}, 'If you only want to explode your friends ig.', function(toggle)
            whitelistGroups.strangers = not toggle
        end)

        local whitelistedName = false
        menu.text_input(Whitelist_settings_root, 'Whitelist player', {'JSWhitelistPlayer'}, 'Lets you whitelist a single player by name.', function(name)
            whitelistedName = name
        end, '')

        local whitelist_list_root = menu.list(Whitelist_settings_root, 'Whitelist player list', {'JSwhitelistList'}, 'Custom player list for selecting  players you wanna whitelist.')

        local whitelistListTable = {}
        local whitelistTogglesTable = {}
        players.on_join(function(pid)
            local playerName = players.get_name(pid)
            whitelistTogglesTable[pid] = menu.toggle(whitelist_list_root, playerName, {'JSwhitelist' .. playerName}, 'Whitelist ' .. playerName .. ' from options that affect all players.', function(toggle)
                if toggle then
                    whitelistListTable[pid] = pid
                    if notifications then
                        util.toast('Whitelisted ' .. playerName)
                    end
                else
                    whitelistListTable[pid] = nil --removes the player from the whitelist
                end
            end)
        end)
        players.on_leave(function(pid)
            menu.delete(whitelistTogglesTable[pid])
            whitelistListTable[pid] = nil --removes the player from the whitelist
        end)

        menu.toggle_loop(players_root, 'No fly zone', {'JSnoFly'}, 'Forces all players in air born vehicles into the ground.', function()
            local playerList = getNonWhitelistedPlayers(whitelistListTable, whitelistGroups, whitelistedName)
            for i = 1, #playerList do
                local playerPed = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(playerList[i])
                local playerVehicle = PED.GET_VEHICLE_PED_IS_IN(playerPed, false)
                if ENTITY.IS_ENTITY_IN_AIR(playerVehicle) then
                    NETWORK.NETWORK_REQUEST_CONTROL_OF_ENTITY(playerVehicle)
                    ENTITY.APPLY_FORCE_TO_ENTITY(playerVehicle, 1, 0, 0, -0.8, 0, 0, 0.5, 0, false, false, true)
                    if notifications then
                        util.toast('Applied force')
                    end
                end
            end
        end)

    -----------------------------------
    -- Explosions
    -----------------------------------
        menu.action(players_root, 'Explode all', {'JSexplodeAll'}, 'Makes everyone explode.', function()
            local playerList = getNonWhitelistedPlayers(whitelistListTable, whitelistGroups, whitelistedName)
            for i = 1, #playerList do
                local playerPed = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(playerList[i])
                explodePlayer(playerPed, false, expSettings)
            end
        end)

        explodeLoopAll = menu.toggle_loop(players_root, 'Explode all loop', {'JSexplodeAllLoop'}, 'Constantly explodes everyone.', function()
            local playerList = getNonWhitelistedPlayers(whitelistListTable, whitelistGroups, whitelistedName)
            for i = 1, #playerList do
                local playerPed = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(playerList[i])
                explodePlayer(playerPed, true, expSettings)
            end
            util.yield(getTotalDelay(expLoopDelay))
        end)

    -----------------------------------
    -- Vehicle
    -----------------------------------
        local players_veh_root = menu.list(players_root, 'Vehicles', {'JSplayersVeh'}, 'Do stuff to all players vehicles.')

        menu.toggle(players_veh_root, 'Lock burnout', {'JSlockBurnout'}, 'Locks all player cars in burnout.', function(toggle)
            local playerList = getNonWhitelistedPlayers(whitelistListTable, whitelistGroups, whitelistedName)
            for k, playerPid in ipairs(playerList) do
                local playerPed = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(playerPid)
                if PED.IS_PED_IN_ANY_VEHICLE(playerPed, true) then
                    local playerVehicle = PED.GET_VEHICLE_PED_IS_IN(playerPed, false)
                    NETWORK.NETWORK_REQUEST_CONTROL_OF_ENTITY(playerVehicle)
                    VEHICLE.SET_VEHICLE_BURNOUT(playerVehicle, toggle)
                end
            end
        end)

        local all_torque = 1000
        menu.slider(players_veh_root, 'Set torque', {'JSsetAllTorque'}, 'Modifies the speed of all player vehicles.', -1000000, 1000000, all_torque, 1, function(value)
            all_torque = value
            util.create_tick_handler(function()
                local playerList = getNonWhitelistedPlayers(whitelistListTable, whitelistGroups, whitelistedName)
                for k, playerPid in ipairs(playerList) do
                    local playerPed = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(playerPid)
                    if PED.IS_PED_IN_ANY_VEHICLE(playerPed, true) then
                        local playerVehicle = PED.GET_VEHICLE_PED_IS_IN(playerPed, false)
                        NETWORK.NETWORK_REQUEST_CONTROL_OF_ENTITY(playerVehicle)
                        VEHICLE.SET_VEHICLE_CHEAT_POWER_INCREASE(playerVehicle, all_torque/1000)
                    end
                end
                return (all_torque ~= 1000)
            end)
        end)

        menu.toggle(players_root, 'Force surface all subs', {'JSforceSurfaceAll'}, 'Forces all Kosatkas to the surface.\nNot compatible with the whitelist.', function(toggle)
            local vehHandles = entities.get_all_vehicles_as_handles()
            local surfaced = 0
            for i = 1, #vehHandles do
                if ENTITY.GET_ENTITY_MODEL(vehHandles[i]) == 1336872304 then -- if Kosatka
                    VEHICLE.FORCE_SUBMARINE_SURFACE_MODE(vehHandles[i], toggle)
                    surfaced = surfaced + 1
                end
            end
            if toggle and notifications then util.toast('Surfaced '..surfaced..' subs') end
        end)
    -----------------------------------

    menu.toggle_loop(players_root, 'Shoot gods', {'JSshootGods'}, 'Disables godmode for other players when aiming at them. Mostly works on trash menus.', function()
        local playerList = getNonWhitelistedPlayers(whitelistListTable, whitelistGroups, whitelistedName)
        for k, playerPid in ipairs(playerList) do
            local playerPed = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(playerPid)
            if (PLAYER.IS_PLAYER_FREE_AIMING_AT_ENTITY(players.user(), playerPed) or PLAYER.IS_PLAYER_FREE_AIMING_AT_ENTITY(players.user(), playerPed)) and players.is_godmode(playerPid) then
                util.trigger_script_event(1 << playerPid, {801199324, playerPid, 869796886})
            end
        end
    end)

    -----------------------------------
    -- Aim karma
    -----------------------------------
        local aim_karma_root = menu.list(players_root, 'Aim karma', {'JSaimKarma'}, 'Do stuff to players that aim at you.')

        local karma = {}
        function playerIsTargetingEntity(playerPed)
            local playerList = getNonWhitelistedPlayers(whitelistListTable, whitelistGroups, whitelistedName)
            for k, playerPid in pairs(playerList) do
                if PLAYER.IS_PLAYER_TARGETTING_ENTITY(playerPid, playerPed) or PLAYER.IS_PLAYER_FREE_AIMING_AT_ENTITY  (playerPid, playerPed) then
                    karma[playerPed] = {
                        pid = playerPid,
                        ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(playerPid)
                    }
                    return true
                end
            end
            karma[playerPed] = nil
            return false
        end

        menu.toggle_loop(aim_karma_root, 'Shoot', {'JSbulletAimKarma'}, 'Shoots players that aim at you.', function()
            if playerIsTargetingEntity(PLAYER.PLAYER_PED_ID()) and karma[PLAYER.PLAYER_PED_ID()] then
                local pos = ENTITY.GET_ENTITY_COORDS(karma[PLAYER.PLAYER_PED_ID()].ped)
                MISC.SHOOT_SINGLE_BULLET_BETWEEN_COORDS(pos.x, pos.y, pos.z, pos.x, pos.y, pos.z +0.1, 100, true, 100416529, PLAYER.PLAYER_PED_ID(), true, false, 100.0)
                util.yield(getTotalDelay(expLoopDelay))
            end
        end)

        menu.toggle_loop(aim_karma_root, 'Explode', {'JSexpAimKarma'}, 'Explodes the player with your custom explosion settings.', function()
            if playerIsTargetingEntity(PLAYER.PLAYER_PED_ID()) and karma[PLAYER.PLAYER_PED_ID()] then
                explodePlayer(karma[PLAYER.PLAYER_PED_ID()].ped, true, expSettings)
            end
        end)

        menu.toggle_loop(aim_karma_root, 'Disable godmode', {'JSgodAimKarma'}, 'If a god mode player aims at you this disables their god mode by pushing their camera forwards.', function()
            if playerIsTargetingEntity(PLAYER.PLAYER_PED_ID()) and karma[PLAYER.PLAYER_PED_ID()] and players.is_godmode(karma[PLAYER.PLAYER_PED_ID()].pid) then
                local karmaPid = karma[PLAYER.PLAYER_PED_ID()].pid
                util.trigger_script_event(1 << karmaPid, {801199324, karmaPid, 869796886})
            end
        end)

        local stand_player_aim_punish =  menu.ref_by_path('World>Inhabitants>Player Aim Punishments>Anonymous Explosion', 34)
        menu.action(aim_karma_root, 'Stands player aim punishments', {}, 'Link to stands player aim punishments.', function()
            menu.focus(stand_player_aim_punish)
        end)

-----------------------------------
-- World
-----------------------------------
    local world_root = menu.list(menu_root, 'World', {'JSworld'}, '')

    local setClockCommand = menu.ref_by_path('World>Atmosphere>Clock>Time', 34)
    local smoothTransitionCommand = menu.ref_by_path('World>Atmosphere>Clock>Smooth Transition', 34)
    menu.toggle(world_root, 'irl time', {'JSirlTime'}, 'Makes the in game time match your irl time. Disables stands "Smooth Transition".', function(toggle)
        irlTime = toggle
        if menu.get_value(smoothTransitionCommand) == 1 then menu.trigger_command(smoothTransitionCommand) end
        util.create_tick_handler(function()
            menu.trigger_command(setClockCommand, os.date('%H:%M:%S'))
            return irlTime
        end)
    end)

    menu.toggle_loop(world_root, 'Disable all map notifications', {'JSnoMapNotifications'}, 'Removes that constant spam.', function()
        HUD.THEFEED_HIDE_THIS_FRAME()
    end)

    -----------------------------------
    -- Trains
    -----------------------------------
        local trains_root = menu.list(world_root, 'Trains', {'JStrains'}, '')

        local trainsStopped = false
        local function stopTrain(train)
            util.create_thread(function()
                while trainsStopped do
                    VEHICLE.SET_TRAIN_SPEED(train, -0.05)
                    util.yield()
                end
                VEHICLE.SET_RENDER_TRAIN_AS_DERAILED(train, false)
            end)
        end
        menu.toggle(trains_root, 'Derail trains', {'JSderail'}, 'Derails and stops all trains.', function(toggle)
            local vehHandles = entities.get_all_vehicles_as_handles()
            trainsStopped = toggle
            for i = 1, #vehHandles do
                if VEHICLE.GET_VEHICLE_CLASS(vehHandles[i]) == 21 then
                    NETWORK.NETWORK_REQUEST_CONTROL_OF_ENTITY(vehHandles[i])
                    VEHICLE.SET_RENDER_TRAIN_AS_DERAILED(vehHandles[i], true)
                    stopTrain(vehHandles[i])
                end
            end
        end)

        menu.action(trains_root, 'Delete trains', {'JSdeleteTrain'}, 'Just becurse every script has train options, I gotta have an anti train option.', function()
            VEHICLE.DELETE_ALL_TRAINS()
        end)

        local markedTrains = {}
        menu.toggle_loop(trains_root, 'Mark nearby trains', {'JSnoMapNotifications'}, 'Marks nearby trains with purple blips.', function()
            local vehHandles = entities.get_all_vehicles_as_handles()
            for i = 0, #vehHandles do
                if VEHICLE.GET_VEHICLE_CLASS(vehHandles[i]) == 21 then
                    for j = 0, #markedTrains do
                        if vehHandles[i] == markedTrains[j] then goto continue end
                    end
                    if notifications then
                        util.toast('Marked train')
                    end
                    table.insert(markedTrains, vehHandles[i])
                    local blip = HUD.ADD_BLIP_FOR_ENTITY(vehHandles[i])
                    HUD.SET_BLIP_COLOUR(blip, 58)
                end
                ::continue::
            end
            util.yield(100)
        end)

    -----------------------------------
    -- Peds
    -----------------------------------
        local peds_root = menu.list(world_root, 'Peds', {'JSpeds'}, '')

        local pedToggleLoops = {
            {name = 'Ragdoll peds', command = 'JSragdollPeds', description = 'Makes all nearby peds fall over lol.', action = function(ped)
                if PED.IS_PED_A_PLAYER(ped) then return end
                PED.SET_PED_TO_RAGDOLL(ped, 2000, 2000, 0, true, true, true)
                -- PED.RESET_PED_RAGDOLL_TIMER(ped)
            end},
            {name = 'Death\'s touch', command = 'JSdeathTouch', description = 'Kills peds that touches you.', action = function(ped)
                if PED.IS_PED_A_PLAYER(ped) or PED.IS_PED_IN_ANY_VEHICLE(ped, true) or not ENTITY.IS_ENTITY_TOUCHING_ENTITY(ped, PLAYER.PLAYER_PED_ID()) then return end
                ENTITY.SET_ENTITY_HEALTH(ped, 0, 0)
            end},
            {name = 'Cold peds', command = 'JScoldPeds', description = 'Removes the thermal signature from all peds.', action = function(ped)
                if PED.IS_PED_A_PLAYER(ped) then return end
                PED.SET_PED_HEATSCALE_OVERRIDE(ped, 0)
            end},
            {name = 'Mute peds', command = 'JSmutePeds', description = 'Because I don\'t want to hear that dude talk about his gay dog any more.', action = function(ped)
                if PED.IS_PED_A_PLAYER(ped) then return end
                AUDIO.STOP_PED_SPEAKING(ped, true)
            end},
            {name = 'Kill peds when steeling their car', command = 'JSkillJackedPeds', description = 'They always get so salty smh.', action = function(ped)
                if PED.IS_PED_A_PLAYER(ped) or not PED.IS_PED_BEING_JACKED(ped) then return end
                ENTITY.SET_ENTITY_HEALTH(ped, 0, 0)
            end, blockAction = function()
                return not PED.IS_PED_JACKING(PLAYER.PLAYER_PED_ID())
            end},
            {name = 'Npc horn boost', command = 'JSnpcHornBoost', description = 'Boosts npcs that horn.', action = function(ped)
                local vehicle = PED.GET_VEHICLE_PED_IS_IN(ped, false)
                if PED.IS_PED_A_PLAYER(ped) or not PED.IS_PED_IN_ANY_VEHICLE(ped, true) or not AUDIO.IS_HORN_ACTIVE(vehicle) then return end
                AUDIO.SET_AGGRESSIVE_HORNS(true) --Makes pedestrians sound their horn longer, faster and more agressive when they use their horn.
                VEHICLE.SET_VEHICLE_FORWARD_SPEED(vehicle, ENTITY.GET_ENTITY_SPEED(vehicle) + 1.2)
            end, onStop = function()
                AUDIO.SET_AGGRESSIVE_HORNS(false)
            end},

            {name = 'Npc siren boost', command = 'JSnpcSirenBoost', description = 'Boosts npcs cars with an active siren.', action = function(ped)
                local vehicle = PED.GET_VEHICLE_PED_IS_IN(ped, false)
                if PED.IS_PED_A_PLAYER(ped) or not PED.IS_PED_IN_ANY_VEHICLE(ped, true) or not VEHICLE.IS_VEHICLE_SIREN_ON(vehicle) then return end
                VEHICLE.SET_VEHICLE_FORWARD_SPEED(vehicle, ENTITY.GET_ENTITY_SPEED(vehicle) + 1.2)
            end},
            {name = 'Auto kill enemies', command = 'JSautokill', description = 'Just instantly kills hostile peds.', action = function(ped) --basically copy pasted form wiri script
                local rel = PED.GET_RELATIONSHIP_BETWEEN_PEDS(PLAYER.PLAYER_PED_ID(), ped)
                if PED.IS_PED_A_PLAYER(ped) or ENTITY.IS_ENTITY_DEAD(ped) or not( (rel == 4 or rel == 5) or PED.IS_PED_IN_COMBAT(ped, PLAYER.PLAYER_PED_ID()) ) then return end
                ENTITY.SET_ENTITY_HEALTH(ped, 0, 0)
            end},
        }
        for i = 1, #pedToggleLoops do
            menu.toggle_loop(peds_root, pedToggleLoops[i].name, {pedToggleLoops[i].command}, pedToggleLoops[i].description, function()
                if pedToggleLoops[i].blockAction and pedToggleLoops[i].blockAction() then return end --checks if blockAction is defined before calling it
                local pedHandles = entities.get_all_peds_as_handles()
                for j = 1, #pedHandles do
                    pedToggleLoops[i].action(pedHandles[j])
                end
                util.yield(10)
            end, function()
                if pedToggleLoops[i].onStop then pedToggleLoops[i].onStop() end
            end)
        end

        menu.toggle(peds_root, 'Riot mode', {'JSriot'}, 'Makes peds hostile.', function(toggle)
            MISC.SET_RIOT_MODE_ENABLED(toggle)
        end)

local playerInfoPid = nil
local playerInfoTogglesTable = {}
local runningTogglingOff = false
----------------------------------
-- Player options
----------------------------------
    players.on_join(function(pid)
        menu.divider(menu.player_root(pid), 'JerryScript') --added a divider here because Holy#9756 was bitching about it in vc
        local player_root = menu.list(menu.player_root(pid), 'JS player options')
        local playerPed = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
        local playerName = players.get_name(pid)

        ----------------------------------
        -- Player info toggle
        ----------------------------------
            playerInfoTogglesTable[pid] = menu.toggle(player_root, 'Player info', {'JSplayerInfo'}, 'Display information about ' .. playerName .. '.', function(toggle)
                if not runningTogglingOff then
                    if toggle then
                        runningTogglingOff = true
                        local playerList = players.list(true, true, true)
                        for i, playerPid in pairs(playerList) do
                            if menu.get_value(playerInfoTogglesTable[playerPid]) == 1 and not (playerInfoTogglesTable[playerPid] == playerInfoTogglesTable[pid]) then
                                menu.trigger_command(playerInfoTogglesTable[playerPid])
                            end
                        end
                        util.yield()
                        runningTogglingOff = false
                        playerInfoPid = pid   --hud starts when this is set
                    else
                        playerInfoPid = nil
                    end
                end
            end)
        ----------------------------------

        local explosive_ammo_components = {
            "0x3BE4465D",
            "0x89EBDAA7",
        }
        menu.toggle_loop(player_root, 'Auto remove explosive ammo', {'JSnoExpAmmo'}, 'Automatically removes explosive ammo from ' .. playerName .. '\'s guns.', function()
            local playerWeapon = WEAPON.GET_SELECTED_PED_WEAPON(playerPed)
            for i = 1, #explosive_ammo_components do
                if WEAPON.HAS_PED_GOT_WEAPON_COMPONENT(playerPed, playerWeapon, explosive_ammo_components[i]) then
                    WEAPON.REMOVE_WEAPON_COMPONENT_FROM_PED(playerPed, playerWeapon, explosive_ammo_components[i])
                    if notifications then
                        util.toast('Removed explosive ammo from ' .. playerName .. '\'s ' .. getWeaponName(playerWeapon))
                    end
                end
            end
        end)


        -----------------------------------
        -- Trolling
        -----------------------------------
            local trolling_root = menu.list(player_root, 'Trolling', {'JStrolling'}, '')

            menu.action(trolling_root, 'Explode player', {'JSexplode'}, 'Explodes '.. playerName ..' with your selected options.', function()
                explodePlayer(playerPed, false, expSettings)
            end)

            menu.toggle_loop(trolling_root, 'Explode player loop', {'JSexplodeLoop'}, 'Explode loops '.. playerName ..' with your selected options.', function()
                explodePlayer(playerPed, true, expSettings)
                util.yield(getTotalDelay(expLoopDelay))
            end)

            menu.action(trolling_root, 'Blame explosions', {'JSexpBlame'}, 'Makes your explosions blamed on '.. playerName ..'.', function()
                expSettings.blamedPlayer = pid
                if menu.get_value(exp_blame_toggle) == 0 then
                    menu.trigger_command(exp_blame_toggle)
                end
                menu.set_menu_name(exp_blame_toggle, "Blame: " .. playerName)
            end)

            menu.action(trolling_root, 'Primed grenade', {'JSprimedGrenade'}, 'Spawns a grenade on top of '.. playerName ..'.', function()
                local pos = ENTITY.GET_ENTITY_COORDS(playerPed)
                MISC.SHOOT_SINGLE_BULLET_BETWEEN_COORDS(pos.x, pos.y, pos.z + 1.4, pos.x, pos.y, pos.z + 1.3, 100, true, -1813897027, PLAYER.PLAYER_PED_ID(), true, false, 100.0)
            end)

            menu.action(trolling_root, 'Sticky', {'JSsticky'}, 'Spawns a sticky bomb on '.. playerName ..' that might stick to their vehicle and you can detonate by pressing "G".', function()
                local pos = ENTITY.GET_ENTITY_COORDS(playerPed)
                MISC.SHOOT_SINGLE_BULLET_BETWEEN_COORDS(pos.x, pos.y, pos.z + 1 , pos.x, pos.y, pos.z + 1.1, 10, true, 741814745, PLAYER.PLAYER_PED_ID(), true, false, 100.0)
            end)

            menu.toggle_loop(trolling_root, 'Shake camera', {'JScamShake'}, 'Shakes the camera of '.. playerName ..'.', function()
                local pos = ENTITY.GET_ENTITY_COORDS(playerPed)
                FIRE.ADD_EXPLOSION(pos.x, pos.y, pos.z, 1, 10, false, true, 1000, true)
            end)
        -----------------------------------

        menu.toggle_loop(player_root, 'Give shoot gods', {'JSgiveShootGods'}, 'Gives '.. playerName ..' the ability to disable players god mode when shooting them.', function()
            local playerList = getNonWhitelistedPlayers(whitelistListTable, whitelistGroups, whitelistedName)
            for k, playerPid in ipairs(playerList) do
                local playerPed = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(playerPid)
                if (PLAYER.IS_PLAYER_FREE_AIMING_AT_ENTITY(pid, playerPed) or PLAYER.IS_PLAYER_FREE_AIMING_AT_ENTITY(pid, playerPed)) and players.is_godmode(playerPid) then
                    util.trigger_script_event(1 << playerPid, {801199324, playerPid, 869796886})
                end
            end
        end)

        menu.toggle_loop(player_root, 'Give horn boost', {'JSgiveHornBoost'}, 'Gives '.. playerName ..' the ability to speed up their car by pressing honking their horn or activating the siren.', function()
            local vehicle = PED.GET_VEHICLE_PED_IS_IN(playerPed, false)
            if not (AUDIO.IS_HORN_ACTIVE(vehicle) or VEHICLE.IS_VEHICLE_SIREN_ON(vehicle)) then return end
            VEHICLE.SET_VEHICLE_FORWARD_SPEED(vehicle, ENTITY.GET_ENTITY_SPEED(vehicle) + hornBoostMultiplier)
        end)

        -----------------------------------
        -- Give aim karma
        -----------------------------------
            local give_karma_root = menu.list(player_root, 'Give aim karma', {'JSgiveAimKarma'}, 'Allows you to to stuff to players who target '.. playerName ..'.')

            menu.toggle_loop(give_karma_root, 'Shoot', {'JSgiveBulletAimKarma'}, 'Shoots players that aim at '.. playerName ..'.', function()
                if playerIsTargetingEntity(playerPed) and karma[playerPed] then
                    local pos = ENTITY.GET_ENTITY_COORDS(karma[playerPed].ped)
                    MISC.SHOOT_SINGLE_BULLET_BETWEEN_COORDS(pos.x, pos.y, pos.z, pos.x, pos.y, pos.z +0.1, 100, true, 100416529, PLAYER.PLAYER_PED_ID(), true, false, 100.0)
                    util.yield(getTotalDelay(expLoopDelay))
                end
            end)

            menu.toggle_loop(give_karma_root, 'Explode', {'JSgiveExpAimKarma'}, 'Explosions with your custom explosion settings.', function()
                if playerIsTargetingEntity(playerPed) and karma[playerPed] then
                    explodePlayer(karma[playerPed].ped, true, expSettings)
                end
            end)

            menu.toggle_loop(give_karma_root, 'Disable godmode', {'JSgiveGodAimKarma'}, 'If a god mode player aims at '.. playerName ..' this disables the aimers god mode by pushing their camera forwards.', function()
                if playerIsTargetingEntity(playerPed) and karma[playerPed] and players.is_godmode(karma[playerPed].pid) then
                    util.trigger_script_event(1 << karma[playerPed].pid, {801199324, karma[playerPed].pid, 869796886})
                end
            end)

        ----------------------------------
        -- Vehicle
        ----------------------------------
            local player_veh_root = menu.list(player_root, "Vehicle")

            menu.toggle(player_veh_root, 'Lock burnout', {'JSlockBurnout'}, 'Locks '.. playerName ..'\'s car in burnout.', function(toggle)
                if PED.IS_PED_IN_ANY_VEHICLE(playerPed, true) then
                    local playerVehicle = PED.GET_VEHICLE_PED_IS_IN(playerPed, false)
                    NETWORK.NETWORK_REQUEST_CONTROL_OF_ENTITY(playerVehicle)
                    VEHICLE.SET_VEHICLE_BURNOUT(playerVehicle, toggle)
                end
            end)

            local player_torque = 1000
            menu.slider(player_veh_root, 'Set torque', {'JSsetTorque'}, 'Modifies the speed of '.. playerName ..'\'s vehicle.', -1000000, 1000000, player_torque, 1, function(value)
                player_torque = value
                util.create_tick_handler(function()
                    if PED.IS_PED_IN_ANY_VEHICLE(playerPed, true) then
                        local playerVehicle = PED.GET_VEHICLE_PED_IS_IN(playerPed, false)
                        NETWORK.NETWORK_REQUEST_CONTROL_OF_ENTITY(playerVehicle)
                        VEHICLE.SET_VEHICLE_CHEAT_POWER_INCREASE(playerVehicle, player_torque/1000)
                    end
                    return (player_torque ~= 1000)
                end)
            end)

            menu.toggle(player_veh_root, 'Force sub surface', {'JSforceSurface'}, 'Forces '.. playerName ..'\'s submarine to the surface if they\'re driving it.', function(toggle)
                local vehicle = PED.GET_VEHICLE_PED_IS_IN(playerPed, false)
                if PED.IS_PED_IN_ANY_VEHICLE(playerPed, true) and ENTITY.GET_ENTITY_MODEL(vehicle) == 1336872304 then
                    VEHICLE.FORCE_SUBMARINE_SURFACE_MODE(vehicle, toggle)
                    if toggle and notifications then
                        util.toast('Forcing '.. playerName ..'\'s sub to surface')
                    end
                end
            end)

            menu.toggle_loop(player_veh_root, 'To the moon', {'JStoMoon'}, 'Forces '.. playerName ..' info the sky if they\'re in a vehicle.', function()
                if PED.IS_PED_IN_ANY_VEHICLE(playerPed, true) then
                    local playerVehicle = PED.GET_VEHICLE_PED_IS_IN(playerPed, false)
                    NETWORK.NETWORK_REQUEST_CONTROL_OF_ENTITY(playerVehicle)
                    ENTITY.APPLY_FORCE_TO_ENTITY(playerVehicle, 1, 0, 0, 100, 0, 0, 0.5, 0, false, false, true)
                    util.yield(10)
                end
            end)

            menu.toggle_loop(player_veh_root, 'Anchor', {'JSanchor'}, 'Forces '.. playerName ..' info the ground if they\'re in a air born vehicle.', function()
                if PED.IS_PED_IN_ANY_VEHICLE(playerPed, true) then
                    local playerVehicle = PED.GET_VEHICLE_PED_IS_IN(playerPed, false)
                    if ENTITY.IS_ENTITY_IN_AIR(playerVehicle) then
                        NETWORK.NETWORK_REQUEST_CONTROL_OF_ENTITY(playerVehicle)
                        ENTITY.APPLY_FORCE_TO_ENTITY(playerVehicle, 1, 0, 0, -100, 0, 0, 0, 0, false, false, true)
                        util.yield(10)
                    end
                end
            end)

        -----------------------------------
        -- Entity rain
        -----------------------------------
            local rain_root = menu.list(player_root, 'Entity rain', {'JSrain'}, '')

            local function rain(playerPed, entity)
                local pos = ENTITY.GET_ENTITY_COORDS(playerPed)
                local hash = util.joaat(entity)
                pos.x = pos.x + math.random(-30,30)
                pos.y = pos.y + math.random(-30,30)
                pos.z = pos.z + 30
                STREAMING.REQUEST_MODEL(hash)
                yieldModelLoad(hash)
                local animal = entities.create_ped(28, hash, pos, 0)
                STREAMING.SET_MODEL_AS_NO_LONGER_NEEDED(hash)
                -- ENTITY.SET_ENTITY_INVINCIBLE(animal, true)
            end

            local rainOptions = {
                { name = 'Meow',    description = 'UWU',                                          animals = {'a_c_cat_01'}                                 },
                { name = 'Sea',     description = '<º)))><',                                      animals = {'a_c_fish', 'a_c_dolphin', 'a_c_killerwhale'} },
                { name = 'Dog',     description = 'Wooof',                                        animals = {'a_c_retriever', 'a_c_pug', 'a_c_rottweiler'} },
                { name = 'Chicken', description = '*clucking*',                                   animals = {'a_c_hen'}                                    },
                { name = 'Monkey',  description = 'Idk what sound a monkey does',                 animals = {'a_c_chimp'}                                  },
                { name = 'Pig',     description = '(> (00) <)',                                   animals = {'a_c_pig'}                                    },
                { name = 'Rat',     description = 'Puts a Remote access trojan in your pc. (JK)', animals = {'a_c_rat'}                                    }
            }
            for i = 1, #rainOptions do
                menu.toggle_loop(rain_root, rainOptions[i].name ..' rain', {'JS'..rainOptions[i].name}, rainOptions[i].description, function()
                    for k, v in pairs(rainOptions[i].animals) do
                        rain(playerPed, v)
                        util.yield(500)
                    end
                end)
            end

            menu.action(rain_root, 'Clear rain', {'JSclear'}, 'Deletes rained entities.', function()
                local pedPointers = entities.get_all_peds_as_pointers()
                for i = 1, #pedPointers do
                    if not PED.IS_PED_A_PLAYER(entities.pointer_to_handle(pedPointers[i])) then
                        entities.delete_by_pointer(pedPointers[i])
                    end
                end
            end)
        -----------------------------------
    end)
    players.on_leave(function(pid)
        playerInfoTogglesTable[pid] = nil
        if pid == playerInfoPid then
            playerInfoPid = nil
        end
    end)
players.dispatch_on_join()

-----------------------------------
-- Script tick loop
-----------------------------------
util.create_tick_handler(function()
    -- car stuff
    if TASK.GET_IS_TASK_ACTIVE(PLAYER.PLAYER_PED_ID(), 2) then --when exiting a car
        setCarOptions(false)
    end
    local carCheck = entities.get_user_vehicle_as_handle()
    if my_cur_car ~= carCheck then
        my_cur_car = carCheck
        setCarOptions(true)
    end

    -- Player info hud
    if playerInfoPid then
        local ct = 0
        local spacing = 0.015 + piSettings.scale * piSettings.scale / 50
        local playerInfoPed = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(playerInfoPid)
        local weaponHash = getWeaponHash(playerInfoPed)
        for i = 1, #playerInfoTogglesOptions do
            local text = playerInfoTogglesOptions[i].displayText(playerInfoPid, playerInfoPed, weaponHash) --not all the functions uses all params but i don't wanna check what params i need to pass
            if playerInfoTogglesOptions[i].toggle and text then
                ct = ct + spacing
                directx.draw_text(1 + sliderToScreenPos(piSettings.xOffset), ct + sliderToScreenPos(piSettings.yOffset), text, piSettings.alignment, piSettings.scale, piSettings.textColor, false)
            end
        end
    end

    -- Safe monitor
    if toggleSafeMonitor then
        local ct = 0
        local spacing = 0.015 + smSettings.scale * smSettings.scale / 50
        for i = 1, #safeManagerToggles do
            if safeManagerToggles[i].toggle then
                ct = ct + spacing
                directx.draw_text(1 + sliderToScreenPos(smSettings.xOffset), ct + sliderToScreenPos(smSettings.yOffset), safeManagerToggles[i].displayText(), smSettings.alignment, smSettings.scale, smSettings.textColor, false)
            end
        end
    end
end)
