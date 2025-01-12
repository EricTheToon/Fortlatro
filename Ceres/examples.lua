local example_perk = SMODS.Perk{
    key = 'example',
	atlas = 'perks',
    pos = {
        x = 0,
        y = 0,
    },
    config = {
        -- all current features, anything more complicated will have to be implemented by yourself for now
		jokers = {
            {
                key = 'j_joker', 
                amount = 5,
                edition = 'e_negative',
                sticker = 'cere_temporary',
                ignore_space = true,
            },
        },
		consumables = {
            {
                key = 'c_fool',
                amount = 2,
                edition = 'e_negative',
                ignore_space = true,
            },
        },		
        tags = {
            {
                key = 'tag_buffoon',
                amount = 1,
            },
        },
        dollars = 10,
        -- burn/shred card
		burn = true,
		shred = false,
		message = 'Example!',
		colour = G.C.GREEN,
	},
    loc_txt = {
        name = 'Example',
        text = {
            'On {C:green}exploit:',
            'create {C:attention}#1#{} {C:dark_edition}negative{}, {C:cere_temporary}temporary{} copies of {C:attention}Joker{},',
            'create {C:attention}#2#{} {C:dark_edition}negative{} copies of {C:attention}The Fool{},',
            'create a {C:attention}Buffoon Tag{},',
            'gain {C:money}$#3#{},',
            'then {C:red}burn{}',
        },
    },

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = {set = "Joker", key = "j_joker", specific_vars = {4}}
        info_queue[#info_queue+1] = G.P_CENTERS['c_fool']
        info_queue[#info_queue+1] = G.P_TAGS['tag_buffoon']
        info_queue[#info_queue+1] = {set = 'Other', key = 'cere_temporary'}
        return {
            vars = {
                card.ability.jokers[1].amount,
                card.ability.consumables[1].amount,
                card.ability.dollars,
            }
        }
    end,
}

local booster_one = Ceres.CONFIG.card_modifiers.perks.enabled and SMODS.Booster{
    key = "perk_normal_1",
    kind = "Perk",
    atlas = "booster_atlas",
    pos = {
        x = 0,
        y = 0
    },
    config = {
        extra = 3,
        choose = 1
    },
    cost = 4,
    weight = 0.96,
    discovered = false or Ceres.CONFIG.misc.discover_all,

    create_card = function(self, card)
        local card = create_card('Base', G.pack_cards, nil, nil, true, true, nil, 'cere')
        local perk = poll_perk()
        local edition = nil
        card:set_perk(perk)
        card:set_edition(nil, true, true)
        return card
    end,

    ease_background_colour = function(self)
        ease_colour(G.C.DYN_UI.MAIN, G.C.SECONDARY_SET.Spectral)
        ease_background_colour{new_colour = G.C.SECONDARY_SET.Spectral, special_colour = G.C.BLACK, contrast = 2}
    end,

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = {set = 'Other', key = 'perk_info'}
		return { vars = {card.config.center.config.choose, card.ability.extra} }
	end,

    group_key = "k_perk_pack"
}
