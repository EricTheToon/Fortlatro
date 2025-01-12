local planet_ex_atlas = SMODS.Atlas{
    key = 'planet_ex',
    path = 'planet_ex.png',
    px = 71,
    py = 95,
    atlas_table = 'ASSET_ATLAS',
}

local ex_enabled = Ceres.CONFIG.consumables.enabled and Ceres.CONFIG.consumables.consumable_ex.enabled

local planet_ex = ex_enabled and SMODS.ConsumableType{
    key = 'planet_ex',
    primary_colour = Ceres.C.planet_ex,
    secondary_colour = Ceres.C.planet_ex,
    loc_txt = {
        name = 'Planet EX',
        collection = 'Planet EX',
        undiscovered = {
            name = 'Not Discovered',
            text = {
                'Purchase or use',
                'this card in an',
                'unseeded run to',
                'learn what it does',
            },
        },
    },
    collection_rows = { 6, 6 },
}

local undiscoverd_atlas = SMODS.UndiscoveredSprite{
    atlas = 'planet_ex',
    key = 'planet_ex',
    pos = {
        x = 0,
        y = 0,
    },
}

local card_draw_ref = Card.draw
function Card:draw(layer)
    card_draw_ref(self, layer)
    if self.ability.set == 'planet_ex' then
        self.children.center:draw_shader('voucher', nil, self.ARGS.send_to_shader)
    end
end

local pluto_ex = ex_enabled and SMODS.Consumable{
    key = "pluto_ex",
    set = "planet_ex",
    config = {
        hand = {
            hand_type = 'High Card',
            --softlock = true
        },
        extra = 3,
    },
    pos = {
        x = 3,
        y = 1,
    },
    cost = 7,
    atlas = "planet_ex",
    unlocked = false or Ceres.CONFIG.misc.unlock_all.enabled,
    discovered = false or Ceres.CONFIG.misc.discover_all.enabled,

    loc_vars = function(self, info_queue, card)
        local vars = {G.GAME.hands[card.ability.hand.hand_type].level, G.GAME.hands[card.ability.hand.hand_type].l_mult * card.ability.extra, G.GAME.hands[card.ability.hand.hand_type].l_chips * card.ability.extra, card.ability.extra}
        local level = G.GAME.hands[card.ability.hand.hand_type].level or 1
        local col = G.C.HAND_LEVELS[math.min(level, 7)]
        if level == 1 then
            col = G.C.UI.TEXT_DARK
        end
        vars.colours = {col}
        return {vars = vars}
    end,

    can_use = function(self, card)
        return true
    end,
    

    use = function(self, card, area, copier)
        for i = 1, card.ability.extra do
            update_hand_text({sound = 'button', volume = 0.7, pitch = 0.8, delay = 0.3}, {handname=card.ability.hand.hand_type,chips = G.GAME.hands[card.ability.hand.hand_type].chips, mult = G.GAME.hands[card.ability.hand.hand_type].mult, level=G.GAME.hands[card.ability.hand.hand_type].level})
            level_up_hand(card, card.ability.hand.hand_type)
        end
        update_hand_text({sound = 'button', volume = 0.7, pitch = 1.1, delay = 0}, {mult = 0, chips = 0, handname = '', level = ''})
    end,

    calculate = function(self, card, context)
        if G.GAME.used_vouchers.v_observatory and (context.scoring_name == card.ability.hand.hand_type) then
            local value = G.P_CENTERS.v_observatory.config.extra * card.ability.extra
            return {
                message = localize{type = 'variable', key = 'a_xmult', vars = {value}},
                Xmult_mod = value
            }
	    end
    end
}

