SMODS.Joker({
	key = "pitch_mitch",
	atlas = "jokers",
	pos = {x = 7, y = 2},
	rarity = 1,
	cost = 4,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	config = {extra = {chips = 20}},
	loc_vars = function(self, info_queue, card)
        if card and Ortalab.config.artist_credits then info_queue[#info_queue+1] = {generate_ui = ortalab_artist_tooltip, key = 'flare'} end
        return {vars = {card.ability.extra.chips}}
    end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play and (context.other_card:is_suit('Spades') or context.other_card:is_suit('Clubs')) then
            return {
                chips = card.ability.extra.chips,
                card = card
            }
        end
    end
})