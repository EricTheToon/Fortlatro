local planet_gx_atlas = SMODS.Atlas{
    key = 'planet_gx',
    path = 'planet_gx.png',
    px = 71,
    py = 95,
    atlas_table = 'ASSET_ATLAS',
}

local gx_enabled = Ceres.CONFIG.consumables.enabled and Ceres.CONFIG.consumables.consumable_gx.enabled
print('GX enabled:' .. tostring(gx_enabled))

local planet_gx = gx_enabled and SMODS.ConsumableType{
    key = 'planet_gx',
    primary_colour = Ceres.C.planet_gx,
    secondary_colour = Ceres.C.planet_gx,
    loc_txt = {
        name = 'Planet GX',
        collection = 'Planet GX',
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
    atlas = 'planet_gx',
    key = 'planet_gx',
    pos = {
        x = 0,
        y = 0,
    },
}

local card_draw_ref = Card.draw
function Card:draw(layer)
    card_draw_ref(self, layer)
    if self.ability.set == 'planet_gx' then
        self.children.center:draw_shader('voucher', nil, self.ARGS.send_to_shader)
    end
end

local pluto_gx = gx_enabled and SMODS.Consumable{
    key = "pluto_gx",
    set = "planet_gx",
    config = {
        hand = {
            hand_types = {
                'High Card',
                'Pair',
                'Two Pair',
            },
            --softlock = true
        },
        extra = 3,
    },
    pos = {
        x = 3,
        y = 1,
    },
    cost = 15,
    atlas = "planet_gx",
    unlocked = false or Ceres.CONFIG.misc.unlock_all.enabled,
    discovered = false or Ceres.CONFIG.misc.discover_all.enabled,

    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.hand.hand_types[1], card.ability.hand.hand_types[2], card.ability.hand.hand_types[3], card.ability.extra}}
    end,

    can_use = function(self, card)
        return true
    end,
    
    use = function(self, card, area, copier)
        for i = 1, #card.ability.hand.hand_types do
            update_hand_text({sound = 'button', volume = 0.7, pitch = 0.8, delay = 0.3}, {handname=card.ability.hand.hand_types[i],chips = G.GAME.hands[card.ability.hand.hand_types[i]].chips, mult = G.GAME.hands[card.ability.hand.hand_types[i]].mult, level=G.GAME.hands[card.ability.hand.hand_types[i]].level})
            level_up_hand(card, card.ability.hand.hand_types[i], nil, card.ability.extra)
        end
        update_hand_text({sound = 'button', volume = 0.7, pitch = 1.1, delay = 0}, {mult = 0, chips = 0, handname = '', level = ''})
    end,

    calculate = function(self, card, context)
        if G.GAME.used_vouchers.v_observatory and (context.scoring_name == card.ability.hand.hand_types[1] or context.scoring_name == card.ability.hand.hand_types[2] or context.scoring_name == card.ability.hand.hand_types[3]) then
            local value = G.P_CENTERS.v_observatory.config.extra * card.ability.extra
            return {
                message = localize{type = 'variable', key = 'a_xmult', vars = {value}},
                Xmult_mod = value
            }
	    end
    end
}

local mercury_gx = gx_enabled and SMODS.Consumable{
    key = "mercury_gx",
    set = "planet_gx",
    config = {
        hand = {
            hand_types = {
                'High Card',
                'Pair',
                'Two Pair',
            },
            --softlock = true
        },
        extra = 3,
    },
    pos = {
        x = 1,
        y = 0,
    },
    cost = 15,
    atlas = "planet_gx",
    unlocked = false or Ceres.CONFIG.misc.unlock_all.enabled,
    discovered = false or Ceres.CONFIG.misc.discover_all.enabled,

    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.hand.hand_types[1], card.ability.hand.hand_types[2], card.ability.hand.hand_types[3], card.ability.extra}}
    end,

    can_use = function(self, card)
        return true
    end,
    
    use = function(self, card, area, copier)
        for i = 1, #card.ability.hand.hand_types do
            update_hand_text({sound = 'button', volume = 0.7, pitch = 0.8, delay = 0.3}, {handname=card.ability.hand.hand_types[i],chips = G.GAME.hands[card.ability.hand.hand_types[i]].chips, mult = G.GAME.hands[card.ability.hand.hand_types[i]].mult, level=G.GAME.hands[card.ability.hand.hand_types[i]].level})
            level_up_hand(card, card.ability.hand.hand_types[i], nil, card.ability.extra)
        end
        update_hand_text({sound = 'button', volume = 0.7, pitch = 1.1, delay = 0}, {mult = 0, chips = 0, handname = '', level = ''})
    end,

    calculate = function(self, card, context)
        if G.GAME.used_vouchers.v_observatory and (context.scoring_name == card.ability.hand.hand_types[1] or context.scoring_name == card.ability.hand.hand_types[2] or context.scoring_name == card.ability.hand.hand_types[3]) then
            local value = G.P_CENTERS.v_observatory.config.extra * card.ability.extra
            return {
                message = localize{type = 'variable', key = 'a_xmult', vars = {value}},
                Xmult_mod = value
            }
	    end
    end
}

