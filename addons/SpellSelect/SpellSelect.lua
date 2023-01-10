addon.name      = 'SpellSelect';
addon.author    = 'Thorny';
addon.version   = '1.0';
addon.desc      = 'Allows you to cast spells by selecting tier and element.';
addon.link      = 'https://github.com/ThornyFFXI/MiscAshita4'

require('common');
local chat = require('chat');

local spellData = T{
    { Index=144, Element='fire', Tier='t1' }, --Fire
    { Index=145, Element='fire', Tier='t2' }, --Fire II
    { Index=146, Element='fire', Tier='t3' }, --Fire III
    { Index=147, Element='fire', Tier='t4' }, --Fire IV
    { Index=148, Element='fire', Tier='t5' }, --Fire V
    { Index=149, Element='ice', Tier='t1' }, --Blizzard
    { Index=150, Element='ice', Tier='t2' }, --Blizzard II
    { Index=151, Element='ice', Tier='t3' }, --Blizzard III
    { Index=152, Element='ice', Tier='t4' }, --Blizzard IV
    { Index=153, Element='ice', Tier='t5' }, --Blizzard V
    { Index=154, Element='wind', Tier='t1' }, --Aero
    { Index=155, Element='wind', Tier='t2' }, --Aero II
    { Index=156, Element='wind', Tier='t3' }, --Aero III
    { Index=157, Element='wind', Tier='t4' }, --Aero IV
    { Index=158, Element='wind', Tier='t5' }, --Aero V
    { Index=159, Element='earth', Tier='t1' }, --Stone
    { Index=160, Element='earth', Tier='t2' }, --Stone II
    { Index=161, Element='earth', Tier='t3' }, --Stone III
    { Index=162, Element='earth', Tier='t4' }, --Stone IV
    { Index=163, Element='earth', Tier='t5' }, --Stone V
    { Index=164, Element='lightning', Tier='t1' }, --Thunder
    { Index=165, Element='lightning', Tier='t2' }, --Thunder II
    { Index=166, Element='lightning', Tier='t3' }, --Thunder III
    { Index=167, Element='lightning', Tier='t4' }, --Thunder IV
    { Index=168, Element='lightning', Tier='t5' }, --Thunder V
    { Index=169, Element='water', Tier='t1' }, --Water
    { Index=170, Element='water', Tier='t2' }, --Water II
    { Index=171, Element='water', Tier='t3' }, --Water III
    { Index=172, Element='water', Tier='t4' }, --Water IV
    { Index=173, Element='water', Tier='t5' }, --Water V
    { Index=174, Element='fire', Tier='ga' }, --Firaga
    { Index=175, Element='fire', Tier='ga2' }, --Firaga II
    { Index=176, Element='fire', Tier='ga3' }, --Firaga III
    { Index=496, Element='fire', Tier='ja' }, --Firaja
    { Index=179, Element='ice', Tier='ga' }, --Blizzaga
    { Index=180, Element='ice', Tier='ga2' }, --Blizzaga II
    { Index=181, Element='ice', Tier='ga3' }, --Blizzaga III
    { Index=497, Element='ice', Tier='ja' }, --Blizzaja
    { Index=184, Element='wind', Tier='ga' }, --Aeroga
    { Index=185, Element='wind', Tier='ga2' }, --Aeroga II
    { Index=186, Element='wind', Tier='ga3' }, --Aeroga III
    { Index=498, Element='wind', Tier='ja' }, --Aeroja
    { Index=189, Element='earth', Tier='ga' }, --Stonega
    { Index=190, Element='earth', Tier='ga2' }, --Stonega II
    { Index=191, Element='earth', Tier='ga3' }, --Stonega III
    { Index=499, Element='earth', Tier='ja' }, --Stoneja
    { Index=194, Element='lightning', Tier='ga' }, --Thundaga
    { Index=195, Element='lightning', Tier='ga2' }, --Thundaga II
    { Index=196, Element='lightning', Tier='ga3' }, --Thundaga III
    { Index=500, Element='lightning', Tier='ja' }, --Thundaja
    { Index=199, Element='water', Tier='ga' }, --Waterga
    { Index=200, Element='water', Tier='ga2' }, --Waterga II
    { Index=201, Element='water', Tier='ga3' }, --Waterga III
    { Index=501, Element='water', Tier='ja' }, --Waterja
    { Index=204, Element='fire', Tier='am1' }, --Flare
    { Index=205, Element='fire', Tier='am2' }, --Flare II
    { Index=206, Element='ice', Tier='am1' }, --Freeze
    { Index=207, Element='ice', Tier='am2' }, --Freeze II
    { Index=208, Element='wind', Tier='am1' }, --Tornado
    { Index=209, Element='wind', Tier='am2' }, --Tornado II
    { Index=210, Element='earth', Tier='am1' }, --Quake
    { Index=211, Element='earth', Tier='am2' }, --Quake II
    { Index=212, Element='lightning', Tier='am1' }, --Burst
    { Index=213, Element='lightning', Tier='am2' }, --Burst II
    { Index=214, Element='water', Tier='am1' }, --Flood
    { Index=215, Element='water', Tier='am2' }, --Flood II
    { Index=235, Element='fire', Tier='eledot' }, --Burn
    { Index=236, Element='ice', Tier='eledot' }, --Frost
    { Index=237, Element='wind', Tier='eledot' }, --Choke
    { Index=238, Element='earth', Tier='eledot' }, --Rasp
    { Index=239, Element='lightning', Tier='eledot' }, --Shock
    { Index=240, Element='water', Tier='eledot' }, --Drown
    { Index=278, Element='earth', Tier='helix' }, --Geohelix
    { Index=279, Element='water', Tier='helix' }, --Hydrohelix
    { Index=280, Element='wind', Tier='helix' }, --Anemohelix
    { Index=281, Element='fire', Tier='helix' }, --Pyrohelix
    { Index=282, Element='ice', Tier='helix' }, --Cryohelix
    { Index=283, Element='lightning', Tier='helix' }, --Ionohelix
    { Index=284, Element='dark', Tier='helix' }, --Noctohelix
    { Index=285, Element='light', Tier='helix' }, --Luminohelix
    { Index=828, Element='fire', Tier='ra' }, --Fira
    { Index=829, Element='fire', Tier='ra2' }, --Fira II
    { Index=830, Element='ice', Tier='ra' }, --Blizzara
    { Index=831, Element='ice', Tier='ra2' }, --Blizzara II
    { Index=832, Element='wind', Tier='ra' }, --Aera
    { Index=833, Element='wind', Tier='ra2' }, --Aera II
    { Index=834, Element='earth', Tier='ra' }, --Stonera
    { Index=835, Element='earth', Tier='ra2' }, --Stonera II
    { Index=836, Element='lightning', Tier='ra' }, --Thundara
    { Index=837, Element='lightning', Tier='ra2' }, --Thundara II
    { Index=838, Element='water', Tier='ra' }, --Watera
    { Index=839, Element='water', Tier='ra2' }, --Watera II
    { Index=849, Element='fire', Tier='t6' }, --Fire VI
    { Index=850, Element='ice', Tier='t6' }, --Blizzard VI
    { Index=851, Element='wind', Tier='t6' }, --Aero VI
    { Index=852, Element='earth', Tier='t6' }, --Stone VI
    { Index=853, Element='lightning', Tier='t6' }, --Thunder VI
    { Index=854, Element='water', Tier='t6' }, --Water VI
    { Index=865, Element='fire', Tier='ra3' }, --Fira III
    { Index=866, Element='ice', Tier='ra3' }, --Blizzara III
    { Index=867, Element='wind', Tier='ra3' }, --Aera III
    { Index=868, Element='earth', Tier='ra3' }, --Stonera III
    { Index=869, Element='lightning', Tier='ra3' }, --Thundara III
    { Index=870, Element='water', Tier='ra3' }, --Watera III    
    { Index=885, Element='earth', Tier='helix2' }, --Geohelix II
    { Index=886, Element='water', Tier='helix2' }, --Hydrohelix II
    { Index=887, Element='wind', Tier='helix2' }, --Anemohelix II
    { Index=888, Element='fire', Tier='helix2' }, --Pyrohelix II
    { Index=889, Element='ice', Tier='helix2' }, --Cryohelix II
    { Index=890, Element='lightning', Tier='helix2' }, --Ionohelix II
    { Index=891, Element='dark', Tier='helix2' }, --Noctohelix II
    { Index=892, Element='light', Tier='helix2' }, --Luminohelix II
};

