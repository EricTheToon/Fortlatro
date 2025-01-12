SMODS.Joker({
	key = "collatz",
	atlas = "jokers",
	pos = {x = 0, y = 2},
	rarity = 2,
	cost = 8,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	config = {extra = {x_mult = 3, x_mult_reduction = 0.5, current_chips = 0}},
    loc_vars = function(self, info_queue, card)
		if card and Ortalab.config.artist_credits then info_queue[#info_queue+1] = {generate_ui = ortalab_artist_tooltip, key = 'flowwey'} end
        return {vars = {card.ability.extra.x_mult, card.ability.extra.x_mult_reduction}}
    end,
    calculate = function(self, card, context) --Collatz Logic
        if context.joker_main then
            if math.floor(card.ability.extra.current_chips / 2) * 2 == card.ability.extra.current_chips then
                return {
                    message = localize{type='variable',key='a_xmult',vars={card.ability.extra.x_mult}},
                    Xmult_mod = card.ability.extra.x_mult
                }
            else
                return {
                    message = localize{type='variable',key='a_xmult',vars={card.ability.extra.x_mult_reduction}},
                    Xmult_mod = card.ability.extra.x_mult_reduction
                }
            end
        end
    end
})

local mod_chips_ref = mod_chips
function mod_chips(_chips) --Required for Collatz
	if next(SMODS.find_card("j_olab_collatz")) then
		local curr_chips = _chips
		for k, v in pairs(G.jokers.cards) do
			if v.ability.name == 'Collatz Conjecture' then
				v.ability.extra.current_chips = curr_chips
			end
		end
	end
	return mod_chips_ref(_chips)
end