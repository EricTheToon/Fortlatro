SMODS.Joker({
	key = "mirage",
	atlas = "jokers",
	pos = {x=6,y=4},
	rarity = 2,
	cost = 5,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = false,
	config = {extra = {xmult = 1, gain = 0.15}},
	loc_vars = function(self, info_queue, card)
        if card and Ortalab.config.artist_credits then info_queue[#info_queue+1] = {generate_ui = ortalab_artist_tooltip, key = 'gappie'} end
		return {vars = {card.ability.extra.gain, card.ability.extra.xmult}}
	end,
	calculate = function(self, card, context)
		if context.joker_main then
            return {
                message = localize{type='variable',key='a_xmult',vars={card.ability.extra.xmult}},
                Xmult_mod = card.ability.extra.xmult
            }
        end
        if context.remove_playing_cards and not context.blueprint then
            for i=1, #context.removed do
                card.ability.extra.xmult = card.ability.extra.xmult + card.ability.extra.gain
                card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize({type='variable', key='a_xmult', vars={card.ability.extra.gain}, colour = G.C.RED})})
            end
        end
    end
})