local mercury_ex = ex_enabled and SMODS.Consumable{
    key = "mercury_ex",
    set = "planet_ex",
    config = {
        hand = {
            hand_type = 'Pair',
            --softlock = true
        },
        extra = 3,
    },
    pos = {
        x = 1,
        y = 0,
    },
    cost = 7,
    atlas = "planet_ex",
    unlocked = false or Ceres.CONFIG.misc.unlock_all.enabled,
    discovered = false or Ceres.CONFIG.misc.discover_all.enabled,

    loc_vars = function(self, info_queue, card)
        local vars = {G.GAME.hands[card.ability.hand.hand_type].level, G.GAME.hands[card.ability.hand.hand_type].l_mult * card.ability.extra, G.GAME.hands[card.ability.hand.hand_type].l_chips * card.ability.extra, card.ability.extra}
        local level = G.GAME.hands[card.ability.hand.hand_type].level or 1
        local col = G.C.HAND_LEVELS[math.min(level, 7)]
        if level == 1 then
            col = G.C.UI.TEXT_DARK
        end
        vars.colours = {col}
        return {vars = vars}
    end,

    can_use = function(self, card)
        return true
    end,
    

    use = function(self, card, area, copier)
        for i = 1, card.ability.extra do
            update_hand_text({sound = 'button', volume = 0.7, pitch = 0.8, delay = 0.3}, {handname=card.ability.hand.hand_type,chips = G.GAME.hands[card.ability.hand.hand_type].chips, mult = G.GAME.hands[card.ability.hand.hand_type].mult, level=G.GAME.hands[card.ability.hand.hand_type].level})
            level_up_hand(card, card.ability.hand.hand_type)
        end
        update_hand_text({sound = 'button', volume = 0.7, pitch = 1.1, delay = 0}, {mult = 0, chips = 0, handname = '', level = ''})
    end,

    calculate = function(self, card, context)
        if G.GAME.used_vouchers.v_observatory and (context.scoring_name == card.ability.hand.hand_type) then
            local value = G.P_CENTERS.v_observatory.config.extra * card.ability.extra
            return {
                message = localize{type = 'variable', key = 'a_xmult', vars = {value}},
                Xmult_mod = value
            }
        end
    end
}

local uranus_ex = ex_enabled and SMODS.Consumable{
    key = "uranus_ex",
    set = "planet_ex",
    config = {
        hand = {
            hand_type = 'Two Pair',
            --softlock = true
        },
        extra = 3,
    },
    pos = {
        x = 1,
        y = 1,
    },
    cost = 7,
    atlas = "planet_ex",
    unlocked = false or Ceres.CONFIG.misc.unlock_all.enabled,
    discovered = false or Ceres.CONFIG.misc.discover_all.enabled,

    loc_vars = function(self, info_queue, card)
        local vars = {G.GAME.hands[card.ability.hand.hand_type].level, G.GAME.hands[card.ability.hand.hand_type].l_mult * card.ability.extra, G.GAME.hands[card.ability.hand.hand_type].l_chips * card.ability.extra, card.ability.extra}
        local level = G.GAME.hands[card.ability.hand.hand_type].level or 1
        local col = G.C.HAND_LEVELS[math.min(level, 7)]
        if level == 1 then
            col = G.C.UI.TEXT_DARK
        end
        vars.colours = {col}
        return {vars = vars}
    end,

    can_use = function(self, card)
        return true
    end,
    

    use = function(self, card, area, copier)
        for i = 1, card.ability.extra do
            update_hand_text({sound = 'button', volume = 0.7, pitch = 0.8, delay = 0.3}, {handname=card.ability.hand.hand_type,chips = G.GAME.hands[card.ability.hand.hand_type].chips, mult = G.GAME.hands[card.ability.hand.hand_type].mult, level=G.GAME.hands[card.ability.hand.hand_type].level})
            level_up_hand(card, card.ability.hand.hand_type)
        end
        update_hand_text({sound = 'button', volume = 0.7, pitch = 1.1, delay = 0}, {mult = 0, chips = 0, handname = '', level = ''})
    end,

    calculate = function(self, card, context)
        if G.GAME.used_vouchers.v_observatory and (context.scoring_name == card.ability.hand.hand_type) then
            local value = G.P_CENTERS.v_observatory.config.extra * card.ability.extra
            return {
                message = localize{type = 'variable', key = 'a_xmult', vars = {value}},
                Xmult_mod = value
            }
        end
    end
}

