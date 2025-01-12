-- atlas for uncommon jokers

local uncommon_joker_atlas = SMODS.Atlas{
    key = 'uncommon_jokers',
    path = 'uncommon_jokers.png',
    px = 71,
    py = 95,
    atlas_table = 'ASSET_ATLAS',
}

-- custom uncommon jokers

local chainsaw_devil = Ceres.CONFIG.jokers.enabled and Ceres.CONFIG.jokers.rarities.uncommon.enabled and SMODS.Joker{
    key = 'chainsaw_devil',
    rarity = 2,
    unlocked = true,
    discovered = false or Ceres.CONFIG.misc.discover_all.enabled,
    pos = {
        x = 1,
        y = 0,
    },
    cost = 7,
    config = {
        extra = 2,
    },
    atlas = 'uncommon_jokers',
    eternal_compat = true,
    perishable_compat = true,
    blueprint_compat = false,

    loc_vars = function(self, info_queue, card)
        return { vars = {card.ability.extra}}
    end,

    calculate = function(self, card, context)
        if context.first_hand_drawn and not context.blueprint and not G.GAME.blind:get_type() == 'Boss' then
            G.GAME.blind.dollars = G.GAME.blind.dollars * card.ability.extra
            G.GAME.current_round.dollars_to_be_earned = G.GAME.blind.dollars > 0 and (string.rep(localize('$'), self.dollars)..'') or ('')
        end
        if context.end_of_round and not (context.individual or context.repetition) and not context.blueprint then
            G.HUD_blind:recalculate()
            card_eval_status_text(card, 'extra', nil, nil, nil, {message = 'X'..card.ability.extra..' Reward', colour = G.C.MONEY})
        end
    end,
}

local snake_eyes = Ceres.CONFIG.jokers.enabled and Ceres.CONFIG.jokers.rarities.rare.enabled and SMODS.Joker{
    key = 'snake_eyes',
    rarity = 2,
    unlocked = false or Ceres.CONFIG.misc.unlock_all.enabled, -- smth luck related
    discovered = false or Ceres.CONFIG.misc.discover_all.enabled,
    pos = {
        x = 4,
        y = 2,
    },
    cost = 6,
    config = {
        extra = 1,
    },
    atlas = 'uncommon_jokers',
    eternal_compat = true,
    perishable_compat = true,
    blueprint_compat = true,

    
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = G.P_CENTERS['m_lucky']
        info_queue[#info_queue+1] = G.P_CENTERS['m_glass']
    end,

    calculate = function(self, card, context)
        if context.repetition and context.cardarea == G.play then
            if context.other_card.ability.name == 'Lucky Card' or context.other_card.ability.name == 'Glass Card' then
                return {
                    message = localize('k_again_ex'),
                    repetitions = card.ability.extra,
                    card = card
                }
            end
        end
    end,
}

local professor = Ceres.CONFIG.jokers.enabled and Ceres.CONFIG.jokers.rarities.uncommon.enabled and SMODS.Joker{
    key = 'professor',
    config = {
        extra = 1,
    },
    rarity = 2,
    pos = {
        x = 2,
        y = 0,
    },
    atlas = 'uncommon_jokers',
    cost = 6,
    unlocked = true,
    discovered = false or Ceres.CONFIG.misc.discover_all.enabled,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,

    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                'Ace',
            },
        }
    end,
    
    calculate = function(self, card, context)
        if context.repetition and context.cardarea == G.play then
            if context.other_card:get_id() == 14 then
                return {
                    message = localize('k_again_ex'),
                    repetitions = card.ability.extra,
                    card = card
                }
            end
        end
    end,
}

local squared = Ceres.CONFIG.jokers.enabled and Ceres.CONFIG.jokers.rarities.uncommon.enabled and SMODS.Joker{
    key = 'squared',
    config = {
        extra = 9,
    },
    rarity = 2,
    pos = {
        x = 3,
        y = 0,
    },
    atlas = 'uncommon_jokers',
    cost = 9,
    unlocked = true,
    discovered = false or Ceres.CONFIG.misc.discover_all.enabled,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,

    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.extra,
            },
        }
    end,

    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play then
            if context.other_card:get_id() == 14 or
            context.other_card:get_id() == 9 or
            context.other_card:get_id() == 4 then
                return {
                    mult = card.ability.extra,
                    card = card,
                }
            end
        end
    end,
}


