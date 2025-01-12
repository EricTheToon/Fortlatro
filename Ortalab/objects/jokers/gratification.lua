SMODS.Joker({
	key = "gratification",
	atlas = "jokers",
	pos = {x = 3,y = 2},
	rarity = 1,
	cost = 5,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	config = {extra = 1},
	loc_vars = function(self, info_queue, card)
        if card and Ortalab.config.artist_credits then info_queue[#info_queue+1] = {generate_ui = ortalab_artist_tooltip, key = 'flare'} end
        return {vars = {card.ability.extra}}
    end,
    calculate = function(self, card, context) --Instant Gratification logic
        if context.discard and context.other_card == context.full_hand[#context.full_hand] then
            G.E_MANAGER:add_event(Event({
                func = function()
                    ease_dollars(card.ability.extra)
                    card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = localize('$')..card.ability.extra,colour = G.C.MONEY, delay = 0.45})
                    return true
                end}))
            return
        end
    end
})