SMODS.Atlas({
    key = 'mythos_cards',
    path = 'mythos.png',
    px = '71',
    py = '95'
})

SMODS.UndiscoveredSprite({
    key = "Mythos",
    atlas = "zodiac_cards",
    pos = { x = 0, y = 3 },
    no_overlay = true
})

G.ARGS.LOC_COLOURS['Mythos'] = HEX("704f72")

SMODS.ConsumableType({
    key = "Mythos",
    primary_colour = HEX("704f72"),
    secondary_colour = HEX("704f72"),
    loc_txt = {
        name = "Mythos Card",
        collection = "Mythos Cards",
        undiscovered = {
            name = 'Unknown Mythos Card',
            text = {
                'Find this card in an unseeded',
                'run to find out what it does'
            }
        }
    },
    collection_rows = {6, 6},
    shop_rate = 1,
    default = 'c_ortalab_zod_aries'
})

SMODS.Consumable({
    key = 'mythos_1',
    set = 'Mythos',
    atlas = 'mythos_cards',
    pos = {x=0, y=0},
    discovered = true,
    config = {extra = {}},
    loc_vars = function(self, info_queue, card)
        if Ortalab.config.artist_credits then info_queue[#info_queue+1] = {generate_ui = ortalab_artist_tooltip, key = 'parchment'} end
    end,
    can_use = function(self, card)
        return true
    end,
    use = function(self, card, area, copier)
        sendDebugMessage("Not yet implemented")
    end
})


SMODS.Consumable({
    key = 'mythos_2',
    set = 'Mythos',
    atlas = 'mythos_cards',
    pos = {x=1, y=0},
    discovered = true,
    config = {extra = {}},
    loc_vars = function(self, info_queue, card)
        if Ortalab.config.artist_credits then info_queue[#info_queue+1] = {generate_ui = ortalab_artist_tooltip, key = 'parchment'} end
    end,
    can_use = function(self, card)
        return true
    end,
    use = function(self, card, area, copier)
        sendDebugMessage("Not yet implemented")
    end
})


SMODS.Consumable({
    key = 'mythos_3',
    set = 'Mythos',
    atlas = 'mythos_cards',
    pos = {x=2, y=0},
    discovered = true,
    config = {extra = {}},
    loc_vars = function(self, info_queue, card)
        if Ortalab.config.artist_credits then info_queue[#info_queue+1] = {generate_ui = ortalab_artist_tooltip, key = 'parchment'} end
    end,
    can_use = function(self, card)
        return true
    end,
    use = function(self, card, area, copier)
        sendDebugMessage("Not yet implemented")
    end
})

SMODS.Consumable({
    key = 'mythos_3',
    set = 'Mythos',
    atlas = 'mythos_cards',
    pos = {x=2, y=0},
    discovered = true,
    config = {extra = {}},
    loc_vars = function(self, info_queue, card)
        if Ortalab.config.artist_credits then info_queue[#info_queue+1] = {generate_ui = ortalab_artist_tooltip, key = 'parchment'} end
    end,
    can_use = function(self, card)
        return true
    end,
    use = function(self, card, area, copier)
        sendDebugMessage("Not yet implemented")
    end
})

SMODS.Consumable({
    key = 'mythos_4',
    set = 'Mythos',
    atlas = 'mythos_cards',
    pos = {x=3, y=0},
    discovered = true,
    config = {extra = {}},
    loc_vars = function(self, info_queue, card)
        if Ortalab.config.artist_credits then info_queue[#info_queue+1] = {generate_ui = ortalab_artist_tooltip, key = 'parchment'} end
    end,
    can_use = function(self, card)
        return true
    end,
    use = function(self, card, area, copier)
        sendDebugMessage("Not yet implemented")
    end
})

SMODS.Consumable({
    key = 'mythos_5',
    set = 'Mythos',
    atlas = 'mythos_cards',
    pos = {x=4, y=0},
    discovered = true,
    config = {extra = {}},
    loc_vars = function(self, info_queue, card)
        if Ortalab.config.artist_credits then info_queue[#info_queue+1] = {generate_ui = ortalab_artist_tooltip, key = 'parchment'} end
    end,
    can_use = function(self, card)
        return true
    end,
    use = function(self, card, area, copier)
        sendDebugMessage("Not yet implemented")
    end
})