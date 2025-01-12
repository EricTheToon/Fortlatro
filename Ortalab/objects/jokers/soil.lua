SMODS.Joker({
	key = "soil",
	atlas = "jokers",
	pos = {x=7,y=9},
	rarity = 2,
	cost = 6,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = false,
	config = {extra = {xmult = 1, xmult_gain = 0.75}},
	loc_vars = function(self, info_queue, card)
        if card and Ortalab.config.artist_credits then info_queue[#info_queue+1] = {generate_ui = ortalab_artist_tooltip, key = 'gappie'} end
		return {vars = {card.ability.extra.xmult, card.ability.extra.xmult_gain}}
	end,
	calculate = function(self, card, context)
        if context.before then
            card.ability.extra.consecutive_ranks = 0
			card.ability.extra.last_triggered = nil
        end
        if context.joker_main then
			local xmult_to_add = card.ability.extra.xmult + (card.ability.extra.xmult_gain * card.ability.extra.consecutive_ranks)
            return {
                message = localize{type='variable', key='a_xmult', vars={xmult_to_add}},
                Xmult_mod = xmult_to_add, 
                colour = G.C.RED,
                card = card
            }
        end
    end
})