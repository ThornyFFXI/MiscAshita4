addon.name      = 'Cudgel';
addon.author    = 'Thorny';
addon.version   = '1.0';
addon.desc      = 'Equips the best warp cudgel you have available.';
addon.link      = 'https://ashitaxi.com/';

require('common');
local chat = require('chat');
local timePointer = ashita.memory.find('FFXiMain.dll', 0, '8B0D????????8B410C8B49108D04808D04808D04808D04C1C3', 2, 0);
local vanaOffset = 0x3C307D70;

local function GetTimeUTC()
    local ptr = ashita.memory.read_uint32(timePointer);
    ptr = ashita.memory.read_uint32(ptr);
    return ashita.memory.read_uint32(ptr + 0x0C);
end

local function TimerToString(timer)
    if (timer >= 3600) then
        local h = math.floor(timer / (3600));
        local m = math.floor(math.fmod(timer, 3600) / 60);
        return string.format('%i:%02i', h, m);
    elseif (timer >= 60) then
        local m = math.floor(timer / 60);
        local s = math.fmod(timer, 60);
        return string.format('%i:%02i', m, s);
    else
        if (timer < 1) then
            return 'Ready';
        else
            return string.format('0:%02i', timer);
        end
    end
end

ashita.events.register('command', 'command_cb', function (e)
    if string.lower(e.command) == '/cudgel' then
        e.blocked = true;
        local bestCudgel = nil;

        local time = GetTimeUTC();
        local containers = T{0,8,10,11,12,13,14,15,16};
        local invMgr = AshitaCore:GetMemoryManager():GetInventory();
        for _,container in ipairs(containers) do
            for index = 1,80 do
                local item = invMgr:GetContainerItem(container, index);
                if (item.Id == 17040) then
                    local charges = struct.unpack('B', item.Extra, 2);
                    local useTime = (struct.unpack('L', item.Extra, 5) + vanaOffset) - time;
                    if (useTime < 3) then useTime = 0; end

                    if (bestCudgel == nil) or (useTime < bestCudgel.TimeUntilUse) or ((useTime == bestCudgel.TimeUntilUse) and (charges > bestCudgel.Charges)) then
                        bestCudgel = { Container=container, Index=index, TimeUntilUse = useTime, Charges = charges };
                    end
                end
            end
        end

        if (bestCudgel ~= nil) then
            local packet = { 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00 };
            packet[5] = bestCudgel.Index;
            packet[6] = 0; --Main weapon
            packet[7] = bestCudgel.Container;
            AshitaCore:GetPacketManager():AddOutgoingPacket(0x50, packet);


            local outString = chat.header('Cudgel');
            outString = outString .. chat.message('Equipping warp cudgel.  Charges:');
            outString = outString .. chat.color1(2, tostring(bestCudgel.Charges));
            outString = outString .. chat.message(' Cooldown:');
            outString = outString .. chat.color1(2, TimerToString(bestCudgel.TimeUntilUse));
            print(outString);
            return;
        end

        print(chat.header('Cudgel') .. chat.error('Could not find a warp cudgel.'));
    end
end);