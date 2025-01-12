SMODS.Joker({
	key = "skydiving",
	atlas = "jokers",
	pos = {x=0,y=3},
	rarity = 2,
	cost = 6,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = false,
	config = {extra = {curr_xmult = 1, xmult_add = 0.3}},
    loc_vars = function(self, info_queue, card)
        if card and Ortalab.config.artist_credits then info_queue[#info_queue+1] = {generate_ui = ortalab_artist_tooltip, key = 'alex'} end
        return {vars = {card.ability.extra.xmult_add, card.ability.extra.curr_xmult}}
    end,
	calculate = function(self, card, context)
		if not context.blueprint and context.cardarea == G.jokers and context.before and G.GAME.hands[context.scoring_name].level ~= 1 then
			if G.GAME.hands[context.scoring_name].level < 1 then
				return {
					card = card,
					level_up = true,
					message = localize('k_level_up_ex')
				}
			else
				local levels_to_remove = G.GAME.hands[context.scoring_name].level - 1
				card.ability.extra.curr_xmult = card.ability.extra.curr_xmult + (levels_to_remove*card.ability.extra.xmult_add)
				level_up_hand(card, context.scoring_name, nil, -levels_to_remove)
				return {
					card = card,
					colour = G.C.RED,
					message = localize{type='variable',key='a_xmult',vars={card.ability.extra.curr_xmult}}
				}
			end
		end
		if context.joker_main and card.ability.extra.curr_xmult > 1 then
			return {
				message = localize{type='variable',key='a_xmult',vars={card.ability.extra.curr_xmult}},
				Xmult_mod = card.ability.extra.curr_xmult
			}
		end
	end
})
