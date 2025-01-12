SMODS.Joker({
	key = "revolver",
	atlas = "jokers",
	pos = {x = 0, y = 1},
	rarity = 1,
	cost = 4,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	config = {extra = {chips = 0, modifier = 5}},
	loc_vars = function(self, info_queue, card)
        if card and Ortalab.config.artist_credits then info_queue[#info_queue+1] = {generate_ui = ortalab_artist_tooltip, key = 'gappie'} end
        return {vars = {card.ability.extra.modifier, card.ability.extra.chips}}
    end,
    calculate = function(self, card, context)
        if context.setting_blind and not context.blueprint then
            if G.jokers.cards[1] == card then return end
            if not card.getting_sliced and not G.jokers.cards[1].ability.eternal and not G.jokers.cards[1].getting_sliced then 
                local sliced_card = G.jokers.cards[1]
                sliced_card.getting_sliced = true
                G.GAME.joker_buffer = G.GAME.joker_buffer - 1
                G.E_MANAGER:add_event(Event({func = function()
                    G.GAME.joker_buffer = 0
                    card.ability.extra.chips = card.ability.extra.chips + sliced_card.sell_cost*card.ability.extra.modifier
                    card:juice_up(0.8, 0.8)
                    sliced_card:start_dissolve({HEX("dc486f")}, nil, 1.6)
                    play_sound('ortalab_gun1', 0.96+math.random()*0.08)
                return true end }))
                card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize{type = 'variable', key = 'a_chips', vars = {card.ability.extra.modifier*sliced_card.sell_cost}}, colour = G.C.BLUE, no_juice = true})
            end
        end
        if context.joker_main and card.ability.extra.chips > 0 then
            return {
                chip_mod = card.ability.extra.chips,
                card = card,
                message = localize{type='variable',key='a_chips',vars={card.ability.extra.chips}}
            }
        end
    end
})

SMODS.Sound({
    key = 'gun1',
    path = 'gun1.ogg'
})