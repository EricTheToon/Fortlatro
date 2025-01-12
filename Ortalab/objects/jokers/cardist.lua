SMODS.Joker({
	key = "cardist",
	atlas = "jokers",
	pos = {x=8,y=5},
	rarity = 1,
	cost = 4,
	unlocked = true,
	discovered = false,
	blueprint_compat = false,
	eternal_compat = true,
	perishable_compat = false,
	config = {extra = {hands = 1}},
	loc_vars = function(self, info_queue, card)
        if card and Ortalab.config.artist_credits then info_queue[#info_queue+1] = {generate_ui = ortalab_artist_tooltip, key = 'salad'} end
		return {vars = {card.ability.extra.hands}}
	end,
	add_to_deck = function(self, card, from_debuff)
		G.E_MANAGER:add_event(Event({func = function()
			ease_hands_played(card.ability.extra.hands)
			G.GAME.round_resets.hands = G.GAME.round_resets.hands + card.ability.extra.hands
			return true
        end}))
	end,
	remove_from_deck = function(self, card, from_debuff)
		G.E_MANAGER:add_event(Event({func = function()
			ease_hands_played(-card.ability.extra.hands)
			G.GAME.round_resets.hands = G.GAME.round_resets.hands - card.ability.extra.hands
			return true
        end}))
	end,
})