SMODS.Joker({
	key = "roscharch",
    atlas = "jokers",
	pos = {x = 6, y = 6},
	rarity = 1,
	cost = 5,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	config = {extra = {chips = 25, mult = 5}},
	loc_vars = function(self, info_queue, card)
        if card and Ortalab.config.artist_credits then info_queue[#info_queue+1] = {generate_ui = ortalab_artist_tooltip, key = 'flare'} end
        return {vars = {card.ability.extra.chips, card.ability.extra.mult}}
    end,
    calculate = function(self, card, context) --Roscharch Logic
        if context.individual and context.cardarea == G.play and (context.other_card:get_id() == 5 or context.other_card:get_id() == 2) then
            if pseudorandom('roscharch_test') <= 0.5 then
                return {
                    mult = card.ability.extra.mult,
                    card = card
                }
            else
                return {
                    chips = card.ability.extra.chips,
                    card = card
                }
            end
        end
    end
})