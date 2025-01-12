SMODS.Joker({
	key = "crime_scene",
	atlas = "jokers",
	pos = {x = 6, y = 7},
	rarity = 2,
	cost = 6,
	unlocked = true,
	discovered = false,
	blueprint_compat = false,
	eternal_compat = true,
	perishable_compat = true,
	config = {extra = {banned_cards = {}}},
	loc_vars = function(self, info_queue, card)
        if card and Ortalab.config.artist_credits then info_queue[#info_queue+1] = {generate_ui = ortalab_artist_tooltip, key = 'grassy'} end
    end,
    remove_from_deck = function(self, card, from_debuff)
		for _, key in ipairs(card.ability.extra.banned_cards) do
            G.GAME.banned_keys[key] = nil
        end
	end,
})

local CardDissolve = Card.start_dissolve
function Card.start_dissolve(self)
    local crime_scene = SMODS.find_card('j_ortalab_crime_scene')
	if next(crime_scene) and self.ability.set == 'Joker' then
		sendDebugMessage("test")
		G.GAME.banned_keys[self.config.center_key] = true
        table.insert(crime_scene[1].ability.extra.banned_cards, self.config.center_key)
	end
	return CardDissolve(self)
end