local uranus_gx = gx_enabled and SMODS.Consumable{
    key = "uranus_gx",
    set = "planet_gx",
    config = {
        hand = {
            hand_types = {
                'Pair',
                'Two Pair',
                'Three of a Kind'
            },
            --softlock = true
        },
        extra = 3,
    },
    pos = {
        x = 1,
        y = 1,
    },
    cost = 15,
    atlas = "planet_gx",
    unlocked = false or Ceres.CONFIG.misc.unlock_all.enabled,
    discovered = false or Ceres.CONFIG.misc.discover_all.enabled,

    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.hand.hand_types[1], card.ability.hand.hand_types[2], card.ability.hand.hand_types[3], card.ability.extra}}
    end,

    can_use = function(self, card)
        return true
    end,
    
    use = function(self, card, area, copier)
        for i = 1, #card.ability.hand.hand_types do
            update_hand_text({sound = 'button', volume = 0.7, pitch = 0.8, delay = 0.3}, {handname=card.ability.hand.hand_types[i],chips = G.GAME.hands[card.ability.hand.hand_types[i]].chips, mult = G.GAME.hands[card.ability.hand.hand_types[i]].mult, level=G.GAME.hands[card.ability.hand.hand_types[i]].level})
            level_up_hand(card, card.ability.hand.hand_types[i], nil, card.ability.extra)
        end
        update_hand_text({sound = 'button', volume = 0.7, pitch = 1.1, delay = 0}, {mult = 0, chips = 0, handname = '', level = ''})
    end,

    calculate = function(self, card, context)
        if G.GAME.used_vouchers.v_observatory and (context.scoring_name == card.ability.hand.hand_types[1] or context.scoring_name == card.ability.hand.hand_types[2] or context.scoring_name == card.ability.hand.hand_types[3]) then
            local value = G.P_CENTERS.v_observatory.config.extra * card.ability.extra
            return {
                message = localize{type = 'variable', key = 'a_xmult', vars = {value}},
                Xmult_mod = value
            }
	    end
    end
}

local venus_gx = gx_enabled and SMODS.Consumable{
    key = "venus_gx",
    set = "planet_gx",
    config = {
        hand = {
            hand_types = {
                'Two Pair',
                'Three of a Kind',
                'Straight',
            },
            --softlock = true
        },
        extra = 3,
    },
    pos = {
        x = 2,
        y = 0,
    },
    cost = 15,
    atlas = "planet_gx",
    unlocked = false or Ceres.CONFIG.misc.unlock_all.enabled,
    discovered = false or Ceres.CONFIG.misc.discover_all.enabled,

    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.hand.hand_types[1], card.ability.hand.hand_types[2], card.ability.hand.hand_types[3], card.ability.extra}}
    end,

    can_use = function(self, card)
        return true
    end,
    
    use = function(self, card, area, copier)
        for i = 1, #card.ability.hand.hand_types do
            update_hand_text({sound = 'button', volume = 0.7, pitch = 0.8, delay = 0.3}, {handname=card.ability.hand.hand_types[i],chips = G.GAME.hands[card.ability.hand.hand_types[i]].chips, mult = G.GAME.hands[card.ability.hand.hand_types[i]].mult, level=G.GAME.hands[card.ability.hand.hand_types[i]].level})
            level_up_hand(card, card.ability.hand.hand_types[i], nil, card.ability.extra)
        end
        update_hand_text({sound = 'button', volume = 0.7, pitch = 1.1, delay = 0}, {mult = 0, chips = 0, handname = '', level = ''})
    end,

    calculate = function(self, card, context)
        if G.GAME.used_vouchers.v_observatory and (context.scoring_name == card.ability.hand.hand_types[1] or context.scoring_name == card.ability.hand.hand_types[2] or context.scoring_name == card.ability.hand.hand_types[3]) then
            local value = G.P_CENTERS.v_observatory.config.extra * card.ability.extra
            return {
                message = localize{type = 'variable', key = 'a_xmult', vars = {value}},
                Xmult_mod = value
            }
	    end
    end
}

