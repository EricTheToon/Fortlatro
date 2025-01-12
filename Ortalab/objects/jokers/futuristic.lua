SMODS.Joker({
	key = "futuristic",
	atlas = "jokers",
	pos = {x=4,y=6},
	rarity = 3,
	cost = 6,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = false,
	config = {extra = {xmult = 1.75, rank = nil}},
	loc_vars = function(self, info_queue, card)
        if card and Ortalab.config.artist_credits then info_queue[#info_queue+1] = {generate_ui = ortalab_artist_tooltip, key = 'kosze'} end
		return {vars = {card.ability.extra.xmult, card.ability.extra.rank and localize(card.ability.extra.rank, 'ranks') or localize('ortalab_rank'), localize('Straight', 'poker_hands')}}
	end,
    set_ability = function(self, card)
        if G.playing_cards and #G.playing_cards > 0 then
            card.ability.extra.rank = Ortalab.rank_from_deck('ortalab_futuristic')
        end
    end,
	calculate = function(self, card, context)
        if context.setting_blind then
            card.ability.extra.rank = Ortalab.rank_from_deck('ortalab_futuristic')
            card:juice_up()
        end
        if context.cardarea == G.play and context.individual and next(context.poker_hands['Straight']) and Ortalab.hand_contains_rank(context.scoring_hand, card.ability.extra.rank) then
            return {
                x_mult = card.ability.extra.xmult,
                card = card
            }
        end
    end
})