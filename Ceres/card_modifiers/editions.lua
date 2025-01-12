local colourblind_shader = SMODS.Shader({key = 'colourblind', path = 'colourblind.fs'})
local mint_shader = SMODS.Shader({key = 'mint', path = 'mint.fs'})

local colourblind = Ceres.CONFIG.card_modifiers.editions.enabled and SMODS.Edition({
    key = "colourblind",
    unlocked = false or Ceres.CONFIG.misc.unlock_all.enabled,
    discovered = false or Ceres.CONFIG.misc.discover_all.enabled,
    shader = 'colourblind',
    config = {
        x_mult = 1.25,
        cere_x_chips = 1.25,
    },
    in_shop = true,
    weight = 3,
    extra_cost = 5,
    apply_to_float = false,
    loc_vars = function(self, info_queue, card)
        return { vars = {
            (card and card.edition and card.edition.cere_x_chips) or self.config.cere_x_chips,
            (card and card.edition and card.edition.x_mult) or self.config.x_mult,
        }}
    end,

    get_weight = function(self)
        return (G.GAME.cere_edition_rate or 1) * self.weight
    end
})

local mint = Ceres.CONFIG.card_modifiers.editions.enabled and SMODS.Edition({
    key = "mint_condition",
    unlocked = false or Ceres.CONFIG.misc.unlock_all.enabled,
    discovered = false or Ceres.CONFIG.misc.discover_all.enabled,
    shader = 'mint',
    config = { extra = 2},
    in_shop = true,
    weight = 10,
    extra_cost = 4,
    apply_to_float = false,
    loc_vars = function(self, info_queue, card)
        return { vars = {(card and card.edition and card.edition.extra) or self.config.extra}}
    end,

    get_weight = function(self)
        return (G.GAME.cere_edition_rate or 1) * self.weight
    end
})

local mint_atlas = SMODS.Atlas{
    key = 'mint',
    path = 'mint_condition.png',
    px = 71,
    py = 95,
    atlas_table = 'ASSET_ATLAS',
}

local glass = nil

local card_draw_ref = Card.draw
function Card:draw(layer)
    if not glass then
        glass = Sprite(0, 0, G.CARD_W, G.CARD_H, mint_atlas, {x=0,y=0})
    end
    card_draw_ref(self, layer)
    if self.sprite_facing == 'front' and self.edition and self.edition.type == 'cere_mint_condition' then
        glass.role.draw_major = self
        glass:draw_shader('dissolve', nil, nil, nil, self.children.center)
    end
end

local ease_dollars_ref = ease_dollars
function ease_dollars(mod, instant)
    local inc = 0
    if mod > 0 then
        for _, card in pairs(G.hand.cards) do
            if card.edition and card.edition.type == 'cere_mint_condition' then
                inc = inc + card.edition.extra
            end
        end
    end
    ease_dollars_ref(mod, instant)
    if inc > 0 then
        delay(0.5)
        ease_dollars_ref(inc, instant)
    end
end
