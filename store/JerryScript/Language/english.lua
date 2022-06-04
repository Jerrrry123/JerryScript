local reg = lang.register

--settings

--Script settings
reg('Script settings')

reg('Disable JS notifications')
reg('Makes the script not notify when stuff happens. These can be pretty useful so I don\'t recommend turning them off.')
reg('Notifications on')

reg('Double tap interval')
reg('Lets you set the maximum time between double taps in ms.')

reg('Create translation template')
reg('Creates a template file for translation in store/JerryScript/Language.')

reg('Failed to get latest release.')
reg('Successfully created file.')
reg('Stop creating template files, you have way too many!')
reg('Failed to create file.')

-- Player info settings
reg('Player info settings')

-- Player info toggles
reg('Display options')

reg('Disable name')

reg('Disable weapon')
reg('Weapon')

reg('Disable ammo info')
reg('Clip')

reg('Disable damage type')
reg('Displays the type of damage the players weapon does, like melee / fire / bullets / mk2 ammo.')
reg('Damage type')

reg('Disable vehicle')

reg('Disable score')
reg('Only shows when you or they have kills.')
reg('Vs')

reg('Disable moving indicator')
reg('Player is')

reg('ragdolling')
reg('climbing')
reg('vaulting')
reg('climbing Ladder')
reg('exiting vehicle')
reg('entering vehicle')
reg('parachuting')
reg('jumping')
reg('falling')
reg('flying a plane')
reg('flying a helicopter')
reg('driving a boat')
reg('driving a submarine')
reg('biking')
reg('driving')
reg('swimming')
reg('strafing')
reg('sprinting')
reg('sneaking')
reg('getting up')
reg('going into cover')
reg('moving in cover')
reg('moving')

reg('Disable aiming indicator')
reg('Player is aiming at you')

reg('Disable reload indicator')
reg('Player is reloading')

-- Safe monitor settings
reg('Safe monitor settings')
reg('Settings for the on screen text')

--Explosion settings
reg('Explosion settings')
reg('Settings for the different options that explode players in this script.')

reg('Loop delay')
reg('Lets you set a custom delay between looped explosions.')

-- Fx explosion settings
reg('FX explosions')
reg('Lets you choose effects instead of explosion type.')

reg('Explosion type')
reg('Fx active')

reg('FX type')
reg('none')
reg('Choose a fx explosion type.')

reg('Colour can be changed.')
reg('Can\'t be silenced.')

reg('Clown Explosion')
reg('Clown Appears')
reg('FW Trailburst')
reg('FW Starburst')
reg('FW Fountain')
reg('Alien Disintegration')
reg('Clown Flowers')
reg('FW Ground Burst')

reg('FX colour')
reg('Only works on some pfx\'s.')


reg('Camera shake')
reg('How much explosions shake the camera.')

reg('Invisible explosions')
reg('Silent explosions')
reg('Disable explosion damage')

reg('Blame settings')
reg('Lets you blame yourself or other players for your explosions, go to the player list to chose a specific player to blame.')

reg('Owned explosions')
reg('Will overwrite "Disable explosion damage".')

reg('Blame')
reg('Random')
reg('Will overwrite "Disable explosion damage" and if you haven\'t chosen a player random players will be blamed for each explosion.')

reg('Blame player list')
reg('Custom player list for selecting blames.')

--[[blame [playername] ..]]
reg(' for your explosions.')

reg('Explosions stopped because the player you\'re blaming left.')

reg('Random blames')
reg('Switches blamed explosions back to random if you already chose a player to blame.')

reg('Horn boost multiplier')
reg('Set the force applied to the car when you or another player uses horn boost.')

--Self
reg('Ghost')
reg('Makes your player different levels off see through.')

reg('Fire wings')
reg('Puts wings made of fire on your back.')

reg('Fire wings scale')

reg('Fire wings colour')

-- Ped customization

reg('Face features')
reg('Customize face features')
reg('Customizations reset after restarting the game.')

