local jd_def = JokerDisplay.Definitions

-- Egg Basket
jd_def["j_snow_egg_basket"] = {
	text = {
        { text = "(" },
        { text = "$", colour = G.C.GOLD },
        { ref_table = "card", ref_value = "sell_cost", colour = G.C.GOLD },
        { text = ")" },
    },
	extra = {
        {
            { text = "(" },
            { ref_table = "card.joker_display_values", ref_value = "odds" },
            { text = " in 4)" },
        }
    },
    extra_config = { colour = G.C.GREEN, scale = 0.3 },
    calc_function = function(card)
        card.joker_display_values.odds = G.GAME and G.GAME.probabilities.normal or 1
    end
}

-- Ritual Sacrifice
jd_def["j_snow_ritual_sacrifice"] = {
	text = {
        { text = "(" },
        { ref_table = "card.joker_display_values", ref_value = "current" },
        { text = "/" },
        { ref_table = "card.joker_display_values", ref_value = "limit" },
        { text = ")" },
    },
    calc_function = function(card)
        card.joker_display_values.limit = G.consumeables.config.card_limit
        card.joker_display_values.current = #G.consumeables.cards
    end
}

-- 7th Heaven
jd_def["j_snow_seventh_heaven"] = {
	text = {
        { text = "judgement on 7" },
    },
	extra = {
        {
            { text = "Plus" },
        }
    },
    extra_config = { colour = G.C.GREEN, scale = 0.3 },
}

-- Dawn Deck
jd_def["j_snow_dawn_deck"] = {
	text = {
        { text = "on final hand" },
    },
	extra = {
        {
            { text = "Retrigger twice" },
        }
    },
    extra_config = { colour = G.C.GOLD, scale = 0.3 },
}

-- Clover
jd_def["j_snow_clover"] = {
	text = {
        { text = "Rerolls -$" },
        { ref_table = "card.joker_display_values", ref_value = "cash" }
    },
    text_config = { colour = G.C.GOLD },
    extra = {
        {
            { text = "(" },
            { ref_table = "card.joker_display_values", ref_value = "odds" },
            { text = " in 4)" },
        }
    },
    extra_config = { colour = G.C.GREEN, scale = 0.3 },
    calc_function = function(card)
        card.joker_display_values.odds = G.GAME and G.GAME.probabilities.normal or 1
        card.joker_display_values.cash = card.ability.extra.money
    end
}

-- Verdant Shift
jd_def["j_snow_verdant_shift"] = {
	text = {
        { text = "+" },
        { ref_table = "card.joker_display_values", ref_value = "chips" },
        { text = " Chips, +" },
        { ref_table = "card.joker_display_values", ref_value = "mult" },
        { text = " Mult" },
    },
    text_config = { colour = G.C.purple },
    extra = {
        {
            { text = "" },
            { ref_table = "card.joker_display_values", ref_value = "curseason" }
        }
    },
    extra_config = { colour = G.C.black, scale = 0.3 },
    calc_function = function(card)
        card.joker_display_values.curseason = card.ability.extra.curseason
        card.joker_display_values.chips = card.ability.extra.current_chips
        card.joker_display_values.mult = card.ability.extra.current_mult
    end
}

-- Fool's Fortune
jd_def["j_snow_fools_fortune"] = {
	text = {
        { text = "get fools" },
    },
	extra = {
        {
            { text = "Sell to" },
        }
    },
    extra_config = { colour = G.C.GREY, scale = 0.3 },
}

-- Combat Confection
jd_def["j_snow_combat_confection"] = {
	text = {
        { text = "X" },
        { ref_table = "card.joker_display_values", ref_value = "Xmult" }
    },
    text_config = { colour = G.C.MULT },
    calc_function = function(card)
        card.joker_display_values.Xmult = card.ability.extra.current_Xmult
    end
}

