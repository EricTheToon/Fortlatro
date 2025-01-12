SMODS.Joker({
	key = "scared_face",
	atlas = "jokers",
	pos = {x = 1, y = 2},
	rarity = 1,
	cost = 5,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
    config = {extra = {chips = 30}},
	loc_vars = function(self, info_queue, card)
        if card and Ortalab.config.artist_credits then info_queue[#info_queue+1] = {generate_ui = ortalab_artist_tooltip, key = 'golddisco'} end
        return {vars = {card.ability.extra.chips}}
    end,
    calculate = function(self, card, context) --Scared Face Logic
        if context.individual and context.cardarea == G.play and not context.other_card:is_face() then
            return {
                chips = card.ability.extra.chips,
                card = card
            }
        end
    end    
})