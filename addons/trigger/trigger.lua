addon.name      = 'Trigger'
addon.author    = 'Thorny';
addon.version   = '1.0';
addon.desc      = 'Binds commands to shoulder buttons of controller.';
addon.link      = 'https://ashitaxi.com/';

require('common');
chat = require('chat');

local dmap = {
    [52] = 'leftshoulder',
    [53] = 'rightshoulder',
    [54] = 'lefttrigger',
    [55] = 'righttrigger'
};
local dState = {};
local xmap = {
    [8] = 'leftshoulder',
    [9] = 'rightshoulder',
    [32] = 'lefttrigger',
    [33] = 'righttrigger' 
};
local xState = {};

local bindings = {};

ashita.events.register('dinput_button', 'dinput_button_cb', function (e)
    local mapping = dmap[e.button];
    if mapping then
        local state = dState[e.button];
        if (state == 0) or (state == nil) then
            if (e.state > 0) then
                local binding = bindings[mapping];
                if (binding) then
                    AshitaCore:GetChatManager():QueueCommand(-1, binding);
                end
            end
        end
        dState[e.button] = e.state;
    end
end);

ashita.events.register('xinput_button', 'xinput_button_cb', function (e)
    local mapping = xmap[e.button];
    if mapping then
        local state = xState[e.button];
        if (state == 0) or (state == nil) then
            if (e.state > 0) then
                local binding = bindings[mapping];
                if (binding) then
                    AshitaCore:GetChatManager():QueueCommand(-1, binding);
                end
            end
        end
        xState[e.button] = e.state;
    end
end);

ashita.events.register('command', 'command_cb', function (e)
    local trimmed = string.sub(string.lower(e.command), 1, 12);
    if (trimmed == '/trigger ls ') then
        local newBinding = string.sub(e.command, 13);
        bindings['leftshoulder'] = newBinding;
        print(string.format('%s%s%s', chat.header('Trigger'), chat.message('Bound left shoulder to:'), chat.color1(2, newBinding)));
        e.blocked = true;
        return;
    end
    if (trimmed == '/trigger rs ') then
        local newBinding = string.sub(e.command, 13);
        bindings['rightshoulder'] = newBinding;
        print(string.format('%s%s%s', chat.header('Trigger'), chat.message('Bound right shoulder to:'), chat.color1(2, newBinding)));
        e.blocked = true;
        return;
    end
    if (trimmed == '/trigger lt ') then
        local newBinding = string.sub(e.command, 13);
        bindings['lefttrigger'] = newBinding;
        print(string.format('%s%s%s', chat.header('Trigger'), chat.message('Bound left trigger to:'), chat.color1(2, newBinding)));
        e.blocked = true;
        return;
    end
    if (trimmed == '/trigger rt ') then
        local newBinding = string.sub(e.command, 13);
        bindings['righttrigger'] = newBinding;
        print(string.format('%s%s%s', chat.header('Trigger'), chat.message('Bound right trigger to:'), chat.color1(2, newBinding)));
        e.blocked = true;
        return;
    end
end);