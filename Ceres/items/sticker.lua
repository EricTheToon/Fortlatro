-- atlas for stickers
local sticker_atlas = SMODS.Atlas{
    key = 'cere_stickers',
    path = 'cere_stickers.png',
    px = 71,
    py = 95,
    atlas_table = 'ASSET_ATLAS',
}
-- defective sticker
local defective = SMODS.Sticker{
    key = "defective",
    badge_colour = Ceres.C.cere_defective,
    atlas = 'cere_stickers',
    pos = {
        x = 0,
        y = 0
    },

    loc_vars = function(self, info_queue, card)
        return {vars = {G.GAME.probabilities.normal or 1}}
    end,
}
-- temporary sticker
local temporary = SMODS.Sticker{
    key = "temporary",
    badge_colour = Ceres.C.cere_temporary,
    atlas = 'cere_stickers',
    pos = {
        x = 1,
        y = 0
    },
}
-- adding any stickers to in shop jokers when enabled
local create_card_ref = create_card
function create_card(_type, area, legendary, _rarity, skip_materialize, soulable, forced_key, key_append)
    local card = create_card_ref(_type, area, legendary, _rarity, skip_materialize, soulable, forced_key, key_append)
    if _type == 'Joker' and ((area == G.shop_jokers) or (area == G.pack_cards)) then
        if G.GAME.modifiers.cere_enable_defective_in_shop and pseudorandom('cere'..(key_append or '')..G.GAME.round_resets.ante) > 0.7 then
            card:set_defective(true)
        end
        if G.GAME.modifiers.cere_enable_temporary_in_shop and pseudorandom('cere'..(key_append or '')..G.GAME.round_resets.ante) > 0.7 then
            card:set_temporary(true)
        end
    end
    return card
end
-- defective cards not working (working)
local calc_joker_ref = Card.calculate_joker
function Card:calculate_joker(context)
    if self.ability and self.ability.defective then
        if pseudorandom(pseudoseed('defective')) < G.GAME.probabilities.normal/3 then
            return
        end
    end
    return calc_joker_ref(self, context)
end