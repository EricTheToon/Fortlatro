SMODS.Joker({
	key = "occultist",
	atlas = "jokers",
	pos = {x = 8, y = 8},
	rarity = 2,
	cost = 8,
	unlocked = true,
	discovered = false,
	blueprint_compat = false,
	eternal_compat = true,
	perishable_compat = true,
	yes_pool_flag = 'shady_trading_redeemed',
	config = {},
	loc_vars = function(self, info_queue, card)
        if card and Ortalab.config.artist_credits then info_queue[#info_queue+1] = {generate_ui = ortalab_artist_tooltip, key = 'flare'} end
        if card and Ortalab.config.artist_credits then info_queue[#info_queue+1] = {generate_ui = ortalab_artist_tooltip, key = 'salad'} end
    end,
})

local CardSet_cost = Card.set_cost --Oculstist Logic
function Card.set_cost(self)
	CardSet_cost(self)
	if (self.ability.set == 'Spectral' or (self.ability.set == 'Booster' and self.ability.name:find('Spectral'))) and next(SMODS.find_card('j_ortalab_occultist')) then 
		self.cost = 0 
	end
end