reg('Nose Width')
reg('Nose Peak Hight')
reg('Nose Peak Length')
reg('Nose Bone Hight')
reg('Nose Peak Lowering')
reg('Nose Bone Twist')
reg('Eyebrow Hight')
reg('Eyebrow Forward')
reg('Cheeks Bone Hight')
reg('Cheeks Bone Width')
reg('Cheeks Width')
reg('Eyes Opening')
reg('Lips Thickness')
reg('Jaw Bone Width')
reg('Jaw Bone Back Length')
reg('Chin Bone Lowering')
reg('Chin Bone Length')
reg('Chin Bone Width')
reg('Chin Hole')
reg('Neck Width')

reg('Create face feature profile')
reg('Saves your customized face in a file so you can load it.')

reg('Reload profiles')
reg('Refreshes your profiles without having to restart the script.')
reg('Profile not found.')

reg('Profiles')

reg('Customize face overlays')

reg('Blemishes')
reg('Facial Hair')
reg('Eyebrows')
reg('Ageing')
reg('Makeup')
reg('Blush')
reg('Complexion')
reg('Sun Damage')
reg('Lipstick')
reg('Moles/Freckles')
reg('Chest Hair')
reg('Body Blemishes')
reg('Add Body Blemishes')

-- Ragdoll types
reg('Ragdoll options')
reg('Different options for making yourself ragdoll.')

reg('Better clumsiness')
reg('Like stands clumsiness, but you can get up after you fall.')

reg('Stumble')
reg('Makes you stumble with a good chance of falling over.')

reg('Fall over')
reg('Makes you stumble, fall over and prevents you from getting back up.')

reg('Ragdoll')
reg('Just makes you ragdoll.')

reg('Full regen')
reg('Makes your hp regenerate until you\'re at full health.')

reg('Cold blooded')
reg('Removes your thermal signature.\nOther players still see it tho.')

reg('Quiet footsteps')
reg('Disables the sound of your footsteps.')

-- Weapons

reg('Thermal guns')
reg('Makes it so when you aim any gun you can toggle thermal vision on "E".')

-- Weapon settings
reg('Weapon settings')
reg('Failed to find memory address.')

reg('Disable recoil')
reg('Disables the camera shake when shooting guns.')

reg('Infinite range')
reg('Disable spread')

reg('Remove spin-up time')
reg('Removes the spin-up from both the minigun and the widowmaker.')

reg('Bullet force multiplier')
reg('Works best when shooting vehicles from the front.\nDisplayed value is in percent.')

reg('Aim fov')
reg('Enable aim fov')
reg('Lets you modify the fov you have while you\'re aiming.')

reg('Zoom aim fov')
reg('Enable zoom fov')
reg('Lets you modify the fov you have while you\'re aiming and has zoomed in.')

-- Proxy stickys
reg('Proxy stickys')
reg('Makes your sticky bombs automatically detonate around players or npc\'s, works with the player whitelist.')

reg('Detonate near players')
reg('If your sticky bombs automatically detonate near players.')

reg('Detonate near npc\'s')
reg('If your sticky bombs automatically detonate near npc\'s.')

reg('Detonation radius')
reg('How close the sticky bombs have to be to the target to detonate.')

reg('Remove all sticky bombs')
reg('Removes every single sticky bomb that exists (not only yours).')


reg('Friendly fire')
reg('Makes you able to shoot peds the game count as your friends.')

reg('Reload when rolling')
reg('Reloads your weapon when doing a roll.')

--Nuke options
reg('Nuke options')
reg('Nuke gun')
reg('Makes the rpg fire nukes')

reg('Nuke waypoint')
reg('Drops a nuke on your selected Waypoint.')
reg('No waypoint set.')

reg('Nuke height')
reg('The height of the nukes you drop.')

reg('Throwables launcher')
reg('Makes the grenade launcher able to shoot throwables, gives you the throwable if you don\'t have it so you can shoot it.')

