addon.name      = 'nomount';
addon.author    = 'Thorny';
addon.version   = '1.01';
addon.desc      = 'Blocks default mount music.';
addon.link      = 'https://ashitaxi.com/';

require('common');

local blockedSongs = T{ 84, 212 };

ashita.events.register('packet_in', 'packet_in_cb', function (e)
    -- Packet: Zone In
    if (e.id == 0x0A) then
        -- Zero active mount music
        ashita.bits.pack_be(e.data_modified_raw, 0, 0x5E, 0, 16);
    end
    -- Packet: Music Update
    if (e.id == 0x5F) then
        local song = struct.unpack('H', e.data, 0x06 + 1);
        if (blockedSongs:contains(song)) then
            e.blocked = true;
        end
    end
end);