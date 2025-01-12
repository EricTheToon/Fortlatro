-- atlas for common jokers

local common_joker_atlas = SMODS.Atlas{
    key = 'common_jokers',
    path = 'common_jokers.png',
    px = 71,
    py = 95,
    atlas_table = 'ASSET_ATLAS',
}

-- custom common jokers

local jester = Ceres.CONFIG.jokers.enabled and Ceres.CONFIG.jokers.rarities.common.enabled and SMODS.Joker{
    key = 'jester',
    rarity = 1,
    unlocked = true,
    discovered = true,
    pos = {
        x = 0,
        y = 2,
    },
    config = {
        extra = 25,
    },
    cost = 2,
    atlas = 'common_jokers',
    eternal_compat = true,
    perishable_compat = true,
    blueprint_compat = true,

    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra}}
    end,

    calculate = function(self, card, context)
        if context.joker_main then
            return {
                    message = localize{type='variable',key='a_chips',vars={card.ability.extra}},
                    chip_mod = card.ability.extra, 
                    colour = G.C.CHIPS
                }
        end          
    end,
}

local coin_toss = Ceres.CONFIG.jokers.enabled and Ceres.CONFIG.jokers.rarities.common.enabled and SMODS.Joker{
    key = 'coin_toss',
    rarity = 1,
    unlocked = true,
    discovered = false or Ceres.CONFIG.misc.discover_all.enabled,
    pos = {
        x = 2,
        y = 0,
    },
    cost = 5,
    config = {
        extra = 1,
    },
    atlas = 'common_jokers',
    eternal_compat = true,
    perishable_compat = true,
    blueprint_compat = true,

    loc_vars = function(self, info_queue, card)
        return {vars = {G.GAME.probabilities.normal}}
    end,

    calculate = function(self, card, context)
        if context.setting_blind and not card.getting_sliced then
            if pseudorandom(pseudoseed('coin')) < G.GAME.probabilities.normal/2 then
                G.E_MANAGER:add_event(Event({func = function()
                        ease_hands_played(card.ability.extra)
                        card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = '+'..card.ability.extra..' Hand'})
                        return true
                    end
                }))
            else
                G.E_MANAGER:add_event(Event({func = function()
                        ease_discard(card.ability.extra)
                        card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = '+'..card.ability.extra..' Discard'})
                        return true
                    end
                }))
            end
        end
    end,
}

local warm_up = Ceres.CONFIG.jokers.enabled and Ceres.CONFIG.jokers.rarities.common.enabled and SMODS.Joker{
    key = 'warm_up',
    rarity = 1,
    unlocked = true,
    discovered = false or Ceres.CONFIG.misc.discover_all.enabled,
    pos = {
        x = 3,
        y = 0,
    },
    cost = 4,
    config = {
        amt = 15,
        extra = 1,
    },
    atlas = 'common_jokers',
    eternal_compat = true,
    perishable_compat = true,
    blueprint_compat = true,

    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.amt, card.ability.extra}}
    end,

    calculate = function(self, card, context)
        if context.after and G.GAME.current_round.hands_played == 0 then
            G.E_MANAGER:add_event(Event({func = function()
                    if G.GAME.chips < (card.ability.amt/100) * G.GAME.blind.chips then
                        ease_hands_played(card.ability.extra)
                        card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = '+'..card.ability.extra..' Hand'})
                    end
                    return true
                end
            }))
        end
    end,
}

