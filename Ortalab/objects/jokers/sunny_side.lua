SMODS.Joker({
	key = "sunnyside",
	atlas = "jokers",
	pos = {x = 1, y = 3},
	rarity = 1,
	cost = 4,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	config = {extra = {money = 4}},
	loc_vars = function(self, info_queue, card)
        if card and Ortalab.config.artist_credits then info_queue[#info_queue+1] = {generate_ui = ortalab_artist_tooltip, key = 'eremel'} end
        return {vars = {card.ability.extra.money}}
    end,
    calculate = function(self, card, context) --The Mysterium Logic
        if context.setting_blind and not card.getting_sliced then
            if #G.consumeables.cards > 0 then
                local consumable = G.consumeables.cards[1]
                consumable.ability.extra_value = consumable.ability.extra_value + card.ability.extra.money
                consumable:set_cost(card.ability.extra.money)
                G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function() card:juice_up(); return true; end}))
                card_eval_status_text(consumable, 'extra', nil, nil, nil, {
                    message = localize('k_val_up'),
                    colour = G.C.MONEY,
                })
            end
        end
    end
})