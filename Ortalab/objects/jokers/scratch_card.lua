SMODS.Joker({
	key = "scratch_card",
	atlas = "jokers",
	pos = {x = 8, y = 2},
	rarity = 1,
	cost = 4,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	config = {extra = {chance = 3, money = 1}},
	loc_vars = function(self, info_queue, card)
        if card and Ortalab.config.artist_credits then info_queue[#info_queue+1] = {generate_ui = ortalab_artist_tooltip, key = 'kosze'} end
        if card and Ortalab.config.artist_credits then info_queue[#info_queue+1] = {generate_ui = ortalab_artist_tooltip, key = 'salad'} end
        return {vars = {G.GAME.probabilities.normal, card.ability.extra.chance, card.ability.extra.money}}
    end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play and not context.other_card:is_face() and not context.other_card.config.center.always_scores then
            if pseudorandom(pseudoseed('ortalab_scratchcard')) < G.GAME.probabilities.normal / card.ability.extra.chance then
                return {
                    dollars = card.ability.extra.money,
                    card = card
                }
            end
        end
    end
})