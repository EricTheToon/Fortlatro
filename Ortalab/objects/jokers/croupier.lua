SMODS.Joker({
	key = "croupier",
	atlas = "jokers",
	pos = {x = 1, y = 4},
	rarity = 2,
	cost = 8,
	unlocked = true,
	discovered = false,
	blueprint_compat = false,
	eternal_compat = true,
	perishable_compat = true,
	config = {},
	loc_vars = function(self, info_queue, card)
        if card and Ortalab.config.artist_credits then info_queue[#info_queue+1] = {generate_ui = ortalab_artist_tooltip, key = 'gappie'} end
    end
})

local CardOpen_ref = Card.open
function Card.open(self)
	for _, _ in pairs(SMODS.find_card('j_ortalab_croupier')) do
		if self.ability.set == "Booster" then
			self.ability.extra = self.ability.extra + 1
		end
	end
	return CardOpen_ref(self)
end