local favourable_odds = Ceres.CONFIG.jokers.enabled and Ceres.CONFIG.jokers.rarities.uncommon.enabled and SMODS.Joker{
    key = 'favourable_odds',
    rarity = 2,
    pos = {
        x = 4,
        y = 0,
    },
    soul_pos = {
        x = 4,
        y = 1,
    },
    atlas = 'uncommon_jokers',
    cost = 7,
    unlocked = true,
    discovered = false or Ceres.CONFIG.misc.discover_all.enabled,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = G.P_CENTERS['m_lucky']
    end,

    calculate = function(self, card, context)
        if context.cardarea == G.jokers and context.before and not context.blueprint then
            local odds = {}
            for k, v in ipairs(context.scoring_hand) do
                if (v:get_id() <= 10 and 
                v:get_id() >= 0 and
                v:get_id()%2 == 1) or
                v:get_id() == 14
                then
                    odds[#odds+1] = v
                    v:set_ability(G.P_CENTERS.m_lucky, nil, true)
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            v:juice_up()
                            return true
                        end
                    })) 
                end
            end
            if #odds > 0 then
                return {
                    message = {'Lucky'},
                    colour = G.C.GREEN,
                    card = card,
                }
            end
        end
    end,
}


local marlboro_reds = Ceres.CONFIG.jokers.enabled and Ceres.CONFIG.jokers.rarities.uncommon.enabled and SMODS.Joker{
    key = 'marlboro_reds',
    rarity = 2,
    pos = {
        x = 0,
        y = 1,
    },
    config = {
        x_mult = 2,
        extra = 0.05,
    },
    atlas = 'uncommon_jokers',
    cost = 6,
    unlocked = true,
    discovered = false or Ceres.CONFIG.misc.discover_all.enabled,
    blueprint_compat = true,
    eternal_compat = false,
    perishable_compat = true,

    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.x_mult,
                card.ability.extra,
            },
        }
    end,

    calculate = function(self, card, context)
        -- main
        if context.joker_main then
            return {
                message = localize{type='variable',key='a_xmult',vars={card.ability.x_mult}},
                colour = G.C.RED,
                Xmult_mod = card.ability.x_mult,
                repetitions = 0
            }
        end
        -- end of round
        if context.end_of_round and not (context.individual or context.repetition or context.blueprint) then
            if card.ability.x_mult - card.ability.extra <= 1 then 
                G.E_MANAGER:add_event(Event({
                    func = function()
                        play_sound('tarot1')
                        card.T.r = -0.2
                        card:juice_up(0.3, 0.4)
                        card.states.drag.is = true
                        card.children.center.pinch.x = true
                        G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.3, blockable = false,
                            func = function()
                                    G.jokers:remove_card(card)
                                    card:remove()
                                    card = nil
                                return true; end})) 
                        return true
                    end
                })) 
                return {
                    message = 'Smoked!',
                    colour = G.C.RED,
                    repetitions = 0
                }
            else
                card.ability.x_mult = card.ability.x_mult - card.ability.extra
                return {
                    message = localize{type='variable',key='a_xmult_minus',vars={card.ability.extra}},
                    colour = G.C.MULT,
                    repetitions = 0,
                }
            end
        end
    end,
}