reg('Current throwable')
reg('Choose what throwable the grenade launcher has.')

--Explosive animal gun
reg('Explosive animal gun')
reg('Inspired by impulses explosive whale gun, but can fire other animals too.')

reg('Current animal')
reg('Choose wat animal the explosive animal gun has.')

--Minecraft gun
reg('Minecraft gun')
reg('Spawns blocks where you shoot.')

reg('Delete last block')
reg('Delete all blocks')

-- Vehicle

-- Speed and handling
reg('Speed and handling')

reg('Low traction')
reg('Makes your vehicle have low traction, I recommend setting this to a hotkey.')

reg('Launch control')
reg('Limits how much force your car applies when accelerating so it doesn\'t burnout, very noticeable in a Emerus.')

reg('Set torque')
reg('Modifies the speed of your vehicle.')

reg('Quick brake')
reg('Slows down your speed more when pressing "S".')

reg('Quick brake force')
reg('1.00 is ordinary brakes.')

-- Boosts
reg('Boosts')

reg('Horn boost')
reg('Makes your car speed up when you honking your horn or activating your siren.')

reg('Vehicle jump')
reg('Lets you jump with your car if you double tap "W".')

-- Nitro
reg('Nitro')
reg('Enable nitro')
reg('Enable nitro boost on any vehicle, use it by pressing "X".')

reg('Duration')
reg('Lets you set a customize how long the nitro lasts.')

reg('Recharge time')
reg('Lets you set a custom delay of how long it takes for nitro to recharge.')

-- Shunt boost
reg('Shunt boost')
reg('Shunt boost')
reg('Lets you shunt boost in any vehicle by double tapping "A" or "D".')

reg('Shunt boost fully recharged')

reg('Disable recharge')
reg('Removes the force build-up of the shunt boost.')

reg('Force')
reg('How much force is applied to your car.')

-- Vehicle doors
reg('Vehicle doors')

reg('Indestructible doors')
reg('Makes it so your vehicle doors can\'t break off.')

reg('Shut doors when driving')
reg('Closes all the vehicle doors when you start driving.')
reg('Closed your car doors.')

reg('Open all doors')
reg('Close all doors')
reg('Made this to test door stuff.')

-- Plane options
reg('Plane options')

reg('Toggle plane afterburner')
reg('Makes you able to toggle afterburner on planes by pressing "left shift".')

reg('Lock vtol')
reg('Locks the angle of planes vtol propellers.')


reg('Ghost vehicle')
reg('Makes your vehicle different levels off see through.')

reg('Disable exhaust pops')
reg('Disables those annoying exhaust pops that your car makes if it has a non-stock exhaust option.')

reg('Stance')
reg('Activates stance on vehicles that support it.')

reg('Npc horn')
reg('Makes you horn like a npc. Also makes your car doors silent.')

reg('To the moon')
reg('Forces you info the sky if you\'re in a vehicle.')

reg('Anchor')
reg('Forces you info the ground if you\'re in a air born vehicle.')

-- Online

--Safe monitor
reg('Safe monitor')
reg('Safe monitor allows you to monitor your safes. It does NOT affect the money being generated.')

reg('Toggle all selected')
reg('Toggles every option.')

reg('Nightclub Safe')
reg('Monitors nightclub safe cash, this does NOT affect income.')
reg('Nightclub Cash')

reg('Nightclub Popularity')

reg('Nightclub Daily Earnings')
reg('Nightclub daily earnings.\nMaximum daily earnings is 10k.')

reg('Arcade safe')
reg('Monitors arcade safe cash, this does NOT affect income.\nMaximum daily earnings is 5k if you have all the arcade games.')
reg('Arcade Cash')

reg('Agency safe')
reg('Monitors agency safe cash, this does NOT affect income.\nMaximum daily earnings is 20k.')
reg('Agency Cash')

reg('Security contracts')
reg('Displays the number of agency security missions you have completed.')

