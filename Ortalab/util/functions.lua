function table.contains(table, element)
	for _, value in pairs(table) do
		if value == element then
			return true
		end
	end
	return false
end

function table.size(table)
    local size = 0
    for _,_ in pairs(table) do
        size = size + 1
    end
    return size
end

function Ortalab.rank_from_deck(seed)
	local ranks = {}
	local seed = seed or 'ortalab_rank_from_deck'
	for _, card in pairs(G.playing_cards) do
		ranks[card.base.value] = card.base.value
	end
	return pseudorandom_element(ranks, pseudoseed(seed))
end

function Ortalab.hand_contains_rank(hand, rank)
    for _, card in ipairs(hand) do
        if card.base.value == rank then return true end
    end
end