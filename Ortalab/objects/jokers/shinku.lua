SMODS.Joker({
	key = "shinku",
	atlas = "jokers",
	pos = {x = 4, y = 9},
    soul_pos = {x = 3, y = 9},
	rarity = 4,
	cost = 20,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = false,
	config = {extra = {cards_to_create = 3}},
	loc_vars = function(self, info_queue, card)
        if card and Ortalab.config.artist_credits then info_queue[#info_queue+1] = {generate_ui = ortalab_artist_tooltip, key = 'tevi'} end
        if card and Ortalab.config.artist_credits then info_queue[#info_queue+1] = {generate_ui = ortalab_artist_tooltip, key = 'crimson'} end
        return {vars = {card.ability.extra.cards_to_create}}
    end,
    calculate = function(self, card, context)
        if context.setting_blind then
            local new_joker_pool = get_current_pool('Joker')
            local final_pool = {}
            for _, v in ipairs(new_joker_pool) do
                if v ~= 'UNAVAILABLE' and string.sub(v, 1, 9) == 'j_ortalab' then
                    table.insert(final_pool, v)
                end
            end
            for i=1, card.ability.extra.cards_to_create do
                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    delay = 0.4,
                    func = function() 
                    local new_joker = create_card('Joker', G.jokers, nil, nil, nil, nil, pseudorandom_element(final_pool, pseudoseed('shinku_spawn')))
                    new_joker:set_edition(nil, true, true)
                    new_joker:add_to_deck()
                    G.jokers:emplace(new_joker)
                    new_joker:start_materialize()
                    new_joker.ability.shinku = true
                    return true
                end}))  
            end 
        end
    end
})

local can_sell = Card.can_sell_card
function Card:can_sell_card(context)
    if self.ability.shinku then return false end
    return can_sell(self, context)
end