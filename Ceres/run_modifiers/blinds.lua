local blind_atlas = SMODS.Atlas{
    key = 'blinds',
    path = 'blinds.png',
    px = 34,
    py = 34,
    atlas_table = 'ANIMATION_ATLAS',
    frames = 21,
}

-- custom blinds

local gun_devil = Ceres.CONFIG.run_modifiers.blinds.enabled and SMODS.Blind{
    key = 'gun_devil',
    boss_colour = Ceres.C.devil,
    dollars = 10,
    mult = 2.5,
    boss = {
        showdown = true
    },
    pos = {
        x = 0,
        y = 0,
    },
    atlas = 'blinds',
    discovered = false or Ceres.CONFIG.misc.discover_all.enabled,
    debuff = {},
    vars = {1,},

    loc_vars = function(self)
        return { vars = {G.GAME.probabilities.normal}}
    end,

    recalc_debuff = function(self, card, from_blind)
        if card.playing_card and pseudorandom(pseudoseed('gun')) < G.GAME.probabilities.normal/4 then
            return true
        else
            return false
        end
    end,
}

local new_moon = Ceres.CONFIG.run_modifiers.blinds.enabled and SMODS.Blind{
    key = 'new_moon',
    boss_colour = Ceres.C.new_moon,
    dollars = 10, -- default is 5, default showdown is 8
    mult = 2,
    boss = {
        showdown = true
    },
    pos = {
        x = 0,
        y = 1,
    },
    atlas = 'blinds',
    discovered = false or Ceres.CONFIG.misc.discover_all.enabled,
    debuff = {
        suit = 'Spades',
        value = 'Ace',
    },

    set_blind = function(self)
        update_new_moon()
    end,
}

function update_new_moon()
    local suits = {}
    local values = {}
    for k, v in pairs(G.playing_cards) do
        if v.ability.effect ~= 'Stone Card' and v.base.suit ~= 'cere_Nothings' then
            suits[v.base.suit] = (suits[v.base.suit] or 0) + 1
            values[v.base.value] = (values[v.base.value] or 0) + 1
        end
    end
    local common_suit = {'Spades', 0}
    local common_value = {'Ace', 0}
    for k, v in pairs(suits) do
        if v > common_suit[2] then
            common_suit = {k, v}
        end
    end
    for k, v in pairs(values) do
        if v > common_value[2] then
            common_value = {k, v}
        end
    end
    new_moon.debuff = {
        suit = common_suit[1],
        value = common_value[1],
    }
    new_moon_updated = false
end