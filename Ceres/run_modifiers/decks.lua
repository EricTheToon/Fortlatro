local back_atlas = SMODS.Atlas{
    key = 'backs',
    path = 'backs.png',
    px = 71,
    py = 95,
    atlas_table = 'ASSET_ATLAS',
}

local scratch = Ceres.CONFIG.run_modifiers.decks.enabled and SMODS.Back{
    key = 'scratch',
    unlocked = false or Ceres.CONFIG.misc.unlock_all.enabled,
    discovered = false or Ceres.CONFIG.misc.discover_all.enabled,
    atlas = 'backs',
    pos = {
        x = 3,
        y = 0,
    },
    config = {
        vouchers = {
            'v_hone',
            'v_clearance_sale',
        },
        reroll_discount = -2,
    },
}

if Ceres.CONFIG.run_modifiers.decks.enabled then
    G.P_CENTERS['sticker_eternal'] = { set = 'Other', key = 'eternal' }
end

local soul = Ceres.CONFIG.run_modifiers.decks.enabled and SMODS.Back{
    key = 'soul',
    unlocked = false or Ceres.CONFIG.misc.unlock_all.enabled,
    discovered = false or Ceres.CONFIG.misc.discover_all.enabled,
    atlas = 'backs',
    pos = {
        x = 1,
        y = 0,
    },
    soul_pos = {
        x = 1,
        y = 1,
    },
    config = {},

    apply = function(self)
        G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.8, func = function()
            play_sound('timpani')
            local card = create_card('Joker', G.jokers, true, nil, nil, nil, nil, 'sou')
            card:set_eternal(true)
            card:add_to_deck()
            card.sell_cost = 0
            card.sell_cost_label = card.sell_cost
            G.jokers:emplace(card)
            check_for_unlock{type = 'spawn_legendary'}
        return true end }))
    end,
}

local gift = Ceres.CONFIG.run_modifiers.decks.enabled and SMODS.Back{
    key = 'gift',
    unlocked = false or Ceres.CONFIG.misc.unlock_all.enabled,
    discovered = false or Ceres.CONFIG.misc.discover_all.enabled,
    atlas = 'backs',
    pos = {
        x = 2,
        y = 0,
    },
    config = {
        vouchers = {
            'v_cere_overflow_norm',
        },
        dollars = 5,
    },

    loc_vars = function(self, info_queue, card)
        return {vars = {self.config.dollars}}
    end,
}

local golden = false and Ceres.CONFIG.run_modifiers.decks.enabled and SMODS.Back{
    key = 'golden',
    unlocked = false or Ceres.CONFIG.misc.unlock_all.enabled,
    discovered = false or Ceres.CONFIG.misc.discover_all.enabled,
    atlas = 'backs',
    pos = {
        x = 3,
        y = 0,
    },
    config = {
        no_interest = true,
        extra_card_bonus = 2,
    },

    loc_vars = function(self, info_queue, card)
        return {vars = {self.config.extra_card_bonus}}
    end,
}

if Ceres.CONFIG.run_modifiers.decks.enabled then
    G.P_CENTERS['cere_advantage'] = { set = 'Other', key = 'cere_advantage'}
end

local tat_spades = Ceres.CONFIG.run_modifiers.decks.enabled and SMODS.Back{
    key = 'tattered_spades',
    unlocked = false or Ceres.CONFIG.misc.unlock_all.enabled,
    discovered = false or Ceres.CONFIG.misc.discover_all.enabled,
    atlas = 'backs',
    pos = {
        x = 0,
        y = 1,
    },
    config = {
        vouchers = Ceres.CONFIG.consumables.vouchers.enabled and {
            'v_cere_overflow_norm',
        } or nil,
        discards = -100000
    },
    loc_txt = {
        name = "Tattered Deck of Spades",
        text = (Ceres.CONFIG.consumables.vouchers.enabled and Ceres.CONFIG.card_modifiers.perks.enabled) and {
            "Start run with:",
            'Deck of {E:1,C:spades}Spades{},',
            '{E:1,C:attention,T:v_cere_overflow_norm}Overflow{} voucher,',
            '{C:attention}3{} {E:1,C:green,T:cere_advantage}Advantage{},',
            '{C:attention}0 {E:1,C:red}Discards',
        } or (Ceres.CONFIG.consumables.vouchers.enabled and not Ceres.CONFIG.card_modifiers.perks.enabled) and {
            "Start run with:",
            'Deck of {E:1,C:spades}Spades{},',
            '{E:1,C:attention,T:v_cere_overflow_norm}Overflow{} voucher,',
            '{C:attention}0 {E:1,C:red}Discards',
        } or (not Ceres.CONFIG.consumables.vouchers.enabled and Ceres.CONFIG.card_modifiers.perks.enabled) and {
            "Start run with:",
            'Deck of {E:1,C:spades}Spades{},',
            '{C:attention}3{} {E:1,C:green,T:cere_advantage}Advantage{},',
            '{C:attention}0 {E:1,C:red}Discards',
        } or (not Ceres.CONFIG.consumables.vouchers.enabled and not Ceres.CONFIG.card_modifiers.perks.enabled) and {
            "Start run with:",
            'Deck of {E:1,C:spades}Spades{},',
            '{C:attention}0 {E:1,C:red}Discards',
        }
    },

    apply = function(self)
        G.E_MANAGER:add_event(Event({
            func = (function()
            for k, v in pairs(G.playing_cards) do
                if not v:is_suit('Spades') then 
                    v:start_dissolve(nil, true, 0.00000001)
                end
            end
            if Ceres.CONFIG.card_modifiers.perks.enabled then ease_advantage(3) end
                return true
            end)
          }))
    end,
}

local tat_hearts = Ceres.CONFIG.run_modifiers.decks.enabled and SMODS.Back{
    key = 'tattered_hearts',
    unlocked = false or Ceres.CONFIG.misc.unlock_all.enabled,
    discovered = false or Ceres.CONFIG.misc.discover_all.enabled,
    atlas = 'backs',
    pos = {
        x = 2,
        y = 1,
    },
    config = {
        vouchers = Ceres.CONFIG.consumables.vouchers.enabled and {
            'v_cere_overflow_norm',
        } or nil,
        discards = -100000
    },
    loc_txt = {
        name = "Tattered Deck of Hearts",
        text = (Ceres.CONFIG.consumables.vouchers.enabled and Ceres.CONFIG.card_modifiers.perks.enabled) and {
            "Start run with:",
            'Deck of {E:1,C:hearts}Hearts{},',
            '{E:1,C:attention,T:v_cere_overflow_norm}Overflow{} voucher,',
            '{C:attention}3{} {E:1,C:green,T:cere_advantage}Advantage{},',
            '{C:attention}0 {E:1,C:red}Discards',
        } or (Ceres.CONFIG.consumables.vouchers.enabled and not Ceres.CONFIG.card_modifiers.perks.enabled) and {
            "Start run with:",
            'Deck of {E:1,C:hearts}Hearts{},',
            '{E:1,C:attention,T:v_cere_overflow_norm}Overflow{} voucher,',
            '{C:attention}0 {E:1,C:red}Discards',
        } or (not Ceres.CONFIG.consumables.vouchers.enabled and Ceres.CONFIG.card_modifiers.perks.enabled) and {
            "Start run with:",
            'Deck of {E:1,C:hearts}Hearts{},',
            '{C:attention}3{} {E:1,C:green,T:cere_advantage}Advantage{},',
            '{C:attention}0 {E:1,C:red}Discards',
        } or (not Ceres.CONFIG.consumables.vouchers.enabled and not Ceres.CONFIG.card_modifiers.perks.enabled) and {
            "Start run with:",
            'Deck of {E:1,C:hearts}Hearts{},',
            '{C:attention}0 {E:1,C:red}Discards',
        }
    },

    apply = function(self)
        G.E_MANAGER:add_event(Event({
            func = (function()
            for k, v in pairs(G.playing_cards) do
                if not v:is_suit('Hearts') then 
                    v:start_dissolve(nil, true, 0.00000001)
                end
            end
            if Ceres.CONFIG.card_modifiers.perks.enabled then ease_advantage(3) end
                return true
            end)
          }))
    end,
}

local tat_clubs = Ceres.CONFIG.run_modifiers.decks.enabled and SMODS.Back{
    key = 'tattered_clubs',
    unlocked = false or Ceres.CONFIG.misc.unlock_all.enabled,
    discovered = false or Ceres.CONFIG.misc.discover_all.enabled,
    atlas = 'backs',
    pos = {
        x = 1,
        y = 1,
    },
    config = {
        vouchers = Ceres.CONFIG.consumables.vouchers.enabled and {
            'v_cere_overflow_norm',
        } or nil,
        discards = -100000
    },
    loc_txt = {
        name = "Tattered Deck of Clubs",
        text = (Ceres.CONFIG.consumables.vouchers.enabled and Ceres.CONFIG.card_modifiers.perks.enabled) and {
            "Start run with:",
            'Deck of {E:1,C:clubs}Clubs{},',
            '{E:1,C:attention,T:v_cere_overflow_norm}Overflow{} voucher,',
            '{C:attention}3{} {E:1,C:green,T:cere_advantage}Advantage{},',
            '{C:attention}0 {E:1,C:red}Discards',
        } or (Ceres.CONFIG.consumables.vouchers.enabled and not Ceres.CONFIG.card_modifiers.perks.enabled) and {
            "Start run with:",
            'Deck of {E:1,C:clubs}Clubs{},',
            '{E:1,C:attention,T:v_cere_overflow_norm}Overflow{} voucher,',
            '{C:attention}0 {E:1,C:red}Discards',
        } or (not Ceres.CONFIG.consumables.vouchers.enabled and Ceres.CONFIG.card_modifiers.perks.enabled) and {
            "Start run with:",
            'Deck of {E:1,C:clubs}Clubs{},',
            '{C:attention}3{} {E:1,C:green,T:cere_advantage}Advantage{},',
            '{C:attention}0 {E:1,C:red}Discards',
        } or (not Ceres.CONFIG.consumables.vouchers.enabled and not Ceres.CONFIG.card_modifiers.perks.enabled) and {
            "Start run with:",
            'Deck of {E:1,C:clubs}Clubs{},',
            '{C:attention}0 {E:1,C:red}Discards',
        }
    },

    apply = function(self)
        G.E_MANAGER:add_event(Event({
            func = (function()
            for k, v in pairs(G.playing_cards) do
                if not v:is_suit('Clubs') then 
                    v:start_dissolve(nil, true, 0.00000001)
                end
            end
            if Ceres.CONFIG.card_modifiers.perks.enabled then ease_advantage(3) end
                return true
            end)
          }))
    end,
}

local tat_diamonds = Ceres.CONFIG.run_modifiers.decks.enabled and SMODS.Back{
    key = 'tattered_diamonds',
    unlocked = false or Ceres.CONFIG.misc.unlock_all.enabled,
    discovered = false or Ceres.CONFIG.misc.discover_all.enabled,
    atlas = 'backs',
    pos = {
        x = 3,
        y = 1,
    },
    config = {
        vouchers = Ceres.CONFIG.consumables.vouchers.enabled and {
            'v_cere_overflow_norm',
        } or nil,
        discards = -100000
    },
    loc_txt = {
        name = "Tattered Deck of Diamonds",
        text = (Ceres.CONFIG.consumables.vouchers.enabled and Ceres.CONFIG.card_modifiers.perks.enabled) and {
            "Start run with:",
            'Deck of {E:1,C:diamonds}Diamonds{},',
            '{E:1,C:attention,T:v_cere_overflow_norm}Overflow{} voucher,',
            '{C:attention}3{} {E:1,C:green,T:cere_advantage}Advantage{},',
            '{C:attention}0 {E:1,C:red}Discards',
        } or (Ceres.CONFIG.consumables.vouchers.enabled and not Ceres.CONFIG.card_modifiers.perks.enabled) and {
            "Start run with:",
            'Deck of {E:1,C:diamonds}Diamonds{},',
            '{E:1,C:attention,T:v_cere_overflow_norm}Overflow{} voucher,',
            '{C:attention}0 {E:1,C:red}Discards',
        } or (not Ceres.CONFIG.consumables.vouchers.enabled and Ceres.CONFIG.card_modifiers.perks.enabled) and {
            "Start run with:",
            'Deck of {E:1,C:diamonds}Diamonds{},',
            '{C:attention}3{} {E:1,C:green,T:cere_advantage}Advantage{},',
            '{C:attention}0 {E:1,C:red}Discards',
        } or (not Ceres.CONFIG.consumables.vouchers.enabled and not Ceres.CONFIG.card_modifiers.perks.enabled) and {
            "Start run with:",
            'Deck of {E:1,C:Diamonds}Diamonds{},',
            '{C:attention}0 {E:1,C:red}Discards',
        }
    },

    apply = function(self)
        G.E_MANAGER:add_event(Event({
            func = (function()
            for k, v in pairs(G.playing_cards) do
                if not v:is_suit('Diamonds') then 
                    v:start_dissolve(nil, true, 0.00000001)
                end
            end
            if Ceres.CONFIG.card_modifiers.perks.enabled then ease_advantage(3) end
                return true
            end)
          }))
    end,
}