local skateboard = Ceres.CONFIG.jokers.enabled and Ceres.CONFIG.jokers.rarities.uncommon.enabled and SMODS.Joker{
    key = 'skateboard',
    rarity = 2,
    pos = {
        x = 1,
        y = 1,
    },
    config = {
        Xmult_mod = 1,
        extra = 0.5,
        hands = {},
    },
    atlas = 'uncommon_jokers',
    cost = 7,
    unlocked = true,
    discovered = false or Ceres.CONFIG.misc.discover_all.enabled,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,

    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.extra,
                card.ability.Xmult_mod,
            },
        }
    end,

    calculate = function(self, card, context)
        -- before round
        if context.before and not context.blueprint then
            for _, hand in pairs(card.ability.hands) do
                if hand == context.scoring_name then
                    return
                end
            end
            card.ability.hands[#card.ability.hands+1] = context.scoring_name
            card.ability.Xmult_mod = 1 + (#card.ability.hands * card.ability.extra)
            return {
                message = localize('k_upgrade_ex'),
                colour = G.C.RED,
                card = card
            }
        end
        -- during round
        if context.joker_main and card.ability.Xmult_mod > 1 then
            return {
                message = localize{type='variable',key='a_xmult',vars={card.ability.Xmult_mod}},
                colour = G.C.RED,
                Xmult_mod = card.ability.Xmult_mod,
            }
        end
        -- end of round
        if context.end_of_round and not (context.individual or context.repetition or context.blueprint) then
            card.ability.hands = {}
            card.ability.Xmult_mod = 1
            return {
                message = localize('k_reset'),
                colour = G.C.RED
            }
        end
    end,
}

-- atlas for stopwatch

local stopwatch_joker_atlas = SMODS.Atlas{
    key = 'stopwatch_joker',
    path = 'stopwatch.png',
    px = 71,
    py = 95,
    atlas_table = 'ASSET_ATLAS',
}

local stopwatch = Ceres.CONFIG.jokers.enabled and Ceres.CONFIG.jokers.rarities.uncommon.enabled and SMODS.Joker{
    key = 'stopwatch',
    rarity = 2,
    pos = {
        x = 0,
        y = 0,
    },
    config = {
        Xmult_mod = 1,
        dt = 0,
        active = false
    },
    atlas = 'stopwatch_joker',
    cost = 7,
    unlocked = true,
    discovered = false or Ceres.CONFIG.misc.discover_all.enabled,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,

    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.Xmult_mod,
            },
        }
    end,

    update = function(self, card, dt)
        if card.ability.active then
            card.ability.dt = card.ability.dt + G.real_dt
            card.ability.Xmult_mod = 1 + (math.floor(card.ability.dt) * 0.01)
        end
        card.config.center.pos.x = (math.floor(card.ability.dt) % 12)
    end,

    calculate = function(self, card, context)
        if context.setting_blind and not card.getting_sliced and not context.blueprint then
            card.ability.active = true
            card.ability.Xmult_mod = 1
            card.ability.dt = 0
            card_eval_status_text(card, 'extra', nil, nil, nil, {message = 'Start!'})
        end
        if context.joker_main and card.ability.Xmult_mod > 1 then
            return {
                message = localize{type='variable',key='a_xmult',vars={card.ability.Xmult_mod}},
                colour = G.C.RED,
                Xmult_mod = card.ability.Xmult_mod,
            }
        end
        if context.end_of_round and not (context.individual or context.repetition or context.blueprint) then
            card.ability.active = false
            card.ability.Xmult_mod = 1
            card.ability.dt = 0
            card_eval_status_text(card, 'extra', nil, nil, nil, {message = 'Stop!'})
        end
    end,
}

local fisherman = Ceres.CONFIG.jokers.enabled and Ceres.CONFIG.jokers.rarities.uncommon.enabled and SMODS.Joker{
    key = 'fisherman',
    rarity = 2,
    pos = {
        x = 2,
        y = 1,
    },
    config = {
        extra = 1,
        added = 0
    },
    atlas = 'uncommon_jokers',
    cost = 6,
    unlocked = true,
    discovered = false or Ceres.CONFIG.misc.discover_all.enabled,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,

    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.extra,
            },
        }
    end,

    calculate = function(self, card, context)
        if context.before then
            G.hand:change_size(card.ability.extra)
            card.ability.added = card.ability.added + card.ability.extra
            return {
                message = '+' .. card.ability.extra .. ' Size',
                colour = G.C.BLUE,
            }
        end
        if context.end_of_round and not (context.individual or context.repetition or context.blueprint) then
            G.hand:change_size(-card.ability.added)
            card.ability.added = 0
            return {
                message = localize('k_reset')
            }
        end
    end,
}

