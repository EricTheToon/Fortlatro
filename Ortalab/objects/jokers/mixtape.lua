SMODS.Joker({
	key = "mixtape",
	atlas = "jokers",
	pos = {x = 1, y = 7},
	rarity = 2,
	cost = 6,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	config = {extra = {xmult = 1.5, gain = 0.2}},
    loc_vars = function(self, info_queue, card)
        if card and Ortalab.config.artist_credits then info_queue[#info_queue+1] = {generate_ui = ortalab_artist_tooltip, key = 'flare'} end
        return {vars = {card.ability.extra.gain, card.ability.extra.xmult}}
    end,
	calculate = function (self, card, context)
        if context.joker_main then
            return {
                message = localize{type='variable',key='a_xmult',vars={card.ability.extra.xmult}},
                Xmult_mod = card.ability.extra.xmult,
                card = card
            }
        end
        if context.end_of_round and not context.repetition and not context.individual and not context.blueprint and G.GAME.current_round.hands_played == 1 then
            card.ability.extra.xmult = card.ability.extra.xmult + card.ability.extra.gain
            card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('k_upgrade_ex')})
        end
    end
})