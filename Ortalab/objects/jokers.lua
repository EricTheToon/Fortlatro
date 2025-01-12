local joker_list = {
    'jester',
    'generous',
    'chastful',
    'patient',
    'abstemious',
    'glum',
    'serious',
    'calm',
    'sane',
    'gnomic',
    'honest',
    'naive',
    'foolish',
    'direct',
    'dull',
    -- 'other_half',
    -- 'cutout',
    -- 'polydactyly',
    -- 'wallet',
    'bank_loan',
    'revolver',
    'graffiti',
    -- 'memorial',
    -- 'stonehenge',
    'joker_miles',
    'prediction_dice',
    'artist_proof',
    'dawn',
    'open_palm',
    'business',
    'collatz',
    'rusty',
    'scared_face',
    'art_gallery',
    'gratification',
    -- 'crowd_pleaser',
    'hypercalculia',
    'taliaferro',
    'red_fred',
    'pitch_mitch',
    'dropout',
    'scratch_card',
    'protostar',
    -- 'crash',
    'skydiving',
    'sunny_side',
    'policeman',
    'whiteboard',
    -- 'driver',
    'hot_chocolate',
    'virus',
    'miracle_cure',
    -- 'yellow', 
    -- 'common_sense',
    'stargazing',
    -- 'biker',
    'mathmagician',
    -- 'purple',
    'pin_point',
    'blacklist',
    'royal_gala',
    'croupier',
    'blue_card',
    -- 'attached',
    'triangle',
    -- 'shrine', wait for mythos
    -- 'street_rat',
    -- 'belmont',
    'scenic',
    'mirage',
    'head_honcho',
    -- 'peasant',
    -- 'storm6',
    'afterburner',
    -- 'foundation',
    'beyond_the_mask',
    -- 'hooligan',
    'vinyl',
    'black_friday',
    'fine_wine',
    'sedimentation',
    -- 'no_parking',
    'scam_email',
    'reduce_reuse',
    'flashback',
    'televangelist',
    -- 'klutz',
    'cardist',
    'pickaxe',
    -- 'fools',
    'black_cat',
    'mint_condition',
    -- 'bear',
    'mystery_soda',
    -- 'collectors',
    -- 'dnd',
    'popcorn_bag',
    'knitted_sweater',
    'futuristic',
    'salad',
    'roscharch',
    'still_water',
    'mill',
    'frowny_face',
    'freezer',
    -- 'polished',
    'grave_digger',
    'spectator',
    'multiplyers',
    -- 'priest',
    -- 'rockstar',
    -- 'falshe_phd',
    'monochrome',
    'mixtape',
    'scantron',
    'fools_gold',
    'amber_mosquito',
    'dripstone',
    'basalt_column',
    'sandstone',
    'crime_scene',
    'soil',
    -- 'pinkprint',
    -- 'wide',
    -- 'gloomy_gus',
    'woo_all_1',
    -- 'heresy',
    -- '20_20',
    -- 'proletaire',
    -- 'hit_the_gym',
    'solo',
    'mysterium',
    'misfits',
    'shelter',
    'spectrum',
    -- 'actor',
    'chameleon',
    -- 'right_hand',
    'sun_sign',
    -- 'boulevard',
    'forklift',
    'pictographer',
    'astrologist',
    'damp',
    -- 'inheritance',
    --legendaries
    'shinku',
    'caffeyne'
}

SMODS.Atlas({
    key = 'jokers',
    path = 'jokers.png',
    px = '71',
    py = '95'
})

for _, key in ipairs(joker_list) do
    SMODS.load_file('objects/jokers/'..key..'.lua')()
end

if Ortalab.config.placeholders then
    for i=1, 150-#joker_list do
        SMODS.Joker({
            key = 'ortalab_temp_'..i,
            pos = {x = 8, y = 9},
            loc_txt = {
                name = 'Locked',
                text = {'{E:1}???'}
            },
            discovered = true,
            ortalab_demo_card = true,
            rarity = nil,
            in_pool = function(self)
                return false
            end,
            loc_vars = function(self, info_queue, card)
                info_queue[#info_queue+1] = {generate_ui = ortalab_artist_tooltip, key = 'no_demo', title = 'Not In Demo'}
            end
        })
    end
end

function Ortalab.remove_joker(card)
    G.E_MANAGER:add_event(Event({
        func = function()
            play_sound('tarot1')
            card.T.r = -0.2
            card:juice_up(0.3, 0.4)
            card.states.drag.is = true
            card.children.center.pinch.x = true
            G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.3, blockable = false,
                func = function()
                        G.jokers:remove_card(card)
                        card:remove()
                        card = nil
                    return true
            end}))
            return true
    end}))
end

function SMODS.current_mod.reset_game_globals(first_pass)
	if first_pass then
		G.GAME.current_round["spectral_type_sold"] = {}
		G.GAME.current_round["ortalab_free_rerolls"] = 0
	end
end