local saturn_gx = gx_enabled and SMODS.Consumable{
    key = "saturn_gx",
    set = "planet_gx",
    config = {
        hand = {
            hand_types = {
                'Three of a Kind',
                'Straight',
                'Flush',
            },
        },
        extra = 3,
    },
    pos = {
        x = 0,
        y = 1,
    },
    cost = 15,
    atlas = "planet_gx",
    unlocked = false or Ceres.CONFIG.misc.unlock_all.enabled,
    discovered = false or Ceres.CONFIG.misc.discover_all.enabled,

    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.hand.hand_types[1], card.ability.hand.hand_types[2], card.ability.hand.hand_types[3], card.ability.extra}}
    end,

    can_use = function(self, card)
        return true
    end,
    
    use = function(self, card, area, copier)
        for i = 1, #card.ability.hand.hand_types do
            update_hand_text({sound = 'button', volume = 0.7, pitch = 0.8, delay = 0.3}, {handname=card.ability.hand.hand_types[i],chips = G.GAME.hands[card.ability.hand.hand_types[i]].chips, mult = G.GAME.hands[card.ability.hand.hand_types[i]].mult, level=G.GAME.hands[card.ability.hand.hand_types[i]].level})
            level_up_hand(card, card.ability.hand.hand_types[i], nil, card.ability.extra)
        end
        update_hand_text({sound = 'button', volume = 0.7, pitch = 1.1, delay = 0}, {mult = 0, chips = 0, handname = '', level = ''})
    end,

    calculate = function(self, card, context)
        if G.GAME.used_vouchers.v_observatory and (context.scoring_name == card.ability.hand.hand_types[1] or context.scoring_name == card.ability.hand.hand_types[2] or context.scoring_name == card.ability.hand.hand_types[3]) then
            local value = G.P_CENTERS.v_observatory.config.extra * card.ability.extra
            return {
                message = localize{type = 'variable', key = 'a_xmult', vars = {value}},
                Xmult_mod = value
            }
	    end
    end
}

local jupiter_gx = gx_enabled and SMODS.Consumable{
    key = "jupiter_gx",
    set = "planet_gx",
    config = {
        hand = {
            hand_types = {
                'Straight',
                'Flush',
                'Full House',
            },
        },
        extra = 3,
    },
    pos = {
        x = 5,
        y = 0,
    },
    cost = 15,
    atlas = "planet_gx",
    unlocked = false or Ceres.CONFIG.misc.unlock_all.enabled,
    discovered = false or Ceres.CONFIG.misc.discover_all.enabled,

    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.hand.hand_types[1], card.ability.hand.hand_types[2], card.ability.hand.hand_types[3], card.ability.extra}}
    end,

    can_use = function(self, card)
        return true
    end,
    
    use = function(self, card, area, copier)
        for i = 1, #card.ability.hand.hand_types do
            update_hand_text({sound = 'button', volume = 0.7, pitch = 0.8, delay = 0.3}, {handname=card.ability.hand.hand_types[i],chips = G.GAME.hands[card.ability.hand.hand_types[i]].chips, mult = G.GAME.hands[card.ability.hand.hand_types[i]].mult, level=G.GAME.hands[card.ability.hand.hand_types[i]].level})
            level_up_hand(card, card.ability.hand.hand_types[i], nil, card.ability.extra)
        end
        update_hand_text({sound = 'button', volume = 0.7, pitch = 1.1, delay = 0}, {mult = 0, chips = 0, handname = '', level = ''})
    end,

    calculate = function(self, card, context)
        if G.GAME.used_vouchers.v_observatory and (context.scoring_name == card.ability.hand.hand_types[1] or context.scoring_name == card.ability.hand.hand_types[2] or context.scoring_name == card.ability.hand.hand_types[3]) then
            local value = G.P_CENTERS.v_observatory.config.extra * card.ability.extra
            return {
                message = localize{type = 'variable', key = 'a_xmult', vars = {value}},
                Xmult_mod = value
            }
	    end
    end
}

