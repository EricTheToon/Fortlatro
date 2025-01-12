SMODS.Joker({
	key = "pin_point",
	atlas = "jokers",
	pos = {x = 5, y = 13},
	rarity = 2,
	cost = 5,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	config = {},
    loc_vars = function(self, info_queue, card)
        if card and Ortalab.config.artist_credits then info_queue[#info_queue+1] = {generate_ui = ortalab_artist_tooltip, key = 'gappie'} end
    end,
	calculate = function(self, card, context)
        if context.end_of_round and not context.repetition and not context.individual and #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
            if G.GAME.last_hand_played then
                local zodiac_key = zodiac_from_hand(G.GAME.last_hand_played)
                local new_zodiac = create_card("Zodiac", G.consumeables, nil, nil, true,  true, zodiac_key)
                new_zodiac:add_to_deck()
                G.consumeables:emplace(new_zodiac)
                new_zodiac:juice_up()
                card:juice_up()
            end
        end
    end
})