

-- HOOKS

local end_round_ref = end_round
function end_round()
	-- remove any temp jokers
    for _, card in pairs(G.GAME.cere.jokers) do
        if card and type(card) == 'table' and card.start_dissolve then
            card:start_dissolve()
        end
    end
    G.GAME.cere.jokers = EMPTY(G.GAME.cere.jokers)
	-- set hand size back to normal
	G.hand.config.real_card_limit = (G.hand.config.real_card_limit or G.hand.config.card_limit) - G.GAME.cere.hand_size
    G.hand.config.card_limit = math.max(0, G.hand.config.real_card_limit)
	G.GAME.cere.hand_size = 0
    if Ceres.CONFIG.card_modifiers.perks.enabled or (Ceres.COMPAT.eris and Eris.CONFIG.perks.enabled) then
        ease_advantage(1)
    end
    end_round_ref()
end

local draw_from_hand_to_discard_ref = G.FUNCS.draw_from_hand_to_discard
G.FUNCS.draw_from_hand_to_discard = function(e)
    local count = #G.cere_perks.cards
    for i=1, count do
        draw_card(G.perks,G.discard, i*100/count,'down', nil, nil, 0.07)
    end
    draw_from_hand_to_discard_ref(e)
end

local draw_card_ref = draw_card
function draw_card(from, to, percent, dir, sort, card, delay, mute, stay_flipped, vol, discarded_only)
    if card then
        -- drawing cards from deck to perk area
        if from == G.deck and to == G.hand and card.ability.set == 'Perk' then
            to = G.cere_perks
            dir = 'up'
            sort = true
        end
    end
    draw_card_ref(from, to, percent, dir, sort, card, delay, mute, stay_flipped, vol, discarded_only)
end

local get_starting_params_ref = get_starting_params
function get_starting_params()
    local ret = get_starting_params_ref()
    ret.advantage = 0
    return ret
end

local loc_colour_ref = loc_colour
function loc_colour(_c, _default)
    return Ceres.C[_c] or loc_colour_ref(_c, _default)
end

local controller_queue_R_cursor_press_ref = Controller.queue_R_cursor_press
function Controller:queue_R_cursor_press(x, y)
    if self.locks.frame then return end
    if not G.SETTINGS.paused and G.cere_perks and G.cere_perks.highlighted[1] then 
        if (G.play and #G.play.cards > 0) or
        (self.locked) or 
        (self.locks.frame) or
        (G.GAME.STOP_USE and G.GAME.STOP_USE > 0) then return end
        G.cere_perks:unhighlight_all()
    end
    controller_queue_R_cursor_press_ref(self, x, y)
end