local venus_ex = ex_enabled and SMODS.Consumable{
    key = "venus_ex",
    set = "planet_ex",
    config = {
        hand = {
            hand_type = 'Three of a Kind',
            --softlock = true
        },
        extra = 3,
    },
    pos = {
        x = 2,
        y = 0,
    },
    cost = 7,
    atlas = "planet_ex",
    unlocked = false or Ceres.CONFIG.misc.unlock_all.enabled,
    discovered = false or Ceres.CONFIG.misc.discover_all.enabled,

    loc_vars = function(self, info_queue, card)
        local vars = {G.GAME.hands[card.ability.hand.hand_type].level, G.GAME.hands[card.ability.hand.hand_type].l_mult * card.ability.extra, G.GAME.hands[card.ability.hand.hand_type].l_chips * card.ability.extra, card.ability.extra}
        local level = G.GAME.hands[card.ability.hand.hand_type].level or 1
        local col = G.C.HAND_LEVELS[math.min(level, 7)]
        if level == 1 then
            col = G.C.UI.TEXT_DARK
        end
        vars.colours = {col}
        return {vars = vars}
    end,

    can_use = function(self, card)
        return true
    end,
    

    use = function(self, card, area, copier)
        for i = 1, card.ability.extra do
            update_hand_text({sound = 'button', volume = 0.7, pitch = 0.8, delay = 0.3}, {handname=card.ability.hand.hand_type,chips = G.GAME.hands[card.ability.hand.hand_type].chips, mult = G.GAME.hands[card.ability.hand.hand_type].mult, level=G.GAME.hands[card.ability.hand.hand_type].level})
            level_up_hand(card, card.ability.hand.hand_type)
        end
        update_hand_text({sound = 'button', volume = 0.7, pitch = 1.1, delay = 0}, {mult = 0, chips = 0, handname = '', level = ''})
    end,

    calculate = function(self, card, context)
        if G.GAME.used_vouchers.v_observatory and (context.scoring_name == card.ability.hand.hand_type) then
            local value = G.P_CENTERS.v_observatory.config.extra * card.ability.extra
            return {
                message = localize{type = 'variable', key = 'a_xmult', vars = {value}},
                Xmult_mod = value
            }
        end
    end
}

local saturn_ex = ex_enabled and SMODS.Consumable{
    key = "saturn_ex",
    set = "planet_ex",
    config = {
        hand = {
            hand_type = 'Straight',
            --softlock = true
        },
        extra = 3,
    },
    pos = {
        x = 0,
        y = 1,
    },
    cost = 7,
    atlas = "planet_ex",
    unlocked = false or Ceres.CONFIG.misc.unlock_all.enabled,
    discovered = false or Ceres.CONFIG.misc.discover_all.enabled,

    loc_vars = function(self, info_queue, card)
        local vars = {G.GAME.hands[card.ability.hand.hand_type].level, G.GAME.hands[card.ability.hand.hand_type].l_mult * card.ability.extra, G.GAME.hands[card.ability.hand.hand_type].l_chips * card.ability.extra, card.ability.extra}
        local level = G.GAME.hands[card.ability.hand.hand_type].level or 1
        local col = G.C.HAND_LEVELS[math.min(level, 7)]
        if level == 1 then
            col = G.C.UI.TEXT_DARK
        end
        vars.colours = {col}
        return {vars = vars}
    end,

    can_use = function(self, card)
        return true
    end,
    

    use = function(self, card, area, copier)
        for i = 1, card.ability.extra do
            update_hand_text({sound = 'button', volume = 0.7, pitch = 0.8, delay = 0.3}, {handname=card.ability.hand.hand_type,chips = G.GAME.hands[card.ability.hand.hand_type].chips, mult = G.GAME.hands[card.ability.hand.hand_type].mult, level=G.GAME.hands[card.ability.hand.hand_type].level})
            level_up_hand(card, card.ability.hand.hand_type)
        end
        update_hand_text({sound = 'button', volume = 0.7, pitch = 1.1, delay = 0}, {mult = 0, chips = 0, handname = '', level = ''})
    end,

    calculate = function(self, card, context)
        if G.GAME.used_vouchers.v_observatory and (context.scoring_name == card.ability.hand.hand_type) then
            local value = G.P_CENTERS.v_observatory.config.extra * card.ability.extra
            return {
                message = localize{type = 'variable', key = 'a_xmult', vars = {value}},
                Xmult_mod = value
            }
        end
    end
}

