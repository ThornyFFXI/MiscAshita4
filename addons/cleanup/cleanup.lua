 --Credit to Chiaia for a similar Windower addon with an unfortunately inappropriate name
addon.author   = 'Thorny';
addon.name     = 'Cleanup';
addon.desc     = 'Blacklist replacement & Log filter';
addon.version  = '1.01';

require ('common');
chat = require('chat')
local gui = require('gui')
settings = {};

local conversionMap = {};
for i = 0,255 do
    local key = string.char(i);
    local val = key;
    if (i < 0x20) or (i > 0x7E) or (T{0x22, 0x5C}:contains(key)) then
        val = string.format('\\x%02X', i);
    end
    conversionMap[key] = val;
end
local path = string.format('%s/config/addons/cleanup', AshitaCore:GetInstallPath());
if not ashita.fs.exists(path) then
    ashita.fs.create_dir(path);
end
local filePath = path .. '/settings.lua';
local function SanitizeTerm(str)
    return string.gsub(str, '(.)', function(a) return conversionMap[a] end);
end

function WriteSettings(data, reload)
    local file = io.open(filePath, 'w');
    if file then
        local sorted = T{};
        for name,_ in pairs(data.Names) do
            sorted:append(name);
        end
        table.sort(sorted);
        file:write('return {\n');
        file:write('    Names={\n');
        for _,entry in ipairs(sorted) do
            file:write(string.format('        ["%s"] = true,\n', entry));
        end
        file:write('    },\n');
        file:write('    Terms=T{\n');
        for _,term in ipairs(data.Terms) do
            file:write(string.format('        "%s",\n', SanitizeTerm(term)));
        end
        file:write('    },\n');
        file:write('};');
        file:close();

        if reload and AshitaCore:GetPluginManager():IsLoaded('Multisend') then
            AshitaCore:GetChatManager():QueueCommand(-1, '/ms sendothers /cu reload');
        end
    end
end

local function LoadSettings()
    if not ashita.fs.exists(filePath) then
        WriteSettings({Names={}, Terms=T{}});
    end

    local success, loadError = loadfile(filePath);
    if not success then
        print(chat.header('CleanUp') .. chat.error('Failed to load settings file.'));
        settings = {Names={}, Terms=T{}};
        return;
    end

    local result, output = pcall(success);
    if not result then
        print(chat.header('CleanUp') .. chat.error('Failed to execute settings file.'));
        settings = {Names={}, Terms=T{}};
        return;
    end
    settings = output;
end

--[[
* Returns a string cleaned from FFXI specific tags and special characters.
* Credit to Atom0s
* @param {string} str - The string to clean.
* @return {string} The cleaned string.
--]]
local function clean_str(str)
    -- Parse the strings auto-translate tags..
    str = AshitaCore:GetChatManager():ParseAutoTranslate(str, true);

    -- Strip FFXI-specific color and translate tags..
    str = str:strip_colors();
    str = str:strip_translate(true);

    -- Strip line breaks..
    while (true) do
        local hasN = str:endswith('\n');
        local hasR = str:endswith('\r');

        if (not hasN and not hasR) then
            break;
        end

        if (hasN) then str = str:trimend('\n'); end
        if (hasR) then str = str:trimend('\r'); end
    end

    -- Replace mid-linebreaks and change to lowercase..
    return string.lower(str:gsub(string.char(0x07), '\n'));
end

local function EvaluateTerm(msg, term)
    return string.match(msg, term);
end

LoadSettings();
ashita.events.register('packet_in', 'Cleanup_HandleIncomingPacket', function (e)
    if (e.id == 0x017) then
        local sender = struct.unpack('c15', e.data, 0x08+1):trimend('\x00');
        local msg = clean_str(struct.unpack('s', e.data, 0x17 + 1));
        if settings.Names[sender] then
            e.blocked = true;
            return;
        end
        for _,term in ipairs(settings.Terms) do
            if EvaluateTerm(msg, string.lower(term)) then
                e.blocked = true;
                return;
            end
        end
    end
end);

ashita.events.register('command', 'Cleanup_command_cb', function (e)
    local args = e.command:args();
    if (#args == 0) or (string.lower(args[1]) ~= "/cu") then
        return;
    end
    
    e.blocked = true;
    if (#args > 1) and (string.lower(args[2]) == 'block') then
        if args[3] then
            local name = string.upper(string.sub(args[3], 1, 1)) .. string.lower(string.sub(args[3], 2));
            if settings.Names[name] ~= true then
                settings.Names[name] = true;
                WriteSettings(settings, true);
                print(chat.header('CleanUp') .. chat.message(string.format('Added %s to block list.', name)));
            end
        end
        return;
    end
    
    if (#args > 1) and (args[2] == 'reload') then
        LoadSettings();
        print(chat.header('CleanUp') .. chat.message('Reloaded settings'));
        return;
    end

    gui:show();
end);