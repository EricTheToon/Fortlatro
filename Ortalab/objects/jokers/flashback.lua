SMODS.Joker({
	key = "flashback",
	atlas = "jokers",
	pos = {x = 7, y = 5},
	rarity = 1,
	cost = 4,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	config = {extra = {tag = 'tag_ortalab_rewind', chance = 3, mod = 2}},
	loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = {generate_ui = tag_tooltip, key = self.config.extra.tag}
        if card and Ortalab.config.artist_credits then info_queue[#info_queue+1] = {generate_ui = ortalab_artist_tooltip, key = 'gappie'} end
        return {vars = {localize({type = 'name_text', set = 'Tag', key = self.config.extra.tag}), card.ability.extra.mod * math.max(1, G.GAME.probabilities.normal), card.ability.extra.chance / math.min(G.GAME.probabilities.normal, 1)}}
    end,
    calculate = function(self, card, context)
        if context.skip_blind then
            sendDebugMessage('pre: '..#G.GAME.tags)
            if pseudorandom(pseudoseed('ortalab_flashback')) < (G.GAME.probabilities.normal * card.ability.extra.mod) / card.ability.extra.chance then
                card:juice_up()
                card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('ortalab_flashback')})
                add_tag(Tag(card.ability.extra.tag))
                for i = 1, #G.GAME.tags do
                    G.GAME.tags[i]:apply_to_run({type = 'immediate'})
                end
            end
            sendDebugMessage('post: '..#G.GAME.tags)

        end
    end
})