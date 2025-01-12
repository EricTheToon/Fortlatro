SMODS.Joker({
	key = "frowny_face",
	atlas = "jokers",
	pos = {x = 7, y = 6},
	rarity = 1,
	cost = 5,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	config = {extra = {mult = 4}},
    loc_vars = function(self, info_queue, card)
        if card and Ortalab.config.artist_credits then info_queue[#info_queue+1] = {generate_ui = ortalab_artist_tooltip, key = 'golddisco'} end
        return {vars = {card.ability.extra.mult}}
    end,
	calculate = function(self, card, context) --Frowny Face Logic
        if context.individual and context.cardarea == G.play and not (context.other_card:is_face()) then
            return {
                mult = card.ability.extra.mult,
                card = card
            }
        end
    end
})