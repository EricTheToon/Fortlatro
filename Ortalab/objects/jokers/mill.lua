SMODS.Joker({
	key = "mill",
	atlas = "jokers",
	pos = {x=4,y=10},
	rarity = 2,
	cost = 6,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = false,
	config = {extra = {xmult = 1, gain = 0.1}},
	loc_vars = function(self, info_queue, card)
        if card and Ortalab.config.artist_credits then info_queue[#info_queue+1] = {generate_ui = ortalab_artist_tooltip, key = 'kosze'} end
		return {vars = {card.ability.extra.xmult, card.ability.extra.gain}}
	end,
	calculate = function(self, card, context)
		if context.joker_main then
            return {
                message = localize{type='variable',key='a_xmult',vars={card.ability.extra.xmult}},
                Xmult_mod = card.ability.extra.xmult
            }
        end
    end
})

local card_change_suit = Card.change_suit
function Card:change_suit(new_suit)
    local change = self.base.suit ~= new_suit
    card_change_suit(self, new_suit)
    if not change then return end
    local scaling_joker = SMODS.find_card('j_ortalab_mill')
    for _, card in pairs(scaling_joker) do        
        card.ability.extra.xmult = card.ability.extra.xmult + card.ability.extra.gain
        card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize{type = 'variable', key = 'a_xmult', vars = {card.ability.extra.xmult}}})
    end
end

local smods_change_base = SMODS.change_base
function SMODS.change_base(card, suit, rank)
    local change = suit and card.base.suit ~= suit
    local card = smods_change_base(card, suit, rank)
    if change and not Ortalab.harp_usage then
        local scaling_joker = SMODS.find_card('j_ortalab_mill')
        for _, card in pairs(scaling_joker) do        
            card.ability.extra.xmult = card.ability.extra.xmult + card.ability.extra.gain
            card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize{type = 'variable', key = 'a_xmult', vars = {card.ability.extra.xmult}}})
        end
    end
    return card
end