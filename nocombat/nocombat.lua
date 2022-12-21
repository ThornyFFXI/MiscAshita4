addon.name      = 'nocombat';
addon.author    = 'Thorny';
addon.version   = '1.0';
addon.desc      = 'Changes the combat music for a zone to match the zone\'s default music.';
addon.link      = 'https://ashitaxi.com/';

require('common');

ashita.events.register('packet_in', 'packet_in_cb', function (e)
    -- Packet: Party Request
    if (e.id == 0x00A) then
        local music = struct.unpack('H', e.data, 0x56 + 1);
        ashita.bits.pack_be(e.data_modified_raw, music, 0x58, 0, 16);
        ashita.bits.pack_be(e.data_modified_raw, music, 0x5A, 0, 16);
        ashita.bits.pack_be(e.data_modified_raw, music, 0x5C, 0, 16);
    end
end);