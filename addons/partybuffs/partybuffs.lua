addon.name      = 'PartyBuffs';
addon.author    = 'Thorny';
addon.version   = '1.07';
addon.desc      = 'Displays party buffs next to vanilla party list.';
addon.link      = 'https://github.com/ThornyFFXI/MiscAshita4';

require('common');
local chat = require('chat');
ffi  = require('ffi');
d3d8 = require('d3d8');
d3d8_device = d3d8.get_device();
renderer = require('spriterenderer');

local memberDisplay = require('memberdisplay');
local settingLib = require('settings');
local partyMembers = T{};

local default_settings = T{
    distance_object = {
        visible        = true,
        can_focus      = false,
        locked         = true,
        lockedz        = true,
        is_dirty       = true,
        font_file      = nil,
        font_family    = 'Comic Sans MS',
        font_height    = 8,
        bold           = true,
        italic         = false,
        right_justified= true,
        strike_through = false,
        underlined     = false,
        color          = 0xFFFF0000,
        color_outline  = 0x00000000,
        padding        = 0.1,
        position_x     = 0,
        position_y     = 0,
        auto_resize    = true,
        anchor         = FrameAnchor.TopLeft,
        anchor_parent  = FrameAnchor.TopLeft,
        text           = '',
    
        -- Font Background Defaults
        background = T{
            texture_offset_x= 0.0,
            texture_offset_y= 0.0,
            border_visible  = false,
            border_color    = 0x00000000,
            border_flags    = FontBorderFlags.None,
            border_sizes    = '0,0,0,0',
            visible         = false,
            position_x      = 0,
            position_y      = 0,
            can_focus       = true,
            locked          = false,
            lockedz         = false,
            scale_x         = 1.0,
            scale_y         = 1.0,
            width           = 0.0,
            height          = 0.0,
            color           = 0xFFFFFFFF,
        }
    },
    show_distance = true,
    show_self = false,
    size = 20,
    exclusions = T{},
    priority = T{},
};

settings = settingLib.load(default_settings);

settingLib.register('settings', 'settings_update', function(newSettings)
    settings = newSettings;
    for _,member in ipairs(partyMembers) do
        member.FontObject:apply(settings.distance_object);
    end
end);

ashita.events.register('load', 'load_cb', function ()
    for i = 0,5 do
        local newMember = memberDisplay:New();
        newMember:Initialize(i);
        partyMembers:append(newMember);
    end
end)

ashita.events.register('unload', 'unload_cb', function ()
    for _,member in ipairs(partyMembers) do
        member:Destroy();
    end
end)


local function StringToBuff(buffString)
    local resMgr = AshitaCore:GetResourceManager();
    local compLower = string.lower(buffString);
    for i = 1,1024 do
        local buffName = resMgr:GetString('buffs.names', i);
        if (buffName ~= nil) and (string.lower(buffName) == compLower) then
            return i, buffName;
        end
    end    
end

