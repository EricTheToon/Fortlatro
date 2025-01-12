SMODS.Joker({
	name = "Mint Condition",
	key = "mint_condition",
	atlas = "jokers",
	pos = {x = 0, y = 6},
	rarity = 3,
	cost = 8,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	config = {extra = {Xmult = 1.5}},
	loc_vars = function(self, info_queue, card)
        if card and Ortalab.config.artist_credits then info_queue[#info_queue+1] = {generate_ui = ortalab_artist_tooltip, key = 'hat'} end
        return {vars = {card.ability.extra.Xmult}}
    end,
})

local ease_hook = ease_dollars
function ease_dollars(mod, instant)
    ease_hook(mod, instant)
    if G.GAME.Ortalab_Scoring_Active and mod > 0 then
        local mint_jokers = SMODS.find_card('j_ortalab_mint_condition')
        for _, card in pairs(mint_jokers) do        
            SMODS.eval_this(card, {
                message = localize({type = 'variable', key = 'a_xmult', vars = {card.ability.extra.Xmult}}),
                Xmult_mod = card.ability.extra.Xmult})
        end
    end
end