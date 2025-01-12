-- atlas for uncommon jokers

local rare_joker_atlas = SMODS.Atlas{
    key = 'rare_jokers',
    path = 'rare_jokers.png',
    px = 71,
    py = 95,
    atlas_table = 'ASSET_ATLAS',
}

-- custom rare jokers

local fox_devil = Ceres.CONFIG.jokers.enabled and Ceres.CONFIG.jokers.rarities.rare.enabled and SMODS.Joker{
    key = 'fox_devil',
    rarity = 3,
    unlocked = false or Ceres.CONFIG.misc.unlock_all.enabled,
    discovered = false or Ceres.CONFIG.misc.discover_all.enabled,
    pos = {
        x = 1,
        y = 0,
    },
    cost = 8,
    config = {
        increase = 10,
        decrease = 25,
    },
    atlas = 'rare_jokers',
    eternal_compat = true,
    perishable_compat = true,
    blueprint_compat = false,

    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.increase, card.ability.decrease}}
    end,

    calculate = function(self, card, context)
        if context.setting_blind and not card.getting_sliced and not context.blueprint and not context.control_devil then
            if context.blind.boss then
                G.GAME.blind.chips = G.GAME.blind.chips  * ((100 - card.ability.decrease) / 100)
            else
                G.GAME.blind.chips = G.GAME.blind.chips + (G.GAME.blind.chips * (card.ability.increase / 100))
            end
        end
        G.GAME.blind.chip_text = number_format(G.GAME.blind.chips)
        G.HUD_blind:get_UIE_by_ID('HUD_blind_count').UIBox:recalculate()
    end,
}

local blood_fiend = Ceres.CONFIG.jokers.enabled and Ceres.CONFIG.jokers.rarities.rare.enabled and SMODS.Joker{
    key = 'blood_fiend',
    rarity = 3,
    unlocked = false or Ceres.CONFIG.misc.unlock_all.enabled,
    discovered = false or Ceres.CONFIG.misc.discover_all.enabled,
    pos = {
        x = 2,
        y = 0,
    },
    cost = 8,
    config = {
        extra = 0.5,
        x_mult = 1,
    },
    atlas = 'rare_jokers',
    eternal_compat = true,
    perishable_compat = false,
    blueprint_compat = true,

    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra, card.ability.x_mult}}
    end,

    calculate = function(self, card, context)
        if not context.blueprint then
            if context.cards_destroyed then
                local hearts = 0
                for k, v in ipairs(context.glass_shattered) do
                    if v:is_suit('Hearts') then
                        hearts = hearts + 1
                    end
                end
                if hearts > 0 then
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            G.E_MANAGER:add_event(Event({
                                func = function()
                                    card.ability.x_mult = card.ability.x_mult + hearts*card.ability.extra
                                return true
                                end
                            }))
                            card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize{type = 'variable', key = 'a_xmult', vars = {card.ability.x_mult + hearts*card.ability.extra}}})
                            return true
                        end
                    }))
                end
                return
            elseif context.remove_playing_cards then
                local hearts = 0
                for k, v in ipairs(context.removed) do
                    if v:is_suit('Hearts') then 
                        hearts = hearts + 1
                    end
                end
                if hearts > 0 then
                    card.ability.x_mult = card.ability.x_mult + hearts*card.ability.extra
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize{type = 'variable', key = 'a_xmult', vars = {card.ability.x_mult}}})
                            return true
                        end
                    }))
                end
                return
            end
        else
            if context.joker_main then
                return {
                    message = localize{type='variable',key='a_xmult',vars={card.ability.x_mult}},
                    Xmult_mod = card.ability.x_mult
                }
            end
        end
    end,
}