local diving_joker = Ceres.CONFIG.jokers.enabled and Ceres.CONFIG.jokers.rarities.common.enabled and SMODS.Joker{
    key = 'diving_joker',
    rarity = 1,
    unlocked = true,
    discovered = false or Ceres.CONFIG.misc.discover_all.enabled,
    pos = {
        x = 5,
        y = 0,
    },
    config = {
        extra = 2,
        drawn = {0,0}
    },
    cost = 5,
    atlas = 'common_jokers',
    eternal_compat = true,
    perishable_compat = true,
    blueprint_compat = true,

    loc_vars = function(self, info_queue, card)
        local playing_cards = G.playing_cards or {}
        local deck_cards = G.deck and G.deck.cards or {}
        local drawn = #playing_cards - #deck_cards
        local total_drawn = card.ability.drawn[1] + card.ability.drawn[2] + drawn
        local mult = math.max(math.floor(total_drawn/8), 0) * card.ability.extra
        return {vars = {card.ability.extra, mult}}
    end,

    calculate = function(self, card, context)
        local playing_cards = G.playing_cards or {}
        local deck_cards = G.deck and G.deck.cards or {}
        local drawn = #playing_cards - #deck_cards
        local total_drawn = card.ability.drawn[1] + card.ability.drawn[2] + drawn
        local mult = math.max(math.floor(total_drawn/8), 0) * card.ability.extra
        if context.end_of_round and not context.individual and not context.repetition and not context.blueprint then
            if G.GAME.blind:get_type() == 'Boss' then
                card.ability.drawn = {0,0}
                return {
                    message = localize('k_reset'),
                    colour = G.C.RED
                }
            elseif G.GAME.blind:get_type() == 'Small' then
                card.ability.drawn[1] = drawn
            else
                card.ability.drawn[2] = drawn
            end
        end
        if context.joker_main then
            if mult > 0 then
                return {
                    message = localize{type='variable',key='a_mult',vars={mult}},
                    mult_mod = mult,
                    colour = G.C.MULT
                }
            end
        end
    end,
}

local accountant = Ceres.CONFIG.jokers.enabled and Ceres.CONFIG.jokers.rarities.common.enabled and SMODS.Joker{
    key = 'accountant',
    rarity = 1,
    unlocked = true,
    discovered = false or Ceres.CONFIG.misc.discover_all.enabled,
    pos = {
        x = 0,
        y = 1,
    },
    config = {
        extra = 1,
        mult_mod = 0,
    },
    cost = 6,
    atlas = 'common_jokers',
    eternal_compat = true,
    perishable_compat = false,
    blueprint_compat = true,

    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra, card.ability.mult_mod}}
    end,

    calculate = function(self, card, context)
        if context.before and not context.blueprint then
            if #context.full_hand == end_of_round then
                card.ability.mult_mod = card.ability.mult_mod + card.ability.extra
                ease_dollars(card.ability.extra)
                G.GAME.dollar_buffer = (G.GAME.dollar_buffer or 0) + card.ability.extra
                G.E_MANAGER:add_event(Event({func = (function() G.GAME.dollar_buffer = 0; return true end)}))
                card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('k_upgrade_ex'), colour = G.C.RED})
            end
        end
        if context.joker_main then
            if card.ability.mult_mod > 0 then
                return {
                    message = localize{type='variable',key='a_mult',vars={card.ability.mult_mod}},
                    mult_mod = card.ability.mult_mod,
                    colour = G.C.MULT
                }
            end
        end
    end,
}

local museum = Ceres.CONFIG.jokers.enabled and Ceres.CONFIG.jokers.rarities.common.enabled and SMODS.Joker{
    key = 'museum',
    rarity = 1,
    unlocked = true,
    discovered = false or Ceres.CONFIG.misc.discover_all.enabled,
    pos = {
        x = 1,
        y = 1,
    },
    config = {
        mult_mod = 0,
    },
    cost = 6,
    atlas = 'common_jokers',
    eternal_compat = true,
    perishable_compat = false,
    blueprint_compat = true,

    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.mult_mod}}
    end,

    calculate = function(self, card, context)
        if context.selling_card then
            if context.card.ability.set == 'Joker' then
                card.ability.mult_mod = card.ability.mult_mod + context.card.sell_cost
                card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('k_upgrade_ex'), colour = G.C.RED})
            end
        end
        if context.joker_main and card.ability.mult_mod > 0 then
            return {
                message = localize{type='variable',key='a_mult',vars={card.ability.mult_mod}},
                mult_mod = card.ability.mult_mod,
                colour = G.C.MULT
            }
        end
    end,
}

local large_joker = Ceres.CONFIG.jokers.enabled and Ceres.CONFIG.jokers.rarities.common.enabled and SMODS.Joker{
    key = 'large_joker',
    name = 'Large Joker',
    rarity = 1,
    unlocked = true,
    discovered = false or Ceres.CONFIG.misc.discover_all.enabled,
    pos = {
        x = 4,
        y = 0,
    },
    config = {
        extra = 1,
        mult_mod = 0,
    },
    cost = 6,
    atlas = 'common_jokers',
    eternal_compat = true,
    perishable_compat = false,
    blueprint_compat = true,

    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.mult_mod, card.ability.extra}}
    end,

    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play and not context.blueprint and context.other_card:get_id() == 14 then
            card.ability.mult_mod = card.ability.mult_mod + card.ability.extra
            card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('k_upgrade_ex'), colour = G.C.RED})
        end
        if context.joker_main and card.ability.mult_mod > 0 then
            return {
                message = localize{type='variable',key='a_mult',vars={card.ability.mult_mod}},
                mult_mod = card.ability.mult_mod,
                colour = G.C.MULT
            }
        end             
    end,
}

