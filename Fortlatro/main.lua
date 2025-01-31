--- STEAMODDED HEADER
--- MOD_NAME: Fortlatro
--- MOD_ID: Fortlatro
--- MOD_AUTHOR: [EricTheToon]
--- MOD_DESCRIPTION: A terribly coded mod to add Fortnite themed stuff + stuff for my friends to Balatro.
--- BADGE_COLOUR: 672A62
--- PREFIX: fn
--- PRIORITY: -69420
--- DEPENDENCIES: [Steamodded>=0.9.8, Talisman>=2.0.0-beta8,]
--- VERSION: 1.0.6 Release 
----------------------------------------------
------------MOD CODE -------------------------
SMODS.Atlas({
    key = 'modicon',
    path = 'modicon.png',
    px = '34',
    py = '34'
})

local config = SMODS.current_mod.config
----------------------------------------------
------------ERIC CODE BEGIN----------------------

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
                local new_card = create_card('Joker', G.jokers, is_soul, nil, nil, nil, nil, "mno")
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

SMODS.Joker{
  key = 'Emily',
  loc_txt = {
    name = 'Emily',
    text = {
      "Retrigger EVERYTHING"
    }
  },
  atlas = "Jokers",
  pos = { x = 4, y = 0 },
  config = {}, -- No need for `extra.odds`
  rarity = 4,
  order = 32,
  cost = 14,
  no_pool_flag = 'clam',
  blueprint_compat = true,
  loc_vars = function(self, info_queue, center)
    return {
      vars = { "" .. (G.GAME and G.GAME.probabilities.normal or 1) }
    }
  end,
  calculate = function(self, card, context)
    -- Check for retrigger conditions
    if context.retrigger_joker_check and not context.retrigger_joker and context.other_card ~= self then
      G.GAME.pool_flags.clam = true -- Ensure 'clam' flag is set
      return {
        message = "CLAM!",          -- Display "CLAM!" message
        colour = G.C.RED,           -- Add color if applicable
        repetitions = 1,            -- Retrigger action
        card = card,
      }
    end

    -- Check for repetition and update game state
    if context.repetition and context.cardarea == G.play then
      G.GAME.pool_flags.clam = true
      return {
        message = "CLAM!",
        colour = G.C.RED,
      }
    end
  end,
}

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
    discovered = true,
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
                "create a {C:dark_edition}LTM Card{}",
                "when {C:attention}Blind{} starts",
                "{C:inactive}(Must have room)"
            }
        }
    },
    atlas = 'Jokers',
    pos = { x = 1, y = 3 },
    config = {
        extra = { odds = 4 } -- 1 in 4 chance
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
                "them and earn an {C:dark_edition}LTM Card{}", 
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
local predefined_joker_names = { "Jimbo", "Crac", "Eric", "Emily", "Gavinia", "Ninja", "Lazarbeam", "Duality", "Zorlodo", "Krowe", "Epic Games", "MagmaReef", "90cranker", "ColonelChugJug", "Gatordile81", "JonseyForever35", "PositiveFeels", "TimeToGo80", "QueenBeet74", "AimLikeIdaho", "CrazyPea96", "GetItGotItGood", "JustABitEpic", "PrancingPwnee", "TooManyBeets", "MintElephant26", "AngryDuck51", "CrepeSalad", "GhostChicken12", "KittyCat80", "PrinceWombat", "WalkInThePark66", "BliceCake", "AthenaOrApollo", "DoctorLobby92", "Gooddoggo80", "Kregore73", "SergentSummer", "WildCactusBob", "BraunyBanana", "AtTheBeach321", "DoubleDaring", "Goosezilla13", "LetsBePals23", "ShadowArrow58", "Wondertail", "SoggyCookie26", "BagelBoy82", "DoubleDuel75", "Grandma40", "LewtGoblin7", "Shepard52", "Yeetman57", "AboveMule633", "BellyFlop40", "DoubleRainbow96", "HashtagToad57", "McCucumber71", "ShieldHorse63", "Beebitme", "PurpleCrayon85", "Blackjack31", "DrPlanet", "HeliumHog", "Meshuncle", "ShootyMcGee40", "SweetPenguin16", "SpiffyPowder6866", "BlinkImGone44", "DrumGunnar", "HeyThereFriend81", "Mouthful95", "SilverySilver", "PortableOx", "LootTrooper51", "BoatingIsLife", "ElPollo85", "Hoodwinked12", "N0nDa1ry", "SirTricksALot21", "ASweatyDog", "LousyCentaur", "BoldPrediction", "FlavorCaptain", "HotelBlankets", "NotAPalidome", "SteelGoose18", "&darkBeast&", "BrainInvader", "FlimsyGoat", "HowAreMy90s", "Number141", "TAgYOuRIt9", "BobDobaleena", "CactusDad80", "FlossPatrol82", "iHazHighGround", "ParanoidCactus", "ThermalDragon39", "OldWaterBottle28", "JesterJumps23", "LaughingLance89", "BalatroKing", "PranksterPie42", "CourtFool77", "SillySpecter", "MaskMischief91", "HarlequinHoop", "GrinGoblin", "ClownPrince44", "GiggleGoose66", "QuipMaster7", "FoolishFrolic", "ChuckleCharger", "WittyWanderer", "JestInTime", "LaughingLotus", "ComicCapper", "LoomingLaughter", "TricksterTango", "MockingMask", "FollyFellow", "SnarkyShadow", "MirthMaker42", "SardonicSprout", "CaperCrown", "GleefulGambit", "JugglingJack88", "TwirlingTrixie", "ChortlingChimp", "MerryMadcap", "SnickerSprite", "BalatroBard", "WitfulWraith", "PranceJester55", "LaughterLynx", "FoolhardyFox", "TumbleTrix89", "JovialJoker", "GleeGoblin79", "CourtroomClown", "WhimsicalWill", "RiddleRogue", "CaperingCrane", "MockeryMaven", "GiddyGambler", "JestfulJinx", "HarlequinHustler", "PantomimePrince", "BalatroBelle", "TrickyTroubadour", "SmirkSprite42", "Peter Griffin", "FoolishFencer", "JesterJourney", "MirthfulMage", "GiddyGladiator", "WhimsyWarden", "ChuckleChampion", "PranksterPuppeteer", "TwirlingTinker", "JovialJuggler", "BuffoonBard", "LaughingLancer", "SnickerSquire", "WittyWitch", "ClownishChronicler", "FoolishFlair", "TricksterTide", "GrinGryphon", "JesterJive", "TumbleTeller", "MimicMarauder", "ComicalCorsair", "QuipQueen", "PrankPirate", "LudicrousLynx", "GleamingGagster", "LaughterLynx", "FollyFiend", "SillySorcerer", "MockingMarauder", "CheerfulCoyote", "WitWhisperer", "FancifulFool", "TrixieTroll", "LaughingLad", "MerrymakingMonk", "BalatroBanshee", "CaperingCavalier", "PantomimePug", "SnickerSpecter", "Jolly Joker", "WaggishWitch", "FooleryFox", "SardonicSquire", "ChortlingClown", "TrixieTrickster", "DrollDruid", "PunnyPaladin", "GrinningGolem", "BanterBard", "MockingMimic", "WittyWraith", "GleefulGargoyle" }

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
                "Gains {C:attention}#1#{} {C:chips}Chips{} for each Joker when scoring",
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
			'For every consecutive round without',
			'buying something at the {C:attention}Shop{}',
			'gain {X:mult,C:white}X0.5{} Mult',
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
			Xmult = 1
		}
	},
	loc_vars = function(self,info_queue,center)
		return {vars = {center.ability.extra.Xmult}}
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
			card.ability.extra.Xmult=1
			return
			{
				message = 'Reset!',
				colour = G.C.MULT
			}
		end
		
		if context.end_of_round and not context.repetition and not context.individual then
			card.ability.extra.Xmult=card.ability.extra.Xmult+0.5 
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
                "Every LTM consumable used adds {C:mult}#2#{} Mult",
                "Spawn 2 Negative LTM Cards upon obtaining this Joker",
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
        if not from_debuff and #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
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
                "{C:mult}#1#{} Mult",
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
            "area and gain {C:chips}#1# {C:chips}Chips{} per card destroyed",
            "{C:inactive}Currently{} {C:chips}#2# {C:inactive}Chips"
        }
    },
    config = {extra = {stored_chips = 0, chips_per_card = 50}},
    rarity = 3,
    pos = {x = 2, y = 10},
    atlas = 'Jokers',
    cost = 5,
    unlocked = true,
    discovered = true,
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
    blueprint_compat = false,

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

            -- Self-destruct if 2 or more Aces
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
            cards = 2, -- configurable value
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
    can_use = function(self, card)
        -- Use the card’s dynamically updated value instead of the fixed config value
        local cards_to_draw = card and card.ability and card.ability.extra and card.ability.extra.cards or self.config.extra.cards
        if G and G.hand and G.hand.highlighted then
            if #G.hand.highlighted >= 0 and #G.hand.highlighted <= cards_to_draw then
                return true
            end
        end
        return false
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
            'Create {C:attention}#1#{} {C:dark_edition}Negative',
            'copies of {C:attention}#2#{} random cards from the deck',
        }
    },
    config = {
        extra = { cards = 1, copies = 3 },
    },
    loc_vars = function(self, info_queue, center)
        info_queue[#info_queue + 1] = G.P_CENTERS.e_negative
        if center and center.ability and center.ability.extra then
            return {vars = {center.ability.extra.cards, center.ability.extra.copies}} 
        end
        return {vars = {}}
    end,
    can_use = function(self, card)
        if G and G.deck and #G.deck.cards > 0 and card.ability and card.ability.extra and card.ability.extra.copies then
            return true
        end
        return false
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

                -- Select the first `card.ability.extra.copies` random cards
                local selected_cards = {}
                for i = 1, math.min(#all_cards, card.ability.extra.copies) do
                    selected_cards[#selected_cards + 1] = all_cards[i]
                end

                -- Create negative copies of the selected cards
                for _, selected_card in ipairs(selected_cards) do
                    local new_card = copy_card(selected_card)
                    new_card:set_edition({negative = true}, true)
                    new_card:add_to_deck()
                    G.deck.config.card_limit = G.deck.config.card_limit + 1
                    G.hand:emplace(new_card)
                    playing_card_joker_effects({new_card})
                end

                return true
            end
        }))
    end,
}


