SMODS.Joker({
	key = "dropout",
	atlas = "jokers",
	pos = {x=4,y=13},
	rarity = 1,
	cost = 4,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = false,
	config = {extra = {rank = 2, chips = 30, mult = 3}},
	loc_vars = function(self, info_queue, card)
        if card and Ortalab.config.artist_credits then info_queue[#info_queue+1] = {generate_ui = ortalab_artist_tooltip, key = 'crimson'} end
		return {vars = {localize(tostring(card.ability.extra.rank), 'ranks'), card.ability.extra.chips, card.ability.extra.mult}}
	end,
	calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play and context.other_card.base.id == card.ability.extra.rank then
            return {
                chips = card.ability.extra.chips,
                mult = card.ability.extra.mult,
                card = card
            }
        end
    end
})