reg('Agency daily Earnings')
reg('Agency daily earnings.\nMaximum daily earnings is 20k if you have completed 200 contracts.')

reg('Increase safe earnings')
reg('Might be risky.')

reg('Auto nightclub popularity')
reg('Automatically sets the nightclubs popularity to 100 if it results in less than max daily income.')

reg('Increment security contracts completed')
reg('Will put you in a new lobby to make the increase stick.\nI added a cooldown to this button so you cant spam it.\nAlso doesn\'t work past 200')
reg('Cooldown active')
reg('You can only use this while in a session.')
reg('You already reached 200 completions.')

-- Property tp
reg('Property tp\'s')
reg('Lets you teleport to the properties you own.')

reg('Ceo office')
reg('MC clubhouse')
reg('MC businesses')
reg('Weed farm')
reg('Cocaine lockup')
reg('Document forgery')
reg('Methamphetamine Lab')
reg('Counterfeit cash')
reg('Bunker')
reg('Hangar')
reg('Facility')
reg('Night club')
reg('Arcade')
reg('Auto shop')
reg('Agency')

reg('Couldn\'t find property.')

--cooldowns
reg('Cooldowns')
reg('Agency')
reg('Terrorbyte')
reg('Casino')
reg('CEO/VIP')

reg('Payphone hits') 
reg('Use this before picking up the payphone.')
reg('Security contracts')
reg('Use this after completing the job.')

reg('Between jobs')
reg('Robbery in progress')
reg('Data sweep')
reg('Targeted data')
reg('Diamond shopping')

reg('Use this after completing the job.')
reg('Use this before starting the job.')

reg('Casino work')
--ceo work
reg('CEO/VIP work')
reg('Stand has this as a toggle, but that option doesn\'t work if you activate it when the cooldown has started, this does.')

reg('Headhunter')
reg('Sightseer')
reg('Asset recovery')
reg('Use this before starting the mission.')

--Casino
-- reg('Casino')
reg('No theres no recoveries here.')

reg('Lucky wheel cooldown')
reg('Tells you if the lucky wheel is available or how much time is left until it is.')
reg('Lucky wheel is available.')

reg('Casino loss/profit')
reg('Tells you how much you made or lost in the casino.')

reg('You\'ve made') --[[amout of chips]]
reg('You\'ve lost') --[[amout of chips]]
reg('chips.')
reg('You haven\'t made or lost any chips.')

-- Time trial
reg('Time trials')
reg('Time trial')
reg('Rc time trial')

reg('Best time trial time')
reg('Best rc time trial time')
reg('Best Time')

reg('Teleport to time trial')
reg('Couldn\'t find time trial.')

reg('Teleport to rc time trial')
reg('Couldn\'t find rc time trial.')

-- Block areas
reg('Block areas')
reg('Block areas in online with invisible walls, but if you over use it it will crash you lol.')
reg('A block is already being run.')
--[[area]] reg('is already blocked.')

reg('Blocking')
reg('Successfully blocked') --[[area or areaname]]


reg('Custom block')
reg('Makes you able to block an area in front of you by pressing "B".')
reg('A block is already being run.')
reg('area')


reg('Block LSC')
reg('Block lsc from being accessed.')

reg('Block casino')
reg('Block casino from being accessed.')

reg('Block maze bank')
reg('Block maze bank from being accessed.')

--area names
reg('orbital room')

--los santos custums locations
reg('burton')
reg('LSIA')
reg('la meza')
reg('blaine county')
reg('paleto bay')
reg('benny\'s')

-- Casino blocks
reg('casino entrance')
reg('casino garage')
reg('lucky wheel')

--Maze bank block
reg('maze bank entrance')
reg('maze bank garage')

--Mc block
reg('hawick clubhouse')

--Arena war garages
reg('arena war garages')

--Players options
reg('Whitelist')
reg('Applies to most options in this section.')

