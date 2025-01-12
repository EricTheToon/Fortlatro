-- HOOKS

local cardarea_add_to_highlighted_ref = CardArea.add_to_highlighted
function CardArea:add_to_highlighted(card, silent)
    if self == G.hand then
        if #G.cere_perks.highlighted > 0 then
            G.cere_perks:unhighlight_all()
        end
    end
    if self == G.cere_perks then
        if #self.highlighted > 0 then
            self:unhighlight_all()
        end
        if #G.hand.highlighted > 0 then
            G.hand:unhighlight_all()
        end
    end
    cardarea_add_to_highlighted_ref(self, card, silent)
end

local cardarea_emplace_ref = CardArea.emplace
function CardArea:emplace(card, location, stay_flipped)
    if card.ability and card.ability.set == 'Perk' and self == G.hand and not from_ref then
        G.cere_perks:emplace(card, location, stay_flipped)
        G.E_MANAGER:add_event(Event({
			trigger = 'immediate',
			func = function()
				G.FUNCS.draw_from_deck_to_hand()
				return true
			end
		}))
    else
        cardarea_emplace_ref(self, card, location, stay_flipped)
    end
end

local cardarea_move_ref = CardArea.move
function CardArea:move(dt)
    if self == G.cere_perks then 
        local desired_y = G.TILE_H - G.cere_perks.T.h - 1.9*((not G.deck_preview and (G.STATE == G.STATES.SELECTING_HAND or G.STATE == G.STATES.DRAW_TO_HAND)) and 2 or 0)
        G.cere_perks.T.y = 15*G.real_dt*desired_y + (1-15*G.real_dt)*G.cere_perks.T.y
        if math.abs(desired_y - G.cere_perks.T.y) < 0.01 then G.cere_perks.T.y = desired_y end
        if G.STATE == G.STATES.TUTORIAL then 
            G.cere_perks.T.y = G.cere_perks.T.y - (3 + 0.6)
        end
        Moveable.move(self, dt)
        self:align_cards()
    else
        cardarea_move_ref(self, dt)
    end
end

local cardarea_draw_ref = CardArea.draw
function CardArea:draw()
    if self == G.cere_perks then
        if not self.states.visible then return end 
        if G.VIEWING_DECK and (self==G.deck or self==G.hand or self==G.play) then return end
        local state = G.TAROT_INTERRUPT or G.STATE
        self.ARGS.invisible_area_types = self.ARGS.invisible_area_types or {discard=1, voucher=1, play=1, consumeable=1, title = 1, title_2 = 1}
        if self.ARGS.invisible_area_types[self.config.type] or
            (self.config.type == 'hand' and ({[G.STATES.SHOP]=1, [G.STATES.TAROT_PACK]=1, [G.STATES.SPECTRAL_PACK]=1, [G.STATES.STANDARD_PACK]=1,[G.STATES.BUFFOON_PACK]=1,[G.STATES.PLANET_PACK]=1, [G.STATES.ROUND_EVAL]=1, [G.STATES.BLIND_SELECT]=1})[state]) or
            (self.config.type == 'hand' and state == G.STATES.SMODS_BOOSTER_OPENED) or
            (self.config.type == 'deck' and self ~= G.deck) or
            (self.config.type == 'shop' and self ~= G.shop_vouchers) then
        end
        self:draw_boundingrect()
        add_to_drawhash(self)
        self.ARGS.draw_layers = self.ARGS.draw_layers or self.config.draw_layers or {'shadow', 'card'}
        for k, v in ipairs(self.ARGS.draw_layers) do
            if self.config.type == 'hand' or self.config.type == 'play' or self.config.type == 'title' or self.config.type == 'voucher' then 
                for i = 1, #self.cards do 
                    if self.cards[i] ~= G.CONTROLLER.focused.target or self == G.hand then
                        if G.CONTROLLER.dragging.target ~= self.cards[i] then self.cards[i]:draw(v) end
                    end
                end
            end
        end
    else
        cardarea_draw_ref(self)
    end
end