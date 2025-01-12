SMODS.Joker({
	key = "sun_sign",
	atlas = "jokers",
	pos = {x = 7, y = 13},
	rarity = 2,
	cost = 5,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	config = {extra = {dollars = 1}},
    loc_vars = function(self, info_queue, card)
        if card and Ortalab.config.artist_credits then info_queue[#info_queue+1] = {generate_ui = ortalab_artist_tooltip, key = 'gappie'} end
        return {vars = {card.ability.extra.dollars, table.size(G.GAME.zodiacs_activated or {})*card.ability.extra.dollars}}
    end,
    calc_dollar_bonus = function(self, card)
		return table.size(G.GAME.zodiacs_activated)*card.ability.extra.dollars
	end
})