local currentTier = nil;
local currentElement = nil;

local function CheckLevels(resource)
    local playMgr = AshitaCore:GetMemoryManager():GetPlayer();
    local mainJob = playMgr:GetMainJob();
    local mainJobLevel = playMgr:GetMainJobLevel();
    local subJob = playMgr:GetSubJob();
    local subJobLevel = playMgr:GetSubJobLevel();


    local jobMask = resource.JobPointMask;
    local levelRequired = resource.LevelRequired;

    if bit.band(bit.rshift(jobMask, mainJob), 1) == 1 then
        return (mainJobLevel == 99); --Assume player knows JP spells if 99
    elseif (levelRequired[mainJob + 1] ~= -1) and (mainJobLevel >= levelRequired[mainJob + 1]) then
        return true;
    end

    if bit.band(bit.rshift(jobMask, subJob), 1) ~= 1 then
        local level = levelRequired[subJob + 1];        
        return (level ~= -1) and (subJobLevel >= level);
    end

    return false;
end

local function TryCastSpell(resource) 
    --Check that player knows the spell scroll
    local playMgr = AshitaCore:GetMemoryManager():GetPlayer();
    if not playMgr:HasSpell(resource.Index) then
        return false;
    end

    --Check that player has the level for spell(not checking job points..) 
    local resource = AshitaCore:GetResourceManager():GetSpellById(resource.Index);
    if not CheckLevels(resource) then
        return false;
    end


    if AshitaCore:GetMemoryManager():GetRecast():GetSpellTimer(resource.Index) ~= 0 then
        return false;
    end

    AshitaCore:GetChatManager():QueueCommand(1, string.format('/ma "%s" <t>', resource.Name[1]));
    return true;
