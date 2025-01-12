SMODS.Atlas({
    key = 'curses',
    path = 'curses.png',
    px = 71,
    py = 95
})

SMODS.Seal({
    key = 'corroded',
    atlas = 'curses',
    pos = {x = 0, y = 0},
    badge_colour = HEX('dc2e33'),
    config = {extra = {base = 3, gain = 1}},
    in_pool = function(self)
        return false
    end,
    loc_vars = function(self, info_queue, card)
        if card and Ortalab.config.artist_credits then info_queue[#info_queue+1] = {generate_ui = ortalab_artist_tooltip, key = 'gappie'} end
		return {vars = {card.ability.seal.extra.base, card.ability.seal.extra.gain}}
    end,
    calculate = function(self, card, context)
        if context.discard then
            card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('ortalab_corroded'), colour = G.C.RED})
            card.ability.seal.extra.base = card.ability.seal.extra.base + card.ability.seal.extra.gain
            card.corroded_discard = true
        end
        if context.cardarea and context.cardarea == G.play and not context.repetition and not context.individual then
            return {
                message = '-'..localize('$')..card.ability.seal.extra.base,
                p_dollars = -card.ability.seal.extra.base,
                colour = G.C.RED,
            }
        end
    end
})

SMODS.Seal({
    key = 'possessed',
    atlas = 'curses',
    pos = {x = 1, y = 0},
    badge_colour = HEX('82b4f4')
})

SMODS.Seal({
    key = 'restrained',
    atlas = 'curses',
    pos = {x = 2, y = 0},
    badge_colour = HEX('d78532')
})

SMODS.Seal({
    key = 'infected',
    atlas = 'curses',
    pos = {x = 3, y = 0},
    badge_colour = HEX('a1ba56')
})