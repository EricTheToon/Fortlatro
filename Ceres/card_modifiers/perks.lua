local perk_atlas = SMODS.Atlas{
	key = 'perks',
	path = 'perks.png',
	px = 71,
	py = 95,
	atlas_table = 'ASSET_ATLAS',
}

local prototype = Ceres.CONFIG.card_modifiers.perks.enabled and SMODS.Perk{
    key = 'prototype',
	atlas = 'perks',
    pos = {
        x = 2,
        y = 1,
    },
    config = {
        jokers = {
            {
                key = 'j_blueprint',
                sticker = 'cere_temporary',
                ignore_space = true,
            },
        },
        burn = true,
        message = 'Blueprint!',
        colour = G.C.SECONDARY_SET.Spectral,
	},

    loc_vars = function(self, info_queue)
        info_queue[#info_queue+1] = {set = 'Other', key = 'cere_temporary'}
        info_queue[#info_queue+1] = G.P_CENTERS['j_blueprint']
    end,
}

local dirty_napkin = Ceres.CONFIG.card_modifiers.perks.enabled and SMODS.Perk{
    key = 'dirty_napkin',
	atlas = 'perks',
    pos = {
        x = 1,
        y = 0,
    },
    config = {
        jokers = {
            {
                key = 'j_brainstorm',
                sticker = 'cere_temporary',
                ignore_space = true,
            },
        },
        burn = true,
        message = 'Brainstorm!',
        colour = G.C.RED,
	},

    loc_vars = function(self, info_queue)
        info_queue[#info_queue+1] = {set = 'Other', key = 'cere_temporary'}
        info_queue[#info_queue+1] = G.P_CENTERS['j_brainstorm']
    end,
}

local reward_card = Ceres.CONFIG.card_modifiers.perks.enabled and SMODS.Perk{
	key = 'reward_card',
	atlas = 'perks',
	pos = {
		x = 2,
		y = 0,
	},
	config = {
        tags = {
            {
                key = 'tag_coupon',
            },
        },
        burn = true,
		message = 'Tag!',
		colour = G.C.GREEN,
	},

	loc_vars = function(self, info_queue)
        info_queue[#info_queue+1] = G.P_TAGS['tag_coupon']
    end,
}

local business_card = Ceres.CONFIG.card_modifiers.perks.enabled and SMODS.Perk{
    key = 'business_card',
	atlas = 'perks',
    pos = {
        x = 3,
        y = 0,
    },
	config = {
        tags = {
            {
                key = 'tag_uncommon',
            },
        },
        burn = true,
		message = 'Tag!',
		colour = G.C.GREEN,
	},

    loc_vars = function(self, info_queue)
        info_queue[#info_queue+1] = G.P_TAGS['tag_uncommon']
    end,
}

local plus_two = Ceres.CONFIG.card_modifiers.perks.enabled and SMODS.Perk{
    key = 'plus_two',
	atlas = 'perks',
    pos = {
        x = 0,
        y = 1,
    },
	config = {
        hand_size = 2,
        burn = true,
        message = '+2!',
        colour = G.C.RED,
	},

    loc_vars = function(self, info_queue, card)
		return {
			vars = {
				card.ability.hand_size,
			},
		}
    end,
}