local seal_atlas = SMODS.Atlas {
    key = "seal_atlas",
    path = "seals.png",
    px = 71,
    py = 95
}

local green_seal = Ceres.CONFIG.card_modifiers.seals.enabled and SMODS.Seal {
    key = "green_seal",
    name = "Green Seal",
    badge_colour = G.C.GREEN,
	config = {
        odds = 2
    },
    loc_vars = function(self, info_queue)
        return { vars = {G.GAME.probabilities.normal, self.config.odds} }
    end,
    atlas = "seal_atlas",
    pos = {
        x = 0,
        y = 0
    },
}

local draw_card_ref = draw_card
function draw_card(from, to, percent, dir, sort, card, delay, mute, stay_flipped, vol, discarded_only)
    if from == G.play and to == G.discard and card and card.seal == 'cere_green_seal' and pseudorandom('green_seal') < G.GAME.probabilities.normal/green_seal.config.odds then
        to = G.hand
        dir = 'up'
        sort = true
    end
    draw_card_ref(from, to, percent, dir, sort, card, delay, mute, stay_flipped, vol, discarded_only)
end