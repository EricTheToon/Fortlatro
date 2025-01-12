SMODS.Joker({
	key = "miracle_cure",
	atlas = "jokers",
	pos = {x = 5, y = 3},
	rarity = 1,
	cost = 4,
	unlocked = true,
	discovered = false,
	blueprint_compat = false,
	eternal_compat = true,
	perishable_compat = true,
	config = {extra = {repetitions = 1}},
	loc_vars = function(self, info_queue, card)
        if card and Ortalab.config.artist_credits then info_queue[#info_queue+1] = {generate_ui = ortalab_artist_tooltip, key = 'flare'} end
        -- return {vars = {card.ability.extra.chips, localize(card.ability.extra.suit, 'suits_singular')}}
    end,
    calculate = function(self, card, context)
        if context.before then
            for _, playing_card in pairs(context.scoring_hand) do
                if playing_card.debuff then
                    playing_card.debuff = false
                    playing_card.cured_debuff = true
                    playing_card.cured = true
                    G.E_MANAGER:add_event(Event({trigger = 'immediate', func = function ()
                        playing_card.cured_debuff = false
                        card:juice_up()
                        return true
                    end}))
                    card_eval_status_text(playing_card, 'extra', nil, nil, nil, {message = localize('ortalab_cured')})
                end
            end
        end
        if context.repetition and context.cardarea == G.play and context.other_card.cured then
            context.other_card.cured = false
            return {
                repetitions = card.ability.extra.repetitions,
                message = localize('k_again_ex'),
                card = card
            }
        end
    end
})