local insurance_fraud = Ceres.CONFIG.jokers.enabled and Ceres.CONFIG.jokers.rarities.uncommon.enabled and SMODS.Joker{
    key = 'insurance_fraud',
    rarity = 2,
    pos = {
        x = 3,
        y = 1,
    },
    config = {
        extra = 3,
        debuffed = {}
    },
    atlas = 'uncommon_jokers',
    cost = 8,
    unlocked = true,
    discovered = false or Ceres.CONFIG.misc.discover_all.enabled,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,

    loc_vars = function(self, info_queue, card)
        if G.GAME.cere_insurance_card then
            return {
                vars = {
                    G.GAME.cere_insurance_card.rank,
                    card.ability.extra,
                },
            }
        else
            return {
                vars = {
                    'Ace',
                    card.ability.extra,
                }
            }
        end
    end,

    calculate = function(self, card, context)
        if context.setting_blind and not card.getting_sliced and not context.blueprint and G.GAME.cere_insurance_card then
            for _, _card in pairs(G.deck.cards) do
                if _card:get_id() == G.GAME.cere_insurance_card.id then
                    card.ability.debuffed[#card.ability.debuffed+1] = _card
                    _card.debuff = true
                end
            end
        end
        if context.joker_main then
            local debuff_tot = 0
            for _, _card in pairs(context.scoring_hand) do
                if _card.debuff then
                    debuff_tot = debuff_tot + 1
                end
            end
            if debuff_tot > 0 then
                ease_dollars(card.ability.extra*debuff_tot)
                G.GAME.dollar_buffer = (G.GAME.dollar_buffer or 0) + (card.ability.extra*debuff_tot)
                G.E_MANAGER:add_event(Event({func = (function() G.GAME.dollar_buffer = 0; return true end)}))
                return {
                    message = localize('$') .. (card.ability.extra*debuff_tot),
                    dollars = (card.ability.extra*debuff_tot),
                    colour = G.C.MONEY
                }
            end
        end
        if context.end_of_round and not (context.individual or context.repetition or context.blueprint) then
            for _, _card in pairs(card.ability.debuffed) do
                _card.debuff = false
            end
            card.ability.debuffed = {}
        end
    end,
}

local seasoning = Ceres.CONFIG.jokers.enabled and Ceres.CONFIG.jokers.rarities.uncommon.enabled and SMODS.Joker{
    key = 'seasoning',
    rarity = 2,
    pos = {
        x = 5,
        y = 2,
    },
    config = {
        extra = 2,
    },
    atlas = 'uncommon_jokers',
    cost = 6,
    unlocked = true,
    discovered = false or Ceres.CONFIG.misc.discover_all.enabled,
    blueprint_compat = true,
    eternal_compat = false,
    perishable_compat = true,

    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra, card.ability.extra > 1 and 's' or ''}}
    end,

    calculate = function(self, card, context)
        if context.before and not context.blueprint then
            for i = 1, #context.scoring_hand do
                if card.ability.extra > 0 then
                    local seal = SMODS.poll_seal({guaranteed = true})
                    local enhancement =  pseudorandom_element(G.P_CENTER_POOLS.Enhanced, pseudoseed('seasoning'))
                    local edition = poll_edition('seasoning', nil, true, true)
                    card_eval_status_text(context.scoring_hand[i], 'extra', nil, nil, nil, {message = 'Seasoned!', colour = G.C.RED})
                    context.scoring_hand[i]:flip()
                    play_sound('card1')
                    context.scoring_hand[i]:juice_up(0.3, 0.3)
                    context.scoring_hand[i]:set_seal(seal, true, true)
                    context.scoring_hand[i]:set_ability(enhancement)
                    context.scoring_hand[i]:set_edition(edition, true, true)
                    delay(0.5)
                    context.scoring_hand[i]:flip()
                    context.scoring_hand[i]:juice_up(0.3, 0.3)
                    card.ability.extra = card.ability.extra - 1
                end
            end
        end
        if card.ability.extra < 1 and not card.empty then
            card.empty = true
            G.E_MANAGER:add_event(Event({
                func = function()
                    play_sound('tarot1')
                    card.T.r = -0.2
                    card:juice_up(0.3, 0.4)
                    card.states.drag.is = true
                    card.children.center.pinch.x = true
                    G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.3, blockable = false,
                        func = function()
                                G.jokers:remove_card(card)
                                card:remove()
                                card = nil
                            return true; end})) 
                    return true
                end
            })) 
            card_eval_status_text(card, 'extra', nil, nil, nil, {message = 'Empty!', colour = G.C.RED})
        end
    end,
}