-- Black Swan
jd_def["j_snow_black_swan"] = {
	text = {
        { text = "+" },
        { ref_table = "card.joker_display_values", ref_value = "mult" }
    },
    text_config = { colour = G.C.MULT },
    reminder_text = {
        { text = "(K,K/Q,Q/J,J)" },
    },
    calc_function = function(card)
        card.joker_display_values.mult = card.ability.extra.current_mult
    end
}

-- Love Is Blind
jd_def["j_snow_love_is_blind"] = {
	text = {
        {
            border_nodes = {
                { text = "X3" },
            }
        }
    },
	extra = {
        {
            { text = "Debuffs Hearts" },
        }
    },
    extra_config = { colour = G.C.RED, scale = 0.3 },
}

-- Turkey Dinner
jd_def["j_snow_turkey_dinner"] = {
	text = {
        { text = "Win", colour = G.C.GREEN },
    },
	extra = {
        {
            { text = "Sell to" },
        }
    },
    extra_config = { colour = G.C.GREY, scale = 0.3 },
}

-- Chick
jd_def["j_snow_chick"] = {
	text = {
        { text = "(" },
        { text = "$", colour = G.C.GOLD },
        { ref_table = "card", ref_value = "sell_cost", colour = G.C.GOLD },
        { text = ")" },
    },
}

-- Opps! All Glorbs!
jd_def["j_snow_opps_all_glorbsDice"] = {
	extra = {
        {
            { text = "(1/3) -> (" },
            { ref_table = "card.joker_display_values", ref_value = "odds" },
            { text = " in 3)" },
        }
    },
    extra_config = { colour = G.C.GREEN, scale = 0.3 },
    calc_function = function(card)
        card.joker_display_values.odds = G.GAME and G.GAME.probabilities.normal or 1
    end
}

-- What? No Numbers?
jd_def["j_snow_what_no_numbersDice"] = {
	extra = {
        {
            { text = "(1/3) -> (" },
            { ref_table = "card.joker_display_values", ref_value = "odds" },
            { text = " in 3)" },
        }
    },
    extra_config = { colour = G.C.GREEN, scale = 0.3 },
    calc_function = function(card)
        card.joker_display_values.odds = G.GAME and G.GAME.probabilities.normal or 1
    end
}

-- Sicherman
jd_def["j_snow_sichermanDice"] = {
	extra = {
        {
            { text = "(1/3) -> (" },
            { ref_table = "card.joker_display_values", ref_value = "odds" },
            { text = " in 3)" },
        }
    },
    extra_config = { colour = G.C.GREEN, scale = 0.3 },
    calc_function = function(card)
        card.joker_display_values.odds = G.GAME and G.GAME.probabilities.normal or 1
    end
}

-- AAAH?! It's Infinity!?
jd_def["j_snow_infinityDice"] = {
	extra = {
        {
            { text = "(1/3) -> (" },
            { ref_table = "card.joker_display_values", ref_value = "odds" },
            { text = " in 3)" },
        }
    },
    extra_config = { colour = G.C.GREEN, scale = 0.3 },
    calc_function = function(card)
        card.joker_display_values.odds = G.GAME and G.GAME.probabilities.normal or 1
    end
}

-- Fudge Dice
jd_def["j_snow_fudgeDice"] = {
	extra = {
        {
            { text = "(1/3) -> (" },
            { ref_table = "card.joker_display_values", ref_value = "odds" },
            { text = " in 3)" },
        }
    },
    extra_config = { colour = G.C.GREEN, scale = 0.3 },
    calc_function = function(card)
        card.joker_display_values.odds = G.GAME and G.GAME.probabilities.normal or 1
    end
}

-- Flux Dice
jd_def["j_snow_fluxDice"] = {
	extra = {
        {
            { text = "(1/3) -> (" },
            { ref_table = "card.joker_display_values", ref_value = "odds" },
            { text = " in 3)" },
        }
    },
    extra_config = { colour = G.C.GREEN, scale = 0.3 },
    calc_function = function(card)
        card.joker_display_values.odds = G.GAME and G.GAME.probabilities.normal or 1
    end
}

