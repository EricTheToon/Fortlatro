SMODS.Joker({
	key = "fools_gold",
	atlas = "jokers",
	pos = {x = 2, y = 7},
	rarity = 2,
	cost = 4,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	config = {extra = {money = 2, suit = 'Diamonds', chance = 2}},
	loc_vars = function(self, info_queue, card)
        if card and Ortalab.config.artist_credits then info_queue[#info_queue+1] = {generate_ui = ortalab_artist_tooltip, key = 'kosze'} end
        return {vars = {math.max(G.GAME.probabilities.normal, 1), card.ability.extra.chance / math.min(G.GAME.probabilities.normal, 1), card.ability.extra.money, localize(card.ability.extra.suit, 'suits_singular'), colours = {G.C.SUITS[card.ability.extra.suit]}}}
    end,
    calculate = function(self, card, context)
        if not context.end_of_round and context.individual and context.cardarea == G.hand and context.other_card:is_suit(card.ability.extra.suit) then
            if pseudorandom(pseudoseed('fools_gold')) < G.GAME.probabilities.normal / card.ability.extra.chance then
				return {
					card = card,
					dollars = card.ability.extra.money
				}
			end
			return {
				card = card,
				message = localize('k_nope_ex')
			}
        end
    end
})