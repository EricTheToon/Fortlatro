SMODS.Joker({
	key = "mysterium",
	atlas = "jokers",
	pos = {x = 2, y = 8},
	rarity = 3,
	cost = 8,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	config = {extra = {x_mult = 4, secret_hand_list = {}}},
	loc_vars = function(self, info_queue, card)
        if card and Ortalab.config.artist_credits then info_queue[#info_queue+1] = {generate_ui = ortalab_artist_tooltip, key = 'flowwey'} end
        return {vars = {card.ability.extra.x_mult}}
    end,
    calculate = function(self, card, context) --The Mysterium Logic
        if context.joker_main then
            if table.contains(card.ability.extra.secret_hand_list, context.scoring_name) then
                return {
                    message = localize{type='variable',key='a_xmult',vars={card.ability.extra.x_mult}},
                    Xmult_mod = card.ability.extra.x_mult
                }
            end
        end
    end
})