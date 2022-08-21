util.require_natives(1660775568)

local time = util.current_time_millis()

local nativeNameSpaces = {
	"SYSTEM",
    "APP",
    "AUDIO",
    "BRAIN",
    "CAM",
    "CLOCK",
    "CUTSCENE",
    "DATAFILE",
    "DECORATOR",
    "DLC",
    "ENTITY",
    "EVENT",
    "FILES",
    "FIRE",
    "GRAPHICS",
    "HUD",
    "INTERIOR",
    "ITEMSET",
    "LOADINGSCREEN",
    "LOCALIZATION",
    "MISC",
    "MOBILE",
    "MONEY",
    "NETSHOPPING",
    "NETWORK",
    "OBJECT",
    "PAD",
    "PATHFIND",
    "PED",
    "PHYSICS",
    "PLAYER",
    "RECORDING",
    "REPLAY",
    "SAVEMIGRATION",
    "SCRIPT",
    "SECURITY",
    "SHAPETEST",
    "SOCIALCLUB",
    "STATS",
    "STREAMING",
    "TASK",
    "VEHICLE",
    "WATER",
    "WEAPON",
    "ZONE"
}

local function readAll(file)
    local f = assert(io.open(file, 'rb'))
    local content = f:read('*all')
    f:close()
    return content
end

local script_file = readAll(filesystem.scripts_dir() ..'JerryScript.lua')

for _, nameSpace in ipairs(nativeNameSpaces) do
    for match in string.gmatch(script_file, nameSpace ..'%..-%(') do
        match = string.strip(match, '(')
        local tbl = string.split(match, ".")
        if not _G[nameSpace][tbl[2]] then
            util.log(nameSpace ..'.'.. tbl[2])
        end
    end
end

util.toast('Took '.. util.current_time_millis() - time ..' ms to scan for undefined natives.')
