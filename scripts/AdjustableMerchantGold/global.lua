local types = require('openmw.types')
local storage = require('openmw.storage')
local async = require('openmw.async')
local world = require('openmw.world')
local I = require('openmw.interfaces')

-----------------------------------------------------------
-- Settings registration
-----------------------------------------------------------

I.Settings.registerPage {
    key = 'AdjustableMerchantGold',
    l10n = 'AdjustableMerchantGold',
    name = 'PageName',
    description = 'PageDescription',
}

I.Settings.registerGroup {
    key = 'SettingsGlobalAdjustableMerchantGold',
    page = 'AdjustableMerchantGold',
    l10n = 'AdjustableMerchantGold',
    name = 'GroupName',
    description = 'GroupDescription',
    permanentStorage = true,
    settings = {
        {
            key = 'GoldMultiplier',
            renderer = 'number',
            name = 'GoldMultiplier_name',
            description = 'GoldMultiplier_description',
            default = 5,
            argument = {
                min = 0.1,
                max = 100,
            },
        },
    },
}

local settings = storage.globalSection('SettingsGlobalAdjustableMerchantGold')

-----------------------------------------------------------
-- Core logic
-----------------------------------------------------------

--- Get the base barter gold from the record for an NPC or Creature.
local function getBaseGold(actor)
    if types.NPC.objectIsInstance(actor) then
        return types.NPC.record(actor).baseGold
    elseif types.Creature.objectIsInstance(actor) then
        return types.Creature.record(actor).baseGold
    end
    return 0
end

--- Apply the configured multiplier to a single actor's barter gold.
local function applyMultiplier(actor)
    local baseGold = getBaseGold(actor)
    if baseGold and baseGold > 0 then
        local multiplier = settings:get('GoldMultiplier') or 1
        local newGold = math.floor(baseGold * multiplier)
        types.Actor.setBarterGold(actor, newGold)
    end
end

--- Re-apply the multiplier to every currently active actor (used when
--- the player changes the setting mid-game).
local function reapplyAll()
    for _, actor in ipairs(world.activeActors) do
        applyMultiplier(actor)
    end
end

-- Subscribe to setting changes so the effect is applied immediately.
settings:subscribe(async:callback(function(_, key)
    if key == 'GoldMultiplier' or key == nil then
        reapplyAll()
    end
end))

-----------------------------------------------------------
-- Engine handlers
-----------------------------------------------------------

return {
    engineHandlers = {
        -- Every time an actor becomes active (player enters a cell,
        -- game loads, etc.) we set its barter gold to the multiplied value.
        onActorActive = function(actor)
            applyMultiplier(actor)
        end,
    },
}
