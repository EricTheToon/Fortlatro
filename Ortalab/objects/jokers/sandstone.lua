SMODS.Joker({
	key = "sandstone",
	atlas = "jokers",
	pos = {x = 5, y = 9},
	rarity = 2,
	cost = 6,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
    enhancement_gate = 'm_ortalab_sand',
	config = {extra = {xmult = 1, gain = 0.1}},
	loc_vars = function(self, info_queue, card)
        if card and Ortalab.config.artist_credits then info_queue[#info_queue+1] = {generate_ui = ortalab_artist_tooltip, key = 'gappie'} end
        info_queue[#info_queue + 1] = G.P_CENTERS['m_ortalab_sand']
        return {vars = {card.ability.extra.xmult, card.ability.extra.gain}}
    end,
    calculate = function(self, card, context)
        if context.before then
            for _, scoring_card in ipairs(context.scoring_hand) do
                if scoring_card.config.center == G.P_CENTERS['m_'..Ortalab.prefix..'_sand'] and not scoring_card.debuff then
                    card.ability.extra.xmult = card.ability.extra.xmult + card.ability.extra.gain
                    G.E_MANAGER:add_event(Event({func = function() scoring_card:juice_up(); return true; end}))
                    card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('ortalab_joker_miles')})
                end
            end
        end
        if context.joker_main then
            return {
                message = localize{type='variable',key='a_xmult',vars={card.ability.extra.xmult}},
                Xmult_mod = card.ability.extra.xmult
            }
        end
    end
})