local jupiter_ex = ex_enabled and SMODS.Consumable{
    key = "jupiter_ex",
    set = "planet_ex",
    config = {
        hand = {
            hand_type = 'Flush',
            --softlock = true
        },
        extra = 3,
    },
    pos = {
        x = 5,
        y = 0,
    },
    cost = 7,
    atlas = "planet_ex",
    unlocked = false or Ceres.CONFIG.misc.unlock_all.enabled,
    discovered = false or Ceres.CONFIG.misc.discover_all.enabled,

    loc_vars = function(self, info_queue, card)
        local vars = {G.GAME.hands[card.ability.hand.hand_type].level, G.GAME.hands[card.ability.hand.hand_type].l_mult * card.ability.extra, G.GAME.hands[card.ability.hand.hand_type].l_chips * card.ability.extra, card.ability.extra}
        local level = G.GAME.hands[card.ability.hand.hand_type].level or 1
        local col = G.C.HAND_LEVELS[math.min(level, 7)]
        if level == 1 then
            col = G.C.UI.TEXT_DARK
        end
        vars.colours = {col}
        return {vars = vars}
    end,

    can_use = function(self, card)
        return true
    end,
    

    use = function(self, card, area, copier)
        for i = 1, card.ability.extra do
            update_hand_text({sound = 'button', volume = 0.7, pitch = 0.8, delay = 0.3}, {handname=card.ability.hand.hand_type,chips = G.GAME.hands[card.ability.hand.hand_type].chips, mult = G.GAME.hands[card.ability.hand.hand_type].mult, level=G.GAME.hands[card.ability.hand.hand_type].level})
            level_up_hand(card, card.ability.hand.hand_type)
        end
        update_hand_text({sound = 'button', volume = 0.7, pitch = 1.1, delay = 0}, {mult = 0, chips = 0, handname = '', level = ''})
    end,

    calculate = function(self, card, context)
        if G.GAME.used_vouchers.v_observatory and (context.scoring_name == card.ability.hand.hand_type) then
            local value = G.P_CENTERS.v_observatory.config.extra * card.ability.extra
            return {
                message = localize{type = 'variable', key = 'a_xmult', vars = {value}},
                Xmult_mod = value
            }
        end
    end
}

local earth_ex = ex_enabled and SMODS.Consumable{
    key = "earth_ex",
    set = "planet_ex",
    config = {
        hand = {
            hand_type = 'Full House',
            --softlock = true
        },
        extra = 3,
    },
    pos = {
        x = 3,
        y = 0,
    },
    cost = 7,
    atlas = "planet_ex",
    unlocked = false or Ceres.CONFIG.misc.unlock_all.enabled,
    discovered = false or Ceres.CONFIG.misc.discover_all.enabled,

    loc_vars = function(self, info_queue, card)
        local vars = {G.GAME.hands[card.ability.hand.hand_type].level, G.GAME.hands[card.ability.hand.hand_type].l_mult * card.ability.extra, G.GAME.hands[card.ability.hand.hand_type].l_chips * card.ability.extra, card.ability.extra}
        local level = G.GAME.hands[card.ability.hand.hand_type].level or 1
        local col = G.C.HAND_LEVELS[math.min(level, 7)]
        if level == 1 then
            col = G.C.UI.TEXT_DARK
        end
        vars.colours = {col}
        return {vars = vars}
    end,

    can_use = function(self, card)
        return true
    end,
    

    use = function(self, card, area, copier)
        for i = 1, card.ability.extra do
            update_hand_text({sound = 'button', volume = 0.7, pitch = 0.8, delay = 0.3}, {handname=card.ability.hand.hand_type,chips = G.GAME.hands[card.ability.hand.hand_type].chips, mult = G.GAME.hands[card.ability.hand.hand_type].mult, level=G.GAME.hands[card.ability.hand.hand_type].level})
            level_up_hand(card, card.ability.hand.hand_type)
        end
        update_hand_text({sound = 'button', volume = 0.7, pitch = 1.1, delay = 0}, {mult = 0, chips = 0, handname = '', level = ''})
    end,

    calculate = function(self, card, context)
        if G.GAME.used_vouchers.v_observatory and (context.scoring_name == card.ability.hand.hand_type) then
            local value = G.P_CENTERS.v_observatory.config.extra * card.ability.extra
            return {
                message = localize{type = 'variable', key = 'a_xmult', vars = {value}},
                Xmult_mod = value
            }
        end
    end
}

