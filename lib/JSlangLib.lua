local function getPathPart(fullPath, remove)
    local path = string.sub(fullPath, #remove + 1)
    return string.gsub(path, '.lua', '')
end
require('store\\JerryScript\\Language\\english')
for _, profilePath in pairs(filesystem.list_files(filesystem.store_dir() ..'JerryScript\\Language')) do
    if string.find(profilePath, 'english') == nil then
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

function JSlang.list(root, name, tableCommands, descriptionString, on_click, on_back)
    local descriptionString = (descriptionString and #descriptionString > 0) and JSlang.trans(descriptionString) or ''
    local tableCommands = tableCommands and tableCommands or {}
    return menu.list(root, JSlang.trans(name), tableCommands, descriptionString, function(enter) if on_click then on_click(enter) end end, function(back) if on_back then on_back(back) end end)
end

function JSlang.action(root, name, tableCommands, descriptionString, on_click, on_command)
    local descriptionString = (descriptionString and #descriptionString > 0) and JSlang.trans(descriptionString) or ''
    return menu.action(root, JSlang.trans(name), tableCommands, descriptionString, function() on_click() end, function() if on_command then on_command() end end)
end

function JSlang.toggle(root, name, tableCommands, descriptionString, func, on)
    local descriptionString = (descriptionString and #descriptionString > 0) and JSlang.trans(descriptionString) or ''
    return menu.toggle(root, JSlang.trans(name), tableCommands, descriptionString, function(toggle) func(toggle) end, on)
end

function JSlang.toggle_loop(root, name, tableCommands, descriptionString, tickFunc, on_stop)
    local descriptionString = (descriptionString and #descriptionString > 0) and JSlang.trans(descriptionString) or ''
    return menu.toggle_loop(root, JSlang.trans(name), tableCommands, descriptionString, function() tickFunc() end, function() if on_stop then on_stop() end end)
end

function JSlang.slider(root, name, tableCommands, descriptionString, min, max, default, increment, func)
    local descriptionString = (descriptionString and #descriptionString > 0) and JSlang.trans(descriptionString) or ''
    return menu.slider(root, JSlang.trans(name), tableCommands, descriptionString, min, max, default, increment, function(value)func(value) end)
end

function JSlang.slider_float(root, name, tableCommands, descriptionString, min, max, default, increment, func)
    local descriptionString = (descriptionString and #descriptionString > 0) and JSlang.trans(descriptionString) or ''
    return menu.slider_float(root, JSlang.trans(name), tableCommands, descriptionString, min, max, default, increment, function(value)func(value) end)
end

function JSlang.click_slider(root, name, tableCommands, descriptionString, min, max, default, increment, func)
    local descriptionString = (descriptionString and #descriptionString > 0) and JSlang.trans(descriptionString) or ''
    return menu.click_slider(root, JSlang.trans(name), tableCommands, descriptionString, min, max, default, increment, function(value)func(value) end)
end

function JSlang.click_slider_float(root, name, tableCommands, descriptionString, min, max, default, increment, func)
    local descriptionString = (descriptionString and #descriptionString > 0) and JSlang.trans(descriptionString) or ''
    return menu.click_slider_float(root, JSlang.trans(name), tableCommands, descriptionString, min, max, default, increment, function(value)func(value) end)
end

function JSlang.list_select(root, name, tableCommands, descriptionString, tableOptions, default, func)
    local descriptionString = (descriptionString and #descriptionString > 0) and JSlang.trans(descriptionString) or ''
    return menu.list_select(root, JSlang.trans(name), tableCommands, descriptionString, tableOptions, default, function()func() end)
end

function JSlang.list_action(root, name, tableCommands, descriptionString, tableOptions, func)
    local descriptionString = (descriptionString and #descriptionString > 0) and JSlang.trans(descriptionString) or ''
    return menu.list_action(root, JSlang.trans(name), tableCommands, descriptionString, tableOptions, function()func() end)
end

function JSlang.text_input(root, name, tableCommands, descriptionString, func, detault)
    local descriptionString = (descriptionString and #descriptionString > 0) and JSlang.trans(descriptionString) or ''
    return menu.text_input(root, JSlang.trans(name), tableCommands, descriptionString, function()func() end, detault)
end

function JSlang.colour(root, name, tableCommands, descriptionString, colour, transparency, func)
    local descriptionString = (descriptionString and #descriptionString > 0) and JSlang.trans(descriptionString) or ''
    return menu.colour(root, JSlang.trans(name), tableCommands, descriptionString, colour, transparency, function(colour)func(colour) end)
end

-- menu.rainbow(int colour_command)

function JSlang.divider(root, name)
    return menu.divider(root, JSlang.trans(name))
end

function JSlang.hyperlink(root, name, link, descriptionString)
    local descriptionString = (descriptionString and #descriptionString > 0) and JSlang.trans(descriptionString) or ''
    return menu.hyperlink(root, JSlang.trans(name), link, descriptionString)
end

function JSlang.action_slider(root, name, link, descriptionString, optionsTable, func)
    local descriptionString = (descriptionString and #descriptionString > 0) and JSlang.trans(descriptionString) or ''
    return menu.action_slider(root, JSlang.trans(name), link, descriptionString, optionsTable, function()func() end)
end

return JSlang
