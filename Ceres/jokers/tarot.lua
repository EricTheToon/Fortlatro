-- -- atlas for uncommon jokers

local tarot_joker_atlas = SMODS.Atlas{
    key = 'tarot_joker',
    path = 'tarot_jokers.png',
    px = 71,
    py = 95,
    atlas_table = 'ASSET_ATLAS',
}

local reversed_shader = SMODS.Shader({key = 'reversed', path = 'reversed.fs'})

local card_draw_ref = Card.draw
function Card:draw(layer)
    layer = layer or 'both'
    if (layer == 'card' or layer == 'both') then
        if self.children.reverse_button and self.sprite_facing == 'front' then
            if self.highlighted then
                self.children.reverse_button.states.visible = true
                self.children.reverse_button:draw()
            else
                self.children.reverse_button.states.visible = false
            end
        end
        if self.children.booster_reverse_button and self.sprite_facing == 'front' then
            if self.highlighted then
                self.children.booster_reverse_button.states.visible = true
                self.children.booster_reverse_button:draw()
            else
                self.children.booster_reverse_button.states.visible = false
            end
        end
    end
    card_draw_ref(self, layer)
    if self.sprite_facing == 'front' and self.ability.reversed then
        self.children.center:draw_shader('cere_reversed', nil, nil, nil, self.children.center)
    end
end

function create_reverse_card_ui(card)
    G.E_MANAGER:add_event(Event({
        trigger = 'after',
        delay = 0.43,
        blocking = false,
        blockable = false,
        func = (function()
            local t = {
                n=G.UIT.ROOT, config = {ref_table = card, minw = 1.1, maxw = 1.3, padding = 0.1, align = 'bm', colour = G.C.GOLD, shadow = true, r = 0.08, minh = 0.94, button = 'reverse_card', hover = true}, nodes={
                    {n=G.UIT.T, config={text = 'REVERSE',colour = G.C.WHITE, scale = 0.5}}
                }
            }
        
            card.children.reverse_button = UIBox{
                definition = t,
                config = {
                    align = "bm",
                    offset = {
                        x = 0,
                        y = -0.55,
                    },
                    parent = card
                }
            }       
            return true
        end)
    }))
end

function create_booster_reverse_card_ui(card)
    G.E_MANAGER:add_event(Event({
        trigger = 'after',
        delay = 0.43,
        blocking = false,
        blockable = false,
        func = (function()
            local t = {
                n=G.UIT.ROOT, config = {ref_table = card, minw = 1.1, maxw = 1.3, padding = 0.1, align = 'tm', colour = G.C.GOLD, shadow = true, r = 0.08, minh = 0.94, button = 'reverse_card', hover = true}, nodes={
                    {n=G.UIT.T, config={text = 'REVERSE',colour = G.C.WHITE, scale = 0.5}}
                }
            }
        
            card.children.booster_reverse_button = UIBox{
                definition = t,
                config = {
                    align = "tm",
                    offset = {
                        x = 0,
                        y = 0.55,
                    },
                    parent = card
                }
            }       
            return true
        end)
    }))
end

function get_tarot_joker_key()
end

local tarot_joker_pool = {
    'j_cere_empress_joker',
    'j_cere_strength_joker',
    'j_cere_judgement_joker',
}

