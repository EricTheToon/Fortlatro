--- STEAMODDED HEADER
--- MOD_NAME: Fortlatro
--- MOD_ID: Fortlatro
--- MOD_AUTHOR: [EricTheToon]
--- MOD_DESCRIPTION: A terribly coded mod to add Fortnite themed stuff + stuff for my friends to Balatro.
--- BADGE_COLOUR: 672A62
--- PREFIX: fn
--- PRIORITY: -10
--- DEPENDENCIES: [Steamodded>=0.9.8, Talisman>=2.0.0-beta8,]
--- VERSION: 1.1.8 Release
----------------------------------------------
------------MOD CODE -------------------------
SMODS.optional_features.cardareas.unscored = true
SMODS.current_mod.optional_features = function()
    return {
        retrigger_joker = true,
		post_trigger = true,
    }
end

-- if you ever get a good logo remove the --[['s 
--[[
SMODS.Atlas{
	key = 'balatro',
    path = 'balatro.png',
    px = 332 ,
    py = 216 ,
    prefix_config = {key = false}
}
--]]

local fn = loc_colour
function loc_colour(_c, _default)
    if not G.ARGS.LOC_COLOURS then
        fn()
    end

	G.ARGS.LOC_COLOURS.fn_nitro = HEX("fc7f34")
	G.ARGS.LOC_COLOURS.fn_shockwaved = HEX("4e4bc3")
	G.ARGS.LOC_COLOURS.fn_boogie = HEX("171711")
	G.ARGS.LOC_COLOURS.fn_eternal = HEX("c65984")
	G.ARGS.LOC_COLOURS.fn_perishable = HEX("687ee7")
	
    return fn(_c, _default)
end



SMODS.Atlas({
    key = 'modicon',
    path = 'modicon.png',
    px = '34',
    py = '34'
})

SMODS.current_mod.config_tab = function()
    local scale = 5/6
    return {n=G.UIT.ROOT, config = {align = "cl", minh = G.ROOM.T.h*0.25, padding = 0.0, r = 0.1, colour = G.C.GREY}, nodes = {
        {n = G.UIT.R, config = { padding = 0.05 }, nodes = {
            {n = G.UIT.C, config = { minw = G.ROOM.T.w*0.25, padding = 0.05 }, nodes = {
                create_toggle{ label = "Toggle SFX", info = {"Enable Sound Effects"}, active_colour = Fortlatro.badge_colour, ref_table = Fortlatro.config, ref_value = "sfx" },
                create_toggle{ label = "Toggle Crac SFX", info = {"Enable Sound Effects for Crac Joker"}, active_colour = Fortlatro.badge_colour, ref_table = Fortlatro.config, ref_value = "cracsfx" },
				create_toggle{ label = "Toggle LeftHandedDeath", info = {"Enable Left Handed Death"}, active_colour = Fortlatro.badge_colour, ref_table = Fortlatro.config, ref_value = "deathcompat" },
				create_toggle{ label = "Toggle Blinds", info = {"Enable additional blinds added by this mod"}, active_colour = Fortlatro.badge_colour, ref_table = Fortlatro.config, ref_value = "blinds" },
                create_toggle{ label = "Cryptid Compatibility", info = {"Enable bonus Cryptid content"}, active_colour = Fortlatro.badge_colour, ref_table = Fortlatro.config, ref_value = "cryptidcompat" },
                create_toggle{ label = "Ortalab Compatibility", info = {"Enable bonus Ortalab content"}, active_colour = Fortlatro.badge_colour, ref_table = Fortlatro.config, ref_value = "ortalabcompat" },
                create_toggle{ label = "Old Calc Compatibility", info = {"Enable if using Steamodded Old Calc"}, active_colour = Fortlatro.badge_colour, ref_table = Fortlatro.config, ref_value = "oldcalccompat" },
                create_toggle{ label = "New Calc Compatibility", info = {"Enable if using Steamodded New Calc"}, active_colour = Fortlatro.badge_colour, ref_table = Fortlatro.config, ref_value = "newcalccompat" }
            }}
        }}
    }}
end


Fortlatro = SMODS.current_mod
-- Load Options
Fortlatro_config = Fortlatro.config
-- This will save the current state even when settings are modified
Fortlatro.enabled = copy_table(Fortlatro_config)

local config = SMODS.current_mod.config
----------------------------------------------
------------ERIC CODE BEGIN----------------------

SMODS.Sound({
	key = "edie",
	path = "edie.ogg",
})

SMODS.Atlas{
    key = 'Jokers', --atlas key
    path = 'Jokers.png', --atlas' path in (yourMod)/assets/1x or (yourMod)/assets/2x
    px = 71.1, --width of one card
    py = 95 -- height of one card
}
SMODS.Joker{
    key = 'Eric', -- joker key
    loc_txt = { -- local text
        name = 'Eric',
        text = {
            'He stole your wallet but I think he\'s trying to help?',
            'When {C:attention}Blind is selected{}',
            'create {C:attention}3{} random Jokers',
            '{C:inactive}(No need to have room)',
            'lose {C:money}$5{} at end of round'
        },
        --[[unlock = {
            'Be {C:legendary}cool{}',
        }]]
    },
    atlas = 'Jokers', -- atlas' key
    rarity = 4, -- rarity: 1 = Common, 2 = Uncommon, 3 = Rare, 4 = Legendary
    cost = 1, -- cost
    unlocked = true, -- if true, starts unlocked
    discovered = false, -- whether or not it starts discovered
    blueprint_compat = true, -- can it be blueprinted/brainstormed
    eternal_compat = true, -- can it be eternal
    perishable_compat = false, -- can it be perishable
    pos = {x = 0, y = 0}, -- position in atlas
	pools = { ["Cat"] = true,},
    config = { 
        extra = {}
    },
    loc_vars = function(self, info_queue, center)
        if G.P_CENTERS and G.P_CENTERS.j_joker then
        end
    end,
    check_for_unlock = function(self, args)
        if args.type == 'eric_loves_you' then
            unlock_card(self)
        end
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            return {
                card = card,
            }
        end

        if context.setting_blind then
            for i = 1, 3 do
                local new_card = create_card('Joker', G.jokers, false, nil, nil, nil, nil, "mno")
                new_card:add_to_deck()
                G.jokers:emplace(new_card)
            end
        end
    end,
    in_pool = function(self, wawa, wawa2)
        -- whether or not this card is in the pool, return true if it is, false otherwise
        return true
    end,
    calc_dollar_bonus = function(self, card)
        return -5
    end,
    remove_from_deck = function(self, card)
        -- Play removal sound effect when sold or removed
        if config.sfx ~= false then
            play_sound("fn_edie") 
        end
    end,
}

----------------------------------------------
------------ERIC CODE END----------------------

----------------------------------------------
------------SWORD CODE BEGIN----------------------
SMODS.Sound({
	key = "error",
	path = "error.ogg",
})


SMODS.ConsumableType{
    key = 'LTMConsumableType', --consumable type key

    collection_rows = {5,5}, --amount of cards in one page
    primary_colour = G.C.PURPLE, --first color
    secondary_colour = G.C.PURPLE, --second color
    loc_txt = {
        collection = 'LTM Cards', --name displayed in collection
        name = 'LTM Cards', --name displayed in badge
        undiscovered = {
            name = 'Hidden LTM', --undiscovered name
            text = {'you dont know the', 'playlist id'} --undiscovered text
        }
    },
    shop_rate = 1, --rate in shop out of 100
}


SMODS.UndiscoveredSprite{
    key = 'LTMConsumableType', --must be the same key as the consumabletype
    atlas = 'Jokers',
    pos = {x = 0, y = 0}
}


SMODS.Consumable{
    key = 'LTMSword', -- key
    set = 'LTMConsumableType', -- the set of the card: corresponds to a consumable type
    atlas = 'Jokers', -- atlas
    pos = {x = 1, y = 0}, -- position in atlas
    loc_txt = {
        name = 'Eric\'s Sword', -- name of card
        text = { -- text of card
            'This thing seems VERY unstable',
            'Add a random edition to up to {C:attention}#1#{} selected cards',
        }
    },
    config = {
        extra = {
            cards = 5, -- configurable value
        }
    },
    loc_vars = function(self, info_queue, center)
        if center and center.ability and center.ability.extra then
            return {vars = {center.ability.extra.cards}} 
        end
        return {vars = {}}
    end,
	
    can_use = function(self, card)
        if G and G.hand and G.hand.highlighted and card.ability and card.ability.extra and card.ability.extra.cards then
            if #G.hand.highlighted > 0 and #G.hand.highlighted <= card.ability.extra.cards then
                return true
            end
        end
        return false
    end,
    use = function(self, card, area, copier)
        if config.sfx ~= false then -- Check if sound effects are enabled
            play_sound("slice1")
            play_sound("fn_error")
        end
        if G and G.hand and G.hand.highlighted then
            for i = 1, #G.hand.highlighted do
                G.hand.highlighted[i]:set_edition(poll_edition('random key', nil, false, true))
            end
        end
    end,
}

----------------------------------------------
------------ERIC SWORD CODE END----------------------

----------------------------------------------
------------CRAC CODE BEGIN----------------------
SMODS.Sound({
	key = "arcana",
	path = "arcana.ogg",
})
SMODS.Sound({
	key = "persona",
	path = "persona.ogg",
})
SMODS.Sound({
	key = "all",
	path = "all.ogg",
})
SMODS.Sound({
	key = "wtf",
	path = "wtf.ogg",
})
SMODS.Sound({
	key = "planet",
	path = "planet.ogg",
})
SMODS.Sound({
	key = "double",
	path = "double.ogg",
})
SMODS.Sound({
	key = "sad",
	path = "sad.ogg",
})
SMODS.Sound({
	key = "happy",
	path = "happy.ogg",
})
SMODS.Sound({
	key = "stamp",
	path = "stamp.ogg",
})
SMODS.Sound({
	key = "yoink",
	path = "yoink.ogg",
})
SMODS.Sound({
	key = "lesgo",
	path = "lesgo.ogg",
})
SMODS.Sound({
	key = "nagito",
	path = "nagito.ogg",
})
SMODS.Sound({
	key = "nah",
	path = "nah.ogg",
})
SMODS.Sound({
	key = "fuck",
	path = "fuck.ogg",
})
SMODS.Sound({
	key = "whip",
	path = "whip.ogg",
})
SMODS.Sound({
	key = "evil",
	path = "evil.ogg",
})
SMODS.Sound({
	key = "evil2",
	path = "evil2.ogg",
})
SMODS.Sound({
	key = "nice",
	path = "nice.ogg",
})



SMODS.Atlas{
    key = 'Jokers', --atlas key
    path = 'Jokers.png', --atlas' path in (yourMod)/assets/1x or (yourMod)/assets/2x
    px = 71.1, --width of one card
    py = 95 -- height of one card
}
if config.oldcalccompat ~= false then
SMODS.Joker{
    key = 'Crac',
    loc_txt = {
        ['en-us'] = {
            name = "Crac",
            text = {
                "The Arcana is the means by which all is revealed.",
                "Has a {C:green,E:1,S:1.1}#3# in #2#{} chance to do SOMETHING",
                "{C:inactive}Currently {C:mult}#1#{}{C:inactive} Mult",
            }
        }
    },
    atlas = 'Jokers',
    pos = { x = 2, y = 0 },
    config = {
        extra = { odds = 13, multmod = 50, mult = 13, repetitions = 1 }
    },
    rarity = 3,
    order = 32,
    cost = 13,
    blueprint_compat = true,
    
    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.extra.mult,
                card.ability.extra.odds,
                '' .. (G.GAME and G.GAME.probabilities.normal or 1),
                card.ability.extra.multmod
            }
        }
    end,
	
    calculate = function(self, card, context)
        if context.before then
            if pseudorandom('crac') < G.GAME.probabilities.normal / card.ability.extra.odds then
                local outcome = pseudorandom('crac_outcome')

                if outcome == nil then
                    error("Outcome is nil. Something went wrong with the random generation or the way outcome is calculated.")
                end


                if outcome < 0.0667  then
                    -- x0 multiplier logic
                    card.ability.extra.mult = 0
                    G.GAME.pool_flags.crac_flag = true  -- Set Crac's unique flag
					if config.cracsfx ~= false then
						play_sound("fn_fuck")
					end
                    return {
                        message = "X0 Mult!"
                    }
                elseif outcome < 0.1334 then
                    -- x10 multiplier logic
                    card.ability.extra.mult = card.ability.extra.mult * 10
                    G.GAME.pool_flags.crac_flag = true  -- Set Crac's unique flag
					if config.cracsfx ~= false then
						play_sound("fn_lesgo")
					end
                    return {
                        message = "X10 Mult!"
                    }
                elseif outcome < 0.2001 then
                    -- -50 multiplier logic
                    card.ability.extra.mult = card.ability.extra.mult - 50
                    G.GAME.pool_flags.crac_flag = true  -- Set Crac's unique flag
					if config.cracsfx ~= false then
						play_sound("fn_wtf")
					end
                    return {
                        message = "-50 Mult!"
                    }
                elseif outcome < 0.2668 then
                    -- Summon a random joker
                    local new_card = create_card('Joker', G.jokers, is_soul, nil, nil, nil, nil, "mno")
                    new_card:add_to_deck()
                    G.jokers:emplace(new_card)
                    G.GAME.pool_flags.crac_flag = true  -- Set Crac's unique flag
					if config.cracsfx ~= false then
						play_sound("fn_persona")
					end
                    return {
                        message = "+1 Joker!"
                    }
                elseif outcome < 0.3335 then
                    -- Summon an LTM consumable
                    local new_card = create_card('LTMConsumableType', G.consumeables)
                    new_card:add_to_deck()
                    G.consumeables:emplace(new_card)
                    G.GAME.pool_flags.crac_flag = true  -- Set Crac's unique flag
					if config.cracsfx ~= false then
						play_sound("fn_yoink")
					end
                    return {
                        message = "+1 LTM Card!"
                    }
                elseif outcome < 0.4002 then
                    -- Multiply by -1
                    card.ability.extra.mult = card.ability.extra.mult * -1
                    G.GAME.pool_flags.crac_flag = true  -- Set Crac's unique flag
					if config.cracsfx ~= false then
						play_sound("fn_sad")
					end
                    return {
                        message = "X-1 Mult!"
                    }
                elseif outcome < 0.4669 then
                    -- Summon a random Tarot card
                    local tarot_cards = {
                        'c_fool', 'c_magician', 'c_hanged_man',
                        'c_lovers', 'c_chariot', 'c_hermit',
                        'c_justice', 'c_death', 'c_temperance',
                        'c_devil', 'c_tower', 'c_star', 'c_moon', 'c_sun', 'c_judgement', 'c_world'
                    }
                    local random_card_id = tarot_cards[math.random(1, #tarot_cards)]
                    local _card = create_card('Tarot', G.consumeables, nil, nil, nil, nil, random_card_id)
                    _card:add_to_deck()
                    G.consumeables:emplace(_card)
                    G.GAME.pool_flags.crac_flag = true  -- Set Crac's unique flag
					if config.cracsfx ~= false then
						play_sound("fn_arcana")
					end
                    return {
                        message = "+1 Tarot!"
                    }
                elseif outcome < 0.5336 then
                    -- Summon a Planet card
                    local card_type = 'Planet'
                    G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
                    G.E_MANAGER:add_event(Event({
                        trigger = 'before',
                        delay = 0.0,
                        func = function()
                            local _planet = 0
                            for k, v in pairs(G.P_CENTER_POOLS.Planet) do
                                if v.config.hand_type == context.scoring_name then
                                    _planet = v.key
                                end
                            end
                            local card = create_card(card_type, G.consumeables, nil, nil, nil, nil, _planet, nil)
                            card:add_to_deck()
                            G.consumeables:emplace(card)
                            G.GAME.consumeable_buffer = 0
                            return true
                        end
                    }))
                    G.GAME.pool_flags.crac_flag = true  -- Set Crac's unique flag
					if config.cracsfx ~= false then
						play_sound("fn_planet")
					end
                    return {
                        message = "+1 Planet!"
                    }
                elseif outcome < 0.6003 then
                    -- Normal multiplier logic
                    card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.multmod
                    G.GAME.pool_flags.crac_flag = true  -- Set Crac's unique flag
					if config.cracsfx ~= false then
						play_sound("fn_happy")
					end
                    return {
                        message = "+50 Mult!"
                    }
                elseif outcome < 0.6670 then
                    -- +50 multiplier logic
                    card.ability.extra.mult = card.ability.extra.mult + 50
                    G.GAME.pool_flags.crac_flag = true  -- Set Crac's unique flag
					if config.cracsfx ~= false then
						play_sound("fn_happy")
					end
                    return {
                        message = "+50 Mult!"
                    }
                elseif outcome < 0.7337 then
                    -- Make all scored cards lucky
                    for k, v in ipairs(context.scoring_hand) do
                        v:set_ability(G.P_CENTERS.m_lucky, nil, true)
                        G.E_MANAGER:add_event(Event({
                            func = function()
                                v:juice_up()
                                return true
                            end
                        }))
                    end
                    G.GAME.pool_flags.crac_flag = true  -- Set Crac's unique flag
					if config.cracsfx ~= false then
						play_sound("fn_nagito")
					end
                    return {
                        message = "All scored cards Lucky!"
                    }
                elseif outcome < 0.8004 then
                    -- Double reroll: Select 2 random outcomes
                    local outcomes = {}

                    -- Perform two rerolls
                    for i = 1, 2 do
                        local rerolled_outcome = pseudorandom('crac_outcome')

                        if rerolled_outcome == nil then
                            error("Rerolled outcome is nil. Something went wrong with the random generation.")
                        end

                        -- Determine the outcome of the reroll
                        if rerolled_outcome < 0.0714 then
                            table.insert(outcomes, "x0 multiplier logic")
                            -- x0 multiplier logic
                            card.ability.extra.mult = 0
                            G.GAME.pool_flags.crac_flag = true
                        elseif rerolled_outcome < 0.1428 then
                            table.insert(outcomes, "x10 multiplier logic")
                            -- x10 multiplier logic
                            card.ability.extra.mult = card.ability.extra.mult * 10
                            G.GAME.pool_flags.crac_flag = true
                        elseif rerolled_outcome < 0.2142 then
                            table.insert(outcomes, "-50 multiplier logic")
                            -- -50 multiplier logic
                            card.ability.extra.mult = card.ability.extra.mult - 50
                            G.GAME.pool_flags.crac_flag = true
                        elseif rerolled_outcome < 0.2856 then
                            table.insert(outcomes, "Summon a random joker")
                            -- Summon a random joker
                            local new_card = create_card('Joker', G.jokers, is_soul, nil, nil, nil, nil, "mno")
                            new_card:add_to_deck()
                            G.jokers:emplace(new_card)
                            G.GAME.pool_flags.crac_flag = true
                        elseif rerolled_outcome < 0.3570 then
                            table.insert(outcomes, "Summon an LTM consumable")
                            -- Summon an LTM consumable
                            local new_card = create_card('LTMConsumableType', G.consumeables)
                            new_card:add_to_deck()
                            G.consumeables:emplace(new_card)
                            G.GAME.pool_flags.crac_flag = true
                        elseif rerolled_outcome < 0.4284 then
                            table.insert(outcomes, "Multiply by -1")
                            -- Multiply by -1
                            card.ability.extra.mult = card.ability.extra.mult * -1
                            G.GAME.pool_flags.crac_flag = true
                        elseif rerolled_outcome < 0.4998 then
                            table.insert(outcomes, "Summon a random Tarot card")
                            -- Summon a random Tarot card
                            local tarot_cards = {
                                'c_fool', 'c_magician', 'c_hanged_man',
                                'c_lovers', 'c_chariot', 'c_hermit',
                                'c_justice', 'c_death', 'c_temperance',
                                'c_devil', 'c_tower', 'c_star', 'c_moon', 'c_sun', 'c_judgement', 'c_world'
                            }
                            local random_card_id = tarot_cards[math.random(1, #tarot_cards)]
                            local _card = create_card('Tarot', G.consumeables, nil, nil, nil, nil, random_card_id)
                            _card:add_to_deck()
                            G.consumeables:emplace(_card)
                            G.GAME.pool_flags.crac_flag = true
                        elseif rerolled_outcome < 0.5712 then
                            table.insert(outcomes, "Summon a Planet card")
                            -- Summon a Planet card
                            local card_type = 'Planet'
                            G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
                            G.E_MANAGER:add_event(Event({
                                trigger = 'before',
                                delay = 0.0,
                                func = function()
                                    local _planet = 0
                                    for k, v in pairs(G.P_CENTER_POOLS.Planet) do
                                        if v.config.hand_type == context.scoring_name then
                                            _planet = v.key
                                        end
                                    end
                                    local card = create_card(card_type, G.consumeables, nil, nil, nil, nil, _planet, nil)
                                    card:add_to_deck()
                                    G.consumeables:emplace(card)
                                    G.GAME.consumeable_buffer = 0
                                    return true
                                end
                            }))
                            G.GAME.pool_flags.crac_flag = true
                        elseif rerolled_outcome < 0.6426 then
                            table.insert(outcomes, "Normal multiplier logic")
                            -- Normal multiplier logic
                            card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.multmod
                            G.GAME.pool_flags.crac_flag = true
                        elseif rerolled_outcome < 0.7140 then
                            table.insert(outcomes, "+50 multiplier logic")
                            -- +50 multiplier logic
                            card.ability.extra.mult = card.ability.extra.mult + 50
                            G.GAME.pool_flags.crac_flag = true
                        elseif rerolled_outcome < 0.7854 then
                            table.insert(outcomes, "Make all scored cards lucky")
                            -- Make all scored cards lucky
                            for k, v in ipairs(context.scoring_hand) do
                                v:set_ability(G.P_CENTERS.m_lucky, nil, true)
                                G.E_MANAGER:add_event(Event({
                                    func = function()
                                        v:juice_up()
                                        return true
                                    end
                                }))
                            end
                            G.GAME.pool_flags.crac_flag = true
                        elseif rerolled_outcome < 0.8568 then
                            table.insert(outcomes, "Double reroll")
                            -- Double reroll: Select 2 random outcomes
                        end
                    end
                    G.GAME.pool_flags.crac_flag = true
					if config.cracsfx ~= false then
						play_sound("fn_double")
					end
                    return {
                        message = "DOUBLE OR NOTHING"
                    }
                elseif outcome < 0.8671 then
                    -- Apply random seals to each scored card
                    for k, v in ipairs(context.scoring_hand) do
						-- Apply random seals to each scored card
						for k, v in ipairs(context.scoring_hand) do
							-- Set a random seal using a guaranteed poll method
							v:set_seal(SMODS.poll_seal({key = 'cracsealed', guaranteed = true}), true)
						end
                        -- Add an event to "juice up" the card after sealing
                        G.E_MANAGER:add_event(Event({
                            func = function()
                                v:juice_up(0.3, 0.4)
                                return true
                            end
                        }))
                    end
                    G.GAME.pool_flags.crac_flag = true  -- Set Crac's unique flag
					if config.cracsfx ~= false then
						play_sound("fn_stamp")
					end
                    return {
                        message = "All scored cards sealed!"
                    }
                elseif outcome < 0.9338 then
                    -- Draw the whole deck
					G.FUNCS.draw_from_deck_to_hand(#G.deck.cards)
					G.GAME.pool_flags.crac_flag = true  -- Set Crac's unique flag
					if config.cracsfx ~= false then
						play_sound("fn_all")
					end
					return {
						message = "Draw the whole deck!"
					}
    
				elseif outcome < 1.0000 then
					-- Instant win 
					G.GAME.chips = G.GAME.blind.chips  -- Set chips to blind value
					G.GAME.pool_flags.crac_flag = true  -- Set Crac's unique flag
					if config.cracsfx ~= false then
						play_sound("fn_nah")
					end
					return {
						message = "Nah, i'd win"
					}
                end
            end
        end
		
        if context.joker_main then
        return {
        message = localize {
            type = 'variable',
            key = 'sj_mult',
            vars = { card.ability.extra.mult }
        },
        mult_mod = card.ability.extra.mult,
        card = self
        }
    end
    end,
    remove_from_deck = function(self, card)
        -- Play removal sound effect when sold or removed
        if config.sfx ~= false then
            play_sound("fn_edie") 
        end
    end
}
end

--Neutral Crac
if config.newcalccompat ~= false then
SMODS.Joker{
    key = 'Crac',
    loc_txt = {
        ['en-us'] = {
            name = "Crac",
            text = {
                "Shitpost and Persona Pilled.",
                "{C:green,E:1,S:1.1}#3# in #2#{} odds for ANYTHING. A TRUE Wild Card.",
                "{C:inactive}Currently {C:mult}#1#{}{C:inactive} Mult",
            }
        }
    },
    atlas = 'Jokers',
    pos = { x = 2, y = 0 },
    config = {
        extra = { odds = 13, multmod = 50, mult = 13, repetitions = 1 }
    },
    rarity = 3,
    order = 32,
    cost = 13,
    blueprint_compat = true,

    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.extra.mult,
                card.ability.extra.odds,
                '' .. (G.GAME and G.GAME.probabilities.normal or 1),
                card.ability.extra.multmod
            }
        }
    end,

    calculate = function(self, card, context)
        local function flag_and_maybe_sound(snd)
            G.GAME.pool_flags.crac_flag = true
            if config.cracsfx ~= false and snd then play_sound(snd) end
        end

        local function run_outcome_bucket(bucket, ctx, silent)
            if bucket == 1 then
                card.ability.extra.mult = 0
                flag_and_maybe_sound(silent and nil or "fn_fuck")
                return silent and nil or {message = "X0 Mult!"}

            elseif bucket == 2 then
                card.ability.extra.mult = card.ability.extra.mult * 10
                flag_and_maybe_sound(silent and nil or "fn_lesgo")
                return silent and nil or {message = "X10 Mult!"}

            elseif bucket == 3 then
                card.ability.extra.mult = card.ability.extra.mult - 50
                flag_and_maybe_sound(silent and nil or "fn_wtf")
                return silent and nil or {message = "-50 Mult!"}

            elseif bucket == 4 then
                local new_card = create_card('Joker', G.jokers, is_soul, nil, nil, nil, nil, "mno")
                if new_card then
                    new_card:add_to_deck()
                    G.jokers:emplace(new_card)
                end
                flag_and_maybe_sound(silent and nil or "fn_persona")
                return silent and nil or {message = "+1 Joker!"}

            elseif bucket == 5 then
                local new_card = create_card('LTMConsumableType', G.consumeables)
                if new_card then
                    new_card:add_to_deck()
                    G.consumeables:emplace(new_card)
                end
                flag_and_maybe_sound(silent and nil or "fn_yoink")
                return silent and nil or {message = "+1 LTM Card!"}

            elseif bucket == 6 then
                card.ability.extra.mult = card.ability.extra.mult * -1
                flag_and_maybe_sound(silent and nil or "fn_sad")
                return silent and nil or {message = "X-1 Mult!"}

            elseif bucket == 7 then
                local new_card = create_card('Tarot', G.consumeables)
                if new_card then
                    new_card:add_to_deck()
                    G.consumeables:emplace(new_card)
                end
                flag_and_maybe_sound(silent and nil or "fn_arcana")
                return silent and nil or {message = "+1 Tarot!"}

            elseif bucket == 8 then
                G.GAME.consumeable_buffer = (G.GAME.consumeable_buffer or 0) + 1
                G.E_MANAGER:add_event(Event({
                    trigger = 'before', delay = 0.0,
                    func = function()
                        local _planet = 0
                        for _, v in pairs(G.P_CENTER_POOLS.Planet) do
                            if v and v.config and v.config.hand_type == ctx.scoring_name then
                                _planet = v.key
                            end
                        end
                        if (not _planet) or _planet == 0 then
                            local pool = G.P_CENTER_POOLS.Planet
                            if pool then
                                local list = {}
                                for _, v in pairs(pool) do
                                    if v and v.key then list[#list+1] = v.key end
                                end
                                if #list > 0 then
                                    _planet = list[math.random(1, #list)]
                                end
                            end
                        end
                        local pcard = create_card('Planet', G.consumeables, nil, nil, nil, nil, _planet, nil)
                        if pcard then
                            pcard:add_to_deck()
                            G.consumeables:emplace(pcard)
                        end
                        G.GAME.consumeable_buffer = 0
                        return true
                    end
                }))
                flag_and_maybe_sound(silent and nil or "fn_planet")
                return silent and nil or {message = "+1 Planet!"}

            elseif bucket == 9 then
                card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.multmod
                flag_and_maybe_sound(silent and nil or "fn_happy")
                return silent and nil or {message = "+50 Mult!"}

            elseif bucket == 10 then
                card.ability.extra.mult = card.ability.extra.mult + 50
                flag_and_maybe_sound(silent and nil or "fn_happy")
                return silent and nil or {message = "+50 Mult!"}

            elseif bucket == 11 then
                if ctx.scoring_hand then
                    for _, v in ipairs(ctx.scoring_hand) do
                        v:set_ability(G.P_CENTERS.m_lucky, nil, true)
                        G.E_MANAGER:add_event(Event({
                            func = function() v:juice_up(); return true end
                        }))
                    end
                end
                flag_and_maybe_sound(silent and nil or "fn_nagito")
                return silent and nil or {message = "All scored cards Lucky!"}

            elseif bucket == 12 then
                for i = 1, 2 do
                    local r = pseudorandom('crac_outcome') or 0
                    local b =
                        (r < 0.0667) and 1 or
                        (r < 0.1334) and 2 or
                        (r < 0.2001) and 3 or
                        (r < 0.2668) and 4 or
                        (r < 0.3335) and 5 or
                        (r < 0.4002) and 6 or
                        (r < 0.4669) and 7 or
                        (r < 0.5336) and 8 or
                        (r < 0.6003) and 9 or
                        (r < 0.6670) and 10 or
                        (r < 0.7337) and 11 or
                        (r < 0.8004) and 12 or
                        (r < 0.8671) and 13 or
                        (r < 0.9338) and 14 or
                        15
                    if b then run_outcome_bucket(b, ctx, true) end
                end
                flag_and_maybe_sound("fn_double")
                return {message = "DOUBLE OR NOTHING"}

            elseif bucket == 13 then
                if ctx.scoring_hand then
                    for _, v in ipairs(ctx.scoring_hand) do
                        v:set_seal(SMODS.poll_seal({key = 'cracsealed', guaranteed = true}), true)
                        G.E_MANAGER:add_event(Event({
                            func = function() v:juice_up(0.3, 0.4); return true end
                        }))
                    end
                end
                flag_and_maybe_sound(silent and nil or "fn_stamp")
                return silent and nil or {message = "All scored cards sealed!"}

            elseif bucket == 14 then
                local n = #G.deck.cards
                if n > 0 then G.FUNCS.draw_from_deck_to_hand(n) end
                flag_and_maybe_sound(silent and nil or "fn_all")
                return silent and nil or {message = "Draw the whole deck!"}

            elseif bucket == 15 then
                G.GAME.chips = G.GAME.blind.chips
                flag_and_maybe_sound(silent and nil or "fn_nah")
                return silent and nil or {message = "Nah, i'd win"}

            elseif bucket == 16 then
                local _card = create_card('Joker', G.jokers, nil, nil, nil, nil, 'j_fn_Crac2')
                if _card then
                    _card:add_to_deck()
                    G.jokers:emplace(_card)
                    _card.ability.extra.odds = card.ability.extra.odds
                    _card.ability.extra.mult = card.ability.extra.mult
                    card:start_dissolve()
                end
                flag_and_maybe_sound("fn_evil")
                return {message = "Pray for your run!"}

            elseif bucket == 17 then
                local _card = create_card('Joker', G.jokers, nil, nil, nil, nil, 'j_fn_Crac3')
                if _card then
                    _card:add_to_deck()
                    G.jokers:emplace(_card)
                    _card.ability.extra.odds = card.ability.extra.odds
                    _card.ability.extra.mult = card.ability.extra.mult
                    card:start_dissolve()
                end
                flag_and_maybe_sound("fn_nice")
                return {message = "The messiah has arisen!"}
            end
        end

        if context.before then
            if pseudorandom('crac') < (G.GAME.probabilities.normal / card.ability.extra.odds) then
                local r = pseudorandom('crac_outcome') or 0
                local bucket =
                    (r < 0.0588) and 1 or
                    (r < 0.1176) and 2 or
                    (r < 0.1764) and 3 or
                    (r < 0.2352) and 4 or
                    (r < 0.2940) and 5 or
                    (r < 0.3528) and 6 or
                    (r < 0.4116) and 7 or
                    (r < 0.4704) and 8 or
                    (r < 0.5292) and 9 or
                    (r < 0.5880) and 10 or
                    (r < 0.6468) and 11 or
                    (r < 0.7056) and 12 or
                    (r < 0.7644) and 13 or
                    (r < 0.8232) and 14 or
                    (r < 0.8820) and 15 or
                    (r < 0.9410) and 16 or
                    17

                local res = run_outcome_bucket(bucket, context, false)
                if res then return res end
            end
        end

        if context.joker_main then
            return { mult = card.ability.extra.mult, card = self }
        end
    end,
}
end


-- EVIL Crac
if config.newcalccompat ~= false then
SMODS.Joker{
    key = 'Crac2',
    loc_txt = {
        ['en-us'] = {
            name = "Crac",
            text = {
                "Shitpost and Persona Pilled.",
                "{C:green,E:1,S:1.1}#3# in #2#{} odds for ANYTHING. A TRUE Wild Card.",
                "{C:inactive}Currently {C:mult}#1#{}{C:inactive} Mult",
            }
        }
    },
    atlas = 'Jokers',
    pos = { x = 0, y = 49 },
    config = {
        extra = { odds = 13, multmod = 50, mult = 13, repetitions = 1 }
    },
    rarity = 3,
    order = 33,
    cost = 13,
    blueprint_compat = true,
	
	loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.extra.mult,
                card.ability.extra.odds,
                '' .. (G.GAME and G.GAME.probabilities.normal or 1),
                card.ability.extra.multmod
            }
        }
    end,
	
	in_pool = function(self, args)
          return (
          not args 
          or args.source ~= 'sho' and args.source ~= 'buf' and args.source ~= 'jud' and args.source ~= 'rif' 
          or args.source == 'rta' or args.source == 'sou' or args.source == 'uta' or args.source == 'wra'
          )
          and true
      end,

    set_ability = function(self, card, initial)
        card:set_eternal(true)
    end,
	
	add_to_deck = function(self, card)
		if config.sfx ~= false then
            play_sound("fn_whip")
        end
    end,

    calculate = function(self, card, context)
        local function flag_and_maybe_sound(snd)
            G.GAME.pool_flags.crac_flag = true
            if config.cracsfx ~= false and snd then play_sound(snd) end
        end

        local function run_bad_bucket(bucket)
            if bucket == 1 then
                card.ability.extra.mult = 0
                flag_and_maybe_sound("fn_evil2")
                return {message = "X0 Mult!"}
            elseif bucket == 3 then
                card.ability.extra.mult = card.ability.extra.mult - 50
                flag_and_maybe_sound("fn_evil2")
                return {message = "-50 Mult!"}
            elseif bucket == 6 then
                card.ability.extra.mult = card.ability.extra.mult * -1
                flag_and_maybe_sound("fn_evil2")
                return {message = "X-1 Mult!"}
            elseif bucket == 18 then
                -- revert back to Neutral Crac
                local _card = create_card('Joker', G.jokers, nil, nil, nil, nil, 'j_fn_Crac') 
                if _card then
                    _card:add_to_deck()
                    G.jokers:emplace(_card)
                    _card.ability.extra.odds = card.ability.extra.odds
                    _card.ability.extra.mult = card.ability.extra.mult
                    card:start_dissolve()
                end
                flag_and_maybe_sound("fn_happy")
                return {message = "Crac reverted!"}
            end
        end

        if context.before then
            if pseudorandom('evil_crac') < (G.GAME.probabilities.normal / card.ability.extra.odds) then
                local r = pseudorandom('evil_crac_outcome') or 0
                local bucket =
                    (r < 0.3) and 1 or   -- X0 Mult
					(r < 0.6) and 3 or   -- -50 Mult
					(r < 0.9) and 6 or   -- X-1 Mult
					18                     -- revert
                local res = run_bad_bucket(bucket)
                if res then return res end
            end
        end

        if context.joker_main then
            return { mult = card.ability.extra.mult, card = self }
        end
    end,
}
end

--GOOD Crac
if config.newcalccompat ~= false then
SMODS.Joker{
    key = 'Crac3',
    loc_txt = {
        ['en-us'] = {
            name = "Crac",
            text = {
                "Shitpost and Persona Pilled.",
                "{C:green,E:1,S:1.1}#3# in #2#{} odds for ANYTHING. A TRUE Wild Card.",
                "{C:inactive}Currently {C:mult}#1#{}{C:inactive} Mult",
            }
        }
    },
    atlas = 'Jokers',
    pos = { x = 1, y = 49 },
    config = {
        extra = { odds = 13, multmod = 50, mult = 13, repetitions = 1 }
    },
    rarity = 3,
    order = 33,
    cost = 13,
    blueprint_compat = true,

    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.extra.mult,
                card.ability.extra.odds,
                '' .. (G.GAME and G.GAME.probabilities.normal or 1),
                card.ability.extra.multmod
            }
        }
    end,
	
	in_pool = function(self, args)
          return (
          not args 
          or args.source ~= 'sho' and args.source ~= 'buf' and args.source ~= 'jud' and args.source ~= 'rif' 
          or args.source == 'rta' or args.source == 'sou' or args.source == 'uta' or args.source == 'wra'
          )
          and true
      end,

    set_ability = function(self, card, initial)
        card:set_eternal(true)
    end,
	

    calculate = function(self, card, context)
        local function flag_and_maybe_sound(snd)
            G.GAME.pool_flags.crac_flag = true
            if config.cracsfx ~= false and snd then play_sound(snd) end
        end

        local function run_good_bucket(bucket, ctx, silent)
            if bucket == 1 then
                card.ability.extra.mult = card.ability.extra.mult * 10
                flag_and_maybe_sound(silent and nil or "fn_lesgo")
                return silent and nil or {message = "X10 Mult!"}

            elseif bucket == 2 then
                card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.multmod
                flag_and_maybe_sound(silent and nil or "fn_happy")
                return silent and nil or {message = "+50 Mult!"}

            elseif bucket == 3 then
                local new_card = create_card('Joker', G.jokers, is_soul, nil, nil, nil, nil, "mno")
                if new_card then
                    new_card:add_to_deck()
                    G.jokers:emplace(new_card)
                end
                flag_and_maybe_sound(silent and nil or "fn_persona")
                return silent and nil or {message = "+1 Joker!"}

            elseif bucket == 4 then
                local new_card = create_card('LTMConsumableType', G.consumeables)
                if new_card then
                    new_card:add_to_deck()
                    G.consumeables:emplace(new_card)
                end
                flag_and_maybe_sound(silent and nil or "fn_yoink")
                return silent and nil or {message = "+1 LTM Card!"}

            elseif bucket == 5 then
                local new_card = create_card('Tarot', G.consumeables)
                if new_card then
                    new_card:add_to_deck()
                    G.consumeables:emplace(new_card)
                end
                flag_and_maybe_sound(silent and nil or "fn_arcana")
                return silent and nil or {message = "+1 Tarot!"}

            elseif bucket == 6 then
                if ctx.scoring_hand then
                    for _, v in ipairs(ctx.scoring_hand) do
                        v:set_ability(G.P_CENTERS.m_lucky, nil, true)
                        G.E_MANAGER:add_event(Event({
                            func = function() v:juice_up(); return true end
                        }))
                    end
                end
                flag_and_maybe_sound(silent and nil or "fn_nagito")
                return silent and nil or {message = "All scored cards Lucky!"}

            elseif bucket == 7 then
                -- Revert to Neutral Crac
                local _card = create_card('Joker', G.jokers, nil, nil, nil, nil, 'j_fn_Crac')
                if _card then
                    _card:add_to_deck()
                    G.jokers:emplace(_card)
                    _card.ability.extra.odds = card.ability.extra.odds
                    _card.ability.extra.mult = card.ability.extra.mult
					_card:set_eternal(true)
                    card:start_dissolve()
                end
                flag_and_maybe_sound("fn_sad")
                return silent and nil or {message = "Crac reverted!"}

            elseif bucket == 8 then
                G.GAME.chips = G.GAME.blind.chips
                flag_and_maybe_sound(silent and nil or "fn_nah")
                return silent and nil or {message = "Nah, I'd win"}
            end
        end

        if context.before then
            local r = pseudorandom('good_crac_outcome') or 0
            local bucket =
                (r < 0.125) and 1 or
                (r < 0.25) and 2 or
                (r < 0.375) and 3 or
                (r < 0.5) and 4 or
                (r < 0.625) and 5 or
                (r < 0.75) and 6 or
                (r < 0.875) and 7 or
                8
            local res = run_good_bucket(bucket, context, false)
            if res then return res end
        end

        if context.joker_main then
            return { mult = card.ability.extra.mult, card = self }
        end
    end,
}
end


----------------------------------------------
------------CRAC CODE END----------------------

----------------------------------------------
------------EMILY CODE BEGIN----------------------

SMODS.Atlas{
    key = 'Jokers', --atlas key
    path = 'Jokers.png', --atlas' path in (yourMod)/assets/1x or (yourMod)/assets/2x
    px = 71.1, --width of one card
    py = 95 -- height of one card
}

if config.oldcalccompat ~= false then
  SMODS.Joker{
    key = 'Emily',
    loc_txt = {
        name = 'Emily',
        text = {
            "Retrigger EVERYTHING {C:attention}#1#{} Times"
        }
    },
    atlas = "Jokers",
    pos = { x = 4, y = 0 },
    config = {
        extra = {
            repetitions = 1, -- Number of times to retrigger for scoring cards and Jokers
        },
    },
    rarity = 4,
    order = 32,
    cost = 14,
    no_pool_flag = 'clam',
    blueprint_compat = true,
    loc_vars = function(self, info_queue, center)
        return {
            vars = { "" .. self.config.extra.repetitions }
        }
    end,

    calculate = function(self, card, context)
        -- Check for retriggering (excluding consumables)
        if (context.retrigger_joker_check and not context.retrigger_joker and context.other_card ~= self) or
           context.jokers or (context.repetition and context.cardarea == G.play) then

            -- Loop through the configured repetitions
            for i = 1, self.config.extra.repetitions do
                G.GAME.pool_flags.clam = true  -- Ensure 'clam' flag is set

                -- Return a message for each repetition
                return {
                    message = "CLAM!",  -- Custom message
                    colour = G.C.RED,    -- Set the color to red for emphasis
                    repetitions = self.config.extra.repetitions, -- How many times to retrigger
                    card = card,         -- Attach the card context
                }
            end
        end
    end,
}
end

if config.newcalccompat ~= false then
SMODS.Joker{
    key = 'Emily',
    loc_txt = {
        name = 'Emily',
        text = {
            "Retrigger EVERYTHING {C:attention}#1#{} Times"
        }
    },
    atlas = "Jokers",
    pos = { x = 4, y = 0 },
    config = {
        extra = {
            repetitions = 1,
        },
    },
    rarity = 4,
    order = 32,
    cost = 14,
    no_pool_flag = 'clam',
    blueprint_compat = true,

    loc_vars = function(self, info_queue, card)
        return {
            vars = {card.ability.extra.repetitions}
        }
    end,

    calculate = function(self, card, context)
        if (context.retrigger_joker_check and not context.retrigger_joker and context.other_card ~= self)
        or context.jokers
        or (context.repetition and context.cardarea == G.play) then

            G.GAME.pool_flags.clam = true

            return {
                message = "CLAM!",
                colour = G.C.RED,
                repetitions = card.ability.extra.repetitions,
                card = card,
            }
        end
    end,
}
end

----------------------------------------------
------------EMILY CODE END----------------------

----------------------------------------------
------------TOILET GANG CODE BEGIN----------------------

SMODS.Sound({
	key = "flush",
	path = "flush.ogg",
})

SMODS.Atlas{
    key = 'Jokers', --atlas key
    path = 'Jokers.png', --atlas' path in (yourMod)/assets/1x or (yourMod)/assets/2x
    px = 71.1, --width of one card
    py = 95 -- height of one card
}

SMODS.Joker{
  key = 'Toilet',
  loc_txt = {
    name = 'Toilet Gang',
    text = {
	 "This Joker Gains {X:mult,C:white}X#1#{} Mult",
     "if played hand",
     "contains a {C:attention}Flush{}",
     "{C:inactive}Currently {X:mult,C:white}X#2#{C:inactive} Mult"
        }
    },
    rarity = 2,
    atlas = "Jokers", pos = {x = 3, y = 0},
    cost = 5,
    unlocked = true,
    discovered = false,
    eternal_compat = true,
    blueprint_compat = true,
    perishable_compat = false,
    config = {extra = {Xmult_add = 0.2, Xmult = 1}},
    loc_vars = function(self, info_queue, card)
   return {vars = {card.ability.extra.Xmult_add, card.ability.extra.Xmult}}
  end, 
    calculate = function(self, card, context)
      if context.cardarea == G.jokers and context.before and not context.blueprint then 
        if context.scoring_name == "Flush" or context.scoring_name == "Straight Flush" or context.scoring_name == "Royal Flush" or context.scoring_name == "Flush Five" or context.scoring_name == "Flush House" then
                        card.ability.extra.Xmult = card.ability.extra.Xmult + card.ability.extra.Xmult_add
						if config.sfx ~= false then
							play_sound("fn_flush")
						end
                        return {
                            message = localize('k_upgrade_ex'),
                            colour = G.C.Mult,
                            card = card
                        }
                         end
        end
        if context.joker_main then
        return {
          message = localize{type='variable',key='a_xmult',vars={card.ability.extra.Xmult}},
          Xmult_mod = card.ability.extra.Xmult,
      }
     end
    end,
}

----------------------------------------------
------------TOILET GANG CODE END----------------------

----------------------------------------------
------------GROUND GAME CODE BEGIN----------------------

SMODS.Sound({
	key = "bus",
	path = "bus.ogg",
})

SMODS.Atlas{
    key = 'Jokers', --atlas key
    path = 'Jokers.png', --atlas' path in (yourMod)/assets/1x or (yourMod)/assets/2x
    px = 71.1, --width of one card
    py = 95 -- height of one card
}
if config.cryptidcompat ~= false then
    SMODS.Joker{
        key = 'GroundGame', 
        loc_txt = {
            ['en-us'] = {
                name = "Ground Game", 
                text = {
                    "If played hand contains a scoring 6, 7, 2, 2, and 3",
                    "Draw the entire deck and apply {C:dark_edition}Glitched{} to ALL cards and Jokers",
                }
            }
        },
        atlas = 'Jokers',
        pos = { x = 0, y = 3 },
        config = {
            extra = {
                -- Define additional properties here if needed
            }
        },
        rarity = 1,
        cost = 5,
        blueprint_compat = false,

        loc_vars = function(self, info_queue, center)
            info_queue[#info_queue + 1] = G.P_CENTERS.e_cry_glitched
            if center and center.ability and center.ability.extra then
                return {vars = {center.ability.extra.cards}} 
            end
            return {vars = {}}
        end,
        
        calculate = function(self, card, context)
            if context.joker_main then
                local counts = { [6] = 0, [7] = 0, [2] = 0, [3] = 0 }
                
                -- Count occurrences of relevant scoring cards
                for _, scoring_card in ipairs(context.scoring_hand) do
                    local value = scoring_card:get_id()
                    if counts[value] ~= nil then
                        counts[value] = counts[value] + 1
                    end
                end
                
                -- Check for the specific condition: 6, 7, 2 (x2), and 3
                if counts[6] >= 1 and counts[7] >= 1 and counts[2] >= 2 and counts[3] >= 1 then
                    -- Draw the entire deck
                    if config.sfx ~= false then
                        play_sound("fn_bus")
                    end
                    G.FUNCS.draw_from_deck_to_hand(#G.deck.cards)
                    
                    -- Apply the GLITCHED effect to scoring hand
                    for i = 1, #context.scoring_hand do
                        context.scoring_hand[i]:set_edition({ cry_glitched = true }, true, false)
                    end

                    -- Apply the GLITCHED effect to all cards in hand and Jokers
                    G.E_MANAGER:add_event(Event({
                        trigger = 'after',
                        delay = 0.0,
                        func = function()
                            self:apply_glitched_effect_to_hand(card)
                            self:apply_glitched_effect_to_jokers(card)
                            return true
                        end
                    }))
                    return {
                        message = localize('k_glitched_applied'),
                        colour = G.C.SECONDARY_SET.Glitched,
                        card = card
                    }
                end
            end
        end,

        apply_glitched_effect_to_hand = function(self, card)
            G.E_MANAGER:add_event(Event({
                trigger = "after",
                delay = 0.4,
                func = function()
                    play_sound("tarot1")
                    card:juice_up(0.3, 0.5)
                    return true
                end,
            }))
            for i = 1, #G.hand.cards do
                local percent = 1.15 - (i - 0.999) / (#G.hand.cards - 0.998) * 0.3
                G.E_MANAGER:add_event(Event({
                    trigger = "after",
                    delay = 0.15,
                    func = function()
                        G.hand.cards[i]:flip()
                        play_sound("card1", percent)
                        G.hand.cards[i]:juice_up(0.3, 0.3)
                        return true
                    end,
                }))
            end
            delay(0.2)
            for i = 1, #G.hand.cards do
                local CARD = G.hand.cards[i]
                local percent = 0.85 + (i - 0.999) / (#G.hand.cards - 0.998) * 0.3
                G.E_MANAGER:add_event(Event({
                    trigger = "after",
                    delay = 0.15,
                    func = function()
                        CARD:flip()
                        CARD:set_edition({
                            cry_glitched = true,
                        })
                        play_sound("tarot2", percent)
                        CARD:juice_up(0.3, 0.3)
                        return true
                    end,
                }))
            end
        end,

        apply_glitched_effect_to_jokers = function(self, card)
            local used_consumable = card
            local target = #G.jokers.cards == 1 and G.jokers.cards[1] or G.jokers.cards[math.random(#G.jokers.cards)]
            G.E_MANAGER:add_event(Event({
                trigger = "after",
                delay = 0.4,
                func = function()
                    play_sound("tarot1")
                    used_consumable:juice_up(0.3, 0.5)
                    return true
                end,
            }))
            for i = 1, #G.jokers.cards do
                local percent = 1.15 - (i - 0.999) / (#G.jokers.cards - 0.998) * 0.3
                G.E_MANAGER:add_event(Event({
                    trigger = "after",
                    delay = 0.15,
                    func = function()
                        G.jokers.cards[i]:flip()
                        play_sound("card1", percent)
                        G.jokers.cards[i]:juice_up(0.3, 0.3)
                        return true
                    end,
                }))
            end
            delay(0.2)
            for i = 1, #G.jokers.cards do
                local CARD = G.jokers.cards[i]
                local percent = 0.85 + (i - 0.999) / (#G.jokers.cards - 0.998) * 0.3
                G.E_MANAGER:add_event(Event({
                    trigger = "after",
                    delay = 0.15,
                    func = function()
                        CARD:flip()
                        if not CARD.edition then
                            CARD:set_edition({ cry_glitched = true })
                        end
                        play_sound("card1", percent)
                        CARD:juice_up(0.3, 0.3)
                        return true
                    end,
                }))
            end
            delay(0.2)
            G.E_MANAGER:add_event(Event({
                trigger = "after",
                delay = 0.4,
                func = function()
                    play_sound("tarot2")
                    used_consumable:juice_up(0.3, 0.5)
                    return true
                end,
            }))
        end
    }
end

----------------------------------------------
------------GROUND GAME CODE END----------------------

----------------------------------------------
------------DUB CODE BEGIN----------------------

SMODS.Sound({
	key = "dub",
	path = "dub.ogg",
})

SMODS.Atlas{
    key = 'Jokers', --atlas key
    path = 'Jokers.png', --atlas' path in (yourMod)/assets/1x or (yourMod)/assets/2x
    px = 71.1, --width of one card
    py = 95 -- height of one card
}
SMODS.Joker{
    key = 'TheDub',
    loc_txt = {
        ['en-us'] = {
            name = "The Dub",
            text = {
                "{C:green}#3#{} in {C:green}#2#{} chance to",
                "create a {C:purple}LTM Card{}",
                "when {C:attention}Blind{} starts",
                "{C:inactive}(Must have room)"
            }
        }
    },
    atlas = 'Jokers',
    pos = { x = 1, y = 3 },
    config = {
        extra = { odds = 2 } -- 1 in 4 chance
    },
    rarity = 1,
    cost = 5,
    blueprint_compat = true,

    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.extra.mult,
                card.ability.extra.odds,
                '' .. (G.GAME and G.GAME.probabilities.normal or 1),
                card.ability.extra.multmod
            }
        }
    end,

    calculate = function(self, card, context)
        -- Check if the Blind effect is starting and that conditions are met (no blueprint card or slicing)
        if context.setting_blind and not (context.blueprint_card or self).getting_sliced then
            -- Check if there's enough room in the consumables
            if #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit and pseudorandom('Krowe') < G.GAME.probabilities.normal/card.ability.extra.odds then
                -- Create and add the LTM card to the deck
                local new_card = create_card('LTMConsumableType', G.consumeables)
                new_card:add_to_deck()
                G.consumeables:emplace(new_card)
				if config.sfx ~= false then
					play_sound("fn_dub")
				end
            end
        end
    end -- End of calculate function
} -- End of Joker

----------------------------------------------
------------DUB CODE END----------------------

----------------------------------------------
------------FLUSH FACTORY CODE BEGIN----------------------

SMODS.Atlas{
    key = 'Jokers', --atlas key
    path = 'Jokers.png', --atlas' path in (yourMod)/assets/1x or (yourMod)/assets/2x
    px = 71.1, --width of one card
    py = 95 -- height of one card
}
SMODS.Joker{
    key = 'FlushFactory',
    loc_txt = {
        ['en-us'] = {
            name = "Flush Factory",
            text = {
                "If the played hand contains a {C:attention}Flush{}",
                "summon a {C:planet}Planet{} card for that hand",
            }
        }
    },
    atlas = 'Jokers',
    pos = { x = 3, y = 3 },
    rarity = 2,
    cost = 5,
    blueprint_compat = true,
    config = { extra = { Xmult_add = 0.2, Xmult = 1 }},
    loc_vars = function(self, info_queue, card)
    end,
    calculate = function(self, card, context)
    if context.cardarea == G.jokers and context.before and not context.blueprint then
        -- Check for flush types
        if context.scoring_name == "Flush" or context.scoring_name == "Straight Flush" or context.scoring_name == "Royal Flush" or context.scoring_name == "Flush Five" or context.scoring_name == "Flush House" then
            local card_type = 'Planet'
            G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
            
            -- Add event for creating a planet card
            G.E_MANAGER:add_event(Event({
                trigger = 'before',
                delay = 0.0,
                func = function()
                    local _planet = nil
                    
                    -- Iterate over the Planet pool to find a matching planet based on the flush hand type
                    for k, v in pairs(G.P_CENTER_POOLS.Planet) do
                        if v.config.hand_type == context.scoring_name then
                            _planet = v.key
                            break  -- Stop iterating once a match is found
                        end
                    end
                    
                    -- If a planet is found, create and add it to the deck
                    if _planet then
                        local new_card = create_card(card_type, G.consumeables, nil, nil, nil, nil, _planet, nil)
                        
                        -- Ensure the card's extra field exists
                        if not new_card.extra then
                            new_card.extra = {}
                        end
                        
                        -- Add the card to the deck
                        new_card:add_to_deck()
                        G.consumeables:emplace(new_card)
                    end

                    -- Reset the consumeable buffer after adding the card
                    G.GAME.consumeable_buffer = 0
                    
                    return true
                end
            }))
            
            -- Set Crac's unique flag
            G.GAME.pool_flags.flush_flag = true
            if config.sfx ~= false then
				play_sound("fn_flush")
			end
            -- Return the dynamic message based on the scoring hand type
            return {
				message = context.scoring_name .. "!"
            }
        end
    end
end,
}

----------------------------------------------
------------FLUSH FACTORY CODE END----------------------

----------------------------------------------
------------VICTORY CROWN CODE BEGIN----------------------

SMODS.Atlas{
    key = 'Jokers', --atlas key
    path = 'Jokers.png', --atlas' path in (yourMod)/assets/1x or (yourMod)/assets/2x
    px = 71.1, --width of one card
    py = 95 -- height of one card
}
SMODS.Joker{
    key = 'VictoryCrown', 
    loc_txt = {
        ['en-us'] = {
            name = "Victory Crown", 
            text = {
                "Scored cards gain a {C:mult}permanent{} {C:chips}Chip{} bonus", 
                "equal to their rank",
            }
        }
    },
    atlas = 'Jokers',
    pos = { x = 4, y = 3 },
    config = {
        extra = {
            -- Define additional properties here if needed
        }
    },
    rarity = 2,
    cost = 5,
    blueprint_compat = true,
    
    -- Calculate function for giving permanent rank-based chip bonus
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play then
            local currentCard = context.other_card
            if currentCard then
                -- Grant the played card's rank value as a permanent chip bonus
                currentCard.ability.perma_bonus = (currentCard.ability.perma_bonus or 0) + SMODS.Ranks[currentCard.base.value].nominal

                -- Replace the "big juice" effect with card:juice_up()
                if currentCard.juice_up then
                    currentCard:juice_up()
                else
                    print("Error: The card does not have the juice_up method.")
                end

                return {
                    extra = { message = "Upgrade!", colour = G.C.CHIPS },
                    colour = G.C.CHIPS,
                    card = currentCard
                }
            end
        end
    end
}
----------------------------------------------
------------VICTORY CROWN CODE END----------------------

----------------------------------------------
------------FORTNITE TRADING CARD CODE BEGIN----------------------

SMODS.Atlas{
    key = 'Jokers', --atlas key
    path = 'Jokers.png', --atlas' path in (yourMod)/assets/1x or (yourMod)/assets/2x
    px = 71.1, --width of one card
    py = 95 -- height of one card
}
SMODS.Joker{
    key = 'Peely', 
    loc_txt = {
        ['en-us'] = {
            name = "Fortnite Trading Card", 
            text = {
                "If {C:attention}first hand{} of round has only 4 cards",
                "destroy them and earn an {C:purple}LTM Card{}", 
            }
        }
    },
    atlas = 'Jokers',
    pos = { x = 2, y = 4 },
    config = {},
    rarity = 2,
    cost = 4,
    blueprint_compat = true,
    
    calculate = function(self, card, context)

        -- Give Peely a little juice animation when the first hand is drawn
        if context.first_hand_drawn and not context.blueprint then
            local eval = function() return G.GAME.current_round.hands_played == 0 and not G.RESET_JIGGLES end
            juice_card_until(card, eval, true)
        end

        if context.joker_main then
            -- Must be first hand of the round
            if G.GAME.current_round.hands_played == 0 then
                -- Must have exactly 4 cards
                if #context.full_hand == 4 then
                    local to_destroy = {}
                    for _, hand_card in ipairs(context.full_hand) do
                        table.insert(to_destroy, hand_card)
                    end

                    -- Delay destruction and card creation
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            -- Destroy the 4 hand cards and notify jokers
                            for _, destroyed in ipairs(to_destroy) do
                                destroyed:start_dissolve()

                                if destroyed.playing_card then
                                    for j = 1, #G.jokers.cards do
                                        eval_card(G.jokers.cards[j], {
                                            cardarea = G.jokers,
                                            remove_playing_cards = true,
                                            removed = {destroyed}
                                        })
                                    end
                                end
                            end

                            -- Create an LTM consumable
                            local new_card = create_card('LTMConsumableType', G.consumeables)
                            new_card:add_to_deck()
                            G.consumeables:emplace(new_card)

                            -- Juice up Peely
                            card:juice_up()

                            return true
                        end,
                        delay = 0.5
                    }))

                    -- Return message for triggering
                    return {
                        message = "+1 LTM Card!",
                        colour = G.C.SECONDARY_SET.Tarot,
                        card = card
                    }
                end
            end
        end
    end
}


----------------------------------------------
------------FORTNITE TRADING CARD CODE END----------------------

----------------------------------------------
------------ZORLODO ZORCODEO ZORBEGINDO----------------------

SMODS.Atlas{
    key = 'Jokers', --atlas key
    path = 'Jokers.png', --atlas' path in (yourMod)/assets/1x or (yourMod)/assets/2x
    px = 71.1, --width of one card
    py = 95 -- height of one card
}
SMODS.Joker{
    key = 'Zorlodo', 
    loc_txt = {
        ['en-us'] = {
            name = "Zorlodo", 
            text = {
				"Dissociates so hard the he thinks he is ",
                "The {C:attention}left{} and {C:attention}right{} jokers",
				"Even if they cannot be copied"
            }
        }
    },
    atlas = 'Jokers',
    pos = { x = 3, y = 4 },
    config = {
        extra = {
            -- No additional properties required for now
        }
    },
    rarity = 4,
    cost = 4,
    blueprint_compat = true,

    calculate = function(self, card, context)
        -- Initialize a table for results
        local results = {}

        -- Identify left and right jokers
        local left_joker, right_joker
        for i = 1, #G.jokers.cards do
            if G.jokers.cards[i] == card then
                left_joker = G.jokers.cards[i - 1]
                right_joker = G.jokers.cards[i + 1]
                break
            end
        end

        -- Process the left joker, if it exists
        if left_joker and left_joker ~= self then
            context.blueprint = (context.blueprint and (context.blueprint + 1)) or 1
            context.blueprint_card = context.blueprint_card or card

            if context.blueprint > #G.jokers.cards + 1 then
                return
            end

            local left_result, left_trig = left_joker:calculate_joker(context)
            if left_result or left_trig then
                if not left_result then
                    left_result = {}
                end

                left_result.card = context.blueprint_card or card
                left_result.colour = G.C.GREEN
                left_result.no_callback = true
                table.insert(results, left_result)
            end
        end

        -- Process the right joker, if it exists
        if right_joker and right_joker ~= self then
            context.blueprint = (context.blueprint and (context.blueprint + 1)) or 1
            context.blueprint_card = context.blueprint_card or card

            if context.blueprint > #G.jokers.cards + 1 then
                return
            end

            local right_result, right_trig = right_joker:calculate_joker(context)
            if right_result or right_trig then
                if not right_result then
                    right_result = {}
                end

                right_result.card = context.blueprint_card or card
                right_result.colour = G.C.GREEN
                right_result.no_callback = true
                table.insert(results, right_result)
            end
        end

        -- Return the combined result
        if #results > 0 then
            return results[1] -- Return the first result (or adjust as needed)
        end
    end
}

----------------------------------------------
------------ZORLODO ZORCODEO ZORENDO----------------------

----------------------------------------------
------------SOLID GOLD CODE BEGIN----------------------

SMODS.Atlas{
    key = 'Jokers', --atlas key
    path = 'Jokers.png', --atlas' path in (yourMod)/assets/1x or (yourMod)/assets/2x
    px = 71.1, --width of one card
    py = 95 -- height of one card
}
SMODS.Joker{
    key = 'SolidGold',
    loc_txt = {
        ['en-us'] = {
            name = "Solid Gold",
            text = {
                "{C:green}#3# in #2#{} chance to",
                "turn each scored card {C:money}Gold{}",
            }
        }
    },
    atlas = 'Jokers',
    pos = { x = 4, y = 4 },
    config = {
        extra = { 
            odds = 4,      -- 1 in 4 chance
            mult = 1,      -- Default multiplier
            multmod = 1,   -- Default multiplier modifier
        }
    },
    rarity = 1,          -- Common joker
    cost = 5,            -- Cost to purchase
    blueprint_compat = true,

    loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = G.P_CENTERS.m_gold
        return {
            vars = {
                card.ability.extra.mult,
                card.ability.extra.odds,
                '' .. (G.GAME and G.GAME.probabilities.normal or 1),
                card.ability.extra.multmod
            }
        }
    end,

    calculate = function(self, card, context)
        if context.joker_main then
            local odds = card.ability.extra.odds or 4
            local chance = 1 / odds
            local probability = G.GAME and G.GAME.probabilities.normal or 1
            chance = chance * probability -- Scale by global probability

            -- Apply the effect to each card in the scoring hand
            for _, scored_card in ipairs(context.scoring_hand) do
                if pseudorandom('solidgold' .. tostring(scored_card)) < chance then
                    -- Turn the card to gold
                    scored_card:set_ability(G.P_CENTERS.m_gold, nil, true)
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            scored_card:juice_up()
                            return true
                        end,
                    }))
                end
            end
        end
    end,
}

----------------------------------------------
------------SOLID GOLD CODE END----------------------

----------------------------------------------
------------BATTLE BUS CODE BEGIN----------------------
SMODS.Atlas{
    key = 'Jokers', --atlas key
    path = 'Jokers.png', --atlas' path in (yourMod)/assets/1x or (yourMod)/assets/2x
    px = 71.1, --width of one card
    py = 95 -- height of one card
}
local predefined_joker_names = { "Jimbo", "Crac", "Eric", "Emily", "Gavinia", "MushiJutsu", "BoiRowan", "Ninja", "Lazarbeam", "Duality", "Zorlodo", "Krowe", "Epic Games", "MagmaReef", "90cranker", "ColonelChugJug", "Gatordile81", "JonseyForever35", "PositiveFeels", "TimeToGo80", "QueenBeet74", "AimLikeIdaho", "CrazyPea96", "GetItGotItGood", "JustABitEpic", "PrancingPwnee", "TooManyBeets", "MintElephant26", "AngryDuck51", "CrepeSalad", "GhostChicken12", "KittyCat80", "PrinceWombat", "WalkInThePark66", "BliceCake", "AthenaOrApollo", "DoctorLobby92", "Gooddoggo80", "Kregore73", "SergentSummer", "WildCactusBob", "BraunyBanana", "AtTheBeach321", "DoubleDaring", "Goosezilla13", "LetsBePals23", "ShadowArrow58", "Wondertail", "SoggyCookie26", "BagelBoy82", "DoubleDuel75", "Grandma40", "LewtGoblin7", "Shepard52", "Yeetman57", "AboveMule633", "BellyFlop40", "DoubleRainbow96", "HashtagToad57", "McCucumber71", "ShieldHorse63", "Beebitme", "PurpleCrayon85", "Blackjack31", "DrPlanet", "HeliumHog", "Meshuncle", "ShootyMcGee40", "SweetPenguin16", "SpiffyPowder6866", "BlinkImGone44", "DrumGunnar", "HeyThereFriend81", "Mouthful95", "SilverySilver", "PortableOx", "LootTrooper51", "BoatingIsLife", "ElPollo85", "Hoodwinked12", "N0nDa1ry", "SirTricksALot21", "ASweatyDog", "LousyCentaur", "BoldPrediction", "FlavorCaptain", "HotelBlankets", "NotAPalidome", "SteelGoose18", "&darkBeast&", "BrainInvader", "FlimsyGoat", "HowAreMy90s", "Number141", "TAgYOuRIt9", "BobDobaleena", "CactusDad80", "FlossPatrol82", "iHazHighGround", "ParanoidCactus", "ThermalDragon39", "OldWaterBottle28", "JesterJumps23", "LaughingLance89", "BalatroKing", "PranksterPie42", "CourtFool77", "SillySpecter", "MaskMischief91", "HarlequinHoop", "GrinGoblin", "ClownPrince44", "GiggleGoose66", "QuipMaster7", "FoolishFrolic", "ChuckleCharger", "WittyWanderer", "JestInTime", "LaughingLotus", "ComicCapper", "LoomingLaughter", "TricksterTango", "MockingMask", "FollyFellow", "SnarkyShadow", "MirthMaker42", "SardonicSprout", "CaperCrown", "GleefulGambit", "JugglingJack88", "TwirlingTrixie", "ChortlingChimp", "MerryMadcap", "SnickerSprite", "BalatroBard", "WitfulWraith", "PranceJester55", "LaughterLynx", "FoolhardyFox", "TumbleTrix89", "JovialJoker", "GleeGoblin79", "CourtroomClown", "WhimsicalWill", "RiddleRogue", "CaperingCrane", "MockeryMaven", "GiddyGambler", "JestfulJinx", "HarlequinHustler", "PantomimePrince", "BalatroBelle", "TrickyTroubadour", "SmirkSprite42", "Peter Griffin", "FoolishFencer", "JesterJourney", "MirthfulMage", "GiddyGladiator", "WhimsyWarden", "ChuckleChampion", "PranksterPuppeteer", "TwirlingTinker", "JovialJuggler", "BuffoonBard", "LaughingLancer", "SnickerSquire", "WittyWitch", "ClownishChronicler", "FoolishFlair", "TricksterTide", "GrinGryphon", "JesterJive", "TumbleTeller", "MimicMarauder", "ComicalCorsair", "QuipQueen", "PrankPirate", "LudicrousLynx", "GleamingGagster", "LaughterLynx", "FollyFiend", "SillySorcerer", "MockingMarauder", "CheerfulCoyote", "WitWhisperer", "FancifulFool", "TrixieTroll", "LaughingLad", "MerrymakingMonk", "BalatroBanshee", "CaperingCavalier", "PantomimePug", "SnickerSpecter", "Jolly Joker", "WaggishWitch", "FooleryFox", "SardonicSquire", "ChortlingClown", "TrixieTrickster", "DrollDruid", "PunnyPaladin", "GrinningGolem", "BanterBard", "MockingMimic", "WittyWraith", "GleefulGargoyle" }

SMODS.Joker {
    key = "BattleBus",
    name = "Battle Bus",
    atlas = 'Jokers',
    pos = { x = 0, y = 5 },
    rarity = 1,
    cost = 4,
    config = {
        extra = { jokers = 1, chips = 4, gainedchips = 4 },
    },
    loc_txt = {
        ['en-us'] = {
            name = "Battle Bus",
            text = {
                "Gains {C:chips}+#1#{} Chips for each Joker when scoring",
                "{C:inactive}Currently{} {C:chips}+#2#{} {C:inactive}Chips"
            }
        }
    },
    loc_vars = function(self, info_queue, center)
        return {
            vars = { center.ability.extra.gainedchips, center.ability.extra.chips }
        }
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            local total_jokers = #predefined_joker_names
            local joker_name = predefined_joker_names[math.random(total_jokers)] or "Jimbo"

            local chips = card.ability.extra.chips  -- Base chips
            local jokers_bonus = card.ability.extra.gainedchips * #G.jokers.cards  -- Bonus chips based on dynamic jokers count

            card.ability.extra.chips = chips + jokers_bonus  -- Total chips calculation

            -- Debug log
			if config.sfx ~= false then
				play_sound("fn_bus")
			end
            print("" .. joker_name .. " has thanked the bus driver")
            SMODS.eval_this(card, {message = ("Beep Beep"), colour = G.C.BLUE})

            return {
                message = localize { type = 'variable', key = 'a_chips', vars = { card.ability.extra.chips } },
                chip_mod = card.ability.extra.chips,
                colour = G.C.CHIPS
            }
        end
    end,
    add_to_deck = function(self, card, from_debuff)
        local num_jokers = #G.jokers.cards  -- Get the current number of Jokers
        card.ability.extra.jokers = num_jokers + 1
    end,
    remove_from_deck = function(self, card)
        local num_jokers = #G.jokers.cards  -- Get the current number of Jokers
        card.ability.extra.jokers = num_jokers - 1
    end
}

----------------------------------------------
------------BATTLE BUS CODE END----------------------

----------------------------------------------
------------STW CODE BEGIN----------------------

SMODS.Atlas
{
	key = 'Jokers',
	path = 'Jokers.png',
	px = 71.1,
	py = 95
}

SMODS.Joker
{
	key = 'SaveTheWorld',
	loc_txt = 
	{
		name = 'Save The World',
		text = 
		{
			'For every round without buying something at the {C:attention}Shop{}',
			'gain {X:mult,C:white}X#2#{} Mult',
			'lose {X:mult,C:white}X#3#{} when buying something',
			'{C:inactive}Currently {}{X:mult,C:white}X#1#{}{C:inactive} Mult{}'
		}
	},
	atlas = 'Jokers',
	pos = {x = 3, y = 5},
	rarity = 3,
	cost = 7,
	config = 
	{ 
		extra = 
		{
			Xmult = 1,
			xmult_add = 0.5,   -- Increment to add each round
			xmult_subtract = 0.25  -- Decrement when buying something
		}
	},
	loc_vars = function(self,info_queue,center)
		return 
		{
			vars = 
			{
				center.ability.extra.Xmult,
				center.ability.extra.xmult_add,
				center.ability.extra.xmult_subtract
			}
		}
	end,
	calculate = function(self,card,context)
		if context.joker_main then
			return
			{
				card = card,
				Xmult_mod = card.ability.extra.Xmult,
				message = 'X' .. card.ability.extra.Xmult,
				colour = G.C.MULT
			}
		end
		
		if context.buying_card or context.reroll_shop or context.open_booster then
			card.ability.extra.Xmult = card.ability.extra.Xmult - card.ability.extra.xmult_subtract
			return
			{
				message = 'X' .. card.ability.extra.Xmult,
				colour = G.C.MULT
			}
		end
		
		if context.end_of_round and not context.repetition and not context.individual then
			card.ability.extra.Xmult = card.ability.extra.Xmult + card.ability.extra.xmult_add
			return
			{
				message = 'X' .. card.ability.extra.Xmult,
				colour = G.C.MULT
			}
		end
	end
}




----------------------------------------------
------------STW CODE END----------------------

----------------------------------------------
------------THE LOOP CODE BEGIN----------------------

if config.cryptidcompat ~= false then
    SMODS.Joker{
        key = 'TheLoop',
        loc_txt = {
            ['en-us'] = {
                name = "The Loop",
                text = {
                    "{C:green}#3# in #2#{} chance to",
                    "give each scored card {C:cry_epic}Echo{}",
                }
            }
        },
        atlas = 'Jokers',
        pos = { x = 2, y = 6 },
        config = {
            extra = { 
                odds = 4,      -- 1 in 4 chance
                mult = 1,      -- Default multiplier
                multmod = 1,   -- Default multiplier modifier
            }
        },
        rarity = 1,          -- Common joker
        cost = 10,            -- Cost to purchase
        blueprint_compat = true,

        loc_vars = function(self, info_queue, card)
            info_queue[#info_queue + 1] = G.P_CENTERS.m_cry_echo
            return {
                vars = {
                    card.ability.extra.mult,
                    card.ability.extra.odds,
                    '' .. (G.GAME and G.GAME.probabilities.normal or 1),
                    card.ability.extra.multmod
                }
            }
        end,

        calculate = function(self, card, context)
            if context.joker_main then
                local odds = card.ability.extra.odds or 4
                local chance = 1 / odds
                local probability = G.GAME and G.GAME.probabilities.normal or 1
                chance = chance * probability -- Scale by global probability

                -- Apply the effect to each card in the scoring hand
                for _, scored_card in ipairs(context.scoring_hand) do
                    if pseudorandom('looper' .. tostring(scored_card)) < chance then
                        -- Turn the card to gold
                        scored_card:set_ability(G.P_CENTERS.m_cry_echo, nil, true)
                        G.E_MANAGER:add_event(Event({
                            func = function()
                                scored_card:juice_up()
                                return true
                            end,
                        }))
                    end
                end
            end
        end,
    }
end

----------------------------------------------
------------THE LOOP CODE END----------------------

----------------------------------------------
------------CHUG JUG CODE BEGIN----------------------

SMODS.Sound({
	key = "chug",
	path = "chug.ogg",
})


SMODS.Joker{
    key = 'ChugJug',
    loc_txt = {
        ['en-us'] = {
            name = "Chug Jug",
            text = {
                "When {C:attention}Blind{} starts, stores your {C:chips}Hands{}",
                "If you run out of {C:chips}Hands{}, restore {C:chips}Hands{} to the stored value",
                "{C:mult}Self-destruct{} when triggered",
                "{C:chips}#1# {C:inactive}Stored{} {C:chips}hands{}"
            }
        }
    },
    atlas = 'Jokers',
    pos = { x = 3, y = 7 },
    config = {
        extra = { 
            hands = 0
        }
    },
    rarity = 2,
    cost = 5,
    blueprint_compat = false,

    loc_vars = function(self, info_queue, card)
        -- Show stored hands
        local stored_hands = self.config.extra.initial_hands or self.config.extra.hands
        return {
            vars = { stored_hands }
        }
    end,

    calculate = function(self, card, context)
        local round = G.GAME.current_round

        if context.setting_blind then
            -- Store the current number of hands at the start of blind
            self.config.extra.initial_hands = round.hands_left 

        elseif context.joker_main then
            -- During normal joker calculation, check if player ran out of hands
            if round.hands_left <= 0 and G.GAME.chips < G.GAME.blind.chips then
                -- Play Chug Jug sound
                if config.sfx ~= false then
					play_sound("fn_chug")
				end
                -- Restore hands
                local restore_value = self.config.extra.initial_hands or self.config.extra.hands
                round.hands_left = restore_value

                -- Self-destruct the joker
                card:start_dissolve()
            end
        end
    end
}

----------------------------------------------
------------CHUG JUG CODE END----------------------

----------------------------------------------
------------BIG POT CODE BEGIN----------------------
SMODS.Joker{
    key = 'BigPot',
    loc_txt = {
        ['en-us'] = {
            name = "Big Pot",
            text = {
                "When {C:attention}Blind{} starts, stores {C:attention}Half{} your {C:chips}Hands{}",
                "If you run out of {C:chips}Hands{}, restore {C:chips}Hands{} to the stored value",
                "{C:mult}Self-destruct{} when triggered",
                "{C:chips}#1# {C:inactive}Stored{} {C:chips}hands{}",
				"Artist: {C:attention}MushiJutsu"
            }
        }
    },
    atlas = 'Jokers',
    pos = { x = 4, y = 7 },
    config = {
        extra = { 
            hands = 0 -- Default hands
        }
    },
    rarity = 1,          -- Uncommon joker
    cost = 2,            -- Cost to purchase
    blueprint_compat = false,

    loc_vars = function(self, info_queue, card)
        -- Dynamically display the stored hands
        local stored_hands = self.config.extra.initial_hands or self.config.extra.hands
        return {
            vars = { stored_hands }
        }
    end,

    calculate = function(self, card, context)
        local round = G.GAME.current_round

        if context.setting_blind then
            -- Store the current number of hands at the start of blind
            self.config.extra.initial_hands = round.hands_left / 2

        elseif context.joker_main then
            -- During normal joker calculation, check if player ran out of hands
            if round.hands_left <= 0 and G.GAME.chips < G.GAME.blind.chips then
                -- Play Chug Jug sound
                if config.sfx ~= false then
					play_sound("fn_chug")
				end
                -- Restore hands
                local restore_value = self.config.extra.initial_hands or self.config.extra.hands
                round.hands_left = restore_value

                -- Self-destruct the joker
                card:start_dissolve()
            end
        end
    end
}

----------------------------------------------
------------BIG POT CODE END----------------------

----------------------------------------------
------------MINI CODE BEGIN----------------------

SMODS.Joker{
    key = 'Mini',
    loc_txt = {
        ['en-us'] = {
            name = "Mini Shield",
            text = {
                "When {C:attention}Blind{} starts, stores a {C:attention}Fourth{} of your {C:chips}Hands{}",
                "If you run out of {C:chips}Hands{}, restore {C:chips}Hands{} to the stored value",
                "{C:mult}Self-destruct{} when triggered",
                "{C:chips}#1# {C:inactive}Stored{} {C:chips}hands{}",
				"Artist: {C:attention}MushiJutsu"
            }
        }
    },
    atlas = 'Jokers',
    pos = { x = 0, y = 8 },
    config = {
        extra = { 
            hands = 0, -- Default hands
        }
    },
    rarity = 1,          -- Uncommon joker
    cost = 1,            -- Cost to purchase
    blueprint_compat = false,

    loc_vars = function(self, info_queue, card)
        -- Dynamically display the stored hands
        local stored_hands = self.config.extra.initial_hands or self.config.extra.hands
        return {
            vars = { stored_hands }
        }
    end,

    calculate = function(self, card, context)
        local round = G.GAME.current_round

        if context.setting_blind then
            -- Store the current number of hands at the start of blind
            self.config.extra.initial_hands = round.hands_left / 4

        elseif context.joker_main then
            -- During normal joker calculation, check if player ran out of hands
            if round.hands_left <= 0 and G.GAME.chips < G.GAME.blind.chips then
                -- Play Chug Jug sound
                if config.sfx ~= false then
					play_sound("fn_chug")
				end
                -- Restore hands
                local restore_value = self.config.extra.initial_hands or self.config.extra.hands
                round.hands_left = restore_value

                -- Self-destruct the joker
                card:start_dissolve()
            end
        end
    end
}
----------------------------------------------
------------MINI CODE END----------------------

----------------------------------------------
------------VBUCKS CODE BEGIN----------------------

if config.oldcalccompat ~= false then
    SMODS.Joker {
        key = 'Vbucks',
        loc_txt = {
            ['en-us'] = {
                name = "Vbucks",
                text = {
                    "{C:green}#3#{} in {C:green}#2#{} chance to",
                    "gain {C:money}$#1#{}",
                    "when {C:attention}Blind{} starts",
                }
            }
        },
        atlas = 'Jokers',
        pos = { x = 1, y = 8 },
        config = {
            extra = { 
                dollars = 10,   -- Fixed Money Granted
                odds = 3,       -- Odds of getting the money
            }
        },
        rarity = 1,            -- Common joker
        cost = 10,             -- Cost to purchase
        blueprint_compat = true,

        loc_vars = function(self, info_queue, card)
            return {
                vars = {
                    card.ability.extra.dollars,
                    card.ability.extra.odds,
                    '' .. (G.GAME and G.GAME.probabilities.normal or 1),
                }
            }
        end,

        calculate = function(self, card, context)
            -- Check if the Blind effect is starting and that conditions are met (no blueprint card or slicing)
            if context.setting_blind and not (context.blueprint_card or self).getting_sliced then
                local money = card.ability.extra.dollars
                local odds = card.ability.extra.odds

                -- Check if you win the money
                if pseudorandom('Vbucks') < G.GAME.probabilities.normal / odds then
                    if money > 0 then
                        ease_dollars(money)
                        G.GAME.dollar_buffer = (G.GAME.dollar_buffer or 0) + money
                        G.E_MANAGER:add_event(Event({func = (function() G.GAME.dollar_buffer = 0; return true end)}))
                        return {
                            message = localize('$') .. money,
                            dollars = money,
                            colour = G.C.MONEY
                        }
                    end
                end
            end
        end
    }
end


if config.newcalccompat ~= false then
    SMODS.Joker {
        key = 'Vbucks',
        loc_txt = {
            ['en-us'] = {
                name = "Vbucks",
                text = {
                    "{C:green}#3#{} in {C:green}#2#{} chance to",
                    "gain {C:money}$#1#{}",
                    "when {C:attention}Blind{} starts",
                }
            }
        },
        atlas = 'Jokers',
        pos = { x = 1, y = 8 },
        config = {
            extra = { 
                dollars = 10,   -- Fixed Money Granted
                odds = 3,       -- Odds of getting the money
            }
        },
        rarity = 1,            -- Common joker
        cost = 10,             -- Cost to purchase
        blueprint_compat = true,

        loc_vars = function(self, info_queue, card)
            return {
                vars = {
                    card.ability.extra.dollars,
                    card.ability.extra.odds,
                    '' .. (G.GAME and G.GAME.probabilities.normal or 1),
                }
            }
        end,

        calculate = function(self, card, context)
            -- Check if the Blind effect is starting and that conditions are met (no blueprint card or slicing)
            if context.setting_blind and not (context.blueprint_card or self).getting_sliced then
                local money = card.ability.extra.dollars
                local odds = card.ability.extra.odds

                -- Check if you win the money based on odds
                if pseudorandom('Vbucks') < (G.GAME.probabilities.normal / odds) then
                    -- Directly give the money without odds
                    if money > 0 then
                        ease_dollars(money)
                        G.GAME.dollar_buffer = (G.GAME.dollar_buffer or 0) + money
                        G.E_MANAGER:add_event(Event({func = function() 
                            G.GAME.dollar_buffer = 0
                            return true 
                        end}))
                    end
                end
            end
        end
    }
end





----------------------------------------------
------------VBUCKS CODE END----------------------

----------------------------------------------
------------REALITY AUGMENT CODE BEGIN----------------------
SMODS.Joker {
    key = 'Augment',
    config = {
        extra = {temp = 0},
    },
    atlas = 'Jokers',
    pos = { x = 2, y = 8 },
    loc_txt = {
        ['en-us'] = {
            name = "Reality Augment",
            text = {
                "All Probabilities become {C:green}certain{}",
                "{C:inactive}(ex: {C:green}1/3{}{C:inactive} -> {C:green}999999999999/3{}{C:inactive})",
            }
        }
    },
    rarity = 3,
    cost = 8,
    blueprint_compat = false,
    add_to_deck = function(self, from_debuff)
        self.added_to_deck = true
		for k, v in pairs(G.GAME.probabilities) do 
            self.config.extra.temp = v
			G.GAME.probabilities.normal = v*1e300
		end
    end,
    remove_from_deck = function(self, from_debuff)
        self.added_to_deck = false
		for k, v in pairs(G.GAME.probabilities) do 
			G.GAME.probabilities[k] = self.config.extra.temp
		end
    end,
    loc_vars = function(self, info_queue, card)
        return { vars = {} }
    end,
    calculate = function(self, card, context)
    end
}

----------------------------------------------
------------REALITY AUGMENT CODE END----------------------

----------------------------------------------
------------BLUGLO CODE BEGIN----------------------

SMODS.Sound({
	key = "bluglo",
	path = "bluglo.ogg",
})

if config.oldcalccompat ~= false then
SMODS.Joker{
    key = 'BluGlo',
    loc_txt = {
        ['en-us'] = {
            name = "BluGlo",
            text = {
                "Every LTM consumable used adds {C:mult}+#2#{} Mult",
                "Spawn 2 Negative {C:purple}LTM Cards{} upon obtaining this Joker",
                "{C:inactive}Currently{} {C:mult}+#1# {C:inactive}mult",
            }
        }
    },
    atlas = 'Jokers',
    pos = { x = 0, y = 9 },
    config = {
        extra = { mult = 0, multmod = 4 } -- mult value
    },
    rarity = 1,
    cost = 5,
    blueprint_compat = true,

    add_to_deck = function(self, card, from_debuff)
        if #G.deck.cards > 0 then
            for _ = 1, 2 do
                local new_card = create_card('LTMConsumableType', G.consumeables)
                new_card:set_edition({negative = true}, true)
                new_card:add_to_deck()
                G.consumeables:emplace(new_card)
            end
            -- Play sound effect
			if config.sfx ~= false then
				play_sound("fn_bluglo")
			end
        end
    end,

    loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = G.P_CENTERS.e_negative
        return {
            vars = {
                card.ability.extra.mult,
                card.ability.extra.multmod
            }
        }
    end,

    calculate = function(self, card, context)
        if
            context.using_consumeable
            and context.consumeable.ability.set == "LTMConsumableType"
            and not context.consumeable.beginning_end
        then
			if config.sfx ~= false then
				play_sound("fn_bluglo")
			end
            card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.multmod
            G.E_MANAGER:add_event(Event({
                func = function()
                    card_eval_status_text(
                        card,
                        "extra",
                        nil,
                        nil,
                        nil,
                        {
                            message = localize({
                                type = "variable",
                                key = "sj_mult",
                                vars = { card.ability.extra.mult },
                            }),
                        }
                    )
                    return true
                end,
            }))
            return
        end
        if context.joker_main then
            return {
                message = localize {
                    type = 'variable',
                    key = 'sj_mult',
                    vars = { card.ability.extra.mult }
                },
                mult_mod = card.ability.extra.mult,
                card = self
            }
        end
    end
}
end

if config.newcalccompat ~= false then
SMODS.Joker{
    key = 'BluGlo',
    loc_txt = {
        ['en-us'] = {
            name = "BluGlo",
            text = {
                "Every LTM consumable used adds {C:mult}+#2#{} Mult",
                "Spawn 2 Negative {C:purple}LTM Cards{} upon obtaining this Joker",
                "{C:inactive}Currently{} {C:mult}+#1# {C:inactive}mult",
            }
        }
    },
    atlas = 'Jokers',
    pos = { x = 0, y = 9 },
    config = {
        extra = { mult = 0, multmod = 4 } -- mult value
    },
    rarity = 1,
    cost = 5,
    blueprint_compat = true,

    add_to_deck = function(self, card, from_debuff)
        if #G.deck.cards > 0 then
            for _ = 1, 2 do
                local new_card = create_card('LTMConsumableType', G.consumeables)
                new_card:set_edition({negative = true}, true)
                new_card:add_to_deck()
                G.consumeables:emplace(new_card)
            end
            -- Play sound effect
			if config.sfx ~= false then
				play_sound("fn_bluglo")
			end
        end
    end,

    loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = G.P_CENTERS.e_negative
        return {
            vars = {
                card.ability.extra.mult,
                card.ability.extra.multmod
            }
        }
    end,

    calculate = function(self, card, context)
        if
            context.using_consumeable
            and context.consumeable.ability.set == "LTMConsumableType"
            and not context.consumeable.beginning_end
        then
			if config.sfx ~= false then
				play_sound("fn_bluglo")
			end
            card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.multmod
            G.E_MANAGER:add_event(Event({
                func = function()
                    card_eval_status_text(
                        card,
                        "extra",
                        nil,
                        nil,
                        nil,
                        {
                            message = localize('k_upgrade_ex'),
							colour = G.C.Mult,
							card = card
                        }
                    )
                    return true
                end,
            }))
            return
        end
        if context.joker_main then
            return {
                mult = card.ability.extra.mult,
                card = self
            }
        end
    end
}
end
----------------------------------------------
------------BLUGLO CODE END----------------------

----------------------------------------------
------------REBOOT CARD CODE BEGIN----------------------

SMODS.Sound({
	key = "reboot",
	path = "reboot.ogg",
})

SMODS.Joker{
    name = "Reboot Card",
    key = "RebootCard",
    config = { extra = { dollars = 10 } }, -- Fixed money granted
    pos = { x = 1, y = 9 },
    loc_txt = {
        name = "Reboot Card",
        text = {
            "Prevents death once",
            "Grants {C:money}$#1#{} when triggered"
        }
    },
    rarity = 3,
    cost = 8,
    unlocked = true,
    discovered = false,
    blueprint_compat = false,
    perishable_compat = true,
    atlas = "Jokers",
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.dollars } }
    end,
    calculate = function(self, card, context)
        if context.end_of_round and not context.blueprint and context.game_over then
            G.E_MANAGER:add_event(Event({
                func = function()
                    -- Visual feedback for chips
                    G.hand_text_area.blind_chips:juice_up()
                    G.hand_text_area.game_chips:juice_up()

                    -- Play a sound effect
					if config.sfx ~= false then
						play_sound('fn_reboot')
					end

                    -- Destroy the Reboot Card itself
                    card:start_dissolve()

                    -- Prevent the game over
                    context.game_over = false

                    -- Grant $10
                    local money = card.ability.extra.dollars
                    if money > 0 then
                        ease_dollars(money)
                        G.GAME.dollar_buffer = (G.GAME.dollar_buffer or 0) + money
                        G.E_MANAGER:add_event(Event({
                            func = function()
                                G.GAME.dollar_buffer = 0
                                return true
                            end
                        }))
                    end

                    return true
                end
            }))
            return {
                message = localize('k_saved_ex') .. " +" .. localize('$') .. card.ability.extra.dollars,
                saved = true,
                colour = G.C.RED
            }
        end
    end
}

----------------------------------------------
------------REBOOT CARD CODE END----------------------

----------------------------------------------
------------OSCAR'S MEDALLION CODE BEGIN----------------------

if config.oldcalccompat ~= false then
    SMODS.Joker{
        key = 'Oscar',
        loc_txt = {
            ['en-us'] = {
                name = "Oscar's Medallion",
                text = {
                    "{C:mult}+#1#{} Mult",
                    "{C:mult}Destroy{} this Joker if a {C:attention}Flush{} is played",
                }
            }
        },
        atlas = 'Jokers',
        pos = { x = 4, y = 9 },
        config = {
            extra = { mult = 20 }
        },
        rarity = 1,
        cost = 5,
        blueprint_compat = true,

        loc_vars = function(self, info_queue, card)
            return {
                vars = {
                    card.ability.extra.mult
                }
            }
        end,

        calculate = function(self, card, context)
            if context.cardarea == G.jokers and context.before and not context.blueprint then
                if context.scoring_name == "Flush" then
                    card:start_dissolve()
                    if config.sfx ~= false then
                        play_sound("fn_flush")
                    end
                    return
                end
            end

            if context.joker_main and context.scoring_name ~= "Flush" then
                return {
                    message = localize {
                        type = 'variable',
                        key = 'sj_mult',
                        vars = { card.ability.extra.mult }
                    },
                    mult_mod = card.ability.extra.mult,
                    card = self
                }
            end
        end
    }
end

if config.newcalccompat ~= false then
    SMODS.Joker{
        key = 'Oscar',
        loc_txt = {
            ['en-us'] = {
                name = "Oscar's Medallion",
                text = {
                    "{C:mult}+#1#{} Mult",
                    "{C:mult}Destroy{} this Joker if a {C:attention}Flush{} is played",
                }
            }
        },
        atlas = 'Jokers',
        pos = { x = 4, y = 9 },
        config = {
            extra = { mult = 20 }
        },
        rarity = 1,
        cost = 5,
        blueprint_compat = true,

        loc_vars = function(self, info_queue, card)
            return {
                vars = {
                    card.ability.extra.mult
                }
            }
        end,

        calculate = function(self, card, context)
            if context.cardarea == G.jokers and context.before and not context.blueprint then
                if context.scoring_name == "Flush" then
                    card:start_dissolve()
                    if config.sfx ~= false then
                        play_sound("fn_flush")
                    end
                    return
                end
            end

            if context.joker_main and context.scoring_name ~= "Flush" then
                return {
                    mult = card.ability.extra.mult,
                    card = self
                }
            end
        end
    }
end


----------------------------------------------
------------OSCAR'S MEDALLION CODE END----------------------

----------------------------------------------
------------MONTAGUE'S MEDALLION CODE BEGIN----------------------

SMODS.Joker {
    key = 'Montague',
    loc_txt = {
        name = 'Montague\'s Medallion',
        text = {
            "Retriggers every {C:diamond}Diamond{} card played {C:attention}#1#{} times",
            "Gains {X:mult,C:white}X#2#{} Mult for each scoring {C:diamond}Diamond{} in played hand",
            "{C:mult}Self-destruct{} if played hand contains 2 Aces",
        }
    },
    rarity = 2,
    atlas = "Jokers",
    pos = {x = 0, y = 10},
    cost = 5,
    unlocked = true,
    discovered = false,
    eternal_compat = true,
    blueprint_compat = true,
    perishable_compat = false,
    ability = {
        extra = {
            repetitions = 1,
            xmultmod = 0.5,
            xmult = 0, -- Ensure xmult starts as 0
        },
    },

    loc_vars = function(self, info_queue, card)
        if not card.ability.extra then
            card.ability.extra = { xmult = 0, repetitions = 1, xmultmod = 0.5 }
        end

        return {
            vars = {
                card.ability.extra.repetitions,
                card.ability.extra.xmultmod,
                card.ability.extra.xmult
            }
        }
    end,

    calculate = function(self, card, context)
        -- Calculate Ace count
        local ace_count = 0
        if context.joker_main or context.cardarea == G.play then
            for _, scoring_card in ipairs(context.scoring_hand) do
                if scoring_card:get_id() == 14 then -- Ace card ID
                    ace_count = ace_count + 1
                end
            end

            -- Self-destruct if 2 or more Aces
            if ace_count >= 2 then
                card:start_dissolve()
                return
            end
        end

        -- Diamond Retrigger Logic with Ace Check
        if context.cardarea == G.play and context.repetition and not context.repetition_only then
            if context.other_card and context.other_card:is_suit("Diamonds") then
                -- Prevent retrigger if there are 2 or more Aces
                if ace_count < 2 then
                    card.ability.extra.xmult = (card.ability.extra.xmult or 0) + card.ability.extra.xmultmod
                    return {
                        message = 'Again!',
                        repetitions = card.ability.extra.repetitions,
                        card = card
                    }
                else
                    -- Explicitly block retrigger if Ace condition is met
                    return {
                        message = "No retrigger (2 Aces in play)",
                        card = card
                    }
                end
            end
        end

        -- Increment xmult for each scored Diamond card
        if context.cardarea == G.jokers and context.before and not context.blueprint then
            if context.scoring_card and context.scoring_card:is_suit("Diamonds") then
                card.ability.extra.xmult = (card.ability.extra.xmult or 0) + card.ability.extra.xmultmod
                return {
                    message = localize('k_upgrade_ex'),
                    colour = G.C.Mult,
                    card = card
                }
            end
        end

        -- Pass xmult value if this Joker is the main scorer
        if context.joker_main then
            local extra = card.ability.extra
            if extra and extra.xmult and extra.xmult > 0 then
                local result = {
                    message = localize{type='variable', key='a_xmult', vars={extra.xmult}},
                    Xmult_mod = extra.xmult,
                }
                extra.xmult = 0 -- Reset xmult to 0
                return result
            end
        end
    end,
}

----------------------------------------------
------------MONTAGUE'S MEDALLION CODE END----------------------

----------------------------------------------
------------MAGMAREEF CODE BEGIN----------------------

SMODS.Joker {
    key = 'MagmaReef',
    loc_txt = {
        name = '[EPIC] MagmaReef',
        text = {
            "When {C:attention}blind selected{}, {C:mult}destroy{}",
            "every {C:purple}LTM Card{} in your consumable",
            "area and gain {C:chips}+#1# {C:chips}Chips{} per card destroyed",
            "{C:inactive}Currently{} {C:chips}+#2# {C:inactive}Chips"
        }
    },
    config = {extra = {stored_chips = 0, chips_per_card = 50}},
    rarity = 3,
    pos = {x = 2, y = 10},
    atlas = 'Jokers',
    cost = 5,
    unlocked = true,
    discovered = false,
    blueprint_compat = true,
	loc_vars = function(self, info_queue, card)
		return {vars = {card.ability.extra.chips_per_card, card.ability.extra.stored_chips}}
    end,
    calculate = function(self, card, context)
        -- LTM card destruction at the start of blind selection
        if context.setting_blind and not card.getting_sliced then
            local destroyed_count = 0

            for i, v in pairs(G.consumeables.cards) do
                if v.ability.set == 'LTMConsumableType' then
                    v.getting_sliced = true
                    G.GAME.consumeable_buffer = G.GAME.consumeable_buffer - 1
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            -- Visual dissolve and sound effects
                            G.GAME.consumeable_buffer = 0
                            card:juice_up(0.8, 0.8)
                            v:start_dissolve(G.C.money, nil, 1.6)
                            play_sound('generic1', 0.96 + math.random() * 0.08)
                            return true
                        end
                    }))
                    destroyed_count = destroyed_count + 1
                    delay(0.5)
                end
            end

            -- Add chips for destroyed cards
            local gained_chips = destroyed_count * card.ability.extra.chips_per_card
            card.ability.extra.stored_chips = card.ability.extra.stored_chips + gained_chips

            -- Log chip gain
            if destroyed_count > 0 then
                SMODS.eval_this(card, {
                    message = ("Upgrade!"),
                    colour = G.C.CHIPS
                })
            end
        end

        -- Joker main scoring logic (after destruction and chip calculation)
        if context.joker_main then
            return {
                message = localize {type = 'variable', key = 'a_chips', vars = {card.ability.extra.stored_chips}},
                chip_mod = card.ability.extra.stored_chips,
                colour = G.C.CHIPS
            }
        end
    end
}

----------------------------------------------
------------MAGMAREEF CODE END----------------------

----------------------------------------------
------------DURR BURGER CODE BEGIN----------------------

if config.oldcalccompat ~= false then
    SMODS.Joker{
        key = 'DurrBurger', 
        loc_txt = {
            ['en-us'] = {
                name = "Durr Burger", 
                text = {
                    "Having cards of the same rank in the {C:attention}first{} and {C:attention}last{} slot",
                    "Gives {C:mult}+#1#{} Mult",
                }
            }
        },
        atlas = 'Jokers',
        pos = { x = 2, y = 11 },
        config = {
            extra = { mult = 10 },
        },
        rarity = 1,
        cost = 5,
        blueprint_compat = true,

        loc_vars = function(self, info_queue, center)
            return { vars = { self.config.extra.mult } }
        end,

        calculate = function(self, card, context)
            if context.joker_main then
                local scoring_hand = context.scoring_hand

                if #scoring_hand >= 2 then
                    local first_id = scoring_hand[1]:get_id()
                    local last_id = scoring_hand[#scoring_hand]:get_id()

                    if first_id == last_id then
                        return {
                            message = localize {
                                type = 'variable',
                                key = 'sj_mult',
                                vars = { card.ability.extra.mult }
                            },
                            mult_mod = card.ability.extra.mult,
                            card = self
                        }
                    end
                end
            end
        end
    }
end

if config.newcalccompat ~= false then
    SMODS.Joker{
        key = 'DurrBurger', 
        loc_txt = {
            ['en-us'] = {
                name = "Durr Burger", 
                text = {
                    "Having cards of the same rank in the {C:attention}first{} and {C:attention}last{} slot",
                    "Gives {C:mult}+#1#{} Mult",
                }
            }
        },
        atlas = 'Jokers',
        pos = { x = 2, y = 11 },
        config = {
            extra = { mult = 10 },
        },
        rarity = 1,
        cost = 5,
        blueprint_compat = true,

        loc_vars = function(self, info_queue, center)
            return { vars = { self.config.extra.mult } }
        end,

        calculate = function(self, card, context)
            if context.joker_main then
                local scoring_hand = context.scoring_hand

                if #scoring_hand >= 2 then
                    local first_id = scoring_hand[1]:get_id()
                    local last_id = scoring_hand[#scoring_hand]:get_id()

                    if first_id == last_id then
                        return {
                            mult = card.ability.extra.mult,
                            card = self
                        }
                    end
                end
            end
        end
    }
end


----------------------------------------------
------------DURR BURGER CODE END----------------------

----------------------------------------------
------------ACES WILD CODE BEGIN----------------------

SMODS.Joker {
    key = 'AcesWild',
    loc_txt = {
        name = 'Aces Wild',
        text = {
            "Retriggers every scoring {C:attention}Ace{} and {C:hearts}Wild Card{} card played {C:attention}#1#{} times",
            "{X:mult,C:white}X#2#{} Mult for each scoring {C:attention}Ace{} or {C:hearts}Wild Card{} in played hand",
        }
    },
    rarity = 3,
    atlas = "Jokers",
    pos = {x = 0, y = 12},
    cost = 5,
    unlocked = true,
    discovered = false,
    eternal_compat = true,
    blueprint_compat = true,
    perishable_compat = false,
    ability = {
        extra = {
            repetitions = 1,
            xmultmod = 1.5,
            xmult = 0, -- Ensure xmult starts as 0
        },
    },

    loc_vars = function(self, info_queue, card)
        if not card.ability.extra then
            card.ability.extra = { xmult = 0, repetitions = 1, xmultmod = 1.5 }
        end

        return {
            vars = {
                card.ability.extra.repetitions,
                card.ability.extra.xmultmod,
                card.ability.extra.xmult
            }
        }
    end,

    calculate = function(self, card, context)
        -- Calculate Ace count
        local ace_count = 0
        if context.joker_main or context.cardarea == G.play then
            for _, scoring_card in ipairs(context.scoring_hand) do
                if scoring_card:get_id() == 14 then -- Ace card ID
                    ace_count = ace_count + 1
                end
            end

            -- Self-destruct if 9999 or more Aces if you actually triggered this how and why wtf are you doing bruh 
            if ace_count >= 9999 then
                card:start_dissolve()
                return
            end
        end

        -- Diamond Retrigger Logic with Ace or Wild Card Check
        if context.cardarea == G.play and context.repetition and not context.repetition_only then
            if context.other_card and (context.other_card:get_id() == 14 or context.other_card.ability.name == 'Wild Card') then
                -- Prevent retrigger if there are 5 or more Aces
                if ace_count < 9999 then
                    card.ability.extra.xmult = (card.ability.extra.xmult or 0) + card.ability.extra.xmultmod
                    return {
                        message = 'Again!',
                        repetitions = card.ability.extra.repetitions,
                        card = card
                    }
                else
                    -- Explicitly block retrigger if Ace condition is met
                    return {
                        message = "No retrigger (5 Aces in play)",
                        card = card
                    }
                end
            end
        end

        -- Increment xmult for each scored Ace or Wild Card
        if context.cardarea == G.jokers and context.before and not context.blueprint then
            if context.scoring_card and (context.scoring_card:get_id() == 14 or context.scoring_card.ability.name == 'Wild Card') then  -- Check for Ace or Wild Card
                card.ability.extra.xmult = (card.ability.extra.xmult or 0) + card.ability.extra.xmultmod
                return {
                    message = localize('k_upgrade_ex'),
                    colour = G.C.Mult,
                    card = card
                }
            end
        end

        -- Pass xmult value if this Joker is the main scorer
        if context.joker_main then
            local extra = card.ability.extra
            if extra and extra.xmult and extra.xmult > 0 then
                local result = {
                    message = localize{type='variable', key='a_xmult', vars={extra.xmult}},
                    Xmult_mod = extra.xmult,
                }
                extra.xmult = 0 -- Reset xmult to 0
                return result
            end
        end
    end,
}

----------------------------------------------
------------ACES WILD CODE END----------------------

----------------------------------------------
------------MIKU CODE BEGIN----------------------
SMODS.Joker({
    key = 'Miku',
    loc_txt = {
        name = 'Hatsune Miku',
        text = {
            "Played {C:attention}3{}'s and {C:attention}9{}'s give {X:mult,C:white}X#1#{} Mult when scored",
        }
    },
    rarity = 3,
    atlas = "Jokers",
    pos = {x = 1, y = 12},
    cost = 9,
    unlocked = true,
    discovered = false,
    eternal_compat = true,
    blueprint_compat = true,
    perishable_compat = false,
    config = {
        extra = {
            Xmult = 1.39,  -- Multiplier for scoring 3 or 9
        },
    },

    loc_vars = function(self, info_queue, card)
        return {
            vars = {card.ability.extra.Xmult}  -- Refer to multiplier correctly
        }
    end,

    calculate = function(self, card, context)
        -- Ensure extra values are set (for safety)
        if not card.ability.extra then
            card.ability.extra = { Xmult = 1.39 }
        end

        -- Apply multiplier individually for each card based on its ID
        if context.individual and context.cardarea == G.play then
            local card_id = context.other_card:get_id()
            if card_id == 3 or card_id == 9 then
                return {
                    x_mult = card.ability.extra.Xmult,  -- Apply multiplier to the current card
                    card = card
                }
            end
        end

        return nil  -- No multiplier if the card isn't a 3 or 9
    end,
})


----------------------------------------------
------------MIKU CODE END----------------------

----------------------------------------------
------------UPGRADE BENCH CODE BEGIN----------------------

SMODS.Sound({
	key = "upgrade",
	path = "upgrade.ogg",
})


SMODS.Joker {
    name = "Upgrade Bench",
    key = "Bench",
    config = {extra = {}},
    pos = {x = 2, y = 12},
    loc_txt = {
        name = "Upgrade Bench",
        text = {
            "Enhance one random card",
            "into an {C:attention}Enhanced{} Card when",
            "first hand is drawn",
        }
    },
    rarity = 1,
    cost = 5,
    unlocked = true,
    discovered = false,
    blueprint_compat = true,
    perishable_compat = true,
    atlas = "Jokers",
    
    loc_vars = function(self, info_queue, center)
        return { vars = { ''..(G.GAME and G.GAME.probabilities.normal or 1), center.ability.extra.odds} }
    end,

    calculate = function(self, card, context)
        if context.first_hand_drawn then
            G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
                -- Collect non-enhanced cards in hand
                local non_enh_list = {}
                for _, hand_card in ipairs(G.hand.cards) do
                    if hand_card.config.center == G.P_CENTERS.c_base then
                        table.insert(non_enh_list, hand_card)
                    end
                end
                
                -- If there are valid cards, apply a random enhancement
                if #non_enh_list > 0 then
                    local enhanced_card = pseudorandom_element(non_enh_list, pseudoseed('bench'))

                    -- Use poll_enhancement to dynamically select an enhancement
                    local enhancement_key = {key = 'upgrade', guaranteed = true}
                    local random_enhancement = G.P_CENTERS[SMODS.poll_enhancement(enhancement_key)]
                    
                    -- Apply the enhancement
                    enhanced_card:set_ability(random_enhancement, nil, true)

                    -- Apply visuals & sound feedback
					if config.sfx ~= false then
						play_sound('fn_upgrade')
					end
                    enhanced_card:juice_up()
                end
                return true
            end}))
        end
    end
}

----------------------------------------------
------------UPGRADE BENCH CODE END----------------------

----------------------------------------------
------------THE NOTHING CODE BEGIN----------------------

if config.oldcalccompat ~= false then
    SMODS.Joker {
        name = "The Nothing",
        key = "Nothing",
        config = {
            extra = {
                destroyed = 0,
                mult = 0,
                multmod = 2
            }
        },
        pos = {x = 3, y = 12},
        loc_txt = {
            name = "The Nothing",
            text = {
                "{C:mult}Destroy{} one random Card when first hand is drawn",
                "Gain {C:mult}+#1#{} Mult for each Card destroyed in this way",
                "{C:inactive}Currently {C:mult}+#2#{} {C:inactive}Mult{}",
            }
        },
        rarity = 1,
        cost = 7,
        unlocked = true,
        discovered = false,
        blueprint_compat = true,
        perishable_compat = true,
        atlas = "Jokers",

        loc_vars = function(self, info_queue, card)
            return {
                vars = {
                    card.ability.extra.multmod,
                    card.ability.extra.mult
                }
            }
        end,

        calculate = function(self, card, context)
            if context.first_hand_drawn then
                G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
                    local non_enh_list = {}
                    for _, hand_card in ipairs(G.hand.cards) do
                        if hand_card.config.center == G.P_CENTERS.c_base then
                            table.insert(non_enh_list, hand_card)
                        end
                    end

                    if #non_enh_list > 0 then
                        local destroyed_card = pseudorandom_element(non_enh_list, pseudoseed('Nothing'))

                        destroyed_card:start_dissolve()

                        card.ability.extra.destroyed = card.ability.extra.destroyed + 1
                        card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.multmod

                        G.E_MANAGER:add_event(Event({
                            func = function()
                                card_eval_status_text(
                                    card,
                                    "extra",
                                    nil,
                                    nil,
                                    nil,
                                    {
                                        message = localize({
                                            type = "variable",
                                            key = "sj_mult",
                                            vars = { card.ability.extra.mult },
                                        }),
                                    }
                                )
                                return true
                            end,
                        }))
                    end
                    return true
                end}))
            end

            if context.joker_main then
                return {
                    message = localize {
                        type = 'variable',
                        key = 'sj_mult',
                        vars = { card.ability.extra.mult }
                    },
                    mult_mod = card.ability.extra.mult,
                    card = self
                }
            end
        end
    }
end

if config.newcalccompat ~= false then
    SMODS.Joker {
        name = "The Nothing",
        key = "Nothing",
        config = {
            extra = {
                destroyed = 0,
                mult = 0,
                multmod = 2
            }
        },
        pos = {x = 3, y = 12},
        loc_txt = {
            name = "The Nothing",
            text = {
                "{C:mult}Destroy{} one random Card when first hand is drawn",
                "Gain {C:mult}+#1#{} Mult for each Card destroyed in this way",
                "{C:inactive}Currently {C:mult}+#2#{} {C:inactive}Mult{}",
            }
        },
        rarity = 1,
        cost = 7,
        unlocked = true,
        discovered = false,
        blueprint_compat = true,
        perishable_compat = true,
        atlas = "Jokers",

        loc_vars = function(self, info_queue, card)
            return {
                vars = {
                    card.ability.extra.multmod,
                    card.ability.extra.mult
                }
            }
        end,

        calculate = function(self, card, context)
            if context.first_hand_drawn then
                G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
                    local non_enh_list = {}
                    for _, hand_card in ipairs(G.hand.cards) do
                        if hand_card.config.center == G.P_CENTERS.c_base then
                            table.insert(non_enh_list, hand_card)
                        end
                    end

                    if #non_enh_list > 0 then
                        local destroyed_card = pseudorandom_element(non_enh_list, pseudoseed('Nothing'))

                        destroyed_card:start_dissolve()

                        card.ability.extra.destroyed = card.ability.extra.destroyed + 1
                        card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.multmod

                        G.E_MANAGER:add_event(Event({
                            func = function()
                                card_eval_status_text(
                                    card,
                                    "extra",
                                    nil,
                                    nil,
                                    nil,
                                    {
                                        message = localize('k_upgrade_ex'),
										colour = G.C.Mult,
										card = card
                                    }
                                )
                                return true
                            end,
                        }))
                    end
                    return true
                end}))
            end

            if context.joker_main then
                return {
                    mult = card.ability.extra.mult,
                    card = self
                }
            end
        end
    }
end


----------------------------------------------
------------THE NOTHING CODE END----------------------


----------------------------------------------
------------THE FLIP CODE BEGIN----------------------

SMODS.Sound({
	key = "end",
	path = "end.ogg",
})

SMODS.Joker{
    key = 'Flip',
    loc_txt = {
        name = 'The Flip',
        text = {
            "This Joker Gains {X:mult,C:white}X#1#{} Mult",
            "for each {C:attention}Flipped{} card held in hand",
            "{C:inactive}Currently {X:mult,C:white}X#2#{}{C:inactive} Mult"
        }
    },
    rarity = 2,
    atlas = "Jokers", pos = {x = 4, y = 12},
    cost = 7,
    unlocked = true,
    discovered = false,
    eternal_compat = true,
    blueprint_compat = true,
    perishable_compat = false,
    config = {extra = {Xmult_add = 0.2, Xmult = 1}},
    
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.Xmult_add, card.ability.extra.Xmult}}
    end, 
    
    calculate = function(self, card, context)
        if context.cardarea == G.jokers and context.before and not context.blueprint then 
            local flipped_count = 0
            -- Count the number of flipped cards in hand
            for i = 1, #G.hand.cards do
                if G.hand.cards[i].facing == 'back' then
                    flipped_count = flipped_count + 1
                end
            end
            -- If there are flipped cards, increase the multiplier based on the count
            if flipped_count > 0 then
                card.ability.extra.Xmult = card.ability.extra.Xmult + (card.ability.extra.Xmult_add * flipped_count)
                if config.sfx ~= false then
                    play_sound("fn_end")
                end
                return {
                    message = localize('k_upgrade_ex'),
                    colour = G.C.Mult,
                    card = card
                }
            end
        end
        if context.joker_main then
            return {
                message = localize{type='variable', key='a_xmult', vars={card.ability.extra.Xmult}},
                Xmult_mod = card.ability.extra.Xmult,
            }
        end
    end,
}

----------------------------------------------
------------THE FLIP CODE END----------------------

----------------------------------------------
------------MALFUNCTIONING VENDING MACHINE CODE BEGIN----------------------

if config.oldcalccompat ~= false then
    SMODS.Joker {
        key = 'MVM',
        loc_txt = {
            ['en-us'] = {
                name = 'Malfunctioning Vending Machine',
                text = {
                    'Every time you {C:attention}purchase{} something',
                    'gain {C:money}$#1#{}',
                }
            }
        },
        atlas = 'Jokers',
        pos = { x = 0, y = 13 },
        config = {
            extra = {
                dollars = 5,    -- Money granted on purchase
            }
        },
        rarity = 3,           -- Rare joker
        cost = 10,             -- Cost to purchase
        blueprint_compat = true,

        loc_vars = function(self, info_queue, card)
            return {
                vars = {
                    card.ability.extra.dollars,
                }
            }
        end,

        calculate = function(self, card, context)
            -- Check if an item is purchased (including reroll or booster)
            if context.buying_card or context.reroll_shop or context.open_booster then
                local money = card.ability.extra.dollars

                -- Directly give the money without odds
                if money > 0 then
                    ease_dollars(money)
                    G.GAME.dollar_buffer = (G.GAME.dollar_buffer or 0) + money
                    G.E_MANAGER:add_event(Event({func = (function() G.GAME.dollar_buffer = 0; return true end)}))
                end
            end
        end
    }
end


if config.newcalccompat ~= false then
    SMODS.Joker {
        key = 'MVM',
        loc_txt = {
            ['en-us'] = {
                name = 'Malfunctioning Vending Machine',
                text = {
                    'Every time you {C:attention}purchase{} something',
                    'gain {C:money}$#1#{}',
                }
            }
        },
        atlas = 'Jokers',
        pos = { x = 0, y = 13 },
        config = {
            extra = {
                dollars = 5,    -- Money granted on purchase
            }
        },
        rarity = 3,           -- Rare joker
        cost = 10,             -- Cost to purchase
        blueprint_compat = true,

        loc_vars = function(self, info_queue, card)
            return {
                vars = {
                    card.ability.extra.dollars,
                }
            }
        end,

        calculate = function(self, card, context)
            -- Trigger when an item is purchased (card, reroll, or booster)
            if context.buying_card or context.reroll_shop or context.open_booster then
                return {
                    dollars = card.ability.extra.dollars,
                    colour = G.C.MONEY
                }
            end
        end
    }
end

----------------------------------------------
------------MALFUNCTIONING VENDING MACHINE CODE END----------------------

----------------------------------------------
------------THANOS CODE BEGIN----------------------

SMODS.Sound({
	key = "dust",
	path = "dust.ogg",
})


SMODS.Joker {
    name = "Thanos",
    key = "Thanos",
    config = {
        extra = {
            odds = 8  -- 1 in 8 chance to activate
        }
    },
    pos = {x = 1, y = 13},
    loc_txt = {
        name = "Thanos",
        text = {
            "When {C:attention}Blind Starts{} {C:green}#2#{} in {C:green}#1#{} chance to",
            "{C:mult}destroy{} half of everything",
            "and create a {C:purple}Legendary{} Joker",
        }
    },
    rarity = 3,
    cost = 6,
    unlocked = true,
    discovered = false,
    blueprint_compat = true,
    perishable_compat = true,
    atlas = "Jokers",

    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.extra.odds,
                '' .. (G.GAME and G.GAME.probabilities.normal or 1),
            }
        }
    end,

    calculate = function(self, card, context)
        if context.first_hand_drawn then
            G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
                local odds = card.ability.extra.odds
                local chance = G.GAME.probabilities.normal / odds

                if pseudorandom('Thanos') < chance then
                    -- Collect all cards separately
                    local jokers, consumables, hand_cards = {}, {}, {}

                    for _, c in ipairs(G.hand.cards) do table.insert(hand_cards, c) end
                    for _, c in ipairs(G.jokers.cards) do table.insert(jokers, c) end
                    for _, c in ipairs(G.consumeables.cards) do table.insert(consumables, c) end

                    -- Function to destroy a rounded-up half of a card list
                    local function destroy_half(card_list)
                        local num_to_destroy = math.ceil(#card_list / 2)
                        for i = 1, num_to_destroy do
                            if #card_list > 0 then
                                local randomIndex = math.random(#card_list)
                                local target = card_list[randomIndex]
                                if config.sfx ~= false then
									play_sound("fn_dust")
								end
                                target:start_dissolve()
                                table.remove(card_list, randomIndex)
                            end
                        end
                    end

                    -- Destroy cards separately
                    destroy_half(jokers)
                    destroy_half(consumables)
                    destroy_half(hand_cards)

                    -- Create a Legendary Joker
                    local new_joker = create_card("Joker", G.jokers, true, 4, nil, nil, nil, "")
                    new_joker:add_to_deck()
                    new_joker:start_materialize()
                    G.jokers:emplace(new_joker)

                    return {
                        message = "Balanced...",
                        colour = G.C.MAGENTA
                    }
                end
                return true
            end}))
        end
    end
}

----------------------------------------------
------------THANOS CODE END----------------------

----------------------------------------------
------------ROCKET RACING CODE BEGIN----------------------

SMODS.Joker {
    key = 'Racing',
    loc_txt = {
        name = 'Rocket Racing',
        text = {
            "{C:chips}#1#{} Chips for each hand played",
            "At 0 gain an extra Joker slot",
            "{C:inactive}Currently{} {C:chips}+#2# {C:inactive}Chips"
        }
    },
    config = {extra = {stored_chips = 200, chips_per_card = -10, slot_granted = false}},
    rarity = 2,
    pos = {x = 2, y = 13},
    atlas = 'Jokers',
    cost = 9,
    unlocked = true,
    discovered = false,
    blueprint_compat = true,

    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.chips_per_card, card.ability.extra.stored_chips}}
    end,

    calculate = function(self, card, context)
        if context.joker_main then
            -- Apply stored chips as a score boost
            local stored_chips = card.ability.extra.stored_chips
            local chips_lost = card.ability.extra.chips_per_card

            -- Queue a delayed event to reduce stored chips AFTER scoring
            G.E_MANAGER:add_event(Event({
                func = function()
                    -- Reduce stored chips but prevent negatives
                    local new_stored_chips = math.max(0, stored_chips + chips_lost)
                    card.ability.extra.stored_chips = new_stored_chips

                    -- Show message as "-10 Chips" (without formatting issues)
                    SMODS.eval_this(card, {
                        message = string.format("-%d Chips", math.abs(chips_lost)),
                        colour = G.C.CHIPS
                    })

                    -- If stored chips hit zero and slot hasn't been granted, grant an extra Joker slot
                    if new_stored_chips == 0 and not card.ability.extra.slot_granted then
                        card.ability.extra.slot_granted = true
                        G.jokers.config.card_limit = G.jokers.config.card_limit + 1

                        -- Show a message for the new Joker slot
                        SMODS.eval_this(card, {
                            message = "Extra Joker Slot!",
                            colour = G.C.VOUCHER
                        })
                    end
                    return true
                end
            }))

            return {
                message = localize {type = 'variable', key = 'a_chips', vars = {stored_chips}},
                chip_mod = stored_chips,
                colour = G.C.CHIPS
            }
        end
    end,

    remove_from_deck = function(self, card)
        -- Remove the extra slot if the card is removed
        if card.ability.extra.slot_granted then
            G.jokers.config.card_limit = G.jokers.config.card_limit - 1
        end
    end
}

----------------------------------------------
------------ROCKET RACING CODE END----------------------

----------------------------------------------
------------50v50 CODE BEGIN----------------------

if config.oldcalccompat ~= false then
    SMODS.Joker {
        key = '50v50',
        loc_txt = {
            name = '50v50',
            text = {
                'Has a {C:green,E:1,S:1.1}#1# in #2#{} chance to give {C:chips}+#3#{} Chips',
                'else give {C:mult}+#4#{} Mult',
            }
        },
        config = {
            extra = { 
                chips_per_card = 50,
                mult_per_card = 50,
                odds = 2
            },
            no_pool_flag = 'gamble',
        },
        rarity = 1,
        pos = {x = 3, y = 13},
        atlas = 'Jokers',
        cost = 5,
        unlocked = true,
        discovered = false,
        blueprint_compat = true,
        loc_vars = function(self, info_queue, card)
            return {
                vars = {
                    G.GAME.probabilities.normal,
                    card.ability.extra.odds,
                    card.ability.extra.chips_per_card,
                    card.ability.extra.mult_per_card
                }
            }
        end,
        calculate = function(self, card, context)
            if context.joker_main then
                G.GAME.pool_flags.gamble = true

                if pseudorandom('50vs50') < G.GAME.probabilities.normal / card.ability.extra.odds then
                    return {
                        message = localize {type = 'variable', key = 'a_chips', vars = {card.ability.extra.chips_per_card}},
                        chip_mod = card.ability.extra.chips_per_card,
                        colour = G.C.CHIPS
                    }
                else
                    return {
                        message = localize {type = 'variable', key = 'a_mult', vars = {card.ability.extra.mult_per_card}},
                        mult_mod = card.ability.extra.mult_per_card,
                        colour = G.C.MULT
                    }
                end
            end
        end
    }
end

if config.newcalccompat ~= false then
    SMODS.Joker {
        key = '50v50',
        loc_txt = {
            name = '50v50',
            text = {
                'Has a {C:green,E:1,S:1.1}#1# in #2#{} chance to give {C:chips}+#3#{} Chips',
                'else give {C:mult}+#4#{} Mult',
            }
        },
        config = {
            extra = { 
                chips_per_card = 50,
                mult_per_card = 50,
                odds = 2
            },
            no_pool_flag = 'gamble',
        },
        rarity = 1,
        pos = {x = 3, y = 13},
        atlas = 'Jokers',
        cost = 5,
        unlocked = true,
        discovered = false,
        blueprint_compat = true,
        loc_vars = function(self, info_queue, card)
            return {
                vars = {
                    G.GAME.probabilities.normal,
                    card.ability.extra.odds,
                    card.ability.extra.chips_per_card,
                    card.ability.extra.mult_per_card
                }
            }
        end,
        calculate = function(self, card, context)
            if context.joker_main then
                G.GAME.pool_flags.gamble = true

                if pseudorandom('50vs50') < G.GAME.probabilities.normal / card.ability.extra.odds then
                    return {
                        chips = card.ability.extra.chips_per_card,
                        colour = G.C.CHIPS
                    }
                else
                    return {
                        mult = card.ability.extra.mult_per_card,
                        colour = G.C.MULT
                    }
                end
            end
        end
    }
end

----------------------------------------------
------------50v50 CODE END----------------------

----------------------------------------------
------------DOUBLE PUMP CODE BEGIN----------------------

SMODS.Sound({
	key = "pump",
	path = "pump.ogg",
})

SMODS.Joker{
    key = "DoublePump",
    loc_txt = {
        name = "Double Pump",
        text = {
            "Retriggers every scoring played card {C:attention}#1#{} times",
            "Takes 2 Joker slots instead of 1"
        }
    },
    rarity = 2,
    atlas = "Jokers",
    pos = { x = 4, y = 13 },
    cost = 6,
    order = 32,
    no_pool_flag = 'pump',
    blueprint_compat = true,
    config = {
        extra = {
            repetitions = 1,  -- Number of times scoring cards will retrigger
        },
    },
    
    loc_vars = function(self, info_queue, card)
        -- Return the retriggers for each card
        return {
            vars = {card.ability.extra.repetitions}
        }
    end,

    -- Adjust Joker slots when added
    add_to_deck = function()
        if G.jokers then
            G.jokers.config.card_limit = G.jokers.config.card_limit - 1  -- Uses an extra slot
        end
    end,

    -- Restore Joker slot when removed
    remove_from_deck = function()
        if G.jokers then
            G.jokers.config.card_limit = G.jokers.config.card_limit + 1  -- Returns the extra slot
        end
    end,

    calculate = function(self, card, context)
        -- Only trigger retriggering for scoring cards
        if context.repetition and context.cardarea == G.play then
            -- Perform retrigger based on card's repetitions
            for i = 1, card.ability.extra.repetitions do
                -- Trigger the retrigger process for each repetition
                G.GAME.pool_flags.pump = true  -- Set 'clam' flag to trigger retrigger
                -- Play the sound after retriggering
                if config.sfx ~= false then
                    play_sound("fn_pump")
                end
                return {
                    message = "Again!",
                    repetitions = card.ability.extra.repetitions - i + 1,  -- Adjust repetitions left for each retrigger
                    card = card,
                }
            end
        end
    end,
}

----------------------------------------------
------------DOUBLE PUMP CODE END----------------------

----------------------------------------------
------------FESTIVAL CODE BEGIN----------------------

SMODS.Sound({
	key = "charge",
	path = "charge.ogg",
})

SMODS.Sound({
	key = "song1",
	path = "song1.ogg",
})

SMODS.Sound({
	key = "song2",
	path = "song2.ogg",
})

SMODS.Sound({
	key = "song3",
	path = "song3.ogg",
})

SMODS.Sound({
	key = "song4",
	path = "song4.ogg",
})

SMODS.Sound({
	key = "song5",
	path = "song5.ogg",
})


SMODS.Joker{
  key = 'Festival',
  loc_txt = {
    name = 'Fortnite Festival',
    text = {
      "This Joker Gains a charge when the condition is met",
      "At 2 charges gives {X:mult,C:white}X#1#{} Mult",
      "Current charges: {C:attention}#2#",
      "Current condition: {C:attention}#3#",
      "{C:inactive} changes every round"
    }
  },
  rarity = 2,
  atlas = "Jokers", pos = {x = 0, y = 14},
  cost = 5,
  unlocked = true,
  discovered = false,
  eternal_compat = true,
  blueprint_compat = true,
  perishable_compat = false,
  config = {extra = {Xmult = 3, charge = 0, required_hand = "High Card"}}, -- Default to a valid hand

  loc_vars = function(self, info_queue, card)
    return {vars = {card.ability.extra.Xmult, card.ability.extra.charge, card.ability.extra.required_hand}}
  end,

  -- Function to set a new random required hand
  set_new_hand = function(self, card)
    local available_hands = {}

    -- Get all valid poker hands from the game
    for hand_name, hand_data in pairs(G.GAME.hands) do
      if hand_data.visible then
        table.insert(available_hands, hand_name)
      end
    end

    -- Ensure a different hand is chosen each round
    if #available_hands > 1 then  -- Prevent infinite loop if only one hand type is valid
      local old_hand = card.ability.extra.required_hand
      local new_hand = old_hand

      while new_hand == old_hand do
        new_hand = pseudorandom_element(available_hands, pseudoseed('festival_hand'))
      end

      card.ability.extra.required_hand = new_hand
    end
  end,

  calculate = function(self, card, context)
    -- Ensure the required hand is set at creation if it somehow wasn't initialized
    if not card.ability.extra.required_hand then
      self:set_new_hand(card)
    end

    -- Set a new required hand when the first hand is drawn
    if context.first_hand_drawn then
      self:set_new_hand(card)
    end

    -- Gain charge when the required hand is played
    if context.cardarea == G.jokers and context.before and not context.blueprint then 
      if context.scoring_name == card.ability.extra.required_hand then
        -- Increment charge counter
        card.ability.extra.charge = (card.ability.extra.charge or 0) + 1

        -- Play charge sound effect
        if config.sfx ~= false then
          play_sound("fn_charge")
        end

        -- Check if charges >= 2 and play the activation sound if necessary
        if card.ability.extra.charge >= 2 then
          if config.sfx ~= false then
            local songs = {"fn_song1", "fn_song2", "fn_song3", "fn_song4"}
            local chosen_song = pseudorandom_element(songs, pseudoseed('festival_song'))
            play_sound(chosen_song)
          end
        end

        return {
          message = "Charge Gained! (" .. card.ability.extra.charge .. "/2)",
          colour = G.C.Mult,
          card = card
        }
      end
    end

    -- Activate the Joker if it has 2 charges
    if context.joker_main and card.ability.extra.charge >= 2 then
      local mult_value = card.ability.extra.Xmult

      -- Reset charge counter after activation
      card.ability.extra.charge = 0

      return {
        message = localize{type='variable',key='a_xmult',vars={mult_value}},
        Xmult_mod = mult_value
      }
    end
  end,

  remove_from_deck = function(self, card)
    -- Play removal sound effect when sold or removed
    if config.sfx ~= false then
      play_sound("fn_song5")
    end
  end,
}

----------------------------------------------
------------FESTIVAL CODE END----------------------

----------------------------------------------
------------KINETIC BLADE CODE BEGIN----------------------

SMODS.Sound({
	key = "bladecharge",
	path = "bladecharge.ogg",
})

SMODS.Sound({
	key = "kblade",
	path = "kblade.ogg",
})

SMODS.Sound({
	key = "bladebreak",
	path = "bladebreak.ogg",
})


SMODS.Joker{
  key = 'KineticBlade',
  loc_txt = {
    name = 'Kinetic Blade',
    text = {
      "Gains a charge when a hand is played",
      "At 3 charges gives {X:mult,C:white}X#1#{} Mult",
      "Current charges: {C:attention}#2#",
    }
  },
  rarity = 2,
  atlas = "Jokers", pos = {x = 1, y = 14},
  cost = 5,
  unlocked = true,
  discovered = false,
  eternal_compat = true,
  blueprint_compat = true,
  perishable_compat = true,
  config = {extra = {Xmult = 3, charge = 0}},

  loc_vars = function(self, info_queue, card)
    return {vars = {card.ability.extra.Xmult, card.ability.extra.charge}}
  end,

  calculate = function(self, card, context)
    -- Gain charge when any hand is played
    if context.cardarea == G.jokers and context.before and not context.blueprint then
      card.ability.extra.charge = card.ability.extra.charge + 1

      -- Play charge sound effect
      if config.sfx ~= false then play_sound("fn_bladecharge") end

      -- Play activation sound at 3 charges
      if card.ability.extra.charge == 3 and config.sfx ~= false then
        play_sound("fn_kblade")
      end

      return {message = "Charge Gained! (" .. card.ability.extra.charge .. "/3)", colour = G.C.Mult, card = card}
    end

    -- Activate at 3 charges
    if context.joker_main and card.ability.extra.charge >= 3 then
      local mult_value = card.ability.extra.Xmult
      card.ability.extra.charge = 0  -- Reset charge counter

      return {message = localize{type='variable',key='a_xmult',vars={mult_value}}, Xmult_mod = mult_value}
    end
  end,

  remove_from_deck = function(self, card)
    if config.sfx ~= false then play_sound("fn_bladebreak") end
  end,
}

----------------------------------------------
------------KINETIC BLADE CODE END----------------------

----------------------------------------------
------------KADO THORNE'S TIME MACHINE CODE BEGIN----------------------

SMODS.Sound({
	key = "time",
	path = "time.ogg",
})

SMODS.Joker{
  key = 'Kado',
  loc_txt = {
    name = "Kado Thorne's Time Machine",
    text = {
      "Sell this card to randomize the ante between {C:attention}-2{} and {C:attention}+2{}",
    }
  },
  rarity = 3,
  atlas = "Jokers", pos = {x = 2, y = 14},
  cost = 10,
  unlocked = true,
  discovered = false,
  eternal_compat = true,
  blueprint_compat = false,
  perishable_compat = false,

  calculate = function(self, card, context)
    if context.selling_self then
      -- Play sound effect when selling
      if config.sfx ~= false then 
        play_sound("fn_time") 
      end

      -- Randomize ante between -2 and +2, but never 0
      local ante_shift = ({-2, -1, 1, 2})[math.random(4)]

      ease_ante(ante_shift)

      -- Ensure the ante properly updates in game state
      G.GAME.round_resets.blind_ante = G.GAME.round_resets.blind_ante or G.GAME.round_resets.ante
      G.GAME.round_resets.blind_ante = math.max(1, G.GAME.round_resets.blind_ante + ante_shift)
    end
  end
}

----------------------------------------------
------------KADO THORNE'S TIME MACHINE CODE END----------------------

----------------------------------------------
------------TYPHOON BLADE CODE BEGIN----------------------
SMODS.Joker{
  key = 'TyphoonBlade',
  loc_txt = {
    name = "Typhoon Blade",
    text = {
      "Sell this card to instantly win a non-boss blind",
      "and get {C:attention}3{} free {C:green}rerolls{} on the next shop",
    }
  },
  rarity = 3,
  atlas = "Jokers", pos = {x = 3, y = 14},
  cost = 10,
  unlocked = true,
  discovered = false,
  eternal_compat = true,
  blueprint_compat = false,
  perishable_compat = false,

  calculate = function(self, card, context)
    if context.selling_self then
        G.E_MANAGER:add_event(Event({
            trigger = "immediate",
            func = function()
                if G.STATE == G.STATES.SELECTING_HAND and not G.GAME.blind.boss then
                    -- Ensure the player has enough chips to win the blind
                    local blind_chips = G.GAME.blind.chips
                    G.GAME.chips = math.max(G.GAME.chips, blind_chips)

                    -- End the round successfully
                    G.STATE = G.STATES.HAND_PLAYED
                    G.STATE_COMPLETE = true
                    end_round()

                    -- Grant 3 free rerolls, using Chaos the Clown's method
                    for i = 1, 3 do
                        G.GAME.current_round.free_rerolls = G.GAME.current_round.free_rerolls + 1
                        calculate_reroll_cost(true)
                    end
                end
                return true
            end
        }), "other")
    end
  end
}

----------------------------------------------
------------TYPHOON BLADE CODE END----------------------

----------------------------------------------
------------FLETCHER KANE CODE BEGIN----------------------
SMODS.Joker({
    key = "Kane",
    loc_txt = {
        name = "Fletcher Kane",
        text = {
            "Retriggers every {C:money}Gold{} card {C:attention}#1#{} times",
        }
    },
    rarity = 2,
    atlas = "Jokers",
    pos = { x = 0, y = 15 },
    cost = 6,
    unlocked = true,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    config = { extra = { repetitions = 1 } },

    loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = G.P_CENTERS.m_gold
		info_queue[#info_queue + 1] = G.P_CENTERS.e_cry_gold
		info_queue[#info_queue + 1] = G.P_SEALS.Gold
        return { vars = { card.ability.extra.repetitions } }
    end,

    calculate = function(self, card, context)
        -- Check if a Gold Card is played or in hand
        if context.repetition and context.cardarea == G.play then
            if context.other_card and context.other_card.ability.name == 'Gold Card' or context.other_card.edition and context.other_card.edition.key == 'e_cry_gold' or context.other_card.seal == 'Gold' then
                return {
                    repetitions = card.ability.extra.repetitions,
                    message = localize('k_again_ex'),
                    card = card
                }
            end
        end

        -- Handle Gold cards in hand
        if context.cardarea == G.hand then
            for i = 1, #G.hand.cards do
                if context.other_card and context.other_card.ability.name == 'Gold Card' then
                    return {
                        repetitions = card.ability.extra.repetitions,
                        message = localize('k_again_ex'),
                        card = card
                    }
                end
            end
        end
    end
})

----------------------------------------------
------------FLETCHER KANE CODE END----------------------

----------------------------------------------
------------DILL BIT CODE BEGIN----------------------

if config.oldcalccompat ~= false then
    SMODS.Joker{
        key = 'DB',
        loc_txt = {
            ['en-us'] = {
                name = "Dill Bit",
                text = {
                    "Adds the sell value of all owned",
                    "{C:attention}Jokers{} and {C:attention}Consumables{} to mult",
                    "{C:inactive}Currently {C:mult}+#1#{} {C:inactive}Mult{}",
                }
            }
        },
        atlas = 'Jokers',
        pos = { x = 1, y = 15 },
        config = {
            extra = { mult = 0 }
        },
        rarity = 2,
        cost = 5,
        blueprint_compat = true,

        loc_vars = function(self, info_queue, card)
            card.ability.extra.mult = self:calculate_sell_cost()
            return {
                vars = { card.ability.extra.mult }
            }
        end,

        calculate_sell_cost = function(self)
            local sell_cost = 0

            if G.jokers and G.jokers.cards then
                for _, joker in ipairs(G.jokers.cards) do
                    if joker ~= self and joker.area == G.jokers then
                        sell_cost = sell_cost + (joker.sell_cost or 0)
                    end
                end
            end

            if G.consumeables and G.consumeables.cards then
                for _, consumable in ipairs(G.consumeables.cards) do
                    if consumable.area == G.consumeables then
                        sell_cost = sell_cost + (consumable.sell_cost or 0)
                    end
                end
            end

            return sell_cost
        end,

        calculate = function(self, card, context)
            card.ability.extra.mult = self:calculate_sell_cost()

            if context.joker_main then
                return {
                    message = localize {
                        type = 'variable',
                        key = 'sj_mult',
                        vars = { card.ability.extra.mult }
                    },
                    mult_mod = card.ability.extra.mult,
                    card = self
                }
            end
        end
    }
end

if config.newcalccompat ~= false then
    SMODS.Joker{
        key = 'DB',
        loc_txt = {
            ['en-us'] = {
                name = "Dill Bit",
                text = {
                    "Adds the sell value of all owned",
                    "{C:attention}Jokers{} and {C:attention}Consumables{} to mult",
                    "{C:inactive}Currently {C:mult}+#1#{} {C:inactive}Mult{}",
                }
            }
        },
        atlas = 'Jokers',
        pos = { x = 1, y = 15 },
        config = {
            extra = { mult = 0, scaling = 1,}
        },
        rarity = 2,
        cost = 5,
        blueprint_compat = true,

        loc_vars = function(self, info_queue, card)
            card.ability.extra.mult = self:calculate_sell_cost()
            return {
                vars = { card.ability.extra.mult }
            }
        end,

        calculate_sell_cost = function(self)
            local sell_cost = 0

            if G.jokers and G.jokers.cards then
                for _, joker in ipairs(G.jokers.cards) do
                    if joker ~= self and joker.area == G.jokers then
                        sell_cost = sell_cost + (joker.sell_cost or 0)
                    end
                end
            end

            if G.consumeables and G.consumeables.cards then
                for _, consumable in ipairs(G.consumeables.cards) do
                    if consumable.area == G.consumeables then
                        sell_cost = sell_cost + (consumable.sell_cost or 0)
                    end
                end
            end

            return sell_cost
        end,

        calculate = function(self, card, context)
            card.ability.extra.mult = self:calculate_sell_cost()

            if context.joker_main then
                return {
                    mult = card.ability.extra.mult,
                    card = self
                }
            end
        end
    }
end


----------------------------------------------
------------DILL BIT CODE END----------------------

----------------------------------------------
------------VULTURE BOON CODE BEGIN----------------------
if config.oldcalccompat ~= false then
    SMODS.Joker{
        key = 'Vulture',
        loc_txt = {
            name = 'Vulture Boon',
            text = {
                "Each discarded card has a {C:green}#1# in #2#{} chance",
                "to permanently gain {C:chips}+#3#{} chips",
            }
        },
        config = {
            extra = { 
                chips = 10,  -- Permanent chip gain per triggered discard
                odds = 3     -- 1 in 3 chance per discarded card
            }
        },
        rarity = 1,
        pos = {x = 2, y = 15},
        atlas = 'Jokers',
        cost = 5,
        unlocked = true,
        discovered = false,
        blueprint_compat = true,

        loc_vars = function(self, info_queue, card)
            return {
                vars = {G.GAME.probabilities.normal, card.ability.extra.odds, card.ability.extra.chips}
            }
        end,

        calculate = function(self, card, context)
            if context.discard and context.other_card then  -- Trigger only on discarded cards
                local discardedCard = context.other_card  -- Get the discarded card
                if pseudorandom('vulture') < G.GAME.probabilities.normal/card.ability.extra.odds then
                    -- Apply permanent chip bonus
                    discardedCard.ability.perma_bonus = (discardedCard.ability.perma_bonus or 0) + card.ability.extra.chips

                    -- Ensure visual effect applies
                    discardedCard:juice_up()

                    return {
                        extra = { message = "Upgrade!", colour = G.C.CHIPS },
                        colour = G.C.CHIPS,
                        card = discardedCard
                    }
                end
            end
        end,
    }
end
if config.newcalccompat ~= false then
    SMODS.Joker{
        key = 'Vulture',
        loc_txt = {
            name = 'Vulture Boon',
            text = {
                "Each discarded card has a {C:green}#1# in #2#{} chance",
                "to permanently gain {C:chips}+#3#{} chips",
            }
        },
        config = {
            extra = { 
                chips = 10,  -- Permanent chip gain per triggered discard
                odds = 3     -- 1 in 3 chance per discarded card
            }
        },
        rarity = 1,
        pos = {x = 2, y = 15},
        atlas = 'Jokers',
        cost = 5,
        unlocked = true,
        discovered = false,
        blueprint_compat = true,

        loc_vars = function(self, info_queue, card)
            return {
                vars = {
                    G.GAME.probabilities.normal, 
                    card.ability.extra.odds, 
                    card.ability.extra.chips
                }
            }
        end,

        calculate = function(self, card, context)
            -- Triggered on discard
            if context.discard and context.other_card then
                local discardedCard = context.other_card
                if pseudorandom('vulture') < G.GAME.probabilities.normal / card.ability.extra.odds then
                    -- Apply chip upgrade with a delayed visual effect
                    G.E_MANAGER:add_event(Event({
                        trigger = "after",
                        delay = 0.15,
                        func = function()
                            discardedCard.ability.perma_bonus = (discardedCard.ability.perma_bonus or 0) + card.ability.extra.chips
                            discardedCard:juice_up()
                            return true
                        end
                    }), 'base')
                end
            end
        end
    }
end

----------------------------------------------
------------VULTURE BOON CODE END----------------------

----------------------------------------------
------------JANE BALATRO CODE BEGIN----------------------

SMODS.Joker {
    key = 'CassidyQuinn',
    loc_txt = {
        name = 'Cassidy Quinn',
        text = {
            "When {C:attention}blind selected{}",
            "Create {C:attention}#1#{} random cards in hand with {C:hearts}Hearts{} or {C:spades}Spades{}"
        }
    },
    config = {extra = {cards = 1}},
    rarity = 2,
    pos = {x = 3, y = 15},
    atlas = 'Jokers',
    cost = 5,
    unlocked = true,
    discovered = false,
    blueprint_compat = true,
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.cards}}
    end,
    calculate = function(self, card, context)
        if context.first_hand_drawn then
            G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
                    local num_cards = card.ability.extra.cards or 1  -- Default to 1 if nil
                    for _ = 1, num_cards do
                        -- Pick a random Hearts or Spades card
                        local valid_cards = {}
                        for _, v in pairs(G.P_CARDS) do
                            if v.suit == 'Hearts' or v.suit == 'Spades' then
                                table.insert(valid_cards, v)
                            end
                        end

                        if #valid_cards > 0 then
                            local chosen_card = pseudorandom_element(valid_cards, pseudoseed('cassidy_quinn'))
                            local new_card = create_playing_card(
                                {
                                    front = chosen_card,
                                    center = G.P_CENTERS.c_base
                                },
                                G.hand
                            )

                            -- Visual & sound feedback
                            new_card:juice_up(0.3, 0.3)
                            play_sound('card1', 1.1)
                        end
                    end

                    return true
                end
            }))
        end
    end
}

----------------------------------------------
------------JANE BALATRO CODE END----------------------

----------------------------------------------
------------THERMITE CODE BEGIN----------------------

SMODS.Joker{
    key = 'Termite',
    loc_txt = {
        name = 'Thermite',
        text = {
            "Each discarded card has a {C:green}#1# in #2#{} chance",
            "to be {C:mult}destroyed{} instead granting {C:chips}+#3#{} chips",
            "{C:inactive}Currently{} {C:chips}+#4# {C:inactive}Chips"
        }
    },
    config = {
        extra = { 
            chips_per_card = 10,  -- Chips gained per destroyed card
            odds = 3,             -- 1 in 3 chance per discarded card
            stored_chips = 0      -- Tracks accumulated chips
        }
    },
    rarity = 1,
    pos = {x = 4, y = 15},
    atlas = 'Jokers',
    cost = 5,
    unlocked = true,
    discovered = false,
    blueprint_compat = true,

    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                G.GAME.probabilities.normal, 
                card.ability.extra.odds, 
                card.ability.extra.chips_per_card, 
                card.ability.extra.stored_chips
            }
        }
    end,

    calculate = function(self, card, context)
        if context.discard and context.other_card then  -- Trigger only on discarded cards
            local discardedCard = context.other_card
            if pseudorandom('termite') < G.GAME.probabilities.normal / card.ability.extra.odds then
                -- Add a delay before destroying the card, similar to Fracture
                G.E_MANAGER:add_event(Event({
                    func = function()
                        -- Destroy the discarded card after the delay
                        discardedCard:start_dissolve()

                        -- Increase Joker's stored chips
                        card.ability.extra.stored_chips = card.ability.extra.stored_chips + card.ability.extra.chips_per_card

                        -- Ensure visual effect
                        card:juice_up()

                        -- Display effect
                        return {
                            extra = { message = "Burnt Up!", colour = G.C.CHIPS },
                            colour = G.C.CHIPS,
                            card = card
                        }
                    end,
                    delay = 0.5  -- Delay of 0.5 seconds before destroying the card
                }), 'base')
                
                -- Return early to prevent immediate execution
                return true
            end
        end

        -- Joker main scoring logic (adds stored chips when scored)
        if context.joker_main then
            return {
                message = localize {type = 'variable', key = 'a_chips', vars = {card.ability.extra.stored_chips}},
                chip_mod = card.ability.extra.stored_chips,
                colour = G.C.CHIPS
            }
        end
    end
}


----------------------------------------------
------------THERMITE CODE END----------------------

----------------------------------------------
------------SHADOW LOGO CODE BEGIN----------------------


if config.oldcalccompat ~= false then
    SMODS.Joker {
        key = 'Shadow',
        loc_txt = {
            name = 'Shadow Logo',
            text = {
                "This Joker Gains {C:mult}+#2#{} Mult",
                "if played hand contains a {C:spades}Dark{} {C:clubs}Suit{} Flush",
                "{C:inactive}Currently{} {C:mult}+#1#{}{C:inactive} Mult",
                "Idea: BoiRowan"
            }
        },
        rarity = 2,
        atlas = "Jokers",
        pos = {x = 3, y = 17},
        cost = 5,
        unlocked = true,
        discovered = false,
        eternal_compat = true,
        blueprint_compat = true,
        perishable_compat = false,
        config = {
            extra = {
                mult = 0,
                multmod = 8
            }
        },
        loc_vars = function(self, info_queue, card)
            return {
                vars = {
                    card.ability.extra.mult,
                    card.ability.extra.multmod
                }
            }
        end,
        calculate = function(self, card, context)
            if context.cardarea == G.jokers and context.before and not context.blueprint then
                if context.scoring_name == "Flush" or
                   context.scoring_name == "Straight Flush" or
                   context.scoring_name == "Royal Flush" or
                   context.scoring_name == "Flush Five" or
                   context.scoring_name == "Flush House" then
                    for _, scoring_card in ipairs(context.scoring_hand) do
                        if scoring_card:is_suit("Spades") or scoring_card:is_suit("Clubs") then
                            card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.multmod
                            return {
                                message = localize('k_upgrade_ex'),
                                colour = G.C.Mult,
                                card = card
                            }
                        end
                    end
                end
            end

            if context.joker_main then
                return {
                    message = localize {
                        type = 'variable',
                        key = 'sj_mult',
                        vars = { card.ability.extra.mult }
                    },
                    mult_mod = card.ability.extra.mult,
                    card = self
                }
            end
        end
    }
end

if config.newcalccompat ~= false then
    SMODS.Joker {
        key = 'Shadow',
        loc_txt = {
            name = 'Shadow Logo',
            text = {
                "This Joker Gains {C:mult}+#2#{} Mult",
                "if played hand contains a {C:spades}Dark{} {C:clubs}Suit{} Flush",
                "{C:inactive}Currently{} {C:mult}+#1#{}{C:inactive} Mult",
                "Idea: BoiRowan"
            }
        },
        rarity = 2,
        atlas = "Jokers",
        pos = {x = 3, y = 17},
        cost = 5,
        unlocked = true,
        discovered = false,
        eternal_compat = true,
        blueprint_compat = true,
        perishable_compat = false,
        config = {
            extra = {
                mult = 0,
                multmod = 8
            }
        },
        loc_vars = function(self, info_queue, card)
            return {
                vars = {
                    card.ability.extra.mult,
                    card.ability.extra.multmod
                }
            }
        end,
        calculate = function(self, card, context)
            if context.cardarea == G.jokers and context.before and not context.blueprint then
                if context.scoring_name == "Flush" or
                   context.scoring_name == "Straight Flush" or
                   context.scoring_name == "Royal Flush" or
                   context.scoring_name == "Flush Five" or
                   context.scoring_name == "Flush House" then
                    for _, scoring_card in ipairs(context.scoring_hand) do
                        if scoring_card:is_suit("Spades") or scoring_card:is_suit("Clubs") then
                            card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.multmod
                            return {
                                message = localize('k_upgrade_ex'),
                                colour = G.C.Mult,
                                card = card
                            }
                        end
                    end
                end
            end

            if context.joker_main then
                return {
                    mult = card.ability.extra.mult,
                    card = self
                }
            end
        end
    }
end


----------------------------------------------
------------SHADOW LOGO CODE END----------------------

----------------------------------------------
------------GHOST LOGO CODE BEGIN----------------------

SMODS.Joker {
    key = 'Ghost',
    loc_txt = {
        name = 'Ghost Logo',
        text = {
            "This Joker Gains {C:chips}+#1#{} Chips",
            "if played hand contains a {C:hearts}Light{} {C:diamonds}Suit{} Flush",
            "{C:inactive}Currently{} {C:chips}+#2#{}{C:inactive} Chips",
            "Idea: BoiRowan"
        }
    },
    rarity = 2,
    atlas = "Jokers",
    pos = {x = 4, y = 17},
    cost = 5,
    unlocked = true,
    discovered = false,
    eternal_compat = true,
    blueprint_compat = true,
    perishable_compat = false,
    config = {extra = {stored_chips = 0, chips_per_flush = 50}},
    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.extra.chips_per_flush,
                card.ability.extra.stored_chips
            }
        }
    end,
    calculate = function(self, card, context)
        if context.cardarea == G.jokers and context.before and not context.blueprint then
            if context.scoring_name == "Flush" or context.scoring_name == "Straight Flush" or context.scoring_name == "Royal Flush" or context.scoring_name == "Flush Five" or context.scoring_name == "Flush House" then
                for _, scoring_card in ipairs(context.scoring_hand) do
                    if scoring_card:is_suit("Hearts") or scoring_card:is_suit("Diamonds") then
                        card.ability.extra.stored_chips = card.ability.extra.stored_chips + card.ability.extra.chips_per_flush
                        SMODS.eval_this(card, {
                            message = "Upgrade!",
                            colour = G.C.CHIPS
                        })
                        return
                    end
                end
            end
        end
        
        if context.joker_main then
            return {
                message = localize {
                    type = 'variable',
                    key = 'a_chips',
                    vars = { card.ability.extra.stored_chips }
                },
                chip_mod = card.ability.extra.stored_chips,
                colour = G.C.CHIPS
            }
        end
    end
}

----------------------------------------------
------------GHOST LOGO CODE END----------------------

----------------------------------------------
------------BATTLE LAB CODE BEGIN----------------------

SMODS.Joker {
    name = "Battle Lab",
    key = "BattleLab",
    config = {
        extra = { cards = 3, copies = 1 },
    },
    pos = {x = 0, y = 18},
    loc_txt = {
        name = "Battle Lab",
        text = {
            "When {C:attention}blind is selected{}",
            "create {C:attention}#2#{} copies of {C:attention}#1#{} random cards from the deck",
            "Idea: BoiRowan"
        }
    },
    rarity = 3,
    cost = 5,
    unlocked = true,
    discovered = false,
    blueprint_compat = true,
    perishable_compat = true,
    atlas = "Jokers",
    
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.cards, card.ability.extra.copies}} 
    end,

    calculate = function(self, card, context)
        if context.first_hand_drawn then
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.4,
                func = function()
                    local num_cards = card.ability.extra.cards or 1  -- Default to 1 if nil
                    local num_copies = card.ability.extra.copies or 1  -- Default to 1 if nil

                    local all_cards = G.deck.cards  -- Get all cards in the deck
                    if not all_cards or #all_cards == 0 then
                        return false -- Exit if the deck is empty
                    end

                    -- Shuffle the deck to randomize selection
                    math.randomseed(os.time())  
                    for i = #all_cards, 2, -1 do
                        local j = math.random(1, i)
                        all_cards[i], all_cards[j] = all_cards[j], all_cards[i]
                    end

                    -- Pick random cards from the deck
                    local selected_cards = {}
                    for i = 1, math.min(#all_cards, num_cards) do
                        table.insert(selected_cards, all_cards[i])
                    end

                    -- Copy the selected cards and create new ones in hand
                    local new_cards = {}
                    for _, selected_card in ipairs(selected_cards) do
                        for _ = 1, num_copies do
                            -- Create a new card with unique attributes and add to hand
                            G.playing_card = (G.playing_card and G.playing_card + 1) or 1
                            local _card = copy_card(selected_card, nil, nil, G.playing_card)
                            _card:add_to_deck()
                            G.deck.config.card_limit = G.deck.config.card_limit + 1
                            table.insert(G.playing_cards, _card)
                            G.hand:emplace(_card)

                            -- Start materializing the new card with visual feedback
                            _card:start_materialize(nil, nil)
                            new_cards[#new_cards + 1] = _card
                        end
                    end

                    -- Apply any additional effects
                    playing_card_joker_effects(new_cards)
                    return true
                end
            }))
        end
    end,
}

----------------------------------------------
------------BATTLE LAB CODE END----------------------

----------------------------------------------
------------TENT CODE BEGIN----------------------

SMODS.Joker
{
    key = 'Tent',
    loc_txt = 
    {
        name = 'Tent',
        text = 
        {
            'When {C:attention}leaving a shop{} without {C:green}rerolling{}',
            'Create {C:attention}#1#{} {C:purple}LTM Cards',
            '{C:inactive}(Must have room)',
            'Idea: BoiRowan'
        }
    },
    atlas = 'Jokers',
    pos = {x = 3, y = 18},
    rarity = 2,
    cost = 3,
    config = 
    { 
        extra = 
        {
            cards = 2, -- Number of LTM cards created
            reroll_count = 0, -- Track rerolls in this shop session
            max_rerolls = 0 -- Allow up to X rerolls before disabling the effect
        }
    },
    
    loc_vars = function(self, info_queue, card)
        return 
        {
            vars = 
            {
                card.ability.extra.cards,
                card.ability.extra.max_rerolls
            }
        }
    end,

    calculate = function(self, card, context)
        -- Reset reroll count at the start of a new shop session (after a round ends)
        if context.end_of_round and not context.repetition and not context.individual then
            card.ability.extra.reroll_count = 0
        end

        -- Track rerolls in the shop
        if context.reroll_shop then
            card.ability.extra.reroll_count = card.ability.extra.reroll_count + 1
        end

        -- When leaving the shop, check if reroll count is within the limit
        if context.ending_shop then
            if card.ability.extra.reroll_count <= card.ability.extra.max_rerolls then
                for i = 1, card.ability.extra.cards do
                    -- Ensure there is room for a consumable
                    if #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
                        local new_card = create_card('LTMConsumableType', G.consumeables)
                        new_card:add_to_deck()
                        G.consumeables:emplace(new_card)
                    end
                end
            end

            -- Reset the reroll counter for the next shop session
            card.ability.extra.reroll_count = 0
        end
    end
}

----------------------------------------------
------------TENT CODE END----------------------

----------------------------------------------
------------SHOPPING CART CODE BEGIN----------------------

if config.oldcalccompat ~= false then
    SMODS.Joker {
        key = 'Cart',
        loc_txt = {
            ['en-us'] = {
                name = "Shopping Cart",
                text = {
                    "When {C:attention}Blind is selected{} set {C:mult}discards{} to 1",
                    "gain {C:money}$#1#{} for each discard removed in this way",
                    "Idea: BoiRowan",
                }
            }
        },
        atlas = 'Jokers',
        pos = { x = 4, y = 18 },
        config = {
            extra = { 
                dollars = 2,   -- Fixed Money Granted per discard
            }
        },
        rarity = 1,            -- Common joker
        cost = 6,             -- Cost to purchase
        blueprint_compat = true,

        loc_vars = function(self, info_queue, card)
            return {
                vars = {
                    card.ability.extra.dollars,
                }
            }
        end,

        calculate = function(self, card, context)
            -- Check if the Blind effect is starting and that conditions are met (no blueprint card or slicing)
            if context.setting_blind and not (context.blueprint_card or self).getting_sliced then
                local dollars_per_discard = card.ability.extra.dollars
                local discards_left = G.GAME.current_round.discards_left
                local money_granted = dollars_per_discard * discards_left - 2

                -- Set discards to 1 and grant money directly (no odds check)
                if money_granted > 0 then
                    -- Grant the money for each discard removed
                    ease_dollars(money_granted)
                    G.GAME.dollar_buffer = (G.GAME.dollar_buffer or 0) + money_granted
                    G.E_MANAGER:add_event(Event({func = (function() G.GAME.dollar_buffer = 0; return true end)}))
                    
                    -- Set discards to 1 (one per discard removed)
                    G.GAME.current_round.discards_left = 1

                    return {
                        message = localize('$') .. money_granted,
                        dollars = money_granted,
                        colour = G.C.MONEY
                    }
                end
            end
        end
    }
end

if config.newcalccompat ~= false then
    SMODS.Joker {
        key = 'Cart',
        loc_txt = {
            ['en-us'] = {
                name = "Shopping Cart",
                text = {
                    "When {C:attention}Blind is selected{} set {C:mult}discards{} to 1",
                    "gain {C:money}$#1#{} for each discard removed in this way",
                    "Idea: BoiRowan",
                }
            }
        },
        atlas = 'Jokers',
        pos = { x = 4, y = 18 },
        config = {
            extra = { 
                dollars = 2,   -- Fixed Money Granted per discard
            }
        },
        rarity = 1,            -- Common joker
        cost = 6,             -- Cost to purchase
        blueprint_compat = true,

        loc_vars = function(self, info_queue, card)
            return {
                vars = {
                    card.ability.extra.dollars,
                }
            }
        end,

        calculate = function(self, card, context)
            -- Check if the Blind effect is starting and that conditions are met (no blueprint card or slicing)
            if context.setting_blind and not (context.blueprint_card or self).getting_sliced then
                local dollars_per_discard = card.ability.extra.dollars
                local discards_left = G.GAME.current_round.discards_left
                local money_granted = dollars_per_discard * discards_left - 2

                -- Grant the money for each discard removed (no odds check)
                if money_granted > 0 then

                    -- Set discards to 1 (one per discard removed)
                    G.GAME.current_round.discards_left = 1

                    return {
                        dollars = money_granted,
                        colour = G.C.MONEY
                    }
                end
            end
        end
    }
end

----------------------------------------------
------------SHOPPING CART CODE END----------------------

----------------------------------------------
------------CARD VAULTING CODE BEGIN----------------------

if config.oldcalccompat ~= false then
    SMODS.Joker {
        key = 'Vault',
        loc_txt = {
            name = 'Card Vaulting',
            text = {
                "When a {C:attention}Debuffed{} Card is played {C:mult}destroy{} it",
                "Gains {C:chips}+#3#{} Chips and {C:mult}+#4#{} Mult for every card destroyed this way",
                "{C:inactive}Currently{} {C:chips}+#1#{} {C:inactive}Chips{} {C:mult}+#2#{}{C:inactive} Mult",
                "Idea: BoiRowan"
            }
        },
        rarity = 1,
        atlas = "Jokers",
        pos = {x = 4, y = 19},
        cost = 5,
        unlocked = true,
        discovered = false,
        eternal_compat = true,
        blueprint_compat = true,
        perishable_compat = false,
        config = {
            extra = {
                mult = 0,
                multmod = 1,
                chipmod = 15,
                stored_chips = 0
            }
        },
        loc_vars = function(self, info_queue, card)
            return {
                vars = {
                    card.ability.extra.stored_chips,
                    card.ability.extra.mult,
                    card.ability.extra.chipmod,
                    card.ability.extra.multmod
                }
            }
        end,
        calculate = function(self, card, context)
            card.ability.extra.stored_chips = card.ability.extra.stored_chips or 0
            
            if context.joker_main then
                for _, hand_card in ipairs(context.full_hand) do
                    if hand_card.debuff and not context.end_of_round then
                        hand_card:start_dissolve()
                        card.ability.extra.stored_chips = card.ability.extra.stored_chips + card.ability.extra.chipmod
                        card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.multmod

                        SMODS.eval_this(card, {
                            message = "Upgrade!",
                            colour = G.C.CHIPS
                        })
                    end
                end
            end

            if context.joker_main then
                return {
                    message = localize {
                        type = 'variable',
                        key = 'a_chips',
                        vars = { card.ability.extra.stored_chips }
                    },
                    chip_mod = card.ability.extra.stored_chips,
                    mult_mod = card.ability.extra.mult,
                    card = self
                }
            end
        end
    }
end

if config.newcalccompat ~= false then
    SMODS.Joker {
        key = 'Vault',
        loc_txt = {
            name = 'Card Vaulting',
            text = {
                "When a {C:attention}Debuffed{} Card is played {C:mult}destroy{} it",
                "Gains {C:chips}+#3#{} Chips and {C:mult}+#4#{} Mult for every card destroyed this way",
                "{C:inactive}Currently{} {C:chips}+#1#{} {C:inactive}Chips{} {C:mult}+#2#{}{C:inactive} Mult",
                "Idea: BoiRowan"
            }
        },
        rarity = 1,
        atlas = "Jokers",
        pos = {x = 4, y = 19},
        cost = 5,
        unlocked = true,
        discovered = false,
        eternal_compat = true,
        blueprint_compat = true,
        perishable_compat = false,
        config = {
            extra = {
                mult = 0,
                multmod = 1,
                chipmod = 15,
                stored_chips = 0
            }
        },
        loc_vars = function(self, info_queue, card)
            return {
                vars = {
                    card.ability.extra.stored_chips,
                    card.ability.extra.mult,
                    card.ability.extra.chipmod,
                    card.ability.extra.multmod
                }
            }
        end,
        calculate = function(self, card, context)
            card.ability.extra.stored_chips = card.ability.extra.stored_chips or 0
            
            if context.joker_main then
                for _, hand_card in ipairs(context.full_hand) do
                    if hand_card.debuff and not context.end_of_round then
                        hand_card:start_dissolve()
                        card.ability.extra.stored_chips = card.ability.extra.stored_chips + card.ability.extra.chipmod
                        card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.multmod

                        SMODS.eval_this(card, {
                            message = "Upgrade!",
                            colour = G.C.CHIPS
                        })
                    end
                end
            end

            if context.joker_main then
                return {
                    chips = card.ability.extra.stored_chips,
                    mult = card.ability.extra.mult,
                    card = self
                }
            end
        end
    }
end

----------------------------------------------
------------CARD VAULTING CODE END----------------------

----------------------------------------------
------------FISHING ROD CODE BEGIN----------------------

SMODS.Joker{
    key = 'Fishing',
    loc_txt = {
        name = 'Fishing Rod',
        text = {
            "If {C:mult}Discarded{} hand contains a {C:attention}Flush{}",
            "Create an {C:purple}LTM Card{}",
            "{C:inactive}(Must have room)",
            "Idea: BoiRowan"
        }
    },
    rarity = 1,
    atlas = "Jokers",
    pos = {x = 0, y = 20},
    cost = 5,
    unlocked = true,
    discovered = false,
    eternal_compat = true,
    blueprint_compat = true,
    perishable_compat = false,

    calculate = function(self, card, context)
        if context.pre_discard and not context.hook then
            local poker_hand = G.FUNCS.get_poker_hand_info(G.hand.highlighted)

            if poker_hand == "Flush" or poker_hand == "Straight Flush" or 
               poker_hand == "Royal Flush" or poker_hand == "Flush Five" or 
               poker_hand == "Flush House" then

                if #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
                -- Create and add the LTM card to the deck
                local new_card = create_card('LTMConsumableType', G.consumeables)
                new_card:add_to_deck()
                G.consumeables:emplace(new_card)
                end
            end
        end
    end,
}

----------------------------------------------
------------FISHING ROD CODE END----------------------

----------------------------------------------
------------SLURP SERIES CODE BEGIN----------------------

if config.oldcalccompat ~= false then
    SMODS.Joker {
        key = 'Slurp',
        loc_txt = {
            name = 'Slurp Series',
            text = {
                'This Joker gains {C:mult}+#2#{} Mult for every unused {C:chips}Hand{} at end of round',
                '{C:inactive}Currently {}{C:mult}+#1#{} {C:inactive}Mult{}',
                'Idea: BoiRowan'
            }
        },
        atlas = 'Jokers',
        pos = {x = 1, y = 20},
        rarity = 1,
        cost = 5,
        config = {
            extra = {
                mult = 0,
                mult_add = 2
            }
        },
        loc_vars = function(self, info_queue, center)
            return {
                vars = {
                    center.ability.extra.mult or 0,
                    center.ability.extra.mult_add or 0
                }
            }
        end,
        calculate = function(self, card, context)
            if context.joker_main then
                return {
                    message = localize {
                        type = 'variable',
                        key = 'sj_mult',
                        vars = { card.ability.extra.mult }
                    },
                    mult_mod = card.ability.extra.mult,
                    card = self
                }
            end

            if context.end_of_round and not context.repetition and not context.individual then
                local hands_left = G.GAME.current_round.hands_left or 0
                local total_gain = hands_left * card.ability.extra.mult_add

                if hands_left > 0 then
                    card.ability.extra.mult = card.ability.extra.mult + total_gain

                    return {
                        message = '+' .. total_gain .. ' Mult ',
                        colour = G.C.MULT
                    }
                end
            end
        end
    }
end

if config.newcalccompat ~= false then
    SMODS.Joker {
        key = 'Slurp',
        loc_txt = {
            name = 'Slurp Series',
            text = {
                'This Joker gains {C:mult}+#2#{} Mult for every unused {C:chips}Hand{} at end of round',
                '{C:inactive}Currently {}{C:mult}+#1#{} {C:inactive}Mult{}',
                'Idea: BoiRowan'
            }
        },
        atlas = 'Jokers',
        pos = {x = 1, y = 20},
        rarity = 1,
        cost = 5,
        config = {
            extra = {
                mult = 0,
                mult_add = 2
            }
        },
        loc_vars = function(self, info_queue, center)
            return {
                vars = {
                    center.ability.extra.mult or 0,
                    center.ability.extra.mult_add or 0
                }
            }
        end,
        calculate = function(self, card, context)
            if context.joker_main then
                return {
                    mult = card.ability.extra.mult,
                    card = self
                }
            end

            if context.end_of_round and not context.repetition and not context.individual then
                local hands_left = G.GAME.current_round.hands_left or 0
                local total_gain = hands_left * card.ability.extra.mult_add

                if hands_left > 0 then
                    card.ability.extra.mult = card.ability.extra.mult + total_gain

                    return {
                        message = '+' .. total_gain .. ' Mult ',
                        colour = G.C.MULT
                    }
                end
            end
        end
    }
end


----------------------------------------------
------------SLURP SERIES CODE END----------------------

----------------------------------------------
------------LAVA SERIES CODE BEGIN----------------------

SMODS.Joker
{
	key = 'Lava',
	loc_txt = 
	{
		name = 'Lava Series',
		text = 
		{
			'This Joker gains {C:chips}+#2#{} Chips for every unused {C:mult}Discard{} at end of round',
			'{C:inactive}Currently {}{C:chips}+#1#{} {C:inactive}Chips{}',
			'Idea: BoiRowan'
		}
	},
	atlas = 'Jokers',
	pos = {x = 2, y = 20},
	rarity = 1,
	cost = 5,
	config = 
	{ 
		extra = 
		{
			chips = 0,
			chips_add = 15 -- Increment to add per unused discard
		}
	},
	loc_vars = function(self, info_queue, center)
		return 
		{
			vars = 
			{
				center.ability.extra.chips or 0,
				center.ability.extra.chips_add or 0
			}
		}
	end,
	calculate = function(self, card, context)
		-- Display the current chips during scoring
		if context.joker_main then
			return {
                message = localize {
                    type = 'variable',
                    key = 'a_chips',
                    vars = { card.ability.extra.chips }
                },
                chip_mod = card.ability.extra.chips,
                card = self
            }
		end
		
		-- Gain chips at end of round based on unused discards
		if context.end_of_round and not context.repetition and not context.individual then
			local discards_left = G.GAME.current_round.discards_left or 0
			local total_gain = discards_left * card.ability.extra.chips_add
			
			if discards_left > 0 then
				card.ability.extra.chips = card.ability.extra.chips + total_gain
				
				return {
					message = '+' .. total_gain .. ' Chips ',
					colour = G.C.CHIPS
				}
			end
		end
	end
}

----------------------------------------------
------------LAVA SERIES CODE END----------------------

----------------------------------------------
------------ATK CODE BEGIN----------------------

SMODS.Sound({
	key = "atk",
	path = "atk.ogg",
})

SMODS.Joker{
    key = 'ATK',
    loc_txt = {
        name = "ATK",
        text = {
            "{C:attention}Sell this Joker{} to add a random enhancement, edition and seal to {C:attention}all selected cards{}",
            "{C:money}-$2{} per card modified this way",
			"Idea: BoiRowan",
        }
    },
    rarity = 1,
    atlas = "Jokers",
    pos = {x = 3, y = 20},
    cost = 3,
    unlocked = true,
    discovered = false,
    eternal_compat = true,
    blueprint_compat = false,
    perishable_compat = false,

    calculate = function(self, card, context)
        if context.selling_self and G and G.hand and G.hand.highlighted and #G.hand.highlighted > 0 then
            -- Play sound effect when selling
            if config.sfx ~= false then 
                play_sound("fn_atk") 
            end

            local modified_count = 0
            for i = 1, #G.hand.highlighted do
                local target_card = G.hand.highlighted[i]
                if target_card then
                    -- Apply random enhancement using the same logic as LTMPerk
                    local enhancement_key = {key = 'perk', guaranteed = true}
                    local random_enhancement = G.P_CENTERS[SMODS.poll_enhancement(enhancement_key)]
                    if random_enhancement then
                        target_card:set_ability(random_enhancement, true)
                    end

                    -- Apply random edition (fix function call)
                    local random_edition = poll_edition(nil, nil, false, true) 
                    if random_edition then
                        target_card:set_edition(random_edition, true)
                    end

                    -- Apply random seal using similar logic as LTMSupercharge
                    local random_seal = SMODS.poll_seal({key = 'supercharge', guaranteed = true})
                    if random_seal then
                        target_card:set_seal(random_seal, true)
                    end

                    -- Add a visual effect to "juice up" the card after sealing
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            target_card:juice_up(0.3, 0.4)
                            return true
                        end
                    }))
                    
					G.GAME.dollars = G.GAME.dollars - 2
                    modified_count = modified_count + 1
                end
            end
        end
    end
}

----------------------------------------------
------------ATK CODE END----------------------

----------------------------------------------
------------AIMBOT CODE BEGIN----------------------

SMODS.Joker {
    key = 'Aimbot',
    loc_txt = {
        name = 'Aimbot',
        text = {
            "{X:mult,C:white}X#1#{} Mult",
            "{C:green}1 in 5{} chance to {C:mult}instantly die{}",
            "Idea: BoiRowan"
        }
    },
    config = {
        extra = {
            Xmult = 5
        }
    },
    rarity = 1,
    pos = {x = 4, y = 20},
    atlas = 'Jokers',
    cost = 0,
    unlocked = true,
    discovered = false,
    blueprint_compat = true,

    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.Xmult}}
    end,

    calculate = function(self, card, context)
        if not context.joker_main then return end

        local reboot = G.GAME and G.GAME.selected_back and G.GAME.selected_back.effect.center.key == 'b_fn_RebootDeck'

        -- Step 1: Roll 1 in 5 chance to die
        if pseudorandom("death_card_trigger") < (1 / 5) then

            if reboot then
                -- Step 2: 50/50 chance with Reboot Deck
                if pseudorandom("really_die") < 0.5 then
                    -- Reboot Deck saves you
                    if config.sfx ~= false then
                        play_sound('fn_reboot')
                    end
                    ease_hands_played(1)
                    G.hand_text_area.blind_chips:juice_up()
                    G.hand_text_area.game_chips:juice_up()
                    G.GAME.chips = G.GAME.chips / 2
                else
                    -- Step 3: Check for Bandage Bazooka
                    local bazooka_card = SMODS.find_card('c_fn_LTMBazooka')[1]
                    if bazooka_card then
                        bazooka_card:start_dissolve()
                        -- No chip halving, just prevent death
                    else
                        -- No Bazooka → Game Over
                        G.E_MANAGER:add_event(Event({
                            func = function()
                                G.STATE = G.STATES.GAME_OVER
                                G.STATE_COMPLETE = false
                                if config.sfx ~= false then 
                                    play_sound("fn_fuck") 
                                end
                                return true
                            end
                        }))
                        return {
                            message = "{C:red}Banned!{}"
                        }
                    end
                end
            else
                -- No Reboot Deck → instant death
                G.E_MANAGER:add_event(Event({
                    func = function()
                        G.STATE = G.STATES.GAME_OVER
                        G.STATE_COMPLETE = false
                        if config.sfx ~= false then 
                            play_sound("fn_fuck") 
                        end
                        return true
                    end
                }))
                return {
                    message = "{C:red}Banned!{}"
                }
            end
        end

        return {
            message = localize {type = 'variable', key = 'a_xmult', vars = {card.ability.extra.Xmult}},
            Xmult_mod = card.ability.extra.Xmult,
        }
    end,
}




----------------------------------------------
------------AIMBOT CODE END----------------------

----------------------------------------------
------------BETTER AIMBOT CODE BEGIN----------------------

SMODS.Joker {
    key = 'BetterAimbot',
    loc_txt = {
        name = '*THE BEST* Ai Aimbot in Fortnite | Completely Undetected',
        text = {
            "{X:mult,C:white}X#1#{} Mult",
            "{C:green}1 in 1000{} chance to {C:mult}instantly die{}",
            "{C:money}$#2#{} monthly subscription (each round)"
        }
    },
    config = {
        extra = {
            Xmult = 5,
            dollars = 100,
        }
    },
    rarity = 3,
    pos = {x = 0, y = 21},
    atlas = 'Jokers',
    cost = 0,
    unlocked = true,
    discovered = false,
    blueprint_compat = true,

    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.extra.Xmult,
                card.ability.extra.dollars
            }
        }
    end,

    calculate = function(self, card, context)
        if not context.joker_main then return end
        
        -- 1 in 1000 chance to kill the player
        if pseudorandom("death_card_trigger") < (1 / 1000) then
           G.E_MANAGER:add_event(Event({
                func = function()
                    G.STATE = G.STATES.GAME_OVER
                    G.STATE_COMPLETE = false
                    -- Play sound effect if enabled
                    if config.sfx ~= false then 
                        play_sound("fn_fuck") 
                    end
                    return true
                end
            }))
            return {
                message = "{C:red}Banned!{}"
            }
        end

        -- Apply the multiplier effect
        return {
            message = localize {type = 'variable', key = 'a_xmult', vars = {card.ability.extra.Xmult}},
            Xmult_mod = card.ability.extra.Xmult,
        }
    end,

    calc_dollar_bonus = function(self, card)
        return -card.ability.extra.dollars
    end,
}

----------------------------------------------
------------BETTER AIMBOT CODE END----------------------

----------------------------------------------
------------SKIBIDI TOILET CODE END----------------------


SMODS.Sound({
	key = "skibidi",
	path = "skibidi.ogg",
})

SMODS.Joker{
  key = 'Skibidi',
  loc_txt = {
    name = 'Skibidi Toilet',
    text = {
      "If played hand is a {C:attention}Flush{}",
      "Create a random {C:attention}Face{} card in hand"
    }
  },
  rarity = 2,
  atlas = "Jokers",
  pos = {x = 1, y = 22},
  cost = 5,
  unlocked = true,
  discovered = false,
  eternal_compat = true,
  blueprint_compat = true,
  perishable_compat = false,

  calculate = function(self, card, context)
    if context.scoring_name == "Flush" and context.cardarea == G.played_cards then
      G.E_MANAGER:add_event(Event({
        func = function()
          local face_ranks = {"J", "Q", "K"}
          local face_suits = {"S", "H", "D", "C"}
          local chosen_rank = pseudorandom_element(face_ranks, pseudoseed('skibidi_face'))
          local chosen_suit = pseudorandom_element(face_suits, pseudoseed('skibidi_suit'))

          create_playing_card(
            {
              front = G.P_CARDS[chosen_suit.."_"..chosen_rank],
              center = G.P_CENTERS.c_base
            },
            G.hand
          ):juice_up(0.3, 0.3)

          play_sound('fn_skibidi')
          return true
        end
      }))

      return true
    end
  end
}

----------------------------------------------
------------SKIBIDI TOILET CODE END----------------------

----------------------------------------------
------------BOT LOBBY CODE BEGIN----------------------

SMODS.Joker {
    key = 'Bots',
    loc_txt = {
        name = 'Bot Lobby',
        text = {
            "When {C:attention}selecting a Blind{} {C:mult}debuffed{} cards are instead {C:mult}discarded{}",
            "Idea: BoiRowan"
        }
    },
    rarity = 1,
    atlas = "Jokers",
    pos = {x = 2, y = 22},
    cost = 5,
    unlocked = true,
    discovered = false,
    eternal_compat = true,
    blueprint_compat = true,
    perishable_compat = false,

    calculate = function(self, card, context)
    if context.first_hand_drawn then
        G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
            -- Save the current highlighted limit
            local original_highlighted_limit = G.hand.config.highlighted_limit

            -- Set the highlighted limit to 9999
            G.hand.config.highlighted_limit = 9999

            local discarded_count = 0
            local any_selected = false

            -- Iterate over both hand and deck cards to handle debuffs
            local all_cards = {G.hand.cards, G.deck.cards}
            for _, card_list in ipairs(all_cards) do
                for i = #card_list, 1, -1 do
                    local selected_card = card_list[i]
                    if selected_card.debuff then
                        G.hand:add_to_highlighted(selected_card, true)
                        table.remove(card_list, i)  -- Remove the debuffed card from the list
                        discarded_count = discarded_count + (card_list == G.hand.cards and 1 or 0)  -- Count discarded only from hand
                        any_selected = true
                    end
                end
            end

            -- Discard selected highlighted cards
            if any_selected then
                G.FUNCS.discard_cards_from_highlighted(nil, true)
            end

            -- Draw new cards to replace discarded ones from the hand
            if discarded_count > 0 then
                local cards_to_draw = math.min(discarded_count, #G.deck.cards)
                G.FUNCS.draw_from_deck_to_hand(cards_to_draw)
            end

            -- Feedback message and sound
            SMODS.eval_this(card, {
                message = "Bot Lobby Activated!",
                colour = G.C.MULT
            })

            -- Restore the original highlighted limit
			G.hand:unhighlight_all()
            G.hand.config.highlighted_limit = original_highlighted_limit

            return true
        end}))
    end
end
}

----------------------------------------------
------------BOT LOBBY CODE END----------------------

----------------------------------------------
------------NICKEH30 CODE BEGIN----------------------

SMODS.Sound({
	key = "nick",
	path = "nick.ogg",
})

if config.oldcalccompat ~= false then
    SMODS.Joker {
        key = 'NickEh30',
        loc_txt = {
            name = 'NickEh30',
            text = {
                "Gains {C:mult}+#1#{} Mult for every {C:attention}unscored card{} in played hand",
                "{C:attention}Resets{} if played hand has no unscored cards",
                "{C:inactive}Currently {C:mult}+#2#{}{C:inactive} Mult", 
                "Idea: BoiRowan",
            }
        },
        rarity = 1,
        atlas = "Jokers", pos = {x = 3, y = 22},
        cost = 5,
        unlocked = true,
        discovered = false,
        eternal_compat = true,
        blueprint_compat = true,
        perishable_compat = false,
        config = {extra = {mult_add = 1, mult = 0}},

        loc_vars = function(self, info_queue, card)
            return {vars = {card.ability.extra.mult_add, card.ability.extra.mult}}
        end,

        calculate = function(self, card, context)
            if context.cardarea == G.jokers and context.before and not context.blueprint then 
                local scoringSet = {}
                for _, played_card in ipairs(context.scoring_hand or {}) do
                    scoringSet[played_card] = true
                end

                local unscoredCards = {}
                for _, thisCard in ipairs(context.full_hand or {}) do
                    if not scoringSet[thisCard] then
                        table.insert(unscoredCards, thisCard)
                    end
                end

                if #unscoredCards > 0 then
                    card.ability.extra.mult = card.ability.extra.mult + (#unscoredCards * card.ability.extra.mult_add)
                    if config.sfx ~= false then
                        play_sound("fn_nick")
                    end
                    return {
                        message = localize('k_upgrade_ex'),
                        colour = G.C.Mult,
                        card = card
                    }
                elseif card.ability.extra.mult > 0 then
                    card.ability.extra.mult = 0
                    return {
                        message = localize('k_reset'),
                        card = card
                    }
                end
            end

            if context.joker_main then
                return {
                    message = localize {
                        type = 'variable',
                        key = 'sj_mult',
                        vars = { card.ability.extra.mult }
                    },
                    mult_mod = card.ability.extra.mult,
                    card = self
                }
            end
        end
    }
end

if config.newcalccompat ~= false then
    SMODS.Joker {
        key = 'NickEh30',
        loc_txt = {
            name = 'NickEh30',
            text = {
                "Gains {C:mult}+#1#{} Mult for every {C:attention}unscored card{} in played hand",
                "{C:attention}Resets{} if played hand has no unscored cards",
                "{C:inactive}Currently {C:mult}+#2#{}{C:inactive} Mult", 
                "Idea: BoiRowan",
            }
        },
        rarity = 1,
        atlas = "Jokers", pos = {x = 3, y = 22},
        cost = 5,
        unlocked = true,
        discovered = false,
        eternal_compat = true,
        blueprint_compat = true,
        perishable_compat = false,
        config = {extra = {mult_add = 1, mult = 0}},

        loc_vars = function(self, info_queue, card)
            return {vars = {card.ability.extra.mult_add, card.ability.extra.mult}}
        end,

        calculate = function(self, card, context)
            if context.cardarea == G.jokers and context.before and not context.blueprint then 
                local scoringSet = {}
                for _, played_card in ipairs(context.scoring_hand or {}) do
                    scoringSet[played_card] = true
                end

                local unscoredCards = {}
                for _, thisCard in ipairs(context.full_hand or {}) do
                    if not scoringSet[thisCard] then
                        table.insert(unscoredCards, thisCard)
                    end
                end

                if #unscoredCards > 0 then
                    card.ability.extra.mult = card.ability.extra.mult + (#unscoredCards * card.ability.extra.mult_add)
                    if config.sfx ~= false then
                        play_sound("fn_nick")
                    end
                    return {
                        message = localize('k_upgrade_ex'),
                        colour = G.C.Mult,
                        card = card
                    }
                elseif card.ability.extra.mult > 0 then
                    card.ability.extra.mult = 0
                    return {
                        message = localize('k_reset'),
                        card = card
                    }
                end
            end

            if context.joker_main then
                return {
                    mult = card.ability.extra.mult,
                    card = self
                }
            end
        end
    }
end


----------------------------------------------
------------NICKEH30 CODE END----------------------

----------------------------------------------
------------RIFTGUN CODE BEGIN----------------------

SMODS.Joker{
    name = "Rift Launcher",
    key = "RiftGun",
    config = { extra = { uses_left = 2 } }, -- Can prevent death twice
    pos = { x = 0, y = 23 },
    loc_txt = {
        name = "Rift Launcher",
        text = {
            "Prevents death twice",
        }
    },
    rarity = 3,
    cost = 8,
    unlocked = true,
    discovered = false,
    blueprint_compat = false,
    perishable_compat = true,
    atlas = "Jokers",
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.uses_left } }
    end,
    calculate = function(self, card, context)
        if context.end_of_round and not context.blueprint and context.game_over then
            G.E_MANAGER:add_event(Event({
                func = function()
                    -- Visual feedback for chips
                    G.hand_text_area.blind_chips:juice_up()
                    G.hand_text_area.game_chips:juice_up()

                    -- Play a sound effect
                    if config.sfx ~= false then
                        play_sound('fn_rift')
                    end

                    -- Prevent the game over
                    context.game_over = false

                    -- Decrease uses and check if it should dissolve
                    card.ability.extra.uses_left = card.ability.extra.uses_left - 1
                    if card.ability.extra.uses_left <= 0 then
                        card:start_dissolve()
                    end

                    return true
                end
            }))

            return {
                message = localize('k_saved_ex') .. " (" .. card.ability.extra.uses_left-1 .. " left)",
                saved = true,
                colour = G.C.RED
            }
        end
    end
}

----------------------------------------------
------------RIFTGUN CODE END----------------------

----------------------------------------------
------------RABBIT CODE BEGIN----------------------

SMODS.Joker{
    key = "Rabbit",
    loc_txt = {
        name = "Wood Rabbit",
        text = {
            "If {C:attention}played hand{} contains a {C:money}Wood{} card retrigger all cards",
            "Retrigger all cards twice if all are {C:money}Wood{}",
            "Idea: BoiRowan"
        }
    },
    rarity = 2,
    atlas = "Jokers",
    pos = { x = 1, y = 23 },
    cost = 6,
    unlocked = true,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    config = {
        extra = { repetitions = 1 },
    },

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS.m_fn_Wood
        return { vars = { card.ability.extra.repetitions } }
    end,

    -- Checks for Wood cards by center config and triggers retriggers
    calculate = function(self, card, context)
        local any_wood = false
        local all_wood = true

        -- Check if there are any Wood cards in the played hand by center config
        if context.cardarea == G.play then
            for _, card_in_hand in ipairs(G.play.cards) do
                if card_in_hand.config.center == G.P_CENTERS.m_fn_Wood then
                    any_wood = true
                else
                    all_wood = false
                end
            end

            -- If there are any Wood cards, trigger retriggers
            if any_wood then
                local reps = all_wood and 2 or 1

                return {
                    message = localize('k_again_ex'),  -- Customize the message as needed
                    repetitions = reps,
                    card = card
                }
            end
        end
    end,
}

----------------------------------------------
------------RABBIT CODE END----------------------

----------------------------------------------
------------FOX CODE BEGIN----------------------

SMODS.Joker{
    key = "Fox",
    loc_txt = {
        name = "Brick Fox",
        text = {
            "If {C:attention}played hand{} contains a {C:mult}Brick{} card retrigger all cards",
            "Retrigger all cards twice if all are {C:mult}Brick{}",
        }
    },
    rarity = 2,
    atlas = "Jokers",
    pos = { x = 2, y = 23 },
    cost = 6,
    unlocked = true,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    config = {
        extra = { repetitions = 1 },  -- Track how many retriggers
    },

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS.m_fn_Brick
        return { vars = { card.ability.extra.repetitions } }
    end,

    -- Checks for Brick cards by center config and triggers retriggers
    calculate = function(self, card, context)
        local any_brick = false
        local all_brick = true

        -- Check if there are any Brick cards in the played hand by center config
        if context.cardarea == G.play then
            for _, card_in_hand in ipairs(G.play.cards) do
                if card_in_hand.config.center == G.P_CENTERS.m_fn_Brick then
                    any_brick = true
                else
                    all_brick = false
                end
            end

            -- If there are any Brick cards, trigger retriggers
            if any_brick then
                local reps = all_brick and 2 or 1

                return {
                    message = localize('k_again_ex'),  -- Customize the message as needed
                    repetitions = reps,
                    card = card
                }
            end
        end
    end,
}

----------------------------------------------
------------FOX CODE END----------------------

----------------------------------------------
------------LLAMA CODE BEGIN----------------------

SMODS.Joker{
    key = "Llama",
    loc_txt = {
        name = "Metal Llama",
        text = {
            "If {C:attention}played hand{} contains a {C:inactive}Metal{} card retrigger all cards",
            "Retrigger all cards twice if all are {C:inactive}Metal{}",
        }
    },
    rarity = 2,
    atlas = "Jokers",
    pos = { x = 3, y = 23 },
    cost = 6,
    unlocked = true,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    config = {
        extra = { repetitions = 1 },  -- Track how many retriggers
    },

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS.m_fn_Metal
        return { vars = { card.ability.extra.repetitions } }
    end,

    -- Checks for Metal cards by center config and triggers retriggers
    calculate = function(self, card, context)
        local any_metal = false
        local all_metal = true

        -- Check if there are any Metal cards in the played hand by center config
        if context.cardarea == G.play then
            for _, card_in_hand in ipairs(G.play.cards) do
                if card_in_hand.config.center == G.P_CENTERS.m_fn_Metal then
                    any_metal = true
                else
                    all_metal = false
                end
            end

            -- If there are any Metal cards, trigger retriggers
            if any_metal then
                local reps = all_metal and 2 or 1

                return {
                    message = localize('k_again_ex'),  -- Customize the message as needed
                    repetitions = reps,
                    card = card
                }
            end
        end
    end,
}

----------------------------------------------
------------LLAMA CODE END----------------------

----------------------------------------------
------------HIDE AND SEEK CODE BEGIN----------------------

if config.oldcalccompat ~= false then
    SMODS.Joker{
        key = 'Hide',
        loc_txt = {
            name = 'Hide And Seek',
            text = {
                "Gains {C:mult}+#2#{} Mult if {C:attention}played hand{} has exactly {C:attention}#1#{} unscored cards",
                "{C:inactive}Currently {C:mult}+#3#{}{C:inactive} Mult", 
                "Idea: BoiRowan",
            }
        },
        rarity = 2,
        atlas = "Jokers", pos = {x = 4, y = 23},
        cost = 5,
        unlocked = true,
        discovered = false,
        eternal_compat = true,
        blueprint_compat = true,
        perishable_compat = false,
        config = {extra = {mult_add = 3, mult = 0, required_unscored = nil}},

        loc_vars = function(self, info_queue, card)
            return {
                vars = {
                    card.ability.extra.required_unscored or 0,
                    card.ability.extra.mult_add,
                    card.ability.extra.mult
                }
            }
        end,

        calculate = function(self, card, context)
            if card.ability.extra.required_unscored == nil then
                card.ability.extra.required_unscored = pseudorandom('hide_seed', 0, 4)
            end

            if context.cardarea == G.jokers and context.before and not context.blueprint then
                local scoringSet = {}
                for _, scored_card in ipairs(context.scoring_hand or {}) do
                    scoringSet[scored_card] = true
                end

                local unscoredCount = 0
                for _, thisCard in ipairs(context.full_hand or {}) do
                    if not scoringSet[thisCard] then
                        unscoredCount = unscoredCount + 1
                    end
                end

                if unscoredCount == card.ability.extra.required_unscored then
                    card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.mult_add
                    card.ability.extra.required_unscored = pseudorandom(
                        'hide_reroll_'..tostring(G.GAME.round_resets.hands_played or 0), 0, 4
                    )
                    return {
                        message = localize('k_upgrade_ex'),
                        colour = G.C.Mult,
                        card = card
                    }
                end
            end

            if context.joker_main then
                return {
                    message = localize {
                        type = 'variable',
                        key = 'sj_mult',
                        vars = { card.ability.extra.mult }
                    },
                    mult_mod = card.ability.extra.mult,
                    card = self
                }
            end
        end
    }
end

if config.newcalccompat ~= false then
    SMODS.Joker{
        key = 'Hide',
        loc_txt = {
            name = 'Hide And Seek',
            text = {
                "Gains {C:mult}+#2#{} Mult if {C:attention}played hand{} has exactly {C:attention}#1#{} unscored cards",
                "{C:inactive}Currently {C:mult}+#3#{}{C:inactive} Mult", 
                "Idea: BoiRowan",
            }
        },
        rarity = 2,
        atlas = "Jokers", pos = {x = 4, y = 23},
        cost = 5,
        unlocked = true,
        discovered = false,
        eternal_compat = true,
        blueprint_compat = true,
        perishable_compat = false,
        config = {extra = {mult_add = 3, mult = 0, required_unscored = nil}},

        loc_vars = function(self, info_queue, card)
            return {
                vars = {
                    card.ability.extra.required_unscored or 0,
                    card.ability.extra.mult_add,
                    card.ability.extra.mult
                }
            }
        end,

        calculate = function(self, card, context)
            if card.ability.extra.required_unscored == nil then
                card.ability.extra.required_unscored = pseudorandom('hide_seed', 0, 4)
            end

            if context.cardarea == G.jokers and context.before and not context.blueprint then
                local scoringSet = {}
                for _, scored_card in ipairs(context.scoring_hand or {}) do
                    scoringSet[scored_card] = true
                end

                local unscoredCount = 0
                for _, thisCard in ipairs(context.full_hand or {}) do
                    if not scoringSet[thisCard] then
                        unscoredCount = unscoredCount + 1
                    end
                end

                if unscoredCount == card.ability.extra.required_unscored then
                    card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.mult_add
                    card.ability.extra.required_unscored = pseudorandom(
                        'hide_reroll_'..tostring(G.GAME.round_resets.hands_played or 0), 0, 4
                    )
                    return {
                        message = localize('k_upgrade_ex'),
                        colour = G.C.Mult,
                        card = card
                    }
                end
            end

            if context.joker_main then
                return {
                    mult = card.ability.extra.mult,
                    card = self
                }
            end
        end
    }
end


----------------------------------------------
------------HIDE AND SEEK CODE END----------------------

----------------------------------------------
------------KEVIN CODE BEGIN----------------------

if config.oldcalccompat ~= false then
    SMODS.Joker{
        key = 'Cubert',
        loc_txt = {
            ['en-us'] = {
                name = "Kevin The Cube",
                text = {
                    "Gain {C:mult}+#2#{} Mult for every {C:purple}Cubic{} card in your full deck",
                    "{C:inactive}Currently {C:mult}+#1#{} {C:inactive}Mult",
                }
            }
        },
        atlas = 'Jokers',
        pos = { x = 0, y = 24 },
        config = {
            extra = { mult = 0, multmod = 2 }
        },
        rarity = 2,
        cost = 6,
        blueprint_compat = true,

        loc_vars = function(self, info_queue, card)
            info_queue[#info_queue + 1] = G.P_CENTERS.m_fn_Cubic
            return {
                vars = {
                    card.ability.extra.mult,
                    card.ability.extra.multmod
                }
            }
        end,

        calculate = function(self, card, context)
            local tally = 0
            for _, v in pairs(G.playing_cards) do
                if v.config.center == G.P_CENTERS.m_fn_Cubic then
                    tally = tally + 1
                end
            end
            card.ability.extra.mult = tally * card.ability.extra.multmod

            if context.joker_main then
                return {
                    message = localize {
                        type = 'variable',
                        key = 'sj_mult',
                        vars = { card.ability.extra.mult }
                    },
                    mult_mod = card.ability.extra.mult,
                    card = self
                }
            end
        end
    }
end

if config.newcalccompat ~= false then
    SMODS.Joker{
        key = 'Cubert',
        loc_txt = {
            ['en-us'] = {
                name = "Kevin The Cube",
                text = {
                    "Gain {C:mult}+#2#{} Mult for every {C:purple}Cubic{} card in your full deck",
                    "{C:inactive}Currently {C:mult}+#1#{} {C:inactive}Mult",
                }
            }
        },
        atlas = 'Jokers',
        pos = { x = 0, y = 24 },
        config = {
            extra = { mult = 0, multmod = 2 }
        },
        rarity = 2,
        cost = 6,
        blueprint_compat = true,

        loc_vars = function(self, info_queue, card)
            info_queue[#info_queue + 1] = G.P_CENTERS.m_fn_Cubic
            return {
                vars = {
                    card.ability.extra.mult,
                    card.ability.extra.multmod
                }
            }
        end,

        calculate = function(self, card, context)
            local tally = 0
            for _, v in pairs(G.playing_cards) do
                if v.config.center == G.P_CENTERS.m_fn_Cubic then
                    tally = tally + 1
                end
            end
            card.ability.extra.mult = tally * card.ability.extra.multmod

            if context.joker_main then
                return {
                    mult = card.ability.extra.mult,
					card = self
                }
            end
        end
    }
end

----------------------------------------------
------------KEVIN CODE END----------------------

----------------------------------------------
------------SHADOW SERIES CODE BEGIN----------------------

SMODS.Joker {
    key = 'ShadowSeries',
    loc_txt = {
        name = 'Shadow Series',
        text = {
            "If {C:chips}Hands{} and {C:red}Discards{} are {C:attention}equal{} at end of round",
            "Gain {X:mult,C:white}X#2#{} Mult per unused {C:chips}Hand{}",
            "{C:inactive}Currently {X:mult,C:white}X#1#{C:inactive} Mult",
			"Idea: BoiRowan",
        }
    },
    rarity = 1,
    cost = 5,
    atlas = 'Jokers',
    pos = { x = 1, y = 24 },
    blueprint_compat = true,
    config = {
        extra = {
            xmult = 1, -- current multiplier
            multmod = 0.05 -- per-hand multiplier gain
        }
    },

    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.extra.xmult,
                card.ability.extra.multmod,
            }
        }
    end,

    calculate = function(self, card, context)
        if context.end_of_round and context.main_eval and not context.blueprint then
            local remaining_hands = G.GAME.current_round.hands_left or 0
            local remaining_discards = G.GAME.current_round.discards_left or 0

            if remaining_hands == remaining_discards and remaining_hands > 0 then
                local gain = remaining_hands * card.ability.extra.multmod
                card.ability.extra.xmult = card.ability.extra.xmult + gain

                return {
                    message = localize('k_upgrade_ex'),
                    colour = G.C.Mult,
                    card = card
                }
            end
        end

        if context.joker_main then
			return {
			message = localize{type='variable',key='a_xmult',vars={card.ability.extra.xmult}},
			Xmult_mod = card.ability.extra.xmult,
			}
		end
	end,
}

----------------------------------------------
------------SHADOW SERIES CODE END----------------------

----------------------------------------------
------------UNVAULTING CODE BEGIN----------------------

SMODS.Joker{
    key = 'Unvaulting',
    loc_txt = {
        name = 'Unvaulting',
        text = {
            "{C:attention}#2#{} times per {C:attention}ante{} {C:money}selling{} a card with an {C:dark_edition}edition",
            "creates a {C:dark_edition}tag{} for that {C:dark_edition}edition{}",
			"Idea: BoiRowan"
        }
    },
    rarity = 2,
    cost = 5,
    atlas = 'Jokers',
    pos = { x = 2, y = 24 },
    blueprint_compat = true,

    config = {
        extra = {
            sold_count = 0,
            target_sold = 1,
            edition = nil
        }
    },

    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.extra.sold_count,
                card.ability.extra.target_sold,
                card.ability.extra.edition or "—"
            }
        }
    end,

    calculate = function(self, card, context)
        -- Selling logic
        if context.selling_card and context.card ~= card and context.card.edition and card.ability.extra.sold_count < card.ability.extra.target_sold then
            local sold_edition = context.card.edition.key
            card.ability.extra.edition = sold_edition
            card.ability.extra.sold_count = card.ability.extra.sold_count + 1

            if sold_edition == 'e_foil' then
                add_tag(Tag('tag_foil'))
            elseif sold_edition == 'e_holo' then
                add_tag(Tag('tag_holo'))
            elseif sold_edition == 'e_polychrome' then
                add_tag(Tag('tag_polychrome'))
            elseif sold_edition == 'e_negative' then
                add_tag(Tag('tag_negative'))
			elseif sold_edition == 'e_ortalab_anaglyphic' then
                add_tag(Tag('tag_ortalab_anaglyphic'))
			elseif sold_edition == 'e_ortalab_fluorescent' then
                add_tag(Tag('tag_ortalab_fluorescent'))
			elseif sold_edition == 'e_ortalab_greyscale' then
                add_tag(Tag('tag_ortalab_greyscale'))
			elseif sold_edition == 'e_ortalab_overexposed' then
                add_tag(Tag('tag_ortalab_overexposed'))
			elseif sold_edition == 'e_cry_glitched' then
                add_tag(Tag('tag_cry_glitched'))
			elseif sold_edition == 'e_cry_mosaic' then
                add_tag(Tag('tag_cry_mosaic'))
			elseif sold_edition == 'e_cry_oversat' then
                add_tag(Tag('tag_cry_oversat'))
			elseif sold_edition == 'e_cry_glass' then
                add_tag(Tag('tag_cry_glass'))
			elseif sold_edition == 'e_cry_gold' then
                add_tag(Tag('tag_cry_gold'))
			elseif sold_edition == 'e_cry_blur' then
                add_tag(Tag('tag_cry_blur'))
			elseif sold_edition == 'e_cry_astral' then
                add_tag(Tag('tag_cry_astral'))
			elseif sold_edition == 'e_cry_m' then
                add_tag(Tag('tag_cry_m'))	
            end
        end

        -- Reset at end of ante (boss blind)
        if context.end_of_round and context.main_eval and not context.blueprint then
            if G.GAME.blind and G.GAME.blind.boss then
                card.ability.extra.sold_count = 0

                return {
                    message = localize('k_reset'),
                    card = card
                }
            end
        end
    end
}

----------------------------------------------
------------UNVAULTING CODE END----------------------

----------------------------------------------
------------JAR BUSTER CODE BEGIN----------------------

SMODS.Joker{
    key = "Jar",
    loc_txt = {
        name = "Jar Buster",
        text = {
            "You dropped your Joker...?",
            "{C:attention}+1{} Joker Slot {C:attention}-1{} Consumable Slot",
        }
    },
    rarity = 2,
    atlas = "Jokers",
    pos = { x = 4, y = 24 },
    cost = 6,
    blueprint_compat = true,

    add_to_deck = function(self, card)
        -- Adjust slots
        if G.jokers then
            G.jokers.config.card_limit = G.jokers.config.card_limit + 1
        end
        if G.consumeables then
            G.consumeables.config.card_limit = G.consumeables.config.card_limit - 1
        end

        -- Mark the card to skip remove_from_deck slot reversal
        card._jarbuster_skip_remove = true

        -- Create a copy and move it to consumables
        local copy = copy_card(card)
        G.consumeables:emplace(copy)
        copy:start_materialize(nil, nil)

        -- Destroy the original card
        card:start_dissolve()
    end,
	
	calculate = function(self, card, context)
		if context.selling_self then
			if G.jokers then
				G.jokers.config.card_limit = G.jokers.config.card_limit - 1
			end
			if G.consumeables then
				G.consumeables.config.card_limit = G.consumeables.config.card_limit + 1
			end
		end
	end
}

----------------------------------------------
------------JAR BUSTER CODE END----------------------

----------------------------------------------
------------FASHION SHOW CODE BEGIN----------------------

SMODS.Joker({
    key = 'Fashion',
    loc_txt = {
        name = 'Fashion Show',
        text = {
            "Jokers with Editions each give {X:mult,C:white}X#1#{} Mult",
            "Idea: BoiRowan",
        }
    },
    rarity = 2,
    atlas = "Jokers",
    pos = {x = 0, y = 25},
    cost = 9,
    unlocked = true,
    discovered = false,
    eternal_compat = true,
    blueprint_compat = true,
    perishable_compat = false,
    config = {
        extra = {
            Xmult = 1.75,  -- Multiplier for editions
        },
    },

    loc_vars = function(self, info_queue, card)
        return {
            vars = {card.ability.extra.Xmult}  -- Correctly reference the multiplier
        }
    end,

    calculate = function(self, card, context)
        -- Ensure the card has an edition and check if it matches the specified conditions
        if context.other_joker and context.other_joker ~= card and context.other_joker.edition and context.other_joker.edition.type then
            return {
                x_mult = card.ability.extra.Xmult,  -- Apply multiplier to the current card
                card = card
            }
        end

        return nil  -- No multiplier if the card isn't linked with another joker having an edition
    end,
})

----------------------------------------------
------------FASHION SHOW CODE END----------------------

----------------------------------------------
------------PIECE CONTROL CODE BEGIN----------------------

SMODS.Joker{
    key = "Control",
    loc_txt = {
        name = "Piece Control",
        text = {
            "Played {C:money}Wood{} cards have a {C:green}#3# in #1#{} chance to become {C:inactive}Metal{}",
            "Played {C:mult}Brick{} cards have a {C:green}#3# in #2#{} chance to become {C:inactive}Metal{}",
            "Idea: BoiRowan"
        }
    },
    rarity = 3,
    atlas = "Jokers",
    pos = { x = 1, y = 25 },
    cost = 9,
    unlocked = true,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    config = { 
        extra = {
            w_odds = 3,  -- 1/3 chance for Wood to become Metal
            b_odds = 2,  -- 1/2 chance for Brick to become Metal
        }
    },
    weight = 0,

    loc_vars = function(self, info_queue, card)
        return { 
            vars = {  
                card.ability.extra.w_odds,
                card.ability.extra.b_odds,
                G.GAME.probabilities.normal
            }
        }
    end,

    -- Checks the played hand and potentially transforms Wood and Brick into Metal
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play then
            for _, played_card in ipairs(G.play.cards) do
                -- Check if the card is Wood and transform it if the odds are met
                if played_card.config.center == G.P_CENTERS.m_fn_Wood then
                    if pseudorandom('wood') < G.GAME.probabilities.normal/card.ability.extra.w_odds then
                        played_card:set_ability(G.P_CENTERS.m_fn_Metal)
                    end
                -- Check if the card is Brick and transform it if the odds are met
                elseif played_card.config.center == G.P_CENTERS.m_fn_Brick then
                    if pseudorandom('brick') < G.GAME.probabilities.normal/card.ability.extra.b_odds then
                        played_card:set_ability(G.P_CENTERS.m_fn_Metal)
                    end
                end
            end
        end
    end,
}

----------------------------------------------
------------PIECE CONTROL CODE END----------------------

----------------------------------------------
------------BATTLE PASS CODE BEGIN----------------------

SMODS.Joker{
  key = 'BP',
  loc_txt = {
    name = 'Battle Pass',
    text = {
      "Gain {X:mult,C:white}X#1#{} Mult for every {C:attention}different{} hand type played",
      "When {C:attention}all hand types{} have been played gain {X:mult,C:white}#2#X{} Mult and {C:attention}reset{}",
      "{C:inactive}Currently {X:mult,C:white}X#3#{C:inactive} Mult",
      "{C:inactive}Unplayed:",
      "{C:attention}#4#",
      " ",
      " ",
    }
  },
  rarity = 3,
  atlas = "Jokers", pos = {x = 2, y = 25},
  cost = 10,
  unlocked = true,
  discovered = false,
  eternal_compat = true,
  blueprint_compat = true,
  perishable_compat = false,
  config = {
    extra = {
      Xmult_add = 0.2,
      Xmult_reset = 3,
      Xmult = 1,
      played_hands = {} -- tracks unique hands
    }
  },
  loc_vars = function(self, info_queue, card)
    local played = card.ability.extra.played_hands or {}
    local core_types = {
      "High Card", "Pair", "Two Pair", "Three of a Kind", "Straight",
      "Flush", "Full House", "Four of a Kind", "Straight Flush"
    }
    local unplayed = {}
    for _, hand in ipairs(core_types) do
      if not played[hand] then
        table.insert(unplayed, hand)
      end
    end

    local grouped = {}
    for i = 1, #unplayed, 5 do
      table.insert(grouped, table.concat({
        unplayed[i], unplayed[i+1], unplayed[i+2],
        unplayed[i+3], unplayed[i+4], }, ", "))
    end

    return {
      vars = {
        card.ability.extra.Xmult_add,
        card.ability.extra.Xmult_reset,
        card.ability.extra.Xmult,
        table.concat(grouped, "\n"),
        9 - #unplayed
      }
    }
  end,
  calculate = function(self, card, context)
    if context.cardarea == G.jokers and context.before and not context.blueprint and context.scoring_name then
      local extra = card.ability.extra
      extra.played_hands = extra.played_hands or {}

      local scoring_name = context.scoring_name
      if scoring_name == "Royal Flush" then
        scoring_name = "Straight Flush"
      end

      local newly_played = false
      if not extra.played_hands[scoring_name] then
        extra.played_hands[scoring_name] = true
        extra.Xmult = extra.Xmult + extra.Xmult_add
        newly_played = true
      end

      -- Only core hands are required for completion
      local core_types = {
        ["High Card"] = true, ["Pair"] = true, ["Two Pair"] = true,
        ["Three of a Kind"] = true, ["Straight"] = true, ["Flush"] = true,
        ["Full House"] = true, ["Four of a Kind"] = true, ["Straight Flush"] = true
      }

      local completed = true
      for hand in pairs(core_types) do
        if not extra.played_hands[hand] then
          completed = false
          break
        end
      end

      if completed then
        extra.Xmult = extra.Xmult + extra.Xmult_reset
        extra.played_hands = {} -- Reset progress
        return {
          message = "Battle Pass Complete!",
          colour = G.C.Mult,
          card = card
        }
      elseif newly_played then
        return {
          message = localize('k_upgrade_ex'),
          colour = G.C.Mult,
          card = card
        }
      end
    end

    if context.joker_main then
      return {
        message = localize{type='variable', key='a_xmult', vars={card.ability.extra.Xmult}},
        Xmult_mod = card.ability.extra.Xmult
      }
    end
  end,
}

----------------------------------------------
------------BATTLE PASS CODE END----------------------

----------------------------------------------
------------INFINITY BLADE CODE BEGIN----------------------

SMODS.Sound({
	key = "iblade",
	path = "iblade.ogg",
})

SMODS.Joker{
    key = "IBlade",
    loc_txt = {
        name = "Infinity Blade",
        text = {
            "{C:chips}+#1#{} Hands, {C:mult}+#2#{} Discards, {C:attention}+#3#{} Handsize,", 
            "{C:attention}+#4#{} Card Slots in shop, {C:attention}+#5#{} Boosters in shop",
			"Idea: BoiRowan",
        }
    },
    rarity = 4,
    atlas = "Jokers",
    pos = { x = 3, y = 25 },
	soul_pos = { x = 4, y = 25 },
    cost = 25,
    blueprint_compat = false,
    config = {
        extra = {
            hands = 1,
            discards = 1,
            handsize = 4,
            shop_slots = 1,
            boosters = 1,
        },
    },

    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.extra.hands,
                card.ability.extra.discards,
                card.ability.extra.handsize,
                card.ability.extra.shop_slots,
                card.ability.extra.boosters,
            }
        }
    end,

    add_to_deck = function(self, card)
        local e = card.ability.extra
        G.GAME.round_resets.hands = G.GAME.round_resets.hands + e.hands
        ease_hands_played(e.hands)

        G.GAME.round_resets.discards = G.GAME.round_resets.discards + e.discards
        ease_discard(e.discards)

        G.hand.config.card_limit = G.hand.config.card_limit + e.handsize
        change_shop_size(e.shop_slots)
        SMODS.change_booster_limit(e.boosters)
		if config.sfx ~= false then
            play_sound("fn_iblade")
        end
    end,

    remove_from_deck = function(self, card)
        local e = card.ability.extra
        G.GAME.round_resets.hands = G.GAME.round_resets.hands - e.hands
        ease_hands_played(-e.hands)

        G.GAME.round_resets.discards = G.GAME.round_resets.discards - e.discards
        ease_discard(-e.discards)

        G.hand.config.card_limit = G.hand.config.card_limit - e.handsize
        change_shop_size(-e.shop_slots)
        SMODS.change_booster_limit(-e.boosters)
    end,
}

----------------------------------------------
------------INFINITY BLADE CODE END----------------------

----------------------------------------------
------------DEFAULT JOKER CODE BEGIN----------------------

if config.newcalccompat ~= false then
SMODS.Joker{
    key = 'Default',
    loc_txt = {
        ['en-us'] = {
            name = "Default Joker",
            text = {
                "If {C:attention}played hand{} contains no modified cards gain {C:mult}+#2#{} Mult ",
                "{C:inactive}Currently{} {C:mult}+#1# {C:inactive}mult",
				"Idea: BoiRowan",
            }
        }
    },
    atlas = 'Jokers',
    pos = { x = 2, y = 26 },
    config = {
        extra = { mult = 0, multmod = 4 }
    },
    rarity = 2,
    cost = 5,
    blueprint_compat = true,

    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.extra.mult,
                card.ability.extra.multmod
            }
        }
    end,

    calculate = function(self, card, context)
        -- Upgrade if hand has NO modified cards
        if context.cardarea == G.jokers and context.before and not context.blueprint then
            if G.playing_cards and #G.playing_cards > 0 then
                local no_modified = true
                for _, played_card in ipairs(context.full_hand) do
                    if played_card.edition or played_card.seal or played_card.config.center ~= G.P_CENTERS.c_base then
                        no_modified = false
                        break
                    end
                end

                if no_modified then
                    card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.multmod
                    return {
                        message = localize('k_upgrade_ex'),
                        colour = G.C.Mult,
                        card = card
                    }
                end
            end
        end

        -- Apply mult bonus
        if context.joker_main then
            return {
                mult = card.ability.extra.mult,
                card = self
            }
        end
    end
}
end

----------------------------------------------
------------DEFAULT JOKER CODE END----------------------

----------------------------------------------
------------RECON SCANNER CODE BEGIN----------------------

SMODS.Joker{
    key = 'Recon',
    loc_txt = {
        ['en-us'] = {
            name = "Recon Scanner",
            text = {
                "Shows the top {C:attention}5{} Cards in the deck",
                "{C:inactive}Currently{} {C:attention}#2#, #3#, #4#, #5#, #6#{}",
            }
        }
    },
    atlas = 'Jokers',
    pos = { x = 4, y = 28 },
    config = {
        extra = {
            card_1 = "???",
            card_2 = "???",
            card_3 = "???",
            card_4 = "???",
            card_5 = "???",
            amount = 5
        }
    },
    rarity = 2,
    cost = 5,
    blueprint_compat = false,

    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.extra.amount,
                card.ability.extra.card_1,
                card.ability.extra.card_2,
                card.ability.extra.card_3,
                card.ability.extra.card_4,
                card.ability.extra.card_5,
            }
        }
    end,

    calculate = function(self, card, context)
        -- Shows the top five cards with readable formatting
        card.ability.extra.card_1 = "" .. (G.deck and G.deck.cards[1] and G.deck.cards[#G.deck.cards].base.id or "?") ..
                                     (G.deck and G.deck.cards[1] and G.deck.cards[#G.deck.cards].base.suit:sub(1,1) or '??')
        card.ability.extra.card_2 = "" .. (G.deck and G.deck.cards[2] and G.deck.cards[#G.deck.cards -1].base.id or "???") ..
                                     (G.deck and G.deck.cards[1] and G.deck.cards[#G.deck.cards-1].base.suit:sub(1,1) or '??')
        card.ability.extra.card_3 = "" .. (G.deck and G.deck.cards[3] and G.deck.cards[#G.deck.cards -2].base.id or "???") ..
                                     (G.deck and G.deck.cards[1] and G.deck.cards[#G.deck.cards-2].base.suit:sub(1,1) or '??')
        card.ability.extra.card_4 = "" .. (G.deck and G.deck.cards[4] and G.deck.cards[#G.deck.cards -3].base.id or "???") ..
                                     (G.deck and G.deck.cards[1] and G.deck.cards[#G.deck.cards-3].base.suit:sub(1,1) or '??')
        card.ability.extra.card_5 = "" .. (G.deck and G.deck.cards[5] and G.deck.cards[#G.deck.cards -4].base.id or "???") ..
                                     (G.deck and G.deck.cards[1] and G.deck.cards[#G.deck.cards-4].base.suit:sub(1,1) or '??')

        -- Now format each card for readability (value and suit)
        card.ability.extra.card_1 = format_card_name(card.ability.extra.card_1)
        card.ability.extra.card_2 = format_card_name(card.ability.extra.card_2)
        card.ability.extra.card_3 = format_card_name(card.ability.extra.card_3)
        card.ability.extra.card_4 = format_card_name(card.ability.extra.card_4)
        card.ability.extra.card_5 = format_card_name(card.ability.extra.card_5)
    end
}

-- Helper function for formatting the card names
function format_card_name(card_str)
    local value_names = {
        [11] = "Jack",
        [12] = "Queen",
        [13] = "King",
        [14] = "Ace"
    }
    local suit_names = {
        H = "Hearts",
        D = "Diamonds",
        C = "Clubs",
        S = "Spades"
    }
    
    -- Extracting the card's value and suit from the string
    local card_value = tonumber(card_str:match("%d+"))  -- Match numeric value (like 11, 12, etc.)
    local card_suit = card_str:sub(-1)  -- Suit is the last character of the string
    
    -- Format the value name (Jack, Queen, King, Ace) or fallback to the number
    local value = value_names[card_value] or card_value
    
    -- Return the formatted name
    return value .. " " .. (suit_names[card_suit] or "Unknown Suit")
end

----------------------------------------------
------------RECON SCANNER CODE END----------------------

----------------------------------------------
------------WHIPLASH CODE BEGIN----------------------

SMODS.Joker{
  key = 'Whiplash',
  loc_txt = {
    name = 'Whiplash',
    text = {
      "{C:mult}+#1#{} Mult if {C:attention}played hand",
      "Is the same as the {C:attention}final hand{} of the {C:attention}previous round",
      "{C:inactive}Currently {C:attention}#3#",
	  "Idea: BoiRowan"
    }
  },
  rarity = 1,
  atlas = "Jokers",
  pos = {x = 0, y = 30},
  cost = 5,
  unlocked = true,
  discovered = false,
  eternal_compat = true,
  blueprint_compat = true,
  perishable_compat = false,
  config = {
    extra = {
      mult = 20,
      hand = "None", -- Stores the last played hand
      required_hand = "None", -- Stores the required hand for the current round
    }
  },
  
  loc_vars = function(self, info_queue, card)
    return {
      vars = {
        card.ability.extra.mult,
        card.ability.extra.hand,  -- Last played hand
        card.ability.extra.required_hand,  -- Required hand
      }
    }
  end,
  
  calculate = function(self, card, context)
    local extra = card.ability.extra
    local scoring_name = context.scoring_name
    
    if context.end_of_round and not context.repetition and not context.individual then
      extra.required_hand = extra.hand
    end
    
    if context.cardarea == G.jokers and context.before and not context.blueprint then
      -- Update the last played hand
      if scoring_name then
        extra.hand = scoring_name
      end
    end
	
	-- Only apply the multiplier if the scoring name matches the required hand
    if context.joker_main and context.scoring_name == extra.required_hand then
		return {
			mult = extra.mult,
			card = self
        }
	end
  end
}

----------------------------------------------
------------WHIPLASH CODE END----------------------

----------------------------------------------
------------QUADCRASHER CODE BEGIN----------------------

SMODS.Joker{
  key = 'Quadcrasher',
  loc_txt = {
    name = 'Quadcrasher',
    text = {
      "{C:chips}+#1#{} Chips if {C:attention}played hand",
      "Is the same as the {C:attention}final hand{} of the {C:attention}previous round",
      "{C:inactive}Currently {C:attention}#3#",
	  "Idea: BoiRowan"
    }
  },
  rarity = 1,
  atlas = "Jokers",
  pos = {x = 1, y = 30},
  cost = 5,
  unlocked = true,
  discovered = false,
  eternal_compat = true,
  blueprint_compat = true,
  perishable_compat = false,
  config = {
    extra = {
      mult = 200,
      hand = "None", -- Stores the last played hand
      required_hand = "None", -- Stores the required hand for the current round
    }
  },
  
  loc_vars = function(self, info_queue, card)
    return {
      vars = {
        card.ability.extra.mult,
        card.ability.extra.hand,  -- Last played hand
        card.ability.extra.required_hand,  -- Required hand
      }
    }
  end,
  
  calculate = function(self, card, context)
    local extra = card.ability.extra
    local scoring_name = context.scoring_name
    
    if context.end_of_round and not context.repetition and not context.individual then
      extra.required_hand = extra.hand
    end
    
    if context.cardarea == G.jokers and context.before and not context.blueprint then
      -- Update the last played hand
      if scoring_name then
        extra.hand = scoring_name
      end
    end
	
	-- Only apply the multiplier if the scoring name matches the required hand
    if context.joker_main and context.scoring_name == extra.required_hand then
		return {
			chips = extra.mult,
			card = self
        }
	end
  end
}

----------------------------------------------
------------QUADCRASHER CODE END----------------------

----------------------------------------------
------------DAILY QUEST CODE BEGIN----------------------

SMODS.Joker{
  key = 'Daily',
  loc_txt = {
    name = 'Daily Quest',
    text = {
      "Gain {X:mult,C:white}X#2#{} Mult after {C:attention}#5#{} consecutive {C:attention}same hands{}",
      "{C:inactive}Currently {X:mult,C:white}X#1#{} {C:inactive}Mult{}",
      "Idea: BoiRowan",
    }
  },
  rarity = 3,
  atlas = "Jokers",
  pos = {x = 2, y = 30},
  cost = 10,
  unlocked = true,
  discovered = false,
  eternal_compat = true,
  blueprint_compat = true,
  perishable_compat = false,
  config = {
    extra = {
      xmult = 1,
      xmult_add = 0.25,
      last_hand = nil, -- Last played hand name
      streak = 0,       -- How many same hands in a row
	  streak_cap = 3,
    }
  },
  
  loc_vars = function(self, info_queue, card)
    return {
      vars = {
		card.ability.extra.xmult,
		card.ability.extra.xmult_add,
		card.ability.extra.last_hand,
        card.ability.extra.streak,
		card.ability.extra.streak_cap,
      }
    }
  end,
  
  calculate = function(self, card, context)
    local extra = card.ability.extra
    local scoring_name = context.scoring_name

    -- do this when playing a hand
    if context.cardarea == G.jokers and context.before and not context.blueprint then
      if scoring_name then
        if extra.last_hand == scoring_name then
          extra.streak = extra.streak + 1
        else
          extra.streak = 1
          extra.last_hand = scoring_name
        end
        
        -- If the streak reaches 3, upgrade and show message
        if extra.streak >= extra.streak_cap then
          extra.xmult = extra.xmult + extra.xmult_add
          extra.streak = 0
          extra.last_hand = nil

          return {
            message = localize('k_upgrade_ex'),
            colour = G.C.Mult,
            card = card
          }
        end
      end
    end

    -- Normal mult calculation
    if context.joker_main then
      return {
        x_mult = extra.xmult,
        card = self
      }
    end
  end
}

----------------------------------------------
------------DAILY QUEST CODE END----------------------

----------------------------------------------
------------VOID ONI MASK CODE BEGIN----------------------

SMODS.Joker{
  key = 'Void',
  loc_txt = {
    name = 'Void Oni Mask',
    text = {
      "{C:attention}#1#{} random {C:attention}played cards{} return to hand",
    }
  },
  rarity = 2,
  atlas = "Jokers",
  pos = {x = 4, y = 30},
  cost = 8,
  unlocked = true,
  discovered = false,
  eternal_compat = true,
  blueprint_compat = true,
  perishable_compat = false,
  config = {
    extra = {
      cards = 1,  -- Default value, can be changed dynamically
    }
  },
  
  loc_vars = function(self, info_queue, card)
    return {
      vars = {
        card.ability.extra.cards,
      }
    }
  end,
  
  calculate = function(self, card, context)
  if context.cardarea == G.jokers and context.before and not context.blueprint then
    G.E_MANAGER:add_event(Event({
      func = function()
        local cards_to_return = card.ability.extra.cards
        local random_cards = {}

        -- Pick random cards from the full hand
        for i = 1, cards_to_return do
          local random_card = context.full_hand[math.random(#context.full_hand)]
          if random_card and not table.contains(random_cards, random_card) then
            table.insert(random_cards, random_card)
          end
        end

        for _, random_card in ipairs(random_cards) do
          G.E_MANAGER:add_event(Event({
            func = function()
              -- First, dissolve the original
              random_card:start_dissolve()

              -- Then, create the copy
              local _copy = copy_card(random_card)
              if _copy then
                _copy:add_to_deck()
                table.insert(G.playing_cards, _copy)
                G.hand:emplace(_copy)
                _copy:start_materialize(nil, nil)
              end
              return true
            end,
            delay = 0.1
          }), 'base')
        end

        return true
      end
    }))
  end
end,
}

----------------------------------------------
------------VOID ONI MASK CODE END----------------------

----------------------------------------------
------------DOUBLE G BOMB CODE BEGIN----------------------

SMODS.Joker{
    key = 'GG',
    loc_txt = {
        name = 'Double G Bomb',
        text = {
            "When a {C:fn_boogie}Boogie Seal{} triggers gain {C:money}$3{}",
            "Discarded cards have a {C:green}#1# in #2#{} chance to gain a {C:fn_boogie}Boogie Seal{}",
            "Idea: BoiRowan",
        }
    },
    config = {
        extra = { 
            odds = 5  -- 1 in 3 chance to gain a Boogie Seal on discard
        }
    },
    rarity = 3,
    pos = {x = 2, y = 31},
    atlas = 'Jokers',
    cost = 15,
    unlocked = true,
    discovered = false,
    blueprint_compat = true,

    loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = G.P_SEALS.fn_BoogieSeal
        return {
            vars = {
                G.GAME.probabilities.normal,
                card.ability.extra.odds,
            }
        }
    end,

    calculate = function(self, card, context)
        if context.discard and context.other_card then
            local discardedCard = context.other_card
            if pseudorandom('Snoopdogg') < G.GAME.probabilities.normal / card.ability.extra.odds then
                discardedCard:set_seal('fn_BoogieSeal', true)
                discardedCard:juice_up()
				if config.sfx ~= false then
					play_sound("fn_boogie")
				end
            end
        end
    end
}

----------------------------------------------
------------DOUBLE G BOMB CODE END----------------------

----------------------------------------------
------------CLICKBAIT CODE BEGIN----------------------

SMODS.Joker{
  key = 'Clickbait',
  loc_txt = {
    name = 'Clickbait Thumbnail',
    text = {
      "This Joker Gains {X:mult,C:white}X#1#{} Mult",
      "When a {C:mult}Gnome{} is created from a {C:mult}Brick{} card",
      "{C:inactive}Currently {X:mult,C:white}X#2#{C:inactive} Mult",
	  "Idea: BoiRowan",
    }
  },
  rarity = 1,
  atlas = "Jokers", pos = {x = 3, y = 31},
  soul_pos = { x = 4, y = 31 },
  cost = 5,
  unlocked = true,
  discovered = false,
  eternal_compat = true,
  blueprint_compat = true,
  perishable_compat = false,
  config = {extra = {Xmult_add = 1, Xmult = 1}},
  loc_vars = function(self, info_queue, card)
    return {vars = {card.ability.extra.Xmult_add, card.ability.extra.Xmult}}
  end,
  calculate = function(self, card, context)
    if context.individual and context.cardarea == G.play then
        if context.other_card.brick_trigger then
          card.ability.extra.Xmult = card.ability.extra.Xmult + card.ability.extra.Xmult_add
          return {
            message = localize('k_upgrade_ex'),
            colour = G.C.Mult,
            card = card
          }
        end
    end
    if context.joker_main then
      return {
        message = localize{type='variable', key='a_xmult', vars={card.ability.extra.Xmult}},
        Xmult_mod = card.ability.extra.Xmult,
      }
    end
  end
}

----------------------------------------------
------------CLICKBAIT CODE END----------------------

----------------------------------------------
------------4 NOOBS VS 1 PRO CODE BEGIN----------------------

SMODS.Joker{
    key = 'Noobs',
    loc_txt = {
        ['en-us'] = {
            name = "4 Noobs Vs 1 Pro",
            text = {
                "If {C:attention}played hand{} has exactly {C:attention}1{} {C:dark_edition}editioned{} card and {C:attention}4{} without",
                "Give that card's {C:dark_edition}edition{} to a random card in the deck",
                "Idea: BoiRowan",
            }
        }
    },
    atlas = 'Jokers',
    pos = { x = 2, y = 32 },
    config = {
        extra = {}
    },
    rarity = 2,
    cost = 8,
    blueprint_compat = true,

    calculate = function(self, card, context)
        if context.cardarea == G.jokers and context.after then
            if context.full_hand and #context.full_hand == 5 then
                local editioned_card = nil
                local non_editioned_count = 0

                for _, c in ipairs(context.full_hand) do
                    if c.edition then
                        if editioned_card then
                            return -- More than one editioned card
                        end
                        editioned_card = c
                    else
                        non_editioned_count = non_editioned_count + 1
                    end
                end

                if editioned_card and non_editioned_count == 4 then
                    local deck_cards = G.deck.cards
                    if #deck_cards == 0 then return end

                    -- Randomly pick one deck card like Decoy Grenade
                    math.randomseed(os.time())
                    local i = math.random(1, #deck_cards)
                    local random_card = deck_cards[i]

                    random_card:set_edition(editioned_card.edition)
                end
            end
        end
    end
}

----------------------------------------------
------------4 NOOBS VS 1 PRO CODE END----------------------

----------------------------------------------
------------DARK SERIES CODE BEGIN----------------------

SMODS.Joker{
    name = "Dark Series",
    key = "Dark",
    config = { extra = { dollars = 0, dollars_add = 1 } }, -- Fixed money granted
    pos = { x = 4, y = 32 },
    loc_txt = {
        name = "Dark Series",
        text = {
            "Earn {C:money}$#2#{} at the end of round for",
            "Every unique {C:purple}LTM Card{} used this run",
            "{C:inactive} Currently {C:money}$#1#{}",
			"Idea: BoiRowan",
        }
    },
    rarity = 3,
    cost = 14,
    unlocked = true,
    discovered = false,
    blueprint_compat = true,
    perishable_compat = true,
    atlas = "Jokers",
	
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.dollars, card.ability.extra.dollars_add } }
    end,
	
	update = function(self, card, dt)
        -- Count how many LTM cards have been used
        local ltms_used = 0
        for _, v in pairs(G.GAME.consumeable_usage) do
            if v.set == 'LTMConsumableType' then
                ltms_used = ltms_used + 1
            end
		end

            -- Update the dollars field based on the number of LTM cards used
            local money_bonus = card.ability.extra.dollars_add * ltms_used
            card.ability.extra.dollars = money_bonus  -- Add the bonus to dollars directly
    end,
	
	
    calculate = function(self, card, context)
        if context.end_of_round and not context.repetition and not context.individual then
            -- Apply the bonus to the player's total dollar buffer
            ease_dollars(card.ability.extra.dollars)
            G.GAME.dollar_buffer = (G.GAME.dollar_buffer or 0) + card.ability.extra.dollars

            -- Clear the dollar buffer after the event is processed
            G.E_MANAGER:add_event(Event({
                func = function()
                    G.GAME.dollar_buffer = 0
                    return true
                end
            }))
        end
    end
}

----------------------------------------------
------------DARK SERIES CODE END----------------------

----------------------------------------------
------------FROZEN SERIES CODE BEGIN----------------------

SMODS.Joker{
    name = "Frozen Series",
    key = "Frozen",
    config = { extra = { Xmult = 0, Xmult_add = 0.5 } }, -- Initialize Xmult to 0
    pos = { x = 0, y = 33 },
    loc_txt = {
        name = "Frozen Series",
        text = {
            "This Joker gains {X:mult,C:white}X#2#{} Mult for",
			"every unique {C:attention}consumable type{} used this run",
            "{C:inactive} Currently {X:mult,C:white}X#1#{}",
            "Idea: BoiRowan",
        }
    },
    rarity = 2,
    cost = 7,
    unlocked = true,
    discovered = false,
    blueprint_compat = true,
    perishable_compat = true,
    atlas = "Jokers",
    
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.Xmult, card.ability.extra.Xmult_add } }
    end,
    
    update = function(self, card, dt)
        -- Track all unique consumable sets used this run
        local unique_sets = {}
        for _, v in pairs(G.GAME.consumeable_usage) do
            if v.set then
                unique_sets[v.set] = true
            end
        end

        -- Count the unique consumable sets
        local unique_count = 0
        for _ in pairs(unique_sets) do
            unique_count = unique_count + 1
        end

        -- Update the Xmult value based on the number of unique consumable sets used
        card.ability.extra.Xmult = unique_count * card.ability.extra.Xmult_add + 1
    end,
    
    calculate = function(self, card, context)
        if context.joker_main then
            return {
                message = localize{type='variable', key='a_xmult', vars={card.ability.extra.Xmult}},
                Xmult_mod = card.ability.extra.Xmult,
            }
        end
    end
}

----------------------------------------------
------------FROZEN SERIES CODE END----------------------

----------------------------------------------
------------DC SERIES CODE BEGIN----------------------

SMODS.Joker{
    name = "DC Series",
    key = "DC",
    config = { extra = { Xmult = 1, Xmult_add = 0.5 } }, -- Initialize Xmult to 1
    pos = { x = 1, y = 33 },
    loc_txt = {
        name = "DC Series",
        text = {
            "This Joker gains {X:mult,C:white}X#2#{} Mult for",
            "every unique {C:attention}consumable{} used this run",
            "{C:inactive} Currently {X:mult,C:white}X#1#{}",
            "Idea: BoiRowan",
        }
    },
    rarity = 4,
    cost = 15,
    unlocked = true,
    discovered = false,
    blueprint_compat = true,
    perishable_compat = true,
    atlas = "Jokers",
    
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.Xmult, card.ability.extra.Xmult_add } }
    end,
    
    update = function(self, card, dt)
        -- Track all unique consumable keys used this run
        local unique_consumables = 0
        for _, v in pairs(G.GAME.consumeable_usage) do
            if v.set ~= 'Ninja Fortnite\'s low taper fade meme is still MASSIVE' then
                unique_consumables = unique_consumables + 1
            end
		end

        -- Update the Xmult value based on the number of unique consumables used
        card.ability.extra.Xmult = 1 + (unique_consumables * card.ability.extra.Xmult_add)
    end,
    
    calculate = function(self, card, context)
        if context.joker_main then
            return {
                message = localize{type='variable', key='a_xmult', vars={card.ability.extra.Xmult}},
                Xmult_mod = card.ability.extra.Xmult,
            }
        end
    end
}

----------------------------------------------
------------DC SERIES CODE END----------------------

----------------------------------------------
------------OG PASS CODE BEGIN----------------------

-- Define the list of vanilla jokers by their keys
local vanilla_jokers = {
    j_joker = true,
    j_greedy_joker = true,
    j_lusty_joker = true,
    j_wrathful_joker = true,
    j_gluttenous_joker = true,
    j_jolly = true,
    j_zany = true,
    j_mad = true,
    j_crazy = true,
    j_droll = true,
    j_sly = true,
    j_wily = true,
    j_clever = true,
    j_devious = true,
    j_crafty = true,
    j_half = true,
    j_stencil = true,
    j_four_fingers = true,
    j_mime = true,
    j_credit_card = true,
    j_ceremonial = true,
    j_banner = true,
    j_mystic_summit = true,
    j_marble = true,
    j_loyalty_card = true,
    j_8_ball = true,
    j_misprint = true,
    j_dusk = true,
    j_raised_fist = true,
    j_chaos = true,
    j_fibonacci = true,
    j_steel_joker = true,
    j_scary_face = true,
    j_abstract = true,
    j_delayed_grat = true,
    j_hack = true,
    j_pareidolia = true,
    j_gros_michel = true,
    j_even_steven = true,
    j_odd_todd = true,
    j_scholar = true,
    j_business = true,
    j_supernova = true,
    j_ride_the_bus = true,
    j_space = true,
    j_egg = true,
    j_burglar = true,
    j_blackboard = true,
    j_runner = true,
    j_ice_cream = true,
    j_dna = true,
    j_splash = true,
    j_blue_joker = true,
    j_sixth_sense = true,
    j_constellation = true,
    j_hiker = true,
    j_faceless = true,
    j_green_joker = true,
    j_superposition = true,
    j_todo_list = true,
    j_cavendish = true,
    j_card_sharp = true,
    j_red_card = true,
    j_madness = true,
    j_square = true,
    j_seance = true,
    j_riff_raff = true,
    j_vampire = true,
    j_shortcut = true,
    j_hologram = true,
    j_vagabond = true,
    j_baron = true,
    j_cloud_9 = true,
    j_rocket = true,
    j_obelisk = true,
    j_midas_mask = true,
    j_luchador = true,
    j_photograph = true,
    j_gift = true,
    j_turtle_bean = true,
    j_erosion = true,
    j_reserved_parking = true,
    j_mail = true,
    j_to_the_moon = true,
    j_hallucination = true,
    j_fortune_teller = true,
    j_juggler = true,
    j_drunkard = true,
    j_stone = true,
    j_golden = true,
    j_lucky_cat = true,
    j_baseball = true,
    j_bull = true,
    j_diet_cola = true,
    j_trading = true,
    j_flash = true,
    j_popcorn = true,
    j_trousers = true,
    j_ancient = true,
    j_ramen = true,
    j_walkie_talkie = true,
    j_selzer = true,
    j_castle = true,
    j_smiley = true,
    j_campfire = true,
    j_ticket = true,
    j_mr_bones = true,
    j_acrobat = true,
    j_sock_and_buskin = true,
    j_swashbuckler = true,
    j_troubadour = true,
    j_certificate = true,
    j_smeared = true,
    j_throwback = true,
    j_hanging_chad = true,
    j_rough_gem = true,
    j_bloodstone = true,
    j_arrowhead = true,
    j_onyx_agate = true,
    j_glass = true,
    j_ring_master = true,
    j_flower_pot = true,
    j_blueprint = true,
    j_wee = true,
    j_merry_andy = true,
    j_oops = true,
    j_idol = true,
    j_seeing_double = true,
    j_matador = true,
    j_hit_the_road = true,
    j_duo = true,
    j_trio = true,
    j_family = true,
    j_order = true,
    j_tribe = true,
    j_stuntman = true,
    j_invisible = true,
    j_brainstorm = true,
    j_satellite = true,
    j_shoot_the_moon = true,
    j_drivers_license = true,
    j_cartomancer = true,
    j_astronomer = true,
    j_burnt = true,
    j_bootstraps = true,
    j_caino = true,
    j_triboulet = true,
    j_yorick = true,
    j_chicot = true,
    j_perkeo = true
}

SMODS.Joker({
    key = 'OGPass',
    loc_txt = {
        name = 'OG Pass',
        text = {
            "{C:attention}Vanilla{} Jokers give {X:mult,C:white}X#1#{} Mult",
			"Idea: BoiRowan",
        }
    },
    rarity = 2,
    atlas = "Jokers",
    pos = {x = 2, y = 33},
    cost = 9,
    unlocked = true,
    discovered = false,
    eternal_compat = true,
    blueprint_compat = true,
    perishable_compat = false,
    config = {
        extra = {
            Xmult = 1.5,  -- Multiplier for vanilla jokers
        },
    },

    -- Define variables for use in localization
    loc_vars = function(self, info_queue, card)
        return {
            vars = {card.ability.extra.Xmult}  -- Correctly reference the multiplier
        }
    end,

    -- Check and apply multiplier for vanilla jokers in the hand
    calculate = function(self, card, context)
        -- Ensure the joker is a valid vanilla joker
        if context.other_joker and context.other_joker ~= card and vanilla_jokers[context.other_joker.config.center.key] then
            return {
                x_mult = card.ability.extra.Xmult,  -- Apply multiplier to the current card
                card = card
            }
        end

        return nil  -- No multiplier if the card isn't a vanilla joker
    end,
})

----------------------------------------------
------------OG PASS CODE END----------------------

----------------------------------------------
------------RELOAD CODE BEGIN----------------------

SMODS.Joker{
    key = 'Reload',
    loc_txt = {
        ['en-us'] = {
            name = "Reload",
            text = {
                "If all {C:chips}Hands{} are used",
                "Gain {C:attention}+#1#{} {C:chips}Hands{} and {C:attention}+#2#{} {C:green}Rerolls{}",
                "Idea: {C:inactive}kxttyfrickfish{}",
            }
        }
    },
    atlas = 'Jokers',
    pos = { x = 4, y = 33 },
    config = {
        extra = { 
            hands = 1,
            rerolls = 1,
            used = 0,
        }
    },
    rarity = 2,
    cost = 5,
    blueprint_compat = false,

    loc_vars = function(self, info_queue, card)
        if card and card.ability and card.ability.extra then
            return {vars = { card.ability.extra.hands, card.ability.extra.rerolls, card.ability.extra.used }} 
        end
        return {vars = {}}
    end,

    calculate = function(self, card, context)
        local round = G.GAME.current_round

        if context.setting_blind then
            -- Reset 'used' back to 0
            card.ability.extra.used = 0 

        elseif context.joker_main then
            -- During normal joker calculation, check if player ran out of hands
            if round.hands_left <= 0 and card.ability.extra.used == 0 then
                card.ability.extra.used = 1 -- Mark as used to prevent multiple triggers
                ease_hands_played(card.ability.extra.hands)
                G.GAME.current_round.free_rerolls = G.GAME.current_round.free_rerolls + card.ability.extra.rerolls
                calculate_reroll_cost(true)
            end
        end
    end
}

----------------------------------------------
------------RELOAD CODE END----------------------

----------------------------------------------
------------CIRCLE CODE BEGIN----------------------

SMODS.Joker{
    key = 'Circle',
    loc_txt = {
        name = 'Storm Circle',
        text = {
            "{X:mult,C:white}X#1#{} Mult if this is the {C:attention}Middlemost{} Joker",
			"Idea: {C:inactive}kxttyfrickfish",
        }
    },
    rarity = 2,
    atlas = "Jokers",
    pos = {x = 0, y = 34},
    cost = 8,
    unlocked = true,
    discovered = false,
    eternal_compat = true,
    blueprint_compat = true,
    perishable_compat = false,
    config = {extra = {Xmult = 2.5}},

    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.Xmult}}
    end,

    calculate = function(self, card, context)
        if context.joker_main then
            local is_middle = false

            -- Check if this is the middlemost Joker
            if G.jokers and #G.jokers.cards > 0 then
                local middle_index = math.ceil(#G.jokers.cards / 2)
                if G.jokers.cards[middle_index] == card then
                    is_middle = true
                end
            end

            -- Apply the multiplier only if it is the middlemost joker
            if is_middle then
                return {
                    message = localize{type='variable',key='a_xmult',vars={card.ability.extra.Xmult}},
                    Xmult_mod = card.ability.extra.Xmult,
                }
            end
        end
    end
}

----------------------------------------------
------------CIRCLE CODE END----------------------

----------------------------------------------
------------SPLIT STORM CIRCLE CODE BEGIN----------------------

SMODS.Joker{
    key = 'Circle2',
    loc_txt = {
        name = 'Storm Circle',
        text = {
            "{X:mult,C:white}X#1#{} Mult if you have",
			"{C:attention}#2#{} or more {C:chips}Hands{} left",
			"Idea: {C:inactive}kxttyfrickfish",
        }
    },
    rarity = 2,
    atlas = "Jokers",
    pos = {x = 2, y = 34},
    cost = 6,
    unlocked = true,
    discovered = false,
    eternal_compat = true,
    blueprint_compat = true,
    perishable_compat = false,
    config = {extra = {Xmult = 2.5, hands = 2}},

    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.Xmult, card.ability.extra.hands}}
    end,

    calculate = function(self, card, context)
        if context.joker_main then
            local hands_left = G.GAME.current_round.hands_left

            -- Apply the multiplier only if it is the middlemost joker
            if hands_left >= card.ability.extra.hands then
                return {
                    message = localize{type='variable',key='a_xmult',vars={card.ability.extra.Xmult}},
                    Xmult_mod = card.ability.extra.Xmult,
                }
            end
        end
    end
}

----------------------------------------------
------------SPLIT STORM CIRCLE CODE END----------------------

----------------------------------------------
------------JAM TRACK CODE BEGIN----------------------

SMODS.Joker{
    key = 'Jam',
    loc_txt = {
        name = 'Jam Track',
        text = {
            "Gain {C:money}$#1#{} if played hand scores at least",
            "{C:attention}50%{} of the {C:attention}blind requirement",
            "Idea: BoiRowan",
        }
    },
    rarity = 3,
    atlas = "Jokers",
    pos = {x = 1, y = 35},
    cost = 8,
    unlocked = true,
    discovered = false,
    eternal_compat = true,
    blueprint_compat = true,
    perishable_compat = false,
    config = {extra = {money = 5}},
    
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.money}}
    end,

    calculate = function(self, card, context)
        if context.final_scoring_step and not context.repetition and not context.blueprint then
            local blind_chips = G.GAME.blind and G.GAME.blind.chips or 0

            G.E_MANAGER:add_event(Event({
                trigger = "immediate",
                func = function()
                    if G.STATE ~= G.STATES.SELECTING_HAND then return false end
                    if G.GAME.chips >= blind_chips / 2 then
                        ease_dollars(card.ability.extra.money) 
						if config.sfx ~= false then
							play_sound("fn_song1")
						end
                    end
                    return true
                end,
            }), "other")
        end
		
		if context.end_of_round and not context.repetition and not context.individual then
			ease_dollars(card.ability.extra.money)
			if config.sfx ~= false then
				play_sound("fn_song1")
			end
		end
    end,
}

----------------------------------------------
------------JAM TRACK CODE END----------------------

----------------------------------------------
------------[TITLE CARD] CODE BEGIN----------------------

-- Define the list of Fortlatro jokers by their keys
local fortlatro_jokers = {
    j_fn_Eric = true,
    j_fn_Crac = true,
    j_fn_Emily = true,
    j_fn_Toilet= true,
    j_fn_GroundGame = true,
    j_fn_TheDub = true,
    j_fn_FlushFactory = true,
    j_fn_VictoryCrown = true,
    j_fn_Peely = true,
    j_fn_Zorlodo = true,
    j_fn_SolidGold = true,
    j_fn_BattleBus = true,
    j_fn_SaveTheWorld = true,
    j_fn_TheLoop = true,
    j_fn_ChugJug = true,
    j_fn_BigPot = true,
    j_fn_Mini = true,
    j_fn_Vbucks = true,
    j_fn_Augment = true,
    j_fn_BluGlo = true,
    j_fn_RebootCard = true,
    j_fn_Oscar = true,
    j_fn_Montague = true,
    j_fn_MagmaReef = true,
    j_fn_DurrBurger = true,
    j_fn_AcesWild = true,
    j_fn_Miku = true,
    j_fn_Bench = true,
    j_fn_Nothing = true,
    j_fn_Flip = true,
    j_fn_MVM = true,
    j_fn_Thanos = true,
    j_fn_Racing = true,
    j_fn_50v50 = true,
    j_fn_DoublePump = true,
    j_fn_Festival = true,
    j_fn_KineticBlade = true,
    j_fn_Kado = true,
    j_fn_TyphoonBlade = true,
    j_fn_Kane = true,
    j_fn_DB = true,
    j_fn_Vulture = true,
    j_fn_CassidyQuinn = true,
    j_fn_Termite = true,
    j_fn_Shadow = true,
    j_fn_Ghost = true,
    j_fn_BattleLab = true,
    j_fn_Tent = true,
    j_fn_Cart = true,
    j_fn_Vault = true,
    j_fn_Fishing = true,
    j_fn_Slurp = true,
    j_fn_Lava = true,
    j_fn_ATK = true,
    j_fn_Aimbot = true,
    j_fn_BetterAimbot = true,
    j_fn_Skibidi = true,
    j_fn_Bots = true,
    j_fn_NickEh30 = true,
    j_fn_RiftGun = true,
    j_fn_Rabbit = true,
    j_fn_Fox = true,
    j_fn_Llama = true,
    j_fn_Hide = true,
    j_fn_Cubert = true,
    j_fn_ShadowSeries = true,
    j_fn_Unvaulting = true,
    j_fn_Jar = true,
    j_fn_Fashion = true,
    j_fn_Control = true,
    j_fn_BP = true,
    j_fn_IBlade = true,
    j_fn_Default = true,
    j_fn_Recon = true,
    j_fn_Whiplash = true,
    j_fn_Quadcrasher = true,
    j_fn_Daily = true,
    j_fn_Void = true,
    j_fn_GG = true,
    j_fn_Clickbait = true,
    j_fn_Noobs = true,
    j_fn_Dark = true,
    j_fn_Frozen = true,
    j_fn_DC = true,
    j_fn_OGPass = true,
    j_fn_Reload = true,
    j_fn_Circle = true,
    j_fn_Circle2 = true,
    j_fn_Jam = true,
    j_fn_Fortnite = true,
	j_fn_Smoothie = true,
	j_fn_Sprite = true,
	j_fn_Prebuild = true,
	j_fn_Shogun = true,
	j_fn_Killswitch = true,
	j_fn_Hero = true,
	j_fn_NBA = true,
	j_fn_Tempest = true,
	j_fn_Griddy = true,
	j_fn_Circle3 = true,
	j_fn_Fortbyte = true,
	j_fn_FlowberryFizz = true,
	j_fn_EGL = true,
	j_fn_Marvel = true,
	j_fn_Cluster = true,
	j_fn_Helios = true,
	j_fn_Icon = true,
	j_fn_Gaming = true,
	j_fn_WRTIS = true,
	j_fn_StarWars = true,
	j_fn_Chewbacca = true,
	j_fn_Crew
	
}

SMODS.Joker({
    key = 'Fortnite',
    loc_txt = {
        name = '[Title Card]',
        text = {
            "{C:purple}Fortlatro{} Jokers give {X:mult,C:white}X#1#{} Mult",
        }
    },
    rarity = 2,
    atlas = "Jokers",
    pos = {x = 2, y = 35},
    cost = 9,
    unlocked = true,
    discovered = false,
    eternal_compat = true,
    blueprint_compat = true,
    perishable_compat = false,
    config = {
        extra = {
            Xmult = 1.5,  -- Multiplier for fortlatro jokers
        },
    },

    -- Define variables for use in localization
    loc_vars = function(self, info_queue, card)
        return {
            vars = {card.ability.extra.Xmult}  -- Correctly reference the multiplier
        }
    end,

    -- Check and apply multiplier for fortlatro jokers
    calculate = function(self, card, context)
        -- Ensure the joker is a valid fortlatro joker
        if context.other_joker and context.other_joker ~= card and fortlatro_jokers[context.other_joker.config.center.key] then
            return {
                x_mult = card.ability.extra.Xmult,  -- Apply multiplier to the current card
                card = card
            }
        end

        return nil  -- No multiplier if the card isn't a fortlatro joker
    end,
})

----------------------------------------------
------------[TITLE CARD] CODE END----------------------

----------------------------------------------
------------SMOOTHIE CODE BEGIN----------------------

SMODS.Sound({
	key = "drink",
	path = "drink.ogg",
})

SMODS.Joker{
    key = 'Smoothie',
    loc_txt = {
        name = 'Banana Smoothie',
        text = {
            "{X:mult,C:white}X#1#{} Mult if this is the {C:attention}Rightmost{} Joker",
			"{C:mult}Self-destruct{} after use",
			"Idea: {C:inactive}kxttyfrickfish",
        }
    },
    rarity = 2,
    atlas = "Jokers",
    pos = {x = 2, y = 36},
    cost = 8,
    unlocked = true,
    discovered = false,
    eternal_compat = true,
    blueprint_compat = true,
    perishable_compat = false,
    config = {extra = {Xmult = 10}},

    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.Xmult}}
    end,

    calculate = function(self, card, context)
    if context.joker_main then
        -- Check if this is the rightmost Joker
        if G.jokers and #G.jokers.cards > 0 then
            if G.jokers.cards[#G.jokers.cards] == card then
                -- Schedule delayed destruction
                G.E_MANAGER:add_event(Event({
                    func = function()
						if config.sfx ~= false then
							play_sound("fn_drink")
						end
                        card:start_dissolve()
                        return true
                    end,
                    delay = 0.5
                }), 'base')

                return {
                    message = localize{type='variable', key='a_xmult', vars={card.ability.extra.Xmult}},
                    Xmult_mod = card.ability.extra.Xmult,
                }
            end
        end
    end
end
}

----------------------------------------------
------------SMOOTHIE CODE END----------------------

----------------------------------------------
------------SPRITE CODE BEGIN----------------------

SMODS.Joker({
    key = 'Sprite',
    loc_txt = {
        name = 'Sprite Duping',
        text = {
            "All {C:attention}Skip{} rewards are doubled",
        }
    },
    rarity = 3,
    atlas = "Jokers",
    pos = {x = 2, y = 38},
    cost = 9,
    unlocked = true,
    discovered = false,
    eternal_compat = true,
    blueprint_compat = true,
    perishable_compat = false,
	
	add_to_deck = function(self, card)
        add_tag(Tag('tag_double'))
    end,

    calculate = function(self, card, context)
		-- check if skipping blind
		if context.skip_blind then
			G.GAME.skips = G.GAME.skips + 1
			add_tag(Tag('tag_double'))
		end
    end,
})

----------------------------------------------
------------SPRITE CODE END----------------------

----------------------------------------------
------------PREBUILD CODE BEGIN----------------------

SMODS.Joker({
    key = 'Prebuild',
    loc_txt = {
        name = 'Prebuild',
        text = {
            "When adding a new {C:attention}Joker{}",
			"Gain a random {C:attention}Consumable{}",
			"{C:inactive}(Must have room)",
			"Idea: {C:inactive}kxttyfrickfish",
        }
    },
    rarity = 2,
    atlas = "Jokers",
    pos = {x = 3, y = 38},
    cost = 7,
    unlocked = true,
    discovered = false,
    eternal_compat = true,
    blueprint_compat = true,
    perishable_compat = false,

	calculate = function(self, card, context)
        if context.card_added then
            if context.card ~= card and context.card.ability.set == 'Joker' then
				if #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
					local new_card = create_card('Consumeables', G.consumeables)
					new_card:add_to_deck()
					G.consumeables:emplace(new_card)
				end
            end
        end
    end,
})

----------------------------------------------
------------PREBUILD CODE END----------------------

----------------------------------------------
------------SHOGUN X CODE BEGIN----------------------

SMODS.Joker {
    key = 'Shogun',
    loc_txt = {
        name = 'Shogun X',
        text = {
            "Gain {C:chips}+#1#{} Chips per {C:attention}Consumable{} used this Ante",
            "{C:inactive}Currently{} {C:chips}+#2# {C:inactive}Chips",
			"Idea: {C:inactive}kxttyfrickfish",
        }
    },
    config = {extra = {stored_chips = 0, chips_per_card = 50}},
    rarity = 2,
    pos = {x = 4, y = 38},
    atlas = 'Jokers',
    cost = 5,
    unlocked = true,
    discovered = false,
    blueprint_compat = true,
	loc_vars = function(self, info_queue, card)
		return {vars = {card.ability.extra.chips_per_card, card.ability.extra.stored_chips}}
    end,
    calculate = function(self, card, context)
	
		if context.end_of_round and context.main_eval and not context.blueprint then
            -- Check if it's a boss blind
            if G.GAME.blind and G.GAME.blind.boss then
				-- Reset on boss blind
                card.ability.extra.stored_chips = 0
                return {
                    message = localize('k_reset'),
                    card = card
                }
			end
		end
	
		
        -- check is using a consumable
        if context.using_consumeable then
            card.ability.extra.stored_chips = card.ability.extra.stored_chips + card.ability.extra.chips_per_card
            return {
				message = localize('k_upgrade_ex'),
				colour = G.C.Mult,
				card = card
            }
        end

        -- Joker main scoring logic (after destruction and chip calculation)
        if context.joker_main then
            return {
                message = localize {type = 'variable', key = 'a_chips', vars = {card.ability.extra.stored_chips}},
                chip_mod = card.ability.extra.stored_chips,
                colour = G.C.CHIPS
            }
        end
    end
}	

----------------------------------------------
------------SHOGUN X CODE END----------------------

----------------------------------------------
------------KILLSWITCH REVOLVERS CODE BEGIN----------------------

SMODS.Joker{
    key = "Killswitch",
    loc_txt = {
        name = "Killswitch Revolvers",
        text = {
            "Lower Gamespeed to gain Mult",
            "{C:inactive}Currently {X:mult,C:white}X#1#{C:inactive} Mult",
        }
    },
    rarity = 2,
    atlas = "Jokers",
    pos = { x = 0, y = 39 },
    cost = 7,
    blueprint_compat = false,
    config = { 
        extra = {
            Xmult = 1,
        }
    },

    loc_vars = function(self, info_queue, center)
        return {
            vars = {
                center.ability.extra.Xmult,
            }
        }
    end,
	
	update = function(self, card)
		
		if G.SETTINGS.GAMESPEED > 4 then
			card.ability.extra.Xmult = 0
		end
	
		if G.SETTINGS.GAMESPEED == 4 then
			card.ability.extra.Xmult = 1
		end
		
		if G.SETTINGS.GAMESPEED == 3 then
			card.ability.extra.Xmult = 1.5
		end
		
		if G.SETTINGS.GAMESPEED == 2 then
			card.ability.extra.Xmult = 2
		end
		
		if G.SETTINGS.GAMESPEED == 1 then
			card.ability.extra.Xmult = 3
		end
		
		if G.SETTINGS.GAMESPEED == 0.5 then
			card.ability.extra.Xmult = 4
		end
		
		if G.SETTINGS.GAMESPEED < 0.5 then
			card.ability.extra.Xmult = 5
		end
	end,
	
    calculate = function(self, card, context)
        if context.joker_main then
			return {
				message = localize{type='variable', key='a_xmult', vars={card.ability.extra.Xmult}},
                Xmult_mod = card.ability.extra.Xmult,
            } 
        end
    end
}

----------------------------------------------
------------KILLSWITCH REVOLVERS CODE END----------------------

----------------------------------------------
------------HERO RANK CODE BEGIN----------------------

SMODS.Joker{
    key = "Hero",
    loc_txt = {
        name = "Hero Rank",
        text = {
            "Gain {X:mult,C:white}X#2#{} Mult",
			"After {C:attention}#3# Antes",
			"{C:inactive}Currently{} {X:mult,C:white}X#1#{} {C:inactive}Mult ",
        }
    },
    rarity = 2,
    atlas = "Jokers",
    pos = { x = 0, y = 40 },
    cost = 7,
    blueprint_compat = false,
    config = { 
        extra = {
            Xmult = 1,
			Xmult_add = 1,
			Antes = 1,
			Antes_Completed = 0,
			Times = 0,
        }
    },

    loc_vars = function(self, info_queue, center)
        return {
            vars = {
                center.ability.extra.Xmult,
				center.ability.extra.Xmult_add,
				center.ability.extra.Antes,
				center.ability.extra.Antes_Completed,
				center.ability.extra.Times,
            }
        }
    end,
	
	update = function(self, card)
	
		local obj = G.P_CENTERS.j_fn_Hero	
		-- C rank
		if card.ability.extra.Times == 0 then
			obj.pos.x = 0
		end
		
		-- B Rank
		if card.ability.extra.Times == 1 then
			obj.pos.x = 1
		end
		
		-- A Rank
		if card.ability.extra.Times == 2 then
			obj.pos.x = 2
		end
		
		-- S Rank
		if card.ability.extra.Times == 3 then
			obj.pos.x = 3
		end
		
		-- S+ Rank
		if card.ability.extra.Times >= 4 then
			obj.pos.x = 4
		end
	end,
	
    calculate = function(self, card, context)
		
		if context.end_of_round and context.main_eval and not context.blueprint then
            -- Check if it's a boss blind
            if G.GAME.blind and G.GAME.blind.boss then
				card.ability.extra.Antes_Completed = card.ability.extra.Antes_Completed + 1
			end
		end
		
		if card.ability.extra.Antes_Completed >= card.ability.extra.Antes then
			card.ability.extra.Antes_Completed = 0
			card.ability.extra.Antes = card.ability.extra.Antes + 1
			card.ability.extra.Times = card.ability.extra.Times + 1
			card.ability.extra.Xmult = card.ability.extra.Xmult + card.ability.extra.Xmult_add
			return {
				message = localize('k_upgrade_ex'),
                colour = G.C.Mult,
                card = card
            } 
		end
		
        if context.joker_main then
			return {
				message = localize{type='variable', key='a_xmult', vars={card.ability.extra.Xmult}},
                Xmult_mod = card.ability.extra.Xmult,
            } 
        end
    end
}

----------------------------------------------
------------HERO RANK CODE END----------------------

----------------------------------------------
------------NBA GLITCH CODE BEGIN----------------------

SMODS.Joker{
    key = "NBA",
    loc_txt = {
        name = "NBA Glitch",
        text = {
            "Every {C:chips}play{} or {C:mult}discard{} draw {C:attention}#1#{} cards",
			"Idea: {C:inactive}kxttyfrickfish{}",
        }
    },
    rarity = 3,
    atlas = "Jokers",
    pos = { x = 1, y = 39 },
    cost = 12,
    blueprint_compat = false,
    config = { 
        extra = {
            cards = 8,
        }
    },

    loc_vars = function(self, info_queue, center)
        return {
            vars = {
                center.ability.extra.cards,
            }
        }
    end,
	
    calculate = function(self, card, context)
        if context.final_scoring_step or context.pre_discard then
			G.FUNCS.draw_from_deck_to_hand(card.ability.extra.cards)
        end
    end
}

----------------------------------------------
------------NBA GLITCH CODE END----------------------

----------------------------------------------
------------TEMPEST GATEWAY CODE BEGIN----------------------

SMODS.Joker{
    key = 'Tempest',
    loc_txt = {
        name = 'Tempest Gateway',
        text = {
            "Each discarded {C:mult}Lego{} card is instead {C:mult}destroyed{}",
			"Earn {C:money}$#1#{} for each lego card destroyed",
			"Idea: {C:inactive}kxttyfrickfish",
        }
    },
    config = {
        extra = { 
            dollars = 3,
        }
    },
    rarity = 1,
    pos = {x = 3, y = 39},
    atlas = 'Jokers',
    cost = 5,
    unlocked = true,
    discovered = false,
    blueprint_compat = true,

    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.extra.dollars
            }
        }
    end,

    calculate = function(self, card, context)
        if context.discard and context.other_card then  -- Trigger only on discarded cards
            local discardedCard = context.other_card
            if discardedCard.config.center == G.P_CENTERS.m_fn_Lego then
				G.E_MANAGER:add_event(Event({
					trigger = 'after',
					delay = 0.2, -- tweak this delay as needed (seconds)
					func = function()
						if discardedCard then
							ease_dollars(card.ability.extra.dollars)
							discardedCard:start_dissolve()
						end
						return true
					end
				}))
            end
        end
    end
}

----------------------------------------------
------------TEMPEST GATEWAY CODE END----------------------

----------------------------------------------
------------GRIDDY CODE BEGIN----------------------

SMODS.Atlas{
    key = 'Griddy', 
    path = 'Griddy.png', 
    px = 71, 
    py = 95 
	}

SMODS.Joker {
    key = 'Griddy',
    loc_txt = {
        name = 'Griddy',
        text = {
            "{C:attention}Double{} the value of the Joker to the {C:attention}right{}",
            "Idea: Benjan"
        }
    },
    rarity = 2,
    cost = 5,
    atlas = 'Griddy',
    pos = { x = 0, y = 1 },
	soul_pos = { x = 0, y = 0 },
    blueprint_compat = true,

    config = {
        extra = {
            _tracked_joker = nil,
            _tracked_value = nil,
            _active = nil,
			animated = true,
            frame = 0,
            timer = 0,
            last_time = 0
        }
    },

    update = function(self, card)
        self:apply_luck(card)
		local extra = card.ability.extra
        if not extra.animated then return end

        local fps = 9    -- higher number is faster again
        local max_frame = 12 -- how many animation frames there are

        -- Delta time calculation
        local current_time = G.TIMERS.REAL
        local delta = current_time - (extra.last_time or 0)
        extra.last_time = current_time

        -- Add delta to timer
        extra.timer = (extra.timer or 0) + delta

        if extra.timer >= (1 / fps) then
            extra.timer = 0
            extra.frame = ((extra.frame or 0) + 1) % (max_frame + 1)

            if card.children and card.children.floating_sprite then
                card.children.floating_sprite:set_sprite_pos({ x = extra.frame, y = 0 })
            end
        end
    end,

    calculate = function(self, card, context)
        self:apply_luck(card)
    end,

    apply_luck = function(self, card)
        local tracked = card.ability.extra
        local right_joker = nil

        -- Find the Joker to the right
        if G.jokers then
            for i = 1, #G.jokers.cards do
                if G.jokers.cards[i] == card then
                    right_joker = G.jokers.cards[i + 1]
                    break
                end
            end
        end

        -- Revert changes if Joker to the right has changed
        if tracked._tracked_joker and tracked._tracked_joker ~= right_joker and tracked._active then
            local prev_joker = tracked._tracked_joker
            local prev_values = tracked._tracked_value

            if prev_joker and prev_values and prev_joker.ability and type(prev_joker.ability.extra) == "table" then
                for key, value in pairs(prev_values) do
                    if type(value) == "number" then
                        prev_joker.ability.extra[key] = value
                    end
                end
            end

            tracked._tracked_joker = nil
            tracked._tracked_value = nil
            tracked._active = nil
        end

        -- Apply effect to the new right Joker if not already active
        if right_joker and right_joker.ability and type(right_joker.ability.extra) == "table" and tracked._tracked_joker ~= right_joker then
            local extra = right_joker.ability.extra
            local backup = {}

            for key, value in pairs(extra) do
                if type(value) == "number" then
                    backup[key] = value
                    extra[key] = value * 2
                end
            end

            tracked._tracked_joker = right_joker
            tracked._tracked_value = backup
            tracked._active = true
        end
    end
}

----------------------------------------------
------------GRIDDY CODE END----------------------

----------------------------------------------
------------CS2 CODE BEGIN----------------------

SMODS.Joker{
        key = 'CS2',
        loc_txt = {
            ['en-us'] = {
                name = "CS2",
                text = {
                    "{C:mult}#1#{} Mult",
					"Idea: SomeoneWhoExists",
                }
            }
        },
        atlas = 'Jokers',
        pos = { x = 1, y = 43 },
        config = {
            extra = { mult = -1 }
        },
        rarity = 1,
        cost = -1,
        blueprint_compat = true,

        loc_vars = function(self, info_queue, card)
            return {
                vars = {
                    card.ability.extra.mult
                }
            }
        end,

        calculate = function(self, card, context)
            if context.joker_main then
                return {
                    mult = card.ability.extra.mult,
                    card = self
                }
            end
        end
    }
----------------------------------------------
------------CS2 CODE END----------------------

----------------------------------------------
------------FORECAST STORM CODE BEGIN----------------------

SMODS.Joker{
        key = 'Circle3',
        loc_txt = {
            ['en-us'] = {
                name = "Forecast Storm",
                text = {
                    "When playing a hand {C:green}50%{} chance to {C:attention}halve{} Blind",
					"{C:green}49%{} chance to {C:attention}double{} Blind",
					"{C:green}1%{} chance to set Blind to {C:attention}1{}",
					"{C:inactive}This isnt the storm forecast?",
					"Idea: SomeoneWhoExists",
                }
            }
        },
        atlas = 'Jokers',
        pos = { x = 2, y = 43 },
        config = {
            extra = { roll = 0 }
        },
        rarity = 2,
        cost = 10,
        blueprint_compat = true,

        loc_vars = function(self, info_queue, card)
            return {
                vars = {
                    card.ability.extra.roll
                }
            }
        end,

        calculate = function(self, card, context)
            if context.joker_main then
				card.ability.extra.roll = math.random(1,100)
				
				if card.ability.extra.roll < 51 then
					G.GAME.blind.chips = G.GAME.blind.chips * 0.5
				end
				
				if card.ability.extra.roll < 100 and card.ability.extra.roll > 50 then
					G.GAME.blind.chips = G.GAME.blind.chips * 2
				end
				
				if card.ability.extra.roll == 100 then
					G.GAME.blind.chips = 1
				end
				
            end
        end
    }

----------------------------------------------
------------FORECAST STORM CODE END----------------------

----------------------------------------------
------------FORTBYTE CODE BEGIN----------------------

SMODS.Joker{
    key = 'Fortbyte',
    loc_txt = {
        ['en-us'] = {
            name = "Fortbyte",
            text = {
                "{C:mult}+#2#{} Mult for each {C:purple}Fortlatro{} Voucher redeemed",
                "{C:inactive}Currently{} {C:mult}+#1#{} {C:inactive}Mult{}",
            }
        }
    },
    atlas = 'Jokers',
    pos = { x = 4, y = 43 },
    config = {
        extra = {
            mult = 0,
            mult_add = 2,
            seen_keys = {}
        }
    },
    rarity = 1,
    cost = 6,
    blueprint_compat = true,

    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.extra.mult,
                card.ability.extra.mult_add
            }
        }
    end,  -- ✅ Comma here instead of end,

    update = function(self, card, dt)
        -- Define your Fortlatro voucher keys
        local voucher_keys = {
            'v_fn_Dumpster',
            'v_fn_Dumpster2',
            'v_fn_Riftjector',
            'v_fn_Riftjector2',
            'v_fn_Rarity',
            'v_fn_Rarity2',
            'v_fn_Last',
            'v_fn_Last2',
            'v_fn_Danger',
            'v_fn_Danger2',
            'v_fn_Talk',
            'v_fn_Talk2uh',
            'v_fn_Forecast',
            'v_fn_Forecast2',
            'v_fn_Bush',
            'v_fn_Bush2',
            'v_fn_Nostalgia',
            'v_fn_Nostalgia2',
			'v_fn_Supply',
			'v_fn_Supply2',
            -- Add more voucher keys here
        }

        local count = 0
        for _, key in ipairs(voucher_keys) do
            if G.GAME.used_vouchers[key] then  -- ✅ Fixed syntax
                count = count + 1
            end
        end

        card.ability.extra.mult = count * card.ability.extra.mult_add
    end,

    calculate = function(self, card, context)
        if context.joker_main then
            return {
                mult = card.ability.extra.mult,
                card = self
            }
        end
    end
}



----------------------------------------------
------------FORTBYTE CODE END----------------------

----------------------------------------------
------------FLOWBERRY FIZZ CODE BEGIN----------------------

SMODS.Joker{
    key = 'FlowberryFizz',
    loc_txt = {
        ['en-us'] = {
            name = "Flowberry Fizz",
            text = {
                "Draw {C:attention}#1#{} additional cards when any {C:attention}Consumable{} is used",
            }
        }
    },
    atlas = 'Jokers',
    pos = { x = 2, y = 45 },
    config = {
        extra = {
            cards = 1,
        }
    },
    rarity = 2,
    cost = 9,
    blueprint_compat = true,

    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.extra.cards,
            }
        }
    end,

    calculate = function(self, card, context)
        if context.using_consumeable and #G.hand.cards > 0 and #G.deck.cards > 0 then
            -- Use the card’s dynamically updated value instead of the fixed config value
			local cards_to_draw = card and card.ability and card.ability.extra and card.ability.extra.cards or self.config.extra.cards
			if G and G.hand then
				-- Use the Launch Pad to draw extra cards
				G.FUNCS.draw_from_deck_to_hand(cards_to_draw)
			end
        end
    end
}

----------------------------------------------
------------FLOWBERRY FIZZ CODE END----------------------

----------------------------------------------
------------EPIC GAMES LAUNCHER CODE BEGIN----------------------

SMODS.Joker{
  key = "EGL",
  loc_txt = {
    name = "Epic Games Launcher",
    text = {
      "{X:mult,C:white}X#1#{} Mult if you have {C:purple}Fortnite{} {C:attention}installed{}"
    }
  },
  atlas = 'Jokers',
    pos = { x = 3, y = 45 },
    config = {
        extra = {
            Xmult = 5,
        }
    },
    rarity = 2,
    cost = 5,
    blueprint_compat = true,

    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.extra.Xmult,
            }
        }
    end,
  
  calculate = function(self, card, context)
    if context.joker_main then
      --print("Starting Fortnite installation check...")

      local function file_exists(path)
        --print("Checking if file exists at path: " .. path)
        local file = io.open(path, "r")
        if file then
          --print("File found!")
          file:close()
          return true
        else
          --print("File not found.")
          return false
        end
      end

      local fortnite_path = "\\Program Files\\Epic Games\\Fortnite\\FortniteGame\\Binaries\\Win64\\FortniteClient-Win64-Shipping.exe"

      if file_exists(fortnite_path) then
		--print("Fortnite is installed!")
		return {
          message = localize{type='variable',key='a_xmult',vars={card.ability.extra.Xmult}},
          Xmult_mod = card.ability.extra.Xmult,
      }
      else
        --print("Fortnite not found.")
      end

      --print("Fortnite installation check completed.")
    end
  end,
}

----------------------------------------------
------------EPIC GAMES LAUNCHER CODE END----------------------

--LOTS OF TRACKING CURRENTLY TRACKING ADDED SEALS, ENHANCEMENTS, JOKERS AND EDITIONS

-- Save reference to original add_to_deck
local add_to_deckref = Card.add_to_deck

function Card.add_to_deck(self, from_debuff)
    if not self.added_to_deck then
        if not from_debuff then
            -- Tracking seals
            if self.seal then
                G.GAME.purchased_seals = G.GAME.purchased_seals or {}
                local seal_key = self.seal
                local already_added = false
                for _, stored_key in ipairs(G.GAME.purchased_seals) do
                    if stored_key == seal_key then
                        already_added = true
                        break
                    end
                end
                if not already_added then
                    table.insert(G.GAME.purchased_seals, seal_key)
                end
            end

            -- Tracking editions
            if self.edition and self.edition.type then
                G.GAME.purchased_editions = G.GAME.purchased_editions or {}
                local edition_key = self.edition.type
                local already_added = false
                for _, stored_key in ipairs(G.GAME.purchased_editions) do
                    if stored_key == edition_key then
                        already_added = true
                        break
                    end
                end
                if not already_added then
                    table.insert(G.GAME.purchased_editions, edition_key)
                end
            end

            -- Tracking enhancements
            if self.config and self.config.center and self.config.center.set == "Enhanced" then
                G.GAME.purchased_enhancements = G.GAME.purchased_enhancements or {}
                local enh_key = self.config.center.key or "UnknownEnhancement"
                G.GAME.last_enhancement = enh_key
                local already_added = false
                for _, stored_key in ipairs(G.GAME.purchased_enhancements) do
                    if stored_key == enh_key then
                        already_added = true
                        break
                    end
                end
                if not already_added then
                    table.insert(G.GAME.purchased_enhancements, enh_key)
                    --print("Added Enhancement:", enh_key, "| Total:", #G.GAME.purchased_enhancements)
                end
            end	

            -- Tracking jokers
            if self.ability and self.ability.set == "Joker" then
                G.GAME.purchased_jokers = G.GAME.purchased_jokers or {}
                local key = self.config.center.key
                G.GAME.last_joker = key
                local already_added = false
                for _, stored_key in ipairs(G.GAME.purchased_jokers) do
                    if stored_key == key then
                        already_added = true
                        break
                    end
                end
                if not already_added then
                    table.insert(G.GAME.purchased_jokers, key)
                end
            end
        end
    end

    return add_to_deckref(self, from_debuff)
end


-- applied seal tracking
local oldsetseal = Card.set_seal
function Card:set_seal(_seal, silent, immediate)
    if _seal and self.area == G.hand then
        G.GAME.purchased_seals = G.GAME.purchased_seals or {}
        
        -- Store the most recently applied seal (this is currently unused)
        G.GAME.last_seal = _seal  
		--print("Current Last Seal: " .. tostring(G.GAME.last_seal))
		
        local already_added = false
        for _, stored_key in ipairs(G.GAME.purchased_seals) do
            if stored_key == _seal then
                already_added = true
                break
            end
        end

        if not already_added then
            table.insert(G.GAME.purchased_seals, _seal)
            --print("Added Seal type to purchased list. Total:", #G.GAME.purchased_seals)
        else
            --print("Seal type already in purchased list. Skipping.")
        end
    end

    return oldsetseal(self, _seal, silent, immediate)
end

-- Applied enhancement tracking
local old_set_ability = Card.set_ability
function Card:set_ability(ability, silent)
    local ret = old_set_ability(self, ability, silent)

    -- Only track if ability exists and card is in hand
    if ability and self.area == G.hand and self.config and self.config.center then
        if self.config.center.set == "Enhanced" then
            G.GAME.purchased_enhancements = G.GAME.purchased_enhancements or {}
            local enh_key = self.config.center.key or "UnknownEnhancement"
            G.GAME.last_enhancement = enh_key

            local already_added = false
            for _, stored_key in ipairs(G.GAME.purchased_enhancements) do
                if stored_key == enh_key then
                    already_added = true
                    break
                end
            end

            if not already_added then
                table.insert(G.GAME.purchased_enhancements, enh_key)
                --print("Applied Enhancement via set_ability:", enh_key, "| Total:", #G.GAME.purchased_enhancements)
            end
        end
    end

    return ret
end

-- Edition tracking with foil-on-joker guard, using applied self.edition
local set_edition_ref = Card.set_edition

-- Helper to normalize an edition table to a string name
local function _detect_edition_name(ed)
    if not ed then return nil end
    if type(ed) == "string" then
        -- Accept "e_foil" or "foil"
        return ed:match("^e_(.+)$") or ed
    elseif type(ed) == "table" then
        if type(ed.type) == "string" then return ed.type end
        if type(ed.key)  == "string" then return ed.key  end
        -- As a fallback, detect boolean flags like { foil = true }
        local EXCLUDE = { chips = true, mult = true, type = true, key = true, xmult = true, x_mult = true, xchips = true }
        for k, v in pairs(ed) do
            if v == true and not EXCLUDE[k] and type(k) == "string" then
                return k
            end
        end
    end
    return nil
end

function Card:set_edition(edition, immediate, silent)
    local run = true
    if edition then
        -- Respect your foil restriction for Jokers
        local is_foil_req = (edition == "e_foil") or (type(edition) == "table" and edition.foil == true)
        if is_foil_req
            and G and G.GAME and G.GAME.modifiers and G.GAME.modifiers.no_foil_jokers
            and self.ability and self.ability.set == "Joker"
        then
            self:juice_up(0.5)
            run = false
        end

        if run then
            -- Apply the edition first (so we can read the authoritative self.edition)
            local ret = set_edition_ref(self, edition, immediate, silent)

            -- Now track the applied edition
            if self.edition and self.area == G.hand then
                local applied = _detect_edition_name(self.edition)
                if applied then
                    G.GAME.purchased_editions = G.GAME.purchased_editions or {}
                    G.GAME.last_edition = applied

                    local already = false
                    for _, stored in ipairs(G.GAME.purchased_editions) do
                        if stored == applied then already = true; break end
                    end
                    if not already then
                        table.insert(G.GAME.purchased_editions, applied)
                        --print(("INFO - [G] Added Edition: %s | Total: %d"):format(applied, #G.GAME.purchased_editions))
                    end
                end
            end

            return ret
        end
    end
end


-- Ensure seal + edition tables always exist when a run starts
local igo = Game.init_game_object
function Game:init_game_object()
    local ret = igo(self)

    -- Seals
    if type(ret.purchased_seals) ~= "table" then ret.purchased_seals = {} end
    ret.last_seal = ret.last_seal or nil

    -- Editions
    if type(ret.purchased_editions) ~= "table" then ret.purchased_editions = {} end
    ret.last_edition = ret.last_edition or nil
	
	-- Enhancements
    if type(ret.purchased_enhancements) ~= "table" then ret.purchased_enhancements = {} end
    ret.last_enhancement = ret.last_enhancement or nil

    return ret
end

-- Helpers
local function seal_count()
    return (G and G.GAME and type(G.GAME.purchased_seals) == "table") and #G.GAME.purchased_seals or 0
end

local function edition_count()
    return (G and G.GAME and type(G.GAME.purchased_editions) == "table") and #G.GAME.purchased_editions or 0
end

local function enhancement_count()
    return (G and G.GAME and type(G.GAME.purchased_enhancements) == "table") and #G.GAME.purchased_enhancements or 0
end


----------------------------------------------
------------MARVEL CODE BEGIN----------------------

SMODS.Joker{
    name = "Marvel Series",
    key = "Marvel",
    config = {
        extra = {
            Xmult = 1,
            Xmult_add = 0.5,
        }
    },
    pos = { x = 4, y = 45 },
    loc_txt = {
        name = "Marvel Series",
        text = {
            "This Joker gains {X:mult,C:white}X#2#{} Mult for",
            "every unique {C:attention}Joker{} obtained this run",
            "{C:inactive}Currently {X:mult,C:white}X#1#{}",
            "Idea: BoiRowan",
        }
    },
    rarity = 4,
    cost = 50,
    unlocked = true,
    discovered = false,
    blueprint_compat = true,
    perishable_compat = true,
    atlas = "Jokers",

    loc_vars = function(self, info_queue, card)
		return {
			vars = {
				card.ability.extra.Xmult_add * #G.GAME.purchased_jokers + 0.5, 
				card.ability.extra.Xmult_add,
				#G.GAME.purchased_jokers
			}
		}
	end,
	
	calculate = function(self, card, context)
		if context.joker_main then
			card.ability.extra.Xmult = card.ability.extra.Xmult_add * #G.GAME.purchased_jokers + 0.5
			return {
				message = localize{type='variable',key='a_xmult',vars={card.ability.extra.Xmult}},
				Xmult_mod = card.ability.extra.Xmult,
			}
		end
	end,
}

----------------------------------------------
------------MARVEL CODE END----------------------

----------------------------------------------
------------CLUSTER CLINGER CODE BEGIN----------------------

-- Save original method
local start_dissolve_original = Card.start_dissolve

function Card:start_dissolve(...)
    -- Only act on normal playing cards
    if self.config and self.config.center
       and (self.config.center.set == "Default" or self.config.center.set == "Enhanced") then
        
        -- Check if cluster clinger is present
        local has_cluster = false
        if G.jokers and G.jokers.cards then
            for _, joker in ipairs(G.jokers.cards) do
                if joker.config and joker.config.center and joker.config.center.key == "j_fn_Cluster" then
                    has_cluster = true
                    break
                end
            end
        end

        -- Only do adjacency destruction if cluster clinger is present
        if has_cluster then
            local card_area = self.area or G.hand
            if card_area and card_area.cards then
                local left_card, right_card
                for i = 1, #card_area.cards do
                    if card_area.cards[i] == self then
                        left_card = card_area.cards[i-1]
                        right_card = card_area.cards[i+1]
                        break
                    end
                end

                -- Destroy left card if exists
                if left_card then
                    left_card:shatter()
					if config.sfx ~= false then
						play_sound("fn_clinger")
					end
                end

                -- Destroy right card if exists
                if right_card then
                    right_card:shatter()
					if config.sfx ~= false then
						play_sound("fn_clinger")
					end
                end
            end
        end
    end

    -- Always call original method
    return start_dissolve_original(self, ...)
end

SMODS.Joker{
    name = "Cluster Clinger",
    key = "Cluster",
    pos = { x = 4, y = 46 },
    loc_txt = {
        name = "Cluster Clinger",
        text = {
            "When a card is {C:mult}destroyed{} also {C:mult}destroy{} {C:attention}adjacent{} cards",
			"Idea: BoiRowan"
        }
    },
    rarity = 2,
    cost = 6,
    unlocked = true,
    discovered = false,
    blueprint_compat = true,
    perishable_compat = true,
    atlas = "Jokers",
}

----------------------------------------------
------------CLUSTER CLINGER CODE END----------------------

----------------------------------------------
------------HELIOS CODE BEGIN----------------------

SMODS.Sound({
	key = "gaster",
	path = "gaster.ogg",
})

SMODS.Joker{
    name = "Helios?",
    key = "Helios",
    config = {
        extra = {
            Xmult = 2.5,
        }
    },
    pos = { x = 0, y = 47 },
    loc_txt = {
        name = "Helios?",
        text = {
            "{X:mult,C:white}X#1#{} Mult",
            "Only exists during {C:attention}Boss Blinds{}",
        }
    },
    rarity = 3,
    cost = 5,
    unlocked = true,
    discovered = false,
    blueprint_compat = true,
    perishable_compat = true,
    atlas = "Jokers",

    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.extra.Xmult,
            }
        }
    end,
	
    add_to_deck = function(self, card)
        -- Create a copy and move it to vouchers
		if config.sfx ~= false then
			play_sound("fn_gaster")
		end
        local copy = copy_card(card)
        G.vouchers:emplace(copy)
        copy:start_materialize(nil, nil)

        -- Destroy the original card
        card:start_dissolve()
    end,
	
    calculate = function(self, card, context)
		
		if card.area == G.vouchers and context.setting_blind and G.GAME.blind.boss then
			if config.sfx ~= false then
				play_sound("fn_gaster")
			end
			local copy = copy_card(card)
			G.jokers:emplace(copy)
			copy:start_materialize(nil, nil)

			-- Destroy the original card
			card:start_dissolve()
		end
		
		if card.area == G.jokers and context.end_of_round and not context.repetition and not context.individual then
			-- Create a copy and move it to vouchers
			if config.sfx ~= false then
				play_sound("fn_gaster")
			end
			local copy = copy_card(card)
			G.vouchers:emplace(copy)
			copy:start_materialize(nil, nil)

			-- Destroy the original card
			card:start_dissolve()
		end
		
        if context.joker_main and G.GAME.blind.boss then
            return {
                message = localize{type='variable',key='a_xmult',vars={card.ability.extra.Xmult}},
                Xmult_mod = card.ability.extra.Xmult,
            }
        end
		
		
    end,
}

----------------------------------------------
------------HELIOS CODE END----------------------

----------------------------------------------
------------ICON SERIES CODE BEGIN----------------------

SMODS.Joker{
    name = "Icon Series",
    key = "Icon",
    config = { extra = { Xmult_add = 1.25 } },
    pos = { x = 3, y = 47 },
    loc_txt = {
        name = "Icon Series",
        text = {
            "This Joker gains {X:mult,C:white}X#2#{} Mult for",
            "every unique {C:mult}Seal{} obtained this run",
            "{C:inactive}Currently {X:mult,C:white}X#1#{}",
            "Idea: BoiRowan",
        }
    },
    rarity = 4, cost = 50, unlocked = true, discovered = false,
    blueprint_compat = true, perishable_compat = true, atlas = "Jokers",

    loc_vars = function(self, info_queue, card)
        local add   = card and card.ability and card.ability.extra and card.ability.extra.Xmult_add or 1.25
        local count = seal_count()
        local currX = 1 + add * count
        return { vars = { currX, add} }
    end,

    calculate = function(self, card, context)
        if context.joker_main then
            local count = seal_count()
            local xmult = 1 + card.ability.extra.Xmult_add * count
            return {
                message = localize{ type = 'variable', key = 'a_xmult', vars = { xmult } },
                Xmult_mod = xmult,
            }
        end
    end,
}

----------------------------------------------
------------ICON SERIES CODE END----------------------

----------------------------------------------
------------GAMING LEGENDS SERIES CODE BEGIN----------------------

SMODS.Joker{
    name = "Gaming Legends Series",
    key = "Gaming",
    config = { extra = { Xmult_add = 1.25 } },
    pos = { x = 4, y = 47 },
    loc_txt = {
        name = "Gaming Legends Series",
        text = {
            "This Joker gains {X:mult,C:white}X#2#{} Mult for",
            "every unique {C:dark_edition}Edition{} obtained this run",
            "{C:inactive}Currently {X:mult,C:white}X#1#{}",
            "Idea: BoiRowan",
        }
    },
    rarity = 4, cost = 50, unlocked = true, discovered = false,
    blueprint_compat = true, perishable_compat = true, atlas = "Jokers",

    loc_vars = function(self, info_queue, card)
        local add   = card and card.ability and card.ability.extra and card.ability.extra.Xmult_add or 1.25
        local count = edition_count()
        local currX = 1 + add * count
        return { vars = { currX, add} }
    end,

    calculate = function(self, card, context)
        if context.joker_main then
            local count = edition_count()
            local xmult = 1 + card.ability.extra.Xmult_add * count
            return {
                message = localize{ type = 'variable', key = 'a_xmult', vars = { xmult } },
                Xmult_mod = xmult,
            }
        end
    end,
}

----------------------------------------------
------------GAMING LEGENDS SERIES CODE END----------------------

----------------------------------------------
------------WRTIS CODE BEGIN----------------------

SMODS.Sound({
	key = "wrtis",
	path = "wrtis.ogg",
})

SMODS.Joker{
    key = "WRTIS",
    loc_txt = {
        name = "Who Remembers The Infinity Stones?",
        text = {
            "{C:mult}+#1#{} Mult for every {C:attention}Year{}",
            "since {C:attention}The Infinity Stones{} were in {C:purple}Fortnite{}",
			"{C:inactive}Currently{} {C:mult}#2#{} {C:inactive}Mult{}",
			"Idea: Amineleguy"
        }
    },
    atlas = 'Jokers',
    pos = { x = 0, y = 48 },
    config = {
        extra = {
            mult = 0,      -- base multiplier (we'll calculate dynamic value)
            mult_add = 1,  -- amount to add per year
        }
    },
    rarity = 1,
    cost = 2,
    blueprint_compat = true,
	
	loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.extra.mult_add,
				card.ability.extra.mult_add * os.date("*t").year - 2018,
            }
        }
    end,

    calculate = function(self, card, context)
        if context.joker_main then
            local current_date = os.date("*t")
            
            -- May 15, 2018
            local start_year = 2018
            local start_month = 5
            local start_day = 15

            local year_diff = current_date.year - start_year

            -- If the current date is before May 15, subtract 1 from the difference
            if current_date.month < start_month or (current_date.month == start_month and current_date.day < start_day) then
                year_diff = year_diff - 1
            end

            -- Set the multiplier
            card.ability.extra.mult = year_diff * card.ability.extra.mult_add
			return {
				message = "who remembers the infinity stones?",
				colour = G.ARGS.LOC_COLOURS.fn_eternal,
				mult = card.ability.extra.mult,
				sound = 'fn_wrtis',
                card = self
            }
        end
    end,
}

----------------------------------------------
------------WRTIS CODE END----------------------

----------------------------------------------
------------STAR WARS SERIES CODE BEGIN----------------------

SMODS.Joker{
    name = "Star Wars Series",
    key = "StarWars",
    config = { extra = { Xmult_add = 1 } },
    pos = { x = 1, y = 48 },
    loc_txt = {
        name = "Star Wars Series",
        text = {
            "This Joker gains {X:mult,C:white}X#2#{} Mult for",
            "every unique {C:dark_edition}Enhancement{} obtained this run",
            "{C:inactive}Currently {X:mult,C:white}X#1#{}",
            "Idea: BoiRowan",
        }
    },
    rarity = 4, cost = 50, unlocked = true, discovered = false,
    blueprint_compat = true, perishable_compat = true, atlas = "Jokers",

    loc_vars = function(self, info_queue, card)
        local add   = card and card.ability and card.ability.extra and card.ability.extra.Xmult_add or 1.25
        local count = enhancement_count()
        local currX = 1 + add * count
        return { vars = { currX, add} }
    end,

    calculate = function(self, card, context)
        if context.joker_main then
            local count = enhancement_count()
            local xmult = 1 + card.ability.extra.Xmult_add * count
            return {
                message = localize{ type = 'variable', key = 'a_xmult', vars = { xmult } },
                Xmult_mod = xmult,
            }
        end
    end,
}

----------------------------------------------
------------STAR WARS SERIES CODE END----------------------



-- Shared idol card selector (called each round)
local function reset_vremade_idol_card()
    G.GAME.current_round.vremade_idol_card = { rank = 'Ace', suit = 'Spades' }
    local valid_idol_cards = {}
    for _, playing_card in ipairs(G.playing_cards) do
        if not SMODS.has_no_suit(playing_card) and not SMODS.has_no_rank(playing_card) then
            valid_idol_cards[#valid_idol_cards + 1] = playing_card
        end
    end
    local idol_card = pseudorandom_element(valid_idol_cards, pseudoseed('idol' .. G.GAME.round_resets.ante))
    if idol_card then
        G.GAME.current_round.vremade_idol_card.rank = idol_card.base.value
        G.GAME.current_round.vremade_idol_card.suit = idol_card.base.suit
        G.GAME.current_round.vremade_idol_card.id = idol_card.base.id
    end
end

-- Hook run start
local start_run_ref = Game.start_run
function Game:start_run(args)
    start_run_ref(self, args)
	if not next(SMODS.find_card('j_fn_Chewbacca')) then
		reset_vremade_idol_card()
	end
end


----------------------------------------------
------------CHEWBACCA SPAWNER CODE BEGIN----------------------

SMODS.Joker {
    key = "Chewbacca",
    blueprint_compat = true,
    rarity = 3,
    cost = 6,
	atlas = 'Jokers',
    pos = { x = 3, y = 48 },
    config = { extra = { jokers = 1 } }, -- number of jokers to spawn
    loc_txt = {
        name = "Chewbacca Spawner",
        text = {
            "Creates {C:attention}#1#{} random {C:purple}Fortlatro{} Joker",
            "When a {C:attention}#2# of #3#{} is played",
			"{C:inactive}(Changes every round){}",
            "{C:inactive}(No need to have room){}",
			"Idea: opal.lua "
        }
    },
    loc_vars = function(self, info_queue, card)
        local idol_card = G.GAME.current_round.vremade_idol_card or { rank = 'Ace', suit = 'Spades' }
        return {
            vars = {
                card.ability.extra.jokers,
                localize(idol_card.rank, 'ranks'),
                localize(idol_card.suit, 'suits_plural'),
                colours = { G.C.SUITS[idol_card.suit] }
            }
        }
    end,
    calculate = function(self, card, context)
        local idol_card = G.GAME.current_round.vremade_idol_card
        if idol_card and context.individual and context.cardarea == G.play and
            context.other_card:get_id() == idol_card.id and
            context.other_card:is_suit(idol_card.suit) then
			
			
			local fortlatro_jokers = {
            'j_fn_Eric', 'j_fn_Crac', 'j_fn_Emily', 'j_fn_Toilet', 'j_fn_Toilet', 'j_fn_TheDub', 'j_fn_TheDub', 'j_fn_TheDub', 'j_fn_FlushFactory', 'j_fn_FlushFactory',
            'j_fn_VictoryCrown', 'j_fn_VictoryCrown', 'j_fn_Peely', 'j_fn_Peely', 'j_fn_Zorlodo', 'j_fn_SolidGold', 'j_fn_SolidGold', 'j_fn_SolidGold', 'j_fn_BattleBus', 'j_fn_BattleBus', 'j_fn_BattleBus', 'j_fn_SaveTheWorld',
            'j_fn_ChugJug', 'j_fn_ChugJug', 'j_fn_BigPot', 'j_fn_BigPot', 'j_fn_BigPot', 'j_fn_Mini', 'j_fn_Mini', 'j_fn_Mini', 'j_fn_Vbucks', 'j_fn_Vbucks', 'j_fn_Vbucks', 'j_fn_Augment', 'j_fn_BluGlo', 'j_fn_BluGlo', 'j_fn_BluGlo',
            'j_fn_RebootCard', 'j_fn_Oscar', 'j_fn_Oscar', 'j_fn_Oscar', 'j_fn_Montague', 'j_fn_Montague', 'j_fn_MagmaReef', 'j_fn_DurrBurger', 'j_fn_DurrBurger', 'j_fn_DurrBurger', 'j_fn_AcesWild',
            'j_fn_Miku', 'j_fn_Bench', 'j_fn_Bench', 'j_fn_Bench', 'j_fn_Nothing', 'j_fn_Nothing', 'j_fn_Nothing', 'j_fn_Flip', 'j_fn_Flip', 'j_fn_Flip', 'j_fn_MVM', 'j_fn_MVM', 'j_fn_Thanos', 'j_fn_Racing', 'j_fn_Racing', 'j_fn_Racing',
            'j_fn_50v50', 'j_fn_50v50', 'j_fn_50v50', 'j_fn_DoublePump', 'j_fn_DoublePump', 'j_fn_Festival', 'j_fn_Festival', 'j_fn_KineticBlade', 'j_fn_KineticBlade', 'j_fn_Kado', 'j_fn_TyphoonBlade',
            'j_fn_Kane', 'j_fn_Kane', 'j_fn_DB', 'j_fn_DB', 'j_fn_Vulture', 'j_fn_Vulture', 'j_fn_Vulture', 'j_fn_CassidyQuinn', 'j_fn_CassidyQuinn', 'j_fn_Termite', 'j_fn_Termite', 'j_fn_Termite', 'j_fn_Shadow', 'j_fn_Shadow', 'j_fn_Ghost', 'j_fn_Ghost',
            'j_fn_BattleLab', 'j_fn_Tent', 'j_fn_Tent', 'j_fn_Cart', 'j_fn_Cart', 'j_fn_Cart', 'j_fn_Vault', 'j_fn_Vault', 'j_fn_Vault', 'j_fn_Fishing', 'j_fn_Fishing', 'j_fn_Fishing', 'j_fn_Slurp', 'j_fn_Slurp', 'j_fn_Slurp', 'j_fn_Lava', 'j_fn_Lava', 'j_fn_Lava',
            'j_fn_ATK', 'j_fn_ATK', 'j_fn_ATK', 'j_fn_Aimbot', 'j_fn_BetterAimbot', 'j_fn_Skibidi', 'j_fn_Skibidi', 'j_fn_Bots', 'j_fn_Bots', 'j_fn_Bots', 'j_fn_NickEh30', 'j_fn_NickEh30', 'j_fn_NickEh30', 'j_fn_RiftGun',
            'j_fn_Rabbit', 'j_fn_Fox', 'j_fn_Llama', 'j_fn_Rabbit', 'j_fn_Fox', 'j_fn_Llama', 'j_fn_Hide', 'j_fn_Hide', 'j_fn_Cubert', 'j_fn_Cubert', 'j_fn_ShadowSeries', 'j_fn_ShadowSeries', 'j_fn_ShadowSeries', 'j_fn_Unvaulting', 'j_fn_Unvaulting',
            'j_fn_Jar', 'j_fn_Jar', 'j_fn_Fashion', 'j_fn_Fashion', 'j_fn_Control', 'j_fn_BP', 'j_fn_IBlade', 'j_fn_Default', 'j_fn_Recon', 'j_fn_Default', 'j_fn_Recon',
            'j_fn_Whiplash', 'j_fn_Whiplash', 'j_fn_Whiplash', 'j_fn_Quadcrasher', 'j_fn_Quadcrasher', 'j_fn_Quadcrasher', 'j_fn_Daily', 'j_fn_Void', 'j_fn_Void', 'j_fn_GG', 'j_fn_Clickbait', 'j_fn_Clickbait', 'j_fn_Clickbait', 'j_fn_Clickbait', 'j_fn_Noobs', 'j_fn_Noobs',
            'j_fn_Dark', 'j_fn_Frozen', 'j_fn_Frozen', 'j_fn_DC', 'j_fn_OGPass', 'j_fn_OGPass', 'j_fn_Reload', 'j_fn_Reload', 'j_fn_Circle', 'j_fn_Circle2', 'j_fn_Circle', 'j_fn_Circle2',
            'j_fn_Jam', 'j_fn_Fortnite', 'j_fn_Fortnite', 'j_fn_Smoothie', 'j_fn_Smoothie', 'j_fn_Sprite', 'j_fn_Prebuild', 'j_fn_Prebuild', 'j_fn_Shogun', 'j_fn_Shogun', 'j_fn_Killswitch', 'j_fn_Killswitch', 'j_fn_Hero', 'j_fn_Hero', 'j_fn_NBA', 'j_fn_Tempest', 'j_fn_Tempest', 'j_fn_Tempest', 'j_fn_Tempest', 'j_fn_Griddy', 'j_fn_Griddy', 'j_fn_Griddy',
			'j_fn_Circle3', 'j_fn_Circle3', 'j_fn_Circle3', 'j_fn_Fortbyte', 'j_fn_Fortbyte', 'j_fn_Fortbyte', 'j_fn_Fortbyte', 'j_fn_FlowberryFizz', 'j_fn_FlowberryFizz', 'j_fn_FlowberryFizz', 'j_fn_EGL', 'j_fn_EGL', 'j_fn_EGL', 'j_fn_Marvel', 'j_fn_Cluster', 'j_fn_Cluster', 'j_fn_Cluster', 'j_fn_Icon', 'j_fn_Gaming', 'j_fn_WRTIS', 'j_fn_WRTIS', 'j_fn_WRTIS', 'j_fn_WRTIS',
			'j_fn_StarWars', 'j_fn_Chewbacca', 'j_fn_Crew',
			}
			
			
            local jokers_to_create = card.ability.extra.jokers or 1
            for _ = 1, jokers_to_create do
                local selected_joker = fortlatro_jokers[math.random(#fortlatro_jokers)]
                local joker_card = create_card('Joker', G.jokers, nil, nil, nil, nil, selected_joker)
                joker_card:add_to_deck()
                G.jokers:emplace(joker_card)
            end
        end
		
		if context.end_of_round then
			reset_vremade_idol_card()
		end
    end,
}

----------------------------------------------
------------CHEWBACCA SPAWNER CODE END----------------------

SMODS.Joker({
    key = 'Crew',
    loc_txt = {
        name = 'Fortnite Crew',
        text = {
            "{C:attention}Scaling{} Jokers have a {C:green}#1# in #2#{} chance to retrigger",
            "Idea: BoiRowan",
        }
    },
    rarity = 3,
    atlas = "Jokers",
    pos = {x = 4, y = 48},
    cost = 12,
    unlocked = true,
    discovered = false,
    eternal_compat = true,
    blueprint_compat = true,
    perishable_compat = false,

    config = {
        extra = {
            odds = 2,  -- 1 in 2 chance
        }
    },

    loc_vars = function(self, info_queue, card)
        return {
            vars = {G.GAME.probabilities.normal, card.ability.extra.odds}
        }
    end,

    calculate = function(self, card, context)
        if (context.retrigger_joker_check 
            and not context.retrigger_joker 
            and context.other_card ~= self 
            and context.other_card.ability 
            and context.other_card.ability.extra) then
            local extra = context.other_card.ability.extra

            -- Only retrigger if Joker has one of these scaling fields
            if extra.mult_add or extra.multadd or extra.multgain or extra.mult_gain or extra.mult_mod or extra.multmod or extra.xmult_add or extra.Xmult_add or extra.Xmult_mod or extra.x_mult_add or extra.x_gain or extra.x_mult_mod or extra.xmult_mod or extra.x_chips_add or extra.xchips_add or extra.x_chips_mod or extra.xchips_mod or extra.scaling then
				if pseudorandom('Subscribe') < G.GAME.probabilities.normal/card.ability.extra.odds then

					return {
						message = localize('k_again_ex'),
						colour = G.C.Mult,
						repetitions = 1,
						card = card,
					}
				end
            end
        end
    end,
})


----------------------------------------------
------------GLASSES CODE BEGIN----------------------

if config.ortalabcompat ~= false then
    SMODS.Consumable{
        key = 'LTMGlasses', -- key
        set = 'LTMConsumableType', -- the set of the card: corresponds to a consumable type
        atlas = 'Jokers', -- atlas
        pos = {x = 0, y = 1}, -- position in atlas
        loc_txt = {
            name = 'Eric\'s 3D Glasses', -- name of card
            text = { -- text of card
                'Everything has so much more depth',
                'Apply {C:mult}A{}{C:chips}n{}{C:mult}a{}{C:chips}g{}{C:mult}l{}{C:chips}y{}{C:mult}p{}{C:chips}h{}{C:mult}i{}{C:chips}c{} to up to {C:attention}#1#{} selected cards',
            }
        },
        config = {
            extra = {
                cards = 3, -- configurable value
            }
        },
        loc_vars = function(self, info_queue, center)
            info_queue[#info_queue + 1] = G.P_CENTERS.e_ortalab_anaglyphic
            if center and center.ability and center.ability.extra then
                return {vars = {center.ability.extra.cards}} 
            end
            return {vars = {}}
        end,
        can_use = function(self, card)
            if G and G.hand and G.hand.highlighted and card.ability and card.ability.extra and card.ability.extra.cards then
                if #G.hand.highlighted > 0 and #G.hand.highlighted <= card.ability.extra.cards then
                    return true
                end
            end
            return false
        end,
        use = function(self, card, area, copier)
            if G and G.hand and G.hand.highlighted then
                for i = 1, #G.hand.highlighted do
                    G.hand.highlighted[i]:set_edition({ortalab_anaglyphic = true},true)
                end
            end
        end,
    }
end

----------------------------------------------
------------GLASSES CODE END----------------------

----------------------------------------------
------------BLOOD CODE BEGIN----------------------

if config.cryptidcompat ~= false then
    SMODS.Consumable{
        key = 'LTMBlood', -- key
        set = 'LTMConsumableType', -- the set of the card: corresponds to a consumable type
        atlas = 'Jokers', -- atlas
        pos = {x = 1, y = 1}, -- position in atlas
        loc_txt = {
            name = 'Eric\'s Blood', -- name of card
            text = { -- text of card
                'You REALLY shouldn\'t touch that',
                'Apply {C:dark_edition}Glitched{} to up to {C:attention}#1#{} selected Cards, Jokers, or Consumables',
            }
        },
        config = {
            extra = {
                cards = 4, -- configurable value
            }
        },
        loc_vars = function(self, info_queue, center)
            info_queue[#info_queue + 1] = G.P_CENTERS.e_cry_glitched
            if center and center.ability and center.ability.extra then
                return {vars = {center.ability.extra.cards - 1}} 
            end
            return {vars = {}}
        end,
        can_use = function(self, card)
            if G and card.ability and card.ability.extra and card.ability.extra.cards then
                local maxCards = card.ability.extra.cards
                local highlightedCardsCount = 0

                -- Count highlighted cards in hand, jokers, consumables, and pack cards
                highlightedCardsCount = highlightedCardsCount + #G.hand.highlighted
                highlightedCardsCount = highlightedCardsCount + #G.jokers.highlighted
                highlightedCardsCount = highlightedCardsCount + #G.consumeables.highlighted
                highlightedCardsCount = highlightedCardsCount + (G.pack_cards and #G.pack_cards.highlighted or 0)

                -- Check if the highlighted cards are within the allowed limit
                if highlightedCardsCount > 0 and highlightedCardsCount <= maxCards then
                    return true
                end
            end
            return false
        end,
        use = function(self, card, area, copier)
            local highlightedCards = {}  -- Collect all the highlighted cards from each category

            -- Add selected cards from each category to the list
            for _, category in ipairs({G.hand.highlighted, G.jokers.highlighted, G.consumeables.highlighted, G.pack_cards and G.pack_cards.highlighted or {}}) do
                for i = 1, #category do
                    table.insert(highlightedCards, category[i])
                end
            end

            -- Apply the effect to the selected cards, jokers, and consumables
            for i = 1, math.min(#highlightedCards, card.ability.extra.cards) do
                local cardToModify = highlightedCards[i]
                cardToModify:set_edition({cry_glitched = true}, true)
            end
        end,
    }
end



----------------------------------------------
------------BLOOD CODE END----------------------

----------------------------------------------
------------PERK UP CODE BEGIN----------------------

SMODS.Sound({
	key = "perk",
	path = "perk.ogg",
})

SMODS.ConsumableType{
    key = 'LTMConsumableType', -- consumable type key

    collection_rows = {4,5}, -- amount of cards in one page
    primary_colour = G.C.PURPLE, -- first color
    secondary_colour = G.C.DARK_EDITION, -- second color
    loc_txt = {
        collection = 'LTM Cards', -- name displayed in collection
        name = 'LTM Cards', -- name displayed in badge
        undiscovered = {
            name = 'Hidden LTM', -- undiscovered name
            text = {'you dont know the', 'playlist id'} -- undiscovered text
        }
    },
    shop_rate = 1, -- rate in shop out of 100
}

SMODS.UndiscoveredSprite{
    key = 'LTMConsumableType', -- must be the same key as the consumabletype
    atlas = 'Jokers',
    pos = {x = 0, y = 0}
}

SMODS.Consumable{
    key = 'LTMPerk', -- key
    set = 'LTMConsumableType', -- the set of the card: corresponds to a consumable type
    atlas = 'Jokers', -- atlas
    pos = {x = 2, y = 1}, -- position in atlas
    loc_txt = {
        name = 'Perk Up', -- name of card
        text = { -- text of card
            'Resource used to upgrade Cards',
            'Found in the Store or summoned by {C:mult}Crac',
            'Apply a random enhancement to up to {C:attention}#1#{} selected cards',
        }
    },
    config = {
        extra = {
            cards = 5, -- configurable value
        }
    },
    loc_vars = function(self, info_queue, center)
        if center and center.ability and center.ability.extra then
            return {vars = {center.ability.extra.cards}} 
        end
        return {vars = {}}
    end,
    can_use = function(self, card)
        if G and G.hand and G.hand.highlighted and card.ability and card.ability.extra and card.ability.extra.cards then
            if #G.hand.highlighted > 0 and #G.hand.highlighted <= card.ability.extra.cards then
                return true
            end
        end
        return false
    end,
    use = function(self, card, area, copier)
        if config.sfx ~= false then
            play_sound("fn_perk")
        end
        
        -- Apply a random enhancement using the poll_enhancement function
        if G and G.hand and G.hand.highlighted then
            for _, selected_card in ipairs(G.hand.highlighted) do
                local enhancement_key = {key = 'perk', guaranteed = true}
                local random_enhancement = G.P_CENTERS[SMODS.poll_enhancement(enhancement_key)]
                selected_card:set_ability(random_enhancement, true)

                -- Trigger a visual effect for enhancement
                G.E_MANAGER:add_event(Event({
                    func = function()
                        selected_card:juice_up() -- Visually enhance the card
                        return true
                    end
                }))
            end
        end
    end,
}


----------------------------------------------
------------PERK UP CODE END----------------------

----------------------------------------------
------------SUPERCHARGER CODE BEGIN----------------------

SMODS.ConsumableType{
    key = 'LTMConsumableType', -- consumable type key

    collection_rows = {4, 5}, -- amount of cards in one page
    primary_colour = G.C.PURPLE, -- first color
    secondary_colour = G.C.DARK_EDITION, -- second color
    loc_txt = {
        collection = 'LTM Cards', -- name displayed in collection
        name = 'LTM Cards', -- name displayed in badge
        undiscovered = {
            name = 'Hidden LTM', -- undiscovered name
            text = {'you dont know the', 'playlist id'} -- undiscovered text
        }
    },
    shop_rate = 1, -- rate in shop out of 100
}

SMODS.UndiscoveredSprite{
    key = 'LTMConsumableType', -- must be the same key as the consumabletype
    atlas = 'Jokers',
    pos = {x = 0, y = 0}
}

SMODS.Consumable{
    key = 'LTMSupercharge',
    set = 'LTMConsumableType',
    atlas = 'Jokers',
    pos = {x = 3, y = 1},
    loc_txt = {
        name = 'Card Supercharger',
        text = {
            'Used to promote cards',
            'Found in the Store or summoned by {C:mult}Crac',
            'add a random seal to {C:attention}#1#{} selected cards',
        }
    },
    config = {
        extra = {
            cards = 3, -- configurable value
        }
    },
    loc_vars = function(self, info_queue, center)
        if center and center.ability and center.ability.extra then
            return {vars = {center.ability.extra.cards}}
        end
        return {vars = {}}
    end,
    can_use = function(self, card)
        if G and G.hand and G.hand.highlighted and card.ability and card.ability.extra and card.ability.extra.cards then
            if #G.hand.highlighted > 0 and #G.hand.highlighted <= card.ability.extra.cards then
                return true
            end
        end
        return false
    end,
    use = function(self, card, area, copier)
        for i, v in pairs(G.hand.highlighted) do
            -- Set a random seal using a guaranteed poll method
            v:set_seal(SMODS.poll_seal({key = 'supercharge', guaranteed = true}), true)

            -- Add an event to "juice up" the card after sealing
            G.E_MANAGER:add_event(Event({
                func = function()
                    v:juice_up(0.3, 0.4)
                    return true
                end
            }))
        end
    end,
}

----------------------------------------------
------------SUPERCHARGER CODE END----------------------

----------------------------------------------
------------DOUBLE OR NOTHING CODE BEGIN----------------------
SMODS.Consumable{
    key = 'DoubleOrNothing', -- key
    set = 'Spectral', -- the set of the card: corresponds to a consumable type
    atlas = 'Jokers', -- atlas
    pos = {x = 4, y = 1}, -- position in atlas
    loc_txt = {
        name = 'Double Or Nothing!', -- name of card
        text = { -- text of card
            '{C:green,E:1,S:1.1}#1# in #2#{} chance to spawn {C:attention}2{} {C:spectral}Ethereal{} tags',
        },
    },
    config = {
        extra = { odds = 2 }, -- Configuration: odds of success (set to 2 for 50% chance)
        no_pool_flag = 'gamble',
    },
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_TAGS.tag_ethereal
        return {vars = {G.GAME.probabilities.normal, card.ability.extra.odds}}
    end,
    use = function(self, card, area, copier)
        G.GAME.pool_flags.gamble = true -- Ensure 'gamble' flag is set

        -- Use the game's internal roll value (assuming it's already handled)
        if pseudorandom('mrbeast') < G.GAME.probabilities.normal/card.ability.extra.odds then
			if config.sfx ~= false then
				play_sound("fn_happy")
			end
            -- Success: Grant 2 ethereal tags
            add_tag(Tag('tag_ethereal'))
            add_tag(Tag('tag_ethereal'))

            -- Display success message on the consumable
            card_eval_status_text(card, 'extra', nil, nil, nil, {
                message = "DOUBLE!", -- Display "DOUBLE!" message
                colour = G.C.GREEN,
            })
        else
            -- Failure: No tags granted
            -- Display failure message on the consumable
			if config.sfx ~= false then
				play_sound("fn_sad")
			end
            card_eval_status_text(card, 'extra', nil, nil, nil, {
                message = "NOTHING!", -- Display "NOTHING!" message
                colour = G.C.RED,
            })
        end
    end,
    can_use = function(self, card)
        return true
    end,
}


----------------------------------------------
------------DOUBLE OR NOTHING CODE END----------------------

----------------------------------------------
------------CARD FLIP CODE BEGIN----------------------
SMODS.ConsumableType{
    key = 'LTMConsumableType', -- consumable type key

    collection_rows = {4, 5}, -- amount of cards in one page
    primary_colour = G.C.PURPLE, -- first color
    secondary_colour = G.C.DARK_EDITION, -- second color
    loc_txt = {
        collection = 'LTM Cards', -- name displayed in collection
        name = 'LTM Cards', -- name displayed in badge
        undiscovered = {
            name = 'Hidden LTM', -- undiscovered name
            text = {'you dont know the', 'playlist id'} -- undiscovered text
        }
    },
    shop_rate = 1, -- rate in shop out of 100
}

SMODS.UndiscoveredSprite{
    key = 'LTMConsumableType', -- must be the same key as the consumabletype
    atlas = 'Jokers',
    pos = {x = 0, y = 0}
}

SMODS.Consumable{
    key = 'LTMStormFlip', -- key
    set = 'LTMConsumableType', -- the set of the card: corresponds to a consumable type
    atlas = 'Jokers', -- atlas
    pos = {x = 2, y = 3}, -- position in atlas
    loc_txt = {
        name = 'Card Flip', -- name of card
        text = { -- text of card
            'Flip up to {C:attention}#1#{} selected Cards, Jokers, or Consumables',
        }
    },
    config = {
        extra = {
            cards = 6, -- configurable value
        }
    },
    loc_vars = function(self, info_queue, center)
        if center and center.ability and center.ability.extra then
            return {vars = {center.ability.extra.cards -1}} 
        end
        return {vars = {}}
    end,
    can_use = function(self, card)
        if G and card.ability and card.ability.extra and card.ability.extra.cards then
            local maxCards = card.ability.extra.cards
            local highlightedCardsCount = 0

            -- Count highlighted cards in hand, jokers, consumables, and pack cards
            highlightedCardsCount = highlightedCardsCount + #G.hand.highlighted
            highlightedCardsCount = highlightedCardsCount + #G.jokers.highlighted
            highlightedCardsCount = highlightedCardsCount + #G.consumeables.highlighted
            highlightedCardsCount = highlightedCardsCount + (G.pack_cards and #G.pack_cards.highlighted or 0)

            -- Check if the highlighted cards are within the allowed limit
            if highlightedCardsCount > 0 and highlightedCardsCount <= maxCards then
                return true
            end
        end
        return false
    end,
    use = function(self, card, area, copier)
        local highlightedCards = {}  -- Collect all the highlighted cards from each category

        -- Add selected cards from each category to the list
        for _, category in ipairs({G.hand.highlighted, G.jokers.highlighted, G.consumeables.highlighted, G.pack_cards and G.pack_cards.highlighted or {}}) do
            for i = 1, #category do
                table.insert(highlightedCards, category[i])
            end
        end

        -- Flip the selected cards, up to the maximum allowed
        for i = 1, math.min(#highlightedCards, card.ability.extra.cards) do
            local cardToFlip = highlightedCards[i]
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.4,
                func = function()
                    cardToFlip:flip()  -- Flip the card
                    play_sound('tarot1', 1.1, 0.6)  -- Play sound effect
                    return true
                end
            }))
        end
    end,
}

----------------------------------------------
------------CARD FLIP CODE END----------------------

----------------------------------------------
------------KINETIC ORE CODE BEGIN----------------------

if config.cryptidcompat ~= false then
    SMODS.Consumable{
        key = 'LTMKinetic', -- key
        set = 'LTMConsumableType', -- the set of the card: corresponds to a consumable type
        atlas = 'Jokers', -- atlas
        pos = {x = 0, y = 4}, -- position in atlas
        loc_txt = {
            name = 'Kinetic Ore', -- name of card
            text = { -- text of card
                'A powerful and durable ore that can be found in many realities',
                'Apply {C:inactive}Stone{} and {C:dark_edition}Astral{} to up to {C:attention}#1#{} selected cards',
            }
        },
        config = {
            extra = {
                cards = 1, -- configurable value
            }
        },
        loc_vars = function(self, info_queue, center)
            info_queue[#info_queue + 1] = G.P_CENTERS.m_stone
            info_queue[#info_queue + 1] = G.P_CENTERS.e_cry_astral
            if center and center.ability and center.ability.extra then
                return {vars = {center.ability.extra.cards}} 
            end
            return {vars = {}}
        end,
        can_use = function(self, card)
            if G and G.hand and G.hand.highlighted and card.ability and card.ability.extra and card.ability.extra.cards then
                if #G.hand.highlighted > 0 and #G.hand.highlighted <= card.ability.extra.cards then
                    return true
                end
            end
            return false
        end,
        use = function(self, card, area, copier)
            if G and G.hand and G.hand.highlighted then
                for i = 1, #G.hand.highlighted do
                    local target_card = G.hand.highlighted[i]
                    
                    -- Apply the "Stone" ability
                    target_card:set_ability(G.P_CENTERS.m_stone, nil, true)
                    
                    -- Apply the "Astral" edition
                    target_card:set_edition({cry_astral = true}, true)
                    
                    -- Add an event to juice up the card
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            target_card:juice_up()
                            return true
                        end
                    }))
                end
            end
        end,
    }
end


----------------------------------------------
------------KINETIC ORE CODE END----------------------

----------------------------------------------
------------LAUNCH PAD CODE BEGIN----------------------

SMODS.Consumable{ 
    key = 'LTMLaunchPad', -- key
    set = 'LTMConsumableType', -- the set of the card
    atlas = 'Jokers', -- atlas
    pos = {x = 1, y = 4}, -- position in atlas
    loc_txt = {
        name = 'Launch Pad', -- name of the consumable
        text = { 
            'Draw {C:attention}#1#{} additional cards'
        }
    },
    config = {
        extra = {
            cards = 2, -- configurable value (number of cards to draw)
        }
    },
    loc_vars = function(self, info_queue, center)
        if center and center.ability and center.ability.extra then
            return {vars = {center.ability.extra.cards}} 
        end
        return {vars = {}}
    end,
    can_use = function(self)
        return #G.hand.cards > 0 and #G.deck.cards > 0
    end,
    use = function(self, card, area, copier)
        -- Use the card’s dynamically updated value instead of the fixed config value
        local cards_to_draw = card and card.ability and card.ability.extra and card.ability.extra.cards or self.config.extra.cards
        if G and G.hand then
            -- Use the Launch Pad to draw extra cards
            G.FUNCS.draw_from_deck_to_hand(cards_to_draw)
        end
    end,
}


----------------------------------------------
------------LAUNCH PAD CODE END----------------------

----------------------------------------------
------------DECOY GRENADE CODE BEGIN---------------------

SMODS.Sound({
	key = "decoy",
	path = "decoy.ogg",
})

SMODS.Consumable{
    key = 'LTMDecoy',
    set = 'LTMConsumableType',
    atlas = 'Jokers',
    pos = {x = 1, y = 5},
    loc_txt = {
        name = 'Decoy Grenade',
        text = {
            'Create {C:attention}#2#{} {C:dark_edition}Negative',
            'copies of {C:attention}#1#{} random cards from the deck',
        }
    },
    config = {
        extra = { cards = 3, copies = 1 },
    },
    loc_vars = function(self, info_queue, center)
        info_queue[#info_queue + 1] = G.P_CENTERS.e_negative
        if center and center.ability and center.ability.extra then
            return {vars = {center.ability.extra.cards, center.ability.extra.copies}} 
        end
        return {vars = {}}
    end,
    can_use = function(self, card)
        -- Only allow use when there are cards in hand
        return G and (#G.hand.cards > 0 and #G.deck.cards > 0)
    end,
    use = function(self, card, area, copier)
        if config.sfx ~= false then
            play_sound("fn_decoy")
        end

        -- Add an event to execute after a delay
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.1,
            func = function()
                local all_cards = G.deck.cards -- Get all cards in the deck
                if not all_cards or #all_cards == 0 then
                    return false -- Exit if the deck is empty
                end

                -- Shuffle the deck to randomize card selection
                math.randomseed(os.time()) -- Ensure random seed is set
                for i = #all_cards, 2, -1 do
                    local j = math.random(1, i)
                    all_cards[i], all_cards[j] = all_cards[j], all_cards[i]
                end

                -- Select 3 random cards from the deck (configurable in extra.cards)
                local selected_cards = {}
                for i = 1, math.min(#all_cards, card.ability.extra.cards) do
                    selected_cards[#selected_cards + 1] = all_cards[i]
                end

                -- Create negative copies of the selected cards
                local new_cards = {}
                for _, selected_card in ipairs(selected_cards) do
                    -- Create one copy of the selected card
                    local _card = copy_card(selected_card)

                    -- Make the card negative by setting the edition
                    _card:set_edition({negative = true}, true)
                    _card:add_to_deck()
                    G.deck.config.card_limit = G.deck.config.card_limit + 1
                    table.insert(G.playing_cards, _card)
                    G.hand:emplace(_card)

                    -- Start materializing the new card with visual feedback
                    _card:start_materialize(nil, nil)
                    new_cards[#new_cards + 1] = _card
                end

                -- Apply any additional effects
                playing_card_joker_effects(new_cards)
                return true
            end
        }))
    end,
}



----------------------------------------------
------------DECOY GRENADE CODE END----------------------

----------------------------------------------
------------LEFT HANDED DEATH CODE BEGIN----------------------

if config.deathcompat ~= false then
    SMODS.Consumable{
        key = 'LeftHandedDeath', -- key
        set = 'Tarot', -- the set of the card: corresponds to a consumable type
        atlas = 'Jokers', -- atlas
        pos = {x = 2, y = 5}, -- position in atlas
        loc_txt = {
            name = 'Death', -- name of card
            text = { -- text of card
                'Select {C:attention:}#1#{} cards',
                'Convert the {C:attention:}right{} card',
                'into the {C:attention} left{} card',
                '{C:inactive} [drag to rearrange]',
            },
        },
        config = {
            extra = { cards = 2 },
        },
        loc_vars = function(self, info_queue, center)
            if center and center.ability and center.ability.extra then
                return { vars = { center.ability.extra.cards } }
            end
            return { vars = {} }
        end,
        can_use = function(self, card)
            if G and G.hand and G.hand.highlighted and card.ability and card.ability.extra and card.ability.extra.cards then
                if #G.hand.highlighted > 0 and #G.hand.highlighted <= card.ability.extra.cards then
                    return true
                end
            end
            return false
        end,
        use = function(self)
            -- Check if highlighted cards exist
            if not G.hand.highlighted or #G.hand.highlighted == 0 then
                return false
            end

            -- Find the leftmost card
            local leftmost = G.hand.highlighted[1]
            for i = 1, #G.hand.highlighted do
                if G.hand.highlighted[i].T.x < leftmost.T.x then
                    leftmost = G.hand.highlighted[i]
                end
            end

            -- Convert all highlighted cards into the leftmost card
            for i = 1, #G.hand.highlighted do
                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    delay = 0.1,
                    func = function()
                        if G.hand.highlighted[i] ~= leftmost then
                            copy_card(leftmost, G.hand.highlighted[i])
                        end
                        return true
                    end
                }))
            end
            return true
        end,
    }
end


----------------------------------------------
------------LEFT HANDED DEATH CODE END----------------------

----------------------------------------------
------------POLYCHROME SPLASH CODE BEGIN----------------------

SMODS.Consumable{
    key = 'LTMPolychromeSplash',
    set = 'LTMConsumableType',
    atlas = 'Jokers',
    pos = {x = 4, y = 5},
    loc_txt = {
        name = 'Polychrome Splash',
        text = {
            'A dangerous organic living metal that consumes and replicates',
            'Responsible for nearly destroying a whole reality',
            'Converts {C:attention}#1#{} random thing into {C:dark_edition}polychrome',
			'50% chance to destroy it instead',
            '{C:inactive}You wouldn\'t open this... right?'
        },
    },
    config = {
        extra = { cards = 1 },
    },
    loc_vars = function(self, info_queue, center)
		info_queue[#info_queue + 1] = G.P_CENTERS.e_polychrome
        if center and center.ability and center.ability.extra then
            return { vars = { center.ability.extra.cards } }
        end
        return { vars = {} }
    end,
    can_use = function(self, card)
        return G and (#G.hand.cards > 0 or #G.jokers.cards > 0 or #G.consumeables.cards > 0)
    end,
    use = function(self, card, area, copier)
		if config.sfx ~= false then
			play_sound("glass1")
		end
        if not (G and card and card.ability and card.ability.extra) then
            print("Invalid game state or consumable configuration.")
            return
        end

        local maxCards = card.ability.extra.cards or 1
        local potentialTargets = {}

        -- Collect cards from hand
        if G.hand then
            for _, target in ipairs(G.hand.cards) do
                table.insert(potentialTargets, target)
            end
        end

        -- Collect Jokers
        if G.jokers then
            for _, target in ipairs(G.jokers.cards) do
                table.insert(potentialTargets, target)
            end
        end

        -- Collect Consumables
        if G.consumeables then
            for _, target in ipairs(G.consumeables.cards) do
                table.insert(potentialTargets, target)
            end
        end


        if #potentialTargets == 0 then
            print("No valid targets for Polychrome Splash.")
            return
        end

        -- Apply either Polychrome edition or dissolve with 50% chance
        local targetCount = math.min(#potentialTargets, maxCards)
        local selectedTargets = {}

        for i = 1, targetCount do
            local randomIndex = math.random(#potentialTargets)
            local target = potentialTargets[randomIndex]
            if math.random() > 0.5 then
                target:set_edition({polychrome = true}, true)
            else
				play_sound("slice1")
				play_sound("glass4")
                target:start_dissolve()  -- Initiates card dissolution
            end
            table.remove(potentialTargets, randomIndex)
        end
    end,
}

----------------------------------------------
------------POLYCHROME SPLASH CODE END----------------------

----------------------------------------------
------------CRYSTAL CODE BEGIN----------------------

if config.oldcalccompat ~= false then
    SMODS.Enhancement({
        loc_txt = {
            name = 'Crystal',
            text = {
                '{X:mult,C:white}X#1#{} Mult {C:chips}#2#{} Chips',
                'no rank or suit',
                '{C:green}#4# in #3#{} chance this',
                'card is {C:red}destroyed',
                'when triggered',
            },
        },
        key = "Crystal",
        atlas = "Jokers",
        pos = {x = 0, y = 6},
        discovered = false,
        no_rank = true,
        no_suit = true,
        replace_base_card = true,
        always_scores = true,
        config = {extra = {base_x = 1.5, chips = 50, odds = 6}},
        loc_vars = function(self, info_queue, card)
            local card_ability = card and card.ability or self.config
            return {
                vars = {
                    card_ability.extra.base_x,
                    card_ability.extra.chips,
                    card.ability.extra.odds,
                    G.GAME.probabilities.normal
                }
            }
        end,
        calculate = function(self, card, context, effect)
            if context.cardarea == G.play and not context.repetition then
                -- Apply the enhancement effects
                effect.x_mult = self.config.extra.base_x
                effect.chips = self.config.extra.chips

                -- Chance to shatter the card
                if pseudorandom('CrystalShatter') < G.GAME.probabilities.normal / card.ability.extra.odds then
                    -- Shatter the card
                    card:shatter()
                end
            end
        end
    })
end

if config.newcalccompat ~= false then
    Crystal = SMODS.Enhancement {
    object_type = "Enhancement",
    key = "Crystal",
    loc_txt = {
        name = "Crystal",
        text = { 
            "{X:mult,C:white}X#1#{} Mult {C:chips}#2#{} Chips",
            "no rank or suit",
            "{C:green}#4# in #3#{} chance this",
            "card is {C:red}destroyed",
            "when triggered"
        },
    },
    atlas = "Jokers",
    pos = { x = 0, y = 6 },
    no_rank = true,        -- No rank
    no_suit = true,        -- No suit
	replace_base_card = true,
    always_scores = true,  -- Always scores
    config = { 
        extra = {
            m_mult = 1.5,   -- Multiplier effect
            chips = 50,     -- Chip bonus
            odds = 6        -- Odds for shattering the card
        }
    },
    weight = 0,
    loc_vars = function(self, info_queue, card)
        return { 
            vars = { 
                card.ability.extra.m_mult, 
                card.ability.extra.chips, 
                card.ability.extra.odds, 
                G.GAME.probabilities.normal 
            }
        }
    end,
    calculate = function(self, card, context)
        if context.main_scoring and context.cardarea == G.play then
            -- Apply the multiplier and chip effects
            return {
                x_mult = card.ability.extra.m_mult,  -- Apply the multiplier
                chips = card.ability.extra.chips,   -- Apply the chips bonus
            }
        end
        if context.cardarea == G.play and context.final_scoring_step and not context.repetition then
            -- Chance to shatter the card
            if pseudorandom('CrystalShatter') < G.GAME.probabilities.normal / card.ability.extra.odds then
                -- Shatter the card
                card:shatter()
            end
        end
    end
}
end

----------------------------------------------
------------CRYSTAL CODE END----------------------

----------------------------------------------
------------RAINBOW CODE BEGIN----------------------
    SMODS.Consumable{
        key = 'LTMRainbow', -- key
        set = 'LTMConsumableType', -- the set of the card: corresponds to a consumable type
        atlas = 'Jokers', -- atlas
        pos = {x = 1, y = 6}, -- position in atlas
        loc_txt = {
            name = 'Rainbow Crystal', -- name of card
            text = { -- text of card
                'An ore never meant to exist',
                'yet somehow it does',
                'after {C:tarot}SOMEONE{} duped them endlessly',
                'Apply {C:inactive}Crystal{} and {C:dark_edition}Polychrome{} to up to {C:attention}#1#{} selected cards',
            }
        },
        config = {
            extra = {
                cards = 1, -- configurable value
            }
        },
        loc_vars = function(self, info_queue, center)
            info_queue[#info_queue + 1] = G.P_CENTERS.m_fn_Crystal vars = { 5 } 
            info_queue[#info_queue + 1] = G.P_CENTERS.e_polychrome
            if center and center.ability and center.ability.extra then
                return {vars = {center.ability.extra.cards}} 
            end
            return {vars = {}}
        end,
        can_use = function(self, card)
            if G and G.hand and G.hand.highlighted and card.ability and card.ability.extra and card.ability.extra.cards then
                if #G.hand.highlighted > 0 and #G.hand.highlighted <= card.ability.extra.cards then
                    return true
                end
            end
            return false
        end,
        use = function(self, card, area, copier)
            if G and G.hand and G.hand.highlighted then
                for i = 1, #G.hand.highlighted do
                    -- Set the edition to Crystal first
                    G.hand.highlighted[i]:set_ability(G.P_CENTERS.m_fn_Crystal, nil, true)
                    
                    -- Then apply the enhancement to Polychrome
                    local v = G.hand.highlighted[i]
                    v:set_edition({polychrome = true}, true)
                    
                    -- Add an event to juice up the card
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            v:juice_up()
                            return true
                        end
                    }))
                end
            end
        end,
    }


----------------------------------------------
------------RAINBOW CODE END----------------------

----------------------------------------------
------------WOOD CODE BEGIN----------------------
if config.oldcalccompat ~= false then
    SMODS.Enhancement({
        loc_txt = {
            name = 'Wood',
            text = {
                '{X:mult,C:white}X#1#{} Mult {C:chips}#2#{} Chips',
            },
        },
        key = "Wood",
        atlas = "Jokers",
        pos = {x = 3, y = 6},
        discovered = false,
        no_rank = false,
        no_suit = false,
        replace_base_card = false,
        always_scores = false,
        config = {extra = {base_x = 1.2, chips = 15,}},
        loc_vars = function(self, info_queue, card)
            local card_ability = card and card.ability or self.config
            return {
                vars = {
                    card_ability.extra.base_x,
                    card_ability.extra.chips,
                }
            }
        end,
        calculate = function(self, card, context, effect)
            if context.cardarea == G.play and not context.repetition then
                -- Apply the enhancement effects
                effect.x_mult = self.config.extra.base_x
                effect.chips = self.config.extra.chips
            end
        end
    })
end

if config.newcalccompat ~= false then
    Wood = SMODS.Enhancement {
    object_type = "Enhancement",
    key = "Wood",
    loc_txt = {
        name = "Wood",
        text = { "{X:mult,C:white}X#1#{} Mult {C:chips}#2#{} Chips" },
    },
    atlas = "Jokers",
    pos = { x = 3, y = 6 },
    config = { extra = { m_mult = 1.2, chips = 15 } },
    weight = 0,
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.m_mult, card.ability.extra.chips } }
    end,
    calculate = function(self, card, context)
        if context.main_scoring and context.cardarea == G.play then
            return {
                x_mult = card.ability.extra.m_mult,  -- Ensure Xmult is directly applied
                chips = card.ability.extra.chips,   -- Apply the chips bonus
            }
        end
    end
}
end
----------------------------------------------
------------WOOD CODE END----------------------

----------------------------------------------
------------BRICK CODE BEGIN----------------------

SMODS.Sound({
	key = "gnome",
	path = "gnome.ogg",
})

if config.oldcalccompat ~= false then
    SMODS.Enhancement({
        loc_txt = {
            name = 'Brick',
            text = {
                '{X:mult,C:white}X#1#{} Mult {C:chips}#2#{} Chips',
                '{C:green}#4# in #3#{} chance to',
                'summon a {C:red}Gnome',
            },
        },
        key = "Brick",
        atlas = "Jokers",
        pos = {x = 4, y = 6},
        discovered = false,
        no_rank = false,
        no_suit = false,
        replace_base_card = false,
        always_scores = false,
        config = {
            extra = {
                base_x = 1.3, -- Multiplier effect
                chips = 40,   -- Chip bonus
                odds = 100    -- Odds for gnome 
            },
        },
        loc_vars = function(self, info_queue, card)
            local card_ability = card and card.ability or self.config
            return {
                vars = {
                    card_ability.extra.base_x,           -- Multiplier
                    card_ability.extra.chips,           -- Chip bonus
                    card_ability.extra.odds,            -- Odds for gnome 
                    G.GAME.probabilities.normal         -- Base probability
                }
            }
        end,
        calculate = function(self, card, context, effect)
            if context.cardarea == G.play and not context.repetition then
                -- Apply the enhancement effects
                effect.x_mult = self.config.extra.base_x
                effect.chips = self.config.extra.chips
                
                -- Chance to summon a gnome
                if pseudorandom('Gnome') < G.GAME.probabilities.normal / card.ability.extra.odds then
                    card.brick_trigger = true
                    G.E_MANAGER:add_event(Event({
                        func = function() 
                            local c = create_card(
                                nil, G.consumeables, nil, nil, nil, nil, 'c_fn_LTMGnome', 'sup'
                            )
                            c:add_to_deck()
                            G.consumeables:emplace(c)
                            if config.sfx ~= false then
                                play_sound("fn_gnome")
                            end
                            return true
                        end
                    }))
                else
                    card.brick_trigger = false
                end
            end
        end,
    })
end

if config.newcalccompat ~= false then
    Brick = SMODS.Enhancement {
        object_type = "Enhancement",
        key = "Brick",
        loc_txt = {
            name = "Brick",
            text = { 
                "{X:mult,C:white}X#1#{} Mult {C:chips}#2#{} Chips",
                "{C:green}#4# in #3#{} chance to",
                "summon a {C:red}Gnome"
            },
        },
        atlas = "Jokers",
        pos = { x = 4, y = 6 },
        config = { 
            extra = {
                m_mult = 1.3,   -- Multiplier effect
                chips = 40,     -- Chip bonus
                odds = 100      -- Odds for gnome 
            }
        },
        weight = 0,
        loc_vars = function(self, info_queue, card)
            return { 
                vars = { 
                    card.ability.extra.m_mult, 
                    card.ability.extra.chips, 
                    card.ability.extra.odds, 
                    G.GAME.probabilities.normal 
                }
            }
        end,
        calculate = function(self, card, context)
            if context.main_scoring and context.cardarea == G.play then
                -- Check for gnome spawn BEFORE return
                if pseudorandom('Gnome') < G.GAME.probabilities.normal / card.ability.extra.odds then
                    card.brick_trigger = true
                    G.E_MANAGER:add_event(Event({
                        func = function() 
                            local c = create_card(
                                nil, G.consumeables, nil, nil, nil, nil, 'c_fn_LTMGnome', 'sup'
                            )
                            c:add_to_deck()
                            G.consumeables:emplace(c)
                            if config.sfx ~= false then
                                play_sound("fn_gnome")
                            end
                            return true
                        end
                    }))
                else
                    card.brick_trigger = false
                end
                -- Now return the actual stat boost
                return {
                    x_mult = card.ability.extra.m_mult,
                    chips = card.ability.extra.chips
                }
            end
        end
    }
end


----------------------------------------------
------------BRICK CODE END----------------------

----------------------------------------------
------------GNOME CODE BEGIN----------------------

SMODS.Consumable{
    key = 'LTMGnome', -- key
    set = 'LTMConsumableType', -- the set of the card: corresponds to a consumable type
    atlas = 'Jokers', -- atlas
    pos = {x = 0, y = 7}, -- position in atlas
    loc_txt = {
        name = 'Gnome', -- name of card
        text = { -- text of card
            'Has a {C:green,E:1,S:1.1}#1# in #2#{} chance to',
			'give an {C:fn_eternal}Eternal{} copy of {C:tarot}Eric{}, {C:mult}Crac{}, {C:tarot}Emily{}, or {C:green,E:1,S:1.1}Zorlodo{}',
			'else give {C:red}nothing{}',
        },
    },
    config = {
        extra = { odds = 8 }, -- Configuration: odds of success (set to 2 for 50% chance)
        no_pool_flag = 'gamble',
    },
    loc_vars = function(self, info_queue, card)
		info_queue[#info_queue+1] = {key = 'eternal', set = 'Other'}
        return {vars = {G.GAME.probabilities.normal, card.ability.extra.odds}}
    end,
    use = function(self, card, area, copier)
        G.GAME.pool_flags.gamble = true -- Ensure 'gamble' flag is set
		if config.sfx ~= false then
			play_sound("fn_gnome")
		end

        -- Use the game's internal roll value (assuming it's already handled)
        if pseudorandom('FriendsGamble') < G.GAME.probabilities.normal / card.ability.extra.odds then
            -- List of possible jokers
            local jokers = {'j_fn_Crac', 'j_fn_Eric', 'j_fn_Emily', 'j_fn_Zorlodo'}

            -- Randomly select one joker to add
            local selected_joker = jokers[math.random(#jokers)]
            joker_add(selected_joker)

            -- Display success message on the consumable
			if config.sfx ~= false then
				play_sound("fn_happy")
			end
            card_eval_status_text(card, 'extra', nil, nil, nil, {
                message = "Friends!", -- Display "Friends!" message
                colour = G.C.PURPLE,
            })
        else
            -- Failure: No joker granted
            -- Display failure message on the consumable
			if config.sfx ~= false then
				play_sound("fn_sad")
			end
            card_eval_status_text(card, 'extra', nil, nil, nil, {
				message = "NOTHING!",
                colour = G.C.RED,
            })
        end
    end,
    can_use = function(self, card)
        return true
    end,
}
----------------------------------------------
------------GNOME CODE END----------------------

----------------------------------------------
------------METAL CODE BEGIN----------------------
if config.oldcalccompat ~= false then
    SMODS.Enhancement({
        loc_txt = {
            name = 'Metal',
            text = {
                '{X:mult,C:white}X#1#{} Mult {C:chips}#2#{} Chips',
            },
        },
        key = "Metal",
        atlas = "Jokers",
        pos = {x = 1, y = 7},
        discovered = false,
        no_rank = false,
        no_suit = false,
        replace_base_card = false,
        always_scores = false,
        config = {extra = {base_x = 1.5, chips = 60,}},
        loc_vars = function(self, info_queue, card)
            local card_ability = card and card.ability or self.config
            return {
                vars = {
                    card_ability.extra.base_x,
                    card_ability.extra.chips,
                }
            }
        end,
        calculate = function(self, card, context, effect)
            if context.cardarea == G.play and not context.repetition then
                -- Apply the enhancement effects
                effect.x_mult = self.config.extra.base_x
                effect.chips = self.config.extra.chips
            end
        end
    })
end

if config.newcalccompat ~= false then
    Metal = SMODS.Enhancement {
    object_type = "Enhancement",
    key = "Metal",
    loc_txt = {
        name = "Metal",
        text = { "{X:mult,C:white}X#1#{} Mult {C:chips}#2#{} Chips" },
    },
    atlas = "Jokers",
    pos = { x = 1, y = 7 },
    config = { extra = { m_mult = 1.5, chips = 60 } },
    weight = 0,
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.m_mult, card.ability.extra.chips } }
    end,
    calculate = function(self, card, context)
        if context.main_scoring and context.cardarea == G.play then
            return {
                x_mult = card.ability.extra.m_mult,  -- Apply the multiplier
                chips = card.ability.extra.chips,   -- Apply the chips bonus
            }
        end
    end
}
end



----------------------------------------------
------------METAL CODE END----------------------

----------------------------------------------
------------STORM SURGE CODE BEGIN----------------------

if config.oldcalccompat ~= false then
    SMODS.Enhancement({
        loc_txt = {
            name = "Storm Surge",
            text = {
                "Gains {C:mult}+#1#{} Mult and {C:chips}+#2#{} Chips per {C:attention}Ante{}",
                "{C:inactive}Currently {C:mult}+#3#{} {C:inactive}Mult {C:chips}+#4#{} {C:inactive}Chips"
            },
        },
        key = "StormSurge",
        atlas = "Jokers",
        pos = { x = 4, y = 14 },
        discovered = false,
        no_rank = false,
        no_suit = false,
        replace_base_card = false,
        always_scores = false,
        config = { extra = { mult = 10, chips = 100 } }, -- Removed scaled values, since they should be dynamic
        loc_vars = function(self, info_queue, card)
            local ante_count = G.GAME.round_resets.ante
            local card_ability = card and card.ability or self.config
            local scaled_mult = card_ability.extra.mult * ante_count
            local scaled_chips = card_ability.extra.chips * ante_count
            return {
                vars = {
                    card_ability.extra.mult,
                    card_ability.extra.chips,
                    scaled_mult,
                    scaled_chips
                }
            }
        end,
        calculate = function(self, card, context, effect)
            if context.cardarea == G.play and not context.repetition then
                local ante_count = G.GAME.round_resets.ante
                effect.mult = self.config.extra.mult * ante_count
                effect.chips = self.config.extra.chips * ante_count
            end
        end
    })
end


if config.newcalccompat ~= false then
    Storm = SMODS.Enhancement {
        object_type = "Enhancement",
        key = "StormSurge",
        loc_txt = {
            name = "Storm Surge",
            text = {
                "Gains {C:mult}+#1#{} Mult and {C:chips}+#2#{} Chips per {C:attention}Ante{}",
                "{C:inactive}Currently {C:mult}+#3#{} {C:inactive}Mult {C:chips}+#4#{} {C:inactive}Chips"
            },
        },
        atlas = "Jokers",
        pos = { x = 4, y = 14 },
        config = { extra = { mult = 10, chips = 100 } },
        weight = 0,
        loc_vars = function(self, info_queue, card)
            local ante_count = G.GAME.round_resets.ante
            local scaled_mult = card.ability.extra.mult * ante_count
            local scaled_chips = card.ability.extra.chips * ante_count
            return {
                vars = {
                    card.ability.extra.mult,
                    card.ability.extra.chips,
                    scaled_mult,
                    scaled_chips
                }
            }
        end,
        calculate = function(self, card, context)
            if context.main_scoring and context.cardarea == G.play then
                local ante_count = G.GAME.round_resets.ante
                return {
                    mult = card.ability.extra.mult * ante_count,  -- Apply the multiplier
                    chips = card.ability.extra.chips * ante_count,  -- Apply the chips bonus
                }
            end
        end
    }
end

----------------------------------------------
------------STORM SURGE CODE END----------------------

----------------------------------------------
------------LEGENDARY CODE BEGIN----------------------

if config.oldcalccompat ~= false then
    SMODS.Enhancement({
        loc_txt = {
            name = "Legendary",
            text = {
                "Gains +{X:mult,C:white}X#2#{} Mult when {C:attention}Scored{}",
                "{C:inactive}Currently {X:mult,C:white}X#1#{} {C:inactive}Mult",
                "Idea: BoiRowan",
            },
        },
        key = "Legendary",
        atlas = "Jokers",
        pos = { x = 0, y = 16 },
        discovered = false,
        no_rank = false,
        no_suit = false,
        replace_base_card = false,
        always_scores = false,
        config = { extra = { x_mult = 1, change = 0.4 } },
        
        loc_vars = function(self, info_queue, card)
            local card_ability = card and card.ability or self.config
            return {
                vars = { 
                    card_ability.extra.x_mult, 
                    card_ability.extra.change 
                }
            }
        end,
        
        calculate = function(self, card, context, effect)
            if context.cardarea == G.play and not context.repetition then
                effect.x_mult = card.ability.extra.x_mult
                card.ability.extra.x_mult = card.ability.extra.x_mult + card.ability.extra.change
            end
        end
    })
end

if config.newcalccompat ~= false then
    Legendary = SMODS.Enhancement {
        object_type = "Enhancement",
        key = "Legendary",
        loc_txt = {
            name = "Legendary",
            text = {
                "Gains +{X:mult,C:white}X#2#{} Mult when {C:attention}Scored{}",
                "{C:inactive}Currently {X:mult,C:white}X#1#{} {C:inactive}Mult",
                "Idea: BoiRowan",
            },
        },
        atlas = "Jokers",
        pos = { x = 0, y = 16 },
        config = { extra = { x_mult = 1, change = 0.4 } },
        weight = 0,

        loc_vars = function(self, info_queue, card)
            return {
                vars = { 
                    card.ability.extra.x_mult, 
                    card.ability.extra.change 
                }
            }
        end,

        calculate = function(self, card, context)
            if context.main_scoring and context.cardarea == G.play then
                local current_x_mult = card.ability.extra.x_mult
                card.ability.extra.x_mult = current_x_mult + card.ability.extra.change
                return { x_mult = current_x_mult }
            end
        end
    }
end


----------------------------------------------
------------LEGENDARY CODE END----------------------

----------------------------------------------
------------CUBIC CODE BEGIN----------------------

if config.oldcalccompat ~= false then
    SMODS.Enhancement({
        loc_txt = {
            name = "Cubic",
            text = {
                "{X:chips,C:white}X#1#{} Chips {X:mult,C:white}X#2#{} Mult",
                "Idea: BoiRowan",
            },
        },
        key = "Cubic",
        atlas = "Jokers",
        pos = { x = 1, y = 17 },
        discovered = false,
        no_rank = false,
        no_suit = false,
        replace_base_card = false,
        always_scores = false,
        config = { extra = { x_chips = 3, x_mult = 0.6 } },

        loc_vars = function(self, info_queue, card)
            return {
                vars = { 
                    card and card.ability.extra.x_chips or self.config.extra.x_chips, 
                    card and card.ability.extra.x_mult or self.config.extra.x_mult
                }
            }
        end,

        calculate = function(self, card, context, effect)
            if context.cardarea == G.play and not context.repetition then
                effect.x_chips = card.ability.extra.x_chips
                effect.x_mult = card.ability.extra.x_mult
            end
        end
    })
end


if config.newcalccompat ~= false then
    Cubic = SMODS.Enhancement({
        object_type = "Enhancement",
        key = "Cubic",
        loc_txt = {
            name = "Cubic",
            text = {
                "{X:chips,C:white}X#1#{} Chips {X:mult,C:white}X#2#{} Mult",
                "Idea: BoiRowan",
            },
        },
        atlas = "Jokers",
        pos = { x = 1, y = 17 },
        config = { extra = { x_chips = 3, x_mult = 0.6 } },
        weight = 0,

        loc_vars = function(self, info_queue, card)
            return {
                vars = { 
                    card.ability.extra.x_chips, 
                    card.ability.extra.x_mult 
                }
            }
        end,

        calculate = function(self, card, context)
            if context.main_scoring and context.cardarea == G.play then
                return {
                    x_chips = card.ability.extra.x_chips,
                    x_mult = card.ability.extra.x_mult
                }
            end
        end
    })
end


----------------------------------------------
------------CUBIC CODE END----------------------

----------------------------------------------
------------SHELL AMMO CODE BEGIN---------------------

if config.newcalccompat ~= false then
    SMODS.Enhancement({
        loc_txt = {
            name = 'Shell Ammo',
            text = {
                '{X:mult,C:white}X#1#{} Mult',
                'Retriggers once per {C:chips}Hand{} used this round',
                'Idea: BoiRowan',
            },
        },
        key = "Shell",
        atlas = "Jokers",
        pos = {x = 3, y = 26},
        discovered = false,
        no_rank = false,
        no_suit = false,
        replace_base_card = false,
        always_scores = false,
        config = {
            extra = {
                x_mult = 1.2,
                retriggers = 0,
            }
        },

        loc_vars = function(self, info_queue, card)
            return {
                vars = {
                    card.ability.extra.x_mult,
                    card.ability.extra.retriggers,
                }
            }
        end,

        calculate = function(self, card, context)
            if context.repetition and context.cardarea == G.play then
				card.ability.extra.retriggers =  G.GAME.round_resets.hands - G.GAME.current_round.hands_left + 1
                return {
                    repetitions = card.ability.extra.retriggers,
					x_mult = card.ability.extra.x_mult,
                }
            end
        end
    })
end

----------------------------------------------
------------SHELL AMMO CODE END----------------------

----------------------------------------------
------------HEAVY AMMO CODE BEGIN----------------------

if config.newcalccompat ~= false then
    SMODS.Enhancement({
        loc_txt = {
            name = 'Heavy Ammo',
            text = {
                '{C:mult}+#1#{} Mult',
                'Retriggers once per remaining {C:chips}Hand{}',
                'Idea: BoiRowan',
            },
        },
        key = "Heavy",
        atlas = "Jokers",
        pos = {x = 4, y = 26},
        discovered = false,
        no_rank = false,
        no_suit = false,
        replace_base_card = false,
        always_scores = false,
        config = {
            extra = {
                mult = 10,
                retriggers = 0,
            }
        },

        loc_vars = function(self, info_queue, card)
            return {
                vars = {
                    card.ability.extra.mult,
                    card.ability.extra.retriggers,
                }
            }
        end,

        calculate = function(self, card, context)
            if context.repetition and context.cardarea == G.play then
				card.ability.extra.retriggers =  G.GAME.current_round.hands_left + 1
                return {
					mult = card.ability.extra.mult,
                    repetitions = card.ability.extra.retriggers,
                }
            end
        end
    })
end

----------------------------------------------
------------HEAVY AMMO CODE END----------------------

----------------------------------------------
------------LIGHT AMMO CODE BEGIN----------------------

if config.newcalccompat ~= false then
    SMODS.Enhancement({
        loc_txt = {
            name = 'Light Ammo',
            text = {
                '{C:chips}+#1#{} Chips',
                'Retriggers once per {C:mult}Discard{} used this round',
                'Idea: BoiRowan',
            },
        },
        key = "Light",
        atlas = "Jokers",
        pos = {x = 0, y = 27},
        discovered = false,
        no_rank = false,
        no_suit = false,
        replace_base_card = false,
        always_scores = false,
        config = {
            extra = {
                chips = 75,
                retriggers = 0,
            }
        },

        loc_vars = function(self, info_queue, card)
            return {
                vars = {
                    card.ability.extra.chips,
                    card.ability.extra.retriggers,
                }
            }
        end,

        calculate = function(self, card, context)
            if context.repetition and context.cardarea == G.play then
				card.ability.extra.retriggers =  G.GAME.current_round.discards_used + 1
                return {
					chips = card.ability.extra.chips,
                    repetitions = card.ability.extra.retriggers,
                }
            end
        end
    })
end

----------------------------------------------
------------LIGHT AMMO CODE END----------------------

----------------------------------------------
------------MEDIUM AMMO CODE BEGIN----------------------

if config.newcalccompat ~= false then
    SMODS.Enhancement({
        loc_txt = {
            name = 'Medium Ammo',
            text = {
                '{X:chips,C:white}X#1#{} Chips',
                'Retriggers once per remaining {C:mult}Discard{}',
                'Idea: BoiRowan',
            },
        },
        key = "Medium",
        atlas = "Jokers",
        pos = {x = 1, y = 27},
        discovered = false,
        no_rank = false,
        no_suit = false,
        replace_base_card = false,
        always_scores = false,
        config = {
            extra = {
                x_chips = 1.1,
                retriggers = 0,
            }
        },

        loc_vars = function(self, info_queue, card)
            return {
                vars = {
                    card.ability.extra.x_chips,
                    card.ability.extra.retriggers,
                }
            }
        end,

        calculate = function(self, card, context)
            if context.repetition and context.cardarea == G.play then
				card.ability.extra.retriggers = G.GAME.current_round.discards_left + 1
                return {
					x_chips = card.ability.extra.x_chips,
                    repetitions = card.ability.extra.retriggers,
                }
            end
        end
    })
end

----------------------------------------------
------------MEDIUM AMMO CODE END----------------------

----------------------------------------------
------------ROCKET AMMO CODE BEGIN----------------------

if config.newcalccompat ~= false then
    SMODS.Enhancement({
        loc_txt = {
            name = 'Rocket Ammo',
            text = {
                'Retrigger {C:attention}#1#{} times',
                'Gain {C:attention}+#2#{} retriggers at end of round if held in hand',
                'Idea: BoiRowan',
            },
        },
        key = "Rocket",
        atlas = "Jokers",
        pos = {x = 2, y = 27},
        discovered = false,
        no_rank = false,
        no_suit = false,
        replace_base_card = false,
        always_scores = false,
        config = {
            extra = {
                retriggers = 1,
                add = 0.5,
            }
        },

        loc_vars = function(self, info_queue, card)
            return {
                vars = {
                    card.ability.extra.retriggers,
                    card.ability.extra.add * 2,
                }
            }
        end,

        calculate = function(self, card, context)
            -- Apply retriggers during play
            if context.repetition and context.cardarea == G.play then
                return {
                    repetitions = card.ability.extra.retriggers,
                }
            end

            -- Permanently increase retriggers at end of round if in hand
            if context.end_of_round and not context.repetition and not context.individual then
                if card.area == G.hand then
                    card.ability.extra.retriggers = card.ability.extra.retriggers + card.ability.extra.add
					return {
                            message = localize('k_upgrade_ex'),
                            colour = G.C.Mult,
                            card = card
                    }
                end
            end
        end,
    })
end

----------------------------------------------
------------ROCKET AMMO CODE END----------------------

----------------------------------------------
------------LEGO CODE BEGIN----------------------

if config.newcalccompat ~= false then
    SMODS.Enhancement({
        loc_txt = {
            name = 'Lego',
            text = {
                'Lose {C:money}$#1#{} and create a copy of this card when played',
                'Idea: {C:inactive}kxttyfrickfish{}',
            },
        },
        key = "Lego",
        atlas = "Jokers",
        pos = {x = 2, y = 39},
        discovered = false,
        no_rank = false,
        no_suit = false,
        replace_base_card = false,
        always_scores = false,
        config = {
            extra = {
                dollars = 3
            }
        },

        loc_vars = function(self, info_queue, card)
            return {
                vars = {
                    (card and card.ability.extra and card.ability.extra.dollars) or 3
                }
            }
        end,

        calculate = function(self, card, context)
            if context.main_scoring and context.cardarea == G.play then
                -- Lose money
                ease_dollars(-card.ability.extra.dollars)

                -- Duplicate the card after a short delay
                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    delay = 0.1,
                    func = function()
                        local copy = copy_card(card)
						G.deck:emplace(copy)
                        copy:add_to_deck()
                        table.insert(G.playing_cards, copy)
                        copy:start_materialize(nil, nil)

                        -- Optional: give copy a random suit
                        -- local suits = {"Hearts", "Diamonds", "Clubs", "Spades"}
                        -- SMODS.change_base(copy, suits[math.random(#suits)])

                        return true
                    end
                }))
            end
        end,
    })
end

----------------------------------------------
------------LEGO CODE END----------------------

----------------------------------------------
------------CREATOR CODE BEGIN----------------------

if config.newcalccompat ~= false then
    SMODS.Enhancement({
        loc_txt = {
            name = 'Creator Code',
            text = {
                'Retrigger {C:attention}#1#{} times',
                '{C:green}#3# in #2#{} chance to spread to the {C:attention}right{} card',
                '{C:inactive}Chance decreases for every successful activation',
                'Idea: Your Average User',
            },
        },
        key = "Creator",
        atlas = "Jokers",
        pos = {x = 2, y = 41},
        discovered = false,
        no_rank = false,
        no_suit = false,
        replace_base_card = false,
        always_scores = false,
        config = {
            extra = {
                retriggers = 1,
                odds = 5,
                odds_subtract = 1,
            }
        },

        loc_vars = function(self, info_queue, card)
            return {
                vars = {
                    card.ability.extra.retriggers or 1,
                    card.ability.extra.odds or 5,
                    G.GAME.probabilities.normal
                }
            }
        end,

        calculate = function(self, card, context)
            if context.cardarea == G.play and context.main_scoring then
                local idx
                for i, v in ipairs(context.scoring_hand) do
                    if v == card then
                        idx = i
                        break
                    end
                end
                if not idx then return end

                -- Attempt to spread to the card on the right
                if pseudorandom('Creator') < G.GAME.probabilities.normal/card.ability.extra.odds then
                    local right_card = context.scoring_hand[idx + 1]
                    if right_card and right_card.ability and right_card.set_ability then
						card.ability.extra.odds = card.ability.extra.odds + card.ability.extra.odds_subtract
                        right_card:set_ability(G.P_CENTERS.m_fn_Creator, nil, true)
                        right_card.ability.extra.retriggers = card.ability.extra.retriggers
                        right_card.ability.extra.odds = card.ability.extra.odds 
                    end
                end
			end
			
			if context.repetition and context.cardarea == G.play then
                return {
                    repetitions = card.ability.extra.retriggers,
                }
            end
        end,
    })
end

----------------------------------------------
------------CREATOR CODE END----------------------

----------------------------------------------
------------XP BOOST CODE BEGIN----------------------
SMODS.Sound({
	key = "xp",
	path = "xp.ogg",
})

if config.newcalccompat ~= false then
    SMODS.Enhancement({
        loc_txt = {
            name = 'Xp Boost',
            text = {
                '{X:mult,C:white}X#1#{} the base {C:chips}Chips{} and {C:mult}Mult{}',
                'of played {C:attention}poker hand{} when {C:attention}held{} in hand',
                'Idea: BoiRowan',
            },
        },
        key = "Xp",
        atlas = "Jokers",
        pos = {x = 2, y = 44},
        discovered = false,
        no_rank = false,
        no_suit = false,
        replace_base_card = false,
        always_scores = false,
        config = {
            extra = {
                level_up = 2,
				scored = 0
            }
        },

        loc_vars = function(self, info_queue, card)
            return {
                vars = {
                    card.ability.extra.level_up,
                }
            }
        end,

        calculate = function(self, card, context)
            if context.before and card.area == G.hand and not context.individual then
				card.ability.extra.scored = 1
                G.GAME.hands[context.scoring_name].mult = G.GAME.hands[context.scoring_name].mult * card.ability.extra.level_up
				G.GAME.hands[context.scoring_name].chips = G.GAME.hands[context.scoring_name].chips * card.ability.extra.level_up
				if config.sfx ~= false then
					return {
						message = "XP BOOSTED!",
						colour = G.C.PURPLE,
						sound = 'fn_xp',
						card = card,
					}
				else
					return {
						message = "XP BOOSTED!",
						colour = G.C.PURPLE,
						card = card,
					}
				end
            end
			
			if context.final_scoring_step and card.ability.extra.scored == 1 then 
				card.ability.extra.scored = 0
				G.GAME.hands[context.scoring_name].mult = G.GAME.hands[context.scoring_name].mult / card.ability.extra.level_up
				G.GAME.hands[context.scoring_name].chips = G.GAME.hands[context.scoring_name].chips / card.ability.extra.level_up
            end
        end,
    })
end

----------------------------------------------
------------XP BOOST CODE END----------------------

----------------------------------------------
------------NITRO CODE BEGIN----------------------

SMODS.Shader({key = 'nitro', path = "nitro.fs"})

SMODS.Edition({
    key = "Nitro",
    loc_txt = {
        name = "Nitro",
        text = {
            "{C:attention}+#1#{} hand size",
			"{C:attention}Resets{} at end of round",
			"Idea: BoiRowan",
        },
    },
    discovered = false,
    unlocked = true,
    shader = 'nitro',
    config = { handsize = 1 }, -- triggers twice, so actual gain is double
    in_shop = true,
    weight = 15,
    extra_cost = 4,
	badge_colour = HEX("ea763e"),
    apply_to_float = true,
	
    loc_vars = function(self, info_queue, card)
        return { vars = { self.config.handsize * 2 } }
    end,
	
    calculate = function(self, card, context)
        self.added = self.added or 0

        -- Played and scored cards get the buff
        if context.main_scoring and context.cardarea == G.play and not context.individual then
            G.hand.config.card_limit = G.hand.config.card_limit + self.config.handsize
            self.added = self.added + self.config.handsize
        end

        -- If it's a Joker with the edition, buff hand size at start of round (setting blind)
        if context.setting_blind and card.ability.set == 'Joker' and not (context.blueprint_card or self).getting_sliced then
            G.hand.config.card_limit = G.hand.config.card_limit + self.config.handsize * 2
            self.added = self.added + self.config.handsize * 2
        end

        -- Remove the buff at end of round
        if context.end_of_round and not context.repetition and not context.individual then
            if self.added > 0 then
                G.hand.config.card_limit = G.hand.config.card_limit - self.added
                self.added = 0
            end
        end
    end
})

----------------------------------------------
------------NITRO CODE END----------------------

----------------------------------------------
------------SHOCKWAVED CODE END----------------------

SMODS.Shader({key = 'shockwaved', path = "shockwaved.fs"})

SMODS.Edition({
    key = "Shockwaved",
    loc_txt = {
        name = "Shockwaved",
        text = {
            "{C:green}#1# in 3{} chance to retrigger adjacent {C:attention}Jokers{}",
            "Retriggers adjacent played cards once",
            "Idea: BoiRowan",
        },
    },
    discovered = false,
    unlocked = true,
    shader = 'shockwaved',
    in_shop = true,
    weight = 0.5,
    extra_cost = 4,
    badge_colour = HEX("4e4bc3"),
    apply_to_float = true,

    loc_vars = function(self, info_queue, card)
        return {
            vars = { G.GAME.probabilities.normal }
        }
    end,

    calculate = function(self, card, context)
        -- Played card retriggers adjacent cards (excluding other Shockwaved cards)
        if context.repetition and context.cardarea == G.play then
            local idx
            for i, v in ipairs(context.scoring_hand) do
                if v == card then
                    idx = i
                    break
                end
            end
            if not idx then return end

            local results = {}

            local function add_result(adj_card)
                if not adj_card then return end
                if adj_card.edition and adj_card.edition.key == "e_fn_Shockwaved" then return end

                results[#results+1] = card_eval_status_text(adj_card, 'extra', nil, nil, nil, {
                    message = 'Again!',
                    colour = G.C.SECONDARY_SET.Tarot,
                })
                results[#results+1] = SMODS.score_card(adj_card, {
                    cardarea = G.play,
                    full_hand = context.full_hand,
                    scoring_hand = context.scoring_hand,
                    scoring_name = context.scoring_name,
                    poker_hands = context.poker_hands
                })
            end

            add_result(context.scoring_hand[idx - 1])
            add_result(context.scoring_hand[idx + 1])

            if #results > 0 then return results end
        end

        -- Joker retrigger logic (1 in 3 chance for adjacent Jokers)
        if context.retrigger_joker_check and not context.retrigger_joker and context.other_card then
            local idx
            for i, v in ipairs(G.jokers.cards) do
                if v == card then
                    idx = i
                    break
                end
            end
            if not idx then return end

            local left = G.jokers.cards[idx > 1 and idx - 1 or nil]
            local right = G.jokers.cards[idx < #G.jokers.cards and idx + 1 or nil]

            if context.other_card == left or context.other_card == right then
                if pseudorandom('shockwaved') < G.GAME.probabilities.normal / 3 then
                    return {
                        message = localize('k_again_ex'),
                        colour = G.C.SECONDARY_SET.Tarot,
                        repetitions = 1,
                        card = card
                    }
                end
            end
        end
    end,
})

----------------------------------------------
------------SHOCKWAVED CODE END----------------------

----------------------------------------------
------------MYTHIC CODE BEGIN----------------------

SMODS.Shader({key = 'mythic', path = "mythic.fs"})

SMODS.Edition({
    key = "Mythic",
    loc_txt = {
        name = "Mythic",
        text = {
            "{X:mult,C:white}X4{} to all values on this card",
			"{C:attention}-1{} Slot / {C:attention}-2{} hand size",
            "Idea: BoiRowan",
        },
    },
    discovered = false,
    unlocked = true,
    shader = 'mythic',
	config = { in_hand = 0 },
    in_shop = true,
    weight = 0.2,
    extra_cost = 4,
    badge_colour = HEX("e9c339"),
    apply_to_float = true,
    
    on_apply = function(card)
        -- Check if the card is a Joker and adjust slot limit
        if card.ability.set == 'Joker' then
            G.jokers.config.card_limit = G.jokers.config.card_limit - 1
        elseif card.ability.consumeable then
            -- Check if the card is a Consumable and adjust slot limit
            G.consumeables.config.card_limit = G.consumeables.config.card_limit - 1
        else
            -- If not a Joker or Consumable, grant a permanent chip bonus
            if card.base and card.base.value then
                local rank_value = SMODS.Ranks[card.base.value] and SMODS.Ranks[card.base.value].nominal or card.base.value
                card.ability.perma_bonus = (card.ability.perma_bonus or 0) + (rank_value * 3)
				G.hand.config.card_limit = G.hand.config.card_limit - 2
                card:juice_up()
            end
        end
        
        -- Apply Mythic enhancements to values in extra
        if card.ability and card.ability.extra then
            for key, value in pairs(card.ability.extra) do
                if type(value) == "number" then
                    card.ability.extra[key] = value * 4
                end
            end
        end
    end,
    
    on_remove = function(card)
        -- Revert the effect of Mythic enhancements
        if card.ability and card.ability.extra then
            for key, value in pairs(card.ability.extra) do
                if type(value) == "number" then
                    card.ability.extra[key] = value / 4
                end
            end
        end

        -- Restore Joker slot if it was a Joker
        if card.ability.set == 'Joker' then
            G.jokers.config.card_limit = G.jokers.config.card_limit + 1
        elseif card.ability.consumeable then
            -- Restore Consumable slot if it was a Consumable
            G.consumeables.config.card_limit = G.consumeables.config.card_limit + 1
        else
            -- Remove the chip bonus if it was applied
            if card.base and card.base.value then
                local rank_value = SMODS.Ranks[card.base.value] and SMODS.Ranks[card.base.value].nominal or card.base.value
                card.ability.perma_bonus = (card.ability.perma_bonus or 0) - (rank_value * 3)
				G.hand.config.card_limit = G.hand.config.card_limit + 2
                card:juice_up()
            end
        end
    end,
	
	
	calculate = function(self, card, context)
		if context.selling_self and card.ability.set == 'Joker' then
			G.jokers.config.card_limit = G.jokers.config.card_limit + 1
		end
		
		if context.selling_self and card.ability.consumeable then
			G.consumeables.config.card_limit = G.consumeables.config.card_limit + 1
		end
		
		if card.area == G.hand and self.config.in_hand == 0 then
			self.config.in_hand = 1
		end
		
		if card.area == G.play and context.main_scoring or card.area == G.discard and self.config.in_hand == 1 or card.area == G.deck and self.config.in_hand == 1 or card.area == G.deck or context.ending_shop and self.config.in_hand == 1 then
			self.config.in_hand = 0
			G.hand.config.card_limit = G.hand.config.card_limit + 2
		end
		
		if context.end_of_round and self.config.in_hand == 1 then
			self.config.in_hand = 0
			G.hand.config.card_limit = G.hand.config.card_limit + 2
		end
		
		-- check if removed
		if context.remove_playing_cards then
			if card.edition and card.edition.fn_Mythic and self.config.in_hand == 1 then
				G.hand.config.card_limit = G.hand.config.card_limit + 2
			end
		end
    end
})

----------------------------------------------
------------MYTHIC CODE END----------------------

----------------------------------------------
------------BLUEPRINT CODE BEGIN----------------------

SMODS.Sound({
	key = "wood",
	path = "wood.ogg",
})
SMODS.Sound({
	key = "brick",
	path = "brick.ogg",
})
SMODS.Sound({
	key = "metal",
	path = "metal.ogg",
})

    SMODS.Consumable{
        key = 'LTMBlueprint', -- key
        set = 'LTMConsumableType', -- the set of the card: corresponds to a consumable type
        atlas = 'Jokers', -- atlas
        pos = {x = 2, y = 7}, -- position in atlas
        loc_txt = {
            name = 'Blueprint', -- name of card
            text = { -- text of card
                'Enhances {C:attention}#1#{} selected cards',
                'into {C:money}Wood{}, {C:mult}Brick{}, or {C:inactive}Metal{}',
            }
        },
        config = {
            extra = {
                cards = 5, -- configurable value
            }
        },
        loc_vars = function(self, info_queue, center)
            info_queue[#info_queue + 1] = G.P_CENTERS.m_fn_Wood
            info_queue[#info_queue + 1] = G.P_CENTERS.m_fn_Brick
            info_queue[#info_queue + 1] = G.P_CENTERS.m_fn_Metal
            if center and center.ability and center.ability.extra then
                return {vars = {center.ability.extra.cards}} 
            end
            return {vars = {}}
        end,
        can_use = function(self, card)
            if G and G.hand and G.hand.highlighted and card.ability and card.ability.extra and card.ability.extra.cards then
                if #G.hand.highlighted > 0 and #G.hand.highlighted <= card.ability.extra.cards then
                    return true
                end
            end
            return false
        end,
        use = function(self, card, area, copier)
            if G and G.hand and G.hand.highlighted then
                for i = 1, #G.hand.highlighted do
                    -- Randomly select an enhancement type
                    local enhancement_type = math.random(3) -- 1 for Wood, 2 for Brick, 3 for Metal
                    
                    -- Assign the enhancement based on the random type
                    if enhancement_type == 1 then
                        if config.sfx ~= false then
                            play_sound("fn_wood")
                        end
                        G.hand.highlighted[i]:set_ability(G.P_CENTERS.m_fn_Wood, nil, true)
                    elseif enhancement_type == 2 then
                        if config.sfx ~= false then
                            play_sound("fn_brick")
                        end
                        G.hand.highlighted[i]:set_ability(G.P_CENTERS.m_fn_Brick, nil, true)
                    elseif enhancement_type == 3 then
                        if config.sfx ~= false then
                            play_sound("fn_metal")
                        end
                        G.hand.highlighted[i]:set_ability(G.P_CENTERS.m_fn_Metal, nil, true)
                    end
                    
                    -- Add an event to juice up the card
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            G.hand.highlighted[i]:juice_up()
                            return true
                        end
                    }))
                end
            end
        end,
    }


----------------------------------------------
------------BLUEPRINT CODE END----------------------

----------------------------------------------
------------SLAP JUICE CODE BEGIN----------------------

SMODS.Sound({
	key = "slap",
	path = "slap.ogg",
})

SMODS.Consumable{
    key = 'LTMSlap', -- key
    set = 'LTMConsumableType', -- the set of the card: corresponds to a consumable type
    atlas = 'Jokers', -- atlas
    pos = {x = 2, y = 9}, -- position in atlas
    loc_txt = {
        name = 'Slap Juice', -- name of card
        text = { -- text of card
            'Gives {C:chips}#1# Hands{} and {C:mult}#2# Discards{}',
        }
    },
    config = {
        extra = {
            hands = 1, discards = 1 -- configurable values
        },
    },
    loc_vars = function(self, info_queue, center)
        if center and center.ability and center.ability.extra then
            return {vars = {center.ability.extra.hands, center.ability.extra.discards}} 
        end
        return {vars = {}}
    end,
    can_use = function(self, card)
        -- Only allow use when there are cards in hand
        return G.STATE == G.STATES.SELECTING_HAND
    end,
    use = function(self, card, area, copier)
        if config.sfx ~= false then
            play_sound("fn_slap")
        end

        -- Add an event to execute after a delay
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.1,
            func = function()
                -- Add hands
                local hands_to_add = card.ability.extra.hands or 1
                ease_hands_played(hands_to_add)

                -- Add discards
                local discards_to_add = card.ability.extra.discards or 1
                ease_discard(discards_to_add)

                return true
            end
        }))
    end,
}


----------------------------------------------
------------SLAP JUICE CODE END----------------------

----------------------------------------------
------------BOOM BOX CODE BEGIN----------------------

SMODS.Sound({
	key = "boombox",
	path = "boombox.ogg",
})

SMODS.Consumable{
    key = 'LTMBoomBox', -- key
    set = 'LTMConsumableType', -- the set of the card: corresponds to a consumable type
    atlas = 'Jokers', -- atlas
    pos = {x = 3, y = 9}, -- position in atlas
    loc_txt = {
        name = 'Boom Box', -- name of card
        text = { -- text of card
            'Select {C:attention}#1#{} cards and {C:mult}remove{} them',
            'Add random enhancements to {C:attention}#1#{} random other cards in the deck',
        },
    },
    config = {
        extra = {
            cards = 3, -- configurable value (default to 3 cards)
        },
    },
    loc_vars = function(self, info_queue, center)
        if center and center.ability and center.ability.extra then
            local cards = math.floor(center.ability.extra.cards) -- Ensure rounded-down value
            return {vars = {cards}}
        end
        return {vars = {}}
    end,
    can_use = function(self, card)
        if G and G.hand and G.hand.highlighted and card.ability and card.ability.extra and card.ability.extra.cards then
            local cards = math.floor(card.ability.extra.cards) -- Ensure rounded-down value
            return #G.hand.highlighted == cards
        end
        return false
    end,
    use = function(self, card, area, copier)
        if config.sfx ~= false then
            play_sound("fn_boombox")
        end

        -- Remove the selected cards in hand with redundancy
        if G and G.hand and G.hand.highlighted then
            for _, selected_card in ipairs(G.hand.highlighted) do
                selected_card:start_dissolve() -- Ensures visual effect of removal

                -- Ensure jokers properly process the removed card
                if selected_card.playing_card then
                    for j = 1, #G.jokers.cards do
                        eval_card(G.jokers.cards[j], {
                            cardarea = G.jokers,
                            remove_playing_cards = true,
                            removed = {selected_card}
                        })
                    end
                end
            end
        end

        -- Add random enhancements to random cards in the deck
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.1,
            func = function()
                local all_cards = G.deck.cards -- Get all cards in the deck
                if not all_cards or #all_cards == 0 then
                    print("No cards in the deck.")
                    return false
                end

                -- Shuffle the deck to randomize card selection
                math.randomseed(os.time())
                for i = #all_cards, 2, -1 do
                    local j = math.random(1, i)
                    all_cards[i], all_cards[j] = all_cards[j], all_cards[i]
                end

                -- Use the rounded-down value of `cards`
                local maxCards = math.floor(card.ability.extra.cards or 1)
                local selected_cards = {}
                for i = 1, math.min(#all_cards, maxCards) do
                    selected_cards[#selected_cards + 1] = all_cards[i]
                end

                -- Apply a random enhancement using the poll_enhancement function
                for _, selected_card in ipairs(selected_cards) do
                    local enhancement_key = {key = 'boombox', guaranteed = true}
                    local random_enhancement = G.P_CENTERS[SMODS.poll_enhancement(enhancement_key)]
                    selected_card:set_ability(random_enhancement, true)

                    -- Trigger a visual effect for enhancement
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            selected_card:juice_up() -- Visually enhance the card
                            return true
                        end
                    }))
                end

                return true
            end,
        }))
    end,
}

----------------------------------------------
------------BOOM BOX CODE END----------------------

----------------------------------------------
------------JUNK RIFT CODE BEGIN----------------------

SMODS.Sound({
	key = "junk",
	path = "junk.ogg",
})

SMODS.Consumable {
    key = 'LTMJunk',
    set = 'LTMConsumableType',
    atlas = 'Jokers',
    pos = {x = 1, y = 10},
    cost = 6,
    loc_txt = {
        name = 'Junk Rift',
        text = {
            'Create {C:attention}#1#{} random {C:attention}playing cards{}',
            'Cards created this way MAY have randomly generated',
            'Editions, Enhancements, and Seals',
        }
    },
    config = {
        extra = {
            cards = 3, -- configurable number of cards (default: 3)
        },
    },
    loc_vars = function(self, info_queue, center)
        if center and center.ability and center.ability.extra then
            local cards = math.floor(center.ability.extra.cards) -- Ensure rounded-down value
            return {vars = {cards}}
        end
        return {vars = {}}
    end,
    can_use = function(self, card)
        return #G.hand.cards > 0 
    end,
    use = function(self, card, area, copier)
        if config.sfx ~= false then
            play_sound("fn_junk")
        end

        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.1,
            func = function()
                local num_cards = card.ability.extra.cards or 3  -- Default to 3 if nil
                for _ = 1, num_cards do
                    -- Create a base playing card
                    local new_card = create_playing_card(
                        {
                            front = pseudorandom_element(G.P_CARDS, pseudoseed('junk_rift')),
                            center = G.P_CENTERS.c_base
                        },
                        G.hand
                    )

                    -- Determine modifications
                    if math.random() <= 0.5 then
                        new_card:set_ability(G.P_CENTERS[SMODS.poll_enhancement({key = 'junk', guaranteed = true})], true)
                    end

                    if math.random() <= 0.3 then
                        new_card:set_edition(poll_edition('junk_edition', 1, true, true), true)
                    end

                    if math.random() <= 0.2 then
                        new_card:set_seal(SMODS.poll_seal({key = 'junk', guaranteed = true}), true)
                    end

                    -- Apply additional effects (e.g., debuffing or modifying the card)
                    G.GAME.blind:debuff_card(new_card)
                end

                -- Enhance the card that used the consumable
                if copier then
                    copier:juice_up()
                else
                    card:juice_up()
                end
                return true
            end
        }))
    end,
}

----------------------------------------------
------------JUNK RIFT CODE END----------------------

----------------------------------------------
------------PIZZA CODE BEGIN----------------------

SMODS.Sound({
	key = "pizza1",
	path = "pizza1.ogg",
})
SMODS.Sound({
	key = "pizza2",
	path = "pizza2.ogg",
})

SMODS.Consumable{
    key = 'LTMPizza',
    set = 'LTMConsumableType',
    atlas = 'Jokers',
    pos = {x = 3, y = 10},
    cost = 1,
    loc_txt = {
        name = 'Pizza',
        text = {
            'Gives {C:attention}#2#%{} of current {C:attention}Blind requirement{} as {C:chips}Chips',
            'Loses {C:attention}#3#%{} at {C:attention}end of round{}',
        },
        use_msg = "You gained {chips} chips from the Pizza!",
    },
    config = {
        extra = {chips = 0, percent = 0.25, loss = 0.03},
    },

    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.extra.chips,
                card.ability.extra.percent * 100,
                card.ability.extra.loss * 100,
            }
        }
    end,

    calculate = function(self, card, context)
        if context.end_of_round and not context.repetition and not context.individual then
            card.ability.extra.percent = card.ability.extra.percent - card.ability.extra.loss
        end
    end,

    can_use = function(self)
        return G.STATE == G.STATES.SELECTING_HAND
    end,

    use = function(self, card, area, copier)
        -- Play sound
        local sfx_flag = card.ability.config and card.ability.config.sfx
        if sfx_flag ~= false then
            play_sound(math.random() < 0.9 and "fn_pizza1" or "fn_pizza2")
        end

        -- Get blind chip value
        local blind_chips = G.GAME.blind and G.GAME.blind.chips or 0
        local percent = card.ability.extra.percent or 0.25
        local award_chips = math.floor(blind_chips * percent)

        -- Grant chips
        G.GAME.chips = G.GAME.chips + award_chips
        G.GAME.pool_flags.ltm_pizza_flag = true

        -- Visual feedback
        (copier or card):juice_up()

        -- Check for auto-win
        G.E_MANAGER:add_event(Event({
            trigger = "immediate",
            func = function()
                if G.STATE ~= G.STATES.SELECTING_HAND then return false end
                if G.GAME.chips >= blind_chips then
                    G.STATE = G.STATES.HAND_PLAYED
                    G.STATE_COMPLETE = true
                    end_round()
                end
                return true
            end,
        }), "other")

        return {message = self.loc_txt.use_msg:gsub("{chips}", tostring(award_chips))}
    end,
}


----------------------------------------------
------------PIZZA CODE END----------------------

----------------------------------------------
------------PIZZA PARTY CODE BEGIN----------------------

SMODS.Sound({
	key = "box",
	path = "box.ogg",
})

SMODS.Consumable {
    key = 'LTMPizzaParty',
    set = 'LTMConsumableType',
    atlas = 'Jokers',
    pos = {x = 4, y = 10},
    cost = 6,
    loc_txt = {
        name = 'Pizza Party',
        text = {
            'Create {C:attention}#1#{} {C:attention}Pizza Slices{}',
			'Automatically used when {C:attention}selecting blind{}',
        }
    },
    config = {
        extra = {
            slices = 2, -- Default to 2 slices
        },
    },
    loc_vars = function(self, info_queue, center)
		info_queue[#info_queue + 1] = G.P_CENTERS.c_fn_LTMPizza
        if center and center.ability and center.ability.extra then
            local slices = math.floor(center.ability.extra.slices)
            return {vars = {slices}}
        end
        return {vars = {}}
    end,

    calculate = function(self, card, context)
        if context.setting_blind then
			if config.sfx ~= false then
				play_sound("fn_box")
			end
            local slices_to_create = card.ability.extra.slices or 2

            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.1,
                func = function()
                    for _ = 1, slices_to_create do
                        local tarot_cards = {
                            'c_fn_LTMPizza', 'c_fn_LTMPizza', 'c_fn_LTMPizza',
                        }
                        local random_card_id = tarot_cards[math.random(1, #tarot_cards)]
                        local _card = create_card('Tarot', G.consumeables, nil, nil, nil, nil, random_card_id)
                        _card:add_to_deck()
                        G.consumeables:emplace(_card)
                    end
                    card:start_dissolve()
                    return true
                end
            }))
        end
    end,

    can_use = function(self, card)
        return G and G.deck and #G.deck.cards > 0
    end,

    use = function(self, card, area, copier)
        if config.sfx ~= false then
            play_sound("fn_box")
        end

        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.1,
            func = function()
                local slices_to_create = card.ability.extra.slices or 2
                for _ = 1, slices_to_create do
                    local tarot_cards = {
                        'c_fn_LTMPizza', 'c_fn_LTMPizza', 'c_fn_LTMPizza',
                    }
                    local random_card_id = tarot_cards[math.random(1, #tarot_cards)]
                    local _card = create_card('Tarot', G.consumeables, nil, nil, nil, nil, random_card_id)
                    _card:add_to_deck()
                    G.consumeables:emplace(_card)
                end
                return true
            end
        }))
    end,
}


----------------------------------------------
------------PIZZA PARTY CODE END----------------------

----------------------------------------------
------------RIFT TO GO CODE BEGIN----------------------

SMODS.Sound({
	key = "rift",
	path = "rift.ogg",
})


SMODS.Consumable{
    key = 'LTMRift', -- key
    set = 'LTMConsumableType', -- the set of the card: corresponds to a consumable type
    atlas = 'Jokers', -- atlas
    pos = {x = 0, y = 11}, -- position in atlas
    loc_txt = {
        name = 'Rift to Go', -- name of card
        text = { -- text of card
            'Select up to {C:attention}#1#{} cards and Discard them',
            '{C:inactive}Doesn\'t use a Discard'
        }
    },
    config = {
        extra = {
            cards = 3, -- configurable value
        }
    },
    loc_vars = function(self, info_queue, center)
        if center and center.ability and center.ability.extra then
            return {vars = {center.ability.extra.cards}} 
        end
        return {vars = {}}
    end,
    can_use = function(self, card)
        if G and G.hand and G.hand.highlighted and card.ability and card.ability.extra and card.ability.extra.cards then
            if #G.hand.highlighted > 0 and #G.hand.highlighted <= card.ability.extra.cards then
                return true
            end
        end
        return false
    end,
    use = function(self, card, area, copier)
        if config.sfx ~= false then
            play_sound("fn_rift") -- Play the Rift sound effect
        end
        if G and G.hand and G.hand.highlighted then
            local any_selected = false
            local _cards = {}
			
            
            -- Create a shallow copy of the highlighted cards
            for k, v in ipairs(G.hand.highlighted) do
                _cards[#_cards + 1] = v
            end
            
            -- Track how many cards are discarded
            local discarded_count = 0
            
            -- Discard the highlighted cards
            for i = 1, math.min(#G.hand.highlighted, card.ability.extra.cards) do
                local selected_card, card_key = pseudorandom_element(_cards, pseudoseed('rift'))
                table.remove(_cards, card_key) -- Remove from the local copy
                discarded_count = discarded_count + 1
                any_selected = true
            end
            
            -- Discard highlighted cards using the game's discard function
            if any_selected then
                G.FUNCS.discard_cards_from_highlighted(nil, true)
            end
            
            -- Draw cards to replace the discarded ones
            if discarded_count > 0 and G.deck and #G.deck.cards > 0 then
                G.FUNCS.draw_from_deck_to_hand(math.min(discarded_count, #G.deck.cards))
            end
        end
    end,
}

----------------------------------------------
------------RIFT TO GO CODE END----------------------

----------------------------------------------
------------GLITCHED CODE BEGIN----------------------

SMODS.Consumable {
    key = 'Glitched',
    set = 'Tarot',
    atlas = 'Jokers',
    pos = {x = 1, y = 11},
    cost = 3,
    loc_txt = {
        name = 'Glitched',
        text = {
            'Create {C:attention}0-4{} random {C:purple}LTM Cards{}',
            '{C:inactive}(no need to have room)'
        }
    },
    config = {
        extra = {
            cards = 2, -- Default value, but can be ignored with random generation
        },
    },
    loc_vars = function(self, info_queue, center)
        if center and center.ability and center.ability.extra then
            local cards = math.floor(center.ability.extra.cards) -- Ensure rounded-down value
            return {vars = {cards}}
        end
        return {vars = {}}
    end,
    can_use = function(self, card)
        return true  -- Consumable can always be used
    end,
    use = function(self, card, area, copier)
        if config.sfx ~= false then
            play_sound("fn_error")
        end

        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.1,
            func = function()
                -- Generate a random number of LTM cards between 0 and 4
                local num_cards = math.random(0, 4)
                
                for _ = 1, num_cards do
                    -- Create and add the LTM card to the deck
                    local new_card = create_card('LTMConsumableType', G.consumeables)
                    new_card:add_to_deck()
                    G.consumeables:emplace(new_card)

                    -- Apply additional effects (e.g., debuffing or modifying the card)
                    G.GAME.blind:debuff_card(new_card)
                end

                -- Enhance the card that used the consumable
                if copier then
                    copier:juice_up()
                else
                    card:juice_up()
                end
                return true
            end
        }))
    end,
}

----------------------------------------------
------------GLITCHED CODE END----------------------

----------------------------------------------
------------CHEST CODE END----------------------

SMODS.Sound({
	key = "chest",
	path = "chest.ogg",
})

SMODS.Consumable{
    key = 'LTMChest', -- key
    set = 'LTMConsumableType', -- the set of the card: corresponds to a consumable type
    atlas = 'Jokers', -- atlas
    pos = {x = 3, y = 11}, -- position in atlas
    loc_txt = {
        name = 'Chest', -- name of card
        text = { -- text of card
            'Summon {C:attention}1{} random low-tier Joker',
            '{C:inactive}(Must have room)'
        }
    },
    config = {
        extra = {
            cards = 1, -- configurable value (now hard-coded)
        }
    },
    loc_vars = function(self, info_queue, center)
        return {vars = {}}
    end,
    can_use = function(self, card)
        -- Check if there's room for more Jokers or if the consumable is in the Joker area
        if #G.jokers.cards < G.jokers.config.card_limit or self.area == G.jokers then
            return true
        end
        return false
    end,
    use = function(self, card, area, copier)
        if config.sfx ~= false then
            play_sound("fn_chest") -- Play the Chest sound effect
        end

        G.E_MANAGER:add_event(Event({
            func = function()
                if G.jokers then
                    -- Randomly choose between common (1) or uncommon (2) with a higher chance for common
                    local rank = (math.random() <= 0.75) and false or true -- 75% chance for common, 25% for uncommon

                    -- Create the card (no legendary cards allowed)
                    local created_card = create_card("Joker", G.jokers, false, false, rank, true, nil, "")

                    -- Add it to the deck and materialize
                    created_card:add_to_deck()
                    created_card:start_materialize()
                    G.jokers:emplace(created_card)

                    return true
                end
            end,
        }))
    end,
}



----------------------------------------------
------------CHEST CODE END----------------------

----------------------------------------------
------------RARE CHEST CODE BEGIN----------------------
SMODS.Consumable{
    key = 'LTMRareChest', -- key
    set = 'LTMConsumableType', -- the set of the card
    atlas = 'Jokers', -- atlas
    pos = {x = 4, y = 11}, -- position in atlas
    loc_txt = {
        name = 'Rare Chest', -- name of card
        text = { -- text of card
            'Summon {C:attention}1{} random high-tier Joker',
            '{C:inactive}(Must have room)'
        }
    },
    config = {
        extra = {
            cards = 1, -- configurable value
        }
    },
    loc_vars = function(self, info_queue, center)
        if center and center.ability and center.ability.extra then
            return {vars = {center.ability.extra.cards}} 
        end
        return {vars = {}}
    end,
    can_use = function(self, card)
        -- Check if there's room for more Jokers or if the consumable is in the Joker area
        if #G.jokers.cards < G.jokers.config.card_limit or self.area == G.jokers then
            return true
        end
        return false
    end,
    use = function(self, card, area, copier)
        if config.sfx ~= false then
            play_sound("fn_chest") -- Play the Chest sound effect
        end

        G.E_MANAGER:add_event(Event({
            func = function()
                if G.jokers then
                    -- Randomly decide if it's legendary or rare (50% chance each)
                    local is_legendary = math.random() < 0.1  -- 30% chance to be true (legendary)

                    -- Create the card: first `true` for legendary, `false` for rare
                    local created_card = create_card("Joker", G.jokers, is_legendary, 4, nil, nil, nil, "")

                    -- Add it to the deck and materialize
                    created_card:add_to_deck()
                    created_card:start_materialize()
                    G.jokers:emplace(created_card)

                    return true
                end
            end,
        }))
    end,
}

----------------------------------------------
------------RARE CHEST CODE END----------------------

----------------------------------------------
------------EARTH SPRITE CODE BEGIN----------------------

SMODS.Sound({
	key = "earth",
	path = "earth.ogg",
})


SMODS.Consumable{
    key = 'LTMEarth', -- key
    set = 'LTMConsumableType', -- the set of the card: corresponds to a consumable type
    atlas = 'Jokers', -- atlas
    pos = {x = 1, y = 16}, -- position in atlas
    loc_txt = {
        name = 'Earth Sprite', -- name of card
        text = { -- text of card
            'Eat up to {C:attention}5{} selected cards',
			'Randomize their suit and rank',
            'Then convert them into {C:money}Legendary{} Cards',
			'Idea: BoiRowan'
        }
    },
    config = {
        extra = {
            cards = 5 -- configurable value
        }
    },
    loc_vars = function(self, info_queue, center)
        info_queue[#info_queue + 1] = G.P_CENTERS.m_fn_Legendary
        if center and center.ability and center.ability.extra then
            return {vars = {center.ability.extra.cards}} 
        end
        return {vars = {}}
    end,
    can_use = function(self, card)
        if G and G.hand and G.hand.highlighted and card.ability and card.ability.extra and card.ability.extra.cards then
            if #G.hand.highlighted > 0 and #G.hand.highlighted <= card.ability.extra.cards then
                return true
            end
        end
        return false
    end,
    use = function(self, card, area, copier)
        if G and G.hand and G.hand.highlighted and #G.hand.highlighted > 0 then
            local num_cards = math.min(#G.hand.highlighted, card.ability.extra.cards or 5)

            G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
                for i = 1, num_cards do
                    local old_card = G.hand.highlighted[i]
                    old_card:start_dissolve()

                    -- Pick a random card from the base deck
                    local valid_cards = {}
                    for _, v in pairs(G.P_CARDS) do
                        table.insert(valid_cards, v) -- Include all ranks and suits
                    end

                    if #valid_cards > 0 then
                        local chosen_card = pseudorandom_element(valid_cards, pseudoseed('earth_sprite'))

                        -- Create the new Legendary card
                        local new_card_data = {
                            front = chosen_card,  -- Random card
                            center = G.P_CENTERS.m_fn_Legendary  -- Set to Legendary
                        }

                        -- Create the new card in hand
                        local new_card = create_playing_card(new_card_data, G.hand)

                        -- Make sure the card is Legendary by explicitly setting the ability
                        new_card:set_ability(G.P_CENTERS.m_fn_Legendary, nil, true)

                        -- Visual & sound feedback
                        new_card:juice_up(0.3, 0.3)
                        if config.sfx ~= false then
							play_sound("fn_earth") -- Play the Rift sound effect
						end
                    end
                end

                return true
            end}))
        end
    end
}

----------------------------------------------
------------EARTH SPRITE CODE END----------------------

----------------------------------------------
------------LUMBERJACK CODE BEGIN----------------------

SMODS.Consumable{
    key = 'Lumberjack',
    set = 'Tarot',
    atlas = 'Jokers',
    pos = {x = 2, y = 16},
    loc_txt = {
        name = 'Lumberjack',
        text = {
            'Convert up to {C:attention}#1#{} cards into {C:money}Wood{} cards',
			'Idea+Art: BoiRowan',
        }
    },
    config = {
        extra = {
            cards = 2, -- configurable value
        }
    },
    loc_vars = function(self, info_queue, center)
        info_queue[#info_queue + 1] = G.P_CENTERS.m_fn_Wood
        if center and center.ability and center.ability.extra then
            return {vars = {center.ability.extra.cards}} 
        end
        return {vars = {}}
    end,
    can_use = function(self, card)
        return G and G.hand and G.hand.highlighted and card.ability and card.ability.extra and 
            card.ability.extra.cards and #G.hand.highlighted > 0 and #G.hand.highlighted <= card.ability.extra.cards
    end,
    use = function(self, card, area, copier)
        if G and G.hand and G.hand.highlighted and #G.hand.highlighted > 0 then
            for i = 1, #G.hand.highlighted do
                local target_card = G.hand.highlighted[i]

                -- Transform the card into a Wood card
                target_card:set_ability(G.P_CENTERS.m_fn_Wood)
				
				if config.sfx ~= false then
					play_sound("fn_wood")
                end

                -- Add a juice-up effect for better feedback
                G.E_MANAGER:add_event(Event({
                    func = function()
                        target_card:juice_up()
                        return true
                    end
                }))
            end
        end
    end,
}

----------------------------------------------
------------LUMBERJACK CODE END----------------------

----------------------------------------------
------------MINER CODE BEGIN----------------------

SMODS.Consumable{
    key = 'Miner',
    set = 'Tarot',
    atlas = 'Jokers',
    pos = {x = 3, y = 16},
    loc_txt = {
        name = 'Miner',
        text = {
            'Convert up to {C:attention}#1#{} cards into {C:mult}Brick{} cards',
			'Idea+Art: BoiRowan',
        }
    },
    config = {
        extra = {
            cards = 2, -- configurable value
        }
    },
    loc_vars = function(self, info_queue, center)
        info_queue[#info_queue + 1] = G.P_CENTERS.m_fn_Brick
        if center and center.ability and center.ability.extra then
            return {vars = {center.ability.extra.cards}} 
        end
        return {vars = {}}
    end,
    can_use = function(self, card)
        return G and G.hand and G.hand.highlighted and card.ability and card.ability.extra and 
            card.ability.extra.cards and #G.hand.highlighted > 0 and #G.hand.highlighted <= card.ability.extra.cards
    end,
    use = function(self, card, area, copier)
        if G and G.hand and G.hand.highlighted and #G.hand.highlighted > 0 then
            for i = 1, #G.hand.highlighted do
                local target_card = G.hand.highlighted[i]

                -- Transform the card into a Wood card
                target_card:set_ability(G.P_CENTERS.m_fn_Brick)

				if config.sfx ~= false then
					play_sound("fn_brick")
                end
				
                -- Add a juice-up effect for better feedback
                G.E_MANAGER:add_event(Event({
                    func = function()
                        target_card:juice_up()
                        return true
                    end
                }))
            end
        end
    end,
}

----------------------------------------------
------------MINER CODE END----------------------

----------------------------------------------
------------BLACKSMITH CODE BEGIN----------------------

SMODS.Consumable{
    key = 'Blacksmith',
    set = 'Tarot',
    atlas = 'Jokers',
    pos = {x = 4, y = 16},
    loc_txt = {
        name = 'Blacksmith',
        text = {
            'Convert up to {C:attention}#1#{} cards into {C:inactive}Metal{} cards',
			'Idea+Art: BoiRowan',
        }
    },
    config = {
        extra = {
            cards = 2, -- configurable value
        }
    },
    loc_vars = function(self, info_queue, center)
        info_queue[#info_queue + 1] = G.P_CENTERS.m_fn_Metal
        if center and center.ability and center.ability.extra then
            return {vars = {center.ability.extra.cards}} 
        end
        return {vars = {}}
    end,
    can_use = function(self, card)
        return G and G.hand and G.hand.highlighted and card.ability and card.ability.extra and 
            card.ability.extra.cards and #G.hand.highlighted > 0 and #G.hand.highlighted <= card.ability.extra.cards
    end,
    use = function(self, card, area, copier)
        if G and G.hand and G.hand.highlighted and #G.hand.highlighted > 0 then
            for i = 1, #G.hand.highlighted do
                local target_card = G.hand.highlighted[i]

                -- Transform the card into a Wood card
                target_card:set_ability(G.P_CENTERS.m_fn_Metal)

				if config.sfx ~= false then
					play_sound("fn_metal")
                end

                -- Add a juice-up effect for better feedback
                G.E_MANAGER:add_event(Event({
                    func = function()
                        target_card:juice_up()
                        return true
                    end
                }))
            end
        end
    end,
}

----------------------------------------------
------------BLACKSMITH CODE END----------------------

----------------------------------------------
------------C4 CODE BEGIN----------------------

SMODS.Sound({
	key = "c4",
	path = "c4.ogg",
})

SMODS.Sound({
	key = "c42",
	path = "c42.ogg",
})

SMODS.Consumable{
    key = 'LTMC4',
    set = 'LTMConsumableType',
    atlas = 'Jokers',
    pos = {x = 0, y = 17},
    loc_txt = {
        name = 'C4',
        text = {
            'Destroy {C:attention}#1#{} random cards from the deck',
            'Create {C:attention}#2#{} random tags',
			'Idea: BoiRowan',
        }
    },
    config = {
        extra = { cards = 5, tags = 1 },
    },
    loc_vars = function(self, info_queue, center)
        if center and center.ability and center.ability.extra then
            return {vars = {center.ability.extra.cards, center.ability.extra.tags}} 
        end
        return {vars = {}}
    end,
    can_use = function(self, card)
        -- Only allow use when there are cards in the deck
        return G and #G.deck.cards > 0
    end,
    use = function(self, card, area, copier)
        if config.sfx ~= false then
            play_sound(math.random() < 0.9 and "fn_c4" or "fn_c42")
        end

        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.1,
            func = function()
                local all_cards = G.deck.cards
                if not all_cards or #all_cards == 0 then
                    return false
                end

                -- Select up to `extra.cards` random cards to destroy
                local num_to_destroy = math.min(#all_cards, card.ability.extra.cards)
                for i = 1, num_to_destroy do
                    local index = math.random(#all_cards)
                    local selected_card = all_cards[index]
                    selected_card:start_dissolve()
                end

                -- Create `extra.tags` random tags
                local random_tags = {
                    "tag_fn_LTMTag1", "tag_fn_LTMTag2", "tag_uncommon", "tag_rare", "tag_negative", 
                    "tag_foil", "tag_holo", "tag_polychrome", "tag_investment", "tag_voucher", 
                    "tag_boss", "tag_standard", "tag_charm", "tag_meteor", "tag_buffoon", 
                    "tag_handy", "tag_garbage", "tag_ethereal", "tag_coupon", "tag_double", 
                    "tag_juggle", "tag_d_six", "tag_top_up", "tag_skip", "tag_orbital", "tag_economy"
                }

                for i = 1, card.ability.extra.tags do
                    local chosen_tag = random_tags[math.random(#random_tags)]
                    
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            add_tag(Tag(chosen_tag))
                            play_sound('generic1', 0.9 + math.random() * 0.1, 0.8)
                            play_sound('holo1', 1.2 + math.random() * 0.1, 0.4)
                            return true
                        end
                    }))
                end

                return true
            end
        }))
    end,
}

----------------------------------------------
------------C4 CODE END----------------------

----------------------------------------------
------------CUBE FRAGMENT CODE BEGIN----------------------

SMODS.Consumable{
    key = 'LTMCube',
    set = 'LTMConsumableType',
    atlas = 'Jokers',
    pos = {x = 2, y = 17},
    loc_txt = {
        name = 'Cube Fragment',
        text = {
            'Cannot be used',
            'while held {C:attention}when blind is selected{}',
            'Converts {C:attention}#1#{} random cards from the deck to {C:purple}Cubic{}',
            'Idea: BoiRowan',
        }
    },
    config = {
        extra = { cards = 1 },
    },
    loc_vars = function(self, info_queue, center)
		info_queue[#info_queue + 1] = G.P_CENTERS.m_fn_Cubic
        if center and center.ability and center.ability.extra then
            return {vars = {center.ability.extra.cards}} 
        end
        return {vars = {}}
    end,
    can_use = function(self, card)
        -- Only allow use when selecting a blind
        return false
    end,
    calculate = function(self, card, context)
        -- Trigger the effect when the first hand is drawn
        if context.setting_blind then
            -- Create an event to trigger the effect after a short delay
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                func = function()
                    -- Collect all cards in the deck
                    local all_cards = G.deck.cards
                    if not all_cards or #all_cards == 0 then
                        return false
                    end

                    -- Select up to `extra.cards` random cards to convert to Cubic
                    local num_to_convert = math.min(#all_cards, card.ability.extra.cards)

                    for i = 1, num_to_convert do
                        local index = math.random(#all_cards)
                        local selected_card = all_cards[index]

                        -- Convert the selected card to Cubic
                        selected_card:set_ability(G.P_CENTERS.m_fn_Cubic)

                        -- Provide visual feedback using juice-up
                        G.E_MANAGER:add_event(Event({
                            func = function()
                                selected_card:juice_up()
                                return true
                            end
                        }))
                    end
                    return true
                end
            }))
        end
    end
}

----------------------------------------------
------------CUBE FRAGMENT CODE END----------------------

----------------------------------------------
------------RUNIC PORTAL CODE BEGIN----------------------

SMODS.Consumable{
    key = 'Portal',
    set = 'Tarot',
    atlas = 'Jokers',
    pos = {x = 1, y = 18},
    loc_txt = {
        name = 'Runic Portal',
        text = {
            'Convert up to {C:attention}#1#{} cards into {C:purple}Cubic{} cards',
			'Idea: BoiRowan',
        }
    },
    config = {
        extra = {
            cards = 2, -- configurable value
        }
    },
    loc_vars = function(self, info_queue, center)
        info_queue[#info_queue + 1] = G.P_CENTERS.m_fn_Cubic
        if center and center.ability and center.ability.extra then
            return {vars = {center.ability.extra.cards}} 
        end
        return {vars = {}}
    end,
    can_use = function(self, card)
        return G and G.hand and G.hand.highlighted and card.ability and card.ability.extra and 
            card.ability.extra.cards and #G.hand.highlighted > 0 and #G.hand.highlighted <= card.ability.extra.cards
    end,
    use = function(self, card, area, copier)
        if G and G.hand and G.hand.highlighted and #G.hand.highlighted > 0 then
            for i = 1, #G.hand.highlighted do
                local target_card = G.hand.highlighted[i]

                -- Transform the card into a Wood card
                target_card:set_ability(G.P_CENTERS.m_fn_Cubic)


                -- Add a juice-up effect for better feedback
                G.E_MANAGER:add_event(Event({
                    func = function()
                        target_card:juice_up()
                        return true
                    end
                }))
            end
        end
    end,
}

----------------------------------------------
------------RUNIC PORTAL CODE END----------------------

----------------------------------------------
------------SUPREMACY CODE BEGIN----------------------

SMODS.Consumable{
    key = 'Supremacy',
    set = 'Tarot',
    atlas = 'Jokers',
    pos = {x = 2, y = 18},
    loc_txt = {
        name = 'Supremacy',
        text = {
            'Convert up to {C:attention}#1#{} cards into {C:attention}Legendary{} cards',
			'Idea: BoiRowan',
        }
    },
    config = {
        extra = {
            cards = 1, -- configurable value
        }
    },
    loc_vars = function(self, info_queue, center)
        info_queue[#info_queue + 1] = G.P_CENTERS.m_fn_Legendary
        if center and center.ability and center.ability.extra then
            return {vars = {center.ability.extra.cards}} 
        end
        return {vars = {}}
    end,
    can_use = function(self, card)
        return G and G.hand and G.hand.highlighted and card.ability and card.ability.extra and 
            card.ability.extra.cards and #G.hand.highlighted > 0 and #G.hand.highlighted <= card.ability.extra.cards
    end,
    use = function(self, card, area, copier)
        if G and G.hand and G.hand.highlighted and #G.hand.highlighted > 0 then
            for i = 1, #G.hand.highlighted do
                local target_card = G.hand.highlighted[i]

                -- Transform the card into a Wood card
                target_card:set_ability(G.P_CENTERS.m_fn_Legendary)


                -- Add a juice-up effect for better feedback
                G.E_MANAGER:add_event(Event({
                    func = function()
                        target_card:juice_up()
                        return true
                    end
                }))
            end
        end
    end,
}
----------------------------------------------
------------SUPREMACY CODE END----------------------

----------------------------------------------
------------AIRSTRIKE CODE BEGIN----------------------

SMODS.Sound({
	key = "air",
	path = "air.ogg",
})

SMODS.Consumable{
    key = 'LTMAir',
    set = 'LTMConsumableType',
    atlas = 'Jokers',
    pos = {x = 0, y = 19},
	rarity = 3,
    loc_txt = {
        name = 'Airstrike',
        text = {
            'Destroy all {C:attention}Even{} cards currently in the deck',
            'Idea: BoiRowan',
        }
    },
    config = {
    },
    can_use = function(self, card)
        return G and #G.deck.cards > 0
    end,
    use = function(self, card, area, copier)
        if config.sfx ~= false then
            play_sound("fn_air")
        end

        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.1,
            func = function()
                local all_cards = G.deck.cards
                if not all_cards or #all_cards == 0 then
                    return false
                end

                -- Filter and destroy even cards
                for _, c in ipairs(all_cards) do
                    local rank = c:get_id()
                    if rank >= 2 and rank <= 10 and rank % 2 == 0 then
                        c:start_dissolve()
                    end
                end

                return true
            end
        }))
    end,
}

----------------------------------------------
------------AIRSTRIKE CODE END----------------------

----------------------------------------------
------------BOTTLE ROCKET CODE BEGIN----------------------

SMODS.Sound({
	key = "bottle",
	path = "bottle.ogg",
})

SMODS.Consumable{
    key = 'LTMBottle',
    set = 'LTMConsumableType',
    atlas = 'Jokers',
    pos = {x = 1, y = 19},
    rarity = 3,
    loc_txt = {
        name = 'Bottle Rocket',
        text = {
            'Destroy all {C:attention}Odd{} cards currently in the deck',
            'Idea: BoiRowan',
        }
    },
    config = {

    },
    can_use = function(self, card)
        return G and #G.deck.cards > 0
    end,
    use = function(self, card, area, copier)
        if config.sfx ~= false then
            play_sound("fn_bottle")
        end

        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.1,
            func = function()
                local all_cards = G.deck.cards
                if not all_cards or #all_cards == 0 then
                    return false
                end

                -- Filter and destroy odd cards and Aces
                for _, c in ipairs(all_cards) do
                    local rank = c:get_id()
                    if (rank >= 2 and rank <= 10 and rank % 2 ~= 0) or rank == 14 then
                        c:start_dissolve()
                    end
                end

                return true
            end
        }))
    end,
}

----------------------------------------------
------------BOTTLE ROCKET CODE END----------------------

----------------------------------------------
------------MYTHIC GOLDFISH CODE BEGIN----------------------


SMODS.Sound({
	key = "fish",
	path = "fish.ogg",
})

SMODS.Consumable{
    key = 'LTMFish',
    set = 'LTMConsumableType',
    atlas = 'Jokers',
    pos = {x = 2, y = 19},
    rarity = 3,
    loc_txt = {
        name = 'Mythic Goldfish',
        text = {
            'Destroy all {C:attention}Face{} cards currently in the deck',
            'Idea: BoiRowan',
        }
    },
    config = {
    },
    can_use = function(self, card)
        return G and #G.deck.cards > 0
    end,
    use = function(self, card, area, copier)
        if config.sfx ~= false then
            play_sound("fn_fish")
        end

        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.1,
            func = function()
                local all_cards = G.deck.cards
                if not all_cards or #all_cards == 0 then
                    return false
                end

                local to_destroy = {}
                for _, c in ipairs(all_cards) do
                    local rank = c:get_id()
                    if rank >= 11 and rank <= 13 then
                        table.insert(to_destroy, c)
                    end
                end

                if #to_destroy > 0 then
                    for _, c in ipairs(to_destroy) do
                        -- Trigger destruction effect for jokers and other mechanics
                        if c.playing_card then
                            for _, joker in ipairs(G.jokers.cards) do
                                eval_card(joker, {
                                    cardarea = G.jokers,
                                    remove_playing_cards = true,
                                    removed = {c}
                                })
                            end
                        end

                        c:start_dissolve()
                    end
                end

                return true
            end
        }))
    end,
}

----------------------------------------------
------------MYTHIC GOLDFISH CODE END----------------------

----------------------------------------------
------------PAINT GRENADE CODE BEGIN----------------------

SMODS.Sound({
	key = "paint",
	path = "paint.ogg",
})

SMODS.Consumable{
    key = 'LTMPaint',
    set = 'LTMConsumableType',
    atlas = 'Jokers',
    pos = {x = 3, y = 19},
    rarity = 3,
    loc_txt = {
        name = 'Paint Grenades',
        text = {
            'Destroy all cards of a {C:attention}Random Suit{} currently in the deck',
            'Idea: BoiRowan',
        }
    },
    config = {
    },
    can_use = function(self, card)
        return G and #G.deck.cards > 0
    end,
    use = function(self, card, area, copier)
        if config.sfx ~= false then
            play_sound("fn_paint")
        end

        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.1,
            func = function()
                local all_cards = G.deck.cards
                if not all_cards or #all_cards == 0 then
                    return false
                end

                -- Select a random suit using the `is_suit` approach
                local suits = {"Spades", "Clubs", "Hearts", "Diamonds"}
                local chosen_suit = suits[math.random(#suits)]

                local to_destroy = {}
                for _, c in ipairs(all_cards) do
                    if c:is_suit(chosen_suit) then
                        table.insert(to_destroy, c)
                    end
                end

                if #to_destroy > 0 then
                    for _, c in ipairs(to_destroy) do
                        -- Trigger destruction effect for jokers and other mechanics
                        if c.playing_card then
                            for _, joker in ipairs(G.jokers.cards) do
                                eval_card(joker, {
                                    cardarea = G.jokers,
                                    remove_playing_cards = true,
                                    removed = {c}
                                })
                            end
                        end

                        c:start_dissolve()
                    end
                end

                return true
            end
        }))
    end,
}

----------------------------------------------
------------PAINT GRENADE CODE END----------------------

----------------------------------------------
------------QUEUE CODE END----------------------

SMODS.Sound({
	key = "ready",
	path = "ready.ogg",
})

SMODS.Consumable{
    key = 'Queue',
    set = 'Spectral',
    atlas = 'Jokers',
    pos = {x = 1, y = 21},
    loc_txt = {
        name = 'Queue',
        text = {
            'Randomize the seals of all {C:attention}sealed{} cards currently in deck',
            'Idea: BoiRowan',
        }
    },
    config = {
    },
    can_use = function(self, card)
        return G and #G.deck.cards > 0
    end,
    use = function(self, card, area, copier)
        if config.sfx ~= false then
            play_sound("fn_ready")
        end

        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.1,
            func = function()
                local all_cards = G.deck.cards
                if not all_cards or #all_cards == 0 then
                    return false
                end

                -- Iterate over all cards in the deck
                for _, v in ipairs(all_cards) do
                    -- Check if the card has a seal
                    if v.seal then
                        -- Randomize the seal (using your method to poll and set a new seal)
                        local new_seal = SMODS.poll_seal({key = 'ready', guaranteed = true})
                        v:set_seal(new_seal, true)
                    end
                end

                return true
            end
        }))
    end,
}

----------------------------------------------
------------QUEUE CODE END----------------------

----------------------------------------------
------------SPLIT PERSONALITY CODE BEGIN----------------------

SMODS.Consumable{
    key = 'Split',
    set = 'Tarot',
    atlas = 'Jokers',
    pos = {x = 2, y = 21},
    loc_txt = {
        name = 'Split Personality',
        text = {
            'Create {C:attention}#1#{} copies of up to {C:attention}#2#{} cards',
            'Copies have a {C:attention}random{} suit',
        }
    },
    config = {
        extra = {
			copies = 2,
            cards = 1, 
        }
    },
    loc_vars = function(self, info_queue, center)
        if center and center.ability and center.ability.extra then
            return {vars = {center.ability.extra.copies, center.ability.extra.cards}} 
        end
        return {vars = {}}
    end,
    can_use = function(self, card)
        return G and G.hand and G.hand.highlighted and card.ability and card.ability.extra and 
            card.ability.extra.cards and #G.hand.highlighted > 0 and #G.hand.highlighted <= card.ability.extra.cards
    end,

    use = function(self, card, area, copier)
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.1,
            func = function()
                if not (G and G.hand and G.hand.highlighted and #G.hand.highlighted > 0) then
                    return true
                end

                local suits = {"Hearts", "Diamonds", "Clubs", "Spades"}
                local new_cards = {}
                local copies_per_card = card.ability.extra.copies

                for _, target_card in ipairs(G.hand.highlighted) do
                    for _ = 1, copies_per_card do
                        local copy = copy_card(target_card)
                        if copy then
                            G.hand:emplace(copy)
                            copy:add_to_deck()
                            table.insert(G.playing_cards, copy)
                            table.insert(new_cards, copy)
                            copy:start_materialize(nil, nil)

                            -- Set random suit safely
                            local new_suit = suits[math.random(#suits)]
                            if SMODS.change_base then
                                SMODS.change_base(copy, new_suit)
                            end
                        end
                    end
                end

                -- Apply effects to all new cards
                if #new_cards > 0 then
                    playing_card_joker_effects(new_cards)
                end

                return true
            end
        }))
    end,
}


----------------------------------------------
------------SPLIT PERSONALITY CODE END----------------------

----------------------------------------------
------------POPCORN CODE BEGIN----------------------

SMODS.Consumable{
    key = 'Popcorn',
    set = 'Tarot',
    atlas = 'Jokers',
    pos = {x = 3, y = 21},
    loc_txt = {
        name = 'Popcorn',
        text = {
            'Split {C:mult}+20{} permanent Mult across {C:attention}all cards in hand{}',
        }
    },
    config = {
        extra = {}
    },
    loc_vars = function(self, info_queue, center)
        return {vars = {}}
    end,
    can_use = function(self, card)
        return G and G.hand and #G.hand.cards > 0
    end,
    use = function(self, card, area, copier)
        if G and G.hand and G.hand.cards and #G.hand.cards > 0 then
            local cards_in_hand = G.hand.cards
            local total = 20
            local num_cards = #cards_in_hand
            local base = math.floor(total / num_cards)
            local remainder = total - base * num_cards

            -- Shuffle so the leftover goes to random cards
            cards_in_hand = pseudoshuffle(G.hand.cards)

            for i, hand_card in ipairs(G.hand.cards) do
                local extra = (i <= remainder) and 1 or 0
                hand_card.ability.perma_mult = (hand_card.ability.perma_mult or 0) + base + extra

                G.E_MANAGER:add_event(Event({
                    func = function()
                        hand_card:juice_up()
                        return true
                    end
                }))
            end

            -- Optional: sound or popup feedback
            play_sound("tarot1")
        end
    end,
}


----------------------------------------------
------------POPCORN CODE END----------------------

----------------------------------------------
------------MIDAS TOUCH CODE BEGIN----------------------

SMODS.Consumable{
    key = 'Midas',
    set = 'Tarot',
    atlas = 'Jokers',
    pos = {x = 4, y = 21},
    loc_txt = {
        name = 'Midas Touch',
        text = {
            'Select up to {C:attention}#1#{} cards and destroy them',
            'Earn {C:money}$#2#{} for each card destroyed'
        }
    },
    config = {
        extra = {
            cards = 3, -- configurable value (default to 3 cards)
            money_per_card = 2, -- $2 per card destroyed
        },
    },
    loc_vars = function(self, info_queue, center)
        if center and center.ability and center.ability.extra then
            return {vars = {center.ability.extra.cards, center.ability.extra.money_per_card}} 
        end
        return {vars = {}}
    end,
    can_use = function(self, card)
        return G and G.hand and G.hand.highlighted and card.ability and card.ability.extra and 
            card.ability.extra.cards and #G.hand.highlighted > 0 and #G.hand.highlighted <= card.ability.extra.cards
    end,
    use = function(self, card, area, copier)
        -- Remove the selected cards in hand with redundancy
        if G and G.hand and G.hand.highlighted then
            local money_earned = 0

            for _, selected_card in ipairs(G.hand.highlighted) do
                selected_card:start_dissolve() -- Ensures visual effect of removal

                -- Ensure jokers properly process the removed card
                if selected_card.playing_card then
                    for j = 1, #G.jokers.cards do
                        eval_card(G.jokers.cards[j], {
                            cardarea = G.jokers,
                            remove_playing_cards = true,
                            removed = {selected_card}
                        })
                    end
                end

                -- Add money for each destroyed card
                money_earned = money_earned + (card.ability.extra.money_per_card or 0)
            end

            -- Use ease_dollars to add the money earned
            if money_earned > 0 then
                ease_dollars(money_earned)
                G.GAME.dollar_buffer = (G.GAME.dollar_buffer or 0) + money_earned
                G.E_MANAGER:add_event(Event({func = (function() 
                    G.GAME.dollar_buffer = 0
                    return true
                end)}))
            end
        end
    end,
}

----------------------------------------------
------------MIDAS TOUCH CODE END----------------------

----------------------------------------------
------------CURSED HAND CODE BEGIN----------------------

SMODS.Consumable{
    key = 'CursedHand',
    set = 'Tarot',
    atlas = 'Jokers',
    pos = {x = 0, y = 22},
    loc_txt = {
        name = 'Cursed Hand',
        text = {
            '{C:mult}Destroy{} {C:attention}all cards in hand{}',
            'Draw a new hand'
        }
    },
    config = {
        extra = {
            cards = 3, -- configurable value (default to 3 cards)
        },
    },
    loc_vars = function(self, info_queue, center)
        if center and center.ability and center.ability.extra then
            return {vars = {center.ability.extra.cards}} 
        end
        return {vars = {}}
    end,
    can_use = function(self, card)
        return G and G.hand and #G.hand.cards > 0
    end,
    use = function(self, card, area, copier)

        if G and G.hand then
            -- Destroy all cards in hand
            for _, selected_card in ipairs(G.hand.cards) do
                selected_card:start_dissolve() -- Ensures visual effect of removal

                -- Ensure jokers properly process the removed card
                if selected_card.playing_card then
                    for j = 1, #G.jokers.cards do
                        eval_card(G.jokers.cards[j], {
                            cardarea = G.jokers,
                            remove_playing_cards = true,
                            removed = {selected_card}
                        })
                    end
                end
            end

            -- Draw new cards to replace the destroyed ones
            if G.deck and #G.deck.cards > 0 then
                local draw_count = math.min(#G.hand.cards, #G.deck.cards) -- Draw the same number of cards as destroyed
                G.FUNCS.draw_from_deck_to_hand(draw_count)
            end
        end
    end,
}

----------------------------------------------
------------CURSED HAND CODE END----------------------

----------------------------------------------
------------BERRY CODE BEGIN----------------------

SMODS.Sound({
	key = "berry",
	path = "berry.ogg",
})

SMODS.Consumable {
    key = 'LTMBerry',
    set = 'LTMConsumableType',
    atlas = 'Jokers',
    pos = {x = 4, y = 22},
    cost = 0,
    loc_txt = {
        name = 'Slap Berry',
        text = {
			'People literally got {C:mult}banned{} for this like 2 weeks ago bruh',
			'Instantly win the current {C:attention}blind{}',
            '{C:green}1 in 6{} chance to {C:mult}instantly die{} instead',
            'returns to consumables on use',
        },
        use_msg = "You gained {chips} chips from the Slap Berry!",
        death_msg = "The Slap Berry backfired! You instantly lost!",
    },
    config = {
        extra = {chips = 0},
    },
    loc_vars = function(self, info_queue, center)
        local chips = center and center.ability and center.ability.extra.chips or 0
        return {vars = {math.floor(chips)}}
    end,
    can_use = function(self) 
        return G.STATE == G.STATES.SELECTING_HAND 
    end,
    use = function(self, card, area, copier)
        -- Play sound effect
        if config.sfx ~= false then
            play_sound("fn_berry")
        end
        
        -- 1 in 6 chance to instantly lose
        if pseudorandom("slap_berry_death") < (1 / 6) then
            G.E_MANAGER:add_event(Event({
                func = function()
                    G.STATE = G.STATES.GAME_OVER
                    G.STATE_COMPLETE = false
                    if config.sfx ~= false then
                        play_sound("fn_fuck")
                    end
                    return true
                end
            }))
            return {message = self.loc_txt.death_msg}
        end
        
        -- Get blind chips and award 100% of them
        local blind_chips = G.GAME.blind and G.GAME.blind.chips or 0
        G.GAME.chips = G.GAME.chips + blind_chips
        G.GAME.pool_flags.ltm_pizza_flag = true
        
        -- Apply juice effect
        (copier or card):juice_up()

        -- End the round immediately
        G.E_MANAGER:add_event(Event({
            trigger = "immediate",
            func = function()
                if G.STATE ~= G.STATES.SELECTING_HAND then
                    return false
                end
                G.STATE = G.STATES.HAND_PLAYED
                G.STATE_COMPLETE = true
                end_round()
                return true
            end,
        }), "other")
        
        -- Create a new Slap Berry consumable upon use
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.1,
            func = function()
                local _card = create_card('Tarot', G.consumeables, nil, nil, nil, nil, 'c_fn_LTMBerry')
                _card:add_to_deck()
                G.consumeables:emplace(_card)
                return {message = "A new Slap Berry appeared!"}
            end
        }))

        -- Return success message
        return {message = self.loc_txt.use_msg:gsub("{chips}", blind_chips)}
    end,
}

----------------------------------------------
------------BERRY CODE END----------------------

----------------------------------------------
------------HOP ROCK CODE BEGIN----------------------

SMODS.Consumable{
    key = 'LTMRock',
    set = 'LTMConsumableType',
    atlas = 'Jokers',
    pos = {x = 0, y = 26},
    loc_txt = {
        name = 'Hop Rock',
        text = {
            'Add a {C:planet}Hop Seal{} to {C:attention}#1#{} selected cards',
			'Idea: BoiRowan'
        }
    },
    config = {
        extra = {
            cards = 2, -- configurable value
        }
    },
    loc_vars = function(self, info_queue, center)
		info_queue[#info_queue + 1] = G.P_SEALS.fn_HopSeal
        if center and center.ability and center.ability.extra then
            return {vars = {center.ability.extra.cards}}
        end
        return {vars = {}}
    end,
    can_use = function(self, card)
        if G and G.hand and G.hand.highlighted and card.ability and card.ability.extra and card.ability.extra.cards then
            if #G.hand.highlighted > 0 and #G.hand.highlighted <= card.ability.extra.cards then
                return true
            end
        end
        return false
    end,
    use = function(self, card, area, copier)
		
		if config.sfx ~= false then
            play_sound("fn_hop")
        end
		
        for i, v in pairs(G.hand.highlighted) do
            -- Set a random seal using a guaranteed poll method
            v:set_seal('fn_HopSeal', true)

            -- Add an event to "juice up" the card after sealing
            G.E_MANAGER:add_event(Event({
                func = function()
                    v:juice_up(0.3, 0.4)
                    return true
                end
            }))
        end
    end,
}

----------------------------------------------
------------HOP ROCK CODE END----------------------

----------------------------------------------
------------NITRO SPLASH CODE BEGIN----------------------

SMODS.Sound({
	key = "nsplash",
	path = "nsplash.ogg",
})

SMODS.Consumable{
        key = 'LTMNSplash', -- key
        set = 'LTMConsumableType', -- the set of the card: corresponds to a consumable type
        atlas = 'Jokers', -- atlas
        pos = {x = 1, y = 26}, -- position in atlas
        loc_txt = {
            name = 'Nitro Splash', -- name of card
            text = { -- text of card
                'Apply {C:fn_nitro}Nitro{} to up to {C:attention}#1#{} selected cards',
				'Idea: BoiRowan'
            }
        },
        config = {
            extra = {
                cards = 2, -- configurable value
            }
        },
        loc_vars = function(self, info_queue, center)
            info_queue[#info_queue + 1] = G.P_CENTERS.e_fn_Nitro
            if center and center.ability and center.ability.extra then
                return {vars = {center.ability.extra.cards}} 
            end
            return {vars = {}}
        end,
        can_use = function(self, card)
            if G and G.hand and G.hand.highlighted and card.ability and card.ability.extra and card.ability.extra.cards then
                if #G.hand.highlighted > 0 and #G.hand.highlighted <= card.ability.extra.cards then
                    return true
                end
            end
            return false
        end,
        use = function(self, card, area, copier)
			
			if config.sfx ~= false then
				play_sound("fn_nsplash")
			end
		
            if G and G.hand and G.hand.highlighted then
                for i = 1, #G.hand.highlighted do
                    G.hand.highlighted[i]:set_edition({fn_Nitro = true},true)
                end
            end
        end,
    }

----------------------------------------------
------------NITRO SPLASH CODE END----------------------

----------------------------------------------
------------MINUTEMEN CODE BEGIN----------------------

SMODS.Sound({
	key = "ar",
	path = "ar.ogg",
})

if config.newcalccompat ~= false then
    SMODS.Consumable{
        key = 'Minutemen',
        set = 'Tarot',
        atlas = 'Jokers',
        pos = {x = 3, y = 27},
        loc_txt = {
            name = 'Minutemen',
            text = {
                'Convert up to {C:attention}#1#{} cards into {C:money}Medium Ammo{} cards',
                'Idea: BoiRowan',
            }
        },
        config = {
            extra = {
                cards = 2, -- configurable value
            }
        },
        loc_vars = function(self, info_queue, center)
            info_queue[#info_queue + 1] = G.P_CENTERS.m_fn_Medium
            if center and center.ability and center.ability.extra then
                return {vars = {center.ability.extra.cards + G.GAME.ammo_extra}} 
            end
            return {vars = {}}
        end,
        can_use = function(self, card)
            return G and G.hand and G.hand.highlighted and card.ability and card.ability.extra and 
                card.ability.extra.cards and #G.hand.highlighted > 0 and #G.hand.highlighted <= card.ability.extra.cards + G.GAME.ammo_extra
        end,
        use = function(self, card, area, copier)
            if G and G.hand and G.hand.highlighted and #G.hand.highlighted > 0 then
                for i = 1, #G.hand.highlighted do
                    local target_card = G.hand.highlighted[i]

                    -- Transform the card into a Wood card
                    target_card:set_ability(G.P_CENTERS.m_fn_Medium)
                    
                    if config.sfx ~= false then
                        play_sound("fn_ar")
                    end
                    
                    -- Add a juice-up effect for better feedback
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            target_card:juice_up()
                            return true
                        end
                    }))
                end
            end
        end,
    }
end


----------------------------------------------
------------MINUTEMEN CODE END----------------------

----------------------------------------------
------------BACKLINE CODE BEGIN----------------------

SMODS.Sound({
	key = "snip",
	path = "snip.ogg",
})
if config.newcalccompat ~= false then
SMODS.Consumable{
    key = 'Backline',
    set = 'Tarot',
    atlas = 'Jokers',
    pos = {x = 4, y = 27},
    loc_txt = {
        name = 'Backline',
        text = {
            'Convert up to {C:attention}#1#{} cards into {C:money}Heavy Ammo{} cards',
			'Idea: BoiRowan',
        }
    },
    config = {
        extra = {
            cards = 2, -- configurable value
        }
    },
    loc_vars = function(self, info_queue, center)
        info_queue[#info_queue + 1] = G.P_CENTERS.m_fn_Heavy
        if center and center.ability and center.ability.extra then
            return {vars = {center.ability.extra.cards + G.GAME.ammo_extra}} 
        end
        return {vars = {}}
    end,
    can_use = function(self, card)
        return G and G.hand and G.hand.highlighted and card.ability and card.ability.extra and 
            card.ability.extra.cards and #G.hand.highlighted > 0 and #G.hand.highlighted <= card.ability.extra.cards + G.GAME.ammo_extra
    end,
    use = function(self, card, area, copier)
        if G and G.hand and G.hand.highlighted and #G.hand.highlighted > 0 then
            for i = 1, #G.hand.highlighted do
                local target_card = G.hand.highlighted[i]

                -- Transform the card into a Wood card
                target_card:set_ability(G.P_CENTERS.m_fn_Heavy)

				if config.sfx ~= false then
					play_sound("fn_snip")
                end
				
                -- Add a juice-up effect for better feedback
                G.E_MANAGER:add_event(Event({
                    func = function()
                        target_card:juice_up()
                        return true
                    end
                }))
            end
        end
    end,
}
end
----------------------------------------------
------------BACKLINE CODE END----------------------

----------------------------------------------
------------FRONTLINE CODE BEGIN----------------------
if config.newcalccompat ~= false then
SMODS.Consumable{
    key = 'Frontline',
    set = 'Tarot',
    atlas = 'Jokers',
    pos = {x = 0, y = 28},
    loc_txt = {
        name = 'Frontline',
        text = {
            'Convert up to {C:attention}#1#{} cards into {C:mult}Shell Ammo{} cards',
			'Idea: BoiRowan',
        }
    },
    config = {
        extra = {
            cards = 2, -- configurable value
        }
    },
    loc_vars = function(self, info_queue, center)
        info_queue[#info_queue + 1] = G.P_CENTERS.m_fn_Shell
        if center and center.ability and center.ability.extra then
            return {vars = {center.ability.extra.cards + G.GAME.ammo_extra}} 
        end
        return {vars = {}}
    end,
    can_use = function(self, card)
        return G and G.hand and G.hand.highlighted and card.ability and card.ability.extra and 
            card.ability.extra.cards and #G.hand.highlighted > 0 and #G.hand.highlighted <= card.ability.extra.cards + G.GAME.ammo_extra
    end,
    use = function(self, card, area, copier)
        if G and G.hand and G.hand.highlighted and #G.hand.highlighted > 0 then
            for i = 1, #G.hand.highlighted do
                local target_card = G.hand.highlighted[i]

                -- Transform the card into a Wood card
                target_card:set_ability(G.P_CENTERS.m_fn_Shell)

				if config.sfx ~= false then
					play_sound("fn_pump")
                end
				
                -- Add a juice-up effect for better feedback
                G.E_MANAGER:add_event(Event({
                    func = function()
                        target_card:juice_up()
                        return true
                    end
                }))
            end
        end
    end,
}
end
----------------------------------------------
------------FRONTLINE CODE END----------------------

----------------------------------------------
------------FLANK CODE BEGIN----------------------

SMODS.Sound({
	key = "smg",
	path = "smg.ogg",
})
if config.newcalccompat ~= false then
SMODS.Consumable{
    key = 'Flank',
    set = 'Tarot',
    atlas = 'Jokers',
    pos = {x = 1, y = 28},
    loc_txt = {
        name = 'Flank',
        text = {
            'Convert up to {C:attention}#1#{} cards into {C:money}Light Ammo{} cards',
			'Idea: BoiRowan',
        }
    },
    config = {
        extra = {
            cards = 2, -- configurable value
        }
    },
    loc_vars = function(self, info_queue, center)
        info_queue[#info_queue + 1] = G.P_CENTERS.m_fn_Light
        if center and center.ability and center.ability.extra then
            return {vars = {center.ability.extra.cards + G.GAME.ammo_extra}} 
        end
        return {vars = {}}
    end,
    can_use = function(self, card)
        return G and G.hand and G.hand.highlighted and card.ability and card.ability.extra and 
            card.ability.extra.cards and #G.hand.highlighted > 0 and #G.hand.highlighted <= card.ability.extra.cards + G.GAME.ammo_extra
    end,
    use = function(self, card, area, copier)
        if G and G.hand and G.hand.highlighted and #G.hand.highlighted > 0 then
            for i = 1, #G.hand.highlighted do
                local target_card = G.hand.highlighted[i]

                -- Transform the card into a Wood card
                target_card:set_ability(G.P_CENTERS.m_fn_Light)
				
				if config.sfx ~= false then
					play_sound("fn_smg")
                end
				
                -- Add a juice-up effect for better feedback
                G.E_MANAGER:add_event(Event({
                    func = function()
                        target_card:juice_up()
                        return true
                    end
                }))
            end
        end
    end,
}
end
----------------------------------------------
------------FLANK CODE END----------------------

----------------------------------------------
------------ARTILLERY CODE END----------------------
if config.newcalccompat ~= false then
SMODS.Consumable{
    key = 'Artillery',
    set = 'Tarot',
    atlas = 'Jokers',
    pos = {x = 2, y = 28},
    loc_txt = {
        name = 'Artillery',
        text = {
            'Convert up to {C:attention}#1#{} cards into {C:green}Rocket Ammo{} cards',
			'Idea: BoiRowan',
        }
    },
    config = {
        extra = {
            cards = 2, -- configurable value
        }
    },
    loc_vars = function(self, info_queue, center)
        info_queue[#info_queue + 1] = G.P_CENTERS.m_fn_Rocket
        if center and center.ability and center.ability.extra then
            return {vars = {center.ability.extra.cards + G.GAME.ammo_extra}} 
        end
        return {vars = {}}
    end,
    can_use = function(self, card)
        return G and G.hand and G.hand.highlighted and card.ability and card.ability.extra and 
            card.ability.extra.cards and #G.hand.highlighted > 0 and #G.hand.highlighted <= card.ability.extra.cards + G.GAME.ammo_extra
    end,
    use = function(self, card, area, copier)
        if G and G.hand and G.hand.highlighted and #G.hand.highlighted > 0 then
            for i = 1, #G.hand.highlighted do
                local target_card = G.hand.highlighted[i]

                -- Transform the card into a Wood card
                target_card:set_ability(G.P_CENTERS.m_fn_Rocket)

				if config.sfx ~= false then
					play_sound("fn_clinger")
                end
				
                -- Add a juice-up effect for better feedback
                G.E_MANAGER:add_event(Event({
                    func = function()
                        target_card:juice_up()
                        return true
                    end
                }))
            end
        end
    end,
}
end
----------------------------------------------
------------ARTILLERY CODE END----------------------

----------------------------------------------
------------AMMO BOX CODE BEGIN----------------------
if config.newcalccompat ~= false then
SMODS.Consumable{
    key = 'LTMAmmo',
    set = 'LTMConsumableType',
    atlas = 'Jokers',
    pos = {x = 3, y = 28},
    loc_txt = {
        name = 'Ammo Box',
        text = {
            'Convert all cards in hand into random {C:money}A{}{C:mult}m{}{C:green}m{}{C:money}o{} Cards',
        }
    },
	
    can_use = function(self, card)
        -- Can only use when there are cards in hand
        return G and G.hand and #G.hand.cards > 0
    end,
    use = function(self, card, area, copier)
        if config.sfx ~= false then
            play_sound("fn_perk")
        end

        local allowed_enhancements = {
            'm_fn_Medium',
            'm_fn_Heavy',
            'm_fn_Light',
            'm_fn_Shell',
            'm_fn_Rocket'
        }

        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.1,
            func = function()
                if G and G.hand and G.hand.cards then
                    for _, hand_card in ipairs(G.hand.cards) do
                        local enhancement_key = pseudorandom_element(allowed_enhancements)
                        local enhancement = G.P_CENTERS[enhancement_key]

                        if enhancement then
                            hand_card:set_ability(enhancement, true)

                            G.E_MANAGER:add_event(Event({
                                func = function()
                                    hand_card:juice_up()
                                    return true
                                end
                            }))
                        end
                    end
                end
                return true
            end
        }))
    end,
}
end
----------------------------------------------
------------AMMO BOX CODE END----------------------

----------------------------------------------
------------COSMIC SWINE CODE BEGIN----------------------

SMODS.Consumable{
    key = 'Swine',
    set = 'Tarot',
    atlas = 'Jokers',
    pos = {x = 0, y = 29},
    loc_txt = {
        name = 'Cosmic Swine',
        text = {
            'Create {C:attention}1{} {C:planet}Planet{} card for your {C:attention}most used{} hand',
            '{C:inactive}(Must have room)'
        }
    },
    config = {
        extra = {
            cards = 1, -- number of Planet cards to create
        }
    },
    loc_vars = function(self, info_queue, center)
        if center and center.ability and center.ability.extra then
            return {vars = {center.ability.extra.cards}}
        end
        return {vars = {}}
    end,
    can_use = function(self, card)
        return true
    end,
    use = function(self, card, area, copier)
        local amount = self.config.extra.cards or 1

        -- Check if there's enough space
        if #G.consumeables.cards + G.GAME.consumeable_buffer > G.consumeables.config.card_limit then
            return
        end

        -- Find most played visible hand
        local tempuse = 0
        local hand = nil
        for k, v in pairs(G.GAME.hands) do
            if v.played > tempuse and v.visible then
                tempuse = v.played
                hand = k
            end
        end

        -- For each card to create
        for i = 1, amount do
            -- Check again if there's still room
            if #G.consumeables.cards + G.GAME.consumeable_buffer >= G.consumeables.config.card_limit then
                break
            end

            local card_type = 'Planet'
            G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1

            G.E_MANAGER:add_event(Event({
                trigger = 'before',
                delay = 0.0,
                func = function()
                    local _planet = nil

                    -- Look for matching Planet by hand type
                    for k, v in pairs(G.P_CENTER_POOLS.Planet) do
                        if hand and v.config and v.config.hand_type == hand then
                            _planet = v.key
                            break
                        end
                    end

                    -- Fallback if no matching planet (random planet)
                    if not _planet then
                        local pool = G.P_CENTER_POOLS.Planet
                        _planet = pseudorandom_element(pool, pseudoseed('cosmic_swine_fallback')).key
                    end

                    -- Create the planet card
                    local new_card = create_card(card_type, G.consumeables, nil, nil, nil, nil, _planet, nil)
                    new_card:add_to_deck()
                    G.consumeables:emplace(new_card)
                    G.GAME.consumeable_buffer = G.GAME.consumeable_buffer - 1

                    return true
                end
            }))
        end
    end,
}

----------------------------------------------
------------COSMIC SWINE CODE END----------------------

----------------------------------------------
------------ZERO POINT FISH CODE BEGIN----------------------

SMODS.Consumable{
    key = 'LTMZFish',
    set = 'LTMConsumableType',
    atlas = 'Jokers',
    pos = {x = 2, y = 29},
    loc_txt = {
        name = 'Zero Point Fish',
        text = {
            'Add a {C:planet}Zero Point Seal{} to {C:attention}#1#{} selected cards',
			'Idea: BoiRowan'
        }
    },
    config = {
        extra = {
            cards = 2, -- configurable value
        }
    },
    loc_vars = function(self, info_queue, center)
		info_queue[#info_queue + 1] = G.P_SEALS.fn_ZeroSeal
        if center and center.ability and center.ability.extra then
            return {vars = {center.ability.extra.cards}}
        end
        return {vars = {}}
    end,
    can_use = function(self, card)
        if G and G.hand and G.hand.highlighted and card.ability and card.ability.extra and card.ability.extra.cards then
            if #G.hand.highlighted > 0 and #G.hand.highlighted <= card.ability.extra.cards then
                return true
            end
        end
        return false
    end,
    use = function(self, card, area, copier)
		
		if config.sfx ~= false then
            play_sound("fn_rift")
        end
		
        for i, v in pairs(G.hand.highlighted) do
            -- Set a random seal using a guaranteed poll method
            v:set_seal('fn_ZeroSeal', true)

            -- Add an event to "juice up" the card after sealing
            G.E_MANAGER:add_event(Event({
                func = function()
                    v:juice_up(0.3, 0.4)
                    return true
                end
            }))
        end
    end,
}

----------------------------------------------
------------ZERO POINT FISH CODE END----------------------

----------------------------------------------
------------CLINGER CODE BEGIN----------------------

SMODS.Sound({
	key = "clinger",
	path = "clinger.ogg",
})

SMODS.Consumable {
    key = 'LTMClinger',
    set = 'LTMConsumableType',
    atlas = 'Jokers',
    pos = {x = 3, y = 29},
    loc_txt = {
        name = 'Clinger',
        text = {
            'Select up to {C:attention}#1#{} cards to {C:mult}destroy{}',
            'Adjacent cards have a {C:green}#3# in #2# chance{} to be {C:mult}destroyed{}',
			'Idea: BoiRowan'
        },
    },
    config = {
        extra = {
            cards = 2, -- max number of cards you can select
            odds = 2,  -- 1 in 2 chance (50%) to destroy adjacent cards
        },
    },

    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.extra.cards,
                card.ability.extra.odds,
                '' .. (G.GAME and G.GAME.probabilities.normal or 1),
            }
        }
    end,

    can_use = function(self, card)
        return G and G.hand and G.hand.highlighted and card.ability and card.ability.extra and
            card.ability.extra.cards and #G.hand.highlighted > 0 and #G.hand.highlighted <= card.ability.extra.cards
    end,

    use = function(self, card, area, copier)
        if config.sfx ~= false then
            play_sound("fn_clinger")
        end

        if G and G.hand and G.hand.highlighted then
            for _, selected_card in ipairs(G.hand.highlighted) do
                selected_card:start_dissolve()

                -- Find left and right cards like Zorlodo does
                local left_card, right_card
                for i = 1, #G.hand.cards do
                    if G.hand.cards[i] == selected_card then
                        left_card = G.hand.cards[i-1]
                        right_card = G.hand.cards[i+1]
                        break
                    end
                end

                -- Try to destroy left card
                if left_card and not left_card.debuff then
                    if pseudorandom('clinger') < G.GAME.probabilities.normal/card.ability.extra.odds then
                        left_card:start_dissolve()
                    end
                end

                -- Try to destroy right card
                if right_card and not right_card.debuff then
                    if pseudorandom('clinger') < G.GAME.probabilities.normal/card.ability.extra.odds then
                        right_card:start_dissolve()
                    end
                end

                -- Evaluate Joker triggers for each selected card
                if selected_card.playing_card then
                    for j = 1, #G.jokers.cards do
                        eval_card(G.jokers.cards[j], {
                            cardarea = G.jokers,
                            remove_playing_cards = true,
                            removed = {selected_card}
                        })
                    end
                end
            end
        end
    end,
}

----------------------------------------------
------------CLINGER CODE END----------------------

----------------------------------------------
------------GRENADE CODE BEGIN----------------------

SMODS.Consumable {
    key = 'LTMGrenade',
    set = 'LTMConsumableType',
    atlas = 'Jokers',
    pos = {x = 4, y = 29},
    loc_txt = {
        name = 'Grenade',
        text = {
            'Select up to {C:attention}#1#{} cards',
            'Selected and adjacent cards have a {C:green}#3# in #2# chance{} to be {C:mult}destroyed{}',
            'Idea: BoiRowan'
        },
    },
    config = {
        extra = {
            cards = 3, -- max number of cards you can select
            odds = 2,  -- 1 in 2 chance (50%) to destroy adjacent cards
        },
    },

    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.extra.cards,
                card.ability.extra.odds,
                '' .. (G.GAME and G.GAME.probabilities.normal or 1),
            }
        }
    end,

    can_use = function(self, card)
        return G and G.hand and G.hand.highlighted and card.ability and card.ability.extra and
            card.ability.extra.cards and #G.hand.highlighted > 0 and #G.hand.highlighted <= card.ability.extra.cards
    end,

    use = function(self, card, area, copier)
        if config.sfx ~= false then
            play_sound("fn_clinger")
        end

        if G and G.hand and G.hand.highlighted then
            for _, selected_card in ipairs(G.hand.highlighted) do
                -- 1/2 chance for the selected card to be destroyed
                if pseudorandom('clinger') < G.GAME.probabilities.normal/card.ability.extra.odds then
                    selected_card:start_dissolve()
                end

                -- Find left and right cards like Zorlodo does
                local left_card, right_card
                for i = 1, #G.hand.cards do
                    if G.hand.cards[i] == selected_card then
                        left_card = G.hand.cards[i-1]
                        right_card = G.hand.cards[i+1]
                        break
                    end
                end

                -- Try to destroy left card
                if left_card and not left_card.debuff then
                    if pseudorandom('clinger') < G.GAME.probabilities.normal/card.ability.extra.odds then
                        left_card:start_dissolve()
                    end
                end

                -- Try to destroy right card
                if right_card and not right_card.debuff then
                    if pseudorandom('clinger') < G.GAME.probabilities.normal/card.ability.extra.odds then
                        right_card:start_dissolve()
                    end
                end

                -- Evaluate Joker triggers for each selected card
                if selected_card.playing_card then
                    for j = 1, #G.jokers.cards do
                        eval_card(G.jokers.cards[j], {
                            cardarea = G.jokers,
                            remove_playing_cards = true,
                            removed = {selected_card}
                        })
                    end
                end
            end
        end
    end,
}

----------------------------------------------
------------GRENADE CODE END----------------------

----------------------------------------------
------------SHADY DEAL CODE BEGIN----------------------

SMODS.Consumable{
    key = 'Shady',
    set = 'Tarot',
    atlas = 'Jokers',
    pos = {x = 3, y = 33},
    loc_txt = {
        name = 'Shady Deal',
        text = {
            'Select up to {C:attention}#1#{} cards',
            'Earn {C:money}money{} equal to {C:attention}a third{} of their {C:chips}Chip{} value',
			'Idea: {C:inactive}kxttyfrickfish',
        }
    },
    config = {
        extra = {
            cards = 3, -- Configurable value (default to 3 cards)
        },
    },
    loc_vars = function(self, info_queue, center)
        if center and center.ability and center.ability.extra then
            return {vars = {center.ability.extra.cards}} 
        end
        return {vars = {}}
    end,
    
    can_use = function(self, card)
        return G and G.hand and G.hand.highlighted and card.ability and card.ability.extra and 
            card.ability.extra.cards and #G.hand.highlighted > 0 and #G.hand.highlighted <= card.ability.extra.cards
    end,
    
    use = function(self, card, area, copier)
        if G and G.hand and G.hand.highlighted then
            local money_earned = 0

            for _, selected_card in ipairs(G.hand.highlighted) do
				local chip_value = 0
				
                if selected_card.config.center == G.P_CENTERS.m_stone or selected_card.config.center == G.P_CENTERS.m_fn_Crystal then
                    chip_value = chip_value + 50
				end
				
				if selected_card.config.center == G.P_CENTERS.m_fn_Wood then
					chip_value = chip_value + 15 + SMODS.Ranks[selected_card.base.value].nominal or 0
				end
				
				if selected_card.config.center == G.P_CENTERS.m_fn_Brick then
					chip_value = chip_value + 40 + SMODS.Ranks[selected_card.base.value].nominal or 0
				end
				
				if selected_card.config.center == G.P_CENTERS.m_fn_Metal then
					chip_value = chip_value + 60 + SMODS.Ranks[selected_card.base.value].nominal or 0
				end
				
				if selected_card.config.center == G.P_CENTERS.m_fn_StormSurge then
					chip_value = chip_value + 100 + SMODS.Ranks[selected_card.base.value].nominal or 0
				end
				
				if selected_card.config.center == G.P_CENTERS.m_fn_Light then
					chip_value = chip_value + 75 + SMODS.Ranks[selected_card.base.value].nominal or 0
				end
				
				if selected_card.config.center ~= G.P_CENTERS.m_stone and selected_card.config.center ~= G.P_CENTERS.m_fn_Crystal and selected_card.config.center ~= G.P_CENTERS.m_fn_Wood and selected_card.config.center ~= G.P_CENTERS.m_fn_Brick and selected_card.config.center ~= G.P_CENTERS.m_fn_Metal and selected_card.config.center ~= G.P_CENTERS.m_fn_StormSurge and selected_card.config.center ~= G.P_CENTERS.m_fn_Light then
					chip_value = SMODS.Ranks[selected_card.base.value] and SMODS.Ranks[selected_card.base.value].nominal or 0
                end

                -- Earn a third of this value as money (rounded down)
                money_earned = money_earned + math.ceil(chip_value / 3)
            end

            -- Add the earned money to the player
            if money_earned > 0 then
                ease_dollars(money_earned)
                G.GAME.dollar_buffer = (G.GAME.dollar_buffer or 0) + money_earned
            end
        end
    end,
}

----------------------------------------------
------------SHADY DEAL CODE END----------------------

----------------------------------------------
------------SHOCKWAVE GRENADE CODE BEGIN----------------------

SMODS.Sound({
	key = "shockwave",
	path = "shockwave.ogg",
})

SMODS.Consumable{
        key = 'LTMShockwave', -- key
        set = 'LTMConsumableType', -- the set of the card: corresponds to a consumable type
        atlas = 'Jokers', -- atlas
        pos = {x = 3, y = 30}, -- position in atlas
		rarity = 3,
        loc_txt = {
            name = 'Shockwave Grenade', -- name of card
            text = { -- text of card
                'Apply {C:fn_shockwaved}Shockwaved{} to up to {C:attention}#1#{} selected cards',
				'Idea: BoiRowan'
            }
        },
        config = {
            extra = {
                cards = 2, -- configurable value
            }
        },
        loc_vars = function(self, info_queue, center)
            info_queue[#info_queue + 1] = G.P_CENTERS.e_fn_Shockwaved
            if center and center.ability and center.ability.extra then
                return {vars = {center.ability.extra.cards}} 
            end
            return {vars = {}}
        end,
        can_use = function(self, card)
            if G and G.hand and G.hand.highlighted and card.ability and card.ability.extra and card.ability.extra.cards then
                if #G.hand.highlighted > 0 and #G.hand.highlighted <= card.ability.extra.cards then
                    return true
                end
            end
            return false
        end,
        use = function(self, card, area, copier)
			
			if config.sfx ~= false then
				play_sound("fn_shockwave")
			end
		
            if G and G.hand and G.hand.highlighted then
                for i = 1, #G.hand.highlighted do
                    G.hand.highlighted[i]:set_edition({fn_Shockwaved = true},true)
                end
            end
        end,
    }

----------------------------------------------
------------SHOCKWAVE GRENADE CODE END----------------------

----------------------------------------------
------------BOOGIE BOMB CODE BEGIN----------------------

SMODS.Consumable{
    key = 'LTMBoogie',
    set = 'LTMConsumableType',
    atlas = 'Jokers',
    pos = {x = 0, y = 31},
    loc_txt = {
        name = 'Boogie Bomb',
        text = {
            'Add a {C:fn_boogie}Boogie Seal{} to {C:attention}#1#{} selected cards',
        }
    },
    config = {
        extra = {
            cards = 2, -- configurable value
        }
    },
    loc_vars = function(self, info_queue, center)
		info_queue[#info_queue + 1] = G.P_SEALS.fn_BoogieSeal
        if center and center.ability and center.ability.extra then
            return {vars = {center.ability.extra.cards}}
        end
        return {vars = {}}
    end,
    can_use = function(self, card)
        if G and G.hand and G.hand.highlighted and card.ability and card.ability.extra and card.ability.extra.cards then
            if #G.hand.highlighted > 0 and #G.hand.highlighted <= card.ability.extra.cards then
                return true
            end
        end
        return false
    end,
    use = function(self, card, area, copier)
		
		if config.sfx ~= false then
            play_sound("fn_boogie")
        end
		
        for i, v in pairs(G.hand.highlighted) do
            -- Set a random seal using a guaranteed poll method
            v:set_seal('fn_BoogieSeal', true)

            -- Add an event to "juice up" the card after sealing
            G.E_MANAGER:add_event(Event({
                func = function()
                    v:juice_up(0.3, 0.4)
                    return true
                end
            }))
        end
    end,
}

----------------------------------------------
------------BOOGIE BOMB CODE END----------------------

----------------------------------------------
------------FORECAST TOWER CODE BEGIN----------------------

SMODS.Consumable{
    key = 'LTMForecast',
    set = 'LTMConsumableType',
    atlas = 'Jokers',
    pos = {x = 1, y = 31},
    loc_txt = {
        name = 'Forecast Tower',
        text = {
            'Add a {C:purple}Storm Seal{} to {C:attention}#1#{} selected cards',
        }
    },
    config = {
        extra = {
            cards = 1, -- configurable value
        }
    },
    loc_vars = function(self, info_queue, center)
		info_queue[#info_queue + 1] = G.P_SEALS.fn_StormSeal
        if center and center.ability and center.ability.extra then
            return {vars = {center.ability.extra.cards}}
        end
        return {vars = {}}
    end,
    can_use = function(self, card)
        if G and G.hand and G.hand.highlighted and card.ability and card.ability.extra and card.ability.extra.cards then
            if #G.hand.highlighted > 0 and #G.hand.highlighted <= card.ability.extra.cards then
                return true
            end
        end
        return false
    end,
    use = function(self, card, area, copier)

		
        for i, v in pairs(G.hand.highlighted) do
            -- Set a random seal using a guaranteed poll method
            v:set_seal('fn_StormSeal', true)

            -- Add an event to "juice up" the card after sealing
            G.E_MANAGER:add_event(Event({
                func = function()
                    v:juice_up(0.3, 0.4)
                    return true
                end
            }))
        end
    end,
}

----------------------------------------------
------------FORECAST TOWER CODE END----------------------

----------------------------------------------
------------KEY CODE BEGIN----------------------

SMODS.Consumable {
    key = 'LTMKey', -- key
    set = 'LTMConsumableType', -- the set of the card: corresponds to a consumable type
    atlas = 'Jokers', -- atlas
    pos = {x = 3, y = 32}, -- position in atlas
    loc_txt = {
        name = 'Key', -- name of card
        text = { -- text of card
            'Remove {C:fn_eternal}Eternal{} from {C:attention}#1#{} selected Jokers',
        }
    },
    config = {
        extra = {
            cards = 1, -- configurable value
        }
    },
    loc_vars = function(self, info_queue, center)
        if center and center.ability and center.ability.extra then
            return {vars = {center.ability.extra.cards}} 
        end
        return {vars = {}}
    end,
    can_use = function(self, card)
        if G and card.ability and card.ability.extra and card.ability.extra.cards then
            local maxCards = card.ability.extra.cards
            local highlightedCardsCount = 0

            -- Count highlighted Jokers
            highlightedCardsCount = highlightedCardsCount + #G.jokers.highlighted

            -- Check if the highlighted cards are within the allowed limit
            if highlightedCardsCount > 0 and highlightedCardsCount <= maxCards then
                return true
            end
        end
        return false
    end,
    use = function(self, card, area, copier)
        local highlightedCards = {}  -- Collect all the highlighted jokers

        -- Add selected jokers from the highlighted list
        for _, joker in ipairs(G.jokers.highlighted) do
            table.insert(highlightedCards, joker)
        end

        -- Remove the Eternal status from the selected jokers only
        for i = 1, math.min(#highlightedCards, card.ability.extra.cards) do
            local jokerToModify = highlightedCards[i]
            -- Remove the Eternal status from the joker
            jokerToModify:set_eternal(nil)
        end
    end,
}

----------------------------------------------
------------KEY CODE END----------------------

----------------------------------------------
------------BOOKS CODE BEGIN----------------------

SMODS.Consumable{
    key = 'Books',
    set = 'Tarot',
    atlas = 'Jokers',
    pos = {x = 1, y = 34},
    loc_txt = {
        name = 'Patchwork Grimoire',
        text = {
            'Select up to {C:attention}#1#{} cards',
            'Give them {C:mult}Red Seal{} and {C:fn_perishable}Perishable',
			'Idea: {C:inactive}kxttyfrickfish',
        }
    },
    config = {
        extra = {
            cards = 2, -- Configurable value (default to 3 cards)
        },
    },
    loc_vars = function(self, info_queue, center)
		info_queue[#info_queue + 1] = G.P_SEALS.Red
		info_queue[#info_queue + 1] = { key = "perishable", set = "Other", vars = { 5 } }
        if center and center.ability and center.ability.extra then
            return {vars = {center.ability.extra.cards}} 
        end
        return {vars = {}}
    end,
    
    can_use = function(self, card)
        return G and G.hand and G.hand.highlighted and card.ability and card.ability.extra and 
            card.ability.extra.cards and #G.hand.highlighted > 0 and #G.hand.highlighted <= card.ability.extra.cards
    end,
    
    use = function(self, card, area, copier)
        if G and G.hand and G.hand.highlighted then

            for i, v in pairs(G.hand.highlighted) do
            -- Set a red seal
				v:set_seal('Red', true)
				v:add_sticker("perishable", true)
            end
        end
    end,
}

----------------------------------------------
------------BOOKS CODE END----------------------

----------------------------------------------
------------FACE CODE BEGIN----------------------

SMODS.Consumable{
    key = 'Face',
    set = 'Tarot',
    atlas = 'Jokers',
    pos = {x = 4, y = 34},
    loc_txt = {
        name = 'New Heir',
        text = {
            'Select up to {C:attention}#1#{} cards',
            'Turn them into {C:attention}Face Cards',
            'Idea: {C:inactive}kxttyfrickfish',
        }
    },
    config = {
        extra = {
            cards = 2, -- Configurable value (default to 2 cards)
        },
    },
    loc_vars = function(self, info_queue, center)
        if center and center.ability and center.ability.extra then
            return {vars = {center.ability.extra.cards}} 
        end
        return {vars = {}}
    end,
    
    can_use = function(self, card)
        if G and G.hand and G.hand.highlighted and card.ability and card.ability.extra then
            local max_cards = card.ability.extra.cards
            return #G.hand.highlighted > 0 and #G.hand.highlighted <= max_cards
        end
        return false
    end,
    
    use = function(self, card, area, copier)
        if G and G.hand and G.hand.highlighted then
            for i = 1, #G.hand.highlighted do
                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    delay = 0.1 * i,
                    func = function()
                        local card = G.hand.highlighted[i]
                        
                        -- Flip the card
                        card:flip()
                        play_sound("tarot1", 1.0, 0.6)
                        card:juice_up(0.3, 0.3)
                        
                        -- Delay for unflipping and transforming to a face card
                        G.E_MANAGER:add_event(Event({
                            trigger = 'after',
                            delay = 0.3, -- Slight delay for the unflip
                            func = function()
                                card:flip() -- Unflip to reveal the transformation
                                
                                local face_ranks = {"J", "Q", "K"} -- Possible face cards
                                local selected_face = face_ranks[math.random(#face_ranks)] -- Randomly select a face

                                -- Change card to the selected face card of its current suit
                                local suit_prefix = string.sub(card.base.suit, 1, 1)..'_'
                                card:set_base(G.P_CARDS[suit_prefix..selected_face])

                                play_sound("tarot2", 1.0, 0.6)
                                card:juice_up(0.3, 0.3)
                                return true
                            end
                        }))
                        return true
                    end
                }))
            end
        end
    end,
}

----------------------------------------------
------------FACE CODE END----------------------

----------------------------------------------
------------MOSHPIT CODE BEGIN----------------------

SMODS.Consumable{
    key = 'Moshpit',
    set = 'Tarot',
    atlas = 'Jokers',
    pos = {x = 0, y = 35},
    loc_txt = {
        name = 'Metal Moshpit',
        text = {
            'Select up to {C:attention}#1#{} cards',
            'If they have an {C:enhanced}Enhancement{}',
			'Replace it with {C:inactive}Steel',
            'Idea: {C:inactive}kxttyfrickfish',
        }
    },
    config = {
        extra = {
            cards = 3, -- configurable value
        }
    },
    loc_vars = function(self, info_queue, center)
        info_queue[#info_queue + 1] = G.P_CENTERS.m_steel
        if center and center.ability and center.ability.extra then
            return {vars = {center.ability.extra.cards}} 
        end
        return {vars = {}}
    end,
    
    can_use = function(self, card)
        return G and G.hand and G.hand.highlighted and card.ability and card.ability.extra and 
            card.ability.extra.cards and #G.hand.highlighted > 0 and #G.hand.highlighted <= card.ability.extra.cards
    end,
    
    use = function(self, card, area, copier)
        if G and G.hand and G.hand.highlighted and #G.hand.highlighted > 0 then
            for i = 1, #G.hand.highlighted do
                local target_card = G.hand.highlighted[i]

                -- Check if the card has an enhancement (not base)
                if target_card.config.center and target_card.config.center ~= G.P_CENTERS.c_base then
                    -- Replace existing enhancement with Steel
                    target_card:set_ability(G.P_CENTERS.m_steel)
                end

                -- feedback for each transformed card
                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    delay = 0.1 * i, -- slight staggered effect for each card
                    func = function()
                        target_card:juice_up(0.3, 0.3)
                        return true
                    end
                }))
            end
        end
    end,
}

----------------------------------------------
------------MOSHPIT CODE END----------------------

----------------------------------------------
------------LOOT LLAMA CODE BEGIN----------------------

SMODS.Consumable {
    key = 'LootLlama',
    set = 'Tarot',
    atlas = 'Jokers',
    pos = {x = 3, y = 35},
    cost = 6,
    loc_txt = {
        name = 'Loot Llama',
        text = {
            'Create {C:attention}#1#{} random {C:purple}Fortlatro{} Jokers{}',
			'{C:inactive}(Must have room)',
        }
    },
    config = {
        extra = {
            jokers = 1, -- Default to 1 joker
        },
    },

    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.extra.jokers,
            }
        }
    end,

    can_use = function(self, card)
        if #G.jokers.cards < G.jokers.config.card_limit then
            return true
		end
    end,

    use = function(self, card, area, copier)
		
		if config.sfx ~= false then
            play_sound("fn_chest")
        end

        local fortlatro_jokers = {
            'j_fn_Eric', 'j_fn_Crac', 'j_fn_Emily', 'j_fn_Toilet', 'j_fn_Toilet', 'j_fn_TheDub', 'j_fn_TheDub', 'j_fn_TheDub', 'j_fn_FlushFactory', 'j_fn_FlushFactory',
            'j_fn_VictoryCrown', 'j_fn_VictoryCrown', 'j_fn_Peely', 'j_fn_Peely', 'j_fn_Zorlodo', 'j_fn_SolidGold', 'j_fn_SolidGold', 'j_fn_SolidGold', 'j_fn_BattleBus', 'j_fn_BattleBus', 'j_fn_BattleBus', 'j_fn_SaveTheWorld',
            'j_fn_ChugJug', 'j_fn_ChugJug', 'j_fn_BigPot', 'j_fn_BigPot', 'j_fn_BigPot', 'j_fn_Mini', 'j_fn_Mini', 'j_fn_Mini', 'j_fn_Vbucks', 'j_fn_Vbucks', 'j_fn_Vbucks', 'j_fn_Augment', 'j_fn_BluGlo', 'j_fn_BluGlo', 'j_fn_BluGlo',
            'j_fn_RebootCard', 'j_fn_Oscar', 'j_fn_Oscar', 'j_fn_Oscar', 'j_fn_Montague', 'j_fn_Montague', 'j_fn_MagmaReef', 'j_fn_DurrBurger', 'j_fn_DurrBurger', 'j_fn_DurrBurger', 'j_fn_AcesWild',
            'j_fn_Miku', 'j_fn_Bench', 'j_fn_Bench', 'j_fn_Bench', 'j_fn_Nothing', 'j_fn_Nothing', 'j_fn_Nothing', 'j_fn_Flip', 'j_fn_Flip', 'j_fn_Flip', 'j_fn_MVM', 'j_fn_MVM', 'j_fn_Thanos', 'j_fn_Racing', 'j_fn_Racing', 'j_fn_Racing',
            'j_fn_50v50', 'j_fn_50v50', 'j_fn_50v50', 'j_fn_DoublePump', 'j_fn_DoublePump', 'j_fn_Festival', 'j_fn_Festival', 'j_fn_KineticBlade', 'j_fn_KineticBlade', 'j_fn_Kado', 'j_fn_TyphoonBlade',
            'j_fn_Kane', 'j_fn_Kane', 'j_fn_DB', 'j_fn_DB', 'j_fn_Vulture', 'j_fn_Vulture', 'j_fn_Vulture', 'j_fn_CassidyQuinn', 'j_fn_CassidyQuinn', 'j_fn_Termite', 'j_fn_Termite', 'j_fn_Termite', 'j_fn_Shadow', 'j_fn_Shadow', 'j_fn_Ghost', 'j_fn_Ghost',
            'j_fn_BattleLab', 'j_fn_Tent', 'j_fn_Tent', 'j_fn_Cart', 'j_fn_Cart', 'j_fn_Cart', 'j_fn_Vault', 'j_fn_Vault', 'j_fn_Vault', 'j_fn_Fishing', 'j_fn_Fishing', 'j_fn_Fishing', 'j_fn_Slurp', 'j_fn_Slurp', 'j_fn_Slurp', 'j_fn_Lava', 'j_fn_Lava', 'j_fn_Lava',
            'j_fn_ATK', 'j_fn_ATK', 'j_fn_ATK', 'j_fn_Aimbot', 'j_fn_BetterAimbot', 'j_fn_Skibidi', 'j_fn_Skibidi', 'j_fn_Bots', 'j_fn_Bots', 'j_fn_Bots', 'j_fn_NickEh30', 'j_fn_NickEh30', 'j_fn_NickEh30', 'j_fn_RiftGun',
            'j_fn_Rabbit', 'j_fn_Fox', 'j_fn_Llama', 'j_fn_Rabbit', 'j_fn_Fox', 'j_fn_Llama', 'j_fn_Hide', 'j_fn_Hide', 'j_fn_Cubert', 'j_fn_Cubert', 'j_fn_ShadowSeries', 'j_fn_ShadowSeries', 'j_fn_ShadowSeries', 'j_fn_Unvaulting', 'j_fn_Unvaulting',
            'j_fn_Jar', 'j_fn_Jar', 'j_fn_Fashion', 'j_fn_Fashion', 'j_fn_Control', 'j_fn_BP', 'j_fn_IBlade', 'j_fn_Default', 'j_fn_Recon', 'j_fn_Default', 'j_fn_Recon',
            'j_fn_Whiplash', 'j_fn_Whiplash', 'j_fn_Whiplash', 'j_fn_Quadcrasher', 'j_fn_Quadcrasher', 'j_fn_Quadcrasher', 'j_fn_Daily', 'j_fn_Void', 'j_fn_Void', 'j_fn_GG', 'j_fn_Clickbait', 'j_fn_Clickbait', 'j_fn_Clickbait', 'j_fn_Clickbait', 'j_fn_Noobs', 'j_fn_Noobs',
            'j_fn_Dark', 'j_fn_Frozen', 'j_fn_Frozen', 'j_fn_DC', 'j_fn_OGPass', 'j_fn_OGPass', 'j_fn_Reload', 'j_fn_Reload', 'j_fn_Circle', 'j_fn_Circle2', 'j_fn_Circle', 'j_fn_Circle2',
            'j_fn_Jam', 'j_fn_Fortnite', 'j_fn_Fortnite', 'j_fn_Smoothie', 'j_fn_Smoothie', 'j_fn_Sprite', 'j_fn_Prebuild', 'j_fn_Prebuild', 'j_fn_Shogun', 'j_fn_Shogun', 'j_fn_Killswitch', 'j_fn_Killswitch', 'j_fn_Hero', 'j_fn_Hero', 'j_fn_NBA', 'j_fn_Tempest', 'j_fn_Tempest', 'j_fn_Tempest', 'j_fn_Tempest', 'j_fn_Griddy', 'j_fn_Griddy', 'j_fn_Griddy',
			'j_fn_Circle3', 'j_fn_Circle3', 'j_fn_Circle3', 'j_fn_Fortbyte', 'j_fn_Fortbyte', 'j_fn_Fortbyte', 'j_fn_Fortbyte', 'j_fn_FlowberryFizz', 'j_fn_FlowberryFizz', 'j_fn_FlowberryFizz', 'j_fn_EGL', 'j_fn_EGL', 'j_fn_EGL', 'j_fn_Marvel', 'j_fn_Cluster', 'j_fn_Cluster', 'j_fn_Cluster', 'j_fn_Icon', 'j_fn_Gaming', 'j_fn_WRTIS', 'j_fn_WRTIS', 'j_fn_WRTIS', 'j_fn_WRTIS',
			'j_fn_StarWars', 'j_fn_Crew',
        }

        local jokers_to_create = card.ability.extra.jokers or 1
        for _ = 1, jokers_to_create do
            local selected_joker = fortlatro_jokers[math.random(#fortlatro_jokers)]
            local joker_card = create_card('Joker', G.Jokers, nil, nil, nil, nil, selected_joker)
            --joker_card.sell_cost = 0--
            joker_card:add_to_deck()
            G.jokers:emplace(joker_card)
        end
    end,
}

----------------------------------------------
------------LOOT LLAMA CODE END----------------------

----------------------------------------------
------------SHOP RESET CODE BEGIN----------------------

SMODS.Consumable{
    key = 'LTMReset',
    set = 'LTMConsumableType',
    atlas = 'Jokers',
    pos = {x = 4, y = 35},
    loc_txt = {
        name = 'Shop Reset',
        text = {
            '{C:attention}Reset{} the {C:green}Shop{}',
        }
    },
    
    can_use = function(self, card)
        return G.STATE == G.STATES.SHOP
    end,
    
    use = function(self, card, area, copier)
    
    if G.STATE == 6 then
        
        G.E_MANAGER:add_event(Event({
            trigger = 'immediate',
            func = function()
                
                if G.shop then
                    G.shop:remove()
                    G.shop = nil
                else
                    print("G.shop was nil.")
                end

                G.GAME.current_round.used_packs = nil
				G.GAME.current_round.reroll_cost = 5
                G.STATE_COMPLETE = false

                return true
            end
        }))
    else
        print("Not in shop state. Current state: " .. tostring(G.STATE))
    end
end
}

----------------------------------------------
------------SHOP RESET CODE END----------------------

----------------------------------------------
------------GOLD SPLASH CODE BEGIN----------------------

SMODS.Consumable{
    key = 'LTMGSplash',
    set = 'LTMConsumableType',
    atlas = 'Jokers',
    pos = {x = 0, y = 37},
    loc_txt = {
        name = 'Gold Splash',
        text = {
            'Split {C:money}$20{} permanently across {C:attention}all cards in hand{}',
        }
    },
    config = {
        extra = {} -- No selection limit needed
    },
    loc_vars = function(self, info_queue, center)
        return {vars = {}}
    end,
    can_use = function(self, card)
        return G and G.hand and #G.hand.cards > 0
    end,
    use = function(self, card, area, copier)
		if config.sfx ~= false then
			play_sound("fn_nsplash")
		end
        if G and G.hand and G.hand.cards and #G.hand.cards > 0 then
            local cards_in_hand = G.hand.cards
            local total = 20
            local num_cards = #cards_in_hand
            local base = math.floor(total / num_cards)
            local remainder = total - base * num_cards

            -- Shuffle so the leftover goes to random cards
            cards_in_hand = pseudoshuffle(G.hand.cards)

            for i, hand_card in ipairs(G.hand.cards) do
                local extra = (i <= remainder) and 1 or 0
                hand_card.ability.perma_p_dollars = (hand_card.ability.perma_p_dollars or 0) + base + extra

                G.E_MANAGER:add_event(Event({
                    func = function()
                        hand_card:juice_up()
                        return true
                    end
                }))
            end

            -- Optional: sound or popup feedback
            play_sound("tarot1")
        end
    end,
}

----------------------------------------------
------------GOLD SPLASH CODE END----------------------

----------------------------------------------
------------CAPITAL GAINS CODE BEGIN----------------------

SMODS.Consumable{
    key = 'Capital',
    set = 'Spectral',
    atlas = 'Jokers',
    pos = {x = 1, y = 41},
    loc_txt = {
        name = 'Capital Gains',
        text = {
            '{C:green}#2# in #1#{} chance to give {C:attention}all cards in hand{} {C:money}Sponsorship Seals{}',
            'Else lose {C:attention}ALL{} {C:money}money',
            'Idea: Your Average User',
        }
    },
    config = {
        extra = {
            odds = 3, -- 1/3 chance
        }
    },
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_SEALS.fn_SponsorSeal
        return {
            vars = {
                card.ability.extra.odds,
                G.GAME.probabilities.normal,
            }
        }
    end,
    can_use = function(self, card)
        return G and G.hand and #G.hand.cards > 0
    end,
    use = function(self, card, area, copier)
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.1,
            func = function()
                if G and G.hand and G.hand.cards then
                    local success = pseudorandom('monetization') < G.GAME.probabilities.normal / card.ability.extra.odds

                    if success then
                        for _, hand_card in ipairs(G.hand.cards) do
                            hand_card:set_seal('fn_SponsorSeal', true)
                            if config.sfx ~= false then play_sound("fn_stamp") end
                            G.E_MANAGER:add_event(Event({
                                func = function()
                                    hand_card:juice_up()
                                    return true
                                end
                            }))
                        end
                    else
                        G.GAME.dollars = 0
						card_eval_status_text(card, 'extra', nil, nil, nil, {
							message = "NOPE!",
							colour = G.C.PURPLE,
						})
                    end
                end
                return true
            end
        }))
    end,
}

----------------------------------------------
------------CAPITAL GAINS CODE END----------------------

----------------------------------------------
------------GRINDSET CODE BEGIN----------------------

SMODS.Consumable {
    key = 'Grindset',
    set = 'Tarot',
    atlas = 'Jokers',
    pos = {x = 3, y = 41},
    loc_txt = {
        name = 'Grindset',
        text = {
            'Destroy all held {C:diamond}Diamond{} cards',
            'Create new {C:spectral}Creator Code{} Cards in their place',
            'Idea: Your Average User'
        }
    },
    config = {
        extra = {
            cards = 5 -- max replacements, can be overridden
        }
    },
    loc_vars = function(self, info_queue, center)
        info_queue[#info_queue + 1] = G.P_CENTERS.m_fn_Creator
        if center and center.ability and center.ability.extra then
            return { vars = { center.ability.extra.cards } }
        end
        return { vars = {} }
    end,
    can_use = function(self, card)
        return #G.hand.cards > 0 
    end,
    use = function(self, card, area, copier)
        if not (G and G.hand and G.hand.cards) then return end

        local to_replace = {}
        for _, c in ipairs(G.hand.cards) do
            if c:is_suit("Diamonds") then
                table.insert(to_replace, c)
            end
        end

        local num_cards = math.min(#to_replace, card.ability.extra.cards or 5)

        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.4,
            func = function()
                for i = 1, num_cards do
                    local old_card = to_replace[i]
                    if old_card then
                        old_card:start_dissolve()

                        -- Pick a random base card (any suit & rank)
                        local base_card = pseudorandom_element(G.P_CARDS, pseudoseed('grindset_card'))

                        local new_card_data = {
                            front = base_card,
                            center = G.P_CENTERS.m_fn_Creator
                        }

                        local new_card = create_playing_card(new_card_data, G.hand)
                        new_card:set_ability(G.P_CENTERS.m_fn_Creator, nil, true)
                        new_card:juice_up(0.3, 0.3)
                    end
                end
                return true
            end
        }))
    end
}

----------------------------------------------
------------GRINDSET CODE END----------------------

----------------------------------------------
------------ENLIGHTENMENT CODE BEGIN----------------------

SMODS.Consumable {
    key = 'Enlightenment',
    set = 'Spectral',
    atlas = 'Jokers',
    pos = {x = 1, y = 42},
    loc_txt = {
        name = 'Enlightenment',
        text = {
            'Apply {C:money}Mythic{} to up to {C:attention}#1#{} selected Jokers',
            '{C:attention}-#2#{} {C:chips}Hands',
            'Idea: BoiRowan'
        }
    },
	
    config = {
        extra = {
            cards = 1,
			hands = 1,
        }
    },
	
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS.e_fn_Mythic
        return {
            vars = {
                card.ability.extra.cards,
                card.ability.extra.hands,
            }
        }
    end,
	
    can_use = function(self, card)
        if G.jokers and G.jokers.highlighted and card.ability and card.ability.extra then
            local n = #G.jokers.highlighted
            return n > 0 and n <= card.ability.extra.cards
        end
        return false
    end,
	
    use = function(self, card, area, copier)
        if config.sfx ~= false then
            play_sound("fn_chest")
        end

        -- Apply Mythic to selected Jokers
        if G.jokers and G.jokers.highlighted then
            for _, j in ipairs(G.jokers.highlighted) do
                j:set_edition({fn_Mythic = true}, true)
            end
        end

        -- Reduce hand count
        G.GAME.round_resets.hands = G.GAME.round_resets.hands - card.ability.extra.hands
        ease_hands_played(-card.ability.extra.hands)
    end,
}

----------------------------------------------
------------ENLIGHTENMENT CODE END----------------------

----------------------------------------------
------------BREAKTHROUGH CODE BEGIN-----------------

SMODS.Sound({
	key = "break",
	path = "break.ogg",
})

SMODS.Consumable{
        key = 'Breakthrough', -- key
        set = 'Spectral', -- the set of the card: corresponds to a consumable type
        atlas = 'Jokers', -- atlas
        pos = {x = 2, y = 42}, -- position in atlas
        loc_txt = {
            name = 'Breakthrough', -- name of card
            text = { -- text of card
                'Apply {C:money}Mythic{} to up to {C:attention}#1#{} selected Cards',
				'{C:attention}-#2#{} {C:mult}Discards',
				'Idea: BoiRowan'
            }
        },
        config = {
            extra = {
                cards = 5, -- configurable value
				discards = 1,
            }
        },
		
        loc_vars = function(self, info_queue, card)
			info_queue[#info_queue + 1] = G.P_CENTERS.e_fn_Mythic
			return {
				vars = {
					card.ability.extra.cards,
					card.ability.extra.discards,
				}
			}
		end,
		
        can_use = function(self, card)
            if G and G.hand and G.hand.highlighted and card.ability and card.ability.extra and card.ability.extra.cards then
                if #G.hand.highlighted > 0 and #G.hand.highlighted <= card.ability.extra.cards then
                    return true
                end
            end
            return false
        end,
		
        use = function(self, card, area, copier)
			
			if config.sfx ~= false then
				play_sound("fn_break")
			end
		
            if G and G.hand and G.hand.highlighted then
                for i = 1, #G.hand.highlighted do
                    G.hand.highlighted[i]:set_edition({fn_Mythic = true},true)
                end
            end
			
			G.GAME.round_resets.discards = G.GAME.round_resets.discards - card.ability.extra.discards
			ease_discard(-card.ability.extra.discards)
        end,
    }

----------------------------------------------
------------BREAKTHROUGH CODE END----------------------

----------------------------------------------
------------FTC CODE BEGIN----------------------

SMODS.Consumable{
    key = 'LTMFTC', -- key
    set = 'LTMConsumableType', -- the set of the card: corresponds to a consumable type
    atlas = 'Jokers', -- atlas
    pos = {x = 3, y = 42}, -- position in atlas
    loc_txt = {
        name = 'FTC Lawsuit', -- name of card
        text = { -- text of card
            'Has a {C:green,E:1,S:1.1}#1# in #2#{} chance to give {C:money}$#3#{}',
        },
    },
    config = {
        extra = { odds = 20, dollars = 200 }, -- Configuration: 1/20 (very low odds)
        no_pool_flag = 'gamble',
    },
    loc_vars = function(self, info_queue, card)
        return {vars = {G.GAME.probabilities.normal, card.ability.extra.odds, card.ability.extra.dollars}}
    end,
	
	can_use = function(self, card)
        return true
    end,
	
    use = function(self, card, area, copier)
        G.GAME.pool_flags.gamble = true -- Ensure 'gamble' flag is set

        -- gamblingggg yippeeeee
        if pseudorandom('FTCGamble') < G.GAME.probabilities.normal / card.ability.extra.odds then
			
            -- Display success message on the consumable
			if config.sfx ~= false then
				play_sound("fn_happy")
			end
            ease_dollars(card.ability.extra.dollars)
        else
            -- Failure: No joker granted
            -- Display failure message on the consumable
			if config.sfx ~= false then
				play_sound("fn_sad")
			end
            card_eval_status_text(card, 'extra', nil, nil, nil, {
				message = "NOPE!",
                colour = G.C.SECONDARY_SET.Tarot,
            })
        end
    end,
}

----------------------------------------------
------------FTC CODE END----------------------

----------------------------------------------
------------BANDAGE BAZOOKA CODE BEGIN----------------------

SMODS.Consumable{
    key = 'LTMBazooka', -- key
    set = 'LTMConsumableType', -- the set of the card: corresponds to a consumable type
    atlas = 'Jokers', -- atlas
    pos = {x = 0, y = 43}, -- position in atlas
	rarity = 3,
    loc_txt = {
        name = 'Bandage Bazooka', -- name of card
        text = { -- text of card
            'Cannot be used',
			'Prevent death once',
			'Idea: Your Average User'
        },
    },
	
	
	can_use = function(self, card)
        return false
    end,
	
    calculate = function(self, card, context)
        if context.end_of_round and not context.blueprint and context.game_over then
            G.E_MANAGER:add_event(Event({
                func = function()
                    -- Visual feedback for chips
                    G.hand_text_area.blind_chips:juice_up()
                    G.hand_text_area.game_chips:juice_up()


                    -- Destroy the Reboot Card itself
                    card:start_dissolve()

                    -- Prevent the game over
                    context.game_over = false

                    return true
                end
            }))
            return {
                message = localize('k_saved_ex'),
                saved = true,
                colour = G.C.RED
            }
        end
    end
}

----------------------------------------------
------------BANDAGE BAZOOKA CODE END----------------------

----------------------------------------------
------------SAVE POINT DEVICE CODE BEGIN----------------------

--CREATE G.GAME.last_ltm FOR thing--
-- Save original function
local igo = Game.init_game_object
function Game:init_game_object()
	local ret = igo(self)
	ret.last_ltm = nil
	return ret
end

-- Save original consumeable usage function
local sgu = set_consumeable_usage
set_consumeable_usage = function(card)
	local ret = sgu(card)
	
	if card and card.config and card.config.center_key and card.ability and card.ability.consumeable then
		if card.ability.set == 'LTMConsumableType' then
			G.E_MANAGER:add_event(Event({
				trigger = 'immediate',
				func = function()
					G.E_MANAGER:add_event(Event({
						trigger = 'immediate',
						func = function()
							G.GAME.last_ltm = card.config.center_key
							return true
						end
					}))
					return true
				end
			}))
		end
	end

	return ret
end


function count_consumables()
  if G.consumeables.get_total_count then
    return G.consumeables:get_total_count()
  else
    return #G.consumeables.cards + G.GAME.consumeable_buffer
  end
end


SMODS.Consumable {
  set = "Tarot",
  key = "Save",
  loc_txt = {
    name = 'Save Point Device',
    text = {
      "Creates the last",
      "{C:purple}LTM Card{} used",
      "during this run",
	  "{C:inactive} (Must have room)",
    }
  },
  pos = { x = 3, y = 43 },
  atlas = "Jokers",
  loc_vars = function(self, info_queue, card)
    local shard_card = G.GAME.last_ltm and G.P_CENTERS[G.GAME.last_ltm] or nil
    return {
      main_end = {
        {
          n = G.UIT.C,
          config = { align = "bm", padding = 0.02 },
          nodes = {
            {
              n = G.UIT.C,
              config = { align = "m", colour = ((not shard_card or shard_card.key == 'c_phanta_shard') and G.C.RED or G.C.GREEN), r = 0.05, padding = 0.05 },
              nodes = {
                { n = G.UIT.T, config = { text = ' ' .. (shard_card and localize { type = 'name_text', key = shard_card.key, set = shard_card.set } or localize('k_none')) .. ' ', colour = G.C.UI.TEXT_LIGHT, scale = 0.3, shadow = true } },
              }
            }
          }
        }
      }
    }
  end,
  can_use = function(self, card)
    return G.consumeables.config.card_limit >= count_consumables() and G.GAME.last_ltm ~= nil
  end,
  use = function(self, card, area, copier)
    G.E_MANAGER:add_event(Event({
      trigger = 'after',
      delay = 0.4,
      func = function()
        if G.consumeables.config.card_limit > count_consumables() then
          play_sound('timpani')
          local new_card = create_card('LTMConsumableType', G.consumeables, nil, nil, nil, nil, G.GAME.last_ltm, 'shard')
          new_card:add_to_deck()
          G.consumeables:emplace(new_card)
          card:juice_up(0.3, 0.5)
        end
        return true
      end
    }))
    delay(0.6)
  end,
}

----------------------------------------------
------------SAVE POINT DEVICE CODE END----------------------

----------------------------------------------
------------EDUCATION CODE BEGIN----------------------

SMODS.Consumable{
    key = 'Education',
    set = 'Tarot',
    atlas = 'Jokers',
    pos = {x = 3, y = 44},
    loc_txt = {
        name = 'Education',
        text = {
            'Convert up to {C:attention}#1#{} cards into {C:purple}Xp Boost{} cards',
			'Idea: BoiRowan',
        }
    },
    config = {
        extra = {
            cards = 1, -- configurable value
        }
    },
    loc_vars = function(self, info_queue, center)
        info_queue[#info_queue + 1] = G.P_CENTERS.m_fn_Xp
        if center and center.ability and center.ability.extra then
            return {vars = {center.ability.extra.cards}} 
        end
        return {vars = {}}
    end,
    can_use = function(self, card)
        return G and G.hand and G.hand.highlighted and card.ability and card.ability.extra and 
            card.ability.extra.cards and #G.hand.highlighted > 0 and #G.hand.highlighted <= card.ability.extra.cards
    end,
    use = function(self, card, area, copier)
	
		if config.sfx ~= false then
            play_sound("fn_xp")
        end
		
        if G and G.hand and G.hand.highlighted and #G.hand.highlighted > 0 then
            for i = 1, #G.hand.highlighted do
                local target_card = G.hand.highlighted[i]

                -- Transform the card into a Wood card
                target_card:set_ability(G.P_CENTERS.m_fn_Xp)


                -- Add a juice-up effect for better feedback
                G.E_MANAGER:add_event(Event({
                    func = function()
                        target_card:juice_up()
                        return true
                    end
                }))
            end
        end
    end,
}

----------------------------------------------
------------EDUCATION CODE END----------------------

----------------------------------------------
------------BATTLE PASS BOOST CODE BEGIN----------------------

if config.newcalccompat ~= false then
SMODS.Consumable{
    key = 'LTMBoost',
    set = 'LTMConsumableType',
    atlas = 'Jokers',
    pos = {x = 4, y = 44},
    loc_txt = {
        name = 'Battle Pass Boost',
        text = {
            'Convert all {C:dark_edition}Enhanced{} cards in hand into {C:purple}Xp Boost{} Cards',
			'Idea: BoiRowan',
        }
    },
	
    loc_vars = function(self, info_queue, center)
        info_queue[#info_queue + 1] = G.P_CENTERS.m_fn_Xp
        return {vars = {}}
    end,

    can_use = function(self, card)
        return G and G.hand and #G.hand.cards > 0
    end,

    use = function(self, card, area, copier)
        if config.sfx ~= false then
            play_sound("fn_xp")
        end

        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.1,
            func = function()
                if G and G.hand and G.hand.cards then
                    for _, hand_card in ipairs(G.hand.cards) do
                        if hand_card.ability.set == 'Enhanced' then
                            hand_card:set_ability(G.P_CENTERS.m_fn_Xp)

                            G.E_MANAGER:add_event(Event({
                                func = function()
                                    hand_card:juice_up()
                                    return true
                                end
                            }))
                        end
                    end
                end
                return true
            end
        }))
    end,
}
end

----------------------------------------------
------------BATTLE PASS BOOST CODE END----------------------

----------------------------------------------
------------BUG BLASTER CODE BEGIN----------------------

SMODS.Consumable{
    key = 'LTMBug',
    set = 'LTMConsumableType',
    atlas = 'Jokers',
    pos = {x = 0, y = 45},
    loc_txt = {
        name = 'Bug Blaster',
        text = {
            'Converts {C:attention}#1#{} random thing into a random {C:dark_edition}edition',
        },
    },
    config = {
        extra = { cards = 1 },
    },
    loc_vars = function(self, info_queue, center)
        if center and center.ability and center.ability.extra then
            return { vars = { center.ability.extra.cards } }
        end
        return { vars = {} }
    end,
    can_use = function(self, card)
        return G and (#G.hand.cards > 0 or #G.jokers.cards > 0 or #G.consumeables.cards > 0)
    end,
    use = function(self, card, area, copier)
        if not (G and card and card.ability and card.ability.extra) then
            print("Invalid game state or consumable configuration.")
            return
        end

        local maxCards = card.ability.extra.cards or 1
        local potentialTargets = {}

        -- Collect cards from hand
        if G.hand then
            for _, target in ipairs(G.hand.cards) do
                table.insert(potentialTargets, target)
            end
        end

        -- Collect Jokers
        if G.jokers then
            for _, target in ipairs(G.jokers.cards) do
                table.insert(potentialTargets, target)
            end
        end

        -- Collect Consumables
        if G.consumeables then
            for _, target in ipairs(G.consumeables.cards) do
                table.insert(potentialTargets, target)
            end
        end


        if #potentialTargets == 0 then
            print("No valid targets for Polychrome Splash.")
            return
        end

        -- Apply either Polychrome edition or dissolve with 50% chance
        local targetCount = math.min(#potentialTargets, maxCards)
        local selectedTargets = {}

        for i = 1, targetCount do
            local randomIndex = math.random(#potentialTargets)
            local target = potentialTargets[randomIndex]
            target:set_edition(poll_edition('random key', nil, false, true))
            table.remove(potentialTargets, randomIndex)
        end
    end,
}

----------------------------------------------
------------BUG BLASTER CODE END----------------------

----------------------------------------------
------------SUPER LAUNCH PAD CODE BEGIN----------------------

SMODS.Consumable{ 
    key = 'LTMSuperLaunchPad', -- key
    set = 'LTMConsumableType', -- the set of the card
    atlas = 'Jokers', -- atlas
    pos = {x = 1, y = 45}, -- position in atlas
    loc_txt = {
        name = 'Super Launch Pad', -- name of the consumable
        text = { 
            'Draw {C:attention}#1#{} additional cards'
        }
    },
    config = {
        extra = {
            cards = 4, -- configurable value (number of cards to draw)
        }
    },
    loc_vars = function(self, info_queue, center)
        if center and center.ability and center.ability.extra then
            return {vars = {center.ability.extra.cards}} 
        end
        return {vars = {}}
    end,
    can_use = function(self)
        return #G.hand.cards > 0 and #G.deck.cards > 0
    end,
    use = function(self, card, area, copier)
        -- Use the card’s dynamically updated value instead of the fixed config value
        local cards_to_draw = card and card.ability and card.ability.extra and card.ability.extra.cards or self.config.extra.cards
        if G and G.hand then
            -- Use the Launch Pad to draw extra cards
            G.FUNCS.draw_from_deck_to_hand(cards_to_draw)
        end
    end,
}

----------------------------------------------
------------SUPER LAUNCH PAD CODE END----------------------

----------------------------------------------
------------THE GREAT TURTLE CODE BEGIN----------------------

-- Track destroyed jokers for The Great Turtle
local start_dissolve_original = Card.start_dissolve

function Card:start_dissolve(...)
    -- Only track if it's a Joker
    if self.config and self.config.center and self.config.center.set == "Joker" then
        G.GAME.destroyed_jokers = G.GAME.destroyed_jokers or {}
        local key = self.config.center.key

        local already_added = false
        for _, stored_key in ipairs(G.GAME.destroyed_jokers) do
            if stored_key == key then
                already_added = true
                break
            end
        end

        if not already_added then
            table.insert(G.GAME.destroyed_jokers, key)
            --print("Destroyed Joker:", key, "| Total:", #G.GAME.destroyed_jokers)
        end
    end

    -- Call original method
    return start_dissolve_original(self, ...)
end

SMODS.Consumable{
    key = 'Turtle', 
    set = 'Spectral', 
    atlas = 'Jokers', 
    pos = {x = 2, y = 48}, 
    loc_txt = {
        name = 'The Great Turtle', 
        text = {
            'Create a copy of {C:attention}#1#{} random {C:mult}destroyed{} {C:attention}Jokers{}',
            '{C:inactive}(Must have room)',
        }
    },
    config = {
        extra = {
            jokers = 1, -- default number to create
        },
    },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.jokers } }
    end,

    can_use = function(self, card)
        return #G.jokers.cards < G.jokers.config.card_limit and #G.GAME.destroyed_jokers > 0
    end,

    use = function(self, card, area, copier)

        local destroyed = G.GAME.destroyed_jokers or {}
        if #destroyed == 0 then
            if config.sfx ~= false then play_sound("fn_sad") end
            card_eval_status_text(card, 'extra', nil, nil, nil, {
                message = "NO JOKERS TO RESURRECT!",
                colour = G.C.RED,
            })
            return
        end

        local jokers_to_create = card.ability.extra.jokers or 1
        for _ = 1, jokers_to_create do
            if #G.jokers.cards >= G.jokers.config.card_limit then break end

            local selected_joker = destroyed[math.random(#destroyed)]
            local joker_card = create_card('Joker', G.jokers, nil, nil, nil, nil, selected_joker)
            joker_card:add_to_deck()
            G.jokers:emplace(joker_card)
        end
    end,
}

----------------------------------------------
------------THE GREAT TURTLE CODE END----------------------

SMODS.Sound({
	key = "cache",
	path = "cache.ogg",
})

SMODS.Consumable{
    key = 'LTMCache',
    set = 'LTMConsumableType',
    atlas = 'Jokers',
    pos = {x = 3, y = 49},
    rarity = 3,
    loc_txt = {
        name = 'Combat Cache',
        text = {
            'Add a {C:attention}random voucher{} to this {C:green}shop{}',
        }
    },

    can_use = function(self, card)
        return G.STATE == G.STATES.SHOP
    end,

    use = function(self, card, area, copier)
        if G.STATE == 6 then
            if config.sfx ~= false then
                play_sound("fn_cache")
            end

            G.shop_vouchers.config.card_limit = G.shop_vouchers.config.card_limit + 1

            -- use the proper Balatro logic to get the next valid voucher
            local voucher_key = get_next_voucher_key(true)
            if voucher_key then
                local voucher = Card(
                    G.shop_vouchers.T.x + G.shop_vouchers.T.w/2,
                    G.shop_vouchers.T.y,
                    G.CARD_W,
                    G.CARD_H,
                    G.P_CARDS.empty,
                    G.P_CENTERS[voucher_key],
                    {bypass_discovery_center = true, bypass_discovery_ui = true}
                )
                create_shop_card_ui(voucher, 'Voucher', G.shop_vouchers)
                voucher:start_materialize()
                G.shop_vouchers:emplace(voucher)
            end
        end
    end
}



----------------------------------------------
------------DUMPSTER DIVER CODE BEGIN----------------------

SMODS.Sound({
	key = "trash",
	path = "trash.ogg",
})

SMODS.Sound({
	key = "augment",
	path = "augment.ogg",
})

SMODS.Voucher {
    key = 'Dumpster',
    loc_txt = {
        name = 'Dumpster Diving',
        text = { '{C:green}#1# in #2#{} chance to spawn a random consumable at {C:attention}end of round{}', '{C:inactive}(No need to have room)'}
    },
    atlas = 'Jokers',
    pos = {
        x = 0,
        y = 32,
    },
    config = {
        extra = {
            odds = 3,
        }
    },
    loc_vars = function(self, info_queue, card)
        local stg = card.ability.extra
        return {
            vars = { G.GAME.probabilities.normal, stg.odds }
        }
    end,
	
	redeem = function(self, card)
        if config.sfx ~= false then
			play_sound("fn_augment")
        end
    end,
    
    calculate = function(self, card, context)
        if context.end_of_round and not context.repetition and not context.individual and not next(SMODS.find_card('v_fn_Dumpster2')) then
            if pseudorandom('trash') < (G.GAME.probabilities.normal / card.ability.extra.odds) then
                local new_card = create_card('Consumeables', G.consumeables)
                new_card:add_to_deck()
                G.consumeables:emplace(new_card)
                if config.sfx ~= false then
                    play_sound("fn_trash")
                end
            end
        end
    end
}

SMODS.Voucher {
    key = 'Dumpster2',
    loc_txt = {
        name = 'Trash Tycoon',
        text = { 'Spawn a random consumable at {C:attention}end of round{}', '{C:inactive}(No need to have room)'}
    },
    atlas = 'Jokers',
    requires = {'v_fn_Dumpster'},
    pos = {
        x = 1,
        y = 32,
    },
	
	redeem = function(self, card)
        if config.sfx ~= false then
			play_sound("fn_augment")
        end
    end,
    
    calculate = function(self, card, context)
        if context.end_of_round and not context.repetition and not context.individual then
            local new_card = create_card('Consumeables', G.consumeables)
            new_card:add_to_deck()
            G.consumeables:emplace(new_card)
            if config.sfx ~= false then
                play_sound("fn_trash")
            end
        end
    end
}

----------------------------------------------
------------DUMPSTER DIVER CODE END----------------------

----------------------------------------------
------------RIFTJECTOR SEAT CODE BEGIN----------------------

SMODS.Voucher {
    key = 'Riftjector',
    loc_txt = {
        name = 'Rift-jector Seat',
        text = { 'The next time you would die', '{C:mult}destroy{} this voucher instead'}
    },
    atlas = 'Jokers',
    pos = {
        x = 0,
        y = 36,
    },
    
	redeem = function(self, card)
        if config.sfx ~= false then
			play_sound("fn_augment")
        end
    end,
	
    calculate = function(self, card, context)
        if context.end_of_round and not context.blueprint and context.game_over then
            G.E_MANAGER:add_event(Event({
                func = function()
                    -- Visual feedback for chips
                    G.hand_text_area.blind_chips:juice_up()
                    G.hand_text_area.game_chips:juice_up()

                    -- Play a sound effect
                    if config.sfx ~= false then
                        play_sound('fn_rift')
                    end

                    -- Prevent the game over
                    context.game_over = false
                    card:start_dissolve()

                    return true
                end
            }))

            return {
                message = localize('k_saved_ex'),
                saved = true,
                colour = G.C.RED
            }
        end
    end
}

SMODS.Voucher {
    key = 'Riftjector2',
    loc_txt = {
        name = 'Failsafe Rift-jector',
        text = { 'The next time you would die', 'survive and {C:green}25% chance{} this voucher is not {C:mult}destroyed{}' }
    },
    atlas = 'Jokers',
    requires = { 'v_fn_Riftjector' },
    pos = {
        x = 1,
        y = 36,
    },
	
	redeem = function(self, card)
        if config.sfx ~= false then
			play_sound("fn_augment")
        end
    end,

    calculate = function(self, card, context)
        if context.end_of_round and not context.blueprint and context.game_over and not context.saved_by_riftjector then
            context.saved_by_riftjector = true

            G.E_MANAGER:add_event(Event({
                func = function()
                    -- Visual feedback
                    G.hand_text_area.blind_chips:juice_up()
                    G.hand_text_area.game_chips:juice_up()

                    -- Sound effect
                    if config.sfx ~= false then
                        play_sound('fn_rift')
                    end

                    -- Prevent the game over
                    context.game_over = false

                    -- 25% chance to not destroy
                    if pseudorandom('rift') >= 1/4 then
                        card:start_dissolve()
                    end

                    return true
                end
            }))

            return {
                message = localize('k_saved_ex'),
                saved = true,
                colour = G.C.RED
            }
        end
    end
}

----------------------------------------------
------------RIFTJECTOR SEAT CODE END----------------------

----------------------------------------------
------------RARITY CHECK CODE BEGIN----------------------

SMODS.Voucher {
    key = 'Rarity',
    loc_txt = {
        name = 'Rarity Check',
        text = { '{C:common}Common{} and {C:uncommon}Uncommon{} Jokers{}', 'Each give {C:mult}+#1#{} Mult', 'Idea: {C:attention}MushiJutsu{}' }
    },
    atlas = 'Jokers',
    pos = {
        x = 3,
        y = 36,
    },
    config = {
        extra = {
            mult = 4,
        }
    },
    loc_vars = function(self, info_queue, card)
        return {
            vars = { card.ability.extra.mult }
        }
    end,
	
	redeem = function(self, card)
        if config.sfx ~= false then
			play_sound("fn_augment")
        end
    end,

    calculate = function(self, card, context)
        local joker = context.other_joker
        if joker and (
            joker.config.center.rarity == 1 or joker.config.center.rarity == "Common" or
            joker.config.center.rarity == 2 or joker.config.center.rarity == "Uncommon"
        ) then
            return {
                mult = card.ability.extra.mult,
            }
        end
    end,
}

SMODS.Voucher {
    key = 'Rarity2',
    loc_txt = {
        name = 'Prestige Check',
        text = { '{C:rare}Rare{} and {C:legendary}Legendary{} Jokers{}', 'Each give {C:mult}+#1#{} Mult' }
    },
    atlas = 'Jokers',
	requires = { 'v_fn_Rarity' },
    pos = {
        x = 4,
        y = 36,
    },
    config = {
        extra = {
            mult = 8,
        }
    },
    loc_vars = function(self, info_queue, card)
        return {
            vars = { card.ability.extra.mult }
        }
    end,
	
	redeem = function(self, card)
        if config.sfx ~= false then
			play_sound("fn_augment")
        end
    end,

    calculate = function(self, card, context)
        local joker = context.other_joker
        if joker and (
            joker.config.center.rarity == 3 or joker.config.center.rarity == "Rare" or
            joker.config.center.rarity == 4 or joker.config.center.rarity == "Legendary"
        ) then
            return {
                mult = card.ability.extra.mult,
            }
        end
    end,
}

----------------------------------------------
------------RARITY CHECK CODE END----------------------

----------------------------------------------
------------LAST SHOTS CODE BEGIN----------------------

SMODS.Voucher {
    key = 'Last',
    loc_txt = {
        name = 'Last Shots',
        text = { '{C:attention}Last 2 Hands{} of round give {C:mult}+#1#{} Mult and {C:chips}+#2#{} Chips', 'Idea: {C:attention}MushiJutsu{}' }
    },
    atlas = 'Jokers',
    pos = {
        x = 1,
        y = 37,
    },
    config = {
        extra = {
            mult = 5,
			chips = 50,
        }
    },
    loc_vars = function(self, info_queue, card)
        return {
            vars = { card.ability.extra.mult, card.ability.extra.chips }
        }
    end,
	
	redeem = function(self, card)
        if config.sfx ~= false then
			play_sound("fn_augment")
        end
    end,

    calculate = function(self, card, context)
        if context.joker_main and G.GAME.current_round.hands_left == 0 then
            return {
				mult = card.ability.extra.mult,
                chips = card.ability.extra.chips,
            }
        end
		
		if context.joker_main and G.GAME.current_round.hands_left == 1 then
            return {
                mult = card.ability.extra.mult,
                chips = card.ability.extra.chips,
            }
        end
	end
}


SMODS.Voucher {
    key = 'Last2',
    loc_txt = {
        name = 'Extended Mag',
        text = { '{C:attention}Last 2 Hands{} of round give {C:mult}+#1#{} Mult and {C:chips}+#2#{} Chips' }
    },
    atlas = 'Jokers',
	requires = { 'v_fn_Last' },
    pos = {
        x = 2,
        y = 37,
    },
    config = {
        extra = {
            mult = 10,
			chips = 100,
        }
    },
    loc_vars = function(self, info_queue, card)
        return {
            vars = { card.ability.extra.mult, card.ability.extra.chips }
        }
    end,
	
	redeem = function(self, card)
        if config.sfx ~= false then
			play_sound("fn_augment")
        end
    end,

    calculate = function(self, card, context)
        if context.joker_main and G.GAME.current_round.hands_left == 0 then
            return {
				mult = card.ability.extra.mult,
                chips = card.ability.extra.chips,
            }
        end
		
		if context.joker_main and G.GAME.current_round.hands_left == 1 then
            return {
                mult = card.ability.extra.mult,
                chips = card.ability.extra.chips,
            }
        end
	end
}

----------------------------------------------
------------LAST SHOTS CODE END----------------------

----------------------------------------------
------------DANGER HERO CODE BEGIN----------------------

SMODS.Voucher {
    key = 'Danger',
    loc_txt = {
        name = 'Danger Hero',
        text = { '{C:attention}Final Hand{} of round gives {X:chips,C:white}X#1#{} Chips' }
    },
    atlas = 'Jokers',
    pos = {
        x = 3,
        y = 37,
    },
    config = {
        extra = {
            x_chips = 2,
        }
    },
    loc_vars = function(self, info_queue, card)
        return {
            vars = { card.ability.extra.x_chips }
        }
    end,
	
	redeem = function(self, card)
        if config.sfx ~= false then
			play_sound("fn_augment")
        end
    end,

    calculate = function(self, card, context)
        if context.joker_main and G.GAME.current_round.hands_left == 0 then
            return {
                x_chips = card.ability.extra.x_chips
            }
        end
    end
}

SMODS.Voucher {
    key = 'Danger2',
    loc_txt = {
        name = 'Last Stand',
        text = { '{C:attention}Final Hand{} of round gives {X:mult,C:white}X#1#{} Mult' }
    },
    atlas = 'Jokers',
	requires = { 'v_fn_Danger' },
    pos = {
        x = 4,
        y = 37,
    },
    config = {
        extra = {
            x_mult = 2,
        }
    },
    loc_vars = function(self, info_queue, card)
        return {
            vars = { card.ability.extra.x_mult }
        }
    end,
	
	redeem = function(self, card)
        if config.sfx ~= false then
			play_sound("fn_augment")
        end
    end,

    calculate = function(self, card, context)
        if context.joker_main and G.GAME.current_round.hands_left == 0 then
            return {
                x_mult = card.ability.extra.x_mult
            }
        end
    end
}

----------------------------------------------
------------DANGER HERO CODE END----------------------

----------------------------------------------
------------TRASH TALK CODE BEGIN----------------------

SMODS.Voucher {
    key = 'Talk',
    loc_txt = {
        name = 'Trash Talk',
        text = { '{X:attention,C:white}X#1#{} {C:attention}Blind Payout{}', '{C:mult}-#2# Discards{}', 'Idea: BoiRowan' }
    },
    atlas = 'Jokers',
    pos = {
        x = 0,
        y = 38,
    },
    config = {
        extra = {
            payout = 2,
			discards = 1,
        }
    },
    loc_vars = function(self, info_queue, card)
        return {
            vars = { card.ability.extra.payout, card.ability.extra.discards }
        }
    end,
	
	redeem = function(self, card)
		if config.sfx ~= false then
			play_sound("fn_augment")
        end
        local e = card.ability.extra
        G.GAME.round_resets.discards = G.GAME.round_resets.discards - e.discards
        ease_discard(-e.discards)
    end,
	
    calculate = function(self, card, context)
        if context.setting_blind then
            G.GAME.blind.dollars = G.GAME.blind.dollars * card.ability.extra.payout
        end
	end
}

SMODS.Voucher {
    key = 'Talk2uh', -- spit on that thing
    loc_txt = {
        name = 'Toxicity',
        text = { '{X:attention,C:white}X#1#{} {C:attention}Blind Payout{}', '{C:chips}-#2# Hands{}', 'Idea: BoiRowan' }
    },
    atlas = 'Jokers',
	requires = { 'v_fn_Talk' },
    pos = {
        x = 1,
        y = 38,
    },
    config = {
        extra = {
            payout = 2,
			hands = 1,
        }
    },
    loc_vars = function(self, info_queue, card)
        return {
            vars = { card.ability.extra.payout, card.ability.extra.hands }
        }
    end,
	
	redeem = function(self, card)
		if config.sfx ~= false then
			play_sound("fn_augment")
        end
        local e = card.ability.extra
        G.GAME.round_resets.hands = G.GAME.round_resets.hands - e.hands
        ease_hands_played(-e.hands)
    end,
	
    calculate = function(self, card, context)
        if context.setting_blind then
            G.GAME.blind.dollars = G.GAME.blind.dollars * card.ability.extra.payout
        end
	end
}

----------------------------------------------
------------TRASH TALK CODE END----------------------

----------------------------------------------
------------FORECAST CODE BEGIN----------------------

SMODS.Voucher {
    key = 'Forecast',
    loc_txt = {
        name = 'Forecast',
        text = { '{C:purple}LTM Cards{} appear {X:attention,C:white}X2{} more frequently in the shop', 'Idea: {C:attention}MushiJutsu{}',}
    },
    atlas = 'Jokers',
    pos = {
        x = 4,
        y = 41,
    },
	
	redeem = function(self)
		if config.sfx ~= false then
			play_sound("fn_augment")
        end
		G.E_MANAGER:add_event(Event({
			func = function()
				G.GAME.ltmconsumabletype_rate = (G.GAME.ltmconsumabletype_rate or 1) * 2
				return true
			end,
		}))
	end,
}

SMODS.Voucher {
    key = 'Forecast2',
    loc_txt = {
        name = 'Storm Mark',
        text = { '{C:purple}LTM Cards{} appear {X:attention,C:white}X4{} more frequently in the shop', 'Idea: {C:attention}MushiJutsu{}', }
    },
    atlas = 'Jokers',
	requires = { 'v_fn_Forecast' },
    pos = {
        x = 0,
        y = 42,
    },
	
	redeem = function(self)
		if config.sfx ~= false then
			play_sound("fn_augment")
        end
		G.E_MANAGER:add_event(Event({
			func = function()
				G.GAME.ltmconsumabletype_rate = (G.GAME.ltmconsumabletype_rate or 2) * 4
				return true
			end,
		}))
	end,
}

----------------------------------------------
------------FORECAST CODE END----------------------

----------------------------------------------
------------BUSH WARRIOR CODE BEGIN----------------------

SMODS.Voucher {
    key = 'Bush',
    loc_txt = {
        name = 'Bush Warrior',
        text = { 'Each {C:attention}Held{} card gives {C:money}$#1#{}' }
    },
    atlas = 'Jokers',
    pos = {
        x = 0,
        y = 44,
    },
    config = {
        extra = {
            dollars = 1,
        }
    },
    loc_vars = function(self, info_queue, card)
        return {
            vars = { card.ability.extra.dollars }
        }
    end,
	
	redeem = function(self, card)
        if config.sfx ~= false then
			play_sound("fn_augment")
        end
    end,

    calculate = function(self, card, context)
        -- trigger for each held card
        if context.cardarea == G.hand and context.individual and not context.end_of_round then
            return {
                dollars = card.ability.extra.dollars,
                card = card,
            }
        end
    end
}

SMODS.Voucher {
    key = 'Bush2',
    loc_txt = {
        name = 'Shrub Mud',
        text = { 'Each {C:attention}Held{} card gains {C:chips}+#1#{} Chips' }
    },
    atlas = 'Jokers',
	requires = { 'v_fn_Bush' },
    pos = {
        x = 1,
        y = 44,
    },
    config = {
        extra = {
            chips = 5,
        }
    },
    loc_vars = function(self, info_queue, card)
        return {
            vars = { card.ability.extra.chips }
        }
    end,
	
	redeem = function(self, card)
        if config.sfx ~= false then
			play_sound("fn_augment")
        end
    end,

    calculate = function(self, card, context)
        if context.cardarea == G.hand and context.individual and not context.end_of_round then
            for _, hand_card in ipairs(G.hand.cards) do
                hand_card.ability.perma_bonus = (hand_card.ability.perma_bonus or 0) + card.ability.extra.chips/#G.hand.cards
            end
            return {
                extra = { message = "Upgrade!", colour = G.C.CHIPS },
                colour = G.C.CHIPS,
            }
        end
    end
}

----------------------------------------------
------------BUSH WARRIOR CODE END----------------------

----------------------------------------------
------------NOSTALGIA GLASSES CODE END----------------------

SMODS.Voucher{
    key = 'Nostalgia',
    atlas = 'Jokers',
    pos = {x = 1, y = 47},
    loc_txt = {
        name = 'Nostalgia Glasses',
        text = {
            'Spawns an {C:attention}extra{} {C:purple}LTM pack{} in every {C:green}shop{}',
			'Idea: BoiRowan',
        }
    },
    config = {
        extra = {
            triggered = 0, --track if it has spawned the pack or not
        },
    },
	
    redeem = function(self, card)
        if config.sfx ~= false then
            play_sound("fn_augment")
        end
    end,

    calculate = function(self, card, context)
        if G.STATE == G.STATES.SHOP and card.ability.extra.triggered == 0 then
            card.ability.extra.triggered = 1

            -- pick randomly between booster1 and booster2
            local booster_keys = {"p_fn_LTMBooster1", "p_fn_LTMBooster2"}
            local chosen = booster_keys[math.random(#booster_keys)]

            local pack = Card(
                G.shop_booster.T.x + G.shop_booster.T.w/2,
                G.shop_booster.T.y,
                G.CARD_W*1.27,
                G.CARD_H*1.27,
                G.P_CARDS.empty,
                G.P_CENTERS[chosen],
                {bypass_discovery_center = true, bypass_discovery_ui = true}
            )
            create_shop_card_ui(pack, 'Booster', G.shop_booster)
            pack.ability.booster_pos = #G.shop_booster.cards + 1
            pack.ability.couponed = true
            pack:start_materialize()
            G.shop_booster:emplace(pack)
        end
		
        if context.ending_shop or context.end_of_round or context.setting_blind then
            card.ability.extra.triggered = 0 --reset tracking for next shop
        end
    end
}

-- Ensure G.GAME.ltm_choices / regular_choices exist at 0 on game start/load
local igo = Game.init_game_object
function Game:init_game_object(...)
    local ret = igo(self, ...)
    -- preserve values if loading a save; otherwise seed to 0
    ret.ltm_choices     = tonumber(ret.ltm_choices)     or 0
    ret.regular_choices = tonumber(ret.regular_choices) or 0
    return ret
end



SMODS.Voucher{
    key = 'Nostalgia2',
    atlas = 'Jokers',
	requires = { 'v_fn_Nostalgia' },
    pos = {x = 2, y = 47},
    loc_txt = {
        name = 'Better Times',
        text = {
            'All packs have {C:attention}#1# extra{} options',
			'{C:purple}LTM packs{} have {C:attention}#2# extra{} options instead',
			'Idea: BoiRowan',
        }
    },
    config = {
        extra = {
            choices = 2, 
			ltm_choices = 3,
        },
    },
	
	loc_vars = function(self, info_queue, card)
        return {
            vars = { card.ability.extra.choices, card.ability.extra.ltm_choices }
        }
    end,
	
    redeem = function(self, card)
        if config.sfx ~= false then
            play_sound("fn_augment")
        end
		G.GAME.ltm_choices = (G.GAME.ltm_choices or 0) + card.ability.extra.ltm_choices
		G.GAME.regular_choices = (G.GAME.regular_choices or 0) + card.ability.extra.choices
    end,
}

----------------------------------------------
------------NOSTALGIA GLASSES CODE END----------------------

----------------------------------------------
------------SUPPLY DROP CODE BEGIN----------------------

SMODS.Voucher{
    key = 'Supply',
    atlas = 'Jokers',
    pos = { x = 4, y = 49 },
    loc_txt = {
        name = 'Supply Drop',
        text = {
            '{C:purple}Arcana Packs{} always contain one of the {C:money}A{}{C:mult}m{}{C:green}m{}{C:money}o{} tarot cards',
            'Idea: BoiRowan'
        }
    },
    redeem = function(self, card)
        if config.sfx ~= false then
            play_sound("fn_augment")
        end

        -- Change Arcana Packs to include checks for Supply
        SMODS.Booster:take_ownership_by_kind('Arcana', {
            create_card = function(_, card, i)
                local _card

                if G.GAME.used_vouchers.v_fn_Supply and i == 2 then
                    local tarot_pool = {
                        "c_fn_Minutemen",
                        "c_fn_Backline",
                        "c_fn_Frontline",
                        "c_fn_Flank",
                        "c_fn_Artillery"
                    }
                    local choice = tarot_pool[math.floor(pseudorandom('supply_tarot') * #tarot_pool) + 1]

                    _card = {
                        set = "Tarot",
                        area = G.pack_cards,
                        skip_materialize = true,
                        soulable = true,
                        key = choice,
                        key_append = "ar1"
                    }

                elseif G.GAME.used_vouchers.v_omen_globe and pseudorandom('omen_globe') > 0.8 then
                    _card = {
                        set = "Spectral",
                        area = G.pack_cards,
                        skip_materialize = true,
                        soulable = true,
                        key_append = "ar2"
                    }

                elseif G.GAME.used_vouchers.v_mxms_sharp_suit and i == 1 then
                    local suit_tallies = { ['Spades'] = 0, ['Hearts'] = 0, ['Clubs'] = 0, ['Diamonds'] = 0 }
                    for _, v in ipairs(G.playing_cards) do
                        suit_tallies[v.base.suit] = (suit_tallies[v.base.suit] or 0) + 1
                    end

                    local _tarot, _suit, _tally = nil, nil, 0
                    for k, v in pairs(suit_tallies) do
                        if v > _tally then
                            _suit = k
                            _tally = v
                        end
                    end

                    if _suit then
                        for _, v in pairs(G.P_CENTER_POOLS.Tarot) do
                            if v.config.suit_conv == _suit then
                                _tarot = v.key
                            end
                        end
                    end

                    _card = {
                        set = "Tarot",
                        area = G.pack_cards,
                        skip_materialize = true,
                        soulable = true,
                        key = _tarot,
                        key_append = "ar1"
                    }

                else
                    _card = {
                        set = "Tarot",
                        area = G.pack_cards,
                        skip_materialize = true,
                        soulable = true,
                        key_append = "ar1"
                    }
                end

                return _card
            end
        }, true)
    end,
}

-- Ensure G.GAME.ammo_extra exist at 0 on game start/load
local igo = Game.init_game_object
function Game:init_game_object(...)
    local ret = igo(self, ...)
    -- preserve values if loading a save; otherwise seed to 0
    ret.ammo_extra     = tonumber(ret.ammo_extra)     or 0
    return ret
end


SMODS.Voucher{
    key = 'Supply2',
    atlas = 'Jokers',
	requires = { 'v_fn_Supply' },
    pos = {x = 0, y = 50},
    loc_txt = {
        name = 'Big Ammo Box',
        text = {
            '{C:money}A{}{C:mult}m{}{C:green}m{}{C:money}o{} tarot cards can target {C:attention}#1#{} additional cards',
			'Idea: BoiRowan',
        }
    },
    config = {
        extra = {
            ammo = 2,
        },
    },
	
	loc_vars = function(self, info_queue, card)
        return {
            vars = { card.ability.extra.ammo }
        }
    end,
	
    redeem = function(self, card)
        if config.sfx ~= false then
            play_sound("fn_augment")
        end
		G.GAME.ammo_extra = (G.GAME.ammo_extra or 0) + card.ability.extra.ammo
    end,
}


----------------------------------------------
------------SUPPLY DROP CODE END----------------------





----------------------------------------------
------------BOOSTER CODE BEGIN----------------------
SMODS.Sound({
	key = "pack",
	path = "pack.ogg",
})
local disabled = {
    c_fn_LTMPizza = true,
    c_fn_LTMSlap = true,
    c_fn_LTMLaunchPad = true,
    c_fn_LTMStormFlip = true,
    c_fn_LTMRift = true,
    c_fn_LTMCube = true,
    c_fn_LTMAir = true,
    c_fn_LTMBottle = true,
    c_fn_LTMFish = true,
    c_fn_LTMPaint = true,
    c_fn_LTMBerry = true,
    c_fn_LTMReset = true,
    c_fn_LTMBazooka = true,
    c_fn_LTMSuperLaunchPad = true,
	c_fn_LTMCache = true,
}

SMODS.Booster({
    key = 'LTMBooster1',
    atlas = 'Jokers',
    pos = { x = 3, y = 8 },
    loc_txt = {
        name = 'LTM Pack',
        text = {
            'Choose {C:attention}#1#{} of up to',
            '{C:attention}#2#{} {C:purple}LTM{} cards to',
            'be used immediately'
        }
    },
    config = {
        extra = 3,
        choose = 1,
    },
    weight = 1,
    cost = 4,
    group_key = 'fn_LTMBooster1',
    draw_hand = true,
    unlocked = true,
    discovered = true,

    create_card = function(self, card)
        local i = 0
        repeat
            i = i + 1
            if card then card:remove() end
            card = create_card("LTMConsumableType", G.pack_cards, nil, nil, true, true, nil, "fn_LTMConsumableType")
        until not disabled[card.config.center.key] or i > 100
        return card
    end,

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.choose, card.ability.extra } }
    end,

    ease_background_colour = function(self)
        local effects = {
            { new_colour = G.C.SET.LTMConsumableType, special_colour = G.C.PURPLE, contrast = -0.1 },
            { new_colour = G.C.SET.LTMConsumableType, special_colour = G.C.BLACK, contrast = 2 },
            { new_colour = G.C.SET.LTMConsumableType, special_colour = G.C.RED, contrast = 5 },
            { new_colour = G.C.SET.LTMConsumableType, special_colour = G.C.BLUE, contrast = 5 },
            { new_colour = G.C.SET.LTMConsumableType, special_colour = G.C.DARK_RED, contrast = 2 },
            { new_colour = G.C.SET.LTMConsumableType, special_colour = G.C.DARK_BLUE, contrast = 2 },
            { new_colour = G.C.SET.LTMConsumableType, special_colour = G.C.BOOSTER, contrast = 2 },
            { new_colour = G.C.SET.LTMConsumableType, special_colour = G.C.ETERNAL, contrast = 1 },
            { new_colour = G.C.SET.Tarot, special_colour = G.C.ETERNAL, contrast = 1 },
            { new_colour = G.C.SET.Spectral, special_colour = G.C.ETERNAL, contrast = 1 },
            { new_colour = G.C.SET.Planet, special_colour = G.C.ETERNAL, contrast = 1 },
            { new_colour = G.C.SET.Enhanced, special_colour = G.C.ETERNAL, contrast = 1 },
            { new_colour = G.C.SET.LTMConsumableType, special_colour = G.C.BLACK, contrast = 0 },
            { new_colour = G.C.SET.LTMConsumableType, special_colour = G.C.DARK_EDITION, contrast = 2 },
            { new_colour = G.C.SET.LTMConsumableType, special_colour = G.C.MONEY, contrast = 2 },
            { new_colour = G.C.SET.LTMConsumableType, special_colour = G.C.GREY, contrast = 3 },
            { new_colour = G.C.SET.LTMConsumableType, special_colour = G.C.PALE_GREEN, contrast = 1 },
            { new_colour = G.C.SET.LTMConsumableType, special_colour = G.C.YELLOW, contrast = 4 },
            { new_colour = G.C.SET.LTMConsumableType, special_colour = G.C.CHANCE, contrast = 3 },
            { new_colour = G.C.SET.LTMConsumableType, special_colour = G.C.PURPLE, contrast = 2 },
            { new_colour = G.C.SET.LTMConsumableType, special_colour = G.C.ORANGE, contrast = 5 },
            { new_colour = G.C.SET.LTMConsumableType, special_colour = G.C.SUITS.Clubs, contrast = 1 },
            { new_colour = G.C.SET.LTMConsumableType, special_colour = G.C.SUITS.Hearts, contrast = 2 },
            { new_colour = G.C.SET.LTMConsumableType, special_colour = G.C.SUITS.Diamonds, contrast = 3 },
            { new_colour = G.C.SET.LTMConsumableType, special_colour = G.C.SUITS.Spades, contrast = 2 },
            { new_colour = G.C.SET.LTMConsumableType, special_colour = G.C.BOOSTER, contrast = 1 },
            { new_colour = G.C.SET.LTMConsumableType, special_colour = G.C.RENTAL, contrast = 2 },
            { new_colour = G.C.SET.LTMConsumableType, special_colour = G.C.SO_1.Hearts, contrast = 2 },
            { new_colour = G.C.SET.LTMConsumableType, special_colour = G.C.SO_1.Spades, contrast = 1 },
            { new_colour = G.C.SET.Default, special_colour = G.C.GREY, contrast = 2 },
            { new_colour = G.C.SET.Default, special_colour = G.C.PURPLE, contrast = 3 },
            { new_colour = G.C.SET.Default, special_colour = G.C.ORANGE, contrast = 4 },
            { new_colour = G.C.SET.Default, special_colour = G.C.CHANCE, contrast = 3 },
            { new_colour = G.C.SET.Default, special_colour = G.C.BLACK, contrast = 1 },
            { new_colour = G.C.SET.Enhanced, special_colour = G.C.YELLOW, contrast = 5 },
            { new_colour = G.C.SET.Enhanced, special_colour = G.C.PALE_GREEN, contrast = 2 },
            { new_colour = G.C.SET.Enhanced, special_colour = G.C.BOOSTER, contrast = 1 },
            { new_colour = G.C.SET.Joker, special_colour = G.C.RED, contrast = 4 },
            { new_colour = G.C.SET.Joker, special_colour = G.C.BLUE, contrast = 5 },
            { new_colour = G.C.SET.Joker, special_colour = G.C.SUITS.Spades, contrast = 2 },
            { new_colour = G.C.SET.Tarot, special_colour = G.C.MONEY, contrast = 2 },
            { new_colour = G.C.SET.Tarot, special_colour = G.C.PURPLE, contrast = 3 },
            { new_colour = G.C.SET.Planet, special_colour = G.C.ORANGE, contrast = 4 },
            { new_colour = G.C.SET.Planet, special_colour = G.C.SUITS.Clubs, contrast = 1 },
            { new_colour = G.C.SET.Spectral, special_colour = G.C.RED, contrast = 4 },
            { new_colour = G.C.SET.Spectral, special_colour = G.C.GREEN, contrast = 2 },
            { new_colour = G.C.SET.Voucher, special_colour = G.C.YELLOW, contrast = 3 },
        }
        local chosen_effect = effects[math.random(#effects)]
        ease_colour(G.C.DYN_UI.MAIN, G.C.SET.LTMConsumableType)
        ease_background_colour(chosen_effect)

        if self.config.sfx ~= false then
            play_sound("fn_pack")
        end
    end
})




----------------------------------------------
------------BOOSTER CODE END----------------------

----------------------------------------------
------------MEGA BOOSTER CODE BEGIN----------------------
SMODS.Atlas{
    key = 'Jokers', --atlas key
    path = 'Jokers.png', --atlas' path in (yourMod)/assets/1x or (yourMod)/assets/2x
    px = 71.1, --width of one card
    py = 95 -- height of one card
}

local disabled = {
    c_fn_LTMPizza = true,
    c_fn_LTMSlap = true,
	c_fn_LTMLaunchPad = true,
	c_fn_LTMStormFlip = true,
	c_fn_LTMRift = true,
	c_fn_LTMCube = true,
	c_fn_LTMAir = true,
	c_fn_LTMBottle = true,
	c_fn_LTMFish = true,
	c_fn_LTMPaint = true,
	c_fn_LTMBerry = true,
	c_fn_LTMReset = true,
	c_fn_LTMBazooka = true,
	c_fn_LTMSuperLaunchPad = true,
	c_fn_LTMCache = true,
}

SMODS.Booster({
    key = 'LTMBooster2',
    atlas = 'Jokers',
    pos = { x = 4, y = 8 },
    loc_txt = {
        name = 'MEGA LTM Pack',
        text = {
            'Choose {C:attention}#1#{} of up to',
            '{C:attention}#2#{} {C:purple}LTM{} cards to',
            'be used immediately'
        }
    },
    config = { extra = 5, choose = 2 },
    weight = 1,
    cost = 8,
    group_key = 'fn_LTMBooster2',
    draw_hand = true,
    unlocked = true,
    discovered = true,
    create_card = function(self, card)
        local i = 0
        repeat
            i = i + 1  -- Increment to prevent infinite loop
            card = create_card("LTMConsumableType", G.pack_cards, nil, nil, true, true, nil, "fn_LTMConsumableType")  -- Long card creation logic
        until not disabled[card.config.center.key] or i > 100 or card:remove()  -- If the card is disabled, regenerate it or clean up after 100 attempts
        return card  -- Return the valid card
    end,
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.choose, card.ability.extra } }
    end,
    ease_background_colour = function(self)
        local effects = {
            { new_colour = G.C.SET.LTMConsumableType, special_colour = G.C.PURPLE, contrast = -0.1 },
            { new_colour = G.C.SET.LTMConsumableType, special_colour = G.C.BLACK, contrast = 2 },
            { new_colour = G.C.SET.LTMConsumableType, special_colour = G.C.RED, contrast = 5 },
            { new_colour = G.C.SET.LTMConsumableType, special_colour = G.C.BLUE, contrast = 5 },
            { new_colour = G.C.SET.LTMConsumableType, special_colour = G.C.DARK_RED, contrast = 2 },
            { new_colour = G.C.SET.LTMConsumableType, special_colour = G.C.DARK_BLUE, contrast = 2 },
            { new_colour = G.C.SET.LTMConsumableType, special_colour = G.C.BOOSTER, contrast = 2 },
            { new_colour = G.C.SET.LTMConsumableType, special_colour = G.C.ETERNAL, contrast = 1 },
            { new_colour = G.C.SET.Tarot, special_colour = G.C.ETERNAL, contrast = 1 },
            { new_colour = G.C.SET.Spectral, special_colour = G.C.ETERNAL, contrast = 1 },
            { new_colour = G.C.SET.Planet, special_colour = G.C.ETERNAL, contrast = 1 },
            { new_colour = G.C.SET.Enhanced, special_colour = G.C.ETERNAL, contrast = 1 },
            { new_colour = G.C.SET.LTMConsumableType, special_colour = G.C.BLACK, contrast = 0 },
            { new_colour = G.C.SET.LTMConsumableType, special_colour = G.C.DARK_EDITION, contrast = 2 },
            { new_colour = G.C.SET.LTMConsumableType, special_colour = G.C.MONEY, contrast = 2 },
            { new_colour = G.C.SET.LTMConsumableType, special_colour = G.C.GREY, contrast = 3 },
            { new_colour = G.C.SET.LTMConsumableType, special_colour = G.C.PALE_GREEN, contrast = 1 },
            { new_colour = G.C.SET.LTMConsumableType, special_colour = G.C.YELLOW, contrast = 4 },
            { new_colour = G.C.SET.LTMConsumableType, special_colour = G.C.CHANCE, contrast = 3 },
            { new_colour = G.C.SET.LTMConsumableType, special_colour = G.C.PURPLE, contrast = 2 },
            { new_colour = G.C.SET.LTMConsumableType, special_colour = G.C.ORANGE, contrast = 5 },
            { new_colour = G.C.SET.LTMConsumableType, special_colour = G.C.SUITS.Clubs, contrast = 1 },
            { new_colour = G.C.SET.LTMConsumableType, special_colour = G.C.SUITS.Hearts, contrast = 2 },
            { new_colour = G.C.SET.LTMConsumableType, special_colour = G.C.SUITS.Diamonds, contrast = 3 },
            { new_colour = G.C.SET.LTMConsumableType, special_colour = G.C.SUITS.Spades, contrast = 2 },
            { new_colour = G.C.SET.LTMConsumableType, special_colour = G.C.BOOSTER, contrast = 1 },
            { new_colour = G.C.SET.LTMConsumableType, special_colour = G.C.RENTAL, contrast = 2 },
            { new_colour = G.C.SET.LTMConsumableType, special_colour = G.C.SO_1.Hearts, contrast = 2 },
            { new_colour = G.C.SET.LTMConsumableType, special_colour = G.C.SO_1.Spades, contrast = 1 },
            { new_colour = G.C.SET.Default, special_colour = G.C.GREY, contrast = 2 },
            { new_colour = G.C.SET.Default, special_colour = G.C.PURPLE, contrast = 3 },
            { new_colour = G.C.SET.Default, special_colour = G.C.ORANGE, contrast = 4 },
            { new_colour = G.C.SET.Default, special_colour = G.C.CHANCE, contrast = 3 },
            { new_colour = G.C.SET.Default, special_colour = G.C.BLACK, contrast = 1 },
            { new_colour = G.C.SET.Enhanced, special_colour = G.C.YELLOW, contrast = 5 },
            { new_colour = G.C.SET.Enhanced, special_colour = G.C.PALE_GREEN, contrast = 2 },
            { new_colour = G.C.SET.Enhanced, special_colour = G.C.BOOSTER, contrast = 1 },
            { new_colour = G.C.SET.Joker, special_colour = G.C.RED, contrast = 4 },
            { new_colour = G.C.SET.Joker, special_colour = G.C.BLUE, contrast = 5 },
            { new_colour = G.C.SET.Joker, special_colour = G.C.SUITS.Spades, contrast = 2 },
            { new_colour = G.C.SET.Tarot, special_colour = G.C.MONEY, contrast = 2 },
            { new_colour = G.C.SET.Tarot, special_colour = G.C.PURPLE, contrast = 3 },
            { new_colour = G.C.SET.Planet, special_colour = G.C.ORANGE, contrast = 4 },
            { new_colour = G.C.SET.Planet, special_colour = G.C.SUITS.Clubs, contrast = 1 },
            { new_colour = G.C.SET.Spectral, special_colour = G.C.RED, contrast = 4 },
            { new_colour = G.C.SET.Spectral, special_colour = G.C.GREEN, contrast = 2 },
            { new_colour = G.C.SET.Voucher, special_colour = G.C.YELLOW, contrast = 3 },
        }
        local random_index = math.random(#effects)
        local chosen_effect = effects[random_index]
        ease_colour(G.C.DYN_UI.MAIN, G.C.SET.LTMConsumableType)
        ease_background_colour(chosen_effect)
        if config.sfx ~= false then
            play_sound("fn_pack")
        end
    end
})

----------------------------------------------
------------MEGA BOOSTER CODE END----------------------

----------------------------------------------
------------AUGMENT BOOSTER CODE BEGIN----------------------

local enabled = {
    v_fn_Dumpster = true,
    v_fn_Dumpster2 = true,
    v_fn_Riftjector = true,
    v_fn_Riftjector2 = true,
    v_fn_Rarity = true,
    v_fn_Rarity2 = true,
    v_fn_Last = true,
    v_fn_Last2 = true,
    v_fn_Danger = true,
    v_fn_Danger2 = true,
    v_fn_Talk = true,
    v_fn_Talk2uh = true,
    v_fn_Forecast = true,
    v_fn_Forecast2 = true,
	v_fn_Bush = true,
	v_fn_Bush2 = true,
	v_fn_Nostalgia = true,
	v_fn_Supply = true,
	v_fn_Supply2 = true,
}

SMODS.Booster({
    key = 'AugmentBooster1',
    atlas = 'Jokers',
    pos = { x = 0, y = 46 },
    loc_txt = {
        name = 'Augment Pack',
        text = {
            'Choose {C:attention}#1#{} of up to',
            '{C:attention}#2#{} {C:spectral}Augments{} to',
            'be redeemed immediately'
        }
    },
    config = { extra = 3, choose = 1 },
    weight = 0,
    cost = 25,
    group_key = 'fn_AugmentBooster',
    draw_hand = false,
    unlocked = true,
    discovered = true,
    create_card = function(self, card)
        local i = 0
        repeat
            i = i + 1  -- prevent infinite loop
            card = create_card("Voucher", G.pack_cards, nil, nil, true, true, nil, "fn_LTMConsumableType")
        until enabled[card.config.center.key] or i > 100 or card:remove() -- accept only if enabled
        return card
    end,
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.choose, card.ability.extra } }
    end,
    ease_background_colour = function(self)
        local effects = {
            { new_colour = G.C.SET.Voucher, special_colour = G.C.BLUE, contrast = 3 },
        }
        local random_index = math.random(#effects)
        local chosen_effect = effects[random_index]
        ease_colour(G.C.DYN_UI.MAIN, G.C.SET.LTMConsumableType)
        ease_background_colour(chosen_effect)
        if config.sfx ~= false then
            play_sound("fn_pack")
        end
    end
})

----------------------------------------------
------------AUGMENT BOOSTER CODE END----------------------

local enabled = {
    v_fn_Dumpster = true,
    v_fn_Dumpster2 = true,
    v_fn_Riftjector = true,
    v_fn_Riftjector2 = true,
    v_fn_Rarity = true,
    v_fn_Rarity2 = true,
    v_fn_Last = true,
    v_fn_Last2 = true,
    v_fn_Danger = true,
    v_fn_Danger2 = true,
    v_fn_Talk = true,
    v_fn_Talk2uh = true,
    v_fn_Forecast = true,
    v_fn_Forecast2 = true,
	v_fn_Bush = true,
	v_fn_Bush2 = true,
	v_fn_Nostalgia = true,
	v_fn_Nostalgia2 = true,
}


SMODS.Booster({
    key = 'AugmentBooster2',
    atlas = 'Jokers',
    pos = { x = 2, y = 46 },
    loc_txt = {
        name = 'MEGA Augment Pack',
        text = {
            'Choose {C:attention}#1#{} of up to',
            '{C:attention}#2#{} {C:spectral}Augments{} to',
            'be redeemed immediately'
        }
    },
    config = { extra = 5, choose = 2 },
    weight = 0,
    cost = 40,
    group_key = 'fn_AugmentBooster2',
    draw_hand = false,
    unlocked = true,
    discovered = true,
    create_card = function(self, card)
        local i = 0
        repeat
            i = i + 1  -- prevent infinite loop
            card = create_card("Voucher", G.pack_cards, nil, nil, true, true, nil, "fn_LTMConsumableType")
        until enabled[card.config.center.key] or i > 100 or card:remove() -- accept only if enabled
        return card
    end,
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.choose, card.ability.extra } }
    end,
    ease_background_colour = function(self)
        local effects = {
            { new_colour = G.C.SET.Voucher, special_colour = G.C.BLUE, contrast = 3 },
        }
        local random_index = math.random(#effects)
        local chosen_effect = effects[random_index]
        ease_colour(G.C.DYN_UI.MAIN, G.C.SET.LTMConsumableType)
        ease_background_colour(chosen_effect)
        if config.sfx ~= false then
            play_sound("fn_pack")
        end
    end
})

----------------------------------------------
------------LTM TAG CODE END----------------------



SMODS.Tag{
    key = 'LTMTag1',
    atlas = 'Jokers',
    pos = {x = 3, y = 8},
    name = "Ship It!",
    order = 1,
    min_ante = 1,
    loc_txt = {
        name = 'Ship It!',
        text = {
            'Gives a free',
            '{C:purple}LTM Pack'
        },
    },
	
    loc_vars = function(self, info_queue)
		info_queue[#info_queue + 1] = G.P_CENTERS.p_fn_LTMBooster1
	end,
	
    apply = function(self, tag, context)
    if context.type == 'new_blind_choice' then
      local lock = tag.ID
            G.CONTROLLER.locks[lock] = true

            tag:yep('+', G.C.SECONDARY_SET.Spectral, function()
                -- Corrected key generation
                local key = 'p_fn_LTMBooster1'

                -- Validate the center exists
                local center = G.P_CENTERS[key]
                if not center then
                    print("Error: Center not found for key: " .. key)
                    G.CONTROLLER.locks[lock] = nil
                    return false -- Exit safely
                end

                -- Create the card with the validated center
                local card = Card(
                    G.play.T.x + G.play.T.w / 2 - G.CARD_W * 1.27 / 2,
                    G.play.T.y + G.play.T.h / 2 - G.CARD_H * 1.27 / 2,
                    G.CARD_W * 1.27, 
                    G.CARD_H * 1.27, 
                    G.P_CARDS.empty, 
                    center, 
                    {bypass_discovery_center = true, bypass_discovery_ui = true}
                )
                card.cost = 0
                card.from_tag = true

                -- Use the card and materialize it
                G.FUNCS.use_card({config = {ref_table = card}})
                card:start_materialize()
                G.CONTROLLER.locks[lock] = nil
                return true
            end)

            tag.triggered = true
            return true
        end
    end,
}
----------------------------------------------
------------LTM TAG CODE END----------------------

----------------------------------------------
------------LTM TAG 2 CODE BEGIN----------------------

SMODS.Tag{
    key = 'LTMTag2',
    atlas = 'Jokers',
    pos = {x = 4, y = 8},
    name = "Ship It Express!",
    order = 1,
    min_ante = 1,
    loc_txt = {
        name = 'Ship It Express!',
        text = {
            'Gives a free',
            '{C:purple}MEGA LTM Pack'
        },
    },
	
    loc_vars = function(self, info_queue)
		info_queue[#info_queue + 1] = G.P_CENTERS.p_fn_LTMBooster2
	end,
	
    apply = function(self, tag, context)
    if context.type == 'new_blind_choice' then
      local lock = tag.ID
            G.CONTROLLER.locks[lock] = true

            tag:yep('+', G.C.SECONDARY_SET.Spectral, function()
                -- Corrected key generation
                local key = 'p_fn_LTMBooster2'

                -- Validate the center exists
                local center = G.P_CENTERS[key]
                if not center then
                    print("Error: Center not found for key: " .. key)
                    G.CONTROLLER.locks[lock] = nil
                    return false -- Exit safely
                end

                -- Create the card with the validated center
                local card = Card(
                    G.play.T.x + G.play.T.w / 2 - G.CARD_W * 1.27 / 2,
                    G.play.T.y + G.play.T.h / 2 - G.CARD_H * 1.27 / 2,
                    G.CARD_W * 1.27, 
                    G.CARD_H * 1.27, 
                    G.P_CARDS.empty, 
                    center, 
                    {bypass_discovery_center = true, bypass_discovery_ui = true}
                )
                card.cost = 0
                card.from_tag = true

                -- Use the card and materialize it
                G.FUNCS.use_card({config = {ref_table = card}})
                card:start_materialize()
                G.CONTROLLER.locks[lock] = nil
                return true
            end)

            tag.triggered = true
            return true
        end
    end,
}

----------------------------------------------
------------LTM TAG 2 CODE END----------------------

----------------------------------------------
------------AUGMENT TAG CODE BEGIN----------------------

SMODS.Tag{
    key = 'AugmentTag',
    atlas = 'Jokers',
    pos = {x = 1, y = 46},
    name = "Reality Augmentation Device",
    order = 1,
    min_ante = 1,
    loc_txt = {
        name = 'Reality Augmentation Device',
        text = {
            'Gives a free',
            '{C:spectral}Augment Pack'
        },
    },
    
	loc_vars = function(self, info_queue)
		info_queue[#info_queue + 1] = G.P_CENTERS.p_fn_AugmentBooster1
	end,
	
    apply = function(self, tag, context)
    if context.type == 'new_blind_choice' then
      local lock = tag.ID
            G.CONTROLLER.locks[lock] = true

            tag:yep('+', G.C.SECONDARY_SET.Spectral, function()
                -- Corrected key generation
                local key = 'p_fn_AugmentBooster1'

                -- Validate the center exists
                local center = G.P_CENTERS[key]
                if not center then
                    print("Error: Center not found for key: " .. key)
                    G.CONTROLLER.locks[lock] = nil
                    return false -- Exit safely
                end

                -- Create the card with the validated center
                local card = Card(
                    G.play.T.x + G.play.T.w / 2 - G.CARD_W * 1.27 / 2,
                    G.play.T.y + G.play.T.h / 2 - G.CARD_H * 1.27 / 2,
                    G.CARD_W * 1.27, 
                    G.CARD_H * 1.27, 
                    G.P_CARDS.empty, 
                    center, 
                    {bypass_discovery_center = true, bypass_discovery_ui = true}
                )
                card.cost = 0
                card.from_tag = true

                -- Use the card and materialize it
                G.FUNCS.use_card({config = {ref_table = card}})
                card:start_materialize()
                G.CONTROLLER.locks[lock] = nil
                return true
            end)

            tag.triggered = true
            return true
        end
    end,
}

----------------------------------------------
------------AUGMENT TAG CODE END----------------------

SMODS.Tag{
    key = 'AugmentTag2',
    atlas = 'Jokers',
    pos = {x = 3, y = 46},
    name = "Dual Reality Augmentation Device",
    order = 1,
    min_ante = 1,
    loc_txt = {
        name = 'Dual Reality Augmentation Device',
        text = {
            'Gives a free',
            '{C:spectral}MEGA Augment Pack'
        },
    },
    
	loc_vars = function(self, info_queue)
		info_queue[#info_queue + 1] = G.P_CENTERS.p_fn_AugmentBooster2
	end,
	
    apply = function(self, tag, context)
    if context.type == 'new_blind_choice' then
      local lock = tag.ID
            G.CONTROLLER.locks[lock] = true

            tag:yep('+', G.C.SECONDARY_SET.Spectral, function()
                -- Corrected key generation
                local key = 'p_fn_AugmentBooster2'

                -- Validate the center exists
                local center = G.P_CENTERS[key]
                if not center then
                    print("Error: Center not found for key: " .. key)
                    G.CONTROLLER.locks[lock] = nil
                    return false -- Exit safely
                end

                -- Create the card with the validated center
                local card = Card(
                    G.play.T.x + G.play.T.w / 2 - G.CARD_W * 1.27 / 2,
                    G.play.T.y + G.play.T.h / 2 - G.CARD_H * 1.27 / 2,
                    G.CARD_W * 1.27, 
                    G.CARD_H * 1.27, 
                    G.P_CARDS.empty, 
                    center, 
                    {bypass_discovery_center = true, bypass_discovery_ui = true}
                )
                card.cost = 0
                card.from_tag = true

                -- Use the card and materialize it
                G.FUNCS.use_card({config = {ref_table = card}})
                card:start_materialize()
                G.CONTROLLER.locks[lock] = nil
                return true
            end)

            tag.triggered = true
            return true
        end
    end,
}

----------------------------------------------
------------FRACTURE CODE BEGIN----------------------

SMODS.Atlas({ key = "Blinds", atlas_table = "ANIMATION_ATLAS", path = "Blinds.png", px = 34, py = 34, frames = 21 })

if config.blinds ~= false then
    SMODS.Blind {
        loc_txt = {
            name = 'Fracture',
            text = { 'All played cards are destroyed' }
        },
        key = 'Fracture',
        name = 'Fracture',
        config = {},
        boss = { min = 1, max = 10, hardcore = true },
        mult = 1,
        boss_colour = HEX("672A62"),
        atlas = "Blinds",
        pos = { x = 0, y = 0 },
        dollars = 5,

        in_pool = function(self)
            return not G.GAME.blinds_fought_fracture
        end,

        calculate = function(self, card, context)
            if context.destroy_card and context.cardarea == G.play and not G.GAME.blind.disabled or context.cardarea == "unscored" and not G.GAME.blind.disabled then
                return {remove = true}
            end
        end,

        defeat = function(self)
            G.GAME.blinds_fought_fracture = true
        end
    }
end

----------------------------------------------
------------FRACTURE CODE END----------------------

----------------------------------------------
------------ZERO BUILD CODE BEGIN----------------------

if config.blinds ~= false then
    SMODS.Blind {
        loc_txt = {
            name = 'Zero Build',
            text = { 'Wood Brick and Metal are debuffed' }
        },
        key = 'NoBuild',
        name = 'Zero Build',
        config = {},
        boss = { min = 1, max = 10, hardcore = true },
        boss_colour = HEX("ee7143"),
        atlas = "Blinds",
        pos = { x = 0, y = 1 },
        dollars = 5,
		
        in_pool = function(self)
            if not G.playing_cards then return false end
            
            for _, card in ipairs(G.playing_cards) do
                if card and card.config and card.config.center then
                    if card.config.center == G.P_CENTERS.m_fn_Wood or
                       card.config.center == G.P_CENTERS.m_fn_Brick or
                       card.config.center == G.P_CENTERS.m_fn_Metal then
                        return true
                    end
                end
            end
            return false
        end,

        recalc_debuff = function(self, card, from_blind)
            if not G.GAME.blind.disabled and card.area ~= G.jokers then
                local debuff_centers = {
                    G.P_CENTERS.m_fn_Wood,
                    G.P_CENTERS.m_fn_Brick,
                    G.P_CENTERS.m_fn_Metal,
                }

                for _, center in ipairs(debuff_centers) do
                    if card.config.center == center then
                        card:set_debuff(true)
                        return true
                    end
                end
            end
            return false
        end
    }
end



----------------------------------------------
------------ZERO BUILD CODE END----------------------


----------------------------------------------
------------TORNADO CODE BEGIN----------------------

-- tornado function
local original_game_update = Game.update
local tornado_shuffle_timer = 0

function Game:update(dt)
    original_game_update(self, dt)

    -- Only run if the current blind is Tornado
    if G.GAME.blind and G.GAME.blind.name == 'Tornado' and not G.GAME.blind.disabled then
        tornado_shuffle_timer = tornado_shuffle_timer + dt
        if tornado_shuffle_timer > 1 then -- shuffle every 2 seconds
            tornado_shuffle_timer = 0
            G.jokers:shuffle('aajk')
        end
    else
        -- Reset timer when not on Tornado
        tornado_shuffle_timer = 0
    end
end



if config.blinds ~= false then
    SMODS.Blind {
        loc_txt = {
            name = 'Tornado',
            text = { 'Jokers are constantly shuffled randomly', 'Idea kxttyfrickfish', }
        },
        key = 'Tornado',
        name = 'Tornado',
        config = {},
        boss = { min = 1, max = 10, hardcore = true },
        mult = 1.5,
        boss_colour = HEX("424242"),
        atlas = "Blinds",
        pos = { x = 0, y = 2 },
        dollars = 5,
    }
end

----------------------------------------------
------------TORNADO CODE END----------------------

----------------------------------------------
------------MRBLOCKU CODE BEGIN----------------------

SMODS.Sound({
	key = "block",
	path = "block.ogg",
})

if config.blinds ~= false then
    SMODS.Blind {
        key = 'MrBlockU',
        name = 'MrBlockU',
        loc_txt = {
            name = 'MrBlockU',
            text = { 'ALL Fortlatro content Debuffed' }
        },
        config = {},
        boss = { min = 4, max = 10, hardcore = true },
        boss_colour = HEX("de1e1d"),
        atlas = "Blinds",
        pos = { x = 0, y = 3 },
        dollars = 10,
		
        calculate = function(self, card, context)
            if context.setting_blind then
                if config.sfx ~= false then
                    play_sound("fn_block") 
                end
            end
        end,
		
        recalc_debuff = function(self, card, from_blind)
            if (card.area == G.jokers) and not G.GAME.blind.disabled and fortlatro_jokers[card.config.center_key] then
                return true
            end

            local debuff_keys = {
                'm_fn_Crystal','m_fn_Wood','m_fn_Brick','m_fn_Metal',
                'm_fn_StormSurge','m_fn_Legendary','m_fn_Cubic','m_fn_Shell',
                'm_fn_Heavy','m_fn_Light','m_fn_Medium','m_fn_Rocket',
                'm_fn_Lego','m_fn_Creator','m_fn_Xp',
            }

            local voucher_keys = {
                'v_fn_Dumpster','v_fn_Dumpster2',
                'v_fn_Riftjector','v_fn_Riftjector2',
                'v_fn_Rarity','v_fn_Rarity2',
                'v_fn_Last','v_fn_Last2',
                'v_fn_Danger','v_fn_Danger2',
                'v_fn_Talk','v_fn_Talk2uh',
                'v_fn_Forecast','v_fn_Forecast2',
                'v_fn_Bush','v_fn_Bush2',
                'v_fn_Nostalgia','v_fn_Nostalgia2',
                'v_fn_Supply','v_fn_Supply2'
            }

            local should_debuff = false

            -- Seals
            local seals = {
                'fn_StormSeal','fn_GlitchedSeal','fn_BoogieSeal',
                'fn_HopSeal','fn_ZeroSeal','fn_HeavySeal','fn_SponsorSeal'
            }
            if card.seal and table.contains(seals, card.seal) then
                should_debuff = true
                card.debuffed_by_blind = true
            end

            -- Editions
            if card.edition then
                if card.edition.fn_Nitro or card.edition.fn_Shockwaved or card.edition.fn_Mythic then
                    should_debuff = true
                    card.debuffed_by_blind = true
                end
            end

            -- Debuff all Fortlatro consumables
            for _, v in ipairs(G.consumeables.cards) do
                if v.ability.set == 'LTMConsumableType' then
                    v:set_debuff(true)
                    v.debuffed_by_blind = true
                end
            end

            -- Debuff Fortlatro vouchers by key
            for _, v in ipairs(G.vouchers.cards) do
                for _, key in ipairs(voucher_keys) do
                    if v.config.center_key == key then
                        v:set_debuff(true)
                        v.debuffed_by_blind = true
                    end
                end
            end

            -- Debuff Fortlatro jokers by key
            for _, key in ipairs(debuff_keys) do
                if G.P_CENTERS[key] and card.config.center == G.P_CENTERS[key] then
                    should_debuff = true
                    break
                end
            end

            if should_debuff then
                card.debuffed_by_blind = true
                self.triggered = true
                return true
            end
        end,

        disable = function(self)
            for _, card in pairs(G.playing_cards) do
                if card.debuffed_by_blind then
                    card:set_debuff()
                    card.debuffed_by_blind = nil
                end
            end
            for _, card in ipairs(G.consumeables.cards) do
                card:set_debuff()
                card.debuffed_by_blind = nil
            end
            for _, card in ipairs(G.vouchers.cards) do
                card:set_debuff()
                card.debuffed_by_blind = nil
            end
            self.triggered = false
        end,

        defeat = function(self)
            for _, card in pairs(G.playing_cards) do
                if card.debuffed_by_blind then
                    card:set_debuff()
                    card.debuffed_by_blind = nil
                end
            end
            for _, card in ipairs(G.consumeables.cards) do
                card:set_debuff()
                card.debuffed_by_blind = nil
            end
            for _, card in ipairs(G.vouchers.cards) do
                card:set_debuff()
                card.debuffed_by_blind = nil
            end
            self.triggered = false
        end
    }
end


----------------------------------------------
------------MRBLOCKU CODE END----------------------

----------------------------------------------
------------PEELY PARTY CODE BEGIN----------------------

SMODS.Sound({
	key = "party",
	path = "party.ogg",
})

if config.blinds ~= false then
    SMODS.Blind {
        key = 'PeelyParty',
        name = 'Peely Party',
        loc_txt = {
            name = 'Peely Party',
            text = { 'All Jokers replaced with Gros Michel{}' }
        },
        boss = { min = 3, max = 10, hardcore = true },
        boss_colour = HEX("fee254"),
        atlas = "Blinds",
        pos = { x = 0, y = 4 },
        dollars = 10,
        
        calculate = function(self, card, context)
            if context.setting_blind then
                if config.sfx ~= false then
                    play_sound("fn_party")
                end

                -- Init storage
                G.GAME.stored_peelyparty_jokers = {}

                -- Store jokers with editions (and more if needed)
                for _, joker in ipairs(G.jokers.cards) do
                    table.insert(G.GAME.stored_peelyparty_jokers, {
                        key = joker.config.center.key,
                        edition = joker.edition and copy_table(joker.edition) or nil,
                        edition_key = joker.edition and joker.edition.key or nil, -- fallback if needed
                        seal = joker.seal or nil, -- if your mod uses seals
                        enhancement = joker.enhancement or nil -- if you want enhancements too
                    })
                end

                -- Replace jokers with Gros Michels
                local jokers_to_replace = {}
                for _, joker in ipairs(G.jokers.cards) do
                    table.insert(jokers_to_replace, joker)
                end
                for _, joker in ipairs(jokers_to_replace) do
                    joker:start_dissolve()
                    local new_joker = create_card('Joker', G.jokers, nil, nil, nil, nil, 'j_gros_michel')
                    new_joker:add_to_deck()
                    G.jokers:emplace(new_joker)
                end
            end
        end,
		
		disable = function(self)
            -- Remove Gros Michels
            local current_jokers = {}
            for _, joker in ipairs(G.jokers.cards) do
                table.insert(current_jokers, joker)
            end
            for _, joker in ipairs(current_jokers) do
                joker:start_dissolve()
            end

            -- Restore original jokers w/ editions
            for _, stored in ipairs(G.GAME.stored_peelyparty_jokers or {}) do
                local restored = create_card('Joker', G.jokers, nil, nil, nil, nil, stored.key)

                if stored.edition then
                    restored:set_edition(stored.edition, true)
                end
                if stored.seal then
                    restored:set_seal(stored.seal)
                end
                if stored.enhancement then
                    restored:set_enhancement(stored.enhancement)
                end

                restored:add_to_deck()
                G.jokers:emplace(restored)
            end

            G.GAME.stored_peelyparty_jokers = nil
		end,

        defeat = function(self)
            -- Do the same as disable
            local current_jokers = {}
            for _, joker in ipairs(G.jokers.cards) do
                table.insert(current_jokers, joker)
            end
            for _, joker in ipairs(current_jokers) do
                joker:start_dissolve()
            end

            for _, stored in ipairs(G.GAME.stored_peelyparty_jokers or {}) do
                local restored = create_card('Joker', G.jokers, nil, nil, nil, nil, stored.key)

                if stored.edition then
                    restored:set_edition(stored.edition, true)
                end
                if stored.seal then
                    restored:set_seal(stored.seal)
                end
                if stored.enhancement then
                    restored:set_enhancement(stored.enhancement)
                end

                restored:add_to_deck()
                G.jokers:emplace(restored)
            end

            G.GAME.stored_peelyparty_jokers = nil
        end
    }
end


----------------------------------------------
------------PEELY PARTY CODE END----------------------

----------------------------------------------
------------STORM SEAL CODE BEGIN----------------------

if config.oldcalccompat ~= false then
    SMODS.Seal {
        name = "Storm Seal",
        key = "StormSeal",
        badge_colour = HEX("9500f3"),
        loc_txt = {
            label = 'Storm Seal',
            name = 'Storm Seal',
            text = {
                "Creates a {C:purple}LTM Card{}",
                "when {C:attention}discarded{}",
                "{C:inactive}(Must have room){}"
            }
        },
        atlas = "Jokers",
        pos = {x=2, y=2},
        calculate = function(self, card, context)
            if context.discard then
                G.E_MANAGER:add_event(Event({
                    trigger = "after",
                    func = function()
                        if G.consumeables.config.card_limit > #G.consumeables.cards then
                            local c = create_card("LTMConsumableType", G.consumeables, nil, nil, nil, nil, nil, "fn_ltm_sword")
                            c:add_to_deck()
                            G.consumeables:emplace(c)
                            card:juice_up()
                        end
                        return true
                    end,
                }))
                return true
            end
        end,
    }
end

if config.newcalccompat ~= false then
    SMODS.Seal {
        name = "Storm Seal",
        key = "StormSeal",
        badge_colour = HEX("9500f3"),
        loc_txt = {
            label = 'Storm Seal',
            name = 'Storm Seal',
            text = {
                "Creates a {C:purple}LTM Card{}",
                "when {C:mult}discarding{} a card",
                "{C:inactive}(Must have room){}"
            }
        },
        atlas = "Jokers",
        pos = {x=2, y=2},
        calculate = function(self, card, context)
            if context.cardarea == G.hand and context.discard then  -- Ensure it's the Storm Seal card being discarded
                G.E_MANAGER:add_event(Event({
                    func = function()
                        if G.consumeables.config.card_limit > #G.consumeables.cards then
                            local c = create_card("LTMConsumableType", G.consumeables, nil, nil, nil, nil, nil, "fn_ltm_sword")
                            if c then
                                c:add_to_deck()
                                G.consumeables:emplace(c)
                            end
                        end

                        card:juice_up() -- Ensures the card is "juiced up" as part of the logic flow.
                        return true
                    end
                }))
            end
        end
    }
end

----------------------------------------------
------------STORM SEAL CODE END----------------------

----------------------------------------------
------------GLITCHED SEAL CODE BEGIN----------------------

if config.oldcalccompat ~= false then
    SMODS.Seal {
        name = "Glitched Seal",
        key = "GlitchedSeal",
        badge_colour = HEX("603d65"),
        loc_txt = {
            label = 'Glitched Seal',
            name = 'Glitched Seal',
            text = {
                "Does something random",
                "when {C:attention}played and unscoring{}",
            }
        },
        atlas = "Jokers",
        pos = {x=3, y=2},
        calculate = function(self, card, context)
            -- Check if extra is nil or not and initialize if necessary
            if not card.ability.extra then
                card.ability.extra = {hands = 1, discards = 1}
            end

            if context.unscoring then
                local rand = math.random(1, 8) -- Pick a random effect

                if rand == 1 then
                    local consumable = create_card("LTMConsumableType", G.consumeables, nil, nil, nil, nil, nil, "fn_ltm_sword")
                    if consumable then
                        consumable:add_to_deck()
                        G.consumeables:emplace(consumable)
                    end

                elseif rand == 2 then
                    ease_dollars(5)
                    G.GAME.dollar_buffer = (G.GAME.dollar_buffer or 0) + 5
                    G.E_MANAGER:add_event(Event({func = (function() G.GAME.dollar_buffer = 0; return true end)}))

                elseif rand == 3 then
                    local consumable = create_card("Tarot", G.consumeables, nil, nil, nil, nil, nil, "c_fool")
                    if consumable then
                        consumable:add_to_deck()
                        G.consumeables:emplace(consumable)
                    end

                elseif rand == 4 then
                    ease_hands_played(1)

                elseif rand == 5 then
                    ease_discard(1)

                elseif rand == 6 then
                    local consumable = create_card("Spectral", G.consumeables, nil, nil, nil, nil, nil, "c_fool")
                    if consumable then
                        consumable:add_to_deck()
                        G.consumeables:emplace(consumable)
                    end

                elseif rand == 7 then
                    draw_card(G.play, G.hand, 100, 'up', true, card, 0, false, false, 1, false)

                elseif rand == 8 then
                    local random_tags = {
                        "tag_fn_LTMTag1", "tag_fn_LTMTag2", 'tag_uncommon', 'tag_rare', 'tag_negative',
                        'tag_foil', 'tag_holo', 'tag_polychrome', 'tag_investment', 'tag_voucher', 'tag_boss',
                        'tag_standard', 'tag_charm', 'tag_meteor', 'tag_buffoon', 'tag_handy', 'tag_garbage',
                        'tag_ethereal', 'tag_coupon', 'tag_double', 'tag_juggle', 'tag_d_six', 'tag_top_up',
                        'tag_skip', 'tag_orbital', 'tag_economy'
                    }
                    local chosen_tag = random_tags[math.random(#random_tags)]

                    G.E_MANAGER:add_event(Event({
                        func = (function()
                            add_tag(Tag(chosen_tag))
                            play_sound('generic1', 0.9 + math.random() * 0.1, 0.8)
                            play_sound('holo1', 1.2 + math.random() * 0.1, 0.4)
                            return true
                        end)
                    }))
                end

                card:juice_up()
                return true
            end
            return false
        end,
    }
end

if config.newcalccompat ~= false then
    SMODS.Seal {
    name = "Glitched Seal",
    key = "GlitchedSeal",
    badge_colour = HEX("603d65"),
    loc_txt = {
        label = 'Glitched Seal',
        name = 'Glitched Seal',
        text = {
            "Does something random",
            "when {C:attention}played and unscoring{}",
        }
    },
    atlas = "Jokers",
    pos = {x=3, y=2},
    calculate = function(self, card, context)
        if context.cardarea == "unscored" and context.main_scoring then
            G.E_MANAGER:add_event(Event({
                func = function()
                    local rand = math.random(1, 8)

                    if rand == 1 then
                        local c = create_card("LTMConsumableType", G.consumeables, nil, nil, nil, nil, nil, "fn_ltm_sword")
                        if c then
                            c:add_to_deck()
                            G.consumeables:emplace(c)
                        end

                    elseif rand == 2 then
                        ease_dollars(5)
                        G.GAME.dollar_buffer = (G.GAME.dollar_buffer or 0) + 5
                        G.E_MANAGER:add_event(Event({func = function()
                            G.GAME.dollar_buffer = 0
                            return true
                        end}))

                    elseif rand == 3 then
                        local c = create_card("Tarot", G.consumeables, nil, nil, nil, nil, nil, "c_fool")
                        if c then
                            c:add_to_deck()
                            G.consumeables:emplace(c)
                        end

                    elseif rand == 4 then
                        ease_hands_played(1)

                    elseif rand == 5 then
                        ease_discard(1)

                    elseif rand == 6 then
                        local c = create_card("Spectral", G.consumeables, nil, nil, nil, nil, nil, "c_fool")
                        if c then
                            c:add_to_deck()
                            G.consumeables:emplace(c)
                        end

                    elseif rand == 7 then
						G.E_MANAGER:add_event(Event({
							func = function()
								local _copy = copy_card(card)
								if _copy then
									-- Register the copy as a playing card
									table.insert(G.playing_cards, _copy)

									-- Add to deck to maintain reference (won't be shuffled)
									_copy:add_to_deck()

									-- Emplace it into hand
									G.hand:emplace(_copy)

									-- Show animation
									_copy:start_materialize(nil, nil)

									-- Destroy original
									card:start_dissolve()
								end
								return true
							end
						}))


                    elseif rand == 8 then
                        local random_tags = {
                            "tag_fn_LTMTag1", "tag_fn_LTMTag2", 'tag_uncommon', 'tag_rare', 'tag_negative',
                            'tag_foil', 'tag_holo', 'tag_polychrome', 'tag_investment', 'tag_voucher', 'tag_boss',
                            'tag_standard', 'tag_charm', 'tag_meteor', 'tag_buffoon', 'tag_handy', 'tag_garbage',
                            'tag_ethereal', 'tag_coupon', 'tag_double', 'tag_juggle', 'tag_d_six', 'tag_top_up',
                            'tag_skip', 'tag_orbital', 'tag_economy'
                        }
                        local chosen_tag = random_tags[math.random(#random_tags)]

                        add_tag(Tag(chosen_tag))
                        play_sound('generic1', 0.9 + math.random() * 0.1, 0.8)
                        play_sound('holo1', 1.2 + math.random() * 0.1, 0.4)
                    end

                    card:juice_up()
                    return true
                end
            }))
        end
    end
}
end


----------------------------------------------
------------GLITCHED SEAL CODE END----------------------

----------------------------------------------
------------BOOGIE SEAL CODE BEGIN----------------------

SMODS.Sound({
	key = "boogie",
	path = "boogie.ogg",
})

if config.oldcalccompat ~= false then
    SMODS.Seal {
        name = "Boogie Seal",
        key = 'BoogieSeal',
        config = {
            extra = { odds = 4, stored_hands = nil },
        },
        atlas = 'Jokers',
        pos = { x = 4, y = 2 },
        badge_colour = HEX("2e2b2e"),
        loc_txt = {
            label = 'Boogie Seal',
            name = 'Boogie Seal',
            text = {
                'If {C:attention}Played Hand{} contains this seal',
                '{C:green,E:1,S:1.1}#2# in #1#{} chance to not consume a hand',
            }
        },
        loc_vars = function(self, info_queue, card)
            return { vars = { self.config.extra.odds, G.GAME.probabilities.normal, self.config.extra.stored_hands } }
        end,
        calculate = function(self, card, context)
            local round = G.GAME.current_round
            if context.cardarea == G.play and not context.repetition and not context.blueprint then
                -- Store the current hands left if not already stored
                if not self.config.extra.stored_hands then
                    self.config.extra.stored_hands = round.hands_left
                end

                -- If the effect triggers, reset the hand count to what it was before playing
                if pseudorandom('boogie_seal') < (G.GAME.probabilities.normal / self.config.extra.odds) then
                    round.hands_left = self.config.extra.stored_hands + 1
					if next(SMODS.find_card('j_fn_GG')) then
						ease_dollars(3)
					end
                    if config.sfx ~= false then
                        play_sound("fn_boogie") 
                    end
                end
            end
        end
    }
end

if config.newcalccompat ~= false then
    SMODS.Seal {
        name = "Boogie Seal",
        key = 'BoogieSeal',
        config = {
            extra = { odds = 4 },
        },
        atlas = 'Jokers',
        pos = { x = 4, y = 2 },
        badge_colour = HEX("2e2b2e"),
        loc_txt = {
            label = 'Boogie Seal',
            name = 'Boogie Seal',
            text = {
                'If {C:attention}Played Hand{} contains this seal',
                '{C:green,E:1,S:1.1}#2# in #1#{} chance to not consume a hand',
            }
        },
        loc_vars = function(self, info_queue, card)
            return { vars = { self.config.extra.odds, G.GAME.probabilities.normal } }
        end,
        calculate = function(self, card, context)
            local round = G.GAME.current_round
			if context.hand_drawn or context.discard or context.setting_blind then
				round._refund_saved_hands = round.hands_left
			end
            if (context.cardarea == G.play or context.cardarea == "unscored") and context.main_scoring then


                local roll = pseudorandom('boogie_seal')
                local chance = (G.GAME.probabilities.normal / self.config.extra.odds)

                if roll < chance then
                    round.hands_left = round._refund_saved_hands

                    if next(SMODS.find_card('j_fn_GG')) then
                        ease_dollars(3)
                    end

                    if config.sfx ~= false then
                        play_sound("fn_boogie")
                    end
                end
            end
        end
    }
end





----------------------------------------------
------------BOOGIE SEAL CODE END----------------------

----------------------------------------------
------------HOP SEAL CODE BEGIN----------------------

SMODS.Sound({
	key = "hop",
	path = "hop.ogg",
})

if config.oldcalccompat ~= false then
    SMODS.Seal {
        name = "Hop Seal",
        key = 'HopSeal',
        config = {
            extra = { odds = 3 },
        },
        atlas = 'Jokers',
        pos = { x = 3, y = 24 },
        badge_colour = HEX("3f89ab"),
        loc_txt = {
            label = 'Hop Seal',
            name = 'Hop Seal',
            text = {
                'When {C:attention}scoring{} this card',
				'{C:green,E:1,S:1.1}#2# in #1#{} chance to gain +1 {C:mult}Discard{}',
				'Idea: BoiRowan'
            }
        },
        loc_vars = function(self, info_queue, card)
            return { vars = { self.config.extra.odds, G.GAME.probabilities.normal } }
        end,
        calculate = function(self, card, context)
            if context.cardarea == G.play and not context.repetition and not context.blueprint then
                -- If the effect triggers, gain a discard
                if pseudorandom('hop_seal') < (G.GAME.probabilities.normal / self.config.extra.odds) then
                    ease_discard(1)
                    if config.sfx ~= false then
                        play_sound("fn_hop") 
                    end
                end
            end
        end
    }
end

if config.newcalccompat ~= false then
    SMODS.Seal {
        name = "Hop Seal",
        key = 'HopSeal',
        config = {
            extra = { odds = 3 },
        },
        atlas = 'Jokers',
        pos = { x = 3, y = 24 },
        badge_colour = HEX("3f89ab"),
        loc_txt = {
            label = 'Hop Seal',
            name = 'Hop Seal',
            text = {
                'When {C:attention}scoring{} this card',
				'{C:green,E:1,S:1.1}#2# in #1#{} chance to gain +1 {C:mult}Discard{}',
				'Idea: BoiRowan'
            }
        },
        loc_vars = function(self, info_queue, card)
            return { vars = { self.config.extra.odds, G.GAME.probabilities.normal } }
        end,
        calculate = function(self, card, context)
            if context.cardarea == G.play and context.main_scoring then
                -- If the effect triggers, gain a discard
                if pseudorandom('hop_seal') < (G.GAME.probabilities.normal / self.config.extra.odds) then
                    ease_discard(1)
                    if config.sfx ~= false then
                        play_sound("fn_hop") 
                    end
                end
            end
        end
    }
end

----------------------------------------------
------------HOP SEAL CODE END----------------------

----------------------------------------------
------------ZERO POINT SEAL CODE BEGIN----------------------

SMODS.Seal {
    name = "Zero Point Seal",
    key = "ZeroSeal",
    config = {
        extra = { cards = 2, drawn = 0 },
    },
    badge_colour = HEX("38faff"),
    loc_txt = {
        label = 'Zero Point Seal',
        name = 'Zero Point Seal',
        text = {
            "When {C:attention}drawn{} draw {C:attention}#1#{} additional cards",
            "Idea: BoiRowan"
        }
    },
    atlas = "Jokers",
    pos = {x=1, y=29},

    loc_vars = function(self, info_queue, card)
        return { vars = { self.config.extra.cards, self.config.extra.drawn } }
    end,
	
	update = function(self, card)
        if card.seal == 'fn_ZeroSeal' and not card.ability.extra then
			card.ability.extra = {cards = 2, drawn = 0}
		end
    end,
	
    calculate = function(self, card, context)
		if not card.ability.extra then
			card.ability.extra = {cards = 2, drawn = 0}
		end
        if context.hand_drawn and card.area == G.hand then  -- Check if a hand is drawn
            if card.ability.extra.drawn == 0 then
                G.FUNCS.draw_from_deck_to_hand(card.ability.extra.cards)
                card.ability.extra.drawn = 1
            end
        end
        if context.end_of_round then
            card.ability.extra.drawn = 0
        end
    end
}

----------------------------------------------
------------ZERO POINT SEAL CODE END----------------------

----------------------------------------------
------------HEAVY SEAL CODE BEGIN----------------------

SMODS.Seal {
    name = "Heavy Seal",
    key = "HeavySeal",
    badge_colour = HEX("d34e00"),
    loc_txt = {
        label = 'Heavy Seal',
        name = 'Heavy Seal',
        text = {
            "This card is always {C:attention}Flipped{}",
            "Idea: {C:inactive}kxttyfrickfish"
        }
    },
    atlas = "Jokers",
    pos = {x=3, y=34},
	
    calculate = function(self, card, context)
        if card.seal == 'fn_HeavySeal' then
			if card.facing == 'front' then
				card:flip()  -- Flip the card
			end
		end
    end
}

----------------------------------------------
------------HEAVY SEAL CODE END----------------------

if config.newcalccompat ~= false then
    SMODS.Seal {
        name = "Sponsorship Seal",
        key = 'SponsorSeal',
        config = {
            extra = { dollars = 1, dollars_add = 0.1 },
        },
        atlas = 'Jokers',
        pos = { x = 0, y = 41 },
        badge_colour = HEX("f7db26"),
        loc_txt = {
            label = 'Sponsorship Seal',
            name = 'Sponsorship Seal',
            text = {
                'While held each scored card gives {C:money}$#1#{}',
				'Increase this by {C:money}$#2#{} for each card scored',
				'Idea: Your Average User'
            }
        },
        loc_vars = function(self, info_queue, card)
            return { vars = { self.config.extra.dollars, self.config.extra.dollars_add } }
        end,
		
		
        calculate = function(self, card, context)
			
			if not card.ability.extra then
				card.ability.extra = { dollars = 1,  dollars_add = 0.1, in_hand = 0 }
			end
			
            if context.cardarea == G.hand then
				card.ability.extra.in_hand = 1
				self.config.extra.dollars = card.ability.extra.dollars
			end
			
			if context.cardarea ~= G.hand then
				card.ability.extra.in_hand = 0
				self.config.extra.dollars = card.ability.extra.dollars
			end
			
			if context.final_scoring_step and card.ability.extra.in_hand == 1 then

				local current_round = #context.scoring_hand * card.ability.extra.dollars_add
				card.ability.extra.dollars = card.ability.extra.dollars + card.ability.extra.dollars_add * #context.scoring_hand
				local reward = card.ability.extra.dollars - current_round
				ease_dollars(reward * #context.scoring_hand)
				self.config.extra.dollars = card.ability.extra.dollars
			end
        end
    }
end

----------------------------------------------
------------CRAC DECK CODE BEGIN----------------------
-- Add Joker
function joker_add(jKey)

    if type(jKey) == 'string' then
        
        local j = SMODS.create_card({
            key = jKey,
        })

        j:add_to_deck()
        G.jokers:emplace(j)


        SMODS.Stickers["eternal"]:apply(j, true)

    end
end

SMODS.Back{
    name = 'Crac Deck',
    key = 'CracDeck',
    atlas = 'Jokers',
    pos = {x = 1, y = 2},
    loc_txt = {
        name = 'Crac Deck',
        text = {
            '{C:attention} 13 hand size',
            'Start with {C:red}Crac{} and {C:spectral}Reality Augment{}',
            '{C:attention}The Arcana is the means by which all is revealed{}',
        },
    },

    config = {
        hand_size = 5
    },

    apply = function ()
        G.E_MANAGER:add_event(Event({

            func = function ()

                -- Add Crac's
                joker_add('j_fn_Crac')
				joker_add('j_fn_Augment')

                return true
            end
        }))
    end,

}
----------------------------------------------
------------CRAC DECK CODE END----------------------

----------------------------------------------
------------CRAC SLEEVE CODE BEGIN----------------------

-- CardSleeves Support
if (SMODS.Mods["CardSleeves"] or {}).can_load then
    CardSleeves.Sleeve {
		key = "Crac_Sleeve",
		atlas = "Jokers",
		pos = { x = 4, y = 39 },
		unlocked = false,
		unlock_condition = { deck = "b_fn_CracDeck", stake = 1 },
		loc_txt = {
            name ="Crac Sleeve",
            text={
                "Start with a {C:mult}Crac{} that {C:attention}always{} triggers",
            },
		},

        apply = function ()
			G.E_MANAGER:add_event(Event({

				func = function ()

					local _card = create_card('Joker', G.jokers, nil, nil, nil, nil, 'j_fn_Crac')
					_card:add_to_deck()
					G.jokers:emplace(_card)
					_card.ability.extra.odds = 1
					SMODS.Stickers["eternal"]:apply(_card, true)

					return true
				end
			}))
		end,
	}
end

----------------------------------------------
------------CRAC SLEEVE CODE END----------------------

----------------------------------------------
------------ERIC DECK CODE BEGIN----------------------
function joker_add2(jKey)

    if type(jKey) == 'string' then
        
        local j = SMODS.create_card({
            key = jKey,
        })

        j:add_to_deck()
        G.jokers:emplace(j)


        SMODS.Stickers["eternal"]:apply(j, true)
		SMODS.Stickers["rental"]:apply(j, true)

    end
end

SMODS.Back{
    name = 'Eric Deck',
    key = 'EricDeck',
    atlas = 'Jokers',
    pos = {x = 0, y = 2},
    loc_txt = {
        name = 'Eric Deck',
        text = {
            'Start with {C:tarot}Eric',
        },
    },

    config = {
        hand_size = 0
    },

    apply = function ()
        G.E_MANAGER:add_event(Event({

            func = function ()

                -- Add Eric
                joker_add2('j_fn_Eric')

                return true
            end
        }))
    end,

}
----------------------------------------------
------------ERIC DECK CODE END----------------------

----------------------------------------------
------------REBOOTED DECK CODE BEGIN----------------------

SMODS.Back{
    name = 'Rebooted Deck',
    key = 'RebootDeck',
    atlas = 'Jokers',
    pos = {x = 4, y = 42},
    loc_txt = {
        name = 'Rebooted Deck',
        text = {
			'Start with {C:green}Aimbot{} and {C:purple}Bandage Bazooka',
            '{C:green}50% chance{} to {C:attention}respawn{} on death',
			'Halve {C:chips}Chips{} on death ',
			'Idea: Your Average User',
        },
    },

    config = {
        hand_size = 0
    },

    apply = function ()
        G.E_MANAGER:add_event(Event({

            func = function ()

                -- Add Eternal Aimbot and Bandage Bazooka
                joker_add('j_fn_Aimbot')
				local tarot_cards = {
					'c_fn_LTMBazooka', 'c_fn_LTMBazooka', 'c_fn_LTMBazooka',  
                }
                local random_card_id = tarot_cards[math.random(1, #tarot_cards)]
                local _card = create_card('Tarot', G.consumeables, nil, nil, nil, nil, random_card_id)
                _card:add_to_deck()
                G.consumeables:emplace(_card)

                return true
            end
        }))
    end,
	
	calculate = function(self, card, context)
        if context.final_scoring_step and G.GAME.current_round.hands_left == 0 and G.GAME.chips < G.GAME.blind.chips then
			local rand = math.random(1,2)
			if rand == 1 then
			
				-- Play a sound effect
				if config.sfx ~= false then
					play_sound('fn_reboot')
				end
				
				-- Prevent the game over
				ease_hands_played(1)
				
				-- Visual feedback for chips
				G.hand_text_area.blind_chips:juice_up()
				G.hand_text_area.game_chips:juice_up()
				G.GAME.chips = G.GAME.chips / 2
				
				return {
					message = localize('k_saved_ex'),
					colour = G.C.RED
				}
				
			end
        end
    end
}

----------------------------------------------
------------REBOOTED DECK CODE END----------------------


----------------------------------------------
------------ZORLODO DECK CODE BEGIN----------------------

SMODS.Back{
    name = 'Zorlodo Deck',
    key = 'ZorlodoDeck',
    atlas = 'Jokers',
    pos = {x = 2, y = 49},
    loc_txt = {
        name = 'Zorlodo Deck',
        text = {
            'Every ante acts as a random {C:attention}other{} deck',
            'Currently: {C:attention}#1#',
        },
    },

    config = {
        extra = { deck = "None", triggered = 0 },
    },

    loc_vars = function(self, info_queue, card)
        return { vars = { self.config.extra.deck, self.config.extra.triggered } }
    end,

    -- Called once when deck is chosen
    apply = function(self, card)
        -- Pick a random deck at start
        local decks = {"Blue", "Red", "Yellow", "Green", "Black", "Magic", "Nebula", "Ghost", "Zodiac", "Painted", "Anaglyph", "Plasma",} -- add whatever real deck names
        local choice = pseudorandom_element(decks, pseudoseed('zorlodo'))
        self.config.extra.deck = choice
        self.config.extra.triggered = 0
    end,

    -- Called each end of round / ante advancement
    calculate = function(self, card, context)
	
		--ensure there is ALWAYS a deck even when restarting
		if self.config.extra.deck == "None" then
			-- Reroll deck
			local decks = {"Blue", "Red", "Yellow", "Green", "Black", "Magic", "Nebula", "Ghost", "Zodiac", "Painted", "Anaglyph", "Plasma",}
			local choice = pseudorandom_element(decks, pseudoseed('zorlodo'))
			self.config.extra.deck = choice
			self.config.extra.triggered = 0
		end
		
        -- When a boss blind ends (ante advancing)
        if context.end_of_round and G.GAME.blind.boss and not context.repetition and not context.individual then
			if self.config.extra.deck == "None" then
				-- Reroll deck
				local decks = {"Blue", "Red", "Yellow", "Green", "Black", "Magic", "Nebula", "Ghost", "Zodiac", "Painted", "Anaglyph", "Plasma",}
				local choice = pseudorandom_element(decks, pseudoseed('zorlodo'))
				self.config.extra.deck = choice
				self.config.extra.triggered = 0
			end
			
			if self.config.extra.deck == "Blue" then
				G.GAME.round_resets.hands = (G.GAME.round_resets.hands or 0) - 1
				ease_hands_played(-1)
				-- Reroll deck
				local decks = {"Blue", "Red", "Yellow", "Green", "Black", "Magic", "Nebula", "Ghost", "Zodiac", "Painted", "Anaglyph", "Plasma",}
				local choice = pseudorandom_element(decks, pseudoseed('zorlodo'))
				self.config.extra.deck = choice
				self.config.extra.triggered = 0
			end

			if self.config.extra.deck == "Red" then
				G.GAME.round_resets.discards = G.GAME.round_resets.discards - 1
				ease_discard(-1)
				-- Reroll deck
				local decks = {"Blue", "Red", "Yellow", "Green", "Black", "Magic", "Nebula", "Ghost", "Zodiac", "Painted", "Anaglyph", "Plasma",}
				local choice = pseudorandom_element(decks, pseudoseed('zorlodo'))
				self.config.extra.deck = choice
				self.config.extra.triggered = 0
			end
			
			if self.config.extra.deck == "Yellow" then
				-- Reroll deck
				local decks = {"Blue", "Red", "Yellow", "Green", "Black", "Magic", "Nebula", "Ghost", "Zodiac", "Painted", "Anaglyph", "Plasma",}
				local choice = pseudorandom_element(decks, pseudoseed('zorlodo'))
				self.config.extra.deck = choice
				self.config.extra.triggered = 0
			end
			
			if self.config.extra.deck == "Green" then
				G.GAME.modifiers.no_interest = false
				
				-- Reroll deck
				local decks = {"Blue", "Red", "Yellow", "Green", "Black", "Magic", "Nebula", "Ghost", "Zodiac", "Painted", "Anaglyph", "Plasma",}
				local choice = pseudorandom_element(decks, pseudoseed('zorlodo'))
				self.config.extra.deck = choice
				self.config.extra.triggered = 0
			end
			
			if self.config.extra.deck == "Black" then
				G.jokers.config.card_limit = G.jokers.config.card_limit - 1
				G.GAME.round_resets.hands = (G.GAME.round_resets.hands or 0) + 1
				ease_hands_played(1)
				-- Reroll deck
				local decks = {"Blue", "Red", "Yellow", "Green", "Black", "Magic", "Nebula", "Ghost", "Zodiac", "Painted", "Anaglyph", "Plasma",}
				local choice = pseudorandom_element(decks, pseudoseed('zorlodo'))
				self.config.extra.deck = choice
				self.config.extra.triggered = 0
			end
			
			if self.config.extra.deck == "Magic" then
				G.consumeables.config.card_limit = G.consumeables.config.card_limit - 1
				for i, v in pairs(G.consumeables.cards) do
					if v.config.center.key == "c_fool" then
						v:start_dissolve()
					end
				end
				-- Reroll deck
				local decks = {"Blue", "Red", "Yellow", "Green", "Black", "Magic", "Nebula", "Ghost", "Zodiac", "Painted", "Anaglyph", "Plasma",}
				local choice = pseudorandom_element(decks, pseudoseed('zorlodo'))
				self.config.extra.deck = choice
				self.config.extra.triggered = 0
			end
			
			if self.config.extra.deck == "Nebula" then
				G.consumeables.config.card_limit = G.consumeables.config.card_limit + 1
				for i, v in pairs(G.vouchers.cards) do
					if v.config.center.key == "v_telescope" then
						v:start_dissolve()
					end
				end
				-- Reroll deck
				local decks = {"Blue", "Red", "Yellow", "Green", "Black", "Magic", "Nebula", "Ghost", "Zodiac", "Painted", "Anaglyph", "Plasma",}
				local choice = pseudorandom_element(decks, pseudoseed('zorlodo'))
				self.config.extra.deck = choice
				self.config.extra.triggered = 0
			end
			
			if self.config.extra.deck == "Ghost" then
				G.GAME.spectral_rate = G.GAME.spectral_rate - 2
				for i, v in pairs(G.consumeables.cards) do
					if v.config.center.key == "c_hex" then
						v:start_dissolve()
					end
				end
				-- Reroll deck
				local decks = {"Blue", "Red", "Yellow", "Green", "Black", "Magic", "Nebula", "Ghost", "Zodiac", "Painted", "Anaglyph", "Plasma",}
				local choice = pseudorandom_element(decks, pseudoseed('zorlodo'))
				self.config.extra.deck = choice
				self.config.extra.triggered = 0
			end
			
			if self.config.extra.deck == "Zodiac" then
				change_shop_size(-1)
				G.GAME.tarot_rate = G.GAME.tarot_rate / 2
				G.GAME.planet_rate = G.GAME.planet_rate / 2
				-- Reroll deck
				local decks = {"Blue", "Red", "Yellow", "Green", "Black", "Magic", "Nebula", "Ghost", "Zodiac", "Painted", "Anaglyph", "Plasma",}
				local choice = pseudorandom_element(decks, pseudoseed('zorlodo'))
				self.config.extra.deck = choice
				self.config.extra.triggered = 0
			end
			
			if self.config.extra.deck == "Painted" then
				G.jokers.config.card_limit = G.jokers.config.card_limit + 1
				G.hand.config.card_limit = G.hand.config.card_limit - 2
				-- Reroll deck
				local decks = {"Blue", "Red", "Yellow", "Green", "Black", "Magic", "Nebula", "Ghost", "Zodiac", "Painted", "Anaglyph", "Plasma",}
				local choice = pseudorandom_element(decks, pseudoseed('zorlodo'))
				self.config.extra.deck = choice
				self.config.extra.triggered = 0
			end
			
			if self.config.extra.deck == "Anaglyph" then
				-- Reroll deck
				local decks = {"Blue", "Red", "Yellow", "Green", "Black", "Magic", "Nebula", "Ghost", "Zodiac", "Painted", "Anaglyph", "Plasma",}
				local choice = pseudorandom_element(decks, pseudoseed('zorlodo'))
				self.config.extra.deck = choice
				self.config.extra.triggered = 0
			end
			
			if self.config.extra.deck == "Plasma" then
				-- Reroll deck
				local decks = {"Blue", "Red", "Yellow", "Green", "Black", "Magic", "Nebula", "Ghost", "Zodiac", "Painted", "Anaglyph", "Plasma",}
				local choice = pseudorandom_element(decks, pseudoseed('zorlodo'))
				self.config.extra.deck = choice
				self.config.extra.triggered = 0
			end
				
        end

        -- Apply Deck Effects
        if self.config.extra.deck == "Blue" and self.config.extra.triggered == 0 then
            self.config.extra.triggered = 1
            G.GAME.round_resets.hands = (G.GAME.round_resets.hands or 0) + 1
			ease_hands_played(1)
        end
		
		if self.config.extra.deck == "Red" and self.config.extra.triggered == 0 then
            self.config.extra.triggered = 1
            G.GAME.round_resets.discards = G.GAME.round_resets.discards + 1
			ease_discard(1)
        end
		
		if self.config.extra.deck == "Yellow" and self.config.extra.triggered == 0 then
            self.config.extra.triggered = 1
            ease_dollars(10)
        end
		
		if self.config.extra.deck == "Green" and self.config.extra.triggered == 0 then
            self.config.extra.triggered = 1
            G.GAME.modifiers.no_interest = true
        end
		
		if context.end_of_round and self.config.extra.deck == "Green" and not context.repetition and not context.individual then
			ease_dollars(G.GAME.current_round.discards_left)
			ease_dollars(G.GAME.current_round.hands_left*2)
		end
		
		if self.config.extra.deck == "Black" and self.config.extra.triggered == 0 then
            self.config.extra.triggered = 1
            G.jokers.config.card_limit = G.jokers.config.card_limit + 1
			G.GAME.round_resets.hands = (G.GAME.round_resets.hands or 0) - 1
			ease_hands_played(-1)
        end
		
		if self.config.extra.deck == "Magic" and self.config.extra.triggered == 0 then
            self.config.extra.triggered = 1
			
            local _card = create_card('Tarot', G.consumeables, nil, nil, nil, nil, 'c_fool')
			_card:add_to_deck()
			G.consumeables:emplace(_card)
			
			local _card2 = create_card('Tarot', G.consumeables, nil, nil, nil, nil, 'c_fool')
			_card:add_to_deck()
			G.consumeables:emplace(_card2)
			
			G.consumeables.config.card_limit = G.consumeables.config.card_limit + 1
        end
		
		if self.config.extra.deck == "Nebula" and self.config.extra.triggered == 0 then
            self.config.extra.triggered = 1
			
            local _card = create_card('Voucher', G.vouchers, nil, nil, nil, nil, 'v_telescope')
			_card:add_to_deck()
			G.vouchers:emplace(_card)
			
			G.consumeables.config.card_limit = G.consumeables.config.card_limit - 1
        end
		
		if self.config.extra.deck == "Ghost" and self.config.extra.triggered == 0 then
            self.config.extra.triggered = 1
			
           local _card = create_card('Tarot', G.consumeables, nil, nil, nil, nil, 'c_hex')
			_card:add_to_deck()
			G.consumeables:emplace(_card)
		
			G.GAME.spectral_rate = G.GAME.spectral_rate + 2
        end
		
		if self.config.extra.deck == "Zodiac" and self.config.extra.triggered == 0 then
            self.config.extra.triggered = 1
			
			change_shop_size(1)
			G.GAME.tarot_rate = G.GAME.tarot_rate * 2
			G.GAME.planet_rate = G.GAME.planet_rate * 2
			
        end
		
		if self.config.extra.deck == "Painted" and self.config.extra.triggered == 0 then
            self.config.extra.triggered = 1
			
			G.jokers.config.card_limit = G.jokers.config.card_limit - 1
			G.hand.config.card_limit = G.hand.config.card_limit + 2
			
        end
		
		if self.config.extra.deck == "Anaglyph" and context.setting_blind and G.GAME.blind.boss and not context.repetition and not context.individual then
			add_tag(Tag('tag_double'))
		end
		
		if self.config.extra.deck == "Plasma" and context.final_scoring_step then
			return {
				balance = true,
			}
		end
    end,
}

----------------------------------------------
------------ZORLODO DECK CODE END----------------------

----------------------------------------------
------------OG DECK CODE BEGIN----------------------

-- ========= Helper: check if OG Deck is active =========
local function is_og_deck_active()
    return G.GAME and G.GAME.selected_back
       and G.GAME.selected_back.effect
       and G.GAME.selected_back.effect.center
       and G.GAME.selected_back.effect.center.key == 'b_fn_OGDeck'
end

-- ========= Helper: blocked packs =========
local BLOCKED_PACKS = {
    'p_fn_AugmentBooster1',
    'p_fn_AugmentBooster2',
    'p_voucher_pack',
	'p_uncommon_voucher_pack',
	'p_fusion_voucher_pack',
}

local function is_blocked_pack(card)
    local c = card and card.config and card.config.center
    local key = c and c.key
    if not key then return false end
    for _, k in ipairs(BLOCKED_PACKS) do
        if k == key then return true end
    end
    return false
end

local function is_voucher_card(card)
    local c = card and card.config and card.config.center
    local set  = c and c.set
    local abil_set = card and card.ability and card.ability.set
    return (set == 'Voucher') or (abil_set == 'Voucher')
end

-- ========= Hook UI-time block, dissolve vouchers / blocked packs =========
do
    local _create_shop_card_ui = rawget(_G, 'create_shop_card_ui')
    if type(_create_shop_card_ui) == 'function' then
        _G.create_shop_card_ui = function(card, ...)
            if is_og_deck_active() and (is_voucher_card(card) or is_blocked_pack(card)) then
                --print("[ShopBlock] Dissolving blocked card: "..tostring(card.config.center.key))
                if card.start_dissolve then
                    card:start_dissolve()
                end
                return nil
            end
            return _create_shop_card_ui(card, ...)
        end
    end
end

SMODS.Back{
    name = 'OG Deck',
    key = 'OGDeck',
    atlas = 'Jokers',
    pos = {x = 1, y = 50},
    loc_txt = {
        name = 'OG Deck',
        text = {
            '{C:attention}+2{} Joker slots',
            'Vouchers {C:attention}CANNOT{} spawn in the {C:green}shop{}',
        },
    },

    config = {
        extra = { triggered = 0 },
    },

    loc_vars = function(self, info_queue, card)
        return { vars = { self.config.extra.deck, self.config.extra.triggered } }
    end,

    apply = function ()
        G.E_MANAGER:add_event(Event({
            func = function ()
                -- Add 2 Joker slots
                G.jokers.config.card_limit = G.jokers.config.card_limit + 2
                return true
            end
        }))
    end,
}

----------------------------------------------
------------OG DECK CODE END----------------------

----------------------------------------------
------------ZERO BUILD DECK CODE END----------------------

-- ========= Helper: check if ZB Deck is active =========
local function is_zb_deck_active()
    local key = G and G.GAME and G.GAME.selected_back
        and G.GAME.selected_back.effect
        and G.GAME.selected_back.effect.center
        and G.GAME.selected_back.effect.center.key
    return key == 'b_fn_ZBDeck'
end

-- ========= Helper: check if card is a Voucher =========
local function is_voucher_card(card)
    local c = card and card.config and card.config.center
    local set  = c and c.set
    local abil_set = card and card.ability and card.ability.set
    return (set == 'Voucher') or (abil_set == 'Voucher')
end

-- ========= Hook UI-time: halve voucher costs =========
do
    local _create_shop_card_ui = rawget(_G, 'create_shop_card_ui')
    if type(_create_shop_card_ui) == 'function' then
        _G.create_shop_card_ui = function(card, ...)
            local ui = _create_shop_card_ui(card, ...)

            if is_zb_deck_active() and is_voucher_card(card) then
                local cur_cost = card and (
                    card.cost
                    or (card.ability and card.ability.cost)
                )

                if type(cur_cost) == "number" then
                    local new_cost = math.floor(cur_cost / 2)
                    G.E_MANAGER:add_event(Event{ func = function()
                        if not card then return true end
                        if card.set_cost then card:set_cost(new_cost) end
                        card.cost = new_cost
                        if card.ability then
                            card.ability.cost = new_cost
                        end
                        return true
                    end})
                end
            end

            return ui
        end
    end
end




SMODS.Back{
    name = 'Zero Build Deck',
    key = 'ZBDeck',
    atlas = 'Jokers',
    pos = {x = 2, y = 50},
    loc_txt = {
        name = 'Zero Build Deck',
        text = {
            'Vouchers restock every {C:attention}round{}',
			'All Vouchers are {C:attention}half price{}',
            '{C:attention}-2{} Joker Slots',
        },
    },

    config = {
        extra = { triggered = 1 },
    },

    loc_vars = function(self, info_queue, card)
        return { vars = { self.config.extra.deck, self.config.extra.triggered } }
    end,

    apply = function ()
        G.E_MANAGER:add_event(Event({
            func = function ()
                -- Add 2 Joker slots
                G.jokers.config.card_limit = G.jokers.config.card_limit - 2
                return true
            end
        }))
    end,
	
	-- Called each end of round / ante advancement
    calculate = function(self, card, context)
		if G.STATE == G.STATES.SHOP then
			if G.shop_vouchers and #G.shop_vouchers.cards <= 0 and G.shop_booster and #G.shop_booster.cards > 0 and self.config.extra.triggered == 0 then
				self.config.extra.triggered = 1
				G.shop_vouchers.config.card_limit = G.shop_vouchers.config.card_limit + 1

				-- use the proper Balatro logic to get the next valid voucher
				local voucher_key = get_next_voucher_key(true)
				if voucher_key then
					local voucher = Card(
						G.shop_vouchers.T.x + G.shop_vouchers.T.w/2,
						G.shop_vouchers.T.y,
						G.CARD_W,
						G.CARD_H,
						G.P_CARDS.empty,
						G.P_CENTERS[voucher_key],
						{bypass_discovery_center = true, bypass_discovery_ui = true}
					)
					create_shop_card_ui(voucher, 'Voucher', G.shop_vouchers)
					voucher:start_materialize()
					G.shop_vouchers:emplace(voucher)
				end
			end
		end
		
		if context.end_of_round then
			self.config.extra.triggered = 0
		end
		
		if context.buying_card then
			self.config.extra.triggered = 1
		end
		
	end,
}		

----------------------------------------------
------------ZERO BUILD DECK CODE END----------------------


----------------------------------------------
------------MOD CODE END----------------------
