addon.name      = 'nomount';
addon.author    = 'Thorny';
addon.version   = '1.0';
addon.desc      = 'Blocks default mount music.';
addon.link      = 'https://ashitaxi.com/';

require('common');

local blockedSongs = T{ 84, 212 };

ashita.events.register('packet_in', 'packet_in_cb', function (e)
    -- Packet: Music Update
    if (e.id == 0x5F) then
        local song = struct.unpack('H', e.data, 0x06 + 1);
        if (blockedSongs:contains(song)) then
            e.blocked = true;
        end
    end
end);