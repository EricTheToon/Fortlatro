local divine_joker_atlas = SMODS.Atlas{
    key = 'divine_jokers',
    path = 'divine_jokers.png',
    px = 71,
    py = 95,
    atlas_table = 'ASSET_ATLAS',
}

local makima = Ceres.CONFIG.jokers.enabled and Ceres.CONFIG.jokers.rarities.divine.enabled and SMODS.Joker{
    key = 'makima',
    rarity = 'cere_divine',
    unlocked = false or Ceres.CONFIG.misc.unlock_all.enabled,
    discovered = false or Ceres.CONFIG.misc.discover_all.enabled,
    pos = {
        x = 0,
        y = 0,
    },
	soul_pos = {
        x = 0, 
        y = 2,
        extra = {
            x = 0,
            y = 1
        }
    },
    config = {
        extra = 2,
    },
    cost = 50,
    atlas = 'divine_jokers',
    eternal_compat = true,
    perishable_compat = true,
    blueprint_compat = true,

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = {set = 'Other', key = 'makima_info'}
        return {vars = {card.ability.extra}}
    end,

    calculate = function(self, card, context)
        if context.other_joker then
            if context.other_joker.ability and context.other_joker.ability.set == 'Joker' and context.other_joker.sell_cost < card.sell_cost then
                G.E_MANAGER:add_event(Event({
                    func = function()
                        context.other_joker:juice_up(0.5, 0.5)
                        return true
                    end
                })) 
                return {
                    message = '^' .. card.ability.extra .. ' Mult',
                    cere_Emult_mod = card.ability.extra
                }
            end
        end
    end,
}

local aizen = Ceres.CONFIG.jokers.enabled and Ceres.CONFIG.jokers.rarities.divine.enabled and SMODS.Joker{
    key = 'aizen',
    rarity = 'cere_divine',
    unlocked = false or Ceres.CONFIG.misc.unlock_all.enabled,
    discovered = false or Ceres.CONFIG.misc.discover_all.enabled,
    pos = {
        x = 1,
        y = 0
    },
    soul_pos = {
        x = 1, 
        y = 2,
        extra = {
            x = 1,
            y = 1
        }
    },
    cost = 50,
    config = {
        extra = 1.5,
    },
    atlas = 'divine_jokers',
    eternal_compat = true,
    perishable_compat = true,
    blueprint_compat = true,

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = {set = 'Other', key = 'aizen_info'}
        return {vars = {card.ability.extra}}
    end,

    calculate = function(self, card, context)
        if not context.end_of_round and context.individual and context.cardarea == G.hand then
            if context.other_card.debuff then
                return {
                    message = localize('k_debuffed'),
                    colour = G.C.RED,
                    card = card,
                }
            else
                return {
                    cere_e_mult = card.ability.extra,
                    card = card
                }
            end
        end
    end,
} or false