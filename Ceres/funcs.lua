-- local is_suit_ref = Card.is_suit
-- function Card:is_suit(suit, bypass_debuff, flush_calc)
--     local ret = is_suit_ref(self, suit, bypass_debuff, flush_calc)
--     if self.base.suit == 'cere_Nothings' then
--         return false
--     end
--     return ret
-- end

local function check_blank(_cards)
    local things = 0
    for _, card in pairs(_cards) do
        if card.base.suit ~= 'cere_Nothings' then
            things = things + 1
        end
    end
    return things < 1
end

local get_poker_hand_info_ref = G.FUNCS.get_poker_hand_info
G.FUNCS.get_poker_hand_info = function(_cards)
    local text, loc_disp_text, poker_hands, scoring_hand, disp_text = get_poker_hand_info_ref(_cards)

    if loc_disp_text == 'Flush' then
        if check_blank(_cards) then
            loc_disp_text = 'Blank'
        end
    elseif loc_disp_text == 'Straight Flush' then
        if check_blank(_cards) then
            loc_disp_text = 'Straight Blank'
        end
    elseif loc_disp_text == 'Royal Flush' then
        if check_blank(_cards) then
            loc_disp_text = 'Royal Blank'
        end
    elseif loc_disp_text == 'Flush House' then
        if check_blank(_cards) then
            loc_disp_text = 'Blank House'
        end
    elseif loc_disp_text == 'Flush Five' then
        if check_blank(_cards) then
            loc_disp_text = 'Blank Five'
        end
    end

    return text, loc_disp_text, poker_hands, scoring_hand, disp_text
end