local mars_ex = ex_enabled and SMODS.Consumable{
    key = "mars_ex",
    set = "planet_ex",
    config = {
        hand = {
            hand_type = 'Four of a Kind',
            --softlock = true
        },
        extra = 3,
    },
    pos = {
        x = 4,
        y = 0,
    },
    cost = 7,
    atlas = "planet_ex",
    unlocked = false or Ceres.CONFIG.misc.unlock_all.enabled,
    discovered = false or Ceres.CONFIG.misc.discover_all.enabled,

    loc_vars = function(self, info_queue, card)
        local vars = {G.GAME.hands[card.ability.hand.hand_type].level, G.GAME.hands[card.ability.hand.hand_type].l_mult * card.ability.extra, G.GAME.hands[card.ability.hand.hand_type].l_chips * card.ability.extra, card.ability.extra}
        local level = G.GAME.hands[card.ability.hand.hand_type].level or 1
        local col = G.C.HAND_LEVELS[math.min(level, 7)]
        if level == 1 then
            col = G.C.UI.TEXT_DARK
        end
        vars.colours = {col}
        return {vars = vars}
    end,

    can_use = function(self, card)
        return true
    end,
    

    use = function(self, card, area, copier)
        for i = 1, card.ability.extra do
            update_hand_text({sound = 'button', volume = 0.7, pitch = 0.8, delay = 0.3}, {handname=card.ability.hand.hand_type,chips = G.GAME.hands[card.ability.hand.hand_type].chips, mult = G.GAME.hands[card.ability.hand.hand_type].mult, level=G.GAME.hands[card.ability.hand.hand_type].level})
            level_up_hand(card, card.ability.hand.hand_type)
        end
        update_hand_text({sound = 'button', volume = 0.7, pitch = 1.1, delay = 0}, {mult = 0, chips = 0, handname = '', level = ''})
    end,

    calculate = function(self, card, context)
        if G.GAME.used_vouchers.v_observatory and (context.scoring_name == card.ability.hand.hand_type) then
            local value = G.P_CENTERS.v_observatory.config.extra * card.ability.extra
            return {
                message = localize{type = 'variable', key = 'a_xmult', vars = {value}},
                Xmult_mod = value
            }
        end
    end
}

