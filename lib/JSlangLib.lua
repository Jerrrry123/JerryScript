local GENERATE_TEMPLATE = false
--if the lib should generate a template.lua in your LANG__DIR for translation templates on startup

local LANG_DIR = filesystem.store_dir() .. 'JerryScript\\Language\\'
--the dir lang files are stored in

local TOAST_FILES = {
    filesystem.scripts_dir() ..'JerryScript.lua',
    filesystem.scripts_dir() ..'lib//JSfuncsNtables.lua',
}
--files to search for toasts in when generating a template

if not filesystem.is_dir(LANG_DIR) then
    filesystem.mkdirs(LANG_DIR)
end

local function getPathPart(fullPath, remove)
    local path = string.sub(fullPath, #remove + 1)
    return string.gsub(path, '.lua', '')
end

for _, profilePath in pairs(filesystem.list_files(LANG_DIR)) do
    if string.find(profilePath, 'template') == nil then
        require(getPathPart(profilePath, filesystem.scripts_dir()))
    end
end

JSlang = {}

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

    local function writeToasts(path, f)
        local script_file = readAll(path)
        for text in string.gmatch(script_file, 'JSlang.toast%(\'.-\'%)') do
            text = string.gsub(text, 'JSlang.toast%(\'', '')
            text = string.gsub(text, '\'%)', '')
            text = string.gsub(text, '\'', '\\\'')
            text = string.gsub(text, '\n', '\\n')
            text = string.gsub(text, '\\\\', '\\')
            f:write('trans(find(\''.. text ..'\'), \'\')' ..'\n')
        end
    end

    if not filesystem.exists(LANG_DIR .. 'template.lua') then
        local f = io.open(LANG_DIR .. 'template.lua', 'w')
        f:write('lang.set_translate(\'\') --insert lang code here e.x. fr en or de\n\nlocal find = lang.find\nlocal trans = lang.translate\n\n--toasts\n')

        for _, file in pairs(TOAST_FILES) do
        writeToasts(file, f)
        end
        f:write('\n--script options\n')
        f:close()
    end

    function JSlang.trans(txt)
        if txt == nil or #txt < 1 then return '' end

        local label = lang.find(txt, 'en')
        if label == 0 then
            local f = io.open(LANG_DIR .. 'template.lua', 'a')
            local fileTxt = string.gsub(txt, '\'', '\\\'')
            fileTxt = string.gsub(fileTxt, '\n', '\\n')
            fileTxt = string.gsub(fileTxt, '\\\\', '\\')
            f:write('trans(find(\''.. fileTxt ..'\'), \'\')' ..'\n')
            f:close()

            label = lang.register(txt)
        end
        return label
    end
end

function JSlang.str_trans(string)
    return lang.get_string(JSlang.trans(string), lang.get_current())
end

function JSlang.toast(string)
    util.toast(JSlang.str_trans(string))
end

function JSlang.list(root, name, tableCommands, description, on_click, on_back)
    local tableCommands = tableCommands and tableCommands or {}
    return menu.list(root, JSlang.trans(name), tableCommands, JSlang.trans(description), function(enter) if on_click then on_click(enter) end end, function(back) if on_back then on_back(back) end end)
end

function JSlang.action(root, name, tableCommands, description, on_click, on_command)
    return menu.action(root, JSlang.trans(name), tableCommands, JSlang.trans(description), function() on_click() end, function() if on_command then on_command() end end)
end

function JSlang.toggle(root, name, tableCommands, description, func, on)
    return menu.toggle(root, JSlang.trans(name), tableCommands, JSlang.trans(description), function(toggle) func(toggle) end, on)
end

function JSlang.toggle_loop(root, name, tableCommands, description, tickFunc, on_stop)
    return menu.toggle_loop(root, JSlang.trans(name), tableCommands, JSlang.trans(description), function() tickFunc() end, function() if on_stop then on_stop() end end)
end

function JSlang.slider(root, name, tableCommands, description, min, max, default, increment, func)
    return menu.slider(root, JSlang.trans(name), tableCommands, JSlang.trans(description), min, max, default, increment, function(value)func(value) end)
end

function JSlang.slider_float(root, name, tableCommands, description, min, max, default, increment, func)
    return menu.slider_float(root, JSlang.trans(name), tableCommands, JSlang.trans(description), min, max, default, increment, function(value)func(value) end)
end

function JSlang.click_slider(root, name, tableCommands, description, min, max, default, increment, func)
    return menu.click_slider(root, JSlang.trans(name), tableCommands, JSlang.trans(description), min, max, default, increment, function(value)func(value) end)
end

function JSlang.click_slider_float(root, name, tableCommands, description, min, max, default, increment, func)
    return menu.click_slider_float(root, JSlang.trans(name), tableCommands, JSlang.trans(description), min, max, default, increment, function(value)func(value) end)
end

function JSlang.list_select(root, name, tableCommands, description, tableOptions, default, func)
    return menu.list_select(root, JSlang.trans(name), tableCommands, JSlang.trans(description), tableOptions, default, function()func() end)
end

function JSlang.list_action(root, name, tableCommands, description, tableOptions, func)
    return menu.list_action(root, JSlang.trans(name), tableCommands, JSlang.trans(description), tableOptions, function()func() end)
end

function JSlang.text_input(root, name, tableCommands, description, func, detault)
    return menu.text_input(root, JSlang.trans(name), tableCommands, JSlang.trans(description), function()func() end, detault)
end

function JSlang.colour(root, name, tableCommands, description, colour, transparency, func)
    return menu.colour(root, JSlang.trans(name), tableCommands, JSlang.trans(description), colour, transparency, function(colour)func(colour) end)
end

-- menu.rainbow(int colour_command)

function JSlang.divider(root, name)
    return menu.divider(root, JSlang.trans(name))
end

function JSlang.hyperlink(root, name, link, description)
    return menu.hyperlink(root, JSlang.trans(name), link, JSlang.trans(description))
end

function JSlang.action_slider(root, name, link, description, optionsTable, func)
    return menu.action_slider(root, JSlang.trans(name), link, JSlang.trans(description), optionsTable, function()func() end)
end
