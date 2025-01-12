-- NEW FUNCS

-- TODO figure out better way for wider mod sticker compat
function Card:set_sticker(sticker, bool)
    if sticker == 'eternal' then
        self:set_eternal(bool)
    elseif sticker == 'pcerehable' then
        self:set_pcerehable(bool)
    elseif sticker == 'rental' then
        self:set_rental(bool)
    elseif sticker == 'cere_defective' then
        self:set_defective(bool)
    elseif sticker == 'cere_temporary' then
        self:set_temporary(bool)
    end
    if not sticker then
        self:set_eternal(false)
        self:set_pcerehable(false)
        self:set_rental(false)
        self:set_defective(false)
        self:set_temporary(false)
    end
end

function Card:set_defective(bool)
    self.ability.cere_defective = bool or nil
end

function Card:set_temporary(bool)
    self.ability.cere_temporary = bool or nil
    if self.ability.cere_temporary then
        if not G.GAME.cere.jokers[self] then
            table.insert(G.GAME.cere.jokers, self)
        end
    end
end

function Card:set_perk(perk)
    self:set_ability(perk)
    for k, v in pairs(self.ability) do
    end
end

function Card:perk_dissolve()
    local dissolve_time = 0.7
    self.dissolve = 0
    self.dissolve_colours = {G.C.BLACK, G.C.ORANGE, G.C.RED, G.C.GOLD, G.C.JOKER_GREY}
    self:juice_up()
    local childParts = Particles(0, 0, 0,0, {
        timer_type = 'TOTAL',
        timer = 0.01*dissolve_time,
        scale = 0.1,
        speed = 2,
        lifespan = 0.7*dissolve_time,
        attach = self,
        colours = self.dissolve_colours,
        fill = true
    })
    G.E_MANAGER:add_event(Event({
        trigger = 'after',
        blockable = false,
        delay =  0.7*dissolve_time,
        func = (function() childParts:fade(0.3*dissolve_time) return true end)
    }))
	G.E_MANAGER:add_event(Event({
		blockable = false,
		func = (function()
				play_sound('whoosh2', math.random()*0.2 + 0.9,0.5)
				play_sound('crumple'..math.random(1, 5), math.random()*0.2 + 0.9,0.5)
			return true end)
	}))
    G.E_MANAGER:add_event(Event({
        trigger = 'ease',
        blockable = false,
        ref_table = self,
        ref_value = 'dissolve',
        ease_to = 1,
        delay =  1*dissolve_time,
        func = (function(t) return t end)
    }))
    G.E_MANAGER:add_event(Event({
        trigger = 'after',
        blockable = false,
        delay =  1.051*dissolve_time,
    }))
end

-- HOOKS

local card_set_ability_ref = Card.set_ability
function Card:set_ability(center, initial, delay_sprites)
    card_set_ability_ref(self, center, initial, delay_sprites)
end

local card_load_ref = Card.load
function Card:load(cardTable, other_card)
    card_load_ref(self, cardTable, other_card)
    if self.ability.cere_temporary then
        table.insert(G.GAME.cere.jokers, self)
    end
end

-- 'borrowed' from cryptid, for multi layer sprites
local set_spritesref = Card.set_sprites
function Card:set_sprites(_center, _front)
    set_spritesref(self, _center, _front);
    if _center and _center.soul_pos and _center.soul_pos.extra and not Ceres.COMPAT.crytpid then
        self.children.floating_sprite2 = Sprite(self.T.x, self.T.y, self.T.w, self.T.h, G.ASSET_ATLAS[_center.atlas or _center.set], _center.soul_pos.extra)
        self.children.floating_sprite2.role.draw_major = self
        self.children.floating_sprite2.states.hover.can = false
        self.children.floating_sprite2.states.click.can = false
    end
end