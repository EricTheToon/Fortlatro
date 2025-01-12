SMODS.Joker({
	key = "head_honcho",
	atlas = "jokers",
	pos = {x=0,y=10},
	rarity = 3,
	cost = 6,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = false,
	config = {extra = {cards = 1, money_loss = 2}},
	loc_vars = function(self, info_queue, card)
        if card and Ortalab.config.artist_credits then info_queue[#info_queue+1] = {generate_ui = ortalab_artist_tooltip, key = 'crimson'} end
		return {vars = {card.ability.extra.money_loss}}
	end,
	calculate = function(self, card, context)
        if context.joker_main and #G.consumeables.cards < G.consumeables.config.card_limit then
            card_eval_status_text(card, 'extra', nil, nil, nil, {message = '-'..localize('$')..card.ability.extra.money_loss, colour = G.C.RED})
            ease_dollars(-card.ability.extra.money_loss)
            G.E_MANAGER:add_event(Event({func = function()
                local card = SMODS.create_card({set = 'Loteria', key_append = 'loteria_joker'})
                card:add_to_deck()
                G.consumeables:emplace(card)
                card:juice_up(0.3, 0.5)
                return true
            end}))
        end
    end
})