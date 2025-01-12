-- Boosters

SMODS.Atlas({
    key = 'zodiac_booster',
    path = 'zodiac_boosters.png',
    px = '71',
    py = '95'
})

Ortalab.zodiacs = {positive = {
    c_ortalab_zod_aries = true,
    c_ortalab_zod_gemini = true,
    c_ortalab_zod_leo = true,
    c_ortalab_zod_libra = true,
    c_ortalab_zod_sag = true,
    c_ortalab_zod_aquarius = true
},
negative = {
    c_ortalab_zod_taurus = true,
    c_ortalab_zod_cancer = true,
    c_ortalab_zod_virgo = true,
    c_ortalab_zod_scorpio = true,
    c_ortalab_zod_capr = true,
    c_ortalab_zod_pisces = true
}}

local hand_types_typing = {
    positive = {
        c_ortalab_zod_aries = 'Four of a Kind',
        c_ortalab_zod_gemini = 'Pair',
        c_ortalab_zod_leo = 'Flush Five',
        c_ortalab_zod_libra = 'Full House',
        c_ortalab_zod_sag = 'Flush',
        c_ortalab_zod_aquarius = 'Two Pair'
    },
    negative = {
        c_ortalab_zod_taurus = 'Three of a Kind',
        c_ortalab_zod_cancer = 'Flush House',
        c_ortalab_zod_virgo = 'Five of a Kind',
        c_ortalab_zod_scorpio = 'High Card',
        c_ortalab_zod_capr = 'Straight',
        c_ortalab_zod_pisces = 'Straight Flush'
    }
}

function zodiac_from_hand(hand_type)
    for key, hand in pairs(hand_types_typing.positive) do
        if hand == hand_type then return key end
    end
    for key, hand in pairs(hand_types_typing.negative) do
        if hand == hand_type then return key end
    end
end

