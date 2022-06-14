--[[coded by Jerry123#4508

    skids from:
    LanceScript by lance#8213
    WiriScript by Nowiry#2663
    KeramisScript by scriptCat#6566
    Heist control by IceDoomfist#0001
    LAZScript

    thx to Sai, ren, aaron, Nowry, JayMontana, IceDoomfist and scriptCat and everyone else that helped me in #programming :)
]]

JSlang = require 'JSlangLib'
require 'JSfuncsNtables'
local JSkey = require 'JSkeyLib'

local scaleForm = require("ScaleformLib")
local SF = scaleForm("instructional_buttons")

local script_store_dir = filesystem.store_dir() .. 'JerryScript\\'
if not filesystem.is_dir(script_store_dir) then
    filesystem.mkdirs(script_store_dir)
end

local face_profiles_dir = script_store_dir .. 'Face Feature Profiles\\'
if not filesystem.is_dir(face_profiles_dir) then
    filesystem.mkdirs(face_profiles_dir)
end

local lang_dir = script_store_dir .. 'Language\\'
if not filesystem.is_dir(lang_dir) then
    filesystem.mkdirs(lang_dir)
end


local menu_root = menu.my_root()

local whitelistGroups = {user = true, friends = true, strangers  = true}
local whitelistListTable = {}
local whitelistedName = false
----------------------------------
-- Settings
----------------------------------
    local settings_root = JSlang.list(menu_root, 'Settings', {}, '')

    ----------------------------------
    -- Script settings
    ----------------------------------
        local script_settings_root = JSlang.list(settings_root, 'Script settings', {'JSsettings'}, '')

        notifications = true
        JSlang.toggle(script_settings_root, 'Disable JS notifications', {'JSnoNotify'}, 'Makes the script not notify when stuff happens. These can be pretty useful so I don\'t recommend turning them off.', function(toggle)
            notifications = not toggle
            if not toggle then
                JSlang.toast('Notifications on')
            end
        end)

        local maxTimeBetweenPress = 300
        JSlang.slider(script_settings_root, 'Double tap interval', {'JSdoubleTapInterval'}, 'Lets you set the maximum time between double taps in ms.', 1, 1000, 300, 1, function(value)
            maxTimeBetweenPress = value
        end)

        JSlang.action(script_settings_root, 'Create translation template', {'JStranslationTemplate'}, 'Creates a template file for translation in store/JerryScript/Language.', function()
            async_http.init('raw.githubusercontent.com', '/Jerrrry123/JerryScript/'.. getLatestRelease() ..'/store/JerryScript/Language/template.lua', function(fileContent)
                local i = ''
                if filesystem.exists(lang_dir .. 'template.lua') then
                    i = 1
                    while filesystem.exists(lang_dir .. 'template'.. i ..'.lua') do
                        i += 1
                    end
                end

                local file = io.open(lang_dir .. 'template'.. i ..'.lua', 'w')
                file:write(fileContent)
                file:close()

                local message = 'Successfully created file.'
                if type(i) == 'number' and i >= 100 then
                    message = 'Stop creating template files, you have way too many!'
                end
                JSlang.toast(message)
            end, function()
                JSlang.toast('Failed to create file.')
            end)
            async_http.dispatch()
        end)

    ----------------------------------
    -- Player info settings
    ----------------------------------
        local pi_settings_root = JSlang.list(settings_root, 'Player info settings', {'JSplayerInfoSettings'}, '')

        local piSettings = new.hudSettings(-151, 1, 3)
        generateHudSettings(pi_settings_root, 'PI', piSettings)

        ----------------------------------
        -- Player info toggles
        ----------------------------------
            local pi_display_options_root = JSlang.list(pi_settings_root, 'Display options', {'PIDisplay'}, '')

            local playerInfoTogglesOptions = {
                {
                    name = 'Disable name', command = 'PIdisableName', description = '', toggle = true,
                    displayText = function(pid)
                        return JSlang.str_trans('Player') ..': '.. players.get_name(pid)
                    end
                },
                {
                    name = 'Disable weapon', command = 'PIdisableWeapon', description = '', toggle = true,
                    displayText = function(pid, ped, weaponHash)
                        local weaponName = getWeaponName(weaponHash)
                        return weaponName and JSlang.str_trans('Weapon') ..': '.. weaponName
                    end
                },
                {
                    name = 'Disable ammo info', command = 'PIdisableAmmo', description = '', toggle = true,
                    displayText = function(pid, ped, weaponHash)
                        local damageType = WEAPON.GET_WEAPON_DAMAGE_TYPE(weaponHash)
                        if not (damageType == 12 or damageType == 1 or damageType == 3 or damageType == 5 or damageType == 13) or util.joaat('weapon_raypistol') == weaponHash then return end
                        local ammoCount
                        local ammo_ptr = memory.alloc_int()
                        if WEAPON.GET_AMMO_IN_CLIP(ped, weaponHash, ammo_ptr) and WEAPON.GET_WEAPONTYPE_GROUP(weaponHash) != util.joaat('GROUP_THROWN') then
                            ammoCount = memory.read_int(ammo_ptr)
                            local clipSize = WEAPON.GET_MAX_AMMO_IN_CLIP(ped, weaponHash, 1)
                            return ammoCount and JSlang.str_trans('Clip') ..': '.. ammoCount ..' / '.. clipSize
                        end
                    end
                },
                {
                    name = 'Disable damage type', command = 'PIdisableDamage', description = 'Displays the type of damage the players weapon does, like melee / fire / bullets / mk2 ammo.', toggle = true,
                    displayText = function(pid, ped, weaponHash)
                        local damageType = getDamageType(ped, weaponHash)
                        return damageType and JSlang.str_trans('Damage type') ..': '.. damageType
                    end
                },
                {
                    name = 'Disable vehicle', command = 'PIdisableVehicle', description = '', toggle = true,
                    displayText = function(pid, ped)
                        local vehicleName = getPlayerVehicleName(ped)
                        return vehicleName and JSlang.str_trans('Vehicle') ..': '.. vehicleName
                    end
                },
                {
                    name = 'Disable score', command = 'PIdisableScore', description = 'Only shows when you or they have kills.', toggle = true,
                    displayText = function(pid)
                        local myScore = GET_INT_GLOBAL(2863967 + 386 + 1 + pid)
                        local theirScore = GET_INT_GLOBAL(2863967 + 353 + 1 + pid)
                        return (myScore > 0 or theirScore > 0) and (myScore ..' '.. JSlang.str_trans('Vs') ..' '.. theirScore) --only returns score if either part has kills
                    end
                },
                {
                    name = 'Disable moving indicator', command = 'PIdisableMovement', description = '', toggle = true,
                    displayText = function(pid, ped)
                        local movement = getMovementType(ped)
                        return movement and JSlang.str_trans('Player is') ..' '.. JSlang.str_trans(movement)
                    end
                },
                {
                    name = 'Disable aiming indicator', command = 'PIdisableAiming', description = '', toggle = true,
                    displayText = function(pid)
                        return PLAYER.IS_PLAYER_TARGETTING_ENTITY(pid, players.user_ped()) and JSlang.str_trans('Player is aiming at you')
                    end
                },
                {
                    name = 'Disable reload indicator', command = 'PIdisableReload', description = '', toggle = true,
                    displayText = function(pid, ped)
                        return PED.IS_PED_RELOADING(ped) and JSlang.str_trans('Player is reloading')
                    end
                },
            }
            generateToggles(playerInfoTogglesOptions, pi_display_options_root, true)

    -----------------------------------
    -- Safe monitor settings
    -----------------------------------
        local sm_settings_root = JSlang.list(settings_root, 'Safe monitor settings', {'SMsettings'}, 'Settings for the on screen text')

        smSettings = new.hudSettings(-3, 0, 2)
        generateHudSettings(sm_settings_root, 'SM', smSettings)

    -----------------------------------
    -- Explosion settings
    -----------------------------------
        local epx_settings_root = JSlang.list(settings_root, 'Explosion settings', {'JSexpSettings'}, 'Settings for the different options that explode players in this script.')

        local expLoopDelay = new.delay(250, 0, 0)

        local loop_delay_root = menu.list(epx_settings_root, JSlang.str_trans('Loop delay') ..': '.. getDelayDisplayValue(expLoopDelay), {'JSexpDelay'}, JSlang.str_trans('Lets you set a custom delay between looped explosions.'))

        generateDelaySettings(loop_delay_root, JSlang.str_trans('Loop delay'), expLoopDelay)

        -----------------------------------
        -- Fx explosion settings
        -----------------------------------
            local expSettings = {
                camShake = 0, invisible = false, audible = true, noDamage = false, owned = false, blamed = false, blamedPlayer = false, expType = 0,
                --stuff for fx explosions
                currentFx = effects['Clown_Explosion'],
                colour = new.colour(1, 0, 1)
            }

            local exp_fx_root = JSlang.list(epx_settings_root, 'FX explosions', {'JSfxExp'}, 'Lets you choose effects instead of explosion type.')
            local exp_fx_type_root

            local exp_type_root exp_type_root = menu.list_action(epx_settings_root, JSlang.str_trans('Explosion type') ..': Grenade', {}, '', {
                ----------------------------------------------
                {'Grenade'},
                {'Grenadelauncher'},
                {'Stickybomb'},
                {'Molotov'},
                {'Rocket'},
                {'Tankshell'},
                {'Hi octane'},
                {'Car'},
                {'Plan'},
                {'Petrol pump'},
                {'Bike'},
                {'Dir steam'},
                {'Dir flame'},
                {'Water hydran'},
                {'Dir gas canister'},
                {'Boat'},
                {'Ship destroy'},
                {'Truck'},
                {'Bullet'},
                {'Smokegrenadelauncher'},
                {'Smokegrenade'},
                {'Bzgas'},
                {'Flare'},
                {'Gas canister'},
                {'Extinguisher'},
                {'Programmablear'},
                {'Train'},
                {'Barrel'},
                {'Propane'},
                {'Blimp'},
                {'Dir flame explode'},
                {'Tanker'},
                {'Plane rocket'},
                {'Vehicle bullet'},
                {'Gas tank'},
                {'Bird crap'},
                {'Railgun'},
                {'Blimp2'},
                {'Firework'},
                {'Snowball'},
                {'Proxmine'},
                {'Valkyrie cannon'},
                {'Air defence'},
                {'Pipebomb'},
                {'Vehiclemine'},
                {'Explosiveammo'},
                {'Apcshell'},
                {'Bomb cluster'},
                {'Bomb gas'},
                {'Bomb incendiary'},
                {'Bomb standard'},
                {'Torpedo'},
                {'Torpedo underwater'},
                {'Bombushka cannon'},
                {'Bomb cluster secondary'},
                {'Hunter barrage'},
                {'Hunter cannon'},
                {'Rogue cannon'},
                {'Mine underwater'},
                {'Orbital cannon'},
                {'Bomb standard wide'},
                {'Explosiveammo shotgun'},
                {'Oppressor2 cannon'},
                {'Mortar kinetic'},
                {'Vehiclemine kinetic'},
                {'Vehiclemine emp'},
                {'Vehiclemine spike'},
                {'Vehiclemine slick'},
                {'Vehiclemine tar'},
                {'Script drone'},
                {'Up-n-atomizer'},
                {'Buriedmine'},
                {'Script missile'},
                {'Rctank rocket'},
                {'Bomb water'},
                {'Bomb water secondary'},
                {'Unknown1'},
                {'Unknown2'},
                {'Flashgrenade'},
                {'Stungrenade'},
                {'Unknown3'},
                {'Script missile large'},
                {'Submarine big'},
                {'Emplauncher emp'},
            }, function(index, text)
                if expSettings.currentFx then expSettings.currentFx = nil end
                menu.set_menu_name(exp_type_root, JSlang.str_trans('Explosion type') ..': '.. text)
                menu.set_menu_name(exp_fx_type_root, JSlang.str_trans('FX type') ..': '.. JSlang.str_trans('none'))
                expSettings.expType = index - 1
            end)

            local function getEffectLabelTableFromKeys(keyTable)
                local labelTable = {}
                for k, v in pairsByKeys(keyTable) do
                    local helpText = ''
                    if keyTable[k].colour and not effects[k].exp then
                        helpText = helpText .. JSlang.str_trans('Colour can be changed.')..'\n'.. JSlang.str_trans('Can\'t be silenced.')
                    elseif keyTable[k].colour then
                        helpText = helpText ..JSlang.str_trans('Colour can be changed.')
                    elseif not keyTable[k].exp then
                        helpText = helpText ..JSlang.str_trans('Can\'t be silenced.')
                    end
                    table.insert(labelTable, {k, {}, helpText})
                end
                return labelTable
            end
            exp_fx_type_root = menu.list_action(exp_fx_root, JSlang.str_trans('FX type') ..': '.. JSlang.str_trans('none'), {'JSfxExpType'}, JSlang.str_trans('Choose a fx explosion type.'), getEffectLabelTableFromKeys(effects), function(index, name)
                expSettings.currentFx = effects[name]
                menu.set_menu_name(exp_type_root, JSlang.str_trans('Explosion type') ..': '.. JSlang.str_trans('Fx active'))
                menu.set_menu_name(exp_fx_type_root, JSlang.str_trans('FX type') ..': '.. name)
            end)


            menu.rainbow(JSlang.colour(exp_fx_root, 'FX colour', {'JSPfxColour'}, 'Only works on some pfx\'s.',  new.colour(1, 0, 1, 1), false, function(colour)
                expSettings.colour = colour
            end))
        -----------------------------------

        JSlang.slider(epx_settings_root, 'Camera shake', {'JSexpCamShake'}, 'How much explosions shake the camera.', 0, 1000, expSettings.camShake, 1, function(value)
            expSettings.camShake = value
        end)

        JSlang.toggle(epx_settings_root, 'Invisible explosions', {'JSexpInvis'}, '', function(toggle)
            expSettings.invisible = toggle
        end)

        JSlang.toggle(epx_settings_root, 'Silent explosions', {'JSexpSilent'}, '', function(toggle)
            expSettings.audible = not toggle
        end)

        JSlang.toggle(epx_settings_root, 'Disable explosion damage', {'JSnoExpDamage'}, '', function(toggle)
            expSettings.noDamage = toggle
        end)

        local blame_settings_root = JSlang.list(epx_settings_root, 'Blame settings', {'JSblameSettings'}, 'Lets you blame yourself or other players for your explosions, go to the player list to chose a specific player to blame.')

        local runningToggling = false
        local function mutuallyExclusiveToggles(toggle)
            if menu.get_value(toggle) then
                runningToggling = true
                menu.trigger_command(toggle)
                util.yield()
                runningToggling = false
            end
        end

        local exp_blame_toggle
        local exp_own_toggle = JSlang.toggle(blame_settings_root, 'Owned explosions', {'JSownExp'}, 'Will overwrite "Disable explosion damage".', function(toggle)
            expSettings.owned = toggle
            if not runningToggling then
                mutuallyExclusiveToggles(exp_blame_toggle)
            end
        end)

        exp_blame_toggle = menu.toggle(blame_settings_root, JSlang.str_trans('Blame') ..': '.. JSlang.str_trans('Random'), {'JSblameExp'}, JSlang.str_trans('Will overwrite "Disable explosion damage" and if you haven\'t chosen a player random players will be blamed for each explosion.'), function(toggle)
            expSettings.blamed = toggle
            if not runningToggling then
                mutuallyExclusiveToggles(exp_own_toggle)
            end
        end)

        local blame_list_root = JSlang.list(blame_settings_root, 'Blame player list', {'JSblameList'}, 'Custom player list for selecting blames.')

        local blamesTogglesTable = {}
        players.on_join(function(pid)
            local playerName = players.get_name(pid)
            blamesTogglesTable[pid] = menu.action(blame_list_root, playerName, {'JSblame'.. playerName}, JSlang.str_trans('Blames your explosions on them.'), function()
                expSettings.blamedPlayer = pid
                if not menu.get_value(exp_blame_toggle) then
                    menu.trigger_command(exp_blame_toggle)
                end
                menu.set_menu_name(exp_blame_toggle, JSlang.str_trans('Blame') ..': '.. playerName)
                menu.focus(blame_list_root)
            end)
        end)
        players.on_leave(function(pid)
            menu.delete(blamesTogglesTable[pid])
            if expSettings.blamedPlayer == pid then
                local playerList = players.list(true, true, true)
                for _, pid in pairs(playerList) do
                    menu.trigger_commands('JSexplodeLoop'.. players.get_name(pid) ..' off')
                end
                menu.trigger_command(explodeLoopAll, 'off')
                expSettings.blamedPlayer = false
                menu.set_menu_name(exp_blame_toggle, JSlang.str_trans('Blame') ..': '.. JSlang.str_trans('Random'))
                if notifications then
                    JSlang.toast('Explosions stopped because the player you\'re blaming left.')
                end
            end
        end)

        JSlang.action(blame_settings_root, 'Random blames', {'JSblameRandomExp'}, 'Switches blamed explosions back to random if you already chose a player to blame.', function()
            expSettings.blamedPlayer = false
            if not menu.get_value(exp_blame_toggle) then
                menu.trigger_command(exp_blame_toggle)
            end
            menu.set_menu_name(exp_blame_toggle, JSlang.str_trans('Blame') ..': '.. JSlang.str_trans('Random'))
        end)

        local hornBoostMultiplier = 1.000
        JSlang.slider(settings_root, 'Horn boost multiplier', {'JShornBoostMultiplier'}, 'Set the force applied to the car when you or another player uses horn boost.', -100000, 100000, hornBoostMultiplier * 1000, 1, function(value)
            hornBoostMultiplier = value / 1000
        end)

