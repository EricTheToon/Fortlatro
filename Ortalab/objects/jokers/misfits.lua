SMODS.Joker({
	key = "misfits",
	atlas = "jokers",
	pos = {x=4,y=11},
	rarity = 3,
	cost = 6,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = false,
	config = {extra = {xmult = 4, count = 4}},
	loc_vars = function(self, info_queue, card)
        if card and Ortalab.config.artist_credits then info_queue[#info_queue+1] = {generate_ui = ortalab_artist_tooltip, key = 'gappie'} end
		return {vars = {card.ability.extra.xmult, card.ability.extra.count}}
	end,
    calculate = function(self, card, context)
        if context.joker_main then
            local suits = {}
            local ranks = {}
            for _, played_card in ipairs(G.play.cards) do
                local suit = played_card.base.suit
                local rank = played_card.base.value
                suits[suit] = suit
                ranks[rank] = rank
            end
            if table.size(suits) == card.ability.extra.count and table.size(ranks) == card.ability.extra.count then
                return {
                    message = localize{type='variable', key='a_xmult', vars={card.ability.extra.xmult}},
                    Xmult_mod = card.ability.extra.xmult, 
                    colour = G.C.RED,
                    card = card
                }
            end
        end
    end
})