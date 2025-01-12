SMODS.Joker({
	key = "stargazing",
	atlas = "jokers",
	pos = {x = 8, y = 13},
	rarity = 2,
	cost = 5,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	config = {extra = {xmult = 1, gain = 0.2}},
    loc_vars = function(self, info_queue, card)
        if card and Ortalab.config.artist_credits then info_queue[#info_queue+1] = {generate_ui = ortalab_artist_tooltip, key = 'gappie'} end
        return {vars = {card.ability.extra.gain, card.ability.extra.xmult}}
    end,
	calculate = function(self, card, context)
        if context.joker_main and card.ability.extra.xmult > 1 then
            return {
                message = localize{type='variable',key='a_xmult',vars={card.ability.extra.xmult}},
                Xmult_mod = card.ability.extra.xmult
            }
        end
    end
})