end


ashita.events.register('command', 'command_cb', function (e)
    local args = e.command:args();
    if (#args == 0) then
        return;
    end

    if (string.lower(args[1]) == '/spellselect') or (string.lower(args[1]) == '/ss') then
        e.blocked = true;
        if (#args < 2) then
            return;
        end

        if (string.lower(args[2]) == 'setele') then
            if #args > 2 then
                local element = string.lower(args[3]);
                
                if (element == 'any') then
                    currentElement = nil;
                    print(chat.header('SpellSelect') .. chat.message('Element set to: ') .. chat.color1(2, 'Any'));
                    return;
                end

                for _,v in ipairs(spellData) do
                    if (v.Element == element) then
                        currentElement = element;
                        print(chat.header('SpellSelect') .. chat.message('Element set to: ') .. chat.color1(2, element));
                        return;
                    end
                end
            end
            
            print(chat.header('SpellSelect') .. chat.error('Invalid element provided.'));
            return;
        end
        
        if (string.lower(args[2]) == 'settier') then
            if #args > 2 then
                local tier = string.lower(args[3]);

                if (tier == 'any') then
                    currentTier = nil;
                    print(chat.header('SpellSelect') .. chat.message('Tier set to: ') .. chat.color1(2, 'Any'));
                    return;
                end

                for _,v in ipairs(spellData) do
                    if (v.Tier == tier) then
                        currentTier = tier;
                        print(chat.header('SpellSelect') .. chat.message('Tier set to: ') .. chat.color1(2, tier));
                        return;
                    end
                end
            end
            
            print(chat.header('SpellSelect') .. chat.error('Invalid tier provided.'));
            return;
        end

        if (string.lower(args[2]) == 'nuke') then
            local matchTier = currentTier;
            local matchElement = currentElement;
            if #args > 2 then
                for index=3,#args do
                    local match = string.lower(args[index]);
                    for _,v in ipairs(spellData) do
                        if (v.Element == match) then
                            matchElement = match;
                            break;
                        elseif (v.Tier == match) then
                            matchTier = match;
                            break;
                        end
                    end
                end
            end

            for _,spell in ipairs(spellData) do
                if ((matchTier == nil) or (spell.Tier == matchTier)) then
                    if ((matchElement == nil) or (spell.Element == matchElement)) then
                        if TryCastSpell(spell) then
                            return;                       
                        end
                    end
                end
            end
            
            print(chat.header('SpellSelect') .. chat.error('No matching spell is ready.'));
            return;
        end
    end
end);