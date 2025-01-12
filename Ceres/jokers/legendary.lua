-- atlas for legendary jokers

local legendary_joker_atlas = SMODS.Atlas{
    key = 'legendary_jokers',
    path = 'legendary_jokers.png',
    px = 71,
    py = 95,
    atlas_table = 'ASSET_ATLAS',
}

-- custom legendary jokers

local traveling_merchant = Ceres.CONFIG.jokers.enabled and Ceres.CONFIG.jokers.rarities.legendary.enabled and SMODS.Joker{
    key = 'traveling_merchant',
    rarity = 4,
    pos = {
        x = 1,
        y = 0,
    },
    soul_pos = {
        x = 1,
        y = 1,
    },
    config = {},
    atlas = 'legendary_jokers',
    cost = 20,
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
            }
        }
    end,

    calculate = function(self, card, context)
        if context.setting_blind and not card.getting_sliced then
            local joker_slot = 1
            for i = 1, #G.jokers.cards do
                if context.blueprint_card then
                    if G.jokers.cards[i] == context.blueprint_card then
                        joker_slot = i
                        break
                    end
                else
                    if G.jokers.cards[i] == card then
                        joker_slot = i
                        break
                    end
                end
            end
            joker_slot = joker_slot % 3
            if joker_slot == 0 then joker_slot = 3 end
            if joker_slot == 1 then
                G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
                G.E_MANAGER:add_event(Event({
                    trigger = 'before',
                    delay = 0.0,
                    func = (function()
                            local _card = create_card('Tarot', G.consumeables, nil, nil, nil, nil, nil, 'ceres')
                            _card:set_edition({negative = true}, true)
                            _card:add_to_deck()
                            G.consumeables:emplace(_card)
                            G.GAME.consumeable_buffer = 0
                        return true
                    end)}))
                card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = localize('k_plus_tarot'), colour = G.C.SECONDARY_SET.Tarot})
            elseif joker_slot == 2 then
                G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
                G.E_MANAGER:add_event(Event({
                    trigger = 'before',
                    delay = 0.0,
                    func = (function()
                            local _card = create_card('Planet', G.consumeables, nil, nil, nil, nil, nil, 'ceres')
                            _card:set_edition({negative = true}, true)
                            _card:add_to_deck()
                            G.consumeables:emplace(_card)
                            G.GAME.consumeable_buffer = 0
                        return true
                    end)}))
                card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = localize('k_plus_planet'), colour = G.C.SECONDARY_SET.Planet})
            elseif joker_slot == 3 then
                G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
                G.E_MANAGER:add_event(Event({
                    trigger = 'before',
                    delay = 0.0,
                    func = (function()
                            local _card = create_card('Spectral', G.consumeables, nil, nil, nil, nil, nil, 'ceres')
                            _card:set_edition({negative = true}, true)
                            _card:add_to_deck()
                            G.consumeables:emplace(_card)
                            G.GAME.consumeable_buffer = 0
                        return true
                    end)}))
                card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = localize('k_plus_spectral'), colour = G.C.SECONDARY_SET.Spectral})
            end
        end
    end,
}