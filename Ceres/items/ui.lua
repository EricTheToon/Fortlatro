-- NEW FUNCS

G.FUNCS.can_exploit = function(e)
    local advantage = G.GAME.current_round.advantage_left or 0
    if #G.cere_perks.highlighted == 1 and advantage > 0 then
        e.config.colour = G.C.GREEN
        e.config.button = 'exploit_cards_from_highlighted'
    else
        e.config.colour = G.C.UI.BACKGROUND_INACTIVE
        e.config.button = nil
    end
end

G.FUNCS.exploit_cards_from_highlighted = function(e)
    if G.cere_exploit and G.cere_exploit.cards[1] then return end
    --check the hand first

    stop_use()
    G.GAME.blind.triggered = false
    G.CONTROLLER.interrupt.focus = true
    G.CONTROLLER:save_cardarea_focus('hand')
    
    table.sort(G.perks.highlighted, function(a,b) return a.T.x < b.T.x end)

    G.E_MANAGER:add_event(Event({
        trigger = 'immediate',
        func = function()
            G.STATE = G.STATES.HAND_PLAYED
            G.STATE_COMPLETE = true
            return true
        end
    }))
    ease_advantage(-1)
    delay(0.4)

        for i=1, #G.cere_perks.highlighted do
            draw_card(G.perks, G.cere_exploit, i*100/#G.hand.highlighted, 'up', nil, G.cere_perks.highlighted[i], nil, true)
        end

        G.E_MANAGER:add_event(Event({
            trigger = 'immediate',
            func = (function()

                G.E_MANAGER:add_event(Event({
                    trigger = 'immediate',
                    func = function()
                        G.FUNCS.evaluate_exploit()
                        return true
                    end
                }))

                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    delay = 0.1,
                    func = function()
                        G.FUNCS.draw_from_exploit()
                        return true
                    end
                }))
                G.E_MANAGER:add_event(Event({
                    trigger = 'immediate',
                    func = function()
                        G.STATE_COMPLETE = false
                        return true
                    end
                }))
                return true
            end)
        }))
end

G.FUNCS.evaluate_exploit = function(e)
    local exploited_card = G.cere_exploit.cards[1]
    delay(0.2)
    highlight_card(exploited_card,1,'up')

    local percent = 0.3
    local percent_delta = 0.08
    delay(0.3)

    local hand_text_set = false
    for i=1, #G.jokers.cards do
        --calculate any joker effects
        local effects = eval_card(G.jokers.cards[i], {cardarea = G.cere_exploit, exploited_card = exploited_card})
        if effects.jokers then
            card_eval_status_text(G.jokers.cards[i], 'jokers', nil, percent, nil, effects.jokers)
            percent = percent + percent_delta
        end
    end
    eval_perk(exploited_card, {cardarea = G.cere_exploit, exploited_card = exploited_card})
    card_eval_perk_text(exploited_card, exploited_card.ability.message, exploited_card.ability.colour)
    delay(0.4)
    --un-highlight all cards
    highlight_card(exploited_card,1,'down')
end

function eval_perk(card, context)
    local center = card.config.center
    context = context or {}
    local ret = {}

    if card.ability.set == 'Perk' and center.calculate and type(center.calculate) == 'function' then
        center:calculate(context, ret, card)
    end
    return ret
end

function card_eval_perk_text(card, message, colour)
	if not (card.ability and card.ability.set == 'Perk') then return end
	local message = message or 'Exploit!'
	local colour = colour or G.C.GREEN
    local percent = (0.9 + 0.2*math.random())
    local volume = 1
    local config = {
        scale = 0.7,
        type = 'fall'
    }
    local delay = 0.75 * 1.25
    local extrafunc = nil
    local sound = 'generic1'
    G.E_MANAGER:add_event(Event({ --Add bonus chips from this card
        trigger = 'before',
		delay = delay,
        func = function()
        if extrafunc then extrafunc() end
        attention_text({
            text = message,
            scale = config.scale or 1, 
            hold = delay - 0.2,
            backdrop_colour = colour,
            align = cm,
            major = card,
            offset = {x = 0, y = 0}
        })
        play_sound(sound, 0.8+percent*0.2, volume)
        if not extra or not extra.no_juice then
            card:juice_up(0.6, 0.1)
            G.ROOM.jiggle = G.ROOM.jiggle + 0.7
        end
		--card:perk_dissolve()
        return true
        end
    }))