local earth_gx = gx_enabled and SMODS.Consumable{
    key = "earth_gx",
    set = "planet_gx",
    config = {
        hand = {
            hand_types = {
                'Flush',
                'Full House',
                'Four of a Kind',
            },
        },
        extra = 3,
    },
    pos = {
        x = 3,
        y = 0,
    },
    cost = 15,
    atlas = "planet_gx",
    unlocked = false or Ceres.CONFIG.misc.unlock_all.enabled,
    discovered = false or Ceres.CONFIG.misc.discover_all.enabled,

    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.hand.hand_types[1], card.ability.hand.hand_types[2], card.ability.hand.hand_types[3], card.ability.extra}}
    end,

    can_use = function(self, card)
        return true
    end,
    
    use = function(self, card, area, copier)
        for i = 1, #card.ability.hand.hand_types do
            update_hand_text({sound = 'button', volume = 0.7, pitch = 0.8, delay = 0.3}, {handname=card.ability.hand.hand_types[i],chips = G.GAME.hands[card.ability.hand.hand_types[i]].chips, mult = G.GAME.hands[card.ability.hand.hand_types[i]].mult, level=G.GAME.hands[card.ability.hand.hand_types[i]].level})
            level_up_hand(card, card.ability.hand.hand_types[i], nil, card.ability.extra)
        end
        update_hand_text({sound = 'button', volume = 0.7, pitch = 1.1, delay = 0}, {mult = 0, chips = 0, handname = '', level = ''})
    end,

    calculate = function(self, card, context)
        if G.GAME.used_vouchers.v_observatory and (context.scoring_name == card.ability.hand.hand_types[1] or context.scoring_name == card.ability.hand.hand_types[2] or context.scoring_name == card.ability.hand.hand_types[3]) then
            local value = G.P_CENTERS.v_observatory.config.extra * card.ability.extra
            return {
                message = localize{type = 'variable', key = 'a_xmult', vars = {value}},
                Xmult_mod = value
            }
	    end
    end
}

local mars_gx = gx_enabled and SMODS.Consumable{
    key = "mars_gx",
    set = "planet_gx",
    config = {
        hand = {
            hand_types = {
                'Full House',
                'Four of a Kind',
                'Straight Flush',
            },
        },
        extra = 3,
    },
    pos = {
        x = 4,
        y = 0,
    },
    cost = 15,
    atlas = "planet_gx",
    unlocked = false or Ceres.CONFIG.misc.unlock_all.enabled,
    discovered = false or Ceres.CONFIG.misc.discover_all.enabled,

    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.hand.hand_types[1], card.ability.hand.hand_types[2], card.ability.hand.hand_types[3], card.ability.extra}}
    end,

    can_use = function(self, card)
        return true
    end,
    
    use = function(self, card, area, copier)
        for i = 1, #card.ability.hand.hand_types do
            update_hand_text({sound = 'button', volume = 0.7, pitch = 0.8, delay = 0.3}, {handname=card.ability.hand.hand_types[i],chips = G.GAME.hands[card.ability.hand.hand_types[i]].chips, mult = G.GAME.hands[card.ability.hand.hand_types[i]].mult, level=G.GAME.hands[card.ability.hand.hand_types[i]].level})
            level_up_hand(card, card.ability.hand.hand_types[i], nil, card.ability.extra)
        end
        update_hand_text({sound = 'button', volume = 0.7, pitch = 1.1, delay = 0}, {mult = 0, chips = 0, handname = '', level = ''})
    end,

    calculate = function(self, card, context)
        if G.GAME.used_vouchers.v_observatory and (context.scoring_name == card.ability.hand.hand_types[1] or context.scoring_name == card.ability.hand.hand_types[2] or context.scoring_name == card.ability.hand.hand_types[3]) then
            local value = G.P_CENTERS.v_observatory.config.extra * card.ability.extra
            return {
                message = localize{type = 'variable', key = 'a_xmult', vars = {value}},
                Xmult_mod = value
            }
	    end
    end
}

