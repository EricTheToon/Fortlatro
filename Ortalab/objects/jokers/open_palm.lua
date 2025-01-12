SMODS.Joker({
	key = "open_palm",
	atlas = "jokers",
	pos = {x=8,y=1},
	rarity = 1,
	cost = 4,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = false,
	config = {extra = {base_chips = 100, modifier = 8}},
	loc_vars = function(self, info_queue, card)
        if card and Ortalab.config.artist_credits then info_queue[#info_queue+1] = {generate_ui = ortalab_artist_tooltip, key = 'alex'} end
		return {vars = {card.ability.extra.base_chips, card.ability.extra.modifier}}
	end,
	calculate = function(self, card, context)
        if context.individual and context.cardarea == G.hand then
            local temp_Chips, temp_ID = 0, 0
            local open_palm_card = nil
            for i=1, #G.hand.cards do
                if temp_ID <= G.hand.cards[i].base.id and G.hand.cards[i].ability.effect ~= 'Stone Card' and not G.hand.cards[i].config.center.replace_base_card then temp_Chips = G.hand.cards[i].base.nominal; temp_ID = G.hand.cards[i].base.id; open_palm_card = G.hand.cards[i] end
            end
            if open_palm_card == context.other_card then 
                if context.other_card.debuff then
                    return {
                        message = localize('k_debuffed'),
                        colour = G.C.BLUE,
                        card = card,
                    }
                else
                    return {
                        chips = card.ability.extra.base_chips - (temp_Chips*card.ability.extra.modifier),
                        card = card,
                    }
                end
            end
        end
    end
})