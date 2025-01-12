SMODS.Joker({
	key = "triangle",
	atlas = "jokers",
	pos = {x = 3, y = 4},
	rarity = 1,
	cost = 5,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = false,
	config = {extra = {mult_add = 3, mult_total = 0}},
	loc_vars = function(self, info_queue, card)
        if card and Ortalab.config.artist_credits then info_queue[#info_queue+1] = {generate_ui = ortalab_artist_tooltip, key = 'salad'} end
        return {vars = {card.ability.extra.mult_add, card.ability.extra.mult_total}}
    end,
    calculate = function(self, card, context) --Triangle Joker Logic
        if context.cardarea == G.jokers and context.before and #context.full_hand == 3 and not context.blueprint then
            card.ability.extra.mult_total = card.ability.extra.mult_total + card.ability.extra.mult_add
            return {
                message = localize('k_upgrade_ex'),
                colour = G.C.MULT,
                card = card
            }
        end
        if context.joker_main then
            return {
                message = localize{type='variable',key='a_mult',vars={card.ability.extra.mult_total}},
                mult_mod = card.ability.extra.mult_total
            }
        end
    end
})