local neptune_ex = ex_enabled and SMODS.Consumable{
    key = "neptune_ex",
    set = "planet_ex",
    config = {
        hand = {
            hand_type = 'Straight Flush',
            --softlock = true
        },
        extra = 3,
    },
    pos = {
        x = 2,
        y = 1,
    },
    cost = 7,
    atlas = "planet_ex",
    unlocked = false or Ceres.CONFIG.misc.unlock_all.enabled,
    discovered = false or Ceres.CONFIG.misc.discover_all.enabled,

    loc_vars = function(self, info_queue, card)
        local vars = {G.GAME.hands[card.ability.hand.hand_type].level, G.GAME.hands[card.ability.hand.hand_type].l_mult * card.ability.extra, G.GAME.hands[card.ability.hand.hand_type].l_chips * card.ability.extra, card.ability.extra}
        local level = G.GAME.hands[card.ability.hand.hand_type].level or 1
        local col = G.C.HAND_LEVELS[math.min(level, 7)]
        if level == 1 then
            col = G.C.UI.TEXT_DARK
        end
        vars.colours = {col}
        return {vars = vars}
    end,

    can_use = function(self, card)
        return true
    end,
    

    use = function(self, card, area, copier)
        for i = 1, card.ability.extra do
            update_hand_text({sound = 'button', volume = 0.7, pitch = 0.8, delay = 0.3}, {handname=card.ability.hand.hand_type,chips = G.GAME.hands[card.ability.hand.hand_type].chips, mult = G.GAME.hands[card.ability.hand.hand_type].mult, level=G.GAME.hands[card.ability.hand.hand_type].level})
            level_up_hand(card, card.ability.hand.hand_type)
        end
        update_hand_text({sound = 'button', volume = 0.7, pitch = 1.1, delay = 0}, {mult = 0, chips = 0, handname = '', level = ''})
    end,

    calculate = function(self, card, context)
        if G.GAME.used_vouchers.v_observatory and (context.scoring_name == card.ability.hand.hand_type) then
            local value = G.P_CENTERS.v_observatory.config.extra * card.ability.extra
            return {
                message = localize{type = 'variable', key = 'a_xmult', vars = {value}},
                Xmult_mod = value
            }
        end
    end
}

local planetx_ex = ex_enabled and SMODS.Consumable{
    key = "planetx_ex",
    set = "planet_ex",
    config = {
        hand = {
            hand_type = 'Five of a Kind',
        },
        extra = 3,
    },
    pos = {
        x = 5,
        y = 1,
    },
    cost = 7,
    atlas = "planet_ex",
    unlocked = false or Ceres.CONFIG.misc.unlock_all.enabled,
    discovered = false or Ceres.CONFIG.misc.discover_all.enabled,

    loc_vars = function(self, info_queue, card)
        local vars = {G.GAME.hands[card.ability.hand.hand_type].level, G.GAME.hands[card.ability.hand.hand_type].l_mult * card.ability.extra, G.GAME.hands[card.ability.hand.hand_type].l_chips * card.ability.extra, card.ability.extra}
        local level = G.GAME.hands[card.ability.hand.hand_type].level or 1
        local col = G.C.HAND_LEVELS[math.min(level, 7)]
        if level == 1 then
            col = G.C.UI.TEXT_DARK
        end
        vars.colours = {col}
        return {vars = vars}
    end,

    can_use = function(self, card)
        return true
    end,
    

    use = function(self, card, area, copier)
        for i = 1, card.ability.extra do
            update_hand_text({sound = 'button', volume = 0.7, pitch = 0.8, delay = 0.3}, {handname=card.ability.hand.hand_type,chips = G.GAME.hands[card.ability.hand.hand_type].chips, mult = G.GAME.hands[card.ability.hand.hand_type].mult, level=G.GAME.hands[card.ability.hand.hand_type].level})
            level_up_hand(card, card.ability.hand.hand_type)
        end
        update_hand_text({sound = 'button', volume = 0.7, pitch = 1.1, delay = 0}, {mult = 0, chips = 0, handname = '', level = ''})
    end,

    calculate = function(self, card, context)
        if G.GAME.used_vouchers.v_observatory and (context.scoring_name == card.ability.hand.hand_type) then
            local value = G.P_CENTERS.v_observatory.config.extra * card.ability.extra
            return {
                message = localize{type = 'variable', key = 'a_xmult', vars = {value}},
                Xmult_mod = value
            }
        end
    end
}