function get_tarot_joker()
    --create the pool
    G.ARGS.TEMP_POOL = EMPTY(G.ARGS.TEMP_POOL)
    local _pool, _starting_pool, _pool_key, _pool_size = G.ARGS.TEMP_POOL, nil, '', 0

    local rarity = 'cere_divine'
    local _starting_pool, _pool_key = tarot_joker_pool, 'Joker'..'cere_tarot_joker'

    --cull the pool
    for k, v in ipairs(_starting_pool) do
        local add = nil
        if not (G.GAME.used_jokers[v] and not next(find_joker("Showman"))) then
            add = true
        end

        if add then 
            _pool[#_pool + 1] = v
            _pool_size = _pool_size + 1
        else
            _pool[#_pool + 1] = 'UNAVAILABLE'
        end
    end

    --if pool is empty
    if _pool_size == 0 then
        _pool[#_pool + 1] = "j_joker"
    end

    local center = pseudorandom_element(_pool, pseudoseed(_pool_key))
    local it = 1
    while center == 'UNAVAILABLE' do
        it = it + 1
        center = pseudorandom_element(_pool, pseudoseed(_pool_key..'_resample'..it))
    end
    return center
end

G.FUNCS.reverse_card = function(e)
    local card = e.config.ref_table
    card.ability.reversed = not card.ability.reversed
    card:highlight(false)
    card:juice_up(0.7)
    play_sound('timpani')
    local center = card.config.center
    if center.reverse and type(center.reverse) == 'function' then
        center:reverse(card)
    end
end

-- custom rare jokers

local fool_joker = false and Ceres.CONFIG.jokers.enabled and Ceres.CONFIG.jokers.rarities.rare.enabled and SMODS.Joker{
    key = 'fool_joker',
    rarity = 3,
    unlocked = false or Ceres.CONFIG.misc.unlock_all.enabled,
    discovered = false or Ceres.CONFIG.misc.discover_all.enabled,
    pos = {
        x = 0,
        y = 0,
    },
    config = {
        reversed = false,
    },
    cost = 10,
    atlas = 'tarot_joker',
    eternal_compat = true,
    perishable_compat = true,
    blueprint_compat = false,

    add_to_deck = function(self, card, from_debuff)
        if not from_debuff then
            create_reverse_card_ui(card)
        end
    end,

    generate_ui = function(self, info_queue, card, desc_nodes, specific_vars, full_UI_table)
        local key = self.key
        if card.ability.reversed then
            key = key .. '_reversed'
        end
        local target = {
            type = 'descriptions',
            key = key,
            set = self.set,
            nodes = desc_nodes,
            vars =
                specific_vars or {}
        }
        local res = {}
        if self.loc_vars and type(self.loc_vars) == 'function' then
            res = self:loc_vars(info_queue, card) or {}
            target.vars = res.vars or target.vars
            target.key = res.key or target.key
        end
        if not full_UI_table.name then
            full_UI_table.name = localize { type = 'name', set = self.set, key = target.key or key, nodes = full_UI_table.name }
        end
        if specific_vars and specific_vars.debuffed and not res.replace_debuff then
            target = { type = 'other', key = 'debuffed_' ..
            (specific_vars.playing_card and 'playing_card' or 'default'), nodes = desc_nodes }
        end
        if res.main_start then
            desc_nodes[#desc_nodes + 1] = res.main_start
        end
        localize(target)
        if res.main_end then
            desc_nodes[#desc_nodes + 1] = res.main_end
        end
    end,

    load = function(self, card, card_table, other_card)
        create_reverse_card_ui(card)
    end,
}

local draw_card_ref = draw_card
function draw_card(from, to, percent, dir, sort, card, delay, mute, stay_flipped, vol, discarded_only)
    if from == G.play and to == G.discard and #SMODS.find_card('j_cere_fool_joker') > 0 then
        to = G.deck
    end
    draw_card_ref(from, to, percent, dir, sort, card, delay, mute, stay_flipped, vol, discarded_only)
end

local empress_joker = Ceres.CONFIG.jokers.enabled and Ceres.CONFIG.jokers.rarities.rare.enabled and SMODS.Joker{
    key = 'empress_joker',
    rarity = 3,
    unlocked = false or Ceres.CONFIG.misc.unlock_all.enabled,
    discovered = false or Ceres.CONFIG.misc.discover_all.enabled,
    pos = {
        x = 3,
        y = 0,
    },
    config = {
        reversed = false,
    },
    cost = 10,
    atlas = 'tarot_joker',
    eternal_compat = true,
    perishable_compat = true,
    blueprint_compat = false,

    add_to_deck = function(self, card, from_debuff)
        if not from_debuff then
            if card.children.booster_reverse_button then card.children.booster_reverse_button = nil end
            create_reverse_card_ui(card)
        end
    end,

    loc_vars = function (self, info_queue, card)
        info_queue[#info_queue+1] = { set = 'Other', key = 'cere_temporary'}
        if card.ability.reversed then
            info_queue[#info_queue+1] = G.P_CENTERS['m_steel']
        else
            info_queue[#info_queue+1] = G.P_CENTERS['m_glass']
        end
        info_queue[#info_queue+1] = {key = 'red_seal', set = 'Other'}
    end,

    in_pool = function()
        return false
    end,

    generate_ui = function(self, info_queue, card, desc_nodes, specific_vars, full_UI_table)
        local key = self.key
        if card.ability.reversed then
            key = key .. '_reversed'
        end
        local target = {
            type = 'descriptions',
            key = key,
            set = self.set,
            nodes = desc_nodes,
            vars =
                specific_vars or {}
        }
        local res = {}
        if self.loc_vars and type(self.loc_vars) == 'function' then
            res = self:loc_vars(info_queue, card) or {}
            target.vars = res.vars or target.vars
            target.key = res.key or target.key
        end
        if not full_UI_table.name then
            full_UI_table.name = localize { type = 'name', set = self.set, key = target.key or key, nodes = full_UI_table.name }
        end
        if specific_vars and specific_vars.debuffed and not res.replace_debuff then
            target = { type = 'other', key = 'debuffed_' ..
            (specific_vars.playing_card and 'playing_card' or 'default'), nodes = desc_nodes }
        end
        if res.main_start then
            desc_nodes[#desc_nodes + 1] = res.main_start
        end
        localize(target)
        if res.main_end then
            desc_nodes[#desc_nodes + 1] = res.main_end
        end
    end,

    calculate = function(self, card, context)
        if context.first_hand_drawn and not context.blueprint then
            G.playing_card = (G.playing_card and G.playing_card + 1) or 1
            local center = card.ability.reversed and G.P_CENTERS['m_steel'] or G.P_CENTERS['m_glass']
            local _card = Card(G.deck.T.x, G.deck.T.y, G.CARD_W, G.CARD_H, G.P_CARDS['H_A'], center, {playing_card = G.playing_card})
            _card.states.visible = nil
            _card:set_seal('Red', true, true)
            _card:set_temporary(true)
            table.insert(G.playing_cards, _card)
            G.hand:emplace(_card)
            _card:start_materialize()
        end
    end,

    load = function(self, card, card_table, other_card)
        create_reverse_card_ui(card)
    end,
}

local hermit_joker = false and Ceres.CONFIG.jokers.enabled and Ceres.CONFIG.jokers.rarities.rare.enabled and SMODS.Joker{
    key = 'hermit_joker',
    rarity = 3,
    unlocked = false or Ceres.CONFIG.misc.unlock_all.enabled,
    discovered = false or Ceres.CONFIG.misc.discover_all.enabled,
    pos = {
        x = 0,
        y = 0,
    },
    cost = 10,
    config = {
        extra = 2,
        hand_size = 1,
        reversed = false,
    },
    atlas = 'tarot_joker',
    eternal_compat = true,
    perishable_compat = true,
    blueprint_compat = false,

    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.hand_size, card.ability.extra}}
    end,

    generate_ui = function(self, info_queue, card, desc_nodes, specific_vars, full_UI_table)
        local key = self.key
        if card.ability.reversed then
            key = key .. '_reversed'
        end
        local target = {
            type = 'descriptions',
            key = key,
            set = self.set,
            nodes = desc_nodes,
            vars =
                specific_vars or {}
        }
        local res = {}
        if self.loc_vars and type(self.loc_vars) == 'function' then
            res = self:loc_vars(info_queue, card) or {}
            target.vars = res.vars or target.vars
            target.key = res.key or target.key
        end
        if not full_UI_table.name then
            full_UI_table.name = localize { type = 'name', set = self.set, key = target.key or key, nodes = full_UI_table.name }
        end
        if specific_vars and specific_vars.debuffed and not res.replace_debuff then
            target = { type = 'other', key = 'debuffed_' ..
            (specific_vars.playing_card and 'playing_card' or 'default'), nodes = desc_nodes }
        end
        if res.main_start then
            desc_nodes[#desc_nodes + 1] = res.main_start
        end
        localize(target)
        if res.main_end then
            desc_nodes[#desc_nodes + 1] = res.main_end
        end
    end,

    add_to_deck = function(self, card, from_debuff)
        if not from_debuff then
            create_reverse_card_ui(card)
        end

        G.hand:change_size(card.ability.hand_size)
        G.GAME.round_resets.hands = G.GAME.round_resets.hands + card.ability.extra
        update_hermit_vals(card.ability.reversed, card.ability.extra, not from_debuff)
    end,

    remove_from_deck = function(self, card, from_debuff)
        G.hand:change_size(-card.ability.hand_size)
        if card.ability.reversed then
            G.GAME.round_resets.discards = G.GAME.round_resets.discards - card.ability.extra
        else
            G.GAME.round_resets.hands = G.GAME.round_resets.hands - card.ability.extra
        end
        update_hermit_vals(card.ability.reversed, card.ability.extra, nil, not from_debuff)
    end,

    reverse = function(self, card)
        if card.ability.reversed then
            G.GAME.round_resets.hands = G.GAME.round_resets.hands - card.ability.extra
            G.GAME.round_resets.discards = G.GAME.round_resets.discards + card.ability.extra
        else
            G.GAME.round_resets.hands = G.GAME.round_resets.hands + card.ability.extra
            G.GAME.round_resets.discards = G.GAME.round_resets.discards - card.ability.extra
        end
        update_hermit_vals(card.ability.reversed, card.ability.extra)
    end,

    load = function(self, card, card_table, other_card)
        create_reverse_card_ui(card)
    end,
}

function update_hermit_vals(flipped, amt, first, last)
    if G.STATE == G.STATES.SELECTING_HAND or G.STATE == G.STATES.HAND_PLAYED or G.STATE == G.STATES.DRAW_TO_HAND then 
        return
    else
        if first then
            ease_hands_played(amt)
        elseif last then
            if flipped then
                ease_discard(amt * -1)
            else
                ease_hands_played(amt * -1)
            end
        else
            local mod = (flipped and -1) or 1
            ease_hands_played(mod * amt)
            ease_discard(mod * amt * -1)
        end
    end
end

local strength_joker = Ceres.CONFIG.jokers.enabled and Ceres.CONFIG.jokers.rarities.rare.enabled and SMODS.Joker{
    key = 'strength_joker',
    rarity = 3,
    unlocked = false or Ceres.CONFIG.misc.unlock_all.enabled,
    discovered = false or Ceres.CONFIG.misc.discover_all.enabled,
    pos = {
        x = 1,
        y = 1,
    },
    config = {
        reversed = false,
        extra = 2,
        discard = 0,
        destroy = 2,
        to_destroy = {},
        retriggers = 0,
    },
    cost = 10,
    atlas = 'tarot_joker',
    eternal_compat = true,
    perishable_compat = true,
    blueprint_compat = false,

    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra, card.ability.destroy}}
    end,

    add_to_deck = function(self, card, from_debuff)
        if not from_debuff then
            if card.children.booster_reverse_button then card.children.booster_reverse_button = nil end
            create_reverse_card_ui(card)
        end
    end,

    in_pool = function()
        return false
    end,

    generate_ui = function(self, info_queue, card, desc_nodes, specific_vars, full_UI_table)
        local key = self.key
        if card.ability.reversed then
            key = key .. '_reversed'
        end
        local target = {
            type = 'descriptions',
            key = key,
            set = self.set,
            nodes = desc_nodes,
            vars =
                specific_vars or {}
        }
        local res = {}
        if self.loc_vars and type(self.loc_vars) == 'function' then
            res = self:loc_vars(info_queue, card) or {}
            target.vars = res.vars or target.vars
            target.key = res.key or target.key
        end
        if not full_UI_table.name then
            full_UI_table.name = localize { type = 'name', set = self.set, key = target.key or key, nodes = full_UI_table.name }
        end
        if specific_vars and specific_vars.debuffed and not res.replace_debuff then
            target = { type = 'other', key = 'debuffed_' ..
            (specific_vars.playing_card and 'playing_card' or 'default'), nodes = desc_nodes }
        end
        if res.main_start then
            desc_nodes[#desc_nodes + 1] = res.main_start
        end
        localize(target)
        if res.main_end then
            desc_nodes[#desc_nodes + 1] = res.main_end
        end
    end,

    calculate = function(self, card, context)
        if context.before and not context.blueprint then
            if not card.ability.reversed then
                card.ability.discard = math.floor(#G.hand.cards / card.ability.extra)
                local any_selected = nil
                for i = 1, #G.hand.cards do
                    local _card = G.hand.cards[i]
                    G.hand.highlighted[#G.hand.highlighted+1] = _card
                    _card:highlight(true)
                    any_selected = true
                    play_sound('card1', 1)
                end
                if any_selected then G.FUNCS.discard_cards_from_highlighted(nil, true) end
                delay(0.7)
            else
                if #card.ability.to_destroy > 0 then
                    for i = #card.ability.to_destroy, 1, -1 do
                        card:juice_up(0.7)
                        card.ability.to_destroy[i]:start_dissolve()
                    end
                end
            end
        end
        if context.repetition and not context.blueprint then
            if context.cardarea == G.play and not card.ability.reversed and card.ability.discard > 0 then
                return {
                    message = localize('k_again_ex'),
                    repetitions = card.ability.discard,
                    card = card
                }
            end
            if context.cardarea == G.hand and card.ability.reversed and card.ability.retriggers > 0 then
                if context.card_effects and (next(context.card_effects[1]) or #context.card_effects > 1) then
                    return {
                        message = localize('k_again_ex'),
                        repetitions = card.ability.retriggers,
                        card = card
                    }
                end
            end
        end  
    end,

    load = function(self, card, card_table, other_card)
        create_reverse_card_ui(card)
    end,
}

local judgement_joker = Ceres.CONFIG.jokers.enabled and Ceres.CONFIG.jokers.rarities.rare.enabled and SMODS.Joker{
    key = 'judgement_joker',
    rarity = 3,
    unlocked = false or Ceres.CONFIG.misc.unlock_all.enabled,
    discovered = false or Ceres.CONFIG.misc.discover_all.enabled,
    pos = {
        x = 0,
        y = 2,
    },
    config = {
        reversed = false,
    },
    cost = 10,
    atlas = 'tarot_joker',
    eternal_compat = true,
    perishable_compat = true,
    blueprint_compat = false,

    add_to_deck = function(self, card, from_debuff)
        if not from_debuff then
            if card.children.booster_reverse_button then card.children.booster_reverse_button = nil end
            create_reverse_card_ui(card)
        end
    end,

    in_pool = function()
        return false
    end,

    loc_vars = function (self, info_queue, card)
        info_queue[#info_queue+1] = { set = 'Other', key = 'cere_temporary'}
    end,

    generate_ui = function(self, info_queue, card, desc_nodes, specific_vars, full_UI_table)
        local key = self.key
        if card.ability.reversed then
            key = key .. '_reversed'
        end
        local target = {
            type = 'descriptions',
            key = key,
            set = self.set,
            nodes = desc_nodes,
            vars =
                specific_vars or {}
        }
        local res = {}
        if self.loc_vars and type(self.loc_vars) == 'function' then
            res = self:loc_vars(info_queue, card) or {}
            target.vars = res.vars or target.vars
            target.key = res.key or target.key
        end
        if not full_UI_table.name then
            full_UI_table.name = localize { type = 'name', set = self.set, key = target.key or key, nodes = full_UI_table.name }
        end
        if specific_vars and specific_vars.debuffed and not res.replace_debuff then
            target = { type = 'other', key = 'debuffed_' ..
            (specific_vars.playing_card and 'playing_card' or 'default'), nodes = desc_nodes }
        end
        if res.main_start then
            desc_nodes[#desc_nodes + 1] = res.main_start
        end
        localize(target)
        if res.main_end then
            desc_nodes[#desc_nodes + 1] = res.main_end
        end
    end,

    calculate = function(self, card, context)
        if context.before and not context.blueprint then
            local card_copy = (card.ability.reversed and #G.hand.cards > 0 and G.hand.cards[1]) or G.play.cards[1] 
            G.playing_card = (G.playing_card and G.playing_card + 1) or 1
            local _card = copy_card(card_copy, nil, nil, G.playing_card)
            _card.states.visible = nil
            _card:set_temporary(true)
            table.insert(G.playing_cards, _card)
            G.hand:emplace(_card)
            _card:start_materialize()
        end
    end,

    load = function(self, card, card_table, other_card)
        create_reverse_card_ui(card)
    end,
}
