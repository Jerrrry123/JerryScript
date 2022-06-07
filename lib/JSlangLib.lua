local function getPathPart(fullPath, remove)
    local path = string.sub(fullPath, #remove + 1)
    return string.gsub(path, '.lua', '')
end
for _, profilePath in pairs(filesystem.list_files(filesystem.store_dir() ..'JerryScript\\Language')) do
    if string.find(profilePath, 'template') == nil then
        require(getPathPart(profilePath, filesystem.scripts_dir()))
    end
end

JSlang = {}
function JSlang.trans(string)
    return lang.find(string, 'en')
end

function JSlang.str_trans(string)
    return lang.get_string(lang.find(string, 'en'), lang.get_current())
end

function JSlang.toast(string)
    util.toast(JSlang.str_trans(string))
end

local function desc(description)
    if description and #description > 0 then
        return JSlang.trans(description)
    end
    return ''
end

function JSlang.list(root, name, tableCommands, description, on_click, on_back)
    description = desc(description)
    local tableCommands = tableCommands and tableCommands or {}
    return menu.list(root, JSlang.trans(name), tableCommands, description, function(enter) if on_click then on_click(enter) end end, function(back) if on_back then on_back(back) end end)
end

function JSlang.action(root, name, tableCommands, description, on_click, on_command)
    description = desc(description)
    return menu.action(root, JSlang.trans(name), tableCommands, description, function() on_click() end, function() if on_command then on_command() end end)
end

function JSlang.toggle(root, name, tableCommands, description, func, on)
    description = desc(description)
    return menu.toggle(root, JSlang.trans(name), tableCommands, description, function(toggle) func(toggle) end, on)
end

function JSlang.toggle_loop(root, name, tableCommands, description, tickFunc, on_stop)
    description = desc(description)
    return menu.toggle_loop(root, JSlang.trans(name), tableCommands, description, function() tickFunc() end, function() if on_stop then on_stop() end end)
end

function JSlang.slider(root, name, tableCommands, description, min, max, default, increment, func)
    description = desc(description)
    return menu.slider(root, JSlang.trans(name), tableCommands, description, min, max, default, increment, function(value)func(value) end)
end

function JSlang.slider_float(root, name, tableCommands, description, min, max, default, increment, func)
    description = desc(description)
    return menu.slider_float(root, JSlang.trans(name), tableCommands, description, min, max, default, increment, function(value)func(value) end)
end

function JSlang.click_slider(root, name, tableCommands, description, min, max, default, increment, func)
    description = desc(description)
    return menu.click_slider(root, JSlang.trans(name), tableCommands, description, min, max, default, increment, function(value)func(value) end)
end

function JSlang.click_slider_float(root, name, tableCommands, description, min, max, default, increment, func)
    local description = desc(description)
    return menu.click_slider_float(root, JSlang.trans(name), tableCommands, description, min, max, default, increment, function(value)func(value) end)
end

function JSlang.list_select(root, name, tableCommands, description, tableOptions, default, func)
    description = desc(description)
    return menu.list_select(root, JSlang.trans(name), tableCommands, description, tableOptions, default, function()func() end)
end

function JSlang.list_action(root, name, tableCommands, description, tableOptions, func)
    description = desc(description)
    return menu.list_action(root, JSlang.trans(name), tableCommands, description, tableOptions, function()func() end)
end

function JSlang.text_input(root, name, tableCommands, description, func, detault)
    description = desc(description)
    return menu.text_input(root, JSlang.trans(name), tableCommands, description, function()func() end, detault)
end

function JSlang.colour(root, name, tableCommands, description, colour, transparency, func)
    description = desc(description)
    return menu.colour(root, JSlang.trans(name), tableCommands, description, colour, transparency, function(colour)func(colour) end)
end

-- menu.rainbow(int colour_command)

function JSlang.divider(root, name)
    return menu.divider(root, JSlang.trans(name))
end

function JSlang.hyperlink(root, name, link, description)
    description = desc(description)
    return menu.hyperlink(root, JSlang.trans(name), link, description)
end

function JSlang.action_slider(root, name, link, description, optionsTable, func)
    description = desc(description)
    return menu.action_slider(root, JSlang.trans(name), link, description, optionsTable, function()func() end)
end

return JSlang
