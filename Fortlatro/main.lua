--- STEAMODDED HEADER
--- MOD_NAME: Fortlatro
--- MOD_ID: Fortlatro
--- MOD_AUTHOR: [EricTheToon]
--- MOD_DESCRIPTION: A terribly coded mod to add Fortnite themed stuff + stuff for my friends to Balatro.
--- BADGE_COLOUR: 672A62
--- PREFIX: fn
--- PRIORITY: -69420
--- DEPENDENCIES: [Steamodded>=0.9.8, Talisman>=2.0.0-beta8,]
--- VERSION: 1.1.2 Release
----------------------------------------------
------------MOD CODE -------------------------
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
                create_toggle{ label = "Cryptid Compatibility", info = {"Enable if Cryptid Mod is Installed"}, active_colour = Fortlatro.badge_colour, ref_table = Fortlatro.config, ref_value = "cryptidcompat" },
                create_toggle{ label = "Ortalab Compatibility", info = {"Enable if Ortalab Mod is Installed"}, active_colour = Fortlatro.badge_colour, ref_table = Fortlatro.config, ref_value = "ortalabcompat" },
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
            'When {C:attention}Blind is selected{},',
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
SMODS.Atlas{
    key = 'Jokers', --atlas key
    path = 'Jokers.png', --atlas' path in (yourMod)/assets/1x or (yourMod)/assets/2x
    px = 71.1, --width of one card
    py = 95 -- height of one card
}
SMODS.Joker{
    key = 'Crac',
    loc_txt = {
        ['en-us'] = {
            name = "Crac",
            text = {
                "The Arcana is the means by which all is revealed.",
                "Has a {C:green,E:1,S:1.1}#3# in #2#{} chance to do SOMETHING",
                "{C:inactive}(Currently {C:mult}#1#{}{C:inactive} Mult)",
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
            "Retrigger scored cards {C:attention}#1#{} Times"
            --frankly this shit is broken as hell on newcompat and i dont know how to fix it she just wont fucking trigger other jokers
            --until one of y'all has a solution im just giving her 5 repetitions of the played hand FUCK new calc man this shit is ass
        }
    },
    atlas = "Jokers",
    pos = { x = 4, y = 0 },
    config = {
        extra = {
            repetitions = 5, -- Number of times to retrigger for scoring cards and Jokers
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
  key = 'Toilet Gang',
  loc_txt = {
    name = 'Toilet Gang',
    text = {
	 "This Joker Gains {X:mult,C:white}X#1#{} Mult",
     "if played hand",
     "contains a {C:attention}Flush{}",
     "{C:inactive}(Currently {X:mult,C:white}X#2#{C:inactive} Mult"
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
                "If the played hand contains a {C:attention}Flush{},",
                "summon a {C:planet}Planet{} card for that hand.",
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
                "If {C:attention}first hand{} of round",
                "has only 4 cards, destroy",
                "them and earn an {C:purple}LTM Card{}", 
            }
        }
    },
    atlas = 'Jokers',
    pos = { x = 2, y = 4 },
    config = {
        extra = {
            -- Define additional properties here if needed
        }
    },
    rarity = 2,
    cost = 4,
    blueprint_compat = true,
    
    -- Calculate function for applying the Joker's effect
    calculate = function(self, card, context)
        if context.joker_main then
            -- Check if the current round has not played any hands yet
            if G.GAME.current_round.hands_played == 0 then
                -- Check if the hand has exactly 4 cards
                if #context.full_hand == 4 then
                    -- Destroy each card in the current hand using start_dissolve
                    for _, hand_card in ipairs(context.full_hand) do
                        hand_card:start_dissolve()  -- Initiates card dissolution
                    end

                    -- Create and add an LTM card to the consumables deck
                    local new_card = create_card('LTMConsumableType', G.consumeables)
                    new_card:add_to_deck()  -- Adds the card to the deck
                    G.consumeables:emplace(new_card)  -- Adds the card to the consumables collection

                    -- Set Crac's unique flag
                    G.GAME.pool_flags.peely_flag = true

                    -- Return the message and effect on the hand
                    return {
                        message = "+1 LTM Card!",
                        colour = G.C.DARK_EDITION,
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
                "Gains {C:chips}#1#{} Chips for each Joker when scoring",
                "{C:inactive}Currently{} {C:chips}#2#{} {C:inactive}Chips"
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
			'{C:inactive}(Currently {}{X:mult,C:white}X#1#{}{C:inactive} Mult){}'
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
            hands = 0 -- Default hands
        }
    },
    rarity = 2,          -- Uncommon joker
    cost = 5,            -- Cost to purchase
    blueprint_compat = false,

    loc_vars = function(self, info_queue, card)
        -- Dynamically display the stored hands
        local stored_hands = self.config.extra.initial_hands or self.config.extra.hands
        return {
            vars = { stored_hands }
        }
    end,

    calculate = function(self, card, context)
        if context.joker_main then
            local round = G.GAME.current_round

            -- Store the initial hands at the start of the round
            if round.hands_played == 0 and not self.config.extra.initial_hands then
                self.config.extra.initial_hands = round.hands_left + 1
            end
            
            -- Check if hands are depleted and the player can't meet the blind
            if round.hands_left <= 0 and G.GAME.chips < G.GAME.blind.chips then
				if config.sfx ~= false then
					play_sound("fn_chug")
				end
                -- Restore hands to the stored value
                local restore_value = self.config.extra.initial_hands or self.config.extra.hands
                round.hands_left = restore_value

                --trigger self-destruction
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
        if context.joker_main then
            local round = G.GAME.current_round

            -- Store the initial hands at the start of the round
            if round.hands_played == 0 and not self.config.extra.initial_hands then
                self.config.extra.initial_hands = round.hands_left / 2 +0.5
            end
            
            -- Check if hands are depleted and the player can't meet the blind
            if round.hands_left <= 0 and G.GAME.chips < G.GAME.blind.chips then
				if config.sfx ~= false then
					play_sound("fn_chug")
				end
                -- Restore hands to the stored value
                local restore_value = self.config.extra.initial_hands or self.config.extra.hands
                round.hands_left = restore_value

                --trigger self-destruction
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
        if context.joker_main then
            local round = G.GAME.current_round

            -- Store the initial hands at the start of the round
            if round.hands_played == 0 and not self.config.extra.initial_hands then
                self.config.extra.initial_hands = round.hands_left / 4 +0.25
            end
            
            -- Check if hands are depleted and the player can't meet the blind
            if round.hands_left <= 0 and G.GAME.chips < G.GAME.blind.chips then
				if config.sfx ~= false then
					play_sound("fn_chug")
				end
                -- Restore hands to the stored value
                local restore_value = self.config.extra.initial_hands or self.config.extra.hands
                round.hands_left = restore_value

                --trigger self-destruction
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

SMODS.Joker{
    key = 'BluGlo',
    loc_txt = {
        ['en-us'] = {
            name = "BluGlo",
            text = {
                "Every LTM consumable used adds {C:mult}+#2#{} Mult",
                "Spawn 2 Negative {C:purple}LTM Cards{} upon obtaining this Joker",
                "{C:inactive}Currently{} {C:mult}#1# {C:inactive}mult",
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
        extra = { mult = 20 } -- mult value
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
        -- Check if the played hand contains a Flush
        if context.cardarea == G.jokers and context.before and not context.blueprint then
            if context.scoring_name == "Flush" then
                -- Trigger destruction of the card
                card:start_dissolve()
                if config.sfx ~= false then
                    play_sound("fn_flush")
                end
                -- No return here to avoid further processing after dissolving
                return
            end
        end

        -- Only provide multiplier if the hand is NOT a Flush
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
            "{C:inactive}Currently{} {C:chips}#2# {C:inactive}Chips"
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

            -- Ensure there are at least 2 cards to compare
            if #scoring_hand >= 2 then
                -- Get the IDs of the first and last cards
                local first_id = scoring_hand[1]:get_id()
                local last_id = scoring_hand[#scoring_hand]:get_id()

                -- Check if the IDs match
                if first_id == last_id then
                    return {
                        message = localize {
                            type = 'variable',
                            key = 'sj_mult',
                            vars = { card.ability.extra.mult }
                        },
                        mult_mod = card.ability.extra.mult, -- Apply multiplier
                        card = self
                    }
                end
            end
        end
    end
}

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

SMODS.Joker {
    name = "The Nothing",
    key = "Nothing",
    config = {
        extra = {
            destroyed = 0, -- Tracks destroyed cards
            mult = 0,      -- Current multiplier
            multmod = 2    -- Mult per destroyed card (adjust as needed)
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
                -- Collect non-enhanced cards in hand
                local non_enh_list = {}
                for _, hand_card in ipairs(G.hand.cards) do
                    if hand_card.config.center == G.P_CENTERS.c_base then
                        table.insert(non_enh_list, hand_card)
                    end
                end
                
                -- If there are valid cards, destroy one at random
                if #non_enh_list > 0 then
                    local destroyed_card = pseudorandom_element(non_enh_list, pseudoseed('Nothing'))

                    -- Destroy the selected card
                    destroyed_card:start_dissolve()
                    
                    -- Update multiplier
                    card.ability.extra.destroyed = card.ability.extra.destroyed + 1
                    card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.multmod

                    -- Show UI feedback
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
            "{C:inactive}(Currently {X:mult,C:white}X#2#{}{C:inactive})"
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
            "At 0, gain an extra Joker slot",
            "{C:inactive}Currently{} {C:chips}#2# {C:inactive}Chips"
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
            chips_per_card = 50,   -- Store chips value
            mult_per_card = 50,    -- Store multiplier value
            odds = 2               -- Configuration: 50% chance for chips or multiplier
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
        -- Return the stored chips and multiplier values for localization
        return {
            vars = {G.GAME.probabilities.normal, card.ability.extra.odds, card.ability.extra.chips_per_card, card.ability.extra.mult_per_card}
        }
    end,
    calculate = function(self, card, context)
        -- Joker main scoring logic with the game's probability system
        if context.joker_main then
            G.GAME.pool_flags.gamble = true -- Set gamble flag

            -- Using the game's internal probability system (like Double or Nothing)
            if pseudorandom('50vs50') < G.GAME.probabilities.normal / card.ability.extra.odds then
                -- Success: Grant +chips_per_card value (50 chips)
                return {
                    message = localize {type = 'variable', key = 'a_chips', vars = {card.ability.extra.chips_per_card}},
                    chip_mod = card.ability.extra.chips_per_card,
                    colour = G.C.CHIPS
                }
            else
                -- Failure: Grant +mult_per_card value (50 multiplier)
                return {
                    message = localize {type = 'variable', key = 'a_mult', vars = {card.ability.extra.mult_per_card}},
                    mult_mod = card.ability.extra.mult_per_card,
                    colour = G.C.MULT
                }
            end
        end
    end
}

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
      "Sell this card to randomize the ante between {C:attention}-2{} and {C:attention}+2{}.",
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
      if self.config.sfx ~= false then 
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
        return { vars = { card.ability.extra.repetitions } }
    end,

    calculate = function(self, card, context)
        -- Check if a Gold Card is played or in hand
        if context.repetition and context.cardarea == G.play then
            if context.other_card and context.other_card.ability.name == 'Gold Card' then
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

SMODS.Joker{
    key = 'DB',
    loc_txt = {
        ['en-us'] = {
            name = "Dill Bit",
            text = {
                "Adds the sell value of all owned",
                "{C:attention}Jokers{} and {C:attention}Consumables{} to mult",
                "{C:inactive}Currently +{C:mult}#1#{} {C:inactive}Mult{}",
            }
        }
    },
    atlas = 'Jokers',
    pos = { x = 1, y = 15 },
    config = {
        extra = { mult = 0 } -- Mult value
    },
    rarity = 2,
    cost = 5,
    blueprint_compat = true,

    loc_vars = function(self, info_queue, card)
        -- Ensure displayed value is always correct
        card.ability.extra.mult = self:calculate_sell_cost()
        return {
            vars = { card.ability.extra.mult }
        }
    end,

    calculate_sell_cost = function(self)
        local sell_cost = 0

        -- Safeguard: Ensure G.jokers and G.consumeables exist before accessing them
        if G.jokers and G.jokers.cards then
            -- Sum sell cost of all Jokers (excluding itself)
            for _, joker in ipairs(G.jokers.cards) do
                if joker ~= self and joker.area == G.jokers then
                    sell_cost = sell_cost + (joker.sell_cost or 0)
                end
            end
        end

        if G.consumeables and G.consumeables.cards then
            -- Sum sell cost of all Consumables
            for _, consumable in ipairs(G.consumeables.cards) do
                if consumable.area == G.consumeables then
                    sell_cost = sell_cost + (consumable.sell_cost or 0)
                end
            end
        end

        return sell_cost
    end,

    calculate = function(self, card, context)
        -- Always update the value
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

----------------------------------------------
------------DILL BIT CODE END----------------------

----------------------------------------------
------------VULTURE BOON CODE BEGIN----------------------
SMODS.Joker{
    key = 'Vulture',
    loc_txt = {
        name = 'Vulture Boon',
        text = {
            "Each discarded card has a {C:green}#1# in #2#{} chance",
            "to permanently gain +{C:chips}#3#{} chips",
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


----------------------------------------------
------------VULTURE BOON CODE END----------------------

----------------------------------------------
------------JANE BALATRO CODE BEGIN----------------------

SMODS.Joker {
    key = 'CassidyQuinn',
    loc_txt = {
        name = 'Cassidy Quinn',
        text = {
            "When {C:attention}blind selected{},",
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
            "to be {C:mult}destroyed{} instead, granting {C:chips}+#3#{} chips",
            "{C:inactive}Currently{} {C:chips}#4# {C:inactive}Chips"
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
                -- Destroy the discarded card
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


SMODS.Joker {
    key = 'Shadow',
    loc_txt = {
        name = 'Shadow Logo',
        text = {
            "This Joker Gains +{C:mult}#2#{} Mult",
            "if played hand contains a {C:spades}Dark{} {C:clubs}Suit{} Flush",
            "{C:inactive}Currently{} +{C:mult}#1#{}{C:inactive} Mult",
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
    config = {extra = {mult = 0, multmod = 8}},  -- regular mult and multmod
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
            if context.scoring_name == "Flush" or context.scoring_name == "Straight Flush" or context.scoring_name == "Royal Flush" or context.scoring_name == "Flush Five" or context.scoring_name == "Flush House" then
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

----------------------------------------------
------------SHADOW LOGO CODE END----------------------

----------------------------------------------
------------GHOST LOGO CODE BEGIN----------------------

SMODS.Joker {
    key = 'Ghost',
    loc_txt = {
        name = 'Ghost Logo',
        text = {
            "This Joker Gains +{C:chips}#1#{} Chips",
            "if played hand contains a {C:hearts}Light{} {C:diamonds}Suit{} Flush",
            "{C:inactive}Currently{} +{C:chips}#2#{}{C:inactive} Chips",
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

SMODS.Joker {
    key = 'Vault',
    loc_txt = {
        name = 'Card Vaulting',
        text = {
            "When a {C:attention}Debuffed{} Card is played {C:mult}destroy{} it",
            "Gains +{C:chips}#3#{} Chips and +{C:mult}#4#{} Mult for every card destroyed this way",
            "{C:inactive}Currently{} +{C:chips}#1#{} {C:inactive}Chips{} +{C:mult}#2#{}{C:inactive} Mult",
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
        extra = {mult = 0, multmod = 1, chipmod = 15, stored_chips = 0}  -- Default initialization of stored_chips
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
        -- Ensure stored_chips is initialized to 0 if it is nil
        card.ability.extra.stored_chips = card.ability.extra.stored_chips or 0
        
        -- Check if the card is debuffed within the full hand and not at the end of the round
        if context.joker_main then
            -- Iterate through the full hand and destroy debuffed cards
            for _, hand_card in ipairs(context.full_hand) do
                if hand_card.debuff and not context.end_of_round then
                    hand_card:start_dissolve()  -- Destroy the debuffed card
                    card.ability.extra.stored_chips = card.ability.extra.stored_chips + card.ability.extra.chipmod
                    card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.multmod

                    -- Grant the chips
                    SMODS.eval_this(card, {
                        message = "Upgrade!",
                        colour = G.C.CHIPS
                    })
                end
            end
        end

        -- Return chips and multiplier if it's part of the joker's main action
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

SMODS.Joker
{
	key = 'Slurp',
	loc_txt = 
	{
		name = 'Slurp Series',
		text = 
		{
			'This Joker gains +{C:mult}#2#{} Mult for every unused {C:chips}Hand{} at end of round',
			'{C:inactive}Currently +{}{C:mult}#1#{} {C:inactive}Mult{}',
			'Idea: BoiRowan'
		}
	},
	atlas = 'Jokers',
	pos = {x = 1, y = 20},
	rarity = 1,
	cost = 5,
	config = 
	{ 
		extra = 
		{
			mult = 0,
			mult_add = 2 -- Increment to add per unused hand
		}
	},
	loc_vars = function(self, info_queue, center)
		return 
		{
			vars = 
			{
				center.ability.extra.mult or 0,
				center.ability.extra.mult_add or 0
			}
		}
	end,
	calculate = function(self, card, context)
		-- Display the current mult during scoring
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
		
		-- Gain multiplier at end of round based on unused hands
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
			'This Joker gains +{C:chips}#2#{} Chips for every unused {C:mult}Discard{} at end of round',
			'{C:inactive}Currently +{}{C:chips}#1#{} {C:inactive}Chips{}',
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
        
        -- Fixed 1 in 5 chance to kill the player
        if pseudorandom("death_card_trigger") < (1 / 5) then
            -- Force game over
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

SMODS.Joker{
  key = 'NickEh30',
  loc_txt = {
    name = 'NickEh30',
    text = {
      "Gains +{C:mult}#1#{} Mult for every {C:attention}unscored card{} in played hand",
      "{C:attention}Resets{} if played hand has no unscored cards",
	  "{C:inactive}(Currently {C:mult}#2#{}{C:inactive} Mult)", 
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
      -- Track scored cards
      local scoringSet = {}
      for _, played_card in ipairs(context.scoring_hand or {}) do
          scoringSet[played_card] = true
      end

      -- Identify unscored cards
      local unscoredCards = {}
      for _, thisCard in ipairs(context.full_hand or {}) do
          if not scoringSet[thisCard] then
              table.insert(unscoredCards, thisCard)
          end
      end

      -- Modify multiplier based on unscored cards
      if #unscoredCards > 0 then
        card.ability.extra.mult = card.ability.extra.mult + (#unscoredCards * card.ability.extra.mult_add)
        
        -- Play sound effect if enabled
        if config.sfx ~= false then
          play_sound("fn_nick")
        end
        
        return {
          message = localize('k_upgrade_ex'),
          colour = G.C.Mult,
          card = card
        }
      elseif card.ability.extra.mult > 0 then
        -- Reset multiplier if no unscored cards remain
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

----------------------------------------------
------------NICKEH30 CODE END----------------------

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
            'Has a {C:green,E:1,S:1.1}#1# in #2#{} chance to give 2 {C:spectral}Spectral{} packs else give {C:red}nothing{}.',
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
            SMODS.eval_this('card_eval_status_text', {
                card = card, -- Reference the consumable card
                message = "DOUBLE!", -- Display "DOUBLE!" message
                colour = G.C.GREEN,
            })
        else
            -- Failure: No tags granted
            -- Display failure message on the consumable
			if config.sfx ~= false then
				play_sound("fn_sad")
			end
            SMODS.eval_this('card_eval_status_text', {
                card = card, -- Reference the consumable card
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
            cards = 4, -- configurable value
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
                'Select {C:attention:}#1#{} cards,',
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
            'A dangerous organic living metal that consumes and replicates.',
            'Responsible for nearly destroying a whole reality.',
            'Converts {C:attention}#1#{} random thing into {C:dark_edition}polychrome.',
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
        if context.cardarea == G.play and not context.repetition then
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
            info_queue[#info_queue + 1] = G.P_CENTERS.m_fn_crystal
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
                    -- Summon the gnome
                    G.E_MANAGER:add_event(Event({
                        func = function() 
                            local c = create_card(
                                nil, G.consumeables, nil, nil, nil, nil, 'c_fn_Gnome', 'sup'
                            )
                            c:add_to_deck()
                            G.consumeables:emplace(c)
                            if config.sfx ~= false then
                                play_sound("fn_gnome")
                            end
                            return true
                        end
                    }))
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
            -- Apply the multiplier and chip effects
            return {
                x_mult = card.ability.extra.m_mult,  -- Apply the multiplier
                chips = card.ability.extra.chips,   -- Apply the chips bonus
            }
        end
        if context.cardarea == G.play and not context.repetition then
            -- Chance to summon a gnome
            if pseudorandom('Gnome') < G.GAME.probabilities.normal / card.ability.extra.odds then
                -- Summon the gnome
                G.E_MANAGER:add_event(Event({
                    func = function() 
                        local c = create_card(
                            nil, G.consumeables, nil, nil, nil, nil, 'c_fn_Gnome', 'sup'
                        )
                        c:add_to_deck()
                        G.consumeables:emplace(c)
                        if config.sfx ~= false then
                            play_sound("fn_gnome")
                        end
                        return true
                    end
                }))
            end
        end
    end
}
end



----------------------------------------------
------------BRICK CODE END----------------------

----------------------------------------------
------------GNOME CODE BEGIN----------------------

SMODS.Consumable{
    key = 'Gnome', -- key
    set = 'LTMConsumableType', -- the set of the card: corresponds to a consumable type
    atlas = 'Jokers', -- atlas
    pos = {x = 0, y = 7}, -- position in atlas
    loc_txt = {
        name = 'Gnome', -- name of card
        text = { -- text of card
            'Has a {C:green,E:1,S:1.1}#1# in #2#{} chance to',
			'give an eternal copy of {C:tarot}Eric{}, {C:mult}Crac{}, {C:tarot}Emily{}, or {C:green,E:1,S:1.1}Zorlodo{}',
			'else give {C:red}nothing{}.',
        },
    },
    config = {
        extra = { odds = 8 }, -- Configuration: odds of success (set to 2 for 50% chance)
        no_pool_flag = 'gamble',
    },
    loc_vars = function(self, info_queue, card)
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
            SMODS.eval_this('card_eval_status_text', {
                card = card, -- Reference the consumable card
                message = "Friends!", -- Display "Friends!" message
                colour = G.C.PURPLE,
            })
        else
            -- Failure: No joker granted
            -- Display failure message on the consumable
			if config.sfx ~= false then
				play_sound("fn_sad")
			end
            SMODS.eval_this('card_eval_status_text', {
                card = card, -- Reference the consumable card
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
                "Gains +{C:mult}#1#{} Mult and +{C:chips}#2#{} Chips per {C:attention}Ante{}",
                "{C:inactive}Currently {C:mult}#3#{} {C:inactive}Mult {C:chips}#4#{} {C:inactive}Chips"
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
                "Gains +{C:mult}#1#{} Mult and +{C:chips}#2#{} Chips per {C:attention}Ante{}",
                "{C:inactive}Currently {C:mult}#3#{} {C:inactive}Mult {C:chips}#4#{} {C:inactive}Chips"
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
                'into {C:money}Wood{}, {C:mult}Brick{}, or {C:inactive}Metal{}.',
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

SMODS.Consumable {
    key = 'LTMPizza',
    set = 'LTMConsumableType',
    atlas = 'Jokers',
    pos = {x = 3, y = 10},
    cost = 1,
    loc_txt = {
        name = 'Pizza',
        text = {
            'Gives 25% of current {C:attention}Blind requirement',
            'as {C:chips}Chips',
        },
        use_msg = "You gained {chips} chips from the Pizza!",
    },
    config = {
        extra = {chips = 0},
    },
    loc_vars = function(self, info_queue, center)
        local chips = center and center.ability and center.ability.extra.chips or 0
        return {vars = {math.floor(chips)}}
    end,
    can_use = function(self) 
        local blind_chips = G.GAME.blind and G.GAME.blind.chips or 0
        return G.STATE == G.STATES.SELECTING_HAND 
    end,
    use = function(self, card, area, copier)
        -- Play sound effect
        if config.sfx ~= false then
            play_sound(math.random() < 0.9 and "fn_pizza1" or "fn_pizza2")
        end
        
        -- Get blind chips and calculate the reward
        local blind_chips = G.GAME.blind and G.GAME.blind.chips or 0
        local award_chips = math.floor(blind_chips * 0.25)
        
        -- Award chips immediately
        G.GAME.chips = G.GAME.chips + award_chips
        G.GAME.pool_flags.ltm_pizza_flag = true
        
        -- Apply juice effect
        (copier or card):juice_up()

        -- Check if the round should end using an immediate event
        G.E_MANAGER:add_event(Event({
            trigger = "immediate",
            func = function()
                if G.STATE ~= G.STATES.SELECTING_HAND then
                    return false
                end
                if G.GAME.chips >= blind_chips then
                    G.STATE = G.STATES.HAND_PLAYED
                    G.STATE_COMPLETE = true
                    end_round()
                end
                return true
            end,
        }), "other")

        -- Return success message
        return {message = self.loc_txt.use_msg:gsub("{chips}", award_chips)}
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
        }
    },
    config = {
        extra = {
            slices = 2, -- Default to 2 slices
        },
    },
    loc_vars = function(self, info_queue, center)
        if center and center.ability and center.ability.extra then
            local slices = math.floor(center.ability.extra.slices) -- Ensure rounded-down value
            return {vars = {slices}}
        end
        return {vars = {}}
    end,
    can_use = function(self, card)
        return G and G.deck and #G.deck.cards > 0 -- Ensure the deck exists and isn't empty
    end,
    use = function(self, card, area, copier)
        if config.sfx ~= false then
            play_sound("fn_box") -- Play the Pizza sound effect
        end

        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.1,
            func = function()
                -- Dynamically reference the number of slices to create
                local slices_to_create = card.ability.extra.slices or 2 -- Default to 2 if nil
                for _ = 1, slices_to_create do
                    -- Create a new Pizza Slice card
                    local tarot_cards = {
                        'c_fn_LTMPizza', 'c_fn_LTMPizza', 'c_fn_LTMPizza',
                    }
                    local random_card_id = tarot_cards[math.random(1, #tarot_cards)]
                    local _card = create_card('Tarot', G.consumeables, nil, nil, nil, nil, random_card_id)
                    _card:add_to_deck()
                    G.consumeables:emplace(_card)
                end

                -- Return feedback to the player
                return {
                    message = string.format("You created %d Pizza Slice(s)!", slices_to_create)
                }
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
            'Eat up to {C:attention}5{} selected cards,',
			'Randomize their suit and rank',
            'Then convert them into {C:money}Legendary{} Cards.',
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
            'while held {C:attention}first played hand{}',
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
        if G.GAME.current_round.hands_played == 0 then
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
            copies = 2, -- Default: 2 copies per selected card
            cards = 1,  -- Default: Can only select 1 card
        }
    },
    loc_vars = function(self, info_queue, center)
        if center and center.ability and center.ability.extra then
            return {vars = {center.ability.extra.copies, center.ability.extra.cards}} 
        end
        return {vars = {}}
    end,
    can_use = function(self, card)
        return G and G.hand and G.hand.highlighted and 
            #G.hand.highlighted > 0 and #G.hand.highlighted <= self.config.extra.cards
    end,
    use = function(self, card, area, copier)
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.1,
            func = function()
                if G and G.hand and G.hand.highlighted and #G.hand.highlighted > 0 then
                    local suits = {"Hearts", "Diamonds", "Clubs", "Spades"}
                    local new_cards = {}

                    for _, target_card in ipairs(G.hand.highlighted) do
                        for _ = 1, self.config.extra.copies do
                            local copy = copy_card(target_card)
                            G.hand:emplace(copy)
                            copy:start_materialize(nil, nil)

                            -- **Use SMODS.change_base to set a random suit**
                            local new_suit = suits[math.random(#suits)]
                            SMODS.change_base(copy, new_suit)

                            table.insert(new_cards, copy)
                        end
                    end

                    -- Apply any additional effects
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
            'Split +{C:mult}20{} permanent Mult across {C:attention}all selected cards{}',
        }
    },
    config = {
        extra = {} -- No selection limit needed
    },
    loc_vars = function(self, info_queue, center)
        return {vars = {}}
    end,
    can_use = function(self, card)
        return G and G.hand and G.hand.highlighted and #G.hand.highlighted > 0
    end,
    use = function(self, card, area, copier)
        if G and G.hand and G.hand.highlighted and #G.hand.highlighted > 0 then
            -- Calculate split multiplier
            local split_mult = math.floor(20 / #G.hand.highlighted)

            for _, target_card in ipairs(G.hand.highlighted) do
                -- Apply split permanent multiplier
                target_card.ability.perma_mult = (target_card.ability.perma_mult or 0) + split_mult

                -- Juice-up effect for feedback
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
    config = { extra = 3, choose = 1 },
    weight = 1,
    cost = 4,
    group_key = 'LTMConsumableType',
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
        return { vars = { card.config.center.config.choose, card.ability.extra } }
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
    group_key = 'LTMConsumableType',
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
        return { vars = { card.config.center.config.choose, card.ability.extra } }
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
    config = {type = "new_blind_choice"},
    apply = function(self, tag, context)
        if context.type == "new_blind_choice" then
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
    config = {type = "new_blind_choice"},
    apply = function(self, tag, context)
        if context.type == "new_blind_choice" then
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
------------FRACTURE CODE BEGIN----------------------

SMODS.Atlas({ key = "Blinds", atlas_table = "ANIMATION_ATLAS", path = "Blinds.png", px = 34, py = 34, frames = 21 })

SMODS.Blind {
    loc_txt = {
        name = 'Fracture',
        text = { 'All played cards are destroyed' }
    },
    key = 'Fracture',
    name = 'Fracture',
    config = {},
    boss = { min = 1, max = 10, hardcore = true },
    boss_colour = HEX("672A62"),
    atlas = "Blinds",
    pos = { x = 0, y = 0 },
    dollars = 5,

    press_play = function (self)
    G.E_MANAGER:add_event(Event({
        func = function()
            -- Loop through the played cards in reverse order
            for i = #G.play.cards, 1, -1 do
                G.E_MANAGER:add_event(Event({
                    func = function()
                        G.play.cards[i]:start_dissolve({ G.C.BLUE }, nil, 1.6, false)
                        return true
                    end,
                    delay = 0.5,
                }), 'base')
            end
            return true
        end
    }))
    return true
end
}

----------------------------------------------
------------FRACTURE CODE END----------------------

----------------------------------------------
------------ZERO BUILD CODE BEGIN----------------------

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

----------------------------------------------
------------ZERO BUILD CODE END----------------------

----------------------------------------------
------------STORM SEAL CODE BEGIN----------------------

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

----------------------------------------------
------------STORM SEAL CODE END----------------------

----------------------------------------------
------------GLITCHED SEAL CODE BEGIN----------------------

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
            local rand = math.random(1, 8) -- Pick a random effect (now 8 options)

            if rand == 1 then
                -- Create a random LTM consumable (no limit check)
                local consumable = create_card("LTMConsumableType", G.consumeables, nil, nil, nil, nil, nil, "fn_ltm_sword")
                if consumable then
                    consumable:add_to_deck()
                    G.consumeables:emplace(consumable)
                end

            elseif rand == 2 then
                -- Give $5
                ease_dollars(5)
                G.GAME.dollar_buffer = (G.GAME.dollar_buffer or 0) + 5
                G.E_MANAGER:add_event(Event({func = (function() G.GAME.dollar_buffer = 0; return true end)}))

            elseif rand == 3 then
                -- Add a random tarot card
                local consumable = create_card("Tarot", G.consumeables, nil, nil, nil, nil, nil, "c_fool")
                if consumable then
                    consumable:add_to_deck()
                    G.consumeables:emplace(consumable)
                end

            elseif rand == 4 then
                -- Give +1 hand this round
                ease_hands_played(1)

            elseif rand == 5 then
                -- Give +1 discard this round
                ease_discard(1)

            elseif rand == 6 then
                -- Create a random spectral card
                local consumable = create_card("Spectral", G.consumeables, nil, nil, nil, nil, nil, "c_fool")
                if consumable then
                    consumable:add_to_deck()
                    G.consumeables:emplace(consumable)
                end

            elseif rand == 7 then
                -- Return the card to hand
                draw_card(G.play, G.hand, 100, 'up', true, card, 0, false, false, 1, false)

            elseif rand == 8 then
                -- Give a random tag
                local random_tags = {"tag_fn_LTMTag1", "tag_fn_LTMTag2", 'tag_uncommon', 'tag_rare', 'tag_negative', 'tag_foil', 'tag_holo', 'tag_polychrome', 'tag_investment', 'tag_voucher', 'tag_boss', 'tag_standard', 'tag_charm', 'tag_meteor', 'tag_buffoon', 'tag_handy', 'tag_garbage', 'tag_ethereal', 'tag_coupon', 'tag_double', 'tag_juggle', 'tag_d_six', 'tag_top_up', 'tag_skip', 'tag_orbital', 'tag_economy'}
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

----------------------------------------------
------------GLITCHED SEAL CODE END----------------------

----------------------------------------------
------------BOOGIE SEAL CODE BEGIN----------------------

SMODS.Sound({
	key = "boogie",
	path = "boogie.ogg",
})

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
            'If {C:attention}Played Hand{} contains this seal, ',
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
            if pseudorandom('boogie_seal') < (1 / self.config.extra.odds) then
                round.hands_left = self.config.extra.stored_hands +1
				if config.sfx ~= false then
					play_sound("fn_boogie") 
				end
            end
        end
    end
}

----------------------------------------------
------------BOOGIE SEAL CODE END----------------------

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
            'Start with 1 {C:red}Crac\'s{} and {C:spectral}Reality Augment{}',
            '{C:attention}The Arcana is the means by which all is revealed{}.',
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
------------ERIC DECK CODE BEGIN----------------------
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
                joker_add('j_fn_Eric')

                return true
            end
        }))
    end,

}
----------------------------------------------
------------ERIC DECK CODE END----------------------

----------------------------------------------
------------MOD CODE END----------------------