local backup_plan = Ceres.CONFIG.jokers.enabled and Ceres.CONFIG.jokers.rarities.common.enabled and SMODS.Joker{
    key = 'backup_plan',
    rarity = 1,
    unlocked = true,
    discovered = false or Ceres.CONFIG.misc.discover_all.enabled,
    pos = {
        x = 3,
        y = 1,
    },
    config = {
        Xmult_mod = 1.5
    },
    cost = 6,
    atlas = 'common_jokers',
    eternal_compat = true,
    perishable_compat = true,
    blueprint_compat = true,

    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.Xmult_mod}}
    end,

    calculate = function(self, card, context)
        if context.joker_main and #context.scoring_hand < 5 then
            return {
                message = localize{type='variable',key='a_xmult',vars={card.ability.Xmult_mod}},
                Xmult_mod = card.ability.Xmult_mod,
                colour = G.C.MULT,
                card = card
            }
        end
    end,
}

local club_sandwich = Ceres.CONFIG.jokers.enabled and Ceres.CONFIG.jokers.rarities.common.enabled and SMODS.Joker{
    key = 'club_sandwich',
    rarity = 1,
    unlocked = true,
    discovered = false or Ceres.CONFIG.misc.discover_all.enabled,
    pos = {
        x = 2,
        y = 1,
    },
    config = {
        mult_mod = 0,
        extra = 1,
    },
    cost = 6,
    atlas = 'common_jokers',
    eternal_compat = true,
    perishable_compat = false,
    blueprint_compat = true,

    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.mult_mod, card.ability.extra}}
    end,

    calculate = function(self, card, context)
        if context.before and not context.blueprint then
            if context.scoring_hand[1]:is_suit('Clubs') and context.scoring_hand[#context.scoring_hand]:is_suit('Clubs') then
                card.ability.mult_mod = card.ability.mult_mod + card.ability.extra
                return {
                    message = localize('k_upgrade_ex'),
                    card = card,
                    colour = G.C.MULT
                }
            end
        end
        if context.joker_main and card.ability.mult_mod > 0 then
            return {
                message = localize{type='variable',key='a_mult',vars={card.ability.mult_mod}},
                mult_mod = card.ability.mult_mod,
                colour = G.C.MULT
            }
        end             
    end,
}

local scratchcard = Ceres.CONFIG.jokers.enabled and Ceres.CONFIG.jokers.rarities.common.enabled and SMODS.Joker{
    key = 'scratchcard',
    rarity = 1,
    unlocked = true,
    discovered = false or Ceres.CONFIG.misc.discover_all.enabled,
    pos = {
        x = 4,
        y = 1,
    },
    config = {
        extra = 1,
    },
    cost = 6,
    atlas = 'common_jokers',
    eternal_compat = true,
    perishable_compat = true,
    blueprint_compat = true,

    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra}}
    end,

    calculate = function(self, card, context)
        if context.joker_main then
            local repeats = {}
            local money = 0
            for _, _card in pairs(context.scoring_hand) do
                if repeats['cere_' .. tostring(_card:get_id())] then
                    money = money + card.ability.extra
                else
                    repeats['cere_' .. tostring(_card:get_id())] = true
                end
            end
            if money > 0 then
                ease_dollars(money)
                G.GAME.dollar_buffer = (G.GAME.dollar_buffer or 0) + money
                G.E_MANAGER:add_event(Event({func = (function() G.GAME.dollar_buffer = 0; return true end)}))
                return {
                    message = localize('$') .. money,
                    dollars = money,
                    colour = G.C.MONEY
                }
            end
        end          
    end,
}

