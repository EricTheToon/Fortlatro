SMODS.Joker({
	key = "bowling_ball",
	atlas = "jokers",
	config = {},
	pos = {x = 5, y = 1},
	rarity = 1,
	cost = 6,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
    loc_vars = function(self, info_queue, card)
        if card and Ortalab.config.artist_credits then info_queue[#info_queue+1] = {generate_ui = ortalab_artist_tooltip, key = 'flare'} end
    end,
	calculate = function (self, card, context)
        if context.joker_main and #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
            local has_10 = false
            for k, v in ipairs(G.hand.cards) do
                if v:get_id() == 10 then has_10 = true end
            end
            if has_10 then
                G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
                G.E_MANAGER:add_event(Event({
                    trigger = 'before',
                    delay = 0.0,
                    func = (function()
                            local card = create_card('Zodiac',G.consumeables, nil, nil, nil, nil, pseudorandom_element(zodiac_pool(), pseudoseed('ortalab_bowling_ball')), 'bowling_ball')
                            card:add_to_deck()
                            G.consumeables:emplace(card)
                            G.GAME.consumeable_buffer = G.GAME.consumeable_buffer - 1
                        return true
                    end)}))
                return {
                    message = localize('ortalab_zodiac_add'),
                    colour = G.C.SET.Zodiac,
                    card = card
                }
            end
        end
    end
})