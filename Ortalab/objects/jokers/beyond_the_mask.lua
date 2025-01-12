SMODS.Joker({
	key = "beyond_the_mask",
	atlas = "jokers",
	pos = {x = 0, y = 5},
	rarity = 2,
	cost = 8,
	unlocked = true,
	discovered = false,
	blueprint_compat = false,
	eternal_compat = true,
	perishable_compat = false,
	config = {extra = {dollars = 1, dollars_add = 1}},
	calc_dollar_bonus = function(self, card)
		return card.ability.extra.dollars
	end,
    loc_vars = function(self, info_queue, card)
        if card and Ortalab.config.artist_credits then info_queue[#info_queue+1] = {generate_ui = ortalab_artist_tooltip, key = 'flare'} end
        info_queue[#info_queue+1] = G.P_CENTERS.m_ortalab_iou
        return {vars = {card.ability.extra.dollars, card.ability.extra.dollars_add}}
    end,
	calculate = function(self, card, context) --Beyond The Mask Logic
        if context.discard and not context.blueprint and not context.other_card.debuff and context.other_card.config.center_key == 'm_ortalab_iou' then
            card.ability.extra.dollars = card.ability.extra.dollars + card.ability.extra.dollars_add
            return {
                message = localize('k_upgrade_ex'),
                colour = G.C.MONEY,
                delay = 0.45, 
                remove = true,
                card = card
            }
        end
    end
})