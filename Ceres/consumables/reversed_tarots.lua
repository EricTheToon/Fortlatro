local reversed_tarot_atlas = SMODS.Atlas{
    key = 'reversed_tarot',
    path = 'reversed_tarots.png',
    px = 71,
    py = 95,
    atlas_table = 'ASSET_ATLAS',
}

local reversed_tarot_enabled = Ceres.CONFIG.consumables.enabled and Ceres.CONFIG.consumables.reversed_tarot.enabled

local reversed_tarots = reversed_tarot_enabled and SMODS.ConsumableType{
    key = 'cere_reversed_tarot',
    primary_colour = Ceres.C.reversed_tarot,
    secondary_colour = Ceres.C.reversed_tarot,
    loc_txt = {
        name = 'Reversed Tarot',
        collection = 'Reversed Tarots',
        undiscovered = {
            name = 'Not Discovered',
            text = {
                'Purchase or use',
                'this card in an',
                'unseeded run to',
                'learn what it does',
            },
        },
    },
    collection_rows = { 5, 6 },
}

local undiscoverd_atlas = SMODS.UndiscoveredSprite{
    atlas = 'reversed_tarot',
    key = 'cere_reversed_tarot',
    pos = {
        x = 6,
        y = 2,
    },
}

local reversed_lovers = reversed_tarot_enabled and SMODS.Consumable{
    key = "reversed_lovers",
    set = "cere_reversed_tarot",
    config = {
        max_highlighted = 1,
        suit_conv = 'cere_Nothings'
    },
    pos = {
        x = 6,
        y = 0,
    },
    cost = 7,
    atlas = "reversed_tarot",
    unlocked = true,
    discovered = false or Ceres.CONFIG.misc.discover_all.enabled,

    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.max_highlighted}}
    end,
}

local reversed_wheel_of_fortune = reversed_tarot_enabled and SMODS.Consumable{
    key = "reversed_wheel_of_fortune",
    set = "cere_reversed_tarot",
    config = {
        extra = 4,
    },
    pos = {
        x = 0,
        y = 1,
    },
    cost = 3,
    atlas = "reversed_tarot",
    unlocked = true,
    discovered = false or Ceres.CONFIG.misc.discover_all.enabled,

    loc_vars = function(self, info_queue, card)
        return {vars = {G.GAME.probabilities.normal or 1, card.ability.extra}}
    end,

    can_use = function(self, card)
        if G.hand and #G.hand.cards > 0 then
            for _, _card in pairs(G.hand.cards) do
                if not card.edition then return true end
            end
        end
        return false
    end,

    use = function(self, card, area, copier)
        if pseudorandom('reversed_wheel_of_fortune') < G.GAME.probabilities.normal/card.ability.extra then 
            G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
                local temp_pool = {}
                for _, _card in pairs(G.hand.cards) do
                    if not _card.edition then
                        temp_pool[#temp_pool+1] = _card
                    end
                end
                local eligible_card = pseudorandom_element(temp_pool, pseudoseed('reversed_wheel_of_fortune'))
                local edition = poll_edition('reversed_wheel_of_fortune', nil, true, true)
                eligible_card:set_edition(edition, true)
                check_for_unlock({type = 'have_edition'})
                card:juice_up(0.3, 0.5)
            return true end }))
        else
            G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
                attention_text({
                    text = localize('k_nope_ex'),
                    scale = 1.3, 
                    hold = 1.4,
                    major = card,
                    backdrop_colour = G.C.SECONDARY_SET.Tarot,
                    align = (G.STATE == G.STATES.TAROT_PACK or G.STATE == G.STATES.SPECTRAL_PACK or G.STATE == G.STATES.SMODS_BOOSTER_OPENED) and 'tm' or 'cm',
                    offset = {x = 0, y = (G.STATE == G.STATES.TAROT_PACK or G.STATE == G.STATES.SPECTRAL_PACK or G.STATE == G.STATES.SMODS_BOOSTER_OPENED) and -0.2 or 0},
                    silent = true
                    })
                    G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.06*G.SETTINGS.GAMESPEED, blockable = false, blocking = false, func = function()
                        play_sound('tarot2', 0.76, 0.4);return true end}))
                    play_sound('tarot2', 1, 0.4)
                    card:juice_up(0.3, 0.5)
            return true end }))
        end
        delay(0.6)
    end,
}

local reversed_strength = reversed_tarot_enabled and SMODS.Consumable{
    key = "reversed_strength",
    set = "cere_reversed_tarot",
    config = {
        max_highlighted = 2,
    },
    pos = {
        x = 1,
        y = 1,
    },
    cost = 3,
    atlas = "reversed_tarot",
    unlocked = true,
    discovered = false or Ceres.CONFIG.misc.discover_all.enabled,

    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.max_highlighted}}
    end,

    use = function(self, card, area, copier)
        G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
            play_sound('tarot1')
            card:juice_up(0.3, 0.5)
            return true end }))
        for i=1, #G.hand.highlighted do
            local percent = 1.15 - (i-0.999)/(#G.hand.highlighted-0.998)*0.3
            G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.15,func = function() G.hand.highlighted[i]:flip();play_sound('card1', percent);G.hand.highlighted[i]:juice_up(0.3, 0.3);return true end }))
        end
        delay(0.2)
        for i=1, #G.hand.highlighted do
            G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.1,func = function()
                local card = G.hand.highlighted[i]
                local suit_prefix = string.sub(card.base.suit, 1, 1)..'_'
                local rank_suffix = card.base.id == 2 and 14 or math.max(card.base.id-1, 2)
                if rank_suffix < 10 then rank_suffix = tostring(rank_suffix)
                elseif rank_suffix == 10 then rank_suffix = 'T'
                elseif rank_suffix == 11 then rank_suffix = 'J'
                elseif rank_suffix == 12 then rank_suffix = 'Q'
                elseif rank_suffix == 13 then rank_suffix = 'K'
                elseif rank_suffix == 14 then rank_suffix = 'A'
                end
                card:set_base(G.P_CARDS[suit_prefix..rank_suffix])
            return true end }))
        end
        for i=1, #G.hand.highlighted do
            local percent = 0.85 + (i-0.999)/(#G.hand.highlighted-0.998)*0.3
            G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.15,func = function() G.hand.highlighted[i]:flip();play_sound('tarot2', percent, 0.6);G.hand.highlighted[i]:juice_up(0.3, 0.3);return true end }))
        end
        G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.2,func = function() G.hand:unhighlight_all(); return true end }))
        delay(0.5)
    end,
}