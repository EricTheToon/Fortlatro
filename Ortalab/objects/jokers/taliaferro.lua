SMODS.Joker({
	key = "taliaferro",
	atlas = "jokers",
	pos = {x = 5, y = 2},
	rarity = 1,
	cost = 4,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	eternal_compat = false,
	perishable_compat = true,
	no_pool_flag = 'taliaferro_extinct',
	config = {extra = {chips = 80, odds = 4}},
	loc_vars = function(self, info_queue, card)
        if card and Ortalab.config.artist_credits then info_queue[#info_queue+1] = {generate_ui = ortalab_artist_tooltip, key = 'flare'} end
        if card and Ortalab.config.artist_credits then info_queue[#info_queue+1] = {generate_ui = ortalab_artist_tooltip, key = 'grassy'} end
        return {vars = {card.ability.extra.chips, math.max(G.GAME.probabilities.normal, 1), card.ability.extra.odds / math.min(G.GAME.probabilities.normal, 1)}}
    end,
    calculate = function(self, card, context) --Taliaferro Logic NOTE: MUST ADD POOL FLAGS
        if context.end_of_round and not context.blueprint and not context.repetition and not context.individual then
            if pseudorandom('taliaferro') < G.GAME.probabilities.normal/card.ability.extra.odds then
                Ortalab.remove_joker(card)
                G.GAME.pool_flags.taliaferro_extinct = true
                return {
                    message = localize('k_extinct_ex')
                }
            else
                return {
                    message = localize('k_safe_ex')
                }
            end
        end
        if context.joker_main then
            return {
                message = localize{type='variable',key='a_chips',vars={card.ability.extra.chips}},
                chip_mod = card.ability.extra.chips, 
                colour = G.C.CHIPS
            }
        end
    end
})