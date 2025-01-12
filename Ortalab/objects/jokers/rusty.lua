SMODS.Joker({
	key = "rusty",
	atlas = "jokers",
	pos = {x = 0, y = 9},
	rarity = 2,
	cost = 6,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
    enhancement_gate = 'm_ortalab_rusty',
	config = {extra = {xmult = 1, gain = 0.2}},
	loc_vars = function(self, info_queue, card)
        if card and Ortalab.config.artist_credits then info_queue[#info_queue+1] = {generate_ui = ortalab_artist_tooltip, key = 'gappie'} end
        info_queue[#info_queue + 1] = G.P_CENTERS['m_ortalab_rusty']
        local count = G.playing_cards and calculate_rusty_amount() or 0
        return {vars = {card.ability.extra.xmult + (card.ability.extra.gain * count), card.ability.extra.gain}}
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            local count = G.playing_cards and calculate_rusty_amount() or 0
            return {
                message = localize{type='variable',key='a_xmult',vars={card.ability.extra.xmult + (card.ability.extra.gain * count)}},
                Xmult_mod = card.ability.extra.xmult + (card.ability.extra.gain * count)
            }
        end
    end
})

function calculate_rusty_amount()
    local count = 0
    for _, card in ipairs(G.playing_cards) do
        if card.config.center_key == 'm_ortalab_rusty' then
            count = count + 1
        end
    end
    return count
end