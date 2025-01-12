SMODS.Joker({
	key = "spectator",
	atlas = "jokers",
	pos = {x=9,y=10},
	rarity = 2,
	cost = 6,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = false,
	config = {extra = {xmult = 2}},
	loc_vars = function(self, info_queue, card)
        if card and Ortalab.config.artist_credits then info_queue[#info_queue+1] = {generate_ui = ortalab_artist_tooltip, key = 'gappie'} end
		return {vars = {card.ability.extra.xmult}}
	end,
	calculate = function(self, card, context)
        if context.joker_main and G.GAME.current_round.hands_played == 0 then
            return {
                message = localize{type='variable', key='a_xmult', vars={card.ability.extra.xmult}},
                Xmult_mod = card.ability.extra.xmult, 
                colour = G.C.RED,
                card = card
            }
        end
    end
})