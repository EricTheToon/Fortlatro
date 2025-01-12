SMODS.Joker({
	key = "black_friday",
	atlas = "jokers",
	pos = {x = 1, y = 5},
	rarity = 1,
	cost = 5,
	unlocked = true,
	discovered = false,
	blueprint_compat = false,
	eternal_compat = true,
	perishable_compat = true,
    config = {extra = {minus_chips = 40, money_off = 20}},
	loc_vars = function(self, info_queue, card)
        if card and Ortalab.config.artist_credits then info_queue[#info_queue+1] = {generate_ui = ortalab_artist_tooltip, key = 'flare'} end
        return {vars = {card.ability.extra.minus_chips, card.ability.extra.money_off}}
    end,
	add_to_deck = function(self, card, from_debuff)
		G.GAME.discount_percent = G.GAME.discount_percent + card.ability.extra.money_off
		G.E_MANAGER:add_event(Event({func = function()
			for k, v in pairs(G.I.CARD) do
				if v.set_cost then v:set_cost() end
			end
			return true end 
		}))
	end,
	remove_from_deck = function(self, card, from_debuff)
		G.GAME.discount_percent = G.GAME.discount_percent - card.ability.extra.money_off
		G.E_MANAGER:add_event(Event({func = function()
			for k, v in pairs(G.I.CARD) do
				if v.set_cost then v:set_cost() end
			end
			return true end 
		}))
	end,
    calculate = function(self, card, context) --Coupon Logic
        if context.joker_main then
            return {
                message = localize{type='variable',key='a_chips_minus',vars={card.ability.extra.minus_chips}},
                chip_mod = -card.ability.extra.minus_chips, 
                colour = G.C.RED
            }
        end
    end
})