local ghost = Ceres.CONFIG.jokers.enabled and Ceres.CONFIG.jokers.rarities.uncommon.enabled and SMODS.Joker{
    key = 'ghost',
    rarity = 2,
    pos = {
        x = 1,
        y = 2,
    },
    config = {
        extra = 0.5,
        Xmult_mod = 1,
    },
    atlas = 'uncommon_jokers',
    cost = 6,
    unlocked = true,
    discovered = false or Ceres.CONFIG.misc.discover_all.enabled,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = false,

    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra, card.ability.Xmult_mod}}
    end,

    calculate = function(self, card, context)
        if context.using_consumeable and not context.blueprint then
            if context.consumeable.ability.set == 'Spectral' then
                card.ability.Xmult_mod = card.ability.Xmult_mod + card.ability.extra
                G.E_MANAGER:add_event(Event({
                    func = function() card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('k_upgrade_ex')}); return true
                    end}))
            end
        end
        if context.joker_main and card.ability.Xmult_mod > 1 then
            return {
                message = localize{type='variable',key='a_xmult',vars={card.ability.Xmult_mod}},
                colour = G.C.RED,
                Xmult_mod = card.ability.Xmult_mod,
            }
        end
    end,
}

local blacksmith = Ceres.CONFIG.jokers.enabled and Ceres.CONFIG.jokers.rarities.uncommon.enabled and SMODS.Joker{
    key = 'blacksmith',
    rarity = 2,
    pos = {
        x = 0,
        y = 2,
    },
    config = {
        extra = 0,
    },
    atlas = 'uncommon_jokers',
    cost = 7,
    unlocked = true,
    discovered = false or Ceres.CONFIG.misc.discover_all.enabled,
    blueprint_compat = true,
    eternal_compat = false,
    perishable_compat = false,

    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra, card.ability.extra == 1 and '' or 's'}}
    end,

    calculate = function(self, card, context)
        if context.selling_self then
            if card.ability.extra > 0 then
                local  _hand, _tally = nil, 0
                for k, v in ipairs(G.handlist) do
                    if G.GAME.hands[v].visible and G.GAME.hands[v].played > _tally then
                        _hand = v
                        _tally = G.GAME.hands[v].played
                    end
                end
                if _hand then
                    update_hand_text({sound = 'button', volume = 0.7, pitch = 0.8, delay = 0.3}, {handname=localize(_hand, 'poker_hands'),chips = G.GAME.hands[_hand].chips, mult = G.GAME.hands[_hand].mult, level=G.GAME.hands[_hand].level})
                    level_up_hand(card, _hand, nil, card.ability.extra)
                    update_hand_text({sound = 'button', volume = 0.7, pitch = 1.1, delay = 0}, {mult = 0, chips = 0, handname = '', level = ''})
                end
            end
        end
        if context.end_of_round and not (context.individual or context.repetition or context.blueprint) then
            card.ability.extra = card.ability.extra + 1
            card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('k_upgrade_ex'), colour = G.C.SECONDARY_SET.Planet})
        end
    end,
}