ashita.events.register('command', 'command_cb', function (e)
    local args = e.command:args();
    if (#args == 0 or args[1] ~= '/pb') then
        return;
    end
    e.blocked = true;

    if (#args < 2) then
        return;
    end
    
    if (string.lower(args[2]) == 'distance') then
        settings.show_distance = not settings.show_distance;
        settingLib.save();
        print(chat.header('PartyBuffs') .. chat.message('Distance display ') .. chat.color1(2, settings.show_distance and 'enabled' or 'disabled') .. chat.message('.'));
        return;
    end
    
    if (string.lower(args[2]) == 'self') then
        settings.show_self = not settings.show_self;
        settingLib.save();
        print(chat.header('PartyBuffs') .. chat.message('Self display ') .. chat.color1(2, settings.show_self and 'enabled' or 'disabled') .. chat.message('.'));
        return;
    end

    if (string.lower(args[2]) == 'exclusion') then
        if (#args > 2) and (string.lower(args[3]) == 'default') then
            settings.exclusions = T{ 34, 35, 38, 56, 57, 58, 59, 60, 62, 65, 68, 72, 73, 74, 75, 76, 77, 78, 79, 87, 90, 91, 92, 93, 94, 95, 96, 97, 98, 99, 114, 115, 117, 118, 127, 143, 150, 151, 152, 155, 157, 158, 159, 160, 161, 162, 171, 172, 176, 187, 188, 190, 191, 229, 230, 232, 235, 236, 237, 238, 239, 240, 241, 242, 243, 249, 250, 252, 253, 254, 256, 257, 258, 260, 261, 262, 263, 264, 266, 267, 268, 269, 270, 271, 272, 273, 274, 276, 277, 278, 279, 280, 281, 282, 284, 285, 287, 288, 289, 290, 292, 293, 294, 295, 296, 297, 298, 300, 301, 302, 303, 304, 305, 306, 307, 308, 340, 341, 342, 343, 345, 346, 349, 350, 351, 352, 353, 354, 355, 357, 358, 359, 360, 361, 362, 363, 364, 365, 366, 367, 368, 369, 371, 375, 381, 382, 383, 384, 385, 386, 387, 388, 389, 390, 391, 392, 393, 394, 395, 396, 397, 398, 399, 400, 401, 402, 405, 406, 407, 408, 409, 410, 411, 412, 413, 414, 415, 416, 422, 423, 424, 425, 426, 427, 428, 429, 430, 431, 432, 433, 434, 435, 436, 438, 439, 440, 441, 442, 443, 447, 448, 449, 450, 451, 452, 456, 457, 460, 461, 462, 463, 464, 465, 466, 467, 468, 469, 470, 472, 474, 475, 476, 478, 479, 480, 481, 482, 483, 484, 486, 487, 488, 489, 510, 511, 512, 523, 524, 525, 526, 527, 528, 529, 530, 532, 576, 577, 578, 579, 585, 605, 606, 607, 608, 609, 610, 611, 613, 614, 615, 616 };
            settingLib.save();
            return;
        end
        if (#args < 4) then
            print(chat.header('PartyBuffs') .. chat.error('Command format is: ') .. chat.color1(2, '/pb exclusion [add/remove] [buff name]') .. chat.error('.'));
            return;
        elseif (string.lower(args[3]) == 'add') then
            local buffId, buffName = StringToBuff(args[4]);
            if (buffId == nil) then
                print(chat.header('PartyBuffs') .. chat.error(string.format('Could not find a buff named: %s', args[4])));
            elseif (settings.exclusions:contains(buffId)) then
                print(chat.header('PartyBuffs') .. chat.error(string.format('%s was already in your exclusions!', buffName)));
            else
                settings.exclusions:append(buffId);
                print(chat.header('PartyBuffs') .. chat.color1(2, buffName) .. chat.message(' added to exclusions.'));
                settingLib.save();
            end
        elseif (string.lower(args[3]) == 'remove') then
            local buffId, buffName = StringToBuff(args[4]);
            if (buffId == nil) then
                print(chat.header('PartyBuffs') .. chat.error(string.format('Could not find a buff named: %s', args[4])));
            elseif (settings.exclusions:contains(buffId)) then
                local newExclusions = T{};
                for _,exclusion in ipairs(settings.exclusions) do
                    if (exclusion ~= buffId) then
                        newExclusions:append(exclusion);
                    end
                end
                settings.exclusions = newExclusions;
                print(chat.header('PartyBuffs') .. chat.color1(2, buffName) .. chat.message(' removed from exclusions.'));
                settingLib.save();
            else
                print(chat.header('PartyBuffs') .. chat.error(string.format('%s was not in your exclusions!', buffName)));
            end
        end
    end
    
    if (string.lower(args[2]) == 'priority') then
        if (#args < 4) then
            print(chat.header('PartyBuffs') .. chat.error('Command format is: ') .. chat.color1(2, '/pb priority [add/remove] [buff name]') .. chat.error('.'));
            return;
        elseif (string.lower(args[3]) == 'add') then
            local buffId, buffName = StringToBuff(args[4]);
            if (buffId == nil) then
                print(chat.header('PartyBuffs') .. chat.error(string.format('Could not find a buff named: %s', args[4])));
            elseif (settings.priority:contains(buffId)) then
                print(chat.header('PartyBuffs') .. chat.error(string.format('%s was already in your priorities!', buffName)));
            else
                settings.priority:append(buffId);
                print(chat.header('PartyBuffs') .. chat.color1(2, buffName) .. chat.message(' added to priorities.'));
                settingLib.save();
            end
        elseif (string.lower(args[3]) == 'remove') then
            local buffId, buffName = StringToBuff(args[4]);
            if (buffId == nil) then
                print(chat.header('PartyBuffs') .. chat.error(string.format('Could not find a buff named: %s', args[4])));
            elseif (settings.priority:contains(buffId)) then
                local newPrioritys = T{};
                for _,priority in ipairs(settings.priority) do
                    if (priority ~= buffId) then
                        newPrioritys:append(priority);
                    end
                end
                settings.priority = newPrioritys;
                print(chat.header('PartyBuffs') .. chat.color1(2, buffName) .. chat.message(' removed from priorities.'));
                settingLib.save();
            else
                print(chat.header('PartyBuffs') .. chat.error(string.format('%s was not in your priorities!', buffName)));
            end
        end
    end

end);

ashita.events.register('d3d_present', 'd3d_present_cb', function ()
    renderer:Begin();
    for _,member in ipairs(partyMembers) do
        member:Render();
    end
    renderer:End();
end);