G.FUNCS.cere_save_config = function(e)
    Ceres.FUNCS.save_config(Ceres)
end

G.FUNCS.cere_change_page = function(e)
	local page_config, back = Ceres.PAGE_FUNCS[e.config.ref_page]()
	local option_box = G.OVERLAY_MENU:get_UIE_by_ID('tab_contents')
	option_box.config.object:remove()
	option_box.config.object = UIBox{
		definition = {
			n = G.UIT.ROOT,
			config = {
				emboss = 0.05,
				r = 0.1,
				minh = 8,
				minw = 7.3,
				align = 'cm',
				padding = 0.2,
				colour = G.C.BLACK,
			},
			nodes = Ceres.FUNCS.create_buttons(page_config, back, 'cere_save_config'),
		},
		config = {
			offset = {
				x = 0,
				y = 0,
			},
			parent = option_box,
		}
	}
	option_box.UIBox:recalculate()
end

Ceres.PAGE_FUNCS = {}

Ceres.PAGE_FUNCS.main = function()
	local ref_table = Ceres.CONFIG
	local _buttons = {
    	{label = 'Jokers', toggle_ref = ref_table.jokers, button_ref = 'cere_change_page', ref_page = 'jokers_rarities'},
    	{label = 'Consumables', toggle_ref = ref_table.consumables, button_ref = 'cere_change_page', ref_page = 'consumables'},
    	{label = 'Card Modifiers', toggle_ref = ref_table.card_modifiers, button_ref = 'cere_change_page', ref_page = 'card_modifiers'},
    	{label = 'Run Modifiers', toggle_ref = ref_table.run_modifiers, button_ref = 'cere_change_page', ref_page = 'run_modifiers'},
		{label = 'Miscellaneous', button_ref = 'cere_change_page', ref_page = 'misc', remove_enable = true,},
  	}
	return _buttons, false
end

Ceres.PAGE_FUNCS.jokers_rarities = function()
	local ref_table = Ceres.CONFIG.jokers
	local _buttons = {
		{label = 'Common Jokers', toggle_ref = ref_table.rarities.common, remove_enable = true,},
		{label = 'Uncommon Jokers', toggle_ref = ref_table.rarities.uncommon, remove_enable = true,},
		{label = 'Rare Jokers', toggle_ref = ref_table.rarities.rare, remove_enable = true,},
		{label = 'Legendary Jokers', toggle_ref = ref_table.rarities.legendary, remove_enable = true,},
		{label = 'Divine Jokers', toggle_ref = ref_table.rarities.divine, remove_enable = true,},

	}
	return _buttons, 'main'
end

Ceres.PAGE_FUNCS.card_modifiers = function()
	local ref_table = Ceres.CONFIG.card_modifiers
	local _buttons = {
		{label = 'Seals', toggle_ref = ref_table.seals, remove_enable = true,},
		--{label = 'Enhancements', toggle_ref = ref_table.enhancements, remove_enable = true,},
		{label = 'Editions', toggle_ref = ref_table.editions, remove_enable = true,},
		{label = 'Perks', toggle_ref = ref_table.perks, remove_enable = true,} or nil,
	}
	return _buttons, 'main'
end

Ceres.PAGE_FUNCS.consumables = function()
	local ref_table = Ceres.CONFIG.consumables
	local _buttons = {
		{label = 'Vouchers', toggle_ref = ref_table.vouchers, remove_enable = true,},
	}
	return _buttons, 'main'
end

Ceres.PAGE_FUNCS.run_modifiers = function()
	local ref_table = Ceres.CONFIG.run_modifiers
	local _buttons = {
		{label = 'Stakes', toggle_ref = ref_table.stakes, remove_enable = true,},
		{label = 'Blinds', toggle_ref = ref_table.blinds, remove_enable = true,},
		{label = 'Decks', toggle_ref = ref_table.decks, remove_enable = true,},
	}
	return _buttons, 'main'
end

Ceres.PAGE_FUNCS.misc = function()
	local ref_table = Ceres.CONFIG.misc
	local _buttons = {
		{label = 'Unlock All', toggle_ref = ref_table.unlock_all, remove_enable = true,},
		{label = 'Discover All', toggle_ref = ref_table.discover_all, remove_enable = true,},
		{label = 'Useless Jokers', toggle_ref = ref_table.useless_jokers, remove_enable = true,},
	}
	return _buttons, 'main'
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