-----------------------------------
-- Self
-----------------------------------
    local self_root = JSlang.list(menu_root, 'Self', {'JSself'}, '')

    local function getOffsetFromCam(dist)
        local pos = CAM.GET_FINAL_RENDERED_CAM_COORD()
        local dir = v3.toDir(CAM.GET_FINAL_RENDERED_CAM_ROT(2))
        local offset = {
            x = pos.x + dir.x * dist,
            y = pos.y + dir.y * dist,
            z = pos.z + dir.z * dist
        }
        return offset
    end

    local startViewMode
    local scope_scaleform
    local gaveHelmet = false
    local levitationCommand = menu.ref_by_path('Self>Movement>Levitation>Levitation', 36)
    JSlang.toggle_loop(self_root, 'Ironman mode', {'JSironman'}, 'Grants you the abilities of ironman :)', function()
        if not menu.get_value(levitationCommand) then
            menu.trigger_command(levitationCommand)
        end
        if not PED.IS_PED_WEARING_HELMET(players.user_ped()) then
            PED.GIVE_PED_HELMET(players.user_ped(), true, 4096, -1)
            gaveHelmet = true
        end

        local context = CAM._GET_CAM_ACTIVE_VIEW_MODE_CONTEXT()
        if startViewMode == nil then
            startViewMode = CAM.GET_CAM_VIEW_MODE_FOR_CONTEXT(context)
        end
        if CAM.GET_CAM_VIEW_MODE_FOR_CONTEXT(context) != 4 then
            CAM.SET_CAM_VIEW_MODE_FOR_CONTEXT(context, 4)
        end

        scope_scaleform = GRAPHICS.REQUEST_SCALEFORM_MOVIE('REMOTE_SNIPER_HUD')
        GRAPHICS.BEGIN_SCALEFORM_MOVIE_METHOD(scope_scaleform, 'REMOTE_SNIPER_HUD')
        GRAPHICS.DRAW_SCALEFORM_MOVIE_FULLSCREEN(scope_scaleform, 255, 255, 255, 255, 0)
        GRAPHICS.END_SCALEFORM_MOVIE_METHOD()

        memory.write_int(memory.script_global(1645739+1121), 1)
        SF.CLEAR_ALL()
        SF.TOGGLE_MOUSE_BUTTONS(false)
        SF.SET_DATA_SLOT(2, JSkey.get_control_instructional_button(0, 'INPUT_ATTACK'), JSlang.str_trans('Explode'))
        SF.SET_DATA_SLOT(1, JSkey.get_control_instructional_button(0, 'INPUT_AIM'), JSlang.str_trans('Beam'))
        SF.SET_DATA_SLOT(0, JSkey.get_control_instructional_button(0, 'INPUT_PICKUP'), JSlang.str_trans('Barrage'))
        SF.DRAW_INSTRUCTIONAL_BUTTONS()

        PLAYER.DISABLE_PLAYER_FIRING(PLAYER.PLAYER_PED_ID(), true)

        JSkey.disable_control_action(2, 'INPUT_VEH_MOUSE_CONTROL_OVERRIDE')
        JSkey.disable_control_action(2, 'INPUT_VEH_FLY_MOUSE_CONTROL_OVERRIDE')
        JSkey.disable_control_action(2, 'INPUT_VEH_SUB_MOUSE_CONTROL_OVERRIDE')

        if not (JSkey.is_key_down('VK_LBUTTON') or JSkey.is_key_down('VK_RBUTTON') or JSkey.is_key_down('VK_E')) then return end

        local a = ENTITY.GET_ENTITY_COORDS(PLAYER.PLAYER_PED_ID())
        local b = getOffsetFromCam(80)

        local hash
        if JSkey.is_key_down('VK_LBUTTON') then
            hash = util.joaat('VEHICLE_WEAPON_PLAYER_LAZER')
            if not WEAPON.HAS_WEAPON_ASSET_LOADED(hash) then
                WEAPON.REQUEST_WEAPON_ASSET(hash, 31, 26)
                while not WEAPON.HAS_WEAPON_ASSET_LOADED(hash) do
                    util.yield()
                end
            end
        elseif JSkey.is_key_down('VK_RBUTTON') then
            hash = util.joaat('WEAPON_RAYPISTOL')
            if not WEAPON.HAS_PED_GOT_WEAPON(players.user_ped(), hash, false) then
                WEAPON.GIVE_WEAPON_TO_PED(players.user_ped(), hash, 9999, false, false)
            end
        else
            hash = util.joaat('WEAPON_RPG')
            if not WEAPON.HAS_PED_GOT_WEAPON(players.user_ped(), hash, false) then
                WEAPON.GIVE_WEAPON_TO_PED(players.user_ped(), hash, 9999, false, false)
            end
            a.x += math.random(0, 100) / 100
            a.y += math.random(0, 100) / 100
            a.z += math.random(0, 100) / 100
        end

        WEAPON.SET_CURRENT_PED_WEAPON(players.user_ped(), util.joaat('WEAPON_UNARMED'), true)
        MISC.SHOOT_SINGLE_BULLET_BETWEEN_COORDS(
            a.x, a.y, a.z,
            b.x, b.y, b.z,
            200,
            true,
            hash,
            PLAYER.PLAYER_PED_ID(),
            true, true, -1.0
        )
    end, function()
        if gaveHelmet then
            PED.REMOVE_PED_HELMET(players.user_ped(), true)
            gaveHelmet = false
        end
        local pScaleform = memory.alloc_int()
        memory.write_int(pScaleform, scope_scaleform)
        GRAPHICS.SET_SCALEFORM_MOVIE_AS_NO_LONGER_NEEDED(pScaleform)
        menu.trigger_command(levitationCommand, 'off')
        util.yield()
        CAM.SET_CAM_VIEW_MODE_FOR_CONTEXT(CAM._GET_CAM_ACTIVE_VIEW_MODE_CONTEXT(), startViewMode)
        startViewMode = nil
    end)

    -----------------------------------
    -- Fire wings
    -----------------------------------
        local fire_wings_list = JSlang.list(self_root, 'Fire wings', {}, '')
        local fireWings = {
            [1] = {pos = {[1] = 120, [2] =  75}},
            [2] = {pos = {[1] = 120, [2] = -75}},
            [3] = {pos = {[1] = 135, [2] =  75}},
            [4] = {pos = {[1] = 135, [2] = -75}},
            [5] = {pos = {[1] = 180, [2] =  75}},
            [6] = {pos = {[1] = 180, [2] = -75}},
            [7] = {pos = {[1] = 195, [2] =  75}},
            [8] = {pos = {[1] = 195, [2] = -75}},
        }
        local fireWingsSettings = {
            scale = 0.3,
            fireColour = new.colour(255 / 255, 127 / 255, 80 / 255, 1),
            on = false
        }
        local ptfxEgg
        local firewingPtfx = 'muz_xs_turret_flamethrower_looping'
        JSlang.toggle(fire_wings_list, 'Fire wings', {'JSfireWings'}, 'Puts wings made of fire on your back.', function (toggle)
            fireWingsSettings.on = toggle
            if fireWingsSettings.on then
                ENTITY.SET_ENTITY_PROOFS(players.user_ped(), false, true, false, false, false, false, 1, false)
                if ptfxEgg == nil then
                    local eggHash = 1803116220
                    loadModel(eggHash)
                    ptfxEgg = entities.create_object(eggHash, ENTITY.GET_ENTITY_COORDS(players.user_ped()))
                    ENTITY.SET_ENTITY_COLLISION(ptfxEgg, false, false)
                    STREAMING.SET_MODEL_AS_NO_LONGER_NEEDED(eggHash)
                end
                for i = 1, #fireWings do
                    while not STREAMING.HAS_NAMED_PTFX_ASSET_LOADED('weap_xs_vehicle_weapons') do
                        STREAMING.REQUEST_NAMED_PTFX_ASSET('weap_xs_vehicle_weapons')
                        util.yield()
                    end
                    GRAPHICS.USE_PARTICLE_FX_ASSET('weap_xs_vehicle_weapons')
                    fireWings[i].ptfx = GRAPHICS.START_NETWORKED_PARTICLE_FX_LOOPED_ON_ENTITY(firewingPtfx, ptfxEgg, 0, 0, 0.1, fireWings[i].pos[1], 0, fireWings[i].pos[2], fireWingsSettings.scale, false, false, false)
                    util.create_tick_handler(function()
                        local rot = ENTITY.GET_ENTITY_ROTATION(players.user_ped(), 2)
                        ENTITY.ATTACH_ENTITY_TO_ENTITY(ptfxEgg, players.user_ped(), -1, 0, 0, 0, rot.x, rot.y, rot.z, false, false, false, false, 0, false)
                        ENTITY.SET_ENTITY_ROTATION(ptfxEgg, rot.x, rot.y, rot.z, 2, true)
                        for i = 1, #fireWings do
                            GRAPHICS.SET_PARTICLE_FX_LOOPED_SCALE(fireWings[i].ptfx, fireWingsSettings.scale)
                            GRAPHICS.SET_PARTICLE_FX_LOOPED_COLOUR(fireWings[i].ptfx, fireWingsSettings.fireColour.r, fireWingsSettings.fireColour.g, fireWingsSettings.fireColour.b)
                        end

                        ENTITY.SET_ENTITY_VISIBLE(ptfxEgg, false)
                        return fireWingsSettings.on
                    end)
                end
            else
                for i = 1, #fireWings do
                    if fireWings[i].ptfx then
                        GRAPHICS.REMOVE_PARTICLE_FX(fireWings[i].ptfx, true)
                        fireWings[i].ptfx = nil
                    end
                    if ptfxEgg then
                        entities.delete_by_handle(ptfxEgg)
                        ptfxEgg = nil
                    end
                end
                STREAMING.REMOVE_NAMED_PTFX_ASSET('weap_xs_vehicle_weapons')
            end
        end)

        JSlang.slider(fire_wings_list, 'Fire wings scale', {'JSfireWingsScale'}, '', 1, 100, 3, 1, function(value)
            fireWingsSettings.scale = value / 10
        end)

        menu.rainbow(JSlang.colour(fire_wings_list, 'Fire wings colour', {'JSfireWingsColour'}, '', fireWingsSettings.fireColour, false, function(colour)
            fireWingsSettings.fireColour = colour
        end))

    -----------------------------------
    -- Ped customization
    -----------------------------------
        local faceFeatures = {
            [0]  = 'Nose Width',
            [1]  = 'Nose Peak Hight',
            [2]  = 'Nose Peak Length',
            [3]  = 'Nose Bone Hight',
            [4]  = 'Nose Peak Lowering',
            [5]  = 'Nose Bone Twist',
            [6]  = 'Eyebrow Hight',
            [7]  = 'Eyebrow Forward',
            [8]  = 'Cheeks Bone Hight',
            [9]  = 'Cheeks Bone Width',
            [10] = 'Cheeks Width',
            [11] = 'Eyes Opening',
            [12] = 'Lips Thickness',
            [13] = 'Jaw Bone Width',
            [14] = 'Jaw Bone Back Length',
            [15] = 'Chin Bone Lowering',
            [16] = 'Chin Bone Length',
            [17] = 'Chin Bone Width',
            [18] = 'Chin Hole',
            [19] = 'Neck Width',
        }
        local face_profiles_list = JSlang.list(self_root, 'Face features', {}, '')
        local face_feature_list = JSlang.list(face_profiles_list, 'Customize face features', {}, 'Customizations reset after restarting the game.')

        local face_sliders = {}
        for i = 0, #faceFeatures do
            local faceValue = (util.is_session_started() and math.floor(STAT_GET_FLOAT('FEATURE_'.. i) * 100) or 0)
            face_sliders[faceFeatures[i]] = JSlang.slider(face_feature_list, faceFeatures[i], {'JSset'.. string.gsub(faceFeatures[i], ' ', '')}, '', -1000, 1000, faceValue, 1, function(value)
                PED._SET_PED_MICRO_MORPH_VALUE(players.user_ped(), i, value / 100)
            end)
        end
        menu.divider(face_profiles_list, '', {}, '')

        local function getProfileName(fullPath, removePath)
            local path = string.sub(fullPath, #removePath + 1)
            return string.gsub(path, '.txt', '')
        end
        local profileReferences = {}
        local function loadProfiles(root)
            local faceProfiles = filesystem.list_files(face_profiles_dir)
            for _, profilePath in pairs(faceProfiles) do
                local profileName = getProfileName(profilePath, face_profiles_dir)
                profileReferences[#profileReferences + 1] = menu.action(root, profileName, {'loadface'.. profileName}, '', function()
                    if not filesystem.exists(profilePath) then JSlang.toast('Profile not found.') end

                    local settings = util.read_colons_and_tabs_file(face_profiles_dir .. profileName ..'.txt')
                    for k, value in pairs(settings) do
                        menu.set_value(face_sliders[k], value)
                    end
                end)
            end
        end
        local function reloadProfiles(root)
            for i = 1, #profileReferences do
                menu.delete(profileReferences[i])
                profileReferences[i] = nil
            end
            loadProfiles(root)
        end
        JSlang.action(face_profiles_list, 'Create face feature profile', {"JSsaveFaceFeatures"}, 'Saves your customized face in a file so you can load it.', function()
            menu.show_command_box("JSsaveFaceFeatures ")
        end, function(fileName)
            local file = io.open(face_profiles_dir .. fileName ..'.txt', 'w')
            for i = 0, #faceFeatures do
                file:write(faceFeatures[i] ..': '.. menu.get_value(face_sliders[faceFeatures[i]]) ..'\n')
            end
            file:close()
            reloadProfiles(face_profiles_list)
        end)

        JSlang.action(face_profiles_list, 'Reload profiles', {"JSreLoadFaceFeatureProfiles"}, 'Refreshes your profiles without having to restart the script.', function()
            reloadProfiles(face_profiles_list)
        end)

        JSlang.divider(face_profiles_list, 'Profiles', {}, '')

        if filesystem.is_dir(face_profiles_dir) then
            loadProfiles(face_profiles_list)
        end

        local faceOverlays = {
            [0]  = { name = 'Blemishes',          min = -1, max = 23 },
            [1]  = { name = 'Facial Hair',        min = -1, max = 28 },
            [2]  = { name = 'Eyebrows',           min = -1, max = 33 },
            [3]  = { name = 'Ageing',             min = -1, max = 14 },
            [4]  = { name = 'Makeup',             min = -1, max = 74 },
            [5]  = { name = 'Blush',              min = -1, max = 6  },
            [6]  = { name = 'Complexion',         min = -1, max = 11 },
            [7]  = { name = 'Sun Damage',         min = -1, max = 10 },
            [8]  = { name = 'Lipstick',           min = -1, max = 9  },
            [9]  = { name = 'Moles/Freckles',     min = -1, max = 17 },
            [10] = { name = 'Chest Hair',         min = -1, max = 16 },
            [11] = { name = 'Body Blemishes',     min = -1, max = 11 },
            [12] = { name = 'Add Body Blemishes', min = -1, max = 1  },
        }
        local face_overlay_list = JSlang.list(self_root, 'Customize face overlays', {}, 'Customizations reset after restarting the game.', function()end)

        for i = 0, #faceOverlays do
            local overlayValue = PED._GET_PED_HEAD_OVERLAY_VALUE(players.user_ped(), i)
            JSlang.slider(face_overlay_list, faceOverlays[i].name, {}, '', faceOverlays[i].min, faceOverlays[i].max, (overlayValue == 255 and -1 or overlayValue), 1, function(value)
                PED.SET_PED_HEAD_OVERLAY(players.user_ped(), i, (value == 255 and -1 or value), 1)
            end)
        end

    -----------------------------------
    -- Ragdoll options
    -----------------------------------
        local ragdoll_types = JSlang.list(self_root, 'Ragdoll options', {'JSragdollOptions'}, 'Different options for making yourself ragdoll.')

        JSlang.toggle_loop(ragdoll_types, 'Better clumsiness', {'JSclumsy'}, 'Like stands clumsiness, but you can get up after you fall.', function()
            if PED.IS_PED_RAGDOLL(players.user_ped()) then util.yield(3000) return end
            PED.SET_PED_RAGDOLL_ON_COLLISION(players.user_ped(), true)
        end)

        JSlang.action(ragdoll_types, 'Stumble', {'JSstumble'}, 'Makes you stumble with a good chance of falling over.', function()
            local vector = ENTITY.GET_ENTITY_FORWARD_VECTOR(players.user_ped())
            PED.SET_PED_TO_RAGDOLL_WITH_FALL(players.user_ped(), 1500, 2000, 2, vector.x, -vector.y, vector.z, 1, 0, 0, 0, 0, 0, 0)
        end)

        -- credit to LAZScript for inspiring this
        local fallTimeout = false
        JSlang.toggle(ragdoll_types, 'Fall over', {'JSfallOver'}, 'Makes you stumble, fall over and prevents you from getting back up.', function(toggle)
            if toggle then
                local vector = ENTITY.GET_ENTITY_FORWARD_VECTOR(players.user_ped())
                PED.SET_PED_TO_RAGDOLL_WITH_FALL(players.user_ped(), 1500, 2000, 2, vector.x, -vector.y, vector.z, 1, 0, 0, 0, 0, 0, 0)
            end
            fallTimeout = toggle
            while fallTimeout do
                PED.RESET_PED_RAGDOLL_TIMER(players.user_ped())
                util.yield()
            end
        end)

        -- credit to aaron for telling me this :p
        JSlang.toggle_loop(ragdoll_types, 'Ragdoll', {'JSragdoll'}, 'Just makes you ragdoll.', function()
            PED.SET_PED_TO_RAGDOLL(players.user_ped(), 2000, 2000, 0, true, true, true)
        end)
    -----------------------------------

    --Transition points
    -- 49  -> 50
    -- 87  -> 88
    -- 159 -> 160
    -- 207 -> 208
    local alphaPoints = {0, 87, 159, 207, 255}
    JSlang.slider(self_root, 'Ghost', {'JSghost'}, 'Makes your player different levels off see through.', 0, 4, 4, 1, function(value)
        ENTITY.SET_ENTITY_ALPHA(players.user_ped(),alphaPoints[value + 1], false)
    end)

    JSlang.toggle_loop(self_root, 'Full regen', {'JSfullRegen'}, 'Makes your hp regenerate until you\'re at full health.', function()
        local health = ENTITY.GET_ENTITY_HEALTH(players.user_ped())
        if ENTITY.GET_ENTITY_MAX_HEALTH(players.user_ped()) == health then return end
        ENTITY.SET_ENTITY_HEALTH(players.user_ped(), health + 5, 0)
        util.yield(255)
    end)

    JSlang.toggle(self_root, 'Cold blooded', {'JScoldBlooded'}, 'Removes your thermal signature.\nOther players still see it tho.', function(toggle)
        PED.SET_PED_HEATSCALE_OVERRIDE(players.user_ped(), (toggle and 0 or 1))
    end)

    JSlang.toggle(self_root, 'Quiet footsteps', {'JSquietSteps'}, 'Disables the sound of your footsteps.', function(toggle)
        AUDIO._SET_PED_AUDIO_FOOTSTEP_LOUD(players.user_ped(), not toggle)
     end)

-----------------------------------
-- Weapons
-----------------------------------
    local weapons_root = JSlang.list(menu_root, 'Weapons', {'JSweapons'}, '')

    local thermal_command = menu.ref_by_path('Game>Rendering>Thermal Vision', 34)
    JSlang.toggle_loop(weapons_root, 'Thermal guns', {'JSthermalGuns'}, 'Makes it so when you aim any gun you can toggle thermal vision on "E".', function()
        if PLAYER.IS_PLAYER_FREE_AIMING(players.user_ped()) then
            if JSkey.is_key_just_down('VK_E') then
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

    ----------------------------------
    -- Weapon settings
    ----------------------------------
        local weapon_settings_root = JSlang.list(weapons_root, 'Weapon settings', {}, '')

        local function readWeaponAddress(storeTable, offset, stopIfModified, ignoreVehicleWeapons)
            if util.is_session_transition_active() then return 0 end
            local userPed = players.user_ped()
            local weaponHash, vehicleWeapon = getWeaponHash(userPed)
            if ignoreVehicleWeapons and vehicleWeapon then return end
            if stopIfModified and storeTable[weaponHash] then return 0 end
            local pointer = (vehicleWeapon and 0x70 or 0x20)
            local address = address_from_pointer_chain(entities.handle_to_pointer(userPed), {0x10D8, pointer, offset})
            if address == 0 then JSlang.toast('Failed to find memory address.') return 0 end
            if not storeTable[weaponHash] then
                storeTable[weaponHash] = {
                    address = address,
                    original = memory.read_float(address)
                }
            end
            return weaponHash
        end

        local function resetWeapons(modifiedWeapons)
            for hash, _ in pairs(modifiedWeapons) do
                memory.write_float(modifiedWeapons[hash].address, modifiedWeapons[hash].original)
                modifiedWeapons[hash] = nil
            end
        end

        local modifiedRecoil = {}
        JSlang.toggle_loop(weapon_settings_root, 'Disable recoil', {'JSnoRecoil'}, 'Disables the camera shake when shooting guns.', function()
            local weaponHash = readWeaponAddress(modifiedRecoil, 0x2F4, true)
            if weaponHash == 0 then return end
            memory.write_float(modifiedRecoil[weaponHash].address, 0)
        end, function()
            resetWeapons(modifiedRecoil)
        end)

        local modifiedRange = {}
        JSlang.toggle_loop(weapon_settings_root, 'Infinite range', {'JSinfiniteRange'}, '', function()
            if util.is_session_transition_active() then return end
            local userPed = players.user_ped()
            local weaponHash, vehicleWeapon = getWeaponHash(userPed)
            if modifiedRange[weaponHash] then return end
            local pointer = (vehicleWeapon and 0x70 or 0x20)
            local userPedPointer = entities.handle_to_pointer(userPed)
            modifiedRange[weaponHash] = {
                minAddress   = address_from_pointer_chain(userPedPointer, {0x10D8, pointer, 0x298}),
                maxAddress   = address_from_pointer_chain(userPedPointer, {0x10D8, pointer, 0x29C}),
                rangeAddress = address_from_pointer_chain(userPedPointer, {0x10D8, pointer, 0x28C}),
            }

            if modifiedRange[weaponHash].minAddress == 0 or modifiedRange[weaponHash].maxAddress == 0 or modifiedRange[weaponHash].rangeAddress == 0 then JSlang.toast('Failed to find memory address.') return end

            modifiedRange[weaponHash].originalMin   = memory.read_float(modifiedRange[weaponHash].minAddress)
            modifiedRange[weaponHash].originalMax   = memory.read_float(modifiedRange[weaponHash].maxAddress)
            modifiedRange[weaponHash].originalRange = memory.read_float(modifiedRange[weaponHash].rangeAddress)

            memory.write_float(modifiedRange[weaponHash].minAddress,   150000)  --because the map is about 15km tall
            memory.write_float(modifiedRange[weaponHash].maxAddress,   150000)
            memory.write_float(modifiedRange[weaponHash].rangeAddress, 150000)
        end, function()
            for hash, _ in pairs(modifiedRange) do
                memory.write_float(modifiedRange[hash].minAddress, modifiedRange[hash].originalMin)
                memory.write_float(modifiedRange[hash].maxAddress, modifiedRange[hash].originalMax)
                memory.write_float(modifiedRange[hash].rangeAddress, modifiedRange[hash].originalRange)
                modifiedRange[hash] = nil
            end
        end)

        local modifiedSpread = {}
        JSlang.toggle_loop(weapon_settings_root, 'Disable spread', {'JSnoSpread'}, '', function()
            local weaponHash = readWeaponAddress(modifiedSpread, 0x74, true)
            if weaponHash == 0 then return end
            memory.write_float(modifiedSpread[weaponHash].address, 0)
        end, function()
            resetWeapons(modifiedSpread)
        end)

        local modifiedSpinup = {
            [1] = {hash = util.joaat('weapon_minigun')},
            [2] = {hash = util.joaat('weapon_rayminigun')},
        }
        JSlang.toggle_loop(weapon_settings_root, 'Remove spin-up time', {'JSnoSpinUp'}, 'Removes the spin-up from both the minigun and the widowmaker.', function()
            local weaponHash = WEAPON.GET_SELECTED_PED_WEAPON(players.user_ped())
            for i = 1, #modifiedSpinup do
                if weaponHash == modifiedSpinup[i].hash then
                    modifiedSpinup[i].address = address_from_pointer_chain(entities.handle_to_pointer(players.user_ped()), {0x10D8, 0x20, 0x144})
                    if modifiedSpinup[i].address == 0 then return end
                    memory.write_float(modifiedSpinup[i].address, 0)
                end
            end
        end, function()
            for i = 1, #modifiedSpinup do
                if modifiedSpinup[i].address then
                    memory.write_float(modifiedSpinup[i].address, 0.5)
                end
            end
        end)

        local modifiedCarForce = {}
        local modifiedHeliForce = {}
        local modifiedPedForce = {}
        JSlang.toggle_loop(weapon_settings_root, 'Bullet force multiplier', {'JSbulletForceMultiplier'}, 'Works best when shooting vehicles from the front.\nDisplayed value is in percent.', function()
            local weaponHash = readWeaponAddress(modifiedCarForce, 0x0E0, false)
            if weaponHash == 0 then return end
            memory.write_float(modifiedCarForce[weaponHash].address, modifiedCarForce[weaponHash].original * 99999999999999)

            weaponHash = readWeaponAddress(modifiedHeliForce, 0x0E4, false)
            if weaponHash == 0 then return end
            memory.write_float(modifiedHeliForce[weaponHash].address, modifiedHeliForce[weaponHash].original * 99999999999999)

            weaponHash = readWeaponAddress(modifiedPedForce, 0x0DC, false)
            if weaponHash == 0 then return end
            memory.write_float(modifiedPedForce[weaponHash].address, modifiedPedForce[weaponHash].original * 99999999999999)
        end, function()
            resetWeapons(modifiedCarForce)
            resetWeapons(modifiedHeliForce)
            resetWeapons(modifiedPedForce)
        end)

        JSlang.divider(weapon_settings_root, 'Aim fov')

        local extraZoom2 = 0
        local modifiedAimFov = {}
        JSlang.toggle_loop(weapon_settings_root, 'Enable aim fov', {'JSenableAimFov'}, 'Lets you modify the fov you have while you\'re aiming.', function()
            local weaponHash = readWeaponAddress(modifiedAimFov, 0x2FC, false)
            if weaponHash == 0 then return end
            memory.write_float(modifiedAimFov[weaponHash].address,  modifiedAimFov[weaponHash].original + extraZoom2)
        end, function()
            resetWeapons(modifiedAimFov)
        end)

        JSlang.slider(weapon_settings_root, 'Aim fov', {'JSaimFov'}, '',-40, 100, 0, 1, function(value)
            extraZoom2 = value
        end)

        JSlang.divider(weapon_settings_root, 'Zoom aim fov')

        local extraZoom = 0
        local modifiedZoomFov = {}
        JSlang.toggle_loop(weapon_settings_root, 'Enable zoom fov', {'JSenableZoomFov'}, 'Lets you modify the fov you have while you\'re aiming and has zoomed in.', function()
            local weaponHash = readWeaponAddress(modifiedZoomFov, 0x410, false)
            if weaponHash == 0 then return end
            memory.write_float(modifiedZoomFov[weaponHash].address,  modifiedZoomFov[weaponHash].original + extraZoom)
        end, function()
            resetWeapons(modifiedZoomFov)
        end)

        JSlang.slider_float(weapon_settings_root, 'Zoom aim fov', {'JSzoomAimFov'}, '', 100, 9999999999, 100, 1, function(value)
            extraZoom = (value - 100) / 100
            modifiedZoomWeapon = nil
        end)

    -----------------------------------
    -- Proxy stickys
    -----------------------------------
        local proxy_sticky_root = JSlang.list(weapons_root, 'Proxy stickys', {}, '')

        local proxyStickySettings = {players = true, npcs = false, radius = 2}
        local function autoExplodeStickys(ped)
            local pos = ENTITY.GET_ENTITY_COORDS(ped, true)
            if not MISC.IS_PROJECTILE_TYPE_WITHIN_DISTANCE(pos.x, pos.y, pos.z, util.joaat('weapon_stickybomb'), proxyStickySettings.radius, true) then return end
            WEAPON.EXPLODE_PROJECTILES(players.user_ped(), util.joaat('weapon_stickybomb'))
        end

        JSlang.toggle_loop(proxy_sticky_root, 'Proxy stickys', {'JSproxyStickys'}, 'Makes your sticky bombs automatically detonate around players or npc\'s, works with the player whitelist.', function()
            if proxyStickySettings.players then
                local specificWhitelistGroup = {user = false,  friends = whitelistGroups.friends, strangers = whitelistGroups.strangers}
                local playerList = getNonWhitelistedPlayers(whitelistListTable, specificWhitelistGroup, whitelistedName)
                for _, pid in pairs(playerList) do
                    local ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
                    autoExplodeStickys(ped)
                end
            end
            if proxyStickySettings.npcs then
                local pedHandles = entities.get_all_peds_as_handles()
                for _, ped in pairs(pedHandles) do
                    if not PED.IS_PED_A_PLAYER(ped) then
                        autoExplodeStickys(ped)
                    end
                end
            end
        end)

        JSlang.toggle(proxy_sticky_root, 'Detonate near players', {'JSProxyStickyPlayers'}, 'If your sticky bombs automatically detonate near players.', function(toggle)
            proxyStickySettings.players = toggle
        end, proxyStickySettings.players)

        JSlang.toggle(proxy_sticky_root, 'Detonate near npc\'s', {'JSProxyStickyNpcs'}, 'If your sticky bombs automatically detonate near npc\'s.', function(toggle)
            proxyStickySettings.npcs = toggle
        end, proxyStickySettings.npcs)

        JSlang.slider(proxy_sticky_root, 'Detonation radius', {'JSstickyRadius'}, 'How close the sticky bombs have to be to the target to detonate.', 1, 10, proxyStickySettings.radius, 1, function(value)
            proxyStickySettings.radius = value
        end)

        JSlang.action(proxy_sticky_root, 'Remove all sticky bombs', {'JSremoveStickys'}, 'Removes every single sticky bomb that exists (not only yours).', function()
            WEAPON.REMOVE_ALL_PROJECTILES_OF_TYPE(util.joaat('weapon_stickybomb'), false)
        end)
    -----------------------------------

    JSlang.toggle(weapons_root, 'Friendly fire', {'JSfriendlyFire'}, 'Makes you able to shoot peds the game count as your friends.', function(toggle)
        PED.SET_CAN_ATTACK_FRIENDLY(players.user_ped(), toggle, false)
    end)

    JSlang.toggle_loop(weapons_root, 'Reload when rolling', {'JSrollReload'}, 'Reloads your weapon when doing a roll.', function()
        if TASK.GET_IS_TASK_ACTIVE(players.user_ped(), 4) and JSkey.is_control_pressed(2, 'INPUT_JUMP') and not PED.IS_PED_SHOOTING(players.user_ped())  then --checking if player is rolling
            util.yield(900)
            WEAPON.REFILL_AMMO_INSTANTLY(players.user_ped())
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
    local nuke_gun_root = JSlang.list(weapons_root, 'Nuke options', {}, '')
    local nuke_gun_toggle = JSlang.toggle(nuke_gun_root, 'Nuke gun', {'JSnukeGun'}, 'Makes the rpg fire nukes', function(toggle)
        nuke_running = toggle
        if nuke_running then
            if animals_running then menu.trigger_command(exp_animal_toggle, 'off') end
            util.create_tick_handler(function()
                if WEAPON.GET_SELECTED_PED_WEAPON(players.user_ped()) == -1312131151 then --if holding homing launcher
                    if PED.IS_PED_SHOOTING(players.user_ped()) then
                        if not remove_projectiles then
                            remove_projectiles = true
                            disableProjectileLoop(-1312131151)
                        end
                        util.create_thread(function()
                            local hash = util.joaat('w_arena_airmissile_01a')
                            loadModel(hash)

                            local cam_rot = CAM.GET_FINAL_RENDERED_CAM_ROT(2)
                            local dir, pos = direction()

                            local bomb = entities.create_object(hash, pos)
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
            JSlang.toast('No waypoint set.')
        end
    end

    JSlang.action(nuke_gun_root, 'Nuke waypoint', {'JSnukeWP'}, 'Drops a nuke on your selected Waypoint.', function ()
        local waypointPos = get_waypoint_pos2()
        if waypointPos then
            local hash = util.joaat('w_arena_airmissile_01a')
            loadModel(hash)

            waypointPos.z += 30
            local bomb = entities.create_object(hash, waypointPos)
            waypointPos.z -= 30
            ENTITY.SET_ENTITY_ROTATION(bomb, -90, 0, 0,  2, true)
            ENTITY.APPLY_FORCE_TO_ENTITY(bomb, 0, 0, 0, 0, 0.0, 0.0, 0.0, 0, true, false, true, false, true)
            STREAMING.SET_MODEL_AS_NO_LONGER_NEEDED(hash)

            while not ENTITY.HAS_ENTITY_COLLIDED_WITH_ANYTHING(bomb) do util.yield() end
            entities.delete(bomb)
            executeNuke(waypointPos)
        end
    end)
    JSlang.slider(nuke_gun_root, 'Nuke height', {'JSnukeHeight'}, 'The height of the nukes you drop.', 10, 100, nuke_height, 10, function(value)
        nuke_height = value
    end)

    --this is heavily skidded from wiriScript so credit to wiri
    local launcherThrowable = util.joaat('weapon_grenade')
    local throwables_launcher_root = JSlang.list(weapons_root, 'Throwables launcher', {}, '')
    local grenade_gun_toggle = JSlang.toggle(throwables_launcher_root, 'Throwables launcher', {'JSgrenade'}, 'Makes the grenade launcher able to shoot throwables, gives you the throwable if you don\'t have it so you can shoot it.', function(toggle)
        grenade_running = toggle
        if grenade_running then
            if animals_running then menu.trigger_command(exp_animal_toggle, "off") end
            util.create_tick_handler(function()
                if WEAPON.GET_SELECTED_PED_WEAPON(players.user_ped()) == -1568386805 then --if holding grenade launcher
                    if PED.IS_PED_SHOOTING(players.user_ped()) then
                        if not remove_projectiles then
                            remove_projectiles = true
                            disableProjectileLoop(-1568386805)
                        end
                        util.create_thread(function()
                            local currentWeapon = WEAPON.GET_CURRENT_PED_WEAPON_ENTITY_INDEX(players.user_ped(), false)
                            local pos1 = ENTITY._GET_ENTITY_BONE_POSITION_2(currentWeapon, ENTITY.GET_ENTITY_BONE_INDEX_BY_NAME(currentWeapon, 'gun_muzzle'))
                            local pos2 = get_offset_from_gameplay_camera(30)
                            if not WEAPON.HAS_PED_GOT_WEAPON(players.user_ped(), launcherThrowable, false) then
                                WEAPON.GIVE_WEAPON_TO_PED(players.user_ped(), launcherThrowable, 9999, false, false)
                            end
                            util.yield()
                            MISC.SHOOT_SINGLE_BULLET_BETWEEN_COORDS(pos1.x, pos1.y, pos1.z, pos2.x, pos2.y, pos2.z, 200, true, launcherThrowable, players.user_ped(), true, false, 2000.0)
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
        ['Grenade']  = util.joaat('weapon_grenade'),
        ['Sticky Bomb']  = util.joaat('weapon_stickybomb'),
        ['Proximity Mine']  = util.joaat('weapon_proxmine'),
        ['BZ Gas']  = util.joaat('weapon_bzgas'),
        ['Tear Gas']  = util.joaat('weapon_smokegrenade'),
        ['Molotov']  = util.joaat('weapon_molotov'),
        ['Flare']  = util.joaat('weapon_flare'),
        ['Snowball']  = util.joaat('weapon_snowball'),
        ['Ball']  = util.joaat('weapon_ball'),
        ['Pipe Bomb'] = util.joaat('weapon_pipebomb'),
    }
    local throwables_launcher_list throwables_launcher_list = menu.list_action(throwables_launcher_root, JSlang.str_trans('Current throwable') ..': Grenade', {}, JSlang.trans('Choose what throwable the grenade launcher has.'), getLabelTableFromKeys(throwablesTable), function(index, text)
        menu.set_menu_name(throwables_launcher_list, JSlang.str_trans('Current throwable') ..': '.. text)
        launcherThrowable = throwablesTable[text]
    end)

    local disable_firing = false
    local function disableFiringLoop()
        util.create_tick_handler(function()
            PLAYER.DISABLE_PLAYER_FIRING(players.user_ped(), true)
            return disable_firing
        end)
    end

    local exp_animal_gun_root = JSlang.list(weapons_root, 'Explosive animal gun', {}, '')
    local exp_animal = 'a_c_killerwhale'
    exp_animal_toggle = JSlang.toggle(exp_animal_gun_root, 'Explosive animal gun', {'JSexpAnimalGun'}, 'Inspired by impulses explosive whale gun, but can fire other animals too.', function(toggle)
        animals_running = toggle
        if animals_running then
            if nuke_running then menu.trigger_command(nuke_gun_toggle, 'off') end
            if grenade_running then menu.trigger_command(grenade_gun_toggle, 'off') end
            while animals_running do
                local weaponHash = WEAPON.GET_SELECTED_PED_WEAPON(players.user_ped())
                local weaponType = WEAPON.GET_WEAPON_DAMAGE_TYPE(weaponHash)
                if weaponType == 3 or (weaponType == 5 and WEAPON.GET_WEAPONTYPE_GROUP(weaponHash) != 1548507267) then --weapons that shoot bullets or explosions and isn't in the throwables category (grenades, proximity mines etc...)
                    disable_firing = true
                    disableFiringLoop()
                    if JSkey.is_key_down('VK_LBUTTON') and PLAYER.IS_PLAYER_FREE_AIMING(players.user_ped()) then
                        util.create_thread(function()
                            local hash = util.joaat(exp_animal)
                            loadModel(hash)

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
        ['Cat'] = 'a_c_cat_01',
        ['Pug'] = 'a_c_pug',
        ['Killerwhale'] = 'a_c_killerwhale',
        ['Dolphin'] = 'a_c_dolphin',
        ['Hen'] = 'a_c_hen',
        ['Pig'] = 'a_c_pig',
        ['Chimp'] = 'a_c_chimp',
        ['Rat'] = 'a_c_rat',
        ['Fish'] = 'a_c_fish',
        ['Retriever'] = 'a_c_retriever',
        ['Rottweiler'] = 'a_c_rottweiler',
    }
    local throwables_launcher_list throwables_launcher_list = menu.list_action(exp_animal_gun_root, JSlang.str_trans('Current animal') ..': Killerwhale', {}, JSlang.trans('Choose wat animal the explosive animal gun has.'), getLabelTableFromKeys(animalsTable), function(index, text)
        menu.set_menu_name(throwables_launcher_list, JSlang.str_trans('Current animal') ..': '.. text)
        exp_animal = animalsTable[text]
    end)

    local impactCords = v3.new()
    local blocks = {}
    local minecraft_gun_root = JSlang.list(weapons_root, 'Minecraft gun', {}, '')
    JSlang.toggle_loop(minecraft_gun_root, 'Minecraft gun', {'JSminecraftGun'}, 'Spawns blocks where you shoot.', function()
        if WEAPON.GET_PED_LAST_WEAPON_IMPACT_COORD(players.user_ped(), impactCords) then
            local hash = util.joaat('prop_mb_sandblock_01')
            loadModel(hash)
            blocks[#blocks + 1] = entities.create_object(hash, impactCords)
        end
    end)
    JSlang.action(minecraft_gun_root, 'Delete last block', {'JSdeleteLastBlock'}, '', function()
        if blocks[#blocks] != nil then
            entities.delete_by_handle(blocks[#blocks])
            blocks[#blocks] = nil
        end
    end)
    JSlang.action(minecraft_gun_root, 'Delete all blocks', {'JSdeleteBlocks'}, '', function()
        for i = 1, #blocks do
            entities.delete_by_handle(blocks[i])
            blocks[i] = nil
        end
    end)

-----------------------------------
-- Vehicle
-----------------------------------
    local my_vehicle_root = JSlang.list(menu_root, 'Vehicle', {'JSVeh'}, '')

    local my_cur_car = entities.get_user_vehicle_as_handle() --gets updated in the tick loop at the bottom of the script

    local carDoors = {
        'Driver Door',
        'Passenger Door',
        'Rear Left',
        'Rear Right',
        'Hood',
        'Trunk',
    }

    local carSettings carSettings = { --makes carSettings available inside this table
        disableExhaustPops = {on = false, setOption = function(toggle)
            AUDIO.ENABLE_VEHICLE_EXHAUST_POPS(my_cur_car, not toggle)
        end},
        launchControl = {on = false, setOption = function(toggle)
            PHYSICS._SET_LAUNCH_CONTROL_ENABLED(toggle)
        end},
        ghostCar = {on = true, value = 4, setOption = function(toggle)
            if carSettings.ghostCar.value != 4 then
                local index = toggle and carSettings.ghostCar.value + 1 or 5
                ENTITY.SET_ENTITY_ALPHA(my_cur_car, alphaPoints[index], true)
            end
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
        lowTraction = {on = false, setOption = function(toggle)
            VEHICLE.SET_VEHICLE_REDUCE_GRIP(my_cur_car, toggle)
            VEHICLE._SET_VEHICLE_REDUCE_TRACTION(my_cur_car, toggle and 0 or 3)
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
        local speedHandling_root = JSlang.list(my_vehicle_root, 'Speed and handling', {'JSspeedHandling'}, '')

        JSlang.toggle(speedHandling_root, 'Low traction', {'JSlowTraction'}, 'Makes your vehicle have low traction, I recommend setting this to a hotkey.', function(toggle)
            carSettings.lowTraction.on = toggle
            carSettings.lowTraction.setOption(toggle)
        end)

        JSlang.toggle(speedHandling_root, 'Launch control', {'JSlaunchControl'}, 'Limits how much force your car applies when accelerating so it doesn\'t burnout, very noticeable in a Emerus.', function(toggle)
            carSettings.launchControl.on = toggle
            carSettings.launchControl.setOption(toggle)
        end)

        local my_torque = 100
        JSlang.slider_float(speedHandling_root, 'Set torque', {'JSsetSelfTorque'}, 'Modifies the speed of your vehicle.', -1000000, 1000000, my_torque, 1, function(value)
            my_torque = value
            util.create_tick_handler(function()
                VEHICLE.SET_VEHICLE_CHEAT_POWER_INCREASE(my_cur_car, my_torque/100)
                return (my_torque != 100)
            end)
        end)

        local quickBrakeLvL = 1.5
        JSlang.toggle_loop(speedHandling_root, 'Quick brake', {'JSquickBrake'}, 'Slows down your speed more when pressing "S".', function(toggle)
            if JSkey.is_control_just_pressed(2, 'INPUT_VEH_BRAKE') and ENTITY.GET_ENTITY_SPEED(my_cur_car) >= 0 and not ENTITY.IS_ENTITY_IN_AIR(my_cur_car) and VEHICLE.GET_PED_IN_VEHICLE_SEAT(my_cur_car, -1, false) == players.user_ped() then
                VEHICLE.SET_VEHICLE_FORWARD_SPEED(my_cur_car, ENTITY.GET_ENTITY_SPEED(my_cur_car) / quickBrakeLvL)
                util.yield(250)
            end
        end)

        JSlang.slider_float(speedHandling_root, 'Quick brake force', {'JSquickBrakeForce'}, '1.00 is ordinary brakes.', 100, 999, 150, 1,  function(value)
            quickBrakeLvL = value / 100
        end)

    -----------------------------------
    -- Boosts
    -----------------------------------
        local boosts_root = JSlang.list(my_vehicle_root, 'Boosts', {'JSboosts'}, '')

        JSlang.toggle_loop(boosts_root, 'Horn boost', {'JShornBoost'}, 'Makes your car speed up when you honking your horn or activating your siren.', function()
            if not (AUDIO.IS_HORN_ACTIVE(my_cur_car) or VEHICLE.IS_VEHICLE_SIREN_ON(my_cur_car)) then return end
            VEHICLE.SET_VEHICLE_FORWARD_SPEED(my_cur_car, ENTITY.GET_ENTITY_SPEED(my_cur_car) + hornBoostMultiplier)
        end)

        JSlang.toggle_loop(boosts_root, 'Vehicle jump', {'JSVehJump'}, 'Lets you jump with your car if you double tap "W".', function()
            if VEHICLE.GET_PED_IN_VEHICLE_SEAT(my_cur_car, -1, false) == players.user_ped() and PED.IS_PED_IN_VEHICLE(players.user_ped(), my_cur_car, true) then
                local prevPress = JSkey.get_ms_since_control_last_press(2, 'INPUT_MOVE_UP_ONLY')
                if JSkey.is_control_just_pressed(2, 'INPUT_MOVE_UP_ONLY') and prevPress != -1 and prevPress <= maxTimeBetweenPress then
                    local mySpeed = ENTITY.GET_ENTITY_SPEED(my_cur_car)
                    ENTITY.APPLY_FORCE_TO_ENTITY_CENTER_OF_MASS(my_cur_car, 1, 0, 2, (mySpeed / 10) + 14, 0, true, true, true)
                    AUDIO.PLAY_SOUND_FROM_ENTITY(-1, 'Hydraulics_Down', players.user_ped(), 'Lowrider_Super_Mod_Garage_Sounds', true, 20)
                end
            end
        end)

        -----------------------------------
        -- Nitro
        -----------------------------------
            JSlang.divider(boosts_root, 'Nitro')

            local nitroSettings = {level = new.delay(500, 2, 0), power = 1, rechargeTime = new.delay(200, 1, 0)}

            local nitroBoostActive = false
            JSlang.toggle(boosts_root, 'Enable nitro', {'JSnitro'}, 'Enable nitro boost on any vehicle, use it by pressing "X".', function(toggle)
                nitroBoostActive = toggle
                if not STREAMING.HAS_NAMED_PTFX_ASSET_LOADED('veh_xs_vehicle_mods') then
                    STREAMING.REQUEST_NAMED_PTFX_ASSET('veh_xs_vehicle_mods')
                    while not STREAMING.HAS_NAMED_PTFX_ASSET_LOADED('veh_xs_vehicle_mods') do util.yield() end
                end
                while nitroBoostActive do
                    if JSkey.is_control_just_pressed(2, 'INPUT_VEH_TRANSFORM') and PED.IS_PED_IN_ANY_VEHICLE(players.user_ped(), true) then --control is x
                        VEHICLE._SET_VEHICLE_NITRO_ENABLED(my_cur_car, true, getTotalDelay(nitroSettings.level) / 10, nitroSettings.power, 999999999999999999, false)
                        util.yield(getTotalDelay(nitroSettings.level))
                        VEHICLE._SET_VEHICLE_NITRO_ENABLED(my_cur_car, false, getTotalDelay(nitroSettings.level) / 10, nitroSettings.power, 999999999999999999, false)
                        local startTime = util.current_time_millis()
                        while util.current_time_millis() < startTime + getTotalDelay(nitroSettings.rechargeTime) do util.yield() end
                    end
                    util.yield()
                end
            end)

            local nitro_duration_root = menu.list(boosts_root, JSlang.str_trans('Duration') ..': '.. getDelayDisplayValue(nitroSettings.level), {'JSnitroDuration'}, JSlang.str_trans('Lets you set a customize how long the nitro lasts.'))
            generateDelaySettings(nitro_duration_root, JSlang.str_trans('Duration'), nitroSettings.level)

            local nitro_recharge_root = menu.list(boosts_root, JSlang.str_trans('Recharge time') ..': '.. getDelayDisplayValue(nitroSettings.rechargeTime), {'JSnitroRecharge'}, JSlang.str_trans('Lets you set a custom delay of how long it takes for nitro to recharge.'))
            generateDelaySettings(nitro_recharge_root, JSlang.str_trans('Recharge time'), nitroSettings.rechargeTime)

        -----------------------------------
        -- Shunt boost
        -----------------------------------
            JSlang.divider(boosts_root, 'Shunt boost')

            local shuntSettings = {
                maxForce = 30, force = 30, disableRecharge = false,
            }
            local function forceRecharge()
                util.create_thread(function()
                    shuntSettings.force = 0
                    while shuntSettings.force < shuntSettings.maxForce and not shuntSettings.disableRecharge do
                        shuntSettings.force += 1
                        util.yield(100)
                    end
                    shuntSettings.force = shuntSettings.maxForce
                    if notifications and not shuntSettings.disableRecharge then
                        JSlang.toast('Shunt boost fully recharged')
                    end
                end)
            end
            local function shunt(dir)
                ENTITY.APPLY_FORCE_TO_ENTITY_CENTER_OF_MASS(my_cur_car, 1, shuntSettings.force * dir, 0, 0, 0, true, true, true)
                AUDIO.PLAY_SOUND_FROM_ENTITY(-1, 'Hydraulics_Down', players.user_ped(), 'Lowrider_Super_Mod_Garage_Sounds', true, 20)
                forceRecharge()
            end

            JSlang.toggle_loop(boosts_root, 'Shunt boost', {'JSshuntBoost'}, 'Lets you shunt boost in any vehicle by double tapping "A" or "D".', function()
                util.create_thread(function()
                    if VEHICLE.GET_PED_IN_VEHICLE_SEAT(my_cur_car, -1, false) == players.user_ped() and PED.IS_PED_IN_VEHICLE(players.user_ped(), my_cur_car, true) then
                        local prevDPress = JSkey.get_ms_since_last_press('VK_D')
                        local prevAPress = JSkey.get_ms_since_last_press('VK_A')
                        if JSkey.is_key_just_down('VK_D') and prevDPress != -1 and prevDPress <= maxTimeBetweenPress then
                            shunt(1)
                        elseif JSkey.is_key_just_down('VK_A') and prevAPress != -1 and prevAPress <= maxTimeBetweenPress then
                            shunt(-1)
                        end
                    end
                end)
            end)

            JSlang.toggle(boosts_root, 'Disable recharge', {'JSnoShutRecharge'}, 'Removes the force build-up of the shunt boost.', function(toggle)
                shuntSettings.disableRecharge = toggle
            end)
            JSlang.slider(boosts_root, 'Force', {'JSshuntForce'}, 'How much force is applied to your car.', 0, 1000, 30, 1, function(value)
                shuntSettings.maxForce = value
            end)

    -----------------------------------
    -- Vehicle doors
    -----------------------------------
        local veh_door_root = JSlang.list(my_vehicle_root, 'Vehicle doors', {'JSvehDoors'}, '')

        JSlang.toggle(veh_door_root, 'Indestructible doors', {'JSinvincibleDoors'}, 'Makes it so your vehicle doors can\'t break off.', function(toggle)
            carSettings.indestructibleDoors.on = toggle
            local vehicleDoorCount =  VEHICLE._GET_NUMBER_OF_VEHICLE_DOORS(my_cur_car)
            for i = -1, vehicleDoorCount do
                VEHICLE._SET_VEHICLE_DOOR_CAN_BREAK(my_cur_car, i, not toggle)
            end
        end)

        JSlang.toggle_loop(veh_door_root, 'Shut doors when driving', {'JSautoClose'}, 'Closes all the vehicle doors when you start driving.', function()
            if VEHICLE.GET_PED_IN_VEHICLE_SEAT(my_cur_car, -1, false) == players.user_ped() and ENTITY.GET_ENTITY_SPEED(my_cur_car) > 1 then --over a speed of 1 because car registers as moving then doors move
                if ENTITY.GET_ENTITY_SPEED(my_cur_car) < 10 then util.yield(800) else util.yield(600) end
                local closed = false
                for i, door in ipairs(carDoors) do
                    if VEHICLE.GET_VEHICLE_DOOR_ANGLE_RATIO(my_cur_car, (i-1)) > 0 and not VEHICLE.IS_VEHICLE_DOOR_DAMAGED(my_cur_car, (i-1)) then
                        VEHICLE.SET_VEHICLE_DOOR_SHUT(my_cur_car, (i-1), false)
                        closed = true
                    end
                end
                if notifications and closed then
                    JSlang.toast('Closed your car doors.')
                end
            end
        end)

        --credit to Wiri, I couldn't get the trunk to close/open so I copied him
        JSlang.action(veh_door_root, 'Open all doors', {'JScarDoorsOpen'}, 'Made this to test door stuff.', function()
            for i, door in ipairs(carDoors) do
                VEHICLE.SET_VEHICLE_DOOR_OPEN(my_cur_car, (i-1), false, false)
            end
        end)

        JSlang.action(veh_door_root, 'Close all doors', {'JScarDoorsClosed'}, 'Made this to test door stuff.', function()
            VEHICLE.SET_VEHICLE_DOORS_SHUT(my_cur_car, false)
        end)

    -----------------------------------
    -- Plane options
    -----------------------------------
        local plane_root = JSlang.list(my_vehicle_root, 'Plane options', {'JSplane'}, '')

        local afterBurnerState = false
        local afterburnerToggle = false
        JSlang.toggle(plane_root, 'Toggle plane afterburner', {'JSafterburner'}, 'Makes you able to toggle afterburner on planes by pressing "left shift".', function(toggle)
            afterburnerToggle = toggle
            util.create_tick_handler(function()
                if JSkey.is_key_just_down('VK_LSHIFT') then
                    afterBurnerState = not afterBurnerState
                    VEHICLE.SET_VEHICLE_FORCE_AFTERBURNER(my_cur_car, afterBurnerState)
                end
                return afterburnerToggle
            end)
            VEHICLE.SET_VEHICLE_FORCE_AFTERBURNER(my_cur_car, false)
        end)

        JSlang.toggle(plane_root, 'Lock vtol', {'JSlockVtol'}, 'Locks the angle of planes vtol propellers.', function(toggle)
            VEHICLE._SET_DISABLE_VEHICLE_FLIGHT_NOZZLE_POSITION(my_cur_car, toggle)
        end)
    -----------------------------------

    JSlang.slider(my_vehicle_root, 'Ghost vehicle', {'JSghostVeh'}, 'Makes your vehicle different levels off see through.', 0 , 4, 4, 1, function(value)
        carSettings.ghostCar.value = value
        if PED.IS_PED_IN_ANY_VEHICLE(players.user_ped(), true) then
            ENTITY.SET_ENTITY_ALPHA(my_cur_car,alphaPoints[value + 1], true)
        end
    end)

    JSlang.toggle(my_vehicle_root, 'Disable exhaust pops', {'JSdisablePops'}, 'Disables those annoying exhaust pops that your car makes if it has a non-stock exhaust option.', function(toggle)
        carSettings.disableExhaustPops.on = toggle
        carSettings.disableExhaustPops.setOption(toggle)
    end)

    JSlang.toggle(my_vehicle_root, 'Stance', {'JSstance'}, 'Activates stance on vehicles that support it.', function(toggle)
        VEHICLE._SET_REDUCE_DRIFT_VEHICLE_SUSPENSION(my_cur_car, toggle)
    end)

    JSlang.toggle(my_vehicle_root, 'Npc horn', {'JSnpcHorn'}, 'Makes you horn like a npc. Also makes your car doors silent.', function(toggle)
        carSettings.npcHorn.on = toggle
        VEHICLE._SET_VEHICLE_SILENT(my_cur_car, toggle)
    end)

    JSlang.toggle_loop(my_vehicle_root, 'To the moon', {'JStoMoon'}, 'Forces you info the sky if you\'re in a vehicle.', function(toggle)
        NETWORK.NETWORK_REQUEST_CONTROL_OF_ENTITY(my_cur_car)
        ENTITY.APPLY_FORCE_TO_ENTITY(my_cur_car, 1, 0, 0, 100, 0, 0, 0.5, 0, false, false, true)
    end)

    JSlang.toggle_loop(my_vehicle_root, 'Anchor', {'JSanchor'}, 'Forces you info the ground if you\'re in a air born vehicle.', function(toggle)
        if ENTITY.IS_ENTITY_IN_AIR(my_cur_car) then
            NETWORK.NETWORK_REQUEST_CONTROL_OF_ENTITY(my_cur_car)
            ENTITY.APPLY_FORCE_TO_ENTITY(my_cur_car, 1, 0, 0, -100, 0, 0, 0.5, 0, false, false, true)
        end
    end)

-----------------------------------
-- Online
-----------------------------------
    local online_root = JSlang.list(menu_root, 'Online', {'JSonline'}, '')

    -----------------------------------
    -- Fake money
    -----------------------------------
        local fake_money_root = JSlang.list(online_root, 'Fake money', {'JSfakeMoney'}, 'Adds fake money, it is only a visual thing and you can\'t spend it.')

        local cashFakeMoney = 0
        local bankFakeMoney = 0
        local fakeMoneyLoopDelay = new.delay(250, 0, 0)
        local fakeMoneyTransactionPending = true

        local function transactionPending()
            if not fakeMoneyTransactionPending then return end
            startBusySpinner('Transaction pending')
            util.yield(math.random(1, 1000))
            HUD.BUSYSPINNER_OFF()
        end

        JSlang.action(fake_money_root, 'Add fake money', {'JSaddFakeMoney'}, 'Adds money once.', function()
            HUD._SET_PLAYER_CASH_CHANGE(cashFakeMoney, bankFakeMoney)
            transactionPending()
        end)

        JSlang.toggle_loop(fake_money_root, 'Loop fake money', {'JSloopFakeMoney'}, 'Adds loops money with your chosen delay.', function()
            HUD._SET_PLAYER_CASH_CHANGE(cashFakeMoney, bankFakeMoney)
            transactionPending()
            util.yield(getTotalDelay(fakeMoneyLoopDelay))
        end)

        JSlang.toggle(fake_money_root, 'Show transaction pending', {'JSfakeTransaction'}, 'Adds a loading transaction pending message when adding fake money.', function(toggle)
            fakeMoneyTransactionPending = toggle
        end, fakeMoneyTransactionPending)

        local fake_money_loop_delay_root = menu.list(fake_money_root, JSlang.str_trans('Fake money loop delay') ..': '.. getDelayDisplayValue(fakeMoneyLoopDelay), {'JSexpDelay'}, JSlang.str_trans('Lets you set a custom delay to the fake money loop.'))

        generateDelaySettings(fake_money_loop_delay_root, JSlang.str_trans('Fake money loop delay'), fakeMoneyLoopDelay)

        JSlang.slider(fake_money_root, 'Bank fake money', {'JSbankFakeMoney'}, 'How much fake money that gets added into your bank.', -2000000000, 2000000000, bankFakeMoney, 1, function(value)
            bankFakeMoney = value
        end)

        JSlang.slider(fake_money_root, 'Cash fake money', {'JScashFakeMoney'}, 'How much fake money that gets added in cash.', -2000000000, 2000000000, cashFakeMoney, 1, function(value)
            cashFakeMoney = value
        end)

    -----------------------------------
    -- Safe monitor
    -----------------------------------
        local SM_root = JSlang.list(online_root, 'Safe monitor', {'JSsm'}, 'Safe monitor allows you to monitor your safes. It does NOT affect the money being generated.')

        local toggleSafeMonitor = false
        JSlang.toggle(SM_root, 'Toggle all selected', {'SMtoggleAllSelected'}, 'Toggles every option.', function(toggle)
            toggleSafeMonitor = toggle
        end)

        local safeManagerToggles = {
            {
                name = 'Nightclub Safe',
                command = 'SMclub',
                description = 'Monitors nightclub safe cash, this does NOT affect income.',
                toggle = true,
                displayText = function()
                    return JSlang.str_trans('Nightclub Cash') ..': '.. STAT_GET_INT('CLUB_SAFE_CASH_VALUE')  / 1000  ..'k / 210k'
                end
            },
            {
                name = 'Nightclub Popularity',
                command = 'SMclubPopularity',
                description = '',
                toggle = false,
                displayText = function()
                    return JSlang.str_trans('Nightclub Popularity') ..': '.. math.floor(STAT_GET_INT('CLUB_POPULARITY') / 10)  ..'%'
                end
            },
            {
                name = 'Nightclub Daily Earnings',
                command = 'SMnightclubEarnings',
                description = 'Nightclub daily earnings.\nMaximum daily earnings is 10k.',
                toggle = false,
                displayText = function()
                    return JSlang.str_trans('Nightclub Daily Earnings') ..': '.. getNightclubDailyEarnings() / 1000  ..'k / day'
                end
            },
            {
                name = 'Arcade safe',
                command = 'SMarcade',
                description = 'Monitors arcade safe cash, this does NOT affect income.\nMaximum daily earnings is 5k if you have all the arcade games.',
                toggle = true,
                displayText = function()
                    return JSlang.str_trans('Arcade Cash') ..': '.. STAT_GET_INT('ARCADE_SAFE_CASH_VALUE') / 1000  ..'k / 100k'
                end
            },
            {
                name = 'Agency safe',
                command = 'SMagency',
                description = 'Monitors agency safe cash, this does NOT affect income.\nMaximum daily earnings is 20k.',
                toggle = true,
                displayText = function()
                    return JSlang.str_trans('Agency Cash') ..': '.. STAT_GET_INT("FIXER_SAFE_CASH_VALUE") / 1000  ..'k / 250k'
                end
            },
            {
                name = 'Security contracts',
                command = 'SMsecurity',
                description = 'Displays the number of agency security missions you have completed.',
                toggle = false,
                displayText = function()
                    return JSlang.str_trans('Security contracts') ..': '.. STAT_GET_INT('FIXER_COUNT')
                end
            },
            {
                name = 'Agency daily Earnings',
                command = 'SMagencyEarnings',
                description = 'Agency daily earnings.\nMaximum daily earnings is 20k if you have completed 200 contracts.',
                toggle = false,
                displayText = function()
                    return JSlang.str_trans('Agency Daily Earnings') ..': '.. getAgencyDailyEarnings(STAT_GET_INT('FIXER_COUNT')) / 1000 ..'k / day'
                end
            },
        }
        generateToggles(safeManagerToggles, SM_root, false)

        local first_open_SM_earnings = {true}
        SM_earnings_root = JSlang.list(SM_root, 'Increase safe earnings', {'SMearnings'}, 'Might be risky.', function()
            listWarning(SM_earnings_root, first_open_SM_earnings)
        end)

        JSlang.toggle_loop(SM_earnings_root, 'Auto nightclub popularity', {'SMautoClubPop'}, 'Automatically sets the nightclubs popularity to 100 if it results in less than max daily income.', function(toggle)
            if getNightclubDailyEarnings() < 50000 then
                menu.trigger_commands('clubPopularity 100')
            end
        end)

        local fixer_count_cooldown = false
        menu.action(SM_earnings_root, 'Increment security contracts completed', {'SMsecurityComplete'}, 'Will put you in a new lobby to make the increase stick.\nI added a cooldown to this button so you cant spam it.\nAlso doesn\'t work past 200', function()
            if fixer_count_cooldown then JSlang.toast('Cooldown active') return end
            if util.is_session_transition_active() then JSlang.toast('You can only use this while in a session.') return end
            if STAT_GET_INT('FIXER_COUNT') >= 200 then JSlang.toast('You already reached 200 completions.') return end

            fixer_count_cooldown = true
            STAT_SET_INCREMENT('FIXER_COUNT', 1)
            util.yield(10)
            menu.trigger_commands('go soloPublic')
            util.yield(7000)
            fixer_count_cooldown = false
        end)

    -----------------------------------
    -- Property tp
    -----------------------------------
        -- warehouse = 473
        -- vehicle cargo = 524
        local propertyBlips = {
            [1] = { name = 'Ceo office',   sprite = 475 },
            [2] = { name = 'MC clubhouse', sprite = 492,
                subProperties = {listName = 'MC businesses', properties = {
                    [1] = { name = 'Weed farm',           sprite = 496 },
                    [2] = { name = 'Cocaine lockup',      sprite = 497 },
                    [3] = { name = 'Document forgery',    sprite = 498 },
                    [4] = { name = 'Methamphetamine Lab', sprite = 499 },
                    [5] = { name = 'Counterfeit cash',    sprite = 500 },
                }}
            },
            [3] = { name = 'Bunker',     sprite = 557 },
            [4] = { name = 'Hangar',     sprite = 569 },
            [5] = { name = 'Facility',   sprite = 590 },
            [6] = { name = 'Night club', sprite = 614 },
            [7] = { name = 'Arcade',     sprite = 740 },
            [8] = { name = 'Auto shop',  sprite = 779 },
            [9] = { name = 'Agency',     sprite = 826 },
        }

        local function getUserPropertyBlip(sprite)
            local blip = HUD.GET_FIRST_BLIP_INFO_ID(sprite)
            while blip ~= 0 do
                local blipColour = HUD.GET_BLIP_COLOUR(blip)
                if HUD.DOES_BLIP_EXIST(blip) and blipColour != 55 and blipColour != 3 then return blip end
                blip = HUD.GET_NEXT_BLIP_INFO_ID(sprite)
            end
        end

        local function tpToBlip(blip)
            local pos = HUD.GET_BLIP_COORDS(blip)
            local tpEntity = (PED.IS_PED_IN_ANY_VEHICLE(players.user_ped(), true) and my_cur_car or players.user_ped())
            ENTITY.SET_ENTITY_COORDS(tpEntity, pos.x, pos.y, pos.z, false, false, false, false)
        end

        local propertyTpRefs = {}
        local function regenerateTpLocations(root)
            for k, _ in pairs(propertyTpRefs) do
                menu.delete(propertyTpRefs[k])
                propertyTpRefs[k] = nil
            end
            for i = 1, #propertyBlips do
                local propertyBlip = getUserPropertyBlip(propertyBlips[i].sprite)
                if propertyBlip ~= nil then
                    propertyTpRefs[propertyBlips[i].name] = JSlang.action(root, propertyBlips[i].name, {}, '', function()
                        if not HUD.DOES_BLIP_EXIST(propertyBlip) then
                            JSlang.toast('Couldn\'t find property.')
                            return
                        end
                        tpToBlip(propertyBlip)
                    end)
                    if propertyBlips[i].subProperties then
                        local subProperties = propertyBlips[i].subProperties
                        local listName = subProperties.listName
                        propertyTpRefs[listName] = menu.list(root, listName, {}, '', function()end)
                        for j = 1, #subProperties.properties do
                            local propertyBlip = getUserPropertyBlip(subProperties.properties[j].sprite)
                            if propertyBlip ~= nil then
                                JSlang.action(propertyTpRefs[listName], subProperties.properties[j].name, {}, '', function() --no need to have refs to these because they get deleted with the sublist
                                    if not HUD.DOES_BLIP_EXIST(propertyBlip) then
                                        JSlang.toast('Couldn\'t find property.')
                                        return
                                    end
                                    tpToBlip(propertyBlip)
                                end)
                            end
                        end
                    end
                end
            end
        end

        local property_tp_list property_tp_list = JSlang.list(online_root, 'Property tp\'s', {'JSpropertyTp'}, 'Lets you teleport to the properties you own.', function()
            regenerateTpLocations(property_tp_list)
        end)

        propertyTpRefs['tmp'] = menu.action(property_tp_list, '', {}, '', function()end)

    ----------------------------------
    -- Casino
    ----------------------------------
        local casino_root = JSlang.list(online_root, 'Casino', {'JScasino'}, 'No theres no recoveries here.')

        local last_LW_seconds = 0
        JSlang.toggle_loop(casino_root, 'Lucky wheel cooldown', {'JSlwCool'}, 'Tells you if the lucky wheel is available or how much time is left until it is.', function()
            if STAT_GET_INT_MPPLY('mpply_lucky_wheel_usage') < util.current_unix_time_seconds() then JSlang.toast('Lucky wheel is available.') return end
            local secondsLeft = STAT_GET_INT_MPPLY('mpply_lucky_wheel_usage') - util.current_unix_time_seconds()
            local hours = math.floor(secondsLeft / 3600)
            local minutes = math.floor((secondsLeft / 60) % 60)
            local seconds = secondsLeft % 60
            if last_LW_seconds != seconds then
                util.toast((hours < 10 and ('0'.. hours) or hours) ..':'.. (minutes < 10 and ('0'.. minutes) or minutes) ..':'.. (seconds < 10 and ('0'.. seconds) or seconds))
                last_LW_seconds = seconds
            end
        end)

        JSlang.action(casino_root, 'Casino loss/profit', {'JScasinoLP'}, 'Tells you how much you made or lost in the casino.', function()
            local chips = STAT_GET_INT_MPPLY('mpply_casino_chips_won_gd')
            if chips > 0 then
                util.toast(JSlang.str_trans('You\'ve made') ..' '.. chips ..' '.. JSlang.str_trans('chips.'))
            elseif chips < 0 then
                util.toast(JSlang.str_trans('You\'ve lost') ..' '.. chips * -1 ..' '.. JSlang.str_trans('chips.'))
            else
                JSlang.toast('You haven\'t made or lost any chips.')
            end
        end)

    ----------------------------------
    -- Time trial
    ----------------------------------
        local tt_root = JSlang.list(online_root, 'Time trials', {'JStt'}, '')

        local function ttTimeToString(time)
            local min = math.floor(time / 60000)
            local sec = (time % 60000) / 1000
            return (min == 0 and '' or min ..'min ') .. sec ..'s'
        end

        JSlang.divider(tt_root, 'Time trial')

        JSlang.toggle_loop(tt_root, 'Best time trial time', {'JSbestTT'}, '', function()
            util.toast(JSlang.str_trans('Best Time') ..': '.. ttTimeToString((STAT_GET_INT_MPPLY('mpply_timetrialbesttime'))))
            util.yield(100)
        end)

        JSlang.action(tt_root, 'Teleport to time trial', {'JStpToTT'}, '', function()
            local ttBlip = HUD._GET_CLOSEST_BLIP_OF_TYPE(430)
            if not HUD.DOES_BLIP_EXIST(ttBlip) then
                JSlang.toast('Couldn\'t find time trial.')
                return
            end
            tpToBlip(ttBlip)
        end)

        JSlang.divider(tt_root, 'Rc time trial')

        JSlang.toggle_loop(tt_root, 'Best rc time trial time', {'JSbestRcTT'}, '', function()
            util.toast(JSlang.str_trans('Best Time') ..': '.. ttTimeToString(STAT_GET_INT_MPPLY('mpply_rcttbesttime')))
            util.yield(100)
        end)

        JSlang.action(tt_root, 'Teleport to rc time trial', {'JStpToRcTT'}, '', function()
            local ttBlip = HUD._GET_CLOSEST_BLIP_OF_TYPE(673)
            if not HUD.DOES_BLIP_EXIST(ttBlip) then
                JSlang.toast('Couldn\'t find rc time trial.')
                return
            end
            tpToBlip(ttBlip)
        end)

    ----------------------------------
    -- Block areas
    ----------------------------------
        local block_root = JSlang.list(online_root, 'Block areas', {'JSblock'}, 'Block areas in online with invisible walls, but if you over use it it will crash you lol.')

        local blockInProgress = false
        function blockAvailable(areaBlocked, areaName)
            if blockInProgress then JSlang.toast('A block is already being run.') return false end
            if areaBlocked then util.toast(JSlang.str_trans(areaName) ..' '.. JSlang.str_trans('is already blocked.')) return false end
            return true
        end

        function setBlockStatus(on, areaName)
            if on then
                blockInProgress = true
                startBusySpinner(JSlang.str_trans('Blocking'))
                return
            end
            HUD.BUSYSPINNER_OFF()
            if notifications then util.toast(JSlang.str_trans('Successfully blocked') ..' '.. JSlang.str_trans(areaName) ..'.') end
            blockInProgress = false
        end

        JSlang.toggle_loop(block_root, 'Custom block', {}, 'Makes you able to block an area in front of you by pressing "B".', function()
            local dir, c1 = direction()
            GRAPHICS._DRAW_SPHERE(c1.x, c1.y, c1.z, 0.3, 52, 144, 233, 0.5)
            if JSkey.is_key_down('VK_B') then
                if blockInProgress then JSlang.toast('A block is already being run.') return end
                setBlockStatus(true)
                block({c1.x, c1.y, c1.z - 0.6})
                setBlockStatus(false, 'area')
            end
        end)

        local block_lsc_root = JSlang.list(block_root, 'Block LSC', {'JSblockLSC'}, 'Block lsc from being accessed.')
        local block_casino_root = JSlang.list(block_root, 'Block casino', {'JSblockCasino'}, 'Block casino from being accessed.')
        local block_maze_root = JSlang.list(block_root, 'Block maze bank', {'JSblockCasino'}, 'Block maze bank from being accessed.')

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
            menu.action(blockAreasActions[i].root, JSlang.str_trans('Block') ..' '.. JSlang.str_trans(areaName), {}, '', function ()
                if not blockAvailable(blockAreasActions[i].blocked, (JSlang.str_trans(areaName) == JSlang.str_trans('LSIA') and areaName or string.capitalize(areaName))) then return end
                setBlockStatus(true)
                blockAreasActions[i].blocked = true
                for j = 1, #blockAreasActions[i].coordinates do
                    block(blockAreasActions[i].coordinates[j])
                end
                setBlockStatus(false, areaName)
            end)
        end

-----------------------------------
-- Players options
-----------------------------------
    local players_root = JSlang.list(menu_root, 'Players', {'JSplayers'}, '')

    -----------------------------------
    -- Whitelist
    -----------------------------------
        local whitelist_settings_root = JSlang.list(players_root, 'Whitelist', {'JSwhitelist'}, 'Applies to most options in this section.')

        JSlang.toggle(whitelist_settings_root, 'Exclude self', {'JSWhitelistSelf'}, 'Will make you not explode yourself. Pretty cool option if you ask me ;P', function(toggle)
            whitelistGroups.user = not toggle
        end)

        JSlang.toggle(whitelist_settings_root, 'Exclude friends', {'JSWhitelistFriends'}, 'Will make you not explode your friends... if you have any. (;-;)', function(toggle)
            whitelistGroups.friends = not toggle
        end)

        JSlang.toggle(whitelist_settings_root, 'Exclude strangers', {'JSWhitelistStrangers'}, 'If you only want to explode your friends I guess.', function(toggle)
            whitelistGroups.strangers = not toggle
        end)

        JSlang.text_input(whitelist_settings_root, 'Whitelist player', {'JSWhitelistPlayer'}, 'Lets you whitelist a single player by name.', function(input)
            whitelistedName = input
        end, '')

        local whitelist_list_root = JSlang.list(whitelist_settings_root, 'Whitelist player list', {'JSwhitelistList'}, 'Custom player list for selecting  players you wanna whitelist.')

        local whitelistTogglesTable = {}
        players.on_join(function(pid)
            local playerName = players.get_name(pid)
            whitelistTogglesTable[pid] = menu.toggle(whitelist_list_root, playerName, {'JSwhitelist'.. playerName}, JSlang.str_trans('Whitelist') ..' '.. playerName ..' '.. JSlang.str_trans('from options that affect all players.'), function(toggle)
                if toggle then
                    whitelistListTable[pid] = pid
                    if notifications then
                        util.toast(JSlang.str_trans('Whitelisted') ..' '.. playerName)
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

    -----------------------------------
    -- Anti chat spam
    -----------------------------------
        local anti_spam_root = JSlang.list(players_root, 'Anti chat spam', {}, '')

        local chatSpamSettings = {
            enabled = false,
            ignoreTeam = true,
            identicalMessages = 5,
        }
        local messageTable = {}
        chat.on_message(function(pid, message_sender, text, team_chat)
            if pid == players.user() then return end
            if not chatSpamSettings.enabled then return end
            if team_chat and chatSpamSettings.ignoreTeam then return end

            if messageTable[pid] == nil then
                messageTable[pid] = {}
            end

            local messageCount = (#messageTable[pid] != nil and #messageTable[pid] or 0)
            messageTable[pid][messageCount + 1] = text

            if #messageTable[pid] < chatSpamSettings.identicalMessages then return end
            for i = 1, #messageTable[pid] - 1 do
                if messageTable[pid][#messageTable[pid]] != messageTable[pid][#messageTable[pid] - i] then
                    messageTable[pid] = {}
                    return
                end
                if i == #messageTable[pid] - 1 then
                    menu.trigger_commands('kick'.. players.get_name(pid))
                    util.toast(JSlang.str_trans('Kicked') ..' '.. players.get_name(pid) ..' '.. JSlang.str_trans('for chat spam.'))
                end
            end
        end)

        JSlang.toggle(anti_spam_root, 'Anti chat spam', {'JSantiChatSpam'}, 'Kicks people if they spam chat.', function(toggle)
            chatSpamSettings.enabled = toggle
        end)

        JSlang.toggle(anti_spam_root, 'Ignore team chat', {'JSignoreTeamSpam'}, '', function(toggle)
            chatSpamSettings.enabled = toggle
        end, chatSpamSettings.ignoreTeam)

        JSlang.slider(anti_spam_root, 'Identical messages', {'JSidenticalChatMessages'}, 'How many identical chat messages a player can send before getting kicked.', 2, 9999, chatSpamSettings.identicalMessages, 1, function(value)
            chatSpamSettings.identicalMessages = value
        end)

    -----------------------------------
    -- Explosions
    -----------------------------------
    JSlang.action(players_root, 'Explode all', {'JSexplodeAll'}, 'Makes everyone explode.', function()
            local playerList = getNonWhitelistedPlayers(whitelistListTable, whitelistGroups, whitelistedName)
            for _, pid in pairs(playerList) do
                local playerPed = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
                explodePlayer(playerPed, false, expSettings)
            end
        end)

        explodeLoopAll = JSlang.toggle_loop(players_root, 'Explode all loop', {'JSexplodeAllLoop'}, 'Constantly explodes everyone.', function()
            local playerList = getNonWhitelistedPlayers(whitelistListTable, whitelistGroups, whitelistedName)
            for _, pid in pairs(playerList) do
                local playerPed = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
                explodePlayer(playerPed, true, expSettings)
            end
            util.yield(getTotalDelay(expLoopDelay))
        end)
    -----------------------------------

    --clockwise (like the clock is laying on the floor with face upwards) from the left when entering the room
    local orbitalTableCords = {
        [1] = { x = 330.48312, y = 4827.281, z = -59.368515 },
        [2] = { x = 327.5724,  y = 4826.48,  z = -59.368515 },
        [3] = { x = 325.95273, y = 4828.985, z = -59.368515 },
        [4] = { x = 327.79208, y = 4831.288, z = -59.368515 },
        [5] = { x = 330.61765, y = 4830.225, z = -59.368515 },
    }
    JSlang.toggle_loop(players_root, 'Orbital cannon detection', {'JSorbDetection'}, 'Tells you when anyone starts using the orbital cannon', function()
        local playerList = players.list(false, true, true)
        for i = 1, #playerList do
            local ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(playerList[i])
            if TASK.GET_IS_TASK_ACTIVE(ped, 135) and ENTITY.GET_ENTITY_SPEED(ped) == 0 then
                local pos = NETWORK._NETWORK_GET_PLAYER_COORDS(playerList[i])
                for j = 1, #orbitalTableCords do
                    if roundDecimals(pos.x, 1) == roundDecimals(orbitalTableCords[j].x, 1) and roundDecimals(pos.y, 1) == roundDecimals(orbitalTableCords[j].y, 1) and roundDecimals(pos.z, 1) == roundDecimals(orbitalTableCords[j].z, 1) then
                        util.toast(players.get_name(playerList[i]) ..' '.. JSlang.str_trans('is using the orbital cannon'))
                    end
                end
            end
        end
    end)

    -----------------------------------
    -- Coloured otr reveal
    -----------------------------------
        local coloured_otr_root = JSlang.list(players_root, 'Coloured otr reveal', {}, '')

        local markedPlayers = {}
        local otrBlipColour = 58
        JSlang.toggle_loop(coloured_otr_root, 'Coloured otr reveal', {'JScolouredOtrReveal'}, 'Marks otr players with coloured blips.', function()
            local playerList = players.list(false, true, true)
            for i, pid in pairs(playerList) do
                if players.is_otr(pid) and not markedPlayers[pid] then
                    local ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
                    markedPlayers[pid] = HUD.ADD_BLIP_FOR_ENTITY(ped)
                    HUD.SET_BLIP_COLOUR(markedPlayers[pid], otrBlipColour)
                    HUD.SHOW_HEADING_INDICATOR_ON_BLIP(markedPlayers[pid], true)
                elseif players.is_otr(pid) then
                    HUD.SET_BLIP_COLOUR(markedPlayers[pid], otrBlipColour)
                elseif not players.is_otr(pid) and markedPlayers[pid] then
                    util.remove_blip(markedPlayers[pid])
                    markedPlayers[pid] = nil
                end
            end
        end, function()
            local playerList = players.list(false, true, true)
            for i, pid in pairs(playerList) do
                if markedPlayers[pid] then
                    util.remove_blip(markedPlayers[pid])
                    markedPlayers[pid] = nil
                end
            end
        end)

        local otr_colour_slider = JSlang.slider(coloured_otr_root, 'otr reveal colour', {'JSortRevealColour'}, '',1, 81, otrBlipColour, 1, function(value)
            otrBlipColour = value + (value > 71 and 1 or 0) + (value > 77 and 2 or 0)
        end)

        JSlang.toggle_loop(coloured_otr_root, 'Otr rgb reveal', {'JSortRgbReveal'}, '', function()
            menu.trigger_command(otr_colour_slider, (otrBlipColour == 84 and 1 or otrBlipColour + 1))
            util.yield(250)
        end)

    -----------------------------------
    -- Vehicle
    -----------------------------------
        local players_veh_root = JSlang.list(players_root, 'Vehicles', {'JSplayersVeh'}, 'Do stuff to all players vehicles.')

        JSlang.toggle(players_veh_root, 'Lock burnout', {'JSlockBurnout'}, 'Locks all player cars in burnout.', function(toggle)
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
        JSlang.slider(players_veh_root, 'Set torque', {'JSsetAllTorque'}, 'Modifies the speed of all player vehicles.', -1000000, 1000000, all_torque, 1, function(value)
            all_torque = value
            util.create_tick_handler(function()
                local playerList = getNonWhitelistedPlayers(whitelistListTable, whitelistGroups, whitelistedName)
                for k, playerPid in ipairs(playerList) do
                    local playerPed = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(playerPid)
                    if PED.IS_PED_IN_ANY_VEHICLE(playerPed, true) then
                        local playerVehicle = PED.GET_VEHICLE_PED_IS_IN(playerPed, false)
                        NETWORK.NETWORK_REQUEST_CONTROL_OF_ENTITY(playerVehicle)
                        VEHICLE.SET_VEHICLE_CHEAT_POWER_INCREASE(playerVehicle, all_torque / 1000)
                    end
                end
                return (all_torque != 1000)
            end)
        end)

        JSlang.toggle(players_veh_root, 'Force surface all subs', {'JSforceSurfaceAll'}, 'Forces all Kosatkas to the surface.\nNot compatible with the whitelist.', function(toggle)
            local vehHandles = entities.get_all_vehicles_as_handles()
            local surfaced = 0
            for i = 1, #vehHandles do
                if ENTITY.GET_ENTITY_MODEL(vehHandles[i]) == 1336872304 then -- if Kosatka
                    VEHICLE.FORCE_SUBMARINE_SURFACE_MODE(vehHandles[i], toggle)
                    surfaced += 1
                end
            end
            if toggle and notifications then util.toast(JSlang.str_trans('Surfaced') ..' '.. surfaced ..' ' .. JSlang.str_trans('submarines.')) end
        end)
    -----------------------------------


    JSlang.toggle_loop(players_root, 'No fly zone', {'JSnoFly'}, 'Forces all players in air born vehicles into the ground.', function()
        local playerList = getNonWhitelistedPlayers(whitelistListTable, whitelistGroups, whitelistedName)
        for _, pid in pairs(playerList) do
            local playerPed = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
            local playerVehicle = PED.GET_VEHICLE_PED_IS_IN(playerPed, false)
            if ENTITY.IS_ENTITY_IN_AIR(playerVehicle) then
                NETWORK.NETWORK_REQUEST_CONTROL_OF_ENTITY(playerVehicle)
                ENTITY.APPLY_FORCE_TO_ENTITY(playerVehicle, 1, 0, 0, -0.8, 0, 0, 0.5, 0, false, false, true)
                if notifications then
                    JSlang.toast('Applied force')
                end
            end
        end
    end)

    JSlang.toggle_loop(players_root, 'Shoot gods', {'JSshootGods'}, 'Disables godmode for other players when aiming at them. Mostly works on trash menus.', function()
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
        local aim_karma_root = JSlang.list(players_root, 'Aim karma', {'JSaimKarma'}, 'Do stuff to players that aim at you.')

        local karma = {}
        function playerIsTargetingEntity(playerPed)
            local playerList = getNonWhitelistedPlayers(whitelistListTable, whitelistGroups, whitelistedName)
            for k, playerPid in pairs(playerList) do
                if PLAYER.IS_PLAYER_TARGETTING_ENTITY(playerPid, playerPed) or PLAYER.IS_PLAYER_FREE_AIMING_AT_ENTITY(playerPid, playerPed) then
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

        JSlang.toggle_loop(aim_karma_root, 'Shoot', {'JSbulletAimKarma'}, 'Shoots players that aim at you.', function()
            local userPed = players.user_ped()
            if playerIsTargetingEntity(userPed) and karma[userPed] then
                local pos = ENTITY.GET_ENTITY_COORDS(karma[userPed].ped)
                MISC.SHOOT_SINGLE_BULLET_BETWEEN_COORDS(pos.x, pos.y, pos.z, pos.x, pos.y, pos.z + 0.1, 100, true, 100416529, userPed, true, false, 100.0)
                util.yield(getTotalDelay(expLoopDelay))
            end
        end)

        JSlang.toggle_loop(aim_karma_root, 'Explode', {'JSexpAimKarma'}, 'Explodes the player with your custom explosion settings.', function()
            local userPed = players.user_ped()
            if playerIsTargetingEntity(userPed) and karma[userPed] then
                explodePlayer(karma[userPed].ped, true, expSettings)
            end
        end)

        JSlang.toggle_loop(aim_karma_root, 'Disable godmode', {'JSgodAimKarma'}, 'If a god mode player aims at you this disables their god mode by pushing their camera forwards.', function()
            local userPed = players.user_ped()
            if playerIsTargetingEntity(userPed) and karma[userPed] and players.is_godmode(karma[userPed].pid) then
                local karmaPid = karma[userPed].pid
                util.trigger_script_event(1 << karmaPid, {801199324, karmaPid, 869796886})
            end
        end)

        local stand_player_aim_punish =  menu.ref_by_path('World>Inhabitants>Player Aim Punishments>Anonymous Explosion', 34)
        JSlang.action(aim_karma_root, 'Stands player aim punishments', {}, 'Link to stands player aim punishments.', function()
            menu.focus(stand_player_aim_punish)
        end)

-----------------------------------
-- World
-----------------------------------
    local world_root = JSlang.list(menu_root, 'World', {'JSworld'}, '')

    local setClockCommand = menu.ref_by_path('World>Atmosphere>Clock>Time', 34)
    local smoothTransitionCommand = menu.ref_by_path('World>Atmosphere>Clock>Smooth Transition', 34)
    JSlang.toggle(world_root, 'irl time', {'JSirlTime'}, 'Makes the in game time match your irl time. Disables stands "Smooth Transition".', function(toggle)
        irlTime = toggle
        if menu.get_value(smoothTransitionCommand) then menu.trigger_command(smoothTransitionCommand) end
        util.create_tick_handler(function()
            menu.trigger_command(setClockCommand, os.date('%H:%M:%S'))
            return irlTime
        end)
    end)

    local numpadControls = {
        -- plane
            107,
            108,
            109,
            110,
            111,
            112,
            117,
            118,
        --sub
            123,
            124,
            125,
            126,
            127,
            128,
    }
    JSlang.toggle_loop(world_root, 'Disable numpad', {'JSdisableNumpad'}, 'Disables numpad so you don\'t rotate your plane/submarine while navigating stand', function()
        for _, control in pairs(numpadControls) do
            PAD.DISABLE_CONTROL_ACTION(2, control, true)
        end
    end)

    local mapZoom = 83
    JSlang.slider(world_root, 'Map zoom level', {'JSmapZoom'}, '', 1, 100, mapZoom, 1, function(value)
        mapZoom = 83
        mapZoom = value
        util.create_tick_handler(function()
            HUD.SET_RADAR_ZOOM_PRECISE(mapZoom)
            return mapZoom != 83
        end)
    end)

    JSlang.toggle(world_root, 'Enable footsteps', {'JSfootSteps'}, 'Enables foot prints on all surfaces.', function(toggle)
        GRAPHICS._SET_FORCE_PED_FOOTSTEPS_TRACKS(toggle)
    end)

    JSlang.toggle(world_root, 'Enable vehicle trails', {'JSvehicleTrails'}, 'Enables vehicle trails on all surfaces.', function(toggle)
        GRAPHICS._SET_FORCE_VEHICLE_TRAILS(toggle)
    end)

    JSlang.toggle_loop(world_root, 'Disable all map notifications', {'JSnoMapNotifications'}, 'Removes that constant spam.', function()
        HUD.THEFEED_HIDE_THIS_FRAME()
    end)

    -----------------------------------
    -- Trains
    -----------------------------------
        local trains_root = JSlang.list(world_root, 'Trains', {'JStrains'}, '')

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
        JSlang.toggle(trains_root, 'Derail trains', {'JSderail'}, 'Derails and stops all trains.', function(toggle)
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

        JSlang.action(trains_root, 'Delete trains', {'JSdeleteTrain'}, 'Just becurse every script has train options, I gotta have an anti train option.', function()
            VEHICLE.DELETE_ALL_TRAINS()
        end)

        local markedTrains = {}
        JSlang.toggle_loop(trains_root, 'Mark nearby trains', {'JSnoMapNotifications'}, 'Marks nearby trains with purple blips.', function()
            local vehHandles = entities.get_all_vehicles_as_handles()
            for i = 0, #vehHandles do
                if VEHICLE.GET_VEHICLE_CLASS(vehHandles[i]) == 21 then
                    for j = 0, #markedTrains do
                        if vehHandles[i] == markedTrains[j] then goto continue end
                    end
                    if notifications then
                        JSlang.toast('Marked train')
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
        local peds_root = JSlang.list(world_root, 'Peds', {'JSpeds'}, '')

        local pedToggleLoops = {
            {name = 'Ragdoll peds', command = 'JSragdollPeds', description = 'Makes all nearby peds fall over lol.', action = function(ped)
                if PED.IS_PED_A_PLAYER(ped) then return end
                PED.SET_PED_TO_RAGDOLL(ped, 2000, 2000, 0, true, true, true)
                -- PED.RESET_PED_RAGDOLL_TIMER(ped)
            end},
            {name = 'Death\'s touch', command = 'JSdeathTouch', description = 'Kills peds that touches you.', action = function(ped)
                if PED.IS_PED_A_PLAYER(ped) or PED.IS_PED_IN_ANY_VEHICLE(ped, true) or not ENTITY.IS_ENTITY_TOUCHING_ENTITY(ped, players.user_ped()) then return end
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
                local rel = PED.GET_RELATIONSHIP_BETWEEN_PEDS(players.user_ped(), ped)
                if PED.IS_PED_A_PLAYER(ped) or ENTITY.IS_ENTITY_DEAD(ped) or not( (rel == 4 or rel == 5) or PED.IS_PED_IN_COMBAT(ped, players.user_ped()) ) then return end
                ENTITY.SET_ENTITY_HEALTH(ped, 0, 0)
            end},
        }
        for i = 1, #pedToggleLoops do
            JSlang.toggle_loop(peds_root, pedToggleLoops[i].name, {pedToggleLoops[i].command}, pedToggleLoops[i].description, function()
                local pedHandles = entities.get_all_peds_as_handles()
                for j = 1, #pedHandles do
                    pedToggleLoops[i].action(pedHandles[j])
                end
                util.yield(10)
            end, function()
                if pedToggleLoops[i].onStop then pedToggleLoops[i].onStop() end
            end)
        end

        JSlang.toggle_loop(peds_root, 'Kill jacked peds', {'JSkillJackedPeds'}, 'Automatically kills peds when stealing their car.', function(toggle)
            if not PED.IS_PED_JACKING(players.user_ped()) then return end
            local jackedPed = PED.GET_JACK_TARGET(players.user_ped())
            util.yield(100)
            ENTITY.SET_ENTITY_HEALTH(jackedPed, 0, 0)
        end)

        JSlang.toggle(peds_root, 'Riot mode', {'JSriot'}, 'Makes peds hostile.', function(toggle)
            MISC.SET_RIOT_MODE_ENABLED(toggle)
        end)


JSlang.hyperlink(menu_root, 'Join the discord server', 'https://discord.gg/QzqBdHQC9S', 'Join the JerryScript discord server to suggest features, report bugs and test upcoming features.')

local JS_logo = directx.create_texture(filesystem.resources_dir() ..'JS.png')

local black = new.colour(0, 0, 1 / 255, 1)
local white = new.colour(1, 1, 1, 1)
local creditText = {
    [1]  = {line = JSlang.str_trans('Coded by') ..' Jerry123#4508', bold = true, wait = 85},
    [2]  = {line = JSlang.str_trans('Some contributions made by'), bold = false, wait = 25},
    [3]  = {line = 'scriptcat#6566', bold = true, wait = 120},

    [4]  = {line = JSlang.str_trans('Skids from:'), bold = true, wait = 35},
    [5]  = {line = 'LanceScript '.. JSlang.str_trans('by') ..' lance#8213', bold = false, wait = 25},
    [6]  = {line = 'WiriScript '.. JSlang.str_trans('by') ..' Nowiry#2663', bold = false, wait = 25},
    [7]  = {line = 'KeramisScript '.. JSlang.str_trans('by') ..' scriptCat#6566', bold = false, wait = 25},
    [8]  = {line = 'Heist control '.. JSlang.str_trans('by') ..' IceDoomfist#0001', bold = false, wait = 25},
    [9]  = {line = 'Meteor '.. JSlang.str_trans('by') ..' RulyPancake the 4th#1157', bold = false, wait = 100},

    [10] = {line = JSlang.str_trans('Thanks to'), bold = false, wait = 25},
    [11] = {line = 'Ren#5219 and JayMontana36#9565', bold = true, wait = 35},
    [12] = {line = JSlang.str_trans('for reviewing my code'), bold = false, wait = 100},

    [13] = {line = JSlang.str_trans('Big thanks to all the cool people who helped me in #programming in the stand discord'), bold = false, wait = 25},
    [14] = {line = 'Sapphire#1053', bold = false, wait = 25},
    [15] = {line = 'aaronlink127#0127', bold = false, wait = 25},
    [16] = {line = 'Fwishky#4980', bold = false, wait = 100},

    [17] = {line = 'Goddess Sainan#0001', bold = true, wait = 25},
    [18] = {line = JSlang.str_trans('For making stand and providing such a great api and documentation'), bold = false, wait = 25},
}
local playingCredits = false
local creditsSpeed = 1
local play_credits_toggle
local function creditsPlaying(toggle)
    playingCredits = toggle
    menu.trigger_commands('anticrashcam '.. (toggle and 'on' or 'off'))
    util.create_tick_handler(function()
        directx.draw_rect(0, 0, 1, 1, black)
        directx.draw_texture(JS_logo, 0.25, 0.25, 0.5, 0.5, 0.14, 0.5, 0 , white)
        if (JSkey.is_key_down('VK_ESCAPE') or JSkey.is_key_down('VK_BACK')) and playingCredits then menu.trigger_command(play_credits_toggle, 'off') end
        creditsSpeed = (JSkey.is_key_down('VK_SPACE') and 2.5 or 1)
        HUD.HUD_FORCE_WEAPON_WHEEL(false)
        return playingCredits
    end)
    util.yield(900)
    AUDIO.SET_RADIO_FRONTEND_FADE_TIME(3)
    AUDIO.SET_AUDIO_FLAG('MobileRadioInGame',toggle)
    AUDIO.SET_FRONTEND_RADIO_ACTIVE(toggle)
    AUDIO.SET_RADIO_STATION_MUSIC_ONLY('RADIO_18_90S_ROCK', true)
    AUDIO.SET_RADIO_TO_STATION_NAME('RADIO_16_SILVERLAKE')
    AUDIO._FORCE_RADIO_TRACK_LIST_POSITION("RADIO_16_SILVERLAKE", "MIRRORPARK_LOCKED", 3 * 61000)
end
local function scrollCreditsLine(textTable, index)
    local i = 0
    while i <= 1000 do
        if not playingCredits then return end
        i += creditsSpeed
        directx.draw_text(0.5, 1  - i / 1000, textTable.line, 1, textTable.bold and  0.7 or 0.5, white, false)
        util.yield()
    end
    if index == #creditText then
        for i = 0, 500 do
            directx.draw_text(0.5, 0.5, JSlang.str_trans('And thank you') ..' '.. players.get_name(players.user()) ..' '.. JSlang.str_trans('for using JerryScript'), 1, 0.7, white, false)
            util.yield()
        end
        util.yield(750)
        menu.trigger_command(play_credits_toggle, 'off')
    end
end
play_credits_toggle = JSlang.toggle(menu_root, 'Play credits', {}, '', function(toggle)
    creditsPlaying(toggle)
    if not toggle then return end
    for i = 1, #creditText do
        if not playingCredits then return end
        util.create_thread(function()
            scrollCreditsLine(creditText[i], i)
        end)
        local wait = 0
        while wait < creditText[i].wait / creditsSpeed do -- i determine the line spacing is by this wait so i have to constantly check if credits are speed up to not fuck it up
            util.yield(1)
            wait += 1
        end
    end
end)


local playerInfoPid = nil
local playerInfoTogglesTable = {}
local runningTogglingOff = false
----------------------------------
-- Player options
----------------------------------
    players.on_join(function(pid)
        JSlang.divider(menu.player_root(pid), 'JerryScript') --added a divider here because Holy#9756 was bitching about it in vc
        local player_root = JSlang.list(menu.player_root(pid), 'JS player options')
        local playerPed = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
        local playerName = players.get_name(pid)

        ----------------------------------
        -- Player info toggle
        ----------------------------------
            playerInfoTogglesTable[pid] = JSlang.toggle(player_root, 'Player info', {'JSplayerInfo'}, 'Display information about this player.', function(toggle)
                if not runningTogglingOff then
                    if toggle then
                        runningTogglingOff = true
                        local playerList = players.list(true, true, true)
                        for i, playerPid in pairs(playerList) do
                            if menu.get_value(playerInfoTogglesTable[playerPid]) and not (playerInfoTogglesTable[playerPid] == playerInfoTogglesTable[pid]) then
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

        -----------------------------------
        -- Trolling
        -----------------------------------
            local trolling_root = JSlang.list(player_root, 'Trolling', {'JStrolling'}, '')

            JSlang.action(trolling_root, 'Explode player', {'JSexplode'}, 'Explodes this player with your selected options.', function()
                explodePlayer(playerPed, false, expSettings)
            end)

            JSlang.toggle_loop(trolling_root, 'Explode loop player', {'JSexplodeLoop'}, 'Loops explosions on them with your selected options.', function()
                explodePlayer(playerPed, true, expSettings)
                util.yield(getTotalDelay(expLoopDelay))
                if not players.exists(pid) then util.stop_thread() end
            end)

            JSlang.action(trolling_root, 'Blame explosions', {'JSexpBlame'}, 'Makes your explosions blamed on them.', function()
                expSettings.blamedPlayer = pid
                if not menu.get_value(exp_blame_toggle) then
                    menu.trigger_command(exp_blame_toggle)
                end
                menu.set_menu_name(exp_blame_toggle, JSlang.str_trans('Blame') ..': '.. playerName)
            end)

            local damage_root = JSlang.list(trolling_root, 'Damage', {}, '')

            JSlang.action(damage_root, 'Primed grenade', {'JSprimedGrenade'}, 'Spawns a grenade on top of them.', function()
                local pos = players.get_position(pid)
                MISC.SHOOT_SINGLE_BULLET_BETWEEN_COORDS(pos.x, pos.y, pos.z + 1.4, pos.x, pos.y, pos.z + 1.3, 100, true, -1813897027, players.user_ped(), true, false, 100.0)
            end)

            JSlang.action(damage_root, 'Sticky', {'JSsticky'}, 'Spawns a sticky bomb on them that might stick to their vehicle and you can detonate by pressing "G".', function()
                local pos = players.get_position(pid)
                MISC.SHOOT_SINGLE_BULLET_BETWEEN_COORDS(pos.x, pos.y, pos.z + 1 , pos.x, pos.y, pos.z + 1.1, 10, true, 741814745, players.user_ped(), true, false, 100.0)
            end)

            JSlang.toggle_loop(trolling_root, 'Undetected money drop 2022', {'JSfakeMoneyDrop'}, 'Drops money bags that wont give any money.', function()
                util.create_thread(function()
                    local hash = 2628187989
                    loadModel(hash)
                    local pos = players.get_position(pid)
                    pos.x += math.random(-2, 2) / 10
                    pos.y += math.random(-2, 2) / 10
                    pos.z += math.random(13, 14) / 10
                    local money = entities.create_object(hash, pos)
                    ENTITY.APPLY_FORCE_TO_ENTITY(money, 3, 0, 0, -0.5, 0.0, 0.0, 0.0, true, true)
                    while not ENTITY.HAS_ENTITY_COLLIDED_WITH_ANYTHING(money) do
                        util.yield()
                    end
                    AUDIO.PLAY_SOUND_FROM_COORD(-1, 'LOCAL_PLYR_CASH_COUNTER_COMPLETE', pos.x, pos.y, pos.z, 'DLC_HEISTS_GENERAL_FRONTEND_SOUNDS', true, 2, false)
                    entities.delete(money)
                end)
            end)

            --made by scriptcat#6566 ;) || requested by Erstarisk#5763
            local yeetMultiplier = 5
            local yeetRange = 100
            local stormDelay = new.delay(250, 0, 0)
            local function yeetEntities()
                local targetPos = players.get_position(pid)
                local pointerTables = {
                    entities.get_all_peds_as_pointers(),
                    entities.get_all_vehicles_as_pointers()
                }
                local range = yeetRange * yeetRange --squaring it, for VDIST2
                for _, pointerTable in pairs(pointerTables) do
                    for _, entityPointer in pairs(pointerTable) do
                        local entityPos = entities.get_position(entityPointer)
                        local distance = v3.distance(targetPos, entityPos)
                        if distance < range then
                            local entityHandle = entities.pointer_to_handle(entityPointer)
                            --check the entity is a ped in a car
                            if (ENTITY.IS_ENTITY_A_PED(entityHandle) and (not PED.IS_PED_IN_ANY_VEHICLE(entityHandle, true) and (not PED.IS_PED_A_PLAYER(entityHandle)))) or (not ENTITY.IS_ENTITY_A_PED(entityHandle))--[[for the vehicles]] then
                                local playerList = players.list(true, true, true)
                                if not ENTITY.IS_ENTITY_A_PED(entityHandle) then
                                    for _, pid in pairs(playerList) do
                                        local ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
                                        if PED.GET_VEHICLE_PED_IS_IN(ped, false) == entityHandle then goto continue end --if the entity is a players car ignore it
                                    end
                                end
                                local localTargetPos = players.get_position(pid)
                                NETWORK.NETWORK_REQUEST_CONTROL_OF_ENTITY(entityHandle)
                                v3.sub(localTargetPos, entityPos) --subtract here, for launch.
                                ENTITY.APPLY_FORCE_TO_ENTITY_CENTER_OF_MASS(entityHandle, 1, v3.getX(localTargetPos) * yeetMultiplier, v3.getY(localTargetPos) * yeetMultiplier, v3.getZ(localTargetPos) * yeetMultiplier, true, false, true, true)
                                ::continue::
                            end
                        end
                    end
                end
            end

            JSlang.action(trolling_root, 'Entity YEET', {'JSentityYeet'}, 'Pushes all peds and vehicles near them.. into them ;)\nRequires you to be near them or spectating them.', function ()
                yeetEntities()
            end)

            JSlang.toggle_loop(trolling_root, 'Entity Storm', {'JSentityStorm'}, 'Constantly pushes all peds and vehicles near them.. into them :p\nRequires you to be near them or spectating them.', function ()
                yeetEntities()
                util.yield(getTotalDelay(stormDelay))
                if not players.exists(pid) then util.stop_thread() end
            end)

            JSlang.slider(trolling_root, 'Range for YEET/Storm', {'JSpushRange'}, 'How close nearby entities have to be to get pushed the targeted player.', 1, 1000, yeetRange, 10, function (value)
                yeetRange = value
            end)

            JSlang.slider(trolling_root, 'Multiplier for YEET/Storm', {'JSpushMultiplier'}, 'Multiplier for how much force is applied to entities when they get pushed towards them.', 1, 1000, yeetMultiplier, 5, function(value)
                yeetMultiplier = value
            end)

            local strom_delay_root = menu.list(trolling_root, JSlang.str_trans('Storm delay') ..': '.. getDelayDisplayValue(stormDelay), {'JSentStormDelay'}, JSlang.str_trans('Lets you set the delay for how often entities are pushed in entity storm.'))
            generateDelaySettings(strom_delay_root, JSlang.str_trans('Storm delay'), stormDelay)
        -----------------------------------

        JSlang.toggle_loop(player_root, 'Give shoot gods', {'JSgiveShootGods'}, 'Grants this player the ability to disable players god mode when shooting them.', function()
            local playerList = getNonWhitelistedPlayers(whitelistListTable, whitelistGroups, whitelistedName)
            for k, playerPid in ipairs(playerList) do
                local playerPed = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(playerPid)
                if (PLAYER.IS_PLAYER_FREE_AIMING_AT_ENTITY(pid, playerPed) or PLAYER.IS_PLAYER_FREE_AIMING_AT_ENTITY(pid, playerPed)) and players.is_godmode(playerPid) then
                    util.trigger_script_event(1 << playerPid, {801199324, playerPid, 869796886})
                end
            end
            if not players.exists(pid) then util.stop_thread() end
        end)

        JSlang.toggle_loop(player_root, 'Give horn boost', {'JSgiveHornBoost'}, 'Gives them the ability to speed up their car by pressing honking their horn or activating the siren.', function()
            local vehicle = PED.GET_VEHICLE_PED_IS_IN(playerPed, false)
            if not (AUDIO.IS_HORN_ACTIVE(vehicle) or VEHICLE.IS_VEHICLE_SIREN_ON(vehicle)) then return end
            NETWORK.NETWORK_REQUEST_CONTROL_OF_ENTITY(vehicle)
            if AUDIO.IS_HORN_ACTIVE(vehicle) then
                ENTITY.APPLY_FORCE_TO_ENTITY_CENTER_OF_MASS(vehicle, 1, 0.0, 1.0, 0.0, true, true, true, true)
            end
            if not players.exists(pid) then util.stop_thread() end
        end)

        -----------------------------------
        -- Give aim karma
        -----------------------------------
            local give_karma_root = JSlang.list(player_root, 'Give aim karma', {'JSgiveAimKarma'}, 'Allows you to to stuff to players who target this player.')

            --dosnt work on yourself
            JSlang.toggle_loop(give_karma_root, 'Shoot', {'JSgiveBulletAimKarma'}, 'Shoots players that aim at them.', function()
                if playerIsTargetingEntity(playerPed) and karma[playerPed] then
                    local pos = ENTITY.GET_ENTITY_COORDS(karma[playerPed].ped)
                    MISC.SHOOT_SINGLE_BULLET_BETWEEN_COORDS(pos.x, pos.y, pos.z, pos.x, pos.y, pos.z +0.1, 100, true, 100416529, players.user_ped(), true, false, 100.0)
                    util.yield(getTotalDelay(expLoopDelay))
                end
            end)

            JSlang.toggle_loop(give_karma_root, 'Explode', {'JSgiveExpAimKarma'}, 'Explosions with your custom explosion settings.', function()
                if playerIsTargetingEntity(playerPed) and karma[playerPed] then
                    explodePlayer(karma[playerPed].ped, true, expSettings)
                end
                if not players.exists(pid) then util.stop_thread() end
            end)

            JSlang.toggle_loop(give_karma_root, 'Disable godmode', {'JSgiveGodAimKarma'}, 'If a god mode player aims at them this disables the aimers god mode by pushing their camera forwards.', function()
                if playerIsTargetingEntity(playerPed) and karma[playerPed] and players.is_godmode(karma[playerPed].pid) then
                    util.trigger_script_event(1 << karma[playerPed].pid, {801199324, karma[playerPed].pid, 869796886})
                end
                if not players.exists(pid) then util.stop_thread() end
            end)

        ----------------------------------
        -- Vehicle
        ----------------------------------
            local player_veh_root = JSlang.list(player_root, 'Vehicle')

            JSlang.toggle(player_veh_root, 'Lock burnout', {'JSlockBurnout'}, 'Locks their car in a burnout.', function(toggle)
                if PED.IS_PED_IN_ANY_VEHICLE(playerPed, true) then
                    local playerVehicle = PED.GET_VEHICLE_PED_IS_IN(playerPed, false)
                    NETWORK.NETWORK_REQUEST_CONTROL_OF_ENTITY(playerVehicle)
                    VEHICLE.SET_VEHICLE_BURNOUT(playerVehicle, toggle)
                end
            end)

            local player_torque = 1000
            JSlang.slider(player_veh_root, 'Set torque', {'JSsetTorque'}, 'Modifies the speed of their vehicle.', -1000000, 1000000, player_torque, 1, function(value)
                player_torque = value
                util.create_tick_handler(function()
                    if PED.IS_PED_IN_ANY_VEHICLE(playerPed, true) then
                        local playerVehicle = PED.GET_VEHICLE_PED_IS_IN(playerPed, false)
                        NETWORK.NETWORK_REQUEST_CONTROL_OF_ENTITY(playerVehicle)
                        VEHICLE.SET_VEHICLE_CHEAT_POWER_INCREASE(playerVehicle, player_torque/1000)
                    end
                    return (player_torque != 1000)
                end)
            end)

            JSlang.toggle(player_veh_root, 'Surface submarine', {'JSforceSurface'}, 'Forces their submarine to the surface if they\'re driving it.', function(toggle)
                local vehicle = PED.GET_VEHICLE_PED_IS_IN(playerPed, false)
                if PED.IS_PED_IN_ANY_VEHICLE(playerPed, true) and ENTITY.GET_ENTITY_MODEL(vehicle) == 1336872304 then
                    VEHICLE.FORCE_SUBMARINE_SURFACE_MODE(vehicle, toggle)
                    if toggle and notifications then
                        util.toast(JSlang.str_trans('Forcing') ..' '.. playerName .. JSlang.str_trans('\'s submarine to the surface.'))
                    end
                end
            end)

            JSlang.toggle_loop(player_veh_root, 'To the moon', {'JStoMoon'}, 'Forces their vehicle into the sky.', function()
                if PED.IS_PED_IN_ANY_VEHICLE(playerPed, true) then
                    local playerVehicle = PED.GET_VEHICLE_PED_IS_IN(playerPed, false)
                    NETWORK.NETWORK_REQUEST_CONTROL_OF_ENTITY(playerVehicle)
                    ENTITY.APPLY_FORCE_TO_ENTITY(playerVehicle, 1, 0, 0, 100, 0, 0, 0.5, 0, false, false, true)
                    util.yield(10)
                end
                if not players.exists(pid) then util.stop_thread() end
            end)

            JSlang.toggle_loop(player_veh_root, 'Anchor', {'JSanchor'}, 'Forces their vehicle info the ground if its in the air.', function()
                if PED.IS_PED_IN_ANY_VEHICLE(playerPed, true) then
                    local playerVehicle = PED.GET_VEHICLE_PED_IS_IN(playerPed, false)
                    if ENTITY.IS_ENTITY_IN_AIR(playerVehicle) then
                        NETWORK.NETWORK_REQUEST_CONTROL_OF_ENTITY(playerVehicle)
                        ENTITY.APPLY_FORCE_TO_ENTITY(playerVehicle, 1, 0, 0, -100, 0, 0, 0, 0, false, false, true)
                        util.yield(10)
                    end
                end
                if not players.exists(pid) then util.stop_thread() end
            end)

        -----------------------------------
        -- Entity rain
        -----------------------------------
            local rain_root = JSlang.list(player_root, 'Entity rain', {'JSrain'}, '')

            local function rain(pid, entity)
                local pos = players.get_position(pid)
                local hash = util.joaat(entity)
                pos.x += math.random(-30,30)
                pos.y += math.random(-30,30)
                pos.z += 30
                loadModel(hash)
                local animal = entities.create_ped(28, hash, pos, 0)
                STREAMING.SET_MODEL_AS_NO_LONGER_NEEDED(hash)
                -- ENTITY.SET_ENTITY_INVINCIBLE(animal, true)
            end

            local rainOptions = {
                { name = 'Meow rain',    description = 'UWU',                                          animals = {'a_c_cat_01'}                                 },
                { name = 'Sea rain',     description = '<º)))><',                                      animals = {'a_c_fish', 'a_c_dolphin', 'a_c_killerwhale'} },
                { name = 'Dog rain',     description = 'Wooof',                                        animals = {'a_c_retriever', 'a_c_pug', 'a_c_rottweiler'} },
                { name = 'Chicken rain', description = '*clucking*',                                   animals = {'a_c_hen'}                                    },
                { name = 'Monkey rain',  description = 'Idk what sound a monkey does',                 animals = {'a_c_chimp'}                                  },
                { name = 'Pig rain',     description = '(> (00) <)',                                   animals = {'a_c_pig'}                                    },
                { name = 'Rat rain',     description = 'Puts a Remote access trojan in your pc. (JK)', animals = {'a_c_rat'}                                    }
            }
            for i = 1, #rainOptions do
                JSlang.toggle_loop(rain_root, rainOptions[i].name, {'JS'.. rainOptions[i].name}, rainOptions[i].description, function()
                    for _, animal in pairs(rainOptions[i].animals) do
                        rain(pid, animal)
                        util.yield(500)
                    end
                    if not players.exists(pid) then util.stop_thread() end
                end)
            end

            JSlang.action(rain_root, 'Clear rain', {'JSclear'}, 'Deletes rained entities.', function()
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
    if TASK.GET_IS_TASK_ACTIVE(players.user_ped(), 2) then --when exiting a car
        setCarOptions(false)
    end
    local carCheck = entities.get_user_vehicle_as_handle()
    if my_cur_car != carCheck then
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
                ct += spacing
                directx.draw_text(1 + sliderToScreenPos(piSettings.xOffset), ct + sliderToScreenPos(piSettings.yOffset), text, piSettings.alignment, piSettings.scale, piSettings.textColour, false)
            end
        end
    end

    -- Safe monitor
    if toggleSafeMonitor then
        local ct = 0
        local spacing = 0.015 + smSettings.scale * smSettings.scale / 50
        for i = 1, #safeManagerToggles do
            if safeManagerToggles[i].toggle then
                ct += spacing
                directx.draw_text(1 + sliderToScreenPos(smSettings.xOffset), ct + sliderToScreenPos(smSettings.yOffset), safeManagerToggles[i].displayText(), smSettings.alignment, smSettings.scale, smSettings.textColour, false)
            end
        end
    end
end)
