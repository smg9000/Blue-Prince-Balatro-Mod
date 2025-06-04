
SMODS.Atlas({ key = "experiments", atlas_table = "ASSET_ATLAS", path = "Exp.png", px = 71, py = 95})

function G.UIDEF.active_experiment()

    local target = {
        type = 'descriptions',
        nodes = {},
    }
    local target2 = {
        type = 'descriptions',
        nodes = {},
    }

    local cause = localize(G.GAME.bp_experiment_cause, 'causes')
    local effect = localize(G.GAME.bp_experiment_effect, 'effects')

    localalize_with_direct({text = {cause}, text_parsed = {loc_parse_string(cause)}}, target)
    localalize_with_direct({text = {effect}, text_parsed = {loc_parse_string(effect)}}, target2)

    local cause_texts = {}
    for i, j in ipairs(target.nodes[1]) do
        table.insert(cause_texts, {n=G.UIT.T, config={ref_table = {j.config.text}, ref_value = 1, scale = 0.4, colour = (j.config.colour == G.C.UI.TEXT_DARK) and G.C.WHITE or j.config.colour, shadow = true}})
    end

    local effect_texts = {}
    for i, j in ipairs(target2.nodes[1]) do
        table.insert(effect_texts, {n=G.UIT.T, config={ref_table = {j.config.text}, ref_value = 1, scale = 0.4, colour = (j.config.colour == G.C.UI.TEXT_DARK) and G.C.WHITE or j.config.colour, shadow = true}})
    end
    
    local t = {n=G.UIT.ROOT, config={align = "cm", padding = 0.1, colour = G.C.CLEAR, minh = 8, minw = 7}, nodes={
        {n=G.UIT.R, config={align = "cm", colour = G.C.CLEAR, padding = 0.3}, nodes = {
            {n=G.UIT.R, config={align = "cm", colour = G.C.BLACK, r = 0.1, maxw=3, padding = 0.2}, nodes={
                {n=G.UIT.R, config={align = "cm", colour = G.C.CLEAR, r = 0.1, maxw=3}, nodes=cause_texts}
            }},
            {n=G.UIT.R, config={align = "cm", colour = G.C.BLACK, r = 0.1, maxw=3, padding = 0.2}, nodes={
                {n=G.UIT.R, config={align = "cm", colour = G.C.CLEAR, r = 0.1, maxw=3}, nodes=effect_texts}
            }},
        }}}
    }

    return t
end

local experimentType = SMODS.ConsumableType {
    key = 'Experiment',
    loc_txt = {},
    primary_colour = HEX('2c4a34'),
    secondary_colour = HEX('2c4a34'),
    collection_rows = { 1 },
    shop_rate = 2,
    default = "c_experiment"
}

