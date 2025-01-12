SMODS.Joker({
	key = "pictographer",
	atlas = "jokers",
	pos = {x=3,y=10},
	rarity = 2,
	cost = 5,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = false,
	config = {extra = {money = 30, count = 4, current = 0}},
	loc_vars = function(self, info_queue, card)
        if card and Ortalab.config.artist_credits then info_queue[#info_queue+1] = {generate_ui = ortalab_artist_tooltip, key = 'gappie'} end
		return {vars = {card.ability.extra.money, card.ability.extra.count, card.ability.extra.current}}
	end,
	calculate = function(self, card, context)
        if context.using_consumeable and context.consumeable.ability.set == 'Loteria' then
            card.ability.extra.current = card.ability.extra.current + 1
            card_eval_status_text(card, 'extra', nil, nil, nil, {message = card.ability.extra.current..'/'..card.ability.extra.count})
            if card.ability.extra.current == card.ability.extra.count then
                card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('$')..card.ability.extra.money, colour = G.C.GOLD})
                ease_dollars(card.ability.extra.money)
                card.ability.extra.current = 0
                card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('ortalab_joker_miles_reset')})
            end
        end
        if context.end_of_round and not context.repetition and not context.individual then
            card.ability.extra.current = 0
            card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('ortalab_joker_miles_reset')})
        end
    end
})