end

if not Ceres.COMPAT.loyaltycard then
function ease_advantage(mod, instant)
    local _mod = function(mod)
        local advantage_UI = G.HUD:get_UIE_by_ID('advantage_UI_count')
        mod = mod or 0
        local text = '+'
        local col = G.C.GREEN
        if mod < 0 then
            text = ''
            col = G.C.RED
        end
        G.GAME.current_round.advantage_left = G.GAME.current_round.advantage_left + mod
        advantage_UI.config.object:update()
        G.HUD:recalculate()
        --Popup text next to the chips in UI showing number of chips gained/lost
        attention_text({
          text = text..mod,
          scale = 0.8, 
          hold = 0.7,
          cover = advantage_UI.parent,
          cover_colour = col,
          align = 'cm',
          })
        --Play a chip sound
        play_sound('chips2')
    end
    if instant then
        _mod(mod)
    else
        G.E_MANAGER:add_event(Event({
        trigger = 'immediate',
        func = function()
            _mod(mod)
            return true
        end
        }))
    end
end
end

G.FUNCS.draw_from_exploit = function(e)
    local count = #G.cere_exploit.cards
    local it = 1
    for k, v in ipairs(G.cere_exploit.cards) do
        if v.shredded then
            G.GAME.cere.shredded[G.GAME.cere.shredded+1] = v.ability.name
            card:dissolve()
        elseif v.burnt then
            draw_card(G.cere_exploit,G.cere_burnt, it*100/count,'down', false, v, 0.07)
            v.burnt = nil
        elseif v.to_hand then
            draw_card(G.cere_exploit,G.cere_perks, i*100/count,'up', true, v, 0.07)
        elseif v.to_deck then
            draw_card(G.cere_exploit, G.deck, i*100/count,'down', false, v, 0.07)
        else
            draw_card(G.cere_exploit,G.discard, it*100/count,'down', false, v, 0.07)
        end
    end
end

G.FUNCS.cere_draw_from_burnt_to_discard = function(e)
    local count = #G.cere_burnt.cards
    local it = 1
    for k, v in ipairs(G.cere_burnt.cards) do
        draw_card(G.cere_burnt,G.discard, it*100/count,'down', false, v)
        it = it + 1
    end
end

G.FUNCS.cere_save_config = function(e)
    Ceres.FUNCS.save_config()
end
  
Ceres.FUNCS.create_toggle = function(args)
    args = args or {}
    args.active_colour = args.active_colour or G.C.RED
    args.inactive_colour = args.inactive_colour or G.C.BLACK
    args.w = args.w or 1.5
    args.h = args.h or 0.5
    args.scale = args.scale or 1
    args.label = args.label or nil
    args.label_scale = args.label_scale or 0.4
    args.ref_table = args.ref_table or {}
    args.ref_value = args.ref_value or "test"

    local check = Sprite(0, 0, 0.5 * args.scale, 0.5 * args.scale, G.ASSET_ATLAS["icons"], { x = 1, y = 0 })
    check.states.drag.can = false
    check.states.visible = false

    local info = nil
    if args.info then
        info = {}
        for k, v in ipairs(args.info) do
            table.insert(info, {
                n = G.UIT.R,
                config = { align = "cm", minh = 0.05 },
                nodes = {
                    { n = G.UIT.T, config = { text = v, scale = 0.25, colour = G.C.UI.TEXT_LIGHT } },
                },
            })
        end
        info = { n = G.UIT.R, config = { align = "cm", minh = 0.05 }, nodes = info }
    end

    local t = {
        n = args.col and G.UIT.C or G.UIT.R,
        config = {
            align = "cr",
            padding = 0.1,
            r = 0.1,
            colour = G.C.CLEAR
        },
        nodes = {
            {
                n = G.UIT.C,
                config = {
                    align = "cm",
                    r = 0.1,
                    padding = 0.03,
                    minw = 0.4 * args.scale,
                    minh = 0.4 * args.scale,
                    outline_colour = G.C.WHITE,
                    outline = 1.15 * args.scale,
                    ref_table = args,
                    colour = args.inactive_colour,
                    button = "toggle_button",
                    button_dist = 0.2,
                    hover = true,
                    toggle_callback = args.callback,
                    func = "toggle",
                },
                nodes = {
                    {
                        n = G.UIT.O,
                        config = {
                            object = check
                        } 
                    },
                },
            },
        },
    }
    if args.label then
        ins = {
            n = G.UIT.C,
            config = { align = "cr", minw = args.w },
            nodes = {
            { n = G.UIT.T, config = { text = args.label, scale = args.label_scale, colour = G.C.UI.TEXT_LIGHT } },
            { n = G.UIT.B, config = { w = 0.1, h = 0.1 } },
            },
        }
        table.insert(t.nodes, 1, ins)
    end
    if args.info then
        t = { n = args.col and G.UIT.C or G.UIT.R, config = { align = "cm" }, nodes = {
            t,
            info,
        } }
    end
    return t
