addon.name      = 'SellIt';
addon.author    = 'Thorny';
addon.version   = '1.0';
addon.desc      = 'Provides one function of bellhop, but worse.';
addon.link      = 'https://ashitaxi.com/';

require('common');
local chat = require('chat');

--The minimum delay between item sales..
local baseDelay = 2;

local activeTerm;
local activeDelay = 0;


local function LocateItem(itemTerm)
    local invMgr = AshitaCore:GetMemoryManager():GetInventory();
    for i = 1,80 do
        local item = invMgr:GetContainerItem(0, i);
        if (item.Id > 0) then
            local resource = AshitaCore:GetResourceManager():GetItemById(item.Id);
            if (string.lower(resource.Name[1]) == itemTerm) and (bit.band(resource.Flags, 0x1000) == 0) then
                return item;
            end
        end
    end
end

ashita.events.register('command', 'cb_HandleCommand', function (e)
    if string.sub(string.lower(e.command),1,8) ~= '/sellit ' then
        return;
    end

    e.blocked = true;
    if (string.len(e.command) < 9) then
        return;
    end
    
    local itemTerm = string.sub(e.command, 9);
    itemTerm = string.lower(AshitaCore:GetChatManager():ParseAutoTranslate(itemTerm, false));
    local item = LocateItem(itemTerm);
    if (item ~= nil) then
        local res = AshitaCore:GetResourceManager():GetItemById(item.Id);
        activeTerm = itemTerm;
        print(chat.header('SellIt') .. chat.message('Beginning sale of ') .. chat.color1(2, res.Name[1]) .. chat.message('.'));
    else
        activeTerm = nil;
        print(chat.header('SellIt') .. chat.error('No matching items were found.'));
    end
end);

ashita.events.register('packet_out', 'cb_HandleOutgoingPacket', function (e)
    if (e.id == 0x15) and (activeTerm ~= nil) and (os.clock() > activeDelay) then
        local item = LocateItem(activeTerm);
        if (item == nil) then
            print(chat.header('SellIt') .. chat.message('Sale complete.'));
            activeTerm = nil;
            return;
        else
            local appraise = struct.pack('LLHBB', 0, item.Count, item.Id, item.Index, 0);
            AshitaCore:GetPacketManager():AddOutgoingPacket(0x84, appraise:totable());
            local confirm = struct.pack('LL', 0, 1);
            AshitaCore:GetPacketManager():AddOutgoingPacket(0x85, confirm:totable());
            activeDelay = os.clock() + baseDelay;
        end
    end
end);