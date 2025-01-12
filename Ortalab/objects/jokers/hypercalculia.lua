SMODS.Joker({
	key = "hypercalculia",
	atlas = "jokers",
	pos = {x = 4, y = 2},
	rarity = 2,
	cost = 6,
	unlocked = true,
	discovered = false,
	blueprint_compat = false,
	eternal_compat = true,
	perishable_compat = true,
	loc_vars = function(self, info_queue, card)
        if card and Ortalab.config.artist_credits then info_queue[#info_queue+1] = {generate_ui = ortalab_artist_tooltip, key = 'flare'} end
    end
})

local face_check = Card.is_face
function Card:is_face(from_boss)
    if next(SMODS.find_card('j_ortalab_hypercalculia')) then return false end
    return face_check(self, from_boss)
end