----------------------------------------------
------------DECOY GRENADE CODE END----------------------

----------------------------------------------
------------LEFT HANDED DEATH CODE BEGIN----------------------

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

if config.enhancementcompat ~= false then
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

----------------------------------------------
------------CRYSTAL CODE END----------------------

----------------------------------------------
------------RAINBOW CODE BEGIN----------------------
if config.enhancementcompat ~= false then
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
end

----------------------------------------------
------------RAINBOW CODE END----------------------

----------------------------------------------
------------WOOD CODE BEGIN----------------------
if config.enhancementcompat ~= false then
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

----------------------------------------------
------------WOOD CODE END----------------------

----------------------------------------------
------------BRICK CODE BEGIN----------------------

SMODS.Sound({
	key = "gnome",
	path = "gnome.ogg",
})

if config.enhancementcompat ~= false then
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
        extra = { odds = 10 }, -- Configuration: odds of success (set to 2 for 50% chance)
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
if config.enhancementcompat ~= false then
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


----------------------------------------------
------------METAL CODE END----------------------

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

if config.enhancementcompat ~= false then
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
                cards = 1, -- configurable value
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
end

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
        return G and (#G.hand.cards > 0) and card.ability and card.ability.extra and card.ability.extra.discards
    end,
    use = function(self, card, area, copier)
        if self.config.sfx ~= false then
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
            'Select {C:attention}#1#{} cards and {C:mult}destroy{} them',
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

        -- Destroy the selected cards in hand
        if G and G.hand and G.hand.highlighted then
            for _, selected_card in ipairs(G.hand.highlighted) do
                selected_card:start_dissolve() -- Dissolves the selected card
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
        return G and G.deck and #G.deck.cards > 0
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
        extra = {
            chips = 0, 
        },
        sfx = true,
    },
    loc_vars = function(self, info_queue, center)
        if center and center.ability and center.ability.extra then
            local cards = math.floor(center.ability.extra.chips) -- Ensure rounded-down value
            return {vars = {cards}}
        end
        return {vars = {}}
    end,
    can_use = function(self, card)
        return G and (#G.hand.cards > 0)
    end,
    use = function(self, card, area, copier)
        if self.config.sfx then
            -- Randomly choose between fn_pizza1 and fn_pizza2
            local pizza_sound = math.random() < 0.9 and "fn_pizza1" or "fn_pizza2"
            play_sound(pizza_sound)
        end

        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.1,
            func = function()
                -- Calculate 25% of the current blind requirement
                local blind_chips = G.GAME.blind and G.GAME.blind.chips or 0 -- Fallback to 0 if undefined
                local award_chips = math.floor(blind_chips * 0.25) -- 25%, rounded down

                -- Add the calculated chips to the player's total
                G.GAME.chips = G.GAME.chips + award_chips

                -- Set a unique flag for this consumable
                G.GAME.pool_flags.ltm_pizza_flag = true

                -- Enhance the card that used the consumable
                (copier or card):juice_up()

                -- Check if the score meets or exceeds the blind chips requirement
                if G.GAME.chips >= blind_chips then
                    G.STATE = G.STATES.HAND_PLAYED -- Change state to indicate the round is over
                    G.STATE_COMPLETE = true        -- Mark the state as complete
                    end_round()                    -- End the round
                end

                -- Return a message to indicate success
                local message = self.loc_txt.use_msg:gsub("{chips}", award_chips)
                return { message = message }
            end
        }))
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
        if self.config.sfx ~= false then
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
        if self.config.sfx ~= false then
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
            'Create {C:attention}#1#{} random {C:purple}LTM Cards{}',
            '{C:inactive}(Must have room)'
        }
    },
    config = {
        extra = {
            cards = 2, -- Configurable number of cards (default: 2)
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
        -- Check if there's room in the consumables deck
        if #G.consumeables.cards + G.GAME.consumeable_buffer <= G.consumeables.config.card_limit then
            return true  -- Consumable can be used
        else
            return false  -- Consumable cannot be used if the deck is full
        end
    end,
    use = function(self, card, area, copier)
        if config.sfx ~= false then
            play_sound("fn_error")
        end

        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.1,
            func = function()
                -- Dynamically reference the 'cards' value from the consumable's config
                local num_cards = self.config.extra.cards or 2  -- Default to 2 if nil
                for _ = 1, num_cards do
                    -- Check if we can create a new LTM card based on the conditions
                    if #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
                        -- Create and add the LTM card to the deck
                        local new_card = create_card('LTMConsumableType', G.consumeables)
                        new_card:add_to_deck()
                        G.consumeables:emplace(new_card)

                        -- Apply additional effects (e.g., debuffing or modifying the card)
                        G.GAME.blind:debuff_card(new_card)
                    end
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
        if self.config.sfx ~= false then
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
        if self.config.sfx ~= false then
            play_sound("fn_chest") -- Play the Chest sound effect
        end

        G.E_MANAGER:add_event(Event({
            func = function()
                if G.jokers then
                    -- Randomly decide if it's legendary or rare (50% chance each)
                    local is_legendary = math.random() < 0.5  -- 50% chance to be true (legendary)

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
------------BOOSTER CODE BEGIN----------------------
SMODS.Sound({
	key = "pack",
	path = "pack.ogg",
})

local disabled = {
    c_fn_LTMPizza = true,
    c_fn_LTMSlap = true
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
    c_fn_LTMSlap = true
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
