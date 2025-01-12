-- Artist Colours
G.ARGS.LOC_COLOURS['gappie'] = HEX('7BF2FF')
G.ARGS.LOC_COLOURS['eremel'] = HEX('F48CBA')
G.ARGS.LOC_COLOURS['kosze'] = HEX('4ecf21')
G.ARGS.LOC_COLOURS['tevi'] = HEX('18b57e')
G.ARGS.LOC_COLOURS['crimson'] = HEX('990000')
G.ARGS.LOC_COLOURS['salad'] = HEX('0AC400')
G.ARGS.LOC_COLOURS['alex'] = HEX('16db9d')
G.ARGS.LOC_COLOURS['cheese'] = HEX('a3a616')
G.ARGS.LOC_COLOURS['coro'] = HEX('9cb3e2')
G.ARGS.LOC_COLOURS['flare'] = HEX('fd5f55')
G.ARGS.LOC_COLOURS['flowwey'] = HEX('110663')
G.ARGS.LOC_COLOURS['golddisco'] = HEX('e6bb12')
G.ARGS.LOC_COLOURS['logan'] = HEX('ffff00')
G.ARGS.LOC_COLOURS['parchment'] = HEX('74293f')
G.ARGS.LOC_COLOURS['shinku'] = HEX('e36774')

function ortalab_artist_tooltip(_c, info_queue, card, desc_nodes, specific_vars, full_UI_table)
    localize{type = 'descriptions', set = 'Ortalab Artist', key = _c.key, nodes = desc_nodes, vars = specific_vars or _c.vars}
    desc_nodes['colour'] = G.ARGS.LOC_COLOURS[_c.key] or G.C.GREY
    desc_nodes.ortalab_artist = true
    desc_nodes.title = _c.title or localize('ortalab_artist')
end

function tag_tooltip(_c, info_queue, card, desc_nodes, specific_vars, full_UI_table)
    desc_nodes.tag = true
    desc_nodes.title = localize({type = 'name_text', set = 'Tag', key = _c.key})
    localize{type = 'descriptions', set = 'Tag', key = _c.key, nodes = desc_nodes, vars = specific_vars or G.P_TAGS[_c.key]:loc_vars().vars}
end

local itfr = info_tip_from_rows
function info_tip_from_rows(desc_nodes, name)
    if desc_nodes.ortalab_artist then
        local t = {}
        for k, v in ipairs(desc_nodes) do
        t[#t+1] = {n=G.UIT.R, config={align = "cm"}, nodes=v}
        end
        return {n=G.UIT.R, config={align = "cm", colour = darken(desc_nodes.colour, 0.15), r = 0.1}, nodes={
            {n=G.UIT.R, config={align = "tm", minh = 0.36, padding = 0.03}, nodes={{n=G.UIT.T, config={text = desc_nodes.title, scale = 0.32, colour = G.C.UI.TEXT_LIGHT}}}},
            {n=G.UIT.R, config={align = "cm", minw = 1.5, minh = 0.4, r = 0.1, padding = 0.05, colour = lighten(desc_nodes.colour, 0.5)}, nodes={{n=G.UIT.R, config={align = "cm", padding = 0.03}, nodes=t}}}
        }}
    elseif desc_nodes.tag then
        local t = {}
        for k, v in ipairs(desc_nodes) do
        t[#t+1] = {n=G.UIT.R, config={align = "cm"}, nodes=v}
        end
        return {n=G.UIT.R, config={align = "cm", colour = lighten(G.C.GREY, 0.15), r = 0.1}, nodes={
            {n=G.UIT.R, config={align = "tm", minh = 0.36, padding = 0.03}, nodes={{n=G.UIT.T, config={text = desc_nodes.title, scale = 0.32, colour = G.C.UI.TEXT_LIGHT}}}},
            {n=G.UIT.R, config={align = "cm", minw = 1.5, minh = 0.4, r = 0.1, padding = 0.05, colour = G.C.WHITE}, nodes={{n=G.UIT.R, config={align = "cm", padding = 0.03}, nodes=t}}}
        }}
    else
        return itfr(desc_nodes, name)
    end
end




-- G.ARGS.LOC_COLOURS['zodiac'] = HEX('9D3B35')
-- G.ARGS.LOC_COLOURS['cryptid'] = HEX('704F72')

