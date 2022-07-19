local script_store_dir = filesystem.store_dir() ..'JerryScript\\'

local store_options = {}
local tabs = {
    [menu.my_root()] = 0,
    [menu.player_root(players.user())] = 0,
}

CL = {}

function get_string(label)
    if type(label) != 'number' then return string.gsub(label, '\n', ' ') end
    return string.gsub(lang.get_string(label, lang.get_current()), '\n', ' ')
end

local f = assert(io.open(script_store_dir .. 'commandList.txt', 'a'))

function makeLine(root, name, commands, help)
    local line = ''
    for i = 1, tabs[root] do
        line ..= '	'
    end
    line ..= get_string(name)
    local help = get_string(help)
    if help != '' then
        line ..= ' — ' .. help
    end
    if #commands > 0 then
        line ..= ' — Command: '
        for k, v in ipairs(commands) do
            line ..= v .. ' ; '
        end
        line = line:sub(0, #line - 3)
    end
    f:write(line .. '\n')
end

function makeLineToggle(root, name, commands, help)
    local line = ''
    for i = 1, tabs[root] do
        line ..= '	'
    end
    line ..= get_string(name)
    local help = get_string(help)
    if help != '' then
        line ..= ' — ' .. help
    end
    if #commands > 0 then
        line ..= ' — Command: '
        for k, v in ipairs(commands) do
            line ..= v .. ' ; '
        end
        line = line:sub(0, #line - 2)
        line ..= '[on/off]'
    else
        line ..= '(On/Off)'
    end
    f:write(line .. '\n')
end


function makeLineSlider(root, name, commands, help, min, max)
    local line = ''
    for i = 1, tabs[root] do
        line ..= '	'
    end
    line ..= get_string(name) .. ' ('.. min ..' to '.. max ..')'
    local help = get_string(help)
    if help != '' then
        line ..= ' — ' .. help
    end
    if #commands > 0 then
        line ..= ' — Command: '
        for k, v in ipairs(commands) do
            line ..= v .. ' ; '
        end
        line = line:sub(0, #line - 2)
        line ..= ' ['.. min ..' to '.. max ..']'
    end
    f:write(line .. '\n')
end

function getFloatString(num)
    local str = tostring(num)
    return str:sub(0, #str -2) ..'.'.. str:sub(#str -1, #str)
end

function CL.list(root, name, commands, help, ...)
    local list = menu.list(root, name, commands, help, ...)
    tabs[list] = tabs[root] + 1

    makeLine(root, name, commands, help)

    return list
end

function CL.action(root, name, commands, help, ...)
    local action = menu.action(root, name, commands, help, ...)

    makeLine(root, name, commands, help)

    return action
end

function CL.toggle(root, name, commands, help, ...)
    local toggle = menu.toggle(root, name, commands, help, ...)

    makeLineToggle(root, name, commands, help)

    return toggle
end

function CL.toggle_loop(root, name, commands, help, ...)
    local toggle_loop = menu.toggle_loop(root, name, commands, help, ...)

    makeLineToggle(root, name, commands, help)

    return toggle_loop
end

function CL.slider(root, name, commands, help, min, max, ...)
    local slider = menu.slider(root, name, commands, help, min, max, ...)

    makeLineSlider(root, name, commands, help, min, max)

    return slider
end

function CL.slider_float(root, name, commands, help, min, max, ...)
    local slider_float = menu.slider_float(root, name, commands, help, min, max, ...)

    makeLineSlider(root, name, commands, help, getFloatString(min), getFloatString(max))

    return slider_float
end

function CL.click_slider(root, name, commands, help, min, max, ...)
    local click_slider = menu.click_slider(root, name, commands, help, min, max, ...)

    makeLineSlider(root, name, commands, help, min, max)

    return click_slider
end

function CL.click_slider_float(root, name, commands, help, min, max, ...)
    local click_slider_float = menu.click_slider_float(root, name, commands, help, min, max, ...)

    makeLineSlider(root, name, commands, getFloatString(min), getFloatString(max))

    return click_slider_float
end

function CL.list_select(root, name, commands, help, ...)
    local list_select = menu.list_select(root, name, commands, help, ...)

    makeLine(root, name, commands, help)

    return list_select
end

function CL.list_action(root, name, commands, help, ...)
    local list_action = menu.list_action(root, name, commands, help, ...)

    makeLine(root, name, commands, help)

    return list_action
end

function CL.text_input(root, name, commands, help, ...)
    local text_input = menu.text_input(root, name, commands, help, ...)

    makeLine(root, name, commands, help)

    return text_input
end

function CL.colour(root, name, commands, help, ...)
    local colour = menu.colour(root, name, commands, help, ...)

    makeLine(root, name, commands, help)

    return colour
end

function CL.action_slider(root, name, commands, help, ...)
    local action_slider = menu.action_slider(root, name, commands, help, ...)

    makeLine(root, name, commands, help)

    return action_slider
end

function CL.hyperlink(root, name, link, ...)
    local hyperlink = menu.hyperlink(root, name, link, ...)

    local line = ''
    for i = 1, tabs[root] do
        line ..= '	'
    end
    line ..= get_string(name)
    line ..= ' — Link: '.. link
    f:write(line .. '\n')

    return hyperlink
end


util.create_thread(function()
    util.yield(1600)
    f:close()
end)
