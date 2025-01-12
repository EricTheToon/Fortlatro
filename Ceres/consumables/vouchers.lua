local voucher_atlas = SMODS.Atlas{
    key = 'vouchers',
    path = 'vouchers.png',
    px = 71,
    py = 95,
    atlas_table = 'ASSET_ATLAS',
}

local reflection = Ceres.CONFIG.consumables.vouchers.enabled and SMODS.Voucher{
    key = 'reflection',
    atlas = 'vouchers',
    pos = {
        x = 0,
        y = 0,
    },
    config = {
        extra = 4
    },
    cost = 10,
    unlocked = true,
    discovered = false or Ceres.CONFIG.misc.discover_all.enabled,

    loc_vars = function(self, info_queue, card)
        return {vars = {self.config.extra}}
    end,

    redeem = function(self)
        G.GAME.negative_rate = self.config.extra
    end
}

local shattered_mirror = Ceres.CONFIG.consumables.vouchers.enabled and SMODS.Voucher{
    key = 'shattered_mirror',
    atlas = 'vouchers',
    pos = {
        x = 0,
        y = 1,
    },
    config = {
        extra = 8
    },
    cost = 10,
    unlocked = true,
    discovered = false or Ceres.CONFIG.misc.discover_all.enabled,
    requires = {
        'v_cere_reflection',
    },

    loc_vars = function(self, info_queue, card)
        return {vars = {self.config.extra}}
    end,

    redeem = function(self)
        G.GAME.negative_rate = self.config.extra
    end
}

-- for making negative rate increase work
if Ceres.CONFIG.consumables.vouchers.enabled then
    SMODS.Edition:take_ownership('negative', {
        get_weight = function(self)
            return (G.GAME.negative_rate or 1) * self.weight
        end,
    })
end

local glimmer = Ceres.CONFIG.consumables.vouchers.enabled and SMODS.Voucher{
    key = 'glimmer',
    atlas = 'vouchers',
    pos = {
        x = 1,
        y = 0,
    },
    config = {
        extra = 2
    },
    cost = 10,
    unlocked = true,
    discovered = false or Ceres.CONFIG.misc.discover_all.enabled,

    loc_vars = function(self, info_queue, card)
        return {vars = {self.config.extra}}
    end,

    redeem = function(self)
        G.GAME.cere_edition_rate = self.config.extra
    end
}

local iridescent = Ceres.CONFIG.consumables.vouchers.enabled and SMODS.Voucher{
    key = 'iridescent',
    atlas = 'vouchers',
    pos = {
        x = 1,
        y = 1,
    },
    config = {
        extra = 4
    },
    cost = 10,
    unlocked = true,
    discovered = false or Ceres.CONFIG.misc.discover_all.enabled,
    requires = {
        'v_cere_glimmer',
    },

    loc_vars = function(self, info_queue, card)
        return {vars = {self.config.extra}}
    end,

    redeem = function(self)
        G.GAME.cere_edition_rate = self.config.extra
    end
}

local supernatural = Ceres.CONFIG.consumables.vouchers.enabled and SMODS.Voucher{
    key = 'supernatural',
    atlas = 'vouchers',
    pos = {
        x = 2,
        y = 0,
    },
    config = {
        extra = 2
    },
    cost = 10,
    unlocked = true,
    discovered = false or Ceres.CONFIG.misc.discover_all.enabled,

    loc_vars = function(self, info_queue, card)
        return {vars = {}}
    end,

    redeem = function(self)
        G.GAME.spectral_rate = self.config.extra
    end
}

local ethereal = Ceres.CONFIG.consumables.vouchers.enabled and SMODS.Voucher{
    key = 'ethereal',
    atlas = 'vouchers',
    pos = {
        x = 2,
        y = 1,
    },
    config = {
        extra = 4
    },
    cost = 10,
    unlocked = true,
    discovered = false or Ceres.CONFIG.misc.discover_all.enabled,
    requires = {
        'v_cere_supernatural',
    },

    loc_vars = function(self, info_queue, card)
        return {vars = {self.config.extra/2}}
    end,

    redeem = function(self)
        G.GAME.spectral_rate = self.config.extra
    end
}

-- for changing ghost deck
if Ceres.CONFIG.consumables.vouchers.enabled then
    SMODS.Back:take_ownership('ghost', {
        loc_txt = {
            name = "Ghost Deck",
            text = {
                "Start run with the",
                "{C:spectral,T:v_cere_supernatural}Supernatural{} voucher",
                "and a {C:spectral,T:c_hex}Hex{} card",
            }
        },
        config = {
            vouchers = {
                'v_cere_supernatural',
            },
            consumables = {'c_hex'}
        },
    })
end

local overflow_norm = Ceres.CONFIG.consumables.vouchers.enabled and SMODS.Voucher{
    key = 'overflow_norm',
    atlas = 'vouchers',
    pos = {
        x = 3,
        y = 0,
    },
    cost = 10,
    unlocked = true,
    discovered = false or Ceres.CONFIG.misc.discover_all.enabled,

    redeem = function(self)
        if Ceres.COMPAT.cryptid then
            G.GAME.modifiers.cry_booster_packs = (G.GAME.modifiers.cry_booster_packs or 2) + 1
        else
            G.GAME.modifiers.cere_boosters = (G.GAME.modifiers.cere_boosters or 0) + 1
        end
    end
}

local overflow_plus = Ceres.CONFIG.consumables.vouchers.enabled and SMODS.Voucher{
    key = 'overflow_plus',
    atlas = 'vouchers',
    pos = {
        x = 3,
        y = 1,
    },
    cost = 10,
    unlocked = true,
    discovered = false or Ceres.CONFIG.misc.discover_all.enabled,
    requires = {
        'v_cere_overflow_norm',
    },

    redeem = function(self)
        if Ceres.COMPAT.cryptid then
            G.GAME.modifiers.cry_booster_packs = (G.GAME.modifiers.cry_booster_packs or 2) + 1
        else
            G.GAME.modifiers.cere_boosters = (G.GAME.modifiers.cere_boosters or 0) + 1
        end
    end
}