SMODS.Joker({
	key = "knitted_sweater",
	atlas = "jokers",
	pos = {x=2,y=11},
	rarity = 1,
	cost = 4,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = false,
	config = {extra = {chips = 0, chip_gain = 15}},
	loc_vars = function(self, info_queue, card)
        if card and Ortalab.config.artist_credits then info_queue[#info_queue+1] = {generate_ui = ortalab_artist_tooltip, key = 'gappie'} end
		return {vars = {card.ability.extra.chip_gain, card.ability.extra.chips, localize('Three of a Kind', 'poker_hands')}}
	end,
	calculate = function(self, card, context)
        if context.before and next(context.poker_hands['Three of a Kind']) then
            card.ability.extra.chips = card.ability.extra.chips + card.ability.extra.chip_gain
            return {
                message = localize('k_upgrade_ex'),
                colour = G.C.BLUE,
                card = card
            }
        end
        if context.joker_main and card.ability.extra.chips > 0 then
            return {
                message = localize{type='variable', key='a_chips', vars={card.ability.extra.chips}},
                chip_mod = card.ability.extra.chips, 
                colour = G.C.CHIPS,
                card = card
            }
        end
    end
})