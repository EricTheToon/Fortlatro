SMODS.Shader({key = 'greyscale', path = "greyscale.fs"})
SMODS.Shader({key = 'fluorescent', path = "fluorescent.fs"})
SMODS.Shader({key = 'anaglyphic', path = "anaglyphic.fs"})
SMODS.Shader({key = 'overexposed', path = "overexposed.fs"})

SMODS.Edition({
    key = "anaglyphic",
    discovered = false,
    unlocked = true,
    shader = 'anaglyphic',
    config = { chips = 20, mult = 6 },
    in_shop = true,
    weight = 20,
    extra_cost = 4,
    apply_to_float = true,
    loc_vars = function(self, info_queue, card)
        if Ortalab.config.artist_credits and (card or Ortalab.config.full_credits) then info_queue[#info_queue+1] = {generate_ui = ortalab_artist_tooltip, key = 'eremel', title = 'Shader'} end
        return { vars = {self.config.chips, self.config.mult}}
    end,
})

SMODS.Edition({
    key = "fluorescent",
    discovered = false,
    unlocked = true,
    shader = 'fluorescent',
    config = { p_dollars = 3 },
    in_shop = true,
    weight = 12,
    extra_cost = 4,
    apply_to_float = true,
    loc_vars = function(self, info_queue, card)
        if Ortalab.config.artist_credits and (card or Ortalab.config.full_credits) then info_queue[#info_queue+1] = {generate_ui = ortalab_artist_tooltip, key = 'eremel', title = 'Shader'} end
        return { vars = {self.config.p_dollars}}
    end
})

SMODS.Edition({
    key = "greyscale",
    shader = "greyscale",
    discovered = false,
    unlocked = true,
    config = {swap = true},
    in_shop = true,
    weight = 8,
    extra_cost = 6,
    badge_colour = HEX("858585"),
    apply_to_float = true,
    loc_vars = function(self, info_queue, card)
        if Ortalab.config.artist_credits and (card or Ortalab.config.full_credits) then info_queue[#info_queue+1] = {generate_ui = ortalab_artist_tooltip, key = 'eremel', title = 'Shader'} end
        return { vars = { self.config.chips, self.config.mult, self.config.x_mult } }
    end
})

-- Awaiting retrigger API
SMODS.Edition({
    key = "overexposed",
    discovered = false,
    unlocked = true,
    shader = 'overexposed',
    config = { retriggers = 1 },
    in_shop = true,
    weight = 3,
    extra_cost = 4,
    apply_to_float = true,
    loc_vars = function(self, info_queue, card)
        if Ortalab.config.artist_credits and (card or Ortalab.config.full_credits) then info_queue[#info_queue+1] = {generate_ui = ortalab_artist_tooltip, key = 'eremel', title = 'Shader'} end
        return { vars = { self.config.retriggers } }
    end
})