reg('Exclude self')
reg('Will make you not explode yourself. Pretty cool option if you ask me ;P')

reg('Exclude friends')
reg('Will make you not explode your friends... if you have any. (;-;)')

reg('Exclude strangers')
reg('If you only want to explode your friends I guess.')

reg('Whitelist player')
reg('Lets you whitelist a single player by name.')

reg('Whitelist player list')
reg('Custom player list for selecting  players you wanna whitelist.')

--[[Whitelist [playerName] ]] reg('from options that affect all players.')

reg('Whitelisted') 

-- Anti chat spam
reg('Anti chat spam')


reg('Kicked') --[[playerName]] reg('for chat spam.')

reg('Kicks people if they spam chat.')

reg('Ignore team chat')

reg('Identical messages')
reg('How many identical chat messages a player can send before getting kicked.')

--Explosions
reg('Explode all')
reg('Makes everyone explode.')

reg('Explode all loop')
reg('Constantly explodes everyone.')


reg('Orbital cannon detection')
reg('Tells you when anyone starts using the orbital cannon')
--[[playerName]] reg('is using the orbital cannon')

-- Coloured otr reveal
reg('Coloured otr reveal')
reg('Marks otr players with coloured blips.')
reg('otr reveal colour')
reg('Otr rgb reveal')

-- Vehicle
reg('Vehicles')
reg('Do stuff to all players vehicles.')

reg('Lock burnout')
reg('Locks all player cars in burnout.')

reg('Set torque')
reg('Modifies the speed of all player vehicles.')

reg('Force surface all subs')
reg('Forces all Kosatkas to the surface.\nNot compatible with the whitelist.')
reg('Surfaced') --[[amount]] reg('submarines.')

reg('No fly zone')
reg('Forces all players in air born vehicles into the ground.')
reg('Applied force')

reg('Shoot gods')
reg('Disables godmode for other players when aiming at them. Mostly works on trash menus.')

reg('Aim karma')
reg('Do stuff to players that aim at you.')

reg('Shoot')
reg('Shoots players that aim at you.')

reg('Explode')
reg('Explodes the player with your custom explosion settings.')

reg('Disable godmode')
reg('If a god mode player aims at you this disables their god mode by pushing their camera forwards.')

reg('Stands player aim punishments')
reg('Link to stands player aim punishments.')


-- World
reg('irl time')
reg('Makes the in game time match your irl time. Disables stands "Smooth Transition".')

reg('Disable numpad')
reg('Disables numpad so you don\'t rotate your plane/submarine while navigating stand')

reg('Map zoom level')

reg('Enable footsteps')
reg('Enables foot prints on all surfaces.')

reg('Enable vehicle trails')
reg('Enables vehicle trails on all surfaces.')

reg('Disable all map notifications')
reg('Removes that constant spam.')

-- Trains
reg('Trains')

reg('Derail trains')
reg('Derails and stops all trains.')

reg('Delete trains')
reg('Just becurse every script has train options, I gotta have an anti train option.')

reg('Mark nearby trains')
reg('Marks nearby trains with purple blips.')
reg('Marked train')

-- Peds
reg('Peds')

reg('Ragdoll peds')
reg('Makes all nearby peds fall over lol.')

reg('Death\'s touch')
reg('Kills peds that touches you.')

reg('Cold peds')
reg('Removes the thermal signature from all peds.')

reg('Mute peds')
reg('Because I don\'t want to hear that dude talk about his gay dog any more.')

reg('Npc horn boost')
reg('Boosts npcs that horn.')

reg('Npc siren boost')
reg('Boosts npcs cars with an active siren.')

reg('Auto kill enemies')
reg('Just instantly kills hostile peds.')

reg('Kill jacked peds')
reg('Automatically kills peds when stealing their car.')

reg('Riot mode')
reg('Makes peds hostile.')

reg('Join the discord server')
reg('Join the JerryScript discord server to suggest features, report bugs and test upcoming features.')


