SMODS.Joker({
	key = "reduce_reuse",
	atlas = "jokers",
	pos = {x = 6, y = 5},
	rarity = 1,
	cost = 4,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	config = {extra = {money = 2}},
	loc_vars = function(self, info_queue, card)
        if card and Ortalab.config.artist_credits then info_queue[#info_queue+1] = {generate_ui = ortalab_artist_tooltip, key = 'gappie'} end
        return {vars = {card.ability.extra.money}}
    end,
	calc_dollar_bonus = function(self, card)
		return G.GAME.current_round.hands_left * card.ability.extra.money
	end
})