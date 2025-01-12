SMODS.Joker({
	key = "artist_proof",
	atlas = "jokers",
	pos = {x=6,y=1},
	rarity = 2,
	cost = 6,
	unlocked = true,
	discovered = false,
	blueprint_compat = false,
	eternal_compat = true,
	perishable_compat = false,
	config = {extra = {negative = 10, positive = 25}},
	loc_vars = function(self, info_queue, card)
        if card and Ortalab.config.artist_credits then info_queue[#info_queue+1] = {generate_ui = ortalab_artist_tooltip, key = 'gappie'} end
		return {vars = {card.ability.extra.negative, card.ability.extra.positive}}
	end,
	calculate = function(self, card, context) --Beyond The Mask Logic
        if context.setting_blind and not context.blueprint then
            local amount = pseudorandom(pseudoseed('ortalab_artist_proof'), -card.ability.extra.negative, card.ability.extra.positive)
            local message = amount < 0 and '-' or ''
            message = message .. localize('$') .. math.abs(amount)
            card_eval_status_text(card, 'extra', nil, nil, nil, {message = message, colour = amount > 0 and G.C.MONEY or G.C.RED})
            ease_dollars(amount)
        end
    end
})