local neptune_gx = gx_enabled and SMODS.Consumable{
    key = "neptune_gx",
    set = "planet_gx",
    config = {
        hand = {
            hand_types = {
                'Four of a Kind',
                'Straight Flush',
                'Five of a Kind',
            },
        },
        extra = 3,
    },
    pos = {
        x = 2,
        y = 1,
    },
    cost = 15,
    atlas = "planet_gx",
    unlocked = false or Ceres.CONFIG.misc.unlock_all.enabled,
    discovered = false or Ceres.CONFIG.misc.discover_all.enabled,

    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.hand.hand_types[1], card.ability.hand.hand_types[2], card.ability.hand.hand_types[3], card.ability.extra}}
    end,

    can_use = function(self, card)
        return true
    end,
    
    use = function(self, card, area, copier)
        for i = 1, #card.ability.hand.hand_types do
            update_hand_text({sound = 'button', volume = 0.7, pitch = 0.8, delay = 0.3}, {handname=card.ability.hand.hand_types[i],chips = G.GAME.hands[card.ability.hand.hand_types[i]].chips, mult = G.GAME.hands[card.ability.hand.hand_types[i]].mult, level=G.GAME.hands[card.ability.hand.hand_types[i]].level})
            level_up_hand(card, card.ability.hand.hand_types[i], nil, card.ability.extra)
        end
        update_hand_text({sound = 'button', volume = 0.7, pitch = 1.1, delay = 0}, {mult = 0, chips = 0, handname = '', level = ''})
    end,

    calculate = function(self, card, context)
        if G.GAME.used_vouchers.v_observatory and (context.scoring_name == card.ability.hand.hand_types[1] or context.scoring_name == card.ability.hand.hand_types[2] or context.scoring_name == card.ability.hand.hand_types[3]) then
            local value = G.P_CENTERS.v_observatory.config.extra * card.ability.extra
            return {
                message = localize{type = 'variable', key = 'a_xmult', vars = {value}},
                Xmult_mod = value
            }
	    end
    end
}

local planetx_gx = gx_enabled and SMODS.Consumable{
    key = "planetx_gx",
    set = "planet_gx",
    config = {
        hand = {
            hand_types = {
                'Straight Flush',
                'Five of a Kind',
                'Flush House',
            },
        },
        extra = 3,
    },
    pos = {
        x = 5,
        y = 1,
    },
    cost = 15,
    atlas = "planet_gx",
    unlocked = false or Ceres.CONFIG.misc.unlock_all.enabled,
    discovered = false or Ceres.CONFIG.misc.discover_all.enabled,

    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.hand.hand_types[1], card.ability.hand.hand_types[2], card.ability.hand.hand_types[3], card.ability.extra}}
    end,

    can_use = function(self, card)
        return true
    end,
    
    use = function(self, card, area, copier)
        for i = 1, #card.ability.hand.hand_types do
            update_hand_text({sound = 'button', volume = 0.7, pitch = 0.8, delay = 0.3}, {handname=card.ability.hand.hand_types[i],chips = G.GAME.hands[card.ability.hand.hand_types[i]].chips, mult = G.GAME.hands[card.ability.hand.hand_types[i]].mult, level=G.GAME.hands[card.ability.hand.hand_types[i]].level})
            level_up_hand(card, card.ability.hand.hand_types[i], nil, card.ability.extra)
        end
        update_hand_text({sound = 'button', volume = 0.7, pitch = 1.1, delay = 0}, {mult = 0, chips = 0, handname = '', level = ''})
    end,

    calculate = function(self, card, context)
        if G.GAME.used_vouchers.v_observatory and (context.scoring_name == card.ability.hand.hand_types[1] or context.scoring_name == card.ability.hand.hand_types[2] or context.scoring_name == card.ability.hand.hand_types[3]) then
            local value = G.P_CENTERS.v_observatory.config.extra * card.ability.extra
            return {
                message = localize{type = 'variable', key = 'a_xmult', vars = {value}},
                Xmult_mod = value
            }
	    end
    end
}