local small_boosters = {keys = {'small_zodiac_1', 'small_zodiac_2', 'small_zodiac_3', 'small_zodiac_4'}, info = {
    atlas = 'zodiac_booster',
    config = {choose = 1, extra = 2},
    loc_vars = function(self, info_queue, card)
        if Ortalab.config.artist_credits then info_queue[#info_queue+1] = {generate_ui = ortalab_artist_tooltip, key = 'gappie'} end
        return {vars = {(card and card.ability.choose or self.config.choose) + (G.GAME and G.GAME.Ortalab_zodiac_voucher and G.GAME.Ortalab_zodiac_voucher or 0), card and card.ability.extra or self.config.extra}}
    end,
    ease_background_colour = function(self)
        ease_colour(G.C.DYN_UI.MAIN, G.C.SET.Zodiac)
        ease_background_colour{new_colour = G.C.SET.Zodiac, special_colour = G.C.BLACK, contrast = 2}
    end,
    draw_hand = false,
    cost = 4,
    weight = 0.5,
    particles = function(self)
        G.booster_pack_sparkles = Particles(1, 1, 0,0, {
            timer = 0.015,
            scale = 0.2,
            initialize = true,
            lifespan = 1,
            speed = 1.1,
            padding = -1,
            attach = G.ROOM_ATTACH,
            colours = {G.ARGS.LOC_COLOURS.zodiac, lighten(G.ARGS.LOC_COLOURS.zodiac, 0.4), lighten(G.ARGS.LOC_COLOURS.zodiac, 0.2), darken(G.ARGS.LOC_COLOURS.zodiac, 0.2)},
            fill = true
        })
        G.booster_pack_sparkles.fade_alpha = 1
        G.booster_pack_sparkles:fade(1, 0)
    end,
    },
    create = {
        {create_card = function(self, card, i)
            local most_used = nil
            if G.GAME.used_vouchers.v_ortalab_horoscope and i == 1 then
                local new_most_used, value = nil, 0
                for zodiac_key, hand_type in pairs(hand_types_typing.positive) do
                    if G.GAME.hands[hand_type].visible and G.GAME.hands[hand_type].played > value then
                        new_most_used = zodiac_key
                        value = G.GAME.hands[hand_type].played
                    end
                end
                most_used = new_most_used
            end
            return create_card("Zodiac", G.pack_cards, nil, nil, true,  true, most_used or pseudorandom_element(zodiac_pool('positive'), pseudoseed('zodiac_positive_pack')), "zodpack")
        end,
        group_key = 'ortalab_zodiac_pack_plus',},
        {create_card = function(self, card, i)
            local most_used = nil
            if G.GAME.used_vouchers.v_ortalab_horoscope and i == 1 then
                local new_most_used, value = nil, 0
                for zodiac_key, hand_type in pairs(hand_types_typing.negative) do
                    if G.GAME.hands[hand_type].visible and G.GAME.hands[hand_type].played > value then
                        new_most_used = zodiac_key
                        value = G.GAME.hands[hand_type].played
                    end
                end
                most_used = new_most_used
            end
            return create_card("Zodiac", G.pack_cards, nil, nil, true,  true, most_used or pseudorandom_element(zodiac_pool('negative'), pseudoseed('zodiac_negative_pack')), "zodpack")
        end,
        group_key = 'ortalab_zodiac_pack_minus',}
    }
}

for i, key in ipairs(small_boosters.keys) do
    local booster_args = {}
    for k,v in pairs(small_boosters.info) do
        booster_args[k] = v
    end
    local other_values = small_boosters.create[(i-1)%2 + 1]
    for k,v in pairs(other_values) do
        booster_args[k] = v
    end
    booster_args.key = key
    booster_args.pos = { x = i - 1, y = 0 }
    SMODS.Booster(booster_args)
end

local mid_boosters = {keys = {'mid_zodiac_1', 'mid_zodiac_2'}, info = {
    atlas = 'zodiac_booster',
    config = {choose = 1, extra = 4},
    loc_vars = function(self, info_queue, card)
        if card and Ortalab.config.artist_credits then info_queue[#info_queue+1] = {generate_ui = ortalab_artist_tooltip, key = 'gappie'} end
        return {vars = {(card and card.ability.choose or self.config.choose) + (G.GAME and G.GAME.Ortalab_zodiac_voucher and G.GAME.Ortalab_zodiac_voucher or 0), card and card.ability.extra or self.config.extra}}
    end,
    create_card = function(self, card, i)
        local most_used = nil
        if G.GAME.used_vouchers.v_ortalab_horoscope and i == 1 then
            local new_most_used, value = nil, 0
            for zodiac_key, hand_type in pairs(hand_types_typing.positive) do
                if G.GAME.hands[hand_type].visible and G.GAME.hands[hand_type].played > value then
                    new_most_used = zodiac_key
                    value = G.GAME.hands[hand_type].played
                end
            end
            for zodiac_key, hand_type in pairs(hand_types_typing.negative) do
                if G.GAME.hands[hand_type].visible and G.GAME.hands[hand_type].played > value then
                    new_most_used = zodiac_key
                    value = G.GAME.hands[hand_type].played
                end
            end
            most_used = new_most_used
        end
        return create_card("Zodiac", G.pack_cards, nil, nil, true,  true, most_used or pseudorandom_element(zodiac_pool(), pseudoseed('zodiac_pack')), "zodpack")
    end,
    ease_background_colour = function(self)
        ease_colour(G.C.DYN_UI.MAIN, G.C.SET.Zodiac)
        ease_background_colour{new_colour = G.C.SET.Zodiac, special_colour = G.C.BLACK, contrast = 2}
    end,
    group_key = 'ortalab_zodiac_pack_2',
    draw_hand = false,
    cost = 6,
    weight = 0.4,
    particles = function(self)
        G.booster_pack_sparkles = Particles(1, 1, 0,0, {
            timer = 0.015,
            scale = 0.2,
            initialize = true,
            lifespan = 1,
            speed = 1.1,
            padding = -1,
            attach = G.ROOM_ATTACH,
            colours = {G.ARGS.LOC_COLOURS.zodiac, lighten(G.ARGS.LOC_COLOURS.zodiac, 0.4), lighten(G.ARGS.LOC_COLOURS.zodiac, 0.2), darken(G.ARGS.LOC_COLOURS.zodiac, 0.2)},
            fill = true
        })
        G.booster_pack_sparkles.fade_alpha = 1
        G.booster_pack_sparkles:fade(1, 0)
    end,
}}

for i, key in ipairs(mid_boosters.keys) do
    local booster_args = {}
    for k,v in pairs(mid_boosters.info) do
        booster_args[k] = v
    end
    booster_args.key = key
    booster_args.pos = { x = i - 1, y = 1 }
    SMODS.Booster(booster_args)
end

local large_boosters = {keys = {'big_zodiac_1', 'big_zodiac_2'}, info = {
    atlas = 'zodiac_booster',
    config = {choose = 2, extra = 4},
    loc_vars = function(self, info_queue, card)
        if Ortalab.config.artist_credits and card then info_queue[#info_queue+1] = {generate_ui = ortalab_artist_tooltip, key = 'gappie'} end
        return {vars = {(card and card.ability.choose or self.config.choose) + (G.GAME and G.GAME.Ortalab_zodiac_voucher and G.GAME.Ortalab_zodiac_voucher or 0), card and card.ability.extra or self.config.extra}}
    end,
    create_card = function(self, card, i)
        local most_used = nil
        if G.GAME.used_vouchers.v_ortalab_horoscope and i == 1 then
            local new_most_used, value = nil, 0
            for zodiac_key, hand_type in pairs(hand_types_typing.positive) do
                if G.GAME.hands[hand_type].visible and G.GAME.hands[hand_type].played > value then
                    new_most_used = zodiac_key
                    value = G.GAME.hands[hand_type].played
                end
            end
            for zodiac_key, hand_type in pairs(hand_types_typing.negative) do
                if G.GAME.hands[hand_type].visible and G.GAME.hands[hand_type].played > value then
                    new_most_used = zodiac_key
                    value = G.GAME.hands[hand_type].played
                end
            end
            most_used = new_most_used
        end
        return create_card("Zodiac", G.pack_cards, nil, nil, true,  true, most_used or pseudorandom_element(zodiac_pool(), pseudoseed('zodiac_pack')), "zodpack")
    end,
    ease_background_colour = function(self)
        ease_colour(G.C.DYN_UI.MAIN, G.C.SET.Zodiac)
        ease_background_colour{new_colour = G.C.SET.Zodiac, special_colour = G.C.BLACK, contrast = 2}
    end,
    group_key = 'ortalab_zodiac_pack_3',
    draw_hand = false,
    cost = 8,
    weight = 0.2,
    particles = function(self)
        G.booster_pack_sparkles = Particles(1, 1, 0,0, {
            timer = 0.015,
            scale = 0.2,
            initialize = true,
            lifespan = 1,
            speed = 1.1,
            padding = -1,
            attach = G.ROOM_ATTACH,
            colours = {G.ARGS.LOC_COLOURS.zodiac, lighten(G.ARGS.LOC_COLOURS.zodiac, 0.4), lighten(G.ARGS.LOC_COLOURS.zodiac, 0.2), darken(G.ARGS.LOC_COLOURS.zodiac, 0.2)},
            fill = true
        })
        G.booster_pack_sparkles.fade_alpha = 1
        G.booster_pack_sparkles:fade(1, 0)
    end,
}}

for i, key in ipairs(large_boosters.keys) do
    local booster_args = {}
    for k,v in pairs(large_boosters.info) do
        booster_args[k] = v
    end
    booster_args.key = key
    booster_args.pos = { x = i + 1, y = 1 }
    SMODS.Booster(booster_args)
end

function zodiac_pool(_type)
    --create the pool
    G.ARGS.TEMP_POOL = EMPTY(G.ARGS.TEMP_POOL)
    local _pool, _starting_pool, _pool_key, _pool_size = G.ARGS.TEMP_POOL, nil, '', 0

     _starting_pool, _pool_key = G.P_CENTER_POOLS['Zodiac'], 'zodiac_pool'
    

    --cull the pool
    for k, v in ipairs(_starting_pool) do
        local add = nil

        -- Positive/Negative type restriction
        if _type then
            if Ortalab.zodiacs[_type][v.key] then
                add = true
            end
        else
            add = true
        end

        -- Remove zodiacs that have already been used and are awaiting activation
        if G.current_zodiacs then
            for _, zodiac in ipairs(G.current_zodiacs) do
                if zodiac.key == v.config.extra.zodiac then add = false end
            end
        end

        -- Remove cards that are already present
        if add and G.GAME.used_jokers[v.key] and not(next(SMODS.find_card('j_showman'))) then
            add = nil
        end

        if add and not G.GAME.banned_keys[v.key] then 
            _pool[#_pool + 1] = v.key
            _pool_size = _pool_size + 1
        end
    end

    --if pool is empty
    if _pool_size == 0 then
        _pool = EMPTY(G.ARGS.TEMP_POOL)
        _pool[#_pool + 1] = _type and _type == 'positive' and 'c_ortalab_zod_gemini' or "c_ortalab_zod_scorpio"
    end

    return _pool, _pool_key..G.GAME.round_resets.ante
end