end

Ceres.FUNCS.create_buttons = function(args, back, save_func)
    save_func = save_func or 'cere_save_config'
    args = args or {
        label = 'Label',
        toggle_ref = nil,
        ref_value = nil,
        button_ref = nil,
        button_label = 'Button',
        remove_enable = true,
    }
    
    local t = {
        {
            n = G.UIT.R,
            config = {
                align = "cm",
                padding = 0,
                minh = 7.5,
                colour = G.C.CLEAR
            },
            nodes = not back and {
                {
                    n = G.UIT.R,
                    config = {
                        align = "tm",
                        colour = G.C.CLEAR,
                        r = 0.1,
                        padding = 0,
                    },
                    nodes = {
                        {
                            n = G.UIT.R,
                            config = {
                                align = "tm",
                                padding = 0,
                            },
                            nodes = {
                                {
                                    n = G.UIT.T,
                                    config = {
                                        text = 'Applied on Game Restart',
                                        scale = 0.4,
                                        colour = G.C.UI.TEXT_LIGHT,
                                        shadow = true,
                                    },
                                }
                            }
                        }
                    }
                },
                {
                    n = G.UIT.R,
                    config = {
                        align = "tm",
                        colour = G.C.CLEAR,
                        r = 0.1,
                        minh = 0.3,
                        padding = 0,
                    },
                }
            } or {}
        }
    }
    
    for k, v in pairs(args) do
        t[1].nodes[#t[1].nodes+1] = {
            n = G.UIT.R,
            config = {
                align = "cm",
                colour = G.C.CLEAR,
                r = 0.1,
                padding = 0,
            },
            nodes = {
                {
                    n = G.UIT.R,
                    config = {
                        align = "cm",
                        padding = 0.05,
                    },
                    nodes = {
                        {
                            n = G.UIT.C,
                            config = {
                                align = "cl",
                                padding = 0.1,
                                minw = 3.6,
                            },
                            nodes = {
                                {
                                    n = G.UIT.O,
                                    config = {
                                        object = DynaText({
                                            string = (not v.remove_enable and "Enable " .. v.label) or v.label,
                                            colours = { G.C.WHITE },
                                            shadow = true,
                                            scale = 0.4
                                        }),
                                    },
                                }
                            }
                        },
                        {
                            n = G.UIT.C,
                            config = {
                                align = "cr",
                                padding = 0.1,
                                minw = 1,
                            },
                            nodes = {
                                ((v.button_ref == nil) and {
                                    n = G.UIT.C,
                                    config = {
                                        align = "cm",
                                        r = 0.1,
                                        padding = 0,
                                        minw = 2.05,
                                        colour = G.C.CLEAR,
                                    },
                                })
                                or nil,
                                v.toggle_ref and 
                                Ceres.FUNCS.create_toggle({
                                    scale = 0.9,
                                    ref_table = v.toggle_ref,
                                    ref_value = 'enabled',
                                    active_colour = G.C.SECONDARY_SET.Planet,
                                    callback = function(x) end,
                                    col = true,
                                })
                                or {
                                    n = G.UIT.C,
                                    config = {
                                        align = "cm",
                                        r = 0.1,
                                        padding = 0.03,
                                        minw = 0.9,
                                        minh = 0.4,
                                        colour = G.C.CLEAR,
                                    },
                                },
                                ((v.toggle_ref and v.button_ref) and {
                                    n = G.UIT.C,
                                    config = {
                                        align = "cm",
                                        r = 0.1,
                                        padding = 0,
                                        minw = 0.1,
                                        minh = 0.4,
                                        colour = G.C.CLEAR,
                                    },
                                })
                                or nil,
                                v.button_ref and
                                {
                                    n = G.UIT.C,
                                    config = {
                                        id = "overlay_menu_config_button"..v.label,
                                        align = "cm",
                                        minw = 1.8,
                                        button_delay = args.back_delay,
                                        minh = 0.75,
                                        padding = 0.13,
                                        r = 0.1,
                                        hover = true,
                                        colour = G.C.SECONDARY_SET.Planet,
                                        button = v.button_ref,
                                        ref_page = v.ref_page,
                                        shadow = false,
                                        outline_colour = lighten(G.C.JOKER_GREY, 0.5),
                                        outline = 1.15,
                                    },
                                    nodes = {
                                        {
                                            n = G.UIT.C,
                                            config = {
                                                align = "cm",
                                                padding = 0,
                                                no_fill = true,
                                            },
                                            nodes = {
                                                {
                                                    n = G.UIT.T,
                                                    config = {
                                                        text = v.button_label or 'Options',
                                                        scale = 0.4,
                                                        colour = G.C.UI.TEXT_LIGHT,
                                                        shadow = true,
                                                    },
                                                },
                                            },
                                        },
                                    },
                                }
                                or nil
                            }
                        }
                    },
                }
            }
        }
    end

    if not back then
        t[2] = {
            n = G.UIT.R,
            config = {
                align = "bm",
                minh = 0.1,
                r = 0.2,
                padding = 0.08,
                colour = args.colour or G.C.CLEAR,
            },
            nodes = {
                {
                    n = G.UIT.R,
                    config = {
                        align = 'bm',
                        minw = 3.5,
                        minh = 0.6,
                        padding = 0.1,
                        r = 0.1,
                        hover = true,
                        colour = G.C.SECONDARY_SET.Planet,
                        button = save_func,
                        shadow = false,
                        outline_colour = lighten(G.C.JOKER_GREY, 0.5),
                        outline = 1.15,
                    },
                    nodes = {
                        {
                            n = G.UIT.R,
                            config = {
                                align = 'cm',
                                padding = 0,
                                no_fill = true
                            },
                            nodes = {
                                {
                                    n = G.UIT.T,
                                    config = {
                                        text = 'Save',
                                        scale = 0.4,
                                        colour = G.C.UI.TEXT_LIGHT,
                                        shadow = true,
                                    },
                                },
                            },
                        },
                    },
                },
            },
        }
    end

    if back then
        t[2] = {
            n = G.UIT.R,
            config = {
                align = "bm",
                minh = 0.1,
                r = 0.2,
                padding = 0.08,
                colour = args.colour or G.C.CLEAR,
            },
            nodes = {
                {
                    n = G.UIT.R,
                    config = {
                        align = 'bm',
                        minw = 3.5,
                        minh = 0.6,
                        padding = 0.1,
                        r = 0.1,
                        hover = true,
                        colour = G.C.RED,
                        button = 'cere_change_page',
                        ref_page = back,
                        shadow = false,
                        outline_colour = lighten(G.C.JOKER_GREY, 0.5),
                        outline = 1.15,
                    },
                    nodes = {
                        {
                            n = G.UIT.R,
                            config = {
                                align = "cm",
                                padding = 0,
                                no_fill = true
                            },
                            nodes = {
                                {
                                    n = G.UIT.T,
                                    config = {
                                        text = 'Back',
                                        scale = 0.4,
                                        colour = G.C.UI.TEXT_LIGHT,
                                        shadow = true,
                                    },
                                },
                            },
                        },
                    },
                }
            }
        }
    end
    return t