local jack_box = Ceres.CONFIG.jokers.enabled and Ceres.CONFIG.jokers.rarities.common.enabled and SMODS.Joker{
    key = 'jack_box',
    rarity = 1,
    unlocked = true,
    discovered = false or Ceres.CONFIG.misc.discover_all.enabled,
    pos = {
        x = 5,
        y = 1,
    },
    config = {
        extra = 25,
    },
    cost = 5,
    atlas = 'common_jokers',
    eternal_compat = true,
    perishable_compat = true,
    blueprint_compat = true,

    loc_vars = function(self, info_queue, card)
        local tot = 0
        if G.deck then
            for _, _card in pairs(G.deck.cards) do
                if _card:get_id() == 11 then
                    tot = tot + card.ability.extra
                end
            end
        end
        return {vars = {card.ability.extra, tot}}
    end,

    calculate = function(self, card, context)
        if context.joker_main then
            local tot = 0
            for _, _card in pairs(G.deck.cards) do
                if _card:get_id() == 11 then
                    tot = tot + card.ability.extra
                end
            end
            if tot > 0 then
                return {
                    message = localize{type='variable',key='a_chips',vars={tot}},
                    chip_mod = tot, 
                    colour = G.C.CHIPS
                }
            end
        end          
    end,
}

local fool_joker = Ceres.CONFIG.jokers.enabled and Ceres.CONFIG.jokers.rarities.common.enabled and SMODS.Joker{
    key = 'fool_joker',
    rarity = 1,
    unlocked = true,
    discovered = false or Ceres.CONFIG.misc.discover_all.enabled,
    pos = {
        x = 1,
        y = 2,
    },
    config = {
        odds = 4,
    },
    cost = 5,
    atlas = 'common_jokers',
    eternal_compat = true,
    perishable_compat = true,
    blueprint_compat = true,

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = G.P_CENTERS['c_fool']
        return {vars = {G.GAME.probabilities.normal or 1, card.ability.odds}}
    end,

    calculate = function(self, card, context)
        if context.end_of_round and not (context.individual or context.repetition) and G.GAME.current_round.hands_played == G.GAME.round_resets.hands then
            if pseudorandom(pseudoseed('fool_joker')) < G.GAME.probabilities.normal/card.ability.odds then
                if #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
                    card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('k_plus_tarot'), colour = G.C.SECONDARY_SET.Tarot})
                    local _card = create_card('Tarot',G.consumeables, nil, nil, nil, nil, 'c_fool')
                    _card:add_to_deck()
                    G.consumeables:emplace(_card)
                end
            else
                card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('k_nope_ex'), colour = G.C.SECONDARY_SET.Tarot})
            end
        end          
    end,
}

local gameplay_update = Ceres.CONFIG.jokers.enabled and Ceres.CONFIG.jokers.rarities.common.enabled and SMODS.Joker{
    key = 'gameplay_update',
    rarity = 1,
    unlocked = true,
    discovered = false or Ceres.CONFIG.misc.discover_all.enabled,
    pos = {
        x = 2,
        y = 2,
    },
    cost = 1,
    atlas = 'common_jokers',
    eternal_compat = true,
    perishable_compat = true,
    blueprint_compat = false,
}

local ceres_joker = Ceres.CONFIG.jokers.enabled and Ceres.CONFIG.jokers.rarities.common.enabled and SMODS.Joker{
    key = 'ceres_joker',
    rarity = 1,
    unlocked = true,
    discovered = false or Ceres.CONFIG.misc.discover_all.enabled,
    pos = {
        x = 3,
        y = 2,
    },
    cost = 1,
    atlas = 'common_jokers',
    eternal_compat = true,
    perishable_compat = true,
    blueprint_compat = false,
}

local flying_ace = false and Ceres.CONFIG.jokers.enabled and Ceres.CONFIG.jokers.rarities.common.enabled and SMODS.Joker{
    key = 'flying_ace',
    rarity = 1,
    unlocked = true,
    discovered = false or Ceres.CONFIG.misc.discover_all.enabled,
    pos = {
        x = 0,
        y = 0,
    },
    config = {
        extra = 3,
    },
    cost = 5,
    atlas = 'common_jokers',
    eternal_compat = true,
    perishable_compat = true,
    blueprint_compat = true,

    loc_vars = function(self, info_queue, card)
        return { vars = {card.ability.extra}}
    end,

    calculate = function(self, card, context)
        if context.destroying_card and #context.full_hand == 1 and context.full_hand[1]:get_id() == 14 and G.GAME.current_round.hands_played == 0 then
            ease_dollars(card.ability.extra)
            G.GAME.dollar_buffer = (G.GAME.dollar_buffer or 0) + card.ability.extra
            G.E_MANAGER:add_event(Event({func = (function() G.GAME.dollar_buffer = 0; return true end)}))
            card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = localize('$')..card.ability.extra, colour = G.C.MONEY})
            return true
        end          
    end,
}