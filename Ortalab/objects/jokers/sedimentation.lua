SMODS.Joker({
	key = "sedimentation",
	atlas = "jokers",
	pos = {x = 3, y = 5},
	rarity = 2,
	cost = 6,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	config = {extra = {mult_per_card = 4}},
	loc_vars = function(self, info_queue, card)
        if card and Ortalab.config.artist_credits then info_queue[#info_queue+1] = {generate_ui = ortalab_artist_tooltip, key = 'gappie'} end
        return {vars = {card.ability.extra.mult_per_card, math.max(0,card.ability.extra.mult_per_card*(G.playing_cards and (#G.playing_cards - G.GAME.starting_deck_size) or 0)), G.GAME.starting_deck_size}}
    end,
    calculate = function(self, card, context) --Sedimentation Logic
        if context.joker_main and (#G.playing_cards - G.GAME.starting_deck_size) > 0 then
            return {
                message = localize{type='variable',key='a_mult',vars={card.ability.extra.mult_per_card*(#G.playing_cards - G.GAME.starting_deck_size)}},
                mult_mod = card.ability.extra.mult_per_card*(#G.playing_cards - G.GAME.starting_deck_size), 
                colour = G.C.MULT
            }
        end
    end
})