SMODS.Joker({
	key = "graffiti",
	atlas = "jokers",
	pos = {x = 1,y = 1},
	rarity = 1,
	cost = 5,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	config = {extra = {mult_add = 6}},
	loc_vars = function(self, info_queue, card)
        if card and Ortalab.config.artist_credits then info_queue[#info_queue+1] = {generate_ui = ortalab_artist_tooltip, key = 'flare'} end
        return {vars = {card.ability.extra.mult_add, card.ability.extra.mult_add*G.GAME.current_round.hands_left}}
    end,
    calculate = function (self, card, context) --Graffiti logic
        if context.joker_main then
            if G.GAME.current_round.hands_left > 0 then
                return {
                    message = localize{type='variable',key='a_mult',vars={card.ability.extra.mult_add*G.GAME.current_round.hands_left}},
                    mult_mod = card.ability.extra.mult_add*G.GAME.current_round.hands_left,
                    colour = G.C.MULT
                }
            end
        end
    end
})