local clock = Ceres.CONFIG.jokers.enabled and Ceres.CONFIG.jokers.rarities.rare.enabled and SMODS.Joker{
    key = 'calling_the_clock',
    config = {
        extra = 1,
    },
    rarity = 3,
    pos = {
        x = 4,
        y = 0,
    },
    atlas = 'rare_jokers',
    cost = 8,
    unlocked = false or Ceres.CONFIG.misc.unlock_all.enabled, -- trigger certain amt of cards in one hand, including cards in hand or smth
    discovered = false or Ceres.CONFIG.misc.discover_all.enabled,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,

    loc_vars = function(self, info_queue, card)
        if G.GAME.cere_clock_card then
            return {
                vars = {
                    G.GAME.cere_clock_card.rank,
                },
            }
        else
            return {
                vars = {
                    'Ace',
                }
            }
        end
    end,

    calculate = function(self, card, context)
        if G.GAME.cere_clock_card then
            if context.repetition and context.cardarea == G.play or (context.cardarea == G.hand and context.card_effects and (next(context.card_effects[1]) or #context.card_effects > 1)) then
                if context.other_card:get_id() == G.GAME.cere_clock_card.id then
                    return {
                        message = localize('k_again_ex'),
                        repetitions = card.ability.extra,
                        card = card
                    }
                end
            end
        end
    end,
}

local ben = false and Ceres.CONFIG.jokers.enabled and Ceres.CONFIG.jokers.rarities.rare.enabled and SMODS.Joker{
    key = 'ben',
    rarity = 3,
    unlocked = false or Ceres.CONFIG.misc.unlock_all.enabled,
    discovered = false or Ceres.CONFIG.misc.discover_all.enabled,
    pos = {
        x = 1,
        y = 0,
    },
    cost = 11,
    atlas = 'rare_jokers',
    eternal_compat = true,
    perishable_compat = true,
    blueprint_compat = true,

    loc_vars = function(self, info_queue, card)
        local var = 0
        if G.GAME and G.GAME.chips and G.GAME.blind and G.GAME.blind.chips and G.GAME.blind.chips ~= 0 then
            local chips = G.GAME.chips or 0
            local blind_chips = G.GAME.blind.chips or 0
            local percent = (G.GAME.chips / G.GAME.blind.chips) * 100 or 0
            if percent then 
                var = 0--Ceres.Ceres.round(tonumber(percent), 0)
            else
                var = 0
            end
            if var > 100 then
                var = 100
            end
            return {vars = {var}}
        end
        return {vars = {0}}
    end,

    calculate = function(self, card, context)
        if context.joker_main then
            if pseudorandom('ben') < tonumber(G.GAME.chips) / tonumber(G.GAME.blind.chips) then
                G.GAME.chips = G.GAME.blind.chips
                G.hand_text_area.game_chips:juice_up()
                G.E_MANAGER:add_event(Event({func = function()
                        G.hand_text_area.game_chips:juice_up()
                        play_sound('voice9')
                        return true
                    end
                }))
                return {
                    message = 'Yes!',
                    repetitions = 0,
                    colour = G.C.GREEN,
                }
            else
                G.E_MANAGER:add_event(Event({func = function()
                        play_sound('voice2')
                        return true
                    end
                }))
                return {
                    message = 'No!',
                    repetitions = 0,
                    colour = G.C.RED,
                }
            end
        end
    end,
}

local double_down = Ceres.CONFIG.jokers.enabled and Ceres.CONFIG.jokers.rarities.rare.enabled and SMODS.Joker{
    key = 'double_down',
    rarity = 3,
    pos = {
        x = 1,
        y = 1,
    },
    config = {
        extra = 2
    },
    atlas = 'rare_jokers',
    cost = 8,
    unlocked = false or Ceres.CONFIG.misc.unlock_all.enabled, -- handsize of 2 lol
    discovered = false or Ceres.CONFIG.misc.discover_all.enabled,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,

    calculate = function(self, card, context)
        if context.repetition and context.cardarea == G.hand and context.poker_hands then
            if next(context.poker_hands['Pair']) and context.card_effects and (next(context.card_effects[1]) or #context.card_effects > 1) then
                return {
                    message = localize('k_again_ex'),
                    repetitions = card.ability.extra,
                    card = card
                }
            end
        end
    end,
}

local yumeko = Ceres.CONFIG.jokers.enabled and Ceres.CONFIG.jokers.rarities.rare.enabled and SMODS.Joker{
    key = 'yumeko',
    rarity = 3,
    pos = {
        x = 2,
        y = 1,
    },
    config = {
        extra = 2
    },
    atlas = 'rare_jokers',
    cost = 8,
    unlocked = false or Ceres.CONFIG.misc.unlock_all.enabled, -- deck of 1 suit
    discovered = false or Ceres.CONFIG.misc.discover_all.enabled,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,

    loc_vars = function(self, info_queue, card)
        if G.GAME.cere_yumeko_suit then
            return {
                vars = {
                    card.ability.extra,
                    localize(G.GAME.cere_yumeko_suit, 'suits_singular'),
                    colours = {
                        G.C.SUITS[G.GAME.cere_yumeko_suit],
                    },
                },
            }
        else
            return {
                vars = {
                    card.ability.extra,
                    localize('Spades', 'suits_singular'),
                    colours = {
                        G.C.SUITS['Spades'],
                    },
                },
            }
        end
    end,

    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play then
            if context.other_card.base and context.other_card:is_suit(G.GAME.cere_yumeko_suit) then
                return {
                    x_mult = card.ability.extra,
                    colour = G.C.RED,
                    card = card
                }
            end
        end
    end,
}

local wanted_poster = Ceres.CONFIG.jokers.enabled and Ceres.CONFIG.jokers.rarities.rare.enabled and SMODS.Joker{
    key = 'wanted_poster',
    rarity = 3,
    pos = {
        x = 3,
        y = 1,
    },
    config = {
        Xmult_mod = 1,
        rarity = 1,
        extra = 0.75,
    },
    atlas = 'rare_jokers',
    cost = 8,
    unlocked = false or Ceres.CONFIG.misc.unlock_all.enabled, -- slice a rare or above joker
    discovered = false or Ceres.CONFIG.misc.discover_all.enabled,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = false,

    loc_vars = function(self, info_queue, card)
        local rarities = {
            'Common',
            'Uncommon',
            'Rare',
        }
        return {
            vars = {
                card.ability.extra,
                rarities[card.ability.rarity],
                card.ability.Xmult_mod,
                colours = {
                    G.C.RARITY[card.ability.rarity]
                }
            },
        }
    end,

    calculate = function(self, card, context)
        if context.setting_blind and not card.getting_sliced and not context.blueprint then
            local valid_jokers = {}
            for _, joker in pairs(G.jokers.cards) do
                if joker ~= card and joker.config.center.rarity == card.ability.rarity and not joker.ability.eternal and not joker.getting_sliced then
                    valid_jokers[#valid_jokers+1] = joker
                end
            end
            if #valid_jokers == 0 then return end
            local rand_joker = pseudorandom_element(valid_jokers, pseudoseed('wanted'))
            rand_joker.getting_sliced = true
            G.GAME.joker_buffer = G.GAME.joker_buffer - 1
            local new_mult = card.ability.Xmult_mod + card.ability.extra
            G.E_MANAGER:add_event(Event({func = function()
                G.GAME.joker_buffer = 0
                card.ability.Xmult_mod = card.ability.Xmult_mod + card.ability.extra
                card:juice_up(0.8, 0.8)
                rand_joker:start_dissolve({HEX("57ecab")}, nil, 1.6)
                play_sound('slice1', 0.96+math.random()*0.08)
            return true end }))
            card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize{type = 'variable', key = 'a_xmult', vars = {new_mult}}, colour = G.C.RED, no_juice = true})
            local valid_rarities = {}
            for i = 1, 3 do
                if i ~= card.ability.rarity then
                    valid_rarities[#valid_rarities+1] = i
                end
            end
            card.ability.rarity = pseudorandom_element(valid_rarities, pseudoseed('wanted'))
        end
        if context.joker_main and card.ability.Xmult_mod > 1 then
            return {
                message = localize{type='variable',key='a_xmult',vars={card.ability.Xmult_mod}},
                colour = G.C.RED,
                Xmult_mod = card.ability.Xmult_mod,
                repetitions = 0
            }
        end
    end,
}

local the_null = Ceres.CONFIG.jokers.enabled and Ceres.CONFIG.jokers.rarities.rare.enabled and Ceres.CONFIG.misc.useless_jokers.enabled and SMODS.Joker{
    key = 'the_null',
    rarity = 3,
    unlocked = false or Ceres.CONFIG.misc.unlock_all.enabled, -- win a run without playing high card
    discovered = false or Ceres.CONFIG.misc.discover_all.enabled,
    pos = {
        x = 1,
        y = 2,
    },
    config = {
        extra = 0,
    },
    cost = 1,
    atlas = 'rare_jokers',
    eternal_compat = true,
    perishable_compat = true,
    blueprint_compat = true,

    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra}}
    end,

    calculate = function(self, card, context)
    end,
}

local the_solo = Ceres.CONFIG.jokers.enabled and Ceres.CONFIG.jokers.rarities.rare.enabled and Ceres.CONFIG.misc.useless_jokers.enabled and SMODS.Joker{
    key = 'the_solo',
    rarity = 3,
    unlocked = false or Ceres.CONFIG.misc.unlock_all.enabled, -- win a run without playing high card
    discovered = false or Ceres.CONFIG.misc.discover_all.enabled,
    pos = {
        x = 4,
        y = 1,
    },
    config = {
        extra = 1,
    },
    cost = 1,
    atlas = 'rare_jokers',
    eternal_compat = true,
    perishable_compat = true,
    blueprint_compat = true,

    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra}}
    end,

    calculate = function(self, card, context)
        if context.joker_main then
            return {
                message = localize{type='variable',key='a_xmult',vars={card.ability.extra}},
                colour = G.C.RED,
                Xmult_mod = card.ability.extra,
            }
        end
    end,
}

