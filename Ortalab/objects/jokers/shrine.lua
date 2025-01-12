SMODS.Joker({
	key = "shrine",
	atlas = "jokers",
	pos = {x = 6, y = 3},
	rarity = 2,
	cost = 8,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = false,
	yes_pool_flag = 'shady_trading_redeemed',
	config = {extra = {xmult = 1, xmult_add = 0.25}},
	loc_vars = function(self, info_queue, card)
        if card and Ortalab.config.artist_credits then info_queue[#info_queue+1] = {generate_ui = ortalab_artist_tooltip, key = 'kosze'} end
        return {vars = {card.ability.extra.xmult_add, card.ability.extra.xmult}}
    end,
    calculate = function(self, card, context) --Shrine Logic
        if context.using_consumeable and not context.blueprint and context.consumeable.ability.set == 'Spectral' then
            card.ability.extra.xmult = card.ability.extra.xmult + card.ability.extra.xmult_add
                G.E_MANAGER:add_event(Event({
                    func = function() card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize{type='variable',key='a_xmult',vars={card.ability.extra.xmult}}}); return true
                    end}))
        end
        if context.joker_main and card.ability.extra.xmult > 1 then
            return {
                message = localize{type='variable',key='a_xmult',vars={card.ability.extra.xmult}},
                Xmult_mod = card.ability.extra.xmult
            }
        end
    end    
})
