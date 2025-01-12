SMODS.Joker({
	key = "scantron",
	atlas = "jokers",
	pos = {x=0,y=11},
	rarity = 1,
	cost = 5,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = false,
	config = {extra = {chance = 3, denom = 4, repetitions = 1}},
	loc_vars = function(self, info_queue, card)
        if card and Ortalab.config.artist_credits then info_queue[#info_queue+1] = {generate_ui = ortalab_artist_tooltip, key = 'gappie'} end
		return {vars = {math.max(G.GAME.probabilities.normal, 1) * card.ability.extra.chance, card.ability.extra.denom / math.min(G.GAME.probabilities.normal, 1), card.ability.extra.repetitions}}
	end,
	calculate = function(self, card, context)
        if context.cardarea == G.play and context.repetition then
            if pseudoseed('ortalab_scantron') > (G.GAME.probabilities.normal * card.ability.extra.chance) / card.ability.extra.denom then
                return {
                    message = localize('k_again_ex'),
                    repetitions = card.ability.extra.repetitions,
                    card = card
                }
            end
        end
        
    end
})