local bismuth_crystal = Ceres.CONFIG.jokers.enabled and Ceres.CONFIG.jokers.rarities.rare.enabled and SMODS.Joker{
    key = 'bismuth_crystal',
    rarity = 3,
    unlocked = false or Ceres.CONFIG.misc.unlock_all.enabled, -- play hand of 5 stone
    discovered = false or Ceres.CONFIG.misc.discover_all.enabled,
    pos = {
        x = 3,
        y = 0,
    },
    config = {
        extra = 1.5,
    },
    cost = 8,
    atlas = 'rare_jokers',
    eternal_compat = true,
    perishable_compat = true,
    blueprint_compat = true,

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = G.P_CENTERS['m_stone']
        return {vars = {card.ability.extra}}
    end,

    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play then
            if context.other_card.ability.name == 'Stone Card' then
                return {
                    x_mult = card.ability.extra,
                    colour = G.C.RED,
                    card = card
                }
            end
        end
    end,
}

local poltergeist = Ceres.CONFIG.jokers.enabled and Ceres.CONFIG.jokers.rarities.rare.enabled and SMODS.Joker{
    key = 'poltergeist',
    rarity = 3,
    unlocked = false or Ceres.CONFIG.misc.unlock_all.enabled, -- uh
    discovered = false or Ceres.CONFIG.misc.discover_all.enabled,
    pos = {
        x = 0,
        y = 2,
    },
    config = {
        extra = 25,
    },
    cost = 8,
    atlas = 'rare_jokers',
    eternal_compat = true,
    perishable_compat = true,
    blueprint_compat = true,

    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra}}
    end,

    calculate = function(self, card, context)
        if context.setting_blind and not (context.blueprint_card or card).getting_sliced and #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
            G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
            G.E_MANAGER:add_event(Event({
                func = (function()
                    G.E_MANAGER:add_event(Event({
                        func = function() 
                            local card = create_card('Spectral',G.consumeables, nil, nil, nil, nil, nil, 'poltergeist')
                            card:add_to_deck()
                            G.consumeables:emplace(card)
                            G.GAME.consumeable_buffer = 0
                            return true
                        end}))   
                        card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = localize('k_plus_spectral'), colour = G.C.SECONDARY_SET.Spectral})                       
                    return true
                end)}))
            G.GAME.blind.chips = G.GAME.blind.chips + (G.GAME.blind.chips * (card.ability.extra / 100))
            G.GAME.blind.chip_text = number_format(G.GAME.blind.chips)
            G.HUD_blind:get_UIE_by_ID('HUD_blind_count').UIBox:recalculate()
        end
    end,
}