function localalize_with_direct(loc_target, args, misc_cat)
    if loc_target then 
        for _, lines in ipairs(args.type == 'unlocks' and loc_target.unlock_parsed or args.type == 'name' and loc_target.name_parsed or (args.type == 'text' or args.type == 'tutorial' or args.type == 'quips') and loc_target or loc_target.text_parsed) do
          local final_line = {}
          for _, part in ipairs(lines) do
            local assembled_string = ''
            for _, subpart in ipairs(part.strings) do
              assembled_string = assembled_string..(type(subpart) == 'string' and subpart or format_ui_value(args.vars[tonumber(subpart[1])]) or 'ERROR')
            end
            local desc_scale = G.LANG.font.DESCSCALE
            if G.F_MOBILE_UI then desc_scale = desc_scale*1.5 end
            if args.type == 'name' then
              final_line[#final_line+1] = {n=G.UIT.O, config={
                object = DynaText({string = {assembled_string},
                  colours = {(part.control.V and args.vars.colours[tonumber(part.control.V)]) or (part.control.C and loc_colour(part.control.C)) or G.C.UI.TEXT_LIGHT},
                  bump = true,
                  silent = true,
                  pop_in = 0,
                  pop_in_rate = 4,
                  maxw = 5,
                  shadow = true,
                  y_offset = -0.6,
                  spacing = math.max(0, 0.32*(17 - #assembled_string)),
                  scale =  (0.55 - 0.004*#assembled_string)*(part.control.s and tonumber(part.control.s) or 1)
                })
              }}
            elseif part.control.E then
              local _float, _silent, _pop_in, _bump, _spacing = nil, true, nil, nil, nil
              if part.control.E == '1' then
                _float = true; _silent = true; _pop_in = 0
              elseif part.control.E == '2' then
                _bump = true; _spacing = 1
              end
              final_line[#final_line+1] = {n=G.UIT.O, config={
                object = DynaText({string = {assembled_string}, colours = {part.control.V and args.vars.colours[tonumber(part.control.V)] or loc_colour(part.control.C or nil)},
                float = _float,
                silent = _silent,
                pop_in = _pop_in,
                bump = _bump,
                spacing = _spacing,
                scale = 0.32*(part.control.s and tonumber(part.control.s) or 1)*desc_scale})
              }}
            elseif part.control.X then
              final_line[#final_line+1] = {n=G.UIT.C, config={align = "m", colour = loc_colour(part.control.X), r = 0.05, padding = 0.03, res = 0.15}, nodes={
                  {n=G.UIT.T, config={
                    text = assembled_string,
                    colour = loc_colour(part.control.C or nil),
                    scale = 0.32*(part.control.s and tonumber(part.control.s) or 1)*desc_scale}},
              }}
            else
              final_line[#final_line+1] = {n=G.UIT.T, config={
              detailed_tooltip = part.control.T and (G.P_CENTERS[part.control.T] or G.P_TAGS[part.control.T]) or nil,
              text = assembled_string,
              shadow = args.shadow,
              colour = part.control.V and args.vars.colours[tonumber(part.control.V)] or loc_colour(part.control.C or nil, args.default_col),
              scale = 0.32*(part.control.s and tonumber(part.control.s) or 1)*desc_scale},}
            end
          end
            if args.type == 'name' or args.type == 'text' then return final_line end
            args.nodes[#args.nodes+1] = final_line
        end
    end
end

local experiment_causes = {}

SMODS.Consumable {
    set = 'Experiment',
    use = function(self, card, area, copier)
        G.GAME.bp_experiment_cause = card.ability.cause
        G.GAME.bp_experiment_effect = card.ability.effect
    end,
    can_use = function(self, card)
        return true
    end,
    set_ability = function(self, card, initial, delay_sprites)
        card.ability.cause = 'select_blind'
        card.ability.effect = 'earn_5_dollars'
    end,
    cost = 3,
    key = 'experiment',
    atlas = 'experiments',
    display_size = { w = 71, h = 71 },
    pixel_size = { w = 71, h = 71 },
    generate_ui = function(self, info_queue, card, desc_nodes, specific_vars, full_UI_table)
        local target = {
            type = 'descriptions',
            key = self.key,
            set = self.set,
            nodes = desc_nodes,
            vars =
                specific_vars or {}
        }
        if self.loc_vars and type(self.loc_vars) == 'function' then
            local res = self:loc_vars(info_queue, card) or {}
            target.vars = res.vars or target.vars
            target.key = res.key or target.key
        end
        local new_loc = { text = {}}
        new_loc.text_parsed = {}
        table.insert(new_loc.text, localize(card.ability.cause, 'causes'))
        table.insert(new_loc.text_parsed, loc_parse_string(localize(card.ability.cause, 'causes')))
        table.insert(new_loc.text, localize(card.ability.effect, 'effects'))
        table.insert(new_loc.text_parsed, loc_parse_string(localize(card.ability.effect, 'effects')))
        if not full_UI_table.name then
            full_UI_table.name = localize { type = 'name', set = self.set, key = target.key or self.key, nodes = full_UI_table.name }
        end
        if specific_vars and specific_vars.debuffed then
            target = { type = 'other', key = 'debuffed_' ..
            (specific_vars.playing_card and 'playing_card' or 'default'), nodes = desc_nodes }
        end
        localalize_with_direct(new_loc, target)
    end,
    in_pool = function()
        return true, { allow_duplicates = true }
    end
}

function do_experiment_effect()
    if G.GAME.bp_experiment_effect == 'earn_5_dollars' then
        ease_dollars(5)
    end
end