local ceres_gx = gx_enabled and SMODS.Consumable{
    key = "ceres_gx",
    set = "planet_gx",
    config = {
        hand = {
            hand_types = {
                'Five of a Kind',
                'Flush House',
                'Flush Five',
            },
        },
        extra = 3,
    },
    pos = {
        x = 4,
        y = 1,
    },
    cost = 15,
    atlas = "planet_gx",
    unlocked = false or Ceres.CONFIG.misc.unlock_all.enabled,
    discovered = false or Ceres.CONFIG.misc.discover_all.enabled,

    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.hand.hand_types[1], card.ability.hand.hand_types[2], card.ability.hand.hand_types[3], card.ability.extra}}
    end,

    can_use = function(self, card)
        return true
    end,
    
    use = function(self, card, area, copier)
        for i = 1, #card.ability.hand.hand_types do
            update_hand_text({sound = 'button', volume = 0.7, pitch = 0.8, delay = 0.3}, {handname=card.ability.hand.hand_types[i],chips = G.GAME.hands[card.ability.hand.hand_types[i]].chips, mult = G.GAME.hands[card.ability.hand.hand_types[i]].mult, level=G.GAME.hands[card.ability.hand.hand_types[i]].level})
            level_up_hand(card, card.ability.hand.hand_types[i], nil, card.ability.extra)
        end
        update_hand_text({sound = 'button', volume = 0.7, pitch = 1.1, delay = 0}, {mult = 0, chips = 0, handname = '', level = ''})
    end,

    calculate = function(self, card, context)
        if G.GAME.used_vouchers.v_observatory and (context.scoring_name == card.ability.hand.hand_types[1] or context.scoring_name == card.ability.hand.hand_types[2] or context.scoring_name == card.ability.hand.hand_types[3]) then
            local value = G.P_CENTERS.v_observatory.config.extra * card.ability.extra
            return {
                message = localize{type = 'variable', key = 'a_xmult', vars = {value}},
                Xmult_mod = value
            }
	    end
    end
}

local eris_gx = gx_enabled and SMODS.Consumable{
    key = "eris_gx",
    set = "planet_gx",
    config = {
        hand = {
            hand_types = {
                'Five of a Kind',
                'Flush House',
                'Flush Five',
            },
        },
        extra = 3,
    },
    pos = {
        x = 0,
        y = 2,
    },
    cost = 15,
    atlas = "planet_gx",
    unlocked = false or Ceres.CONFIG.misc.unlock_all.enabled,
    discovered = false or Ceres.CONFIG.misc.discover_all.enabled,

    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.hand.hand_types[1], card.ability.hand.hand_types[2], card.ability.hand.hand_types[3], card.ability.extra}}
    end,

    can_use = function(self, card)
        return true
    end,
    
    use = function(self, card, area, copier)
        for i = 1, #card.ability.hand.hand_types do
            update_hand_text({sound = 'button', volume = 0.7, pitch = 0.8, delay = 0.3}, {handname=card.ability.hand.hand_types[i],chips = G.GAME.hands[card.ability.hand.hand_types[i]].chips, mult = G.GAME.hands[card.ability.hand.hand_types[i]].mult, level=G.GAME.hands[card.ability.hand.hand_types[i]].level})
            level_up_hand(card, card.ability.hand.hand_types[i], nil, card.ability.extra)
        end
        update_hand_text({sound = 'button', volume = 0.7, pitch = 1.1, delay = 0}, {mult = 0, chips = 0, handname = '', level = ''})
    end,

    calculate = function(self, card, context)
        if G.GAME.used_vouchers.v_observatory and (context.scoring_name == card.ability.hand.hand_types[1] or context.scoring_name == card.ability.hand.hand_types[2] or context.scoring_name == card.ability.hand.hand_types[3]) then
            local value = G.P_CENTERS.v_observatory.config.extra * card.ability.extra
            return {
                message = localize{type = 'variable', key = 'a_xmult', vars = {value}},
                Xmult_mod = value
            }
	    end
    end
}