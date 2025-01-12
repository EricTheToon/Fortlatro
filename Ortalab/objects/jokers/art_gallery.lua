SMODS.Joker({
	key = "art_gallery",
	atlas = "jokers",
	pos = {x=2,y=2},
	rarity = 1,
	cost = 6,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	config = {extra = {chips_add = 20}},
    loc_vars = function(self, info_queue, card)
        if card and Ortalab.config.artist_credits then info_queue[#info_queue+1] = {generate_ui = ortalab_artist_tooltip, key = 'flare'} end
		local total_cards = (G.jokers and #G.jokers.cards or 0) + (G.consumeables and #G.consumeables.cards or 0)
		return {vars = {card.ability.extra.chips_add, total_cards*card.ability.extra.chips_add}}
    end,
	calculate = function(self, card, context)
        if context.joker_main then
            local total_cards = #G.jokers.cards + #G.consumeables.cards
            return {
                message = localize{type='variable',key='a_chips',vars={total_cards*card.ability.extra.chips_add}},
                chip_mod = total_cards*card.ability.extra.chips_add, 
                colour = G.C.CHIPS
            }
        end
    end
})