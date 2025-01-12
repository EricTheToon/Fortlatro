local enhancement_atlas = SMODS.Atlas{
    key = 'enhancement_atlas',
    path = 'enhancements.png',
    px = 71,
    py = 95,
    atlas_table = 'ASSET_ATLAS',
}

local illusion = false and Ceres.CONFIG.card_modifiers.enhancements.enabled and SMODS.Enhancement{
    key = 'illusion',
    pos = {
        x = 0,
        y = 0,
    },
    atlas = 'enhancement_atlas',
    config = {
        extra = 1.5,
        chip_odds = 2,
    },

    loc_vars = function(self, info_queue)
        return {vars = {G.GAME.probabilities.normal, self.config.extra,  self.config.chip_odds,  self.config.retrigger_odds}}
    end,

    calculate = function(self, card, context, effect)
        if context.cardarea == G.play and not context.repetition_only then
            if pseudorandom('illu') < (G.GAME.probabilities.normal / self.config.chip_odds) then
                effect.cere_x_chips = (effect.cere_x_chips or 1) * self.config.extra
            end
        end
    end
}

local cobalt = Ceres.CONFIG.card_modifiers.enhancements.enabled and SMODS.Enhancement{
    key = 'cobalt',
    pos = {
        x = 1,
        y = 0,
    },
    atlas = 'enhancement_atlas',
    config = {
        extra = 2,
    },

    loc_vars = function(self, info_queue)
        return {vars = {self.config.extra}}
    end,

    calculate = function(self, card, context, effect)
        if context.cardarea == G.hand and not context.repetition_only then
            effect.cere_x_chips = (effect.cere_x_chips or 1) * self.config.extra
        end
    end
}