local ceres_ex = ex_enabled and SMODS.Consumable{
    key = "ceres_ex",
    set = "planet_ex",
    config = {
        hand = {
            hand_type = 'Flush House',
        },
        extra = 3,
    },
    pos = {
        x = 4,
        y = 1,
    },
    cost = 7,
    atlas = "planet_ex",
    unlocked = false or Ceres.CONFIG.misc.unlock_all.enabled,
    discovered = false or Ceres.CONFIG.misc.discover_all.enabled,

    loc_vars = function(self, info_queue, card)
        local vars = {G.GAME.hands[card.ability.hand.hand_type].level, G.GAME.hands[card.ability.hand.hand_type].l_mult * card.ability.extra, G.GAME.hands[card.ability.hand.hand_type].l_chips * card.ability.extra, card.ability.extra}
        local level = G.GAME.hands[card.ability.hand.hand_type].level or 1
        local col = G.C.HAND_LEVELS[math.min(level, 7)]
        if level == 1 then
            col = G.C.UI.TEXT_DARK
        end
        vars.colours = {col}
        return {vars = vars}
    end,

    can_use = function(self, card)
        return true
    end,
    

    use = function(self, card, area, copier)
        for i = 1, card.ability.extra do
            update_hand_text({sound = 'button', volume = 0.7, pitch = 0.8, delay = 0.3}, {handname=card.ability.hand.hand_type,chips = G.GAME.hands[card.ability.hand.hand_type].chips, mult = G.GAME.hands[card.ability.hand.hand_type].mult, level=G.GAME.hands[card.ability.hand.hand_type].level})
            level_up_hand(card, card.ability.hand.hand_type)
        end
        update_hand_text({sound = 'button', volume = 0.7, pitch = 1.1, delay = 0}, {mult = 0, chips = 0, handname = '', level = ''})
    end,

    calculate = function(self, card, context)
        if G.GAME.used_vouchers.v_observatory and (context.scoring_name == card.ability.hand.hand_type) then
            local value = G.P_CENTERS.v_observatory.config.extra * card.ability.extra
            return {
                message = localize{type = 'variable', key = 'a_xmult', vars = {value}},
                Xmult_mod = value
            }
        end
    end
}

local eris_ex = ex_enabled and SMODS.Consumable{
    key = "eris_ex",
    set = "planet_ex",
    config = {
        hand = {
            hand_type = 'Flush Five',
        },
        extra = 3,
    },
    pos = {
        x = 0,
        y = 2,
    },
    cost = 7,
    atlas = "planet_ex",
    unlocked = false or Ceres.CONFIG.misc.unlock_all.enabled,
    discovered = false or Ceres.CONFIG.misc.discover_all.enabled,

    loc_vars = function(self, info_queue, card)
        local vars = {G.GAME.hands[card.ability.hand.hand_type].level, G.GAME.hands[card.ability.hand.hand_type].l_mult * card.ability.extra, G.GAME.hands[card.ability.hand.hand_type].l_chips * card.ability.extra, card.ability.extra}
        local level = G.GAME.hands[card.ability.hand.hand_type].level or 1
        local col = G.C.HAND_LEVELS[math.min(level, 7)]
        if level == 1 then
            col = G.C.UI.TEXT_DARK
        end
        vars.colours = {col}
        return {vars = vars}
    end,

    can_use = function(self, card)
        return true
    end,
    

    use = function(self, card, area, copier)
        for i = 1, card.ability.extra do
            update_hand_text({sound = 'button', volume = 0.7, pitch = 0.8, delay = 0.3}, {handname=card.ability.hand.hand_type,chips = G.GAME.hands[card.ability.hand.hand_type].chips, mult = G.GAME.hands[card.ability.hand.hand_type].mult, level=G.GAME.hands[card.ability.hand.hand_type].level})
            level_up_hand(card, card.ability.hand.hand_type)
        end
        update_hand_text({sound = 'button', volume = 0.7, pitch = 1.1, delay = 0}, {mult = 0, chips = 0, handname = '', level = ''})
    end,

    calculate = function(self, card, context)
        if G.GAME.used_vouchers.v_observatory and (context.scoring_name == card.ability.hand.hand_type) then
            local value = G.P_CENTERS.v_observatory.config.extra * card.ability.extra
            return {
                message = localize{type = 'variable', key = 'a_xmult', vars = {value}},
                Xmult_mod = value
            }
        end
    end
}