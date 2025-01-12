SMODS.Joker({
	key = "business",
	atlas = "jokers",
	pos = {x=9,y=1},
	rarity = 1,
	cost = 4,
	unlocked = true,
	discovered = false,
	blueprint_compat = false,
	eternal_compat = true,
	perishable_compat = false,
	config = {extra = {reroll_cut = 1}},
	loc_vars = function(self, info_queue, card)
        if card and Ortalab.config.artist_credits then info_queue[#info_queue+1] = {generate_ui = ortalab_artist_tooltip, key = 'alex'} end
		return {vars = {card.ability.extra.reroll_cut}}
	end,
	add_to_deck = function(self, card, from_debuff)
		G.E_MANAGER:add_event(Event({func = function()
			G.GAME.round_resets.reroll_cost = G.GAME.round_resets.reroll_cost - card.ability.extra.reroll_cut
			G.GAME.current_round.reroll_cost = math.max(0, G.GAME.current_round.reroll_cost - card.ability.extra.reroll_cut)
			return true
        end}))
	end,
	remove_from_deck = function(self, card, from_debuff)
		G.E_MANAGER:add_event(Event({func = function()
			G.GAME.round_resets.reroll_cost = G.GAME.round_resets.reroll_cost + card.ability.extra.reroll_cut
			return true
        end}))
	end,
})