local cursed_purse = Ceres.CONFIG.jokers.enabled and Ceres.CONFIG.jokers.rarities.uncommon.enabled and SMODS.Joker{
    key = 'cursed_purse',
    rarity = 2,
    pos = {
        x = 2,
        y = 2,
    },
    config = {
        extra = 1,
    },
    atlas = 'uncommon_jokers',
    cost = 6,
    unlocked = true,
    discovered = false or Ceres.CONFIG.misc.discover_all.enabled,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,

    update = function(self, card, dt)
        if G.jokers then
            for i = 1, #G.jokers.cards do
                if G.jokers.cards[i].from_cursed_purse then 
                    G.jokers.cards[i]:set_debuff(false)
                    G.jokers.cards[i].from_cursed_purse = false
                end
                if G.jokers.cards[i] == card then
                    if i ~= 1 then
                        G.jokers.cards[i-1]:set_debuff(true)
                        G.jokers.cards[i-1].from_cursed_purse = true
                    end
                end
            end
        end
    end,

    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra}}
    end,

    add_to_deck = function(self, card, from_debuff)
        if not from_debuff and G.jokers then G.jokers:change_size(card.ability.extra) end
    end,

    remove_from_deck = function(self, card, from_debuff)
        if not from_debuff and G.jokers then G.jokers:change_size(-card.ability.extra) end
    end,
}

local collectors_book = Ceres.CONFIG.jokers.enabled and Ceres.CONFIG.jokers.rarities.uncommon.enabled and SMODS.Joker{
    key = 'collectors_book',
    rarity = 2,
    pos = {
        x = 3,
        y = 2,
    },
    config = {
        extra = 0.1,
        Xmult_mod = 1,
        used = {}
    },
    atlas = 'uncommon_jokers',
    cost = 6,
    unlocked = true,
    discovered = false or Ceres.CONFIG.misc.discover_all.enabled,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = false,

    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra, card.ability.Xmult_mod}}
    end,

    calculate = function(self, card, context)
        if context.using_consumeable and not context.blueprint then
            local new = true
            for _, consumable in pairs(card.ability.used) do
                if context.consumeable.ability.name == consumable then
                    new = false
                end
            end
            if new then
                card.ability.used[#card.ability.used+1] = context.consumeable.ability.name
                card.ability.Xmult_mod = card.ability.Xmult_mod + card.ability.extra
                G.E_MANAGER:add_event(Event({
                    func = function() card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('k_upgrade_ex'), colour = G.C.MULT}); return true
                    end
                }))
            end
        end
        if context.joker_main and card.ability.Xmult_mod > 1 then
            return {
                message = localize{type='variable',key='a_xmult',vars={card.ability.Xmult_mod}},
                colour = G.C.RED,
                Xmult_mod = card.ability.Xmult_mod,
            }
        end
    end,
}

local roulette = false and Ceres.CONFIG.jokers.enabled and Ceres.CONFIG.jokers.rarities.uncommon.enabled and SMODS.Joker{
    key = 'roulette',
    rarity = 2,
    pos = {
        x = 0,
        y = 0,
    },
    config = {
        odds = 2,
        Xmult_mod = 2,
    },
    atlas = 'uncommon_jokers',
    cost = 6,
    unlocked = true,
    discovered = false or Ceres.CONFIG.misc.discover_all.enabled,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = false,

    loc_vars = function(self, info_queue, card)
        return {vars = {G.GAME.probabilities.normal or 1, card.ability.odds, card.ability.Xmult_mod}}
    end,

    calculate = function(self, card, context)
        if context.using_consumeable and not context.blueprint then
            local new = true
            for _, consumable in pairs(card.ability.used) do
                if context.consumeable.ability.name == consumable then
                    new = false
                end
            end
            if new then
                card.ability.used[#card.ability.used+1] = context.consumeable.ability.name
                card.ability.Xmult_mod = card.ability.Xmult_mod + card.ability.extra
                G.E_MANAGER:add_event(Event({
                    func = function() card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('k_upgrade_ex'), colour = G.C.MULT}); return true
                    end
                }))
            end
        end
        if context.joker_main and card.ability.Xmult_mod > 1 then
            return {
                message = localize{type='variable',key='a_xmult',vars={card.ability.Xmult_mod}},
                colour = G.C.RED,
                Xmult_mod = card.ability.Xmult_mod,
            }
        end
    end,
}
