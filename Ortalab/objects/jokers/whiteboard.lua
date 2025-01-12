SMODS.Joker({
	key = "whiteboard",
	atlas = "jokers",
	pos = {x = 2, y = 3},
	rarity = 2,
	cost = 4,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	config = {extra = {xmult = 3}},
	loc_vars = function(self, info_queue, card)
        if card and Ortalab.config.artist_credits then info_queue[#info_queue+1] = {generate_ui = ortalab_artist_tooltip, key = 'flare'} end
        return {vars = {card.ability.extra.xmult}}
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            for _, card in pairs(G.hand.cards) do
                if not card:is_suit('Hearts') and not card:is_suit('Diamonds') then
                    return
                end
            end
            return {
                Xmult_mod = card.ability.extra.xmult,
                message = localize{type='variable',key='a_xmult',vars={card.ability.extra.xmult}},
            }
        end
    end
})