-- Oops! All Oops!
jd_def["j_snow_oops_all_oopsDice"] = {
	text = {
        { text = "Die Of Dice", colour = G.C.GREEN },
    },
}

-- Coin
jd_def["j_snow_coin"] = {
	text = {
        { text = "+" },
        { ref_table = "card.joker_display_values", ref_value = "mult" }
    },
    text_config = { colour = G.C.MULT },
    extra = {
        {
            { text = "(" },
            { ref_table = "card.joker_display_values", ref_value = "odds" },
            { text = " in 2)" },
        }
    },
    extra_config = { colour = G.C.GREEN, scale = 0.3 },
    calc_function = function(card)
        card.joker_display_values.odds = G.GAME and G.GAME.probabilities.normal or 1
        card.joker_display_values.mult = card.ability.extra.mult
    end
}

-- Heart Coin
jd_def["j_snow_heart_coin"] = {
	text = {
        { text = "X" },
        { ref_table = "card.joker_display_values", ref_value = "Xmult" }
    },
    text_config = { colour = G.C.MULT },
    extra = {
        {
            { text = "(" },
            { ref_table = "card.joker_display_values", ref_value = "odds" },
            { text = " in 2)" },
        }
    },
    extra_config = { colour = G.C.GREEN, scale = 0.3 },
    reminder_text = {
        { text = "(" },
        {
            ref_table = "card.joker_display_values",
            ref_value = "localized_text",
            colour = lighten(loc_colour(G.P_CENTERS["j_lusty_joker"].config.extra.suit:lower()), 0.35)
        },
        { text = ")", colour = G.C.UI.TEXT_INACTIVE },
    },
    calc_function = function(card)
        card.joker_display_values.odds = G.GAME and G.GAME.probabilities.normal or 1
        card.joker_display_values.Xmult = card.ability.extra.current_Xmult
        card.joker_display_values.localized_text = localize('Hearts', 'suits_plural')
    end
}

-- Club Coin
jd_def["j_snow_club_coin"] = {
	text = {
        { text = "+" },
        { ref_table = "card.joker_display_values", ref_value = "mult" }
    },
    text_config = { colour = G.C.MULT },
    extra = {
        {
            { text = "(" },
            { ref_table = "card.joker_display_values", ref_value = "odds" },
            { text = " in 2)" },
        }
    },
    extra_config = { colour = G.C.GREEN, scale = 0.3 },
    reminder_text = {
        { text = "(" },
        {
            ref_table = "card.joker_display_values",
            ref_value = "localized_text",
            colour = lighten(loc_colour(G.P_CENTERS["j_gluttenous_joker"].config.extra.suit:lower()), 0.35)
        },
        { text = ")" },
    },
    calc_function = function(card)
        card.joker_display_values.odds = G.GAME and G.GAME.probabilities.normal or 1
        card.joker_display_values.mult = card.ability.extra.mult
        card.joker_display_values.localized_text = localize('Clubs', 'suits_plural')
    end
}

-- Spade Coin
jd_def["j_snow_spade_coin"] = {
	text = {
        { text = "+" },
        { ref_table = "card.joker_display_values", ref_value = "chips" }
    },
    text_config = { colour = G.C.BLUE },
    extra = {
        {
            { text = "(" },
            { ref_table = "card.joker_display_values", ref_value = "odds" },
            { text = " in 2)" },
        }
    },
    extra_config = { colour = G.C.GREEN, scale = 0.3 },
    reminder_text = {
        { text = "(" },
        {
            ref_table = "card.joker_display_values",
            ref_value = "localized_text",
            colour = lighten(loc_colour(G.P_CENTERS["j_wrathful_joker"].config.extra.suit:lower()), 0.35)
        },
        { text = ")", colour = G.C.UI.TEXT_INACTIVE },
    },
    calc_function = function(card)
        card.joker_display_values.odds = G.GAME and G.GAME.probabilities.normal or 1
        card.joker_display_values.chips = card.ability.extra.chips
        card.joker_display_values.localized_text = localize('Spades', 'suits_plural')
    end
}

