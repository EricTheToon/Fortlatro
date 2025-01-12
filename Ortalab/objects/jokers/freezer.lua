SMODS.Joker({
	key = "freezer",
	atlas = "jokers",
	pos = {x=1,y=11},
	rarity = 2,
	cost = 6,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = false,
	config = {extra = {xmult = 1, xmult_gain = 0.75, chance = 3, denom = 4}},
	loc_vars = function(self, info_queue, card)
        if card and Ortalab.config.artist_credits then info_queue[#info_queue+1] = {generate_ui = ortalab_artist_tooltip, key = 'gappie'} end
		return {vars = {card.ability.extra.xmult_gain, card.ability.extra.xmult + (card.ability.extra.xmult_gain * (G.consumeables and #G.consumeables.cards or 0)), math.max(1, G.GAME.probabilities.normal) * card.ability.extra.chance, card.ability.extra.denom / math.min(G.GAME.probabilities.normal, 1)}}
	end,
	calculate = function(self, card, context)
        if context.joker_main then
            return {
                message = localize{type='variable', key='a_xmult', vars={card.ability.extra.xmult + (card.ability.extra.xmult_gain * #G.consumeables.cards)}},
                Xmult_mod = card.ability.extra.xmult + (card.ability.extra.xmult_gain * #G.consumeables.cards), 
                colour = G.C.RED,
                card = card
            }
        end
    end
})