end



-- HOOKS

local create_UIBox_buttons_ref = create_UIBox_buttons
function create_UIBox_buttons()
    local ret = create_UIBox_buttons_ref()
    if Ceres.CONFIG.card_modifiers.perks.enabled then
        local exploit_button = {n=G.UIT.C, config={id = 'exploit_button', align = "tm", minw = 2.5, padding = 0.3, r = 0.1, hover = true, colour = G.C.GREEN, button = "exploit_cards_from_highlighted", one_press = true, shadow = true, func = 'can_exploit'}, nodes={
        {n=G.UIT.R, config={align = "bcm", padding = 0}, nodes={
            {n=G.UIT.T, config={text = localize('b_exploit'), scale = 0.45, colour = G.C.UI.TEXT_LIGHT, focus_args = {button = 'x', orientation = 'bm'}, func = 'set_button_pip'}}
        }},
        }}
        table.insert(ret.nodes, 1, exploit_button)
    end
    return ret
end

local get_badge_colour_ref = get_badge_colour
function get_badge_colour(key)
    local ref_return = get_badge_colour_ref(key)
    return Ceres.C[key] or ref_return
end

-- OVERWRITES

if Ceres.CONFIG.card_modifiers.perks.enabled then
function create_UIBox_HUD()
    local scale = 0.4
    local stake_sprite = get_stake_sprite(G.GAME.stake or 1, 0.5)

    local contents = {}

    local spacing = 0.13
    local temp_col = G.C.DYN_UI.BOSS_MAIN
    local temp_col2 = G.C.DYN_UI.BOSS_DARK
    contents.round = {
        {
            n=G.UIT.R,
            config={align = "cm"},
            nodes={
                {
                    n=G.UIT.C,
                    config={id = 'hud_advantage',align = "cm", padding = 0.05, minw = 1.45, colour = temp_col, emboss = 0.05, r = 0.1},
                    nodes={
                        {
                            n=G.UIT.R, 
                            config={align = "cm", minh = 0.33, maxw = 1.35}, 
                            nodes={
                                {
                                    n=G.UIT.T,
                                    config={text = localize('k_hud_advantage'), scale = 0.85*scale, colour = G.C.UI.TEXT_LIGHT, shadow = true}
                                },
                            }
                        },
                        {
                            n=G.UIT.R,
                            config={align = "cm", r = 0.1, minw = 1.2, colour = temp_col2},
                            nodes={
                                {
                                    n=G.UIT.O, 
                                    config={object = DynaText({string = {{ref_table = G.GAME.current_round, ref_value = 'advantage_left'}}, font = G.LANGUAGES['en-us'].font, colours = {G.C.GREEN},shadow = true, rotate = true, scale = 2*scale}),id = 'advantage_UI_count'}
                                },
                            }
                        }
                    }
                }, 
                {
                    n=G.UIT.C,
                    config={minw = spacing},
                    nodes={}
                },
                {
                    n=G.UIT.C, 
                    config={id = 'hud_hands',align = "cm", padding = 0.05, minw = 1.45, colour = temp_col, emboss = 0.05, r = 0.1}, 
                    nodes={
                        {
                            n=G.UIT.R, 
                            config={align = "cm", minh = 0.33, maxw = 1.35}, 
                            nodes={
                                {
                                    n=G.UIT.T, config={text = localize('k_hud_hands'), scale = 0.85*scale, colour = G.C.UI.TEXT_LIGHT, shadow = true}
                                },
                            }
                        },
                        {
                            n=G.UIT.R, 
                            config={align = "cm", r = 0.1, minw = 1.2, colour = temp_col2}, 
                            nodes={
                                {
                                    n=G.UIT.O, 
                                    config={object = DynaText({string = {{ref_table = G.GAME.current_round, ref_value = 'hands_left'}}, font = G.LANGUAGES['en-us'].font, colours = {G.C.BLUE},shadow = true, rotate = true, scale = 2*scale}),id = 'hand_UI_count'}
                                },
                            }
                        }
                    }
                },
                {
                    n=G.UIT.C, 
                    config={minw = spacing},
                    nodes={}
                },
                {
                    n=G.UIT.C, 
                    config={align = "cm", padding = 0.05, minw = 1.45, colour = temp_col, emboss = 0.05, r = 0.1}, 
                    nodes={
                        {
                            n=G.UIT.R, 
                            config={align = "cm", minh = 0.33, maxw = 1.35}, 
                            nodes={
                                {
                                    n=G.UIT.T, config={text = localize('k_hud_discards'), scale = 0.85*scale, colour = G.C.UI.TEXT_LIGHT, shadow = true}
                                },
                            }
                        },
                        {
                            n=G.UIT.R, 
                            config={align = "cm"}, 
                            nodes={
                                {
                                    n=G.UIT.R, 
                                    config={align = "cm", r = 0.1, minw = 1.2, colour = temp_col2}, 
                                    nodes={
                                        {
                                            n=G.UIT.O, 
                                            config={object = DynaText({string = {{ref_table = G.GAME.current_round, ref_value = 'discards_left'}}, font = G.LANGUAGES['en-us'].font, colours = {G.C.RED},shadow = true, rotate = true, scale = 2*scale}),id = 'discard_UI_count'}
                                        },
                                    }
                                }
                            }
                        },
                    }
                },
            }
        }
    }
    contents.dols = {
        {
            n=G.UIT.R, 
            config={align = "cm"}, 
            nodes={
                {
                    n=G.UIT.C, 
                    config={align = "cm", padding = 0.05, minw = 1.45*2 + spacing, minh = 1.15, colour = temp_col, emboss = 0.05, r = 0.1}, 
                    nodes={
                        {
                            n=G.UIT.R, config={align = "cm"}, 
                            nodes={
                                {
                                    n=G.UIT.C, 
                                    config={align = "cm", r = 0.1, minw = 1.28*2+spacing, minh = 1, colour = temp_col2}, 
                                    nodes={
                                        {
                                            n=G.UIT.O, 
                                            config={object = DynaText({string = {{ref_table = G.GAME, ref_value = 'dollars', prefix = localize('$')}},
                                            scale_function = function ()
                                                return scale_number(G.GAME.dollars, 2.2 * scale, 99999, 1000000)
                                            end, maxw = 1.35, colours = {G.C.MONEY}, font = G.LANGUAGES['en-us'].font, shadow = true,spacing = 2, bump = true, scale = 2.2*scale}), id = 'dollar_text_UI'}
                                        }
                                    }
                                },
                            }
                        },
                    }
                },
            }
        },
    }
    contents.ante = {
        {
            n=G.UIT.C, config={minw = 0.2},nodes={}
        },
        {
            n=G.UIT.R, 
            config={align = "cm"}, 
            nodes={
                {
                    n=G.UIT.C, 
                    config={id = 'hud_ante',align = "cm", padding = 0.05, minw = 1.45, minh = 1, colour = temp_col, emboss = 0.05, r = 0.1}, 
                    nodes={
                        {
                            n=G.UIT.R, 
                            config={align = "cm", minh = 0.33, maxw = 1.35}, 
                            nodes={
                                {
                                    n=G.UIT.T, 
                                    config={text = localize('k_ante'), scale = 0.85*scale, colour = G.C.UI.TEXT_LIGHT, shadow = true}
                                },
                            }
                        },
                        {
                            n=G.UIT.R, 
                            config={align = "cm", r = 0.1, minw = 1.2, colour = temp_col2}, 
                            nodes={
                                {
                                    n=G.UIT.O, 
                                    config={object = DynaText({string = {{ref_table = G.GAME.round_resets, ref_value = 'ante'}}, colours = {G.C.IMPORTANT},shadow = true, font = G.LANGUAGES['en-us'].font, scale = scale_number(G.GAME.round_resets.ante, 2*scale, 100)}),id = 'ante_UI_count'}
                                },--{n=G.UIT.T, config={text = number_format(G.GAME.round_resets.ante), lang = G.LANGUAGES['en-us'], scale = scale_number(G.GAME.round_resets.ante, 2*scale, 100), colour = G.C.IMPORTANT, shadow = true,id = 'ante_UI_count'}},
                                {
                                    n=G.UIT.T, 
                                    config={text = " ", scale = 0.3*scale}
                                },
                                {
                                    n=G.UIT.T, 
                                    config={text = "/ ", scale = 0.7*scale, colour = G.C.WHITE, shadow = true}
                                },
                                {
                                    n=G.UIT.T, 
                                    config={ref_table = G.GAME, ref_value='win_ante', scale = scale, colour = G.C.WHITE, shadow = true}
                                }
                            }
                        },
                    }
                },
                {
                    n=G.UIT.C, 
                    config={minw = spacing},
                    nodes={}
                },
                {
                    n=G.UIT.C, 
                    config={align = "cm", padding = 0.05, minw = 1.45, minh = 1, colour = temp_col, emboss = 0.05, r = 0.1}, 
                    nodes={
                        {
                            n=G.UIT.R, 
                            config={align = "cm", maxw = 1.35}, 
                            nodes={
                                {
                                    n=G.UIT.T, 
                                    config={text = localize('k_round'), minh = 0.33, scale = 0.85*scale, colour = G.C.UI.TEXT_LIGHT, shadow = true}
                                },
                            }
                        },
                        {
                            n=G.UIT.R, 
                            config={align = "cm", r = 0.1, minw = 1.2, colour = temp_col2, id = 'row_round_text'}, 
                            nodes={
                                {
                                    n=G.UIT.O, 
                                    config={object = DynaText({string = {{ref_table = G.GAME, ref_value = 'round'}}, colours = {G.C.IMPORTANT},shadow = true, scale = 2*scale}),id = 'round_UI_count'}
                                },
                            }
                        },
                    }
                },
            }
        },            
    }
    contents.hand =
        {n=G.UIT.R, config={align = "cm", id = 'hand_text_area', colour = darken(G.C.BLACK, 0.1), r = 0.1, emboss = 0.05, padding = 0.03}, nodes={
            {n=G.UIT.C, config={align = "cm"}, nodes={
              {n=G.UIT.R, config={align = "cm", minh = 1.1}, nodes={
                {n=G.UIT.O, config={id = 'hand_name', func = 'hand_text_UI_set',object = DynaText({string = {{ref_table = G.GAME.current_round.current_hand, ref_value = "handname_text"}}, colours = {G.C.UI.TEXT_LIGHT}, shadow = true, float = true, scale = scale*1.4})}},
                {n=G.UIT.O, config={id = 'hand_chip_total', func = 'hand_chip_total_UI_set',object = DynaText({string = {{ref_table = G.GAME.current_round.current_hand, ref_value = "chip_total_text"}}, colours = {G.C.UI.TEXT_LIGHT}, shadow = true, float = true, scale = scale*1.4})}},
                {n=G.UIT.T, config={ref_table = G.GAME.current_round.current_hand, ref_value='hand_level', scale = scale, colour = G.C.UI.TEXT_LIGHT, id = 'hand_level', shadow = true}}
              }},
              {n=G.UIT.R, config={align = "cm", minh = 1, padding = 0.1}, nodes={
                {n=G.UIT.C, config={align = "cr", minw = 2, minh =1, r = 0.1,colour = G.C.UI_CHIPS, id = 'hand_chip_area', emboss = 0.05}, nodes={
                    {n=G.UIT.O, config={func = 'flame_handler',no_role = true, id = 'flame_chips', object = Moveable(0,0,0,0), w = 0, h = 0}},
                    {n=G.UIT.O, config={id = 'hand_chips', func = 'hand_chip_UI_set',object = DynaText({string = {{ref_table = G.GAME.current_round.current_hand, ref_value = "chip_text"}}, colours = {G.C.UI.TEXT_LIGHT}, font = G.LANGUAGES['en-us'].font, shadow = true, float = true, scale = scale*2.3})}},
                    {n=G.UIT.B, config={w=0.1,h=0.1}},
                }},
                {n=G.UIT.C, config={align = "cm"}, nodes={
                  {n=G.UIT.T, config={text = "X", lang = G.LANGUAGES['en-us'], scale = scale*2, colour = G.C.UI_MULT, shadow = true}},
                }},
                {n=G.UIT.C, config={align = "cl", minw = 2, minh=1, r = 0.1,colour = G.C.UI_MULT, id = 'hand_mult_area', emboss = 0.05}, nodes={
                  {n=G.UIT.O, config={func = 'flame_handler',no_role = true, id = 'flame_mult', object = Moveable(0,0,0,0), w = 0, h = 0}},
                  {n=G.UIT.B, config={w=0.1,h=0.1}},
                  {n=G.UIT.O, config={id = 'hand_mult', func = 'hand_mult_UI_set',object = DynaText({string = {{ref_table = G.GAME.current_round.current_hand, ref_value = "mult_text"}}, colours = {G.C.UI.TEXT_LIGHT}, font = G.LANGUAGES['en-us'].font, shadow = true, float = true, scale = scale*2.3})}},
                }}
              }}
            }}
          }}
    contents.dollars_chips = {n=G.UIT.R, config={align = "cm",r=0.1, padding = 0,colour = G.C.DYN_UI.BOSS_MAIN, emboss = 0.05, id = 'row_dollars_chips'}, nodes={
      {n=G.UIT.C, config={align = "cm", padding = 0.1}, nodes={
        {n=G.UIT.C, config={align = "cm", minw = 1.3}, nodes={
          {n=G.UIT.R, config={align = "cm", padding = 0, maxw = 1.3}, nodes={
            {n=G.UIT.T, config={text = localize('k_round'), scale = 0.42, colour = G.C.UI.TEXT_LIGHT, shadow = true}}
          }},
          {n=G.UIT.R, config={align = "cm", padding = 0, maxw = 1.3}, nodes={
            {n=G.UIT.T, config={text =localize('k_lower_score'), scale = 0.42, colour = G.C.UI.TEXT_LIGHT, shadow = true}}
          }}
        }},
        {n=G.UIT.C, config={align = "cm", minw = 3.3, minh = 0.7, r = 0.1, colour = G.C.DYN_UI.BOSS_DARK}, nodes={
          {n=G.UIT.O, config={w=0.5,h=0.5 , object = stake_sprite, hover = true, can_collide = false}},
          {n=G.UIT.B, config={w=0.1,h=0.1}},
          {n=G.UIT.T, config={ref_table = G.GAME, ref_value = 'chips_text', lang = G.LANGUAGES['en-us'], scale = 0.85, colour = G.C.WHITE, id = 'chip_UI_count', func = 'chip_UI_set', shadow = true}}
        }}
      }}
    }}

    contents.button1 = {
        {
            n=G.UIT.C, config={align = "cm", r=0.1, colour = G.C.CLEAR, shadow = true, id = 'button_area', padding = 0.2}, nodes={
                {
                    n=G.UIT.R, config={id = 'run_info_button', align = "cm", minh = 1.2, minw = 1.5,padding = 0.05, r = 0.1, hover = true, colour = G.C.RED, button = "run_info", shadow = true}, nodes={
                        {
                            n=G.UIT.R, config={align = "cm", padding = 0, maxw = 1.4}, nodes={
                                {
                                    n=G.UIT.T, config={text = localize('b_run_info_1'), scale = 1.2*scale, colour = G.C.UI.TEXT_LIGHT, shadow = true}
                                }
                            }
                        },
                        {
                            n=G.UIT.R, config={align = "cm", padding = 0, maxw = 1.4}, nodes={
                                {
                                    n=G.UIT.T, config={text = localize('b_run_info_2'), scale = 1*scale, colour = G.C.UI.TEXT_LIGHT, shadow = true, focus_args = {button = G.F_GUIDE and 'guide' or 'back', orientation = 'bm'}, func = 'set_button_pip'}
                                }
                            }
                        }
                    }
                }
            },
        }
    }
    contents.button2 = {
        {
            n=G.UIT.R, config={align = "cm", minh = 1.2, minw = 1.5,padding = 0.05, r = 0.1, hover = true, colour = G.C.ORANGE, button = "options", shadow = true}, nodes={
                {
                    n=G.UIT.C, config={align = "cm", maxw = 1.4, focus_args = {button = 'start', orientation = 'bm'}, func = 'set_button_pip'}, nodes={
                        {
                            n=G.UIT.T, config={text = localize('b_options'), scale = scale, colour = G.C.UI.TEXT_LIGHT, shadow = true}
                        }
                    }
                },
            }
        }
    }

    local t = {
        {
            n=G.UIT.R, config={align = "cm", id = 'row_round'}, nodes=contents.round
        },
        {
            n=G.UIT.R, config={align = "cm", id = 'row_round'}, nodes={
                {
                    n=G.UIT.R, config={align = "cm", id = 'row_round'}, nodes={
                        {
                            n=G.UIT.C, config={align = "cm"}, nodes=contents.button1
                        },
                        {
                            n=G.UIT.C, config={align = "cm"}, nodes=contents.dols
                        }
                    },
                },
                {
                    n=G.UIT.R, config={align = "cm", id = 'row_round'}, nodes={
                        {
                            n=G.UIT.C, config={align = "cm"}, nodes=contents.button2
                        },
                        {
                            n=G.UIT.C, config={align = "cm", padding}, nodes=contents.ante
                        }
                    }
                }
            }
        }
    }
    return {n=G.UIT.ROOT, config = {align = "cm", padding = 0.03, colour = G.C.UI.TRANSPARENT_DARK}, nodes={
      {n=G.UIT.R, config = {align = "cm", padding= 0.05, colour = G.C.DYN_UI.MAIN, r=0.1}, nodes={
        {n=G.UIT.R, config={align = "cm", colour = G.C.DYN_UI.BOSS_DARK, r=0.1, minh = 30, padding = 0.08}, nodes={
          {n=G.UIT.R, config={align = "cm", minh = 0.3}, nodes={}},
          {n=G.UIT.R, config={align = "cm", id = 'row_blind', minw = 1, minh = 3.75}, nodes={
            {n=G.UIT.B, config={w=0, h=3.64, id = 'row_blind_bottom'}, nodes={}}
          }},
          contents.dollars_chips,
          contents.hand,
          {n=G.UIT.R, config={align = "cm", id = 'row_round'}, nodes=t},
        }}
      }}
    }}
end
end