--if the lib should generate a template.lua in your LANG_DIR for translation templates on startup, this will log all the menu options, and after the main script had loaded the lib will check your STRING_FILES for unregistered strings
local GENERATE_TEMPLATE = false

--the dir lang files are stored in
local LANG_DIR = filesystem.store_dir() .. 'JerryScript\\Language\\'

--files to search for JSlang.toast and JSlang.str_trans in when generating a template
local STRING_FILES = {
    filesystem.scripts_dir() ..'JerryScript.lua',
    filesystem.scripts_dir() ..'lib//JSfuncsNtables.lua',
}

--if you have a template file and a translated file with just plaintext of your translation, this will help you merge those files into translations
local FILE_MERGE = false

--require translations
if not filesystem.is_dir(LANG_DIR) then
    filesystem.mkdirs(LANG_DIR)
end

local function getPathPart(fullPath, remove)
    local path = string.sub(fullPath, #remove + 1)
    return string.gsub(path, '.lua', '')
end
util.create_thread(function()
    util.yield()
    for i, profilePath in pairs(filesystem.list_files(LANG_DIR)) do
        if string.find(profilePath, 'template') == nil and string.find(profilePath, 'translated') == nil and string.find(profilePath, 'result') == nil then
            util.create_thread(function()
                util.yield(100 * i)
                require(getPathPart(profilePath, filesystem.scripts_dir()))
            end)
        end
    end
end)

--add lang functions
local JSlang = {}

function JSlang.trans(txt)
    if txt == nil or #txt < 1 then return '' end

    local label = lang.find(txt, 'en')
    if label == 0 then
        label = lang.register(txt)
    end
    return label
end

if GENERATE_TEMPLATE then
    local function readAll(file)
        local f = assert(io.open(file, 'rb'))
        local content = f:read('*all')
        f:close()
        return content
    end

    local loggedStrings = {}
    local function writeToasts(path, f)
        local script_file = readAll(path)
        for text in string.gmatch(script_file, 'JSlang.toast%(\'.-\'%)') do
            text = string.gsub(text, 'JSlang.toast%(\'', '')
            text = string.gsub(text, '\'%)', '')
            text = string.gsub(text, '\'', '\\\'')
            text = string.gsub(text, '\n', '\\n')
            text = string.gsub(text, '\\\\', '\\')
            if loggedStrings[text] == nil and lang.find(text, 'en') == 0 then
                f:write('t(f(\''.. text ..'\'), \'\')' ..'\n')
                loggedStrings[text] = true
            end
        end
    end

    local function writeStrings(path, f)
        local script_file = readAll(path)
        for text in string.gmatch(script_file, 'JSlang.str_trans%(\'.-\'%)') do
            text = string.gsub(text, 'JSlang.str_trans%(\'', '')
            text = string.gsub(text, '\'%)', '')
            text = string.gsub(text, '\'', '\\\'')
            text = string.gsub(text, '\n', '\\n')
            text = string.gsub(text, '\\\\', '\\')
            if loggedStrings[text] == nil and lang.find(text, 'en') == 0 then
                f:write('t(f(\''.. text ..'\'), \'\')' ..'\n')
                loggedStrings[text] = true
            end
        end
    end

    if not filesystem.exists(LANG_DIR .. 'template.lua') then
        local f = assert(io.open(LANG_DIR .. 'template.lua', 'a'))
        f:write('lang.set_translate(\'\') --insert lang code here e.x. fr en or de\n\nlocal f = lang.find\nlocal t = lang.translate\n\n')
        f:close()
    end

    --asynchronous code that runs after the main script has loaded
    util.create_thread(function()
        --wait for main script to load
        util.yield()

        local f = assert(io.open(LANG_DIR .. 'template.lua', 'a'))
        f:write('\n--toasts\n')

        for _, file in pairs(STRING_FILES) do
            writeToasts(file, f)
        end

        f:write('\n--other strings\n')
        for _, file in pairs(STRING_FILES) do
            writeStrings(file, f)
        end
        f:close()
    end)

    function JSlang.trans(txt)
        if txt == nil or #txt < 1 then return '' end

        local label = lang.find(txt, 'en')
        if label == 0 then
            local f = assert(io.open(LANG_DIR .. 'template.lua', 'a'))
            local fileTxt = string.gsub(txt, '\'', '\\\'')
            fileTxt = string.gsub(fileTxt, '\n', '\\n')
            fileTxt = string.gsub(fileTxt, '\\\\', '\\')
            f:write('t(f(\''.. fileTxt ..'\'), \'\')' ..'\n')
            f:close()

            label = lang.register(txt)
        end
        return label
    end
end

if FILE_MERGE then
    local mergeTable = {}
    menu.action(menu.my_root(), 'merge template', {}, '', function()
        local res = assert(io.open(LANG_DIR .. 'result.lua', 'a'))

        local i = 1
        for line in io.lines(LANG_DIR .."template.lua") do
            mergeTable[i][1] = line
            i += 1
        end
        local j = 1
        for line in io.lines(LANG_DIR .."translated.lua") do
            mergeTable[i][2] = line
            j += 1
        end
        for i = 1, #mergeTable do
            local fileTxt = string.gsub(mergeTable[i][2], '\'', '\\\'')
            fileTxt = string.gsub(fileTxt, '\\\\', '\\')
            res:write(string.gsub(mergeTable[i][1], "''", "'"..fileTxt .."'") .. "\n")
        end

        res:close()
    end)
end

function JSlang.str_trans(string)
    return lang.get_string(JSlang.trans(string), lang.get_current())
end

function JSlang.toast(string)
    util.toast(JSlang.str_trans(string))
end

function JSlang.list(root, name, tableCommands, description, on_click, on_back)
    local tableCommands = tableCommands and tableCommands or {}
    if not on_click and not on_back then
        return menu.list(root, JSlang.trans(name), tableCommands, JSlang.trans(description))
    end
    if not on_back then
        return menu.list(root, JSlang.trans(name), tableCommands, JSlang.trans(description), on_click)
    end
    return menu.list(root, JSlang.trans(name), tableCommands, JSlang.trans(description), on_click, on_back)
end

function JSlang.action(root, name, tableCommands, description, on_click, on_command)
    return menu.action(root, JSlang.trans(name), tableCommands, JSlang.trans(description), on_click, on_command)
end

function JSlang.toggle(root, name, tableCommands, description, func, on)
    return menu.toggle(root, JSlang.trans(name), tableCommands, JSlang.trans(description), func, on)
end

function JSlang.toggle_loop(root, name, tableCommands, description, tickFunc, on_stop)
    return menu.toggle_loop(root, JSlang.trans(name), tableCommands, JSlang.trans(description), tickFunc, on_stop)
end

function JSlang.slider(root, name, tableCommands, description, min, max, default_value, increment, func)
    return menu.slider(root, JSlang.trans(name), tableCommands, JSlang.trans(description), min, max, default_value, increment, func)
end

function JSlang.slider_float(root, name, tableCommands, description, min, max, default_value, increment, func)
    return menu.slider_float(root, JSlang.trans(name), tableCommands, JSlang.trans(description), min, max, default_value, increment, func)
end

function JSlang.click_slider(root, name, tableCommands, description, min, max, default_value, increment, func)
    return menu.click_slider(root, JSlang.trans(name), tableCommands, JSlang.trans(description), min, max, default_value, increment, func)
end

function JSlang.click_slider_float(root, name, tableCommands, description, min, max, default_value, increment, func)
    return menu.click_slider_float(root, JSlang.trans(name), tableCommands, JSlang.trans(description), min, max, default_value, increment, func)
end

function JSlang.list_select(root, name, tableCommands, description, tableOptions, default_value, func)
    return menu.list_select(root, JSlang.trans(name), tableCommands, JSlang.trans(description), tableOptions, default_value, func)
end

function JSlang.list_action(root, name, tableCommands, description, tableOptions, func)
    return menu.list_action(root, JSlang.trans(name), tableCommands, JSlang.trans(description), tableOptions, func)
end

function JSlang.text_input(root, name, tableCommands, description, func, default_value)
    return menu.text_input(root, JSlang.trans(name), tableCommands, JSlang.trans(description), func, default_value)
end

function JSlang.colour(root, name, tableCommands, description, colour, transparency, func)
    return menu.colour(root, JSlang.trans(name), tableCommands, JSlang.trans(description), colour, transparency, func)
end

-- menu.rainbow(int colour_command)

function JSlang.divider(root, name)
    return menu.divider(root, JSlang.trans(name))
end

function JSlang.hyperlink(root, name, link, description)
    return menu.hyperlink(root, JSlang.trans(name), link, JSlang.trans(description))
end

function JSlang.action_slider(root, name, link, description, optionsTable, func)
    return menu.action_slider(root, JSlang.trans(name), link, JSlang.trans(description), optionsTable, func)
end

return JSlang
