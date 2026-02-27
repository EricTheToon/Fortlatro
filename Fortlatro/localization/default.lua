return {
    descriptions = {
		--[[ --zorlodo is fucking dead i dont have to do this anymore lmao
        Joker = {
            j_space = {
                name = "Space Force", -- this is really stupid but zorlodo really wanted it because hes in the space force 
                text = {
                    "{C:green}#1# in #2#{} chance to",
                    "upgrade level of",
                    "played {C:attention}poker hand{}"
                }
            }
        },
		--]]
        Edition = {
            e_fn_Nitro = {
                name = "Nitro",
                text = {
                    "{C:attention}+2{} hand size",
                    "Idea: Boi Rowan",
                },
            },

            e_fn_Nitro_playing_card = {
                name = "Nitro",
                text = {
                    "{C:attention}+2{} hand size when {C:attention}played{}",
                    "{C:attention}Resets{} at end of round{}",
                    "Idea: Boi Rowan",
                },
            },

            e_fn_Shockwaved = {
                name = "Shockwaved",
                text = {
                    "{C:green}#1# in 3{} chance to retrigger adjacent {C:attention}Jokers{}",
                    "Idea: Boi Rowan",
                },
            },

            e_fn_Shockwaved_playing_card = {
                name = "Shockwaved",
                text = {
                    "Retriggers adjacent played cards once",
                    "Idea: Boi Rowan",
                },
            },

            e_fn_Mythic = {
                name = "Mythic",
                text = {
                    "{X:mult,C:white}X4{} to {C:attention}ALL{} values on this card",
                    "{C:attention}-1{} Joker Slot",
                    "Idea: BoiRowan",
                },
            },

            e_fn_Mythic_consumable = {
                name = "Mythic",
                text = {
                    "{X:mult,C:white}X4{} to {C:attention}ALL{} values on this card",
                    "{C:attention}-1{} Consumable Slot",
                    "Idea: BoiRowan",
                },
            },

            e_fn_Mythic_playing_card = {
                name = "Mythic",
                text = {
                    "{X:mult,C:white}X4{} to {C:attention}ALL{} values on this card",
                    "{C:attention}-1{} Handsize",
                    "Idea: BoiRowan",
                },
            },

            e_fn_Overshielded = {
                name = "Overshielded",
                text = {
                    "Cannot be {C:mult}debuffed{}",
                    "Prevent {C:attention}adjacent{} Jokers from being {C:mult}debuffed{}",
                    "Idea: BoiRowan",
                },
            },

            e_fn_Overshielded_consumable = {
                name = "Overshielded",
                text = {
                    "Cannot be {C:mult}debuffed{}",
                    "Prevent {C:attention}adjacent{} Consumables from being {C:mult}debuffed{}",
                    "Idea: BoiRowan",
                },
            },

            e_fn_Overshielded_playing_card = {
                name = "Overshielded",
                text = {
                    "Cannot be {C:mult}debuffed{}",
                    "Prevent {C:attention}adjacent{} Cards from being {C:mult}debuffed{}",
                    "Idea: BoiRowan",
                },
            },

            e_fn_Cell = {
                name = "Cel Shaded",
                text = {
                    "{C:attention}+1{} to {C:attention}ALL{} values on this card",
                },
            },

            e_fn_Shard = {
                name = "Crystal Shard",
                text = {
                    "???",
                },
            },
        },

        Other = {
            fn_Luck_Aura = {
                name = "Luck Aura",
                text = {
                    "All {C:green}probabilities{} are {C:green}guaranteed{}",
                }
            },

            fn_Fire_Aura = {
                name = "Fire Aura",
                text = {
                    "{X:spectral,C:white}^2{} Chips",
                }
            },

            fn_Based_Aura = {
                name = "Based Aura",
                text = {
                    "This and {C:attention}Adjacent{} cards permanently gain {C:chips}+5{} Chips and {C:mult}+1{} Mult",
                }
            },
        }
    },

    misc = {
        dictionary = {
            --b_cash_out = "Crash Out", --stupid thing to make cash out crash out not implementing this lol

            fn_LTMBooster1 = "LTM Pack",
            fn_LTMBooster2 = "MEGA LTM Pack",
            fn_AugmentBooster = "Augment Pack",
            fn_AugmentBooster2 = "MEGA Augment Pack",
            fn_ui_auras = "Auras",
        },

        quips = {
            fn_example_quip = { "Victory Royale!" },
            fn_example_quip2 = { "You placed 99th" },
            fn_example_quip3 = { "*Does Take The L*" },

            fn_eric_quip_1 = { "LETS GOOOO" },
            fn_eric_quip_2 = { "How did bro lose with me :skull:" },

            fn_emily_quip_1 = { "ZINGO!!!!!" },

            fn_kxtty_quip_1 = { "Guess I negatived your win too?" },
            fn_kxtty_quip_2 = { "You're still a winner! Just not at this game." },
            fn_kxtty_quip_3 = { "Negative and negative SHOULD equal positive." },
        },

        labels = {
            fn_Nitro = "Nitro",
            fn_Shockwaved = "Shockwaved",
            fn_Mythic = "Mythic",
            fn_Overshielded = "Overshielded",
            fn_Cell = "Cel Shaded",
            fn_Shard = "Crystal Shard",
            fn_Luck_Aura = "Luck Aura",
            fn_Fire_Aura = "Fire Aura",
            fn_Based_Aura = "Based Aura",
        }
    }
}