-- Diamond Coin
jd_def["j_snow_diamond_coin"] = {
	text = {
        { text = "+$" },
        { ref_table = "card.joker_display_values", ref_value = "money" }
    },
    text_config = { colour = G.C.GOLD },
    extra = {
        {
            { text = "(" },
            { ref_table = "card.joker_display_values", ref_value = "odds" },
            { text = " in 2)" },
        }
    },
    extra_config = { colour = G.C.GREEN, scale = 0.3 },
    reminder_text = { --
        { text = "(" },
        {
            ref_table = "card.joker_display_values",
            ref_value = "localized_text",
            colour = lighten(loc_colour(G.P_CENTERS["j_greedy_joker"].config.extra.suit:lower()), 0.35)
        },
        { text = ")" },
    },
    calc_function = function(card)
        card.joker_display_values.odds = G.GAME and G.GAME.probabilities.normal or 1
        card.joker_display_values.money = card.ability.extra.money
        card.joker_display_values.localized_text = localize('Diamonds', 'suits_plural')
    end
}

-- Ghost Coin
jd_def["j_snow_ghost_coin"] = {
	text = {
        { text = "X" },
        { ref_table = "card.joker_display_values", ref_value = "Xmult" }
    },
    text_config = { colour = G.C.MULT },
    extra = {
        {
            { text = "(" },
            { ref_table = "card.joker_display_values", ref_value = "odds" },
            { text = " in 10)" },
        }
    },
    extra_config = { colour = G.C.GREEN, scale = 0.3 },
    calc_function = function(card)
        card.joker_display_values.odds = G.GAME and G.GAME.probabilities.normal or 1
        card.joker_display_values.Xmult = card.ability.extra.current_Xmult
    end
}

-- Liquid Coin
jd_def["j_snow_liquid_coin"] = {
	text = {
        { text = "Retriggers:" },
        { ref_table = "card.joker_display_values", ref_value = "retriggers" }
    },
    text_config = { colour = G.C.GOLD },
    extra = {
        {
            { text = "(" },
            { ref_table = "card.joker_display_values", ref_value = "odds" },
            { text = " in 20)" },
        }
    },
    extra_config = { colour = G.C.GREEN, scale = 0.3 },
    calc_function = function(card)
        card.joker_display_values.odds = G.GAME and G.GAME.probabilities.normal or 1
        card.joker_display_values.retriggers = card.ability.extra.num_retriggers
    end
}

-- Metal Coin
jd_def["j_snow_metal_coin"] = {
	text = {
        { text = "Retriggers:" },
        { ref_table = "card.joker_display_values", ref_value = "retriggers" }
    },
    text_config = { colour = G.C.GOLD },
    extra = {
        {
            { text = "(" },
            { ref_table = "card.joker_display_values", ref_value = "odds" },
            { text = " in 4)" },
        }
    },
    extra_config = { colour = G.C.GREEN, scale = 0.3 },
    calc_function = function(card)
        card.joker_display_values.odds = G.GAME and G.GAME.probabilities.normal or 1
        card.joker_display_values.retriggers = card.ability.extra.num_retriggers
    end
}

-- Bent Coin
jd_def["j_snow_bent_coin"] = {
	text = {
        { text = "$(X2|/2):" },
    },
    text_config = { colour = G.C.GOLD },
    extra = {
        {
            { text = "(" },
            { ref_table = "card.joker_display_values", ref_value = "odds" },
            { text = " in 4)" },
        }
    },
    extra_config = { colour = G.C.GREEN, scale = 0.3 },
    calc_function = function(card)
        card.joker_display_values.odds = G.GAME and G.GAME.probabilities.normal or 1
    end
}