--credits
reg('Coded by') --[[Jerry123#4508]]
reg('Some contributions made by') --[[scriptcat#6566]]

reg('Skids from:')
--[[scriptname]] reg('by') --[[creators name]]

reg(('Thanks to'))
--[[Ren#5219 and JayMontana36#9565]]
reg('for reviewing my code')

reg('Big thanks to all the cool people who helped me in #programming in the stand discord')
--[[names]]

--[[Goddess Sainan#0001]]
reg('For making stand and providing such a great api and documentation')

reg('And thank you') --[[your name]]  reg('for using JerryScript')

reg('Play credits')

-- Player options
reg('JerryScript')
reg('JS player options')

reg('Player info')
reg('Display information about this player.')

 -- Trolling
reg('Trolling')

reg('Explode player')
reg('Explodes this player with your selected options.')

reg('Explode loop player')
reg('Loops explosions on them with your selected options.')

reg('Blame explosions')
reg('Makes your explosions blamed on them.')


reg('Damage')

reg('Primed grenade')
reg('Spawns a grenade on top of them.')

reg('Sticky')
reg('Spawns a sticky bomb on them that might stick to their vehicle and you can detonate by pressing "G".')

reg('Undetected money drop 2022')
reg('Drops money bags that wont give any money.')

reg('Entity YEET')
reg('Pushes all peds and vehicles near them.. into them ;)\nRequires you to be near them or spectating them.')

reg('Entity Storm')
reg('Constantly pushes all peds and vehicles near them.. into them :p\nRequires you to be near them or spectating them.')

reg('Range for YEET/Storm')
reg('How close nearby entities have to be to get pushed the targeted player.')

reg('Multiplier for YEET/Storm')
reg('Multiplier for how much force is applied to entities when they get pushed towards them.')

reg('Storm delay')
reg('Lets you set the delay for how often entities are pushed in entity storm.')

reg('Give shoot gods')
reg('Grants this player the ability to disable players god mode when shooting them.')

reg('Give horn boost')
reg('Gives them the ability to speed up their car by pressing honking their horn or activating the siren.')

reg('Give aim karma')
reg('Allows you to to stuff to players who target this player.')

reg('Explode')
reg('Explosions with your custom explosion settings.')

reg('Disable godmode')
reg('If a god mode player aims at them this disables the aimers god mode by pushing their camera forwards.')

-- Vehicle

reg('Lock burnout')
reg('Locks their car in a burnout.')

reg('Modifies the speed of their vehicle.')

reg('Surface submarine')
reg('Forces their submarine to the surface if they\'re driving it.')

reg('Forcing') --[[name]] reg('\'s submarine to the surface.')


-- reg('To the moon')
reg('Forces their vehicle into the sky.')

reg('Forces their into the sky if they\'re in a vehicle.')

--Entity rain
reg('Entity rain')

reg('Meow rain')
reg('UWU')

reg('Sea rain')
reg('<º)))><')

reg('Dog rain')
reg('Wooof')

reg('Chicken rain')
reg('*clucking*')

reg('Monkey rain')
reg('Idk what sound a monkey does')

reg('Pig rain')
reg('(> (00) <)')

reg('Rat rain')
reg('Puts a Remote access trojan in your pc. (JK)')

reg('Clear rain')
reg('Deletes rained entities.')

--list warning

reg('I can\'t guarantee that these options are 100% safe. I tested them on my main, but im stupid.')

--components

--text options
reg('X position')

reg('Y position')

reg('The size of the text.')

reg('Text alignment')
reg('1 is center, 2 is left and 3 is right.')

reg('Text colour')
reg('Sets the colour of the text overlay.')


--delay
reg('Ms')
reg('The delay is the added total of ms, sec and min values.')

reg('Seconds')
reg('The delay is the added total of ms, sec and min values.')

reg('Minutes')
reg('The delay is the added total of ms, sec and min values.')

reg('min')

reg('s')

reg('ms')