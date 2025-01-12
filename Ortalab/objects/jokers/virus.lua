SMODS.Joker({
	key = "virus",
	atlas = "jokers",
	pos = {x = 4, y = 3},
	rarity = 3,
	cost = 10,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
    config = {extra = {duped_cards = 2, joker_triggered = false}},
	loc_vars = function(self, info_queue, card)
        if card and Ortalab.config.artist_credits then info_queue[#info_queue+1] = {generate_ui = ortalab_artist_tooltip, key = 'golddisco'} end
        return {vars = {card.ability.extra.duped_cards}}
    end,
    calculate = function(self, card, context) --Virus Logic
        if context.first_hand_drawn and not context.blueprint then
            local eval = function() return G.GAME.current_round.hands_played == 0 end
            juice_card_until(card, eval, true)
        end
        if context.destroying_card and not context.blueprint and card.ability.extra.joker_triggered == true then
            card.ability.extra.joker_triggered = false
            return true
        end
        if context.cardarea == G.jokers and context.before and G.GAME.current_round.hands_played == 0 then
            if #context.full_hand == 1 then
                local card_to_dupe = context.full_hand[1]
                local hand = {}
                for i=1, #G.hand.cards do
                    if not (G.hand.cards[i]:get_id() == card_to_dupe:get_id() and G.hand.cards[i].ability.name == card_to_dupe.ability.name and G.hand.cards[i].edition == card_to_dupe.edition) and G.hand.cards[i].infected ~= true then hand[#hand+1] = G.hand.cards[i] end
                end
                card.ability.extra.joker_triggered = true
                local infected_card_1
                local infected_card_2
                if hand[1] ~= nil then 
                    infected_card_1 = pseudorandom_element(hand, pseudoseed('virus'))
                    hand[infected_card_1] = nil
                    infected_card_1.infected = true
                    infected_card_1:flip()
                    if hand[1] ~= nil then 
                        infected_card_2 = pseudorandom_element(hand, pseudoseed('virus'))
                        hand[infected_card_2] = nil
                        infected_card_2.infected = true
                        infected_card_2:flip()
                    end
                    if infected_card_1 then
                        G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.15,func = function()
                            if infected_card_2 then
                                copy_card(card_to_dupe, infected_card_2)
                                infected_card_2:flip()
                            end
                            copy_card(card_to_dupe, infected_card_1)
                            infected_card_1:flip()
                            return true 
                            end 
                        }))
                    end
                end
                return {
                    message = localize('ortalab_infect'),
                    colour = G.C.CHIPS,
                    delay = 1, 
                    card = card
                }
            end
        end
    end
})