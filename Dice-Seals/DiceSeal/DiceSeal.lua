--- STEAMODDED HEADER
--- MOD_NAME: Dice Seal
--- MOD_ID: DiceSeal
--- MOD_AUTHOR: [Flounder]
--- MOD_DESCRIPTION: Adds a Dice Seal to the game

----------------------------------------------
------------MOD CODE -------------------------

SMODS.Atlas {
    key = "diceseal_atlas",
    path = "dice_seal.png",
    px = 71,
    py = 95
}
local seal = SMODS.Seal {
    name = "dice_seal",
    key = "dice_seal",
    badge_colour = HEX("3eb25f"),
    loc_txt = {
        label = 'Dice Seal',
        name = 'Dice Seal',
        text = {
            "Discarding this seal:",
            "Doubles all {C:attention}listed",
            "{C:green,E:1,S:1.1}probabilities",
            "{C:inactive}(ex: {C:green}1 in 3{C:inactive} -> {C:green}2 in 3{C:inactive})",
            "{C:dark_edition}Discarding removes all dice seals{}"
        }
    },
    atlas = "diceseal_atlas",
    pos = {x=0, y=0},
    calculate = function(self, card, context)
        if context.discard then
             for k, v in pairs(G.GAME.probabilities) do
                 G.GAME.probabilities[k] = v * 2
             end
             G.E_MANAGER:add_event(
                 Event({
                     trigger = 'after',
                     delay = 0.2,
                     func = function()
                         for _,v in pairs(G.playing_cards) do
                             if v.seal== 'dice_seal'then
                                 v.seal=nil
                             end
                         end
                         return true
                     end
                 })
             )
        end
    end
}

SMODS.Atlas {
    key = "oops6",
    path = "c_oops6.png",
    px = 71,
    py = 95
}
SMODS.Consumable {
    set = 'Spectral',
    key = 'oops6',
    loc_txt = {
        name = "Oops All 20s",
        text = {
            "Add a {C:green}Dice Seal{}",
            "to {C:attention}1{} selected",
            "card in your hand"
        }
    },
    atlas = 'oops6',
    pos = { x = 0, y = 0 },
    config = {max_highlighted = 1, extra = seal.key,},
    cost = 4,
    use = function(self, card, area, copier)
        local conv_card = G.hand.highlighted[1]
        G.E_MANAGER:add_event(Event({
            func = function()
                play_sound('tarot1')
                local spectral = copier or card
                spectral:juice_up(0.3, 0.5)
                return true
            end
        }))

        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.1,
            func = function()
                conv_card:set_seal(card.ability.extra, nil, true)
                return true
            end
        }))
        delay(0.5)
    end,
    can_use = function(self, card)
        if G.STATE == G.STATES.SELECTING_HAND or G.STATE == G.STATES.TAROT_PACK or G.STATE == G.STATES.SPECTRAL_PACK or G.STATE == G.STATES.PLANET_PACK then
            if #G.hand.highlighted >= 1 and #G.hand.highlighted <= card.ability.max_highlighted then
                for i=1, #G.hand.highlighted do
                    if G.hand.highlighted[i].ability.effect == "Stone Card" then
                        return false
                    end
                end
                return true
            end
        end
    end,
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = { key = "dice_seal_seal", set = 'Other' }
        return { vars = { }}
    end
}

----------------------------------------------
------------MOD CODE END----------------------
