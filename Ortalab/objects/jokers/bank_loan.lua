SMODS.Joker({
	key = "bank_loan",
	atlas = "jokers",
	pos = {x=9,y=0},
	rarity = 1,
	cost = 0,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = false,
	config = {extra = {money = 20}},
	loc_vars = function(self, info_queue, card)
        if card and Ortalab.config.artist_credits then info_queue[#info_queue+1] = {generate_ui = ortalab_artist_tooltip, key = 'gappie'} end
		return {vars = {card.ability.extra.money}}
	end,
	add_to_deck = function(self, card, from_debuff)
        ease_dollars(card.ability.extra.money)
        card.sell_cost = card.ability.extra.money * -1
    end
})

local set_cost = Card.set_cost
function Card:set_cost()
    set_cost(self)
    if self.config.center_key == 'j_ortalab_bank_loan' then
        self.sell_cost = -1 * self.ability.extra.money
        self.sell_cost_label = self.ability.extra.money
    end
end