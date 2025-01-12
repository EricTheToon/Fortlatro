SMODS.Joker({
	key = "astrologist",
	atlas = "jokers",
	pos = {x = 9, y = 13},
	rarity = 2,
	cost = 5,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	config = {extra = {mod = 2}},
    loc_vars = function(self, info_queue, card)
        if card and Ortalab.config.artist_credits then info_queue[#info_queue+1] = {generate_ui = ortalab_artist_tooltip, key = 'gappie'} end
        return {vars = {card.ability.extra.mod}}
    end,
	add_to_deck = function(self, card, from_debuff)
        G.GAME.Ortalab_Zodiac_Reduction = G.GAME.Ortalab_Zodiac_Reduction * card.ability.extra.mod
        G.GAME.Ortalab_zodiac_temp_level_mod = G.GAME.Ortalab_zodiac_temp_level_mod * card.ability.extra.mod
    end,
    remove_from_deck = function(self, card, from_debuff)
        G.GAME.Ortalab_Zodiac_Reduction = G.GAME.Ortalab_Zodiac_Reduction / card.ability.extra.mod
        G.GAME.Ortalab_zodiac_temp_level_mod = G.GAME.Ortalab_zodiac_temp_level_mod / card.ability.extra.mod
    end
})