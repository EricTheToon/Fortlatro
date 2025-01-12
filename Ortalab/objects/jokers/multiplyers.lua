SMODS.Joker({
	key = "multiplyers",
	atlas = "jokers",
	pos = {x = 9, y = 6},
	rarity = 2,
	cost = 6,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
    config = {extra = {repetitions = 1}},
	loc_vars = function(self, info_queue, card)
        if card and Ortalab.config.artist_credits then info_queue[#info_queue+1] = {generate_ui = ortalab_artist_tooltip, key = 'gappie'} end
        return {vars = {card.ability.extra.repetitions}}
    end,
    calculate = function(self, card, context)
        if context.repetition and context.cardarea == G.play and not context.other_card:is_face() and not context.other_card.config.center.always_scores then
            return {
                repetitions = card.ability.extra.repetitions,
                message = localize('k_again_ex'),
                card = card
            }
        end
    end
})