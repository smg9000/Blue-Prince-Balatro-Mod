to_big = to_big or function(x) return x end

bp_force_showman = nil
bp_force_showman2 = nil

SMODS.Atlas({ key = "experiments", atlas_table = "ASSET_ATLAS", path = "Exp.png", px = 71, py = 95})

SMODS.Atlas({ key = "gallery_letters", atlas_table = "ASSET_ATLAS", path = "gallery_letters.png", px = 71, py = 95})

SMODS.Atlas({ key = "bpjokers", atlas_table = "ASSET_ATLAS", path = "bpjokers.png", px = 71, py = 95})

function G.UIDEF.active_experiment()

    local target = {
        type = 'descriptions',
        nodes = {},
        vars = {G.GAME and G.GAME.bp_spectral_uses_left or 5}
    }
    local target2 = {
        type = 'descriptions',
        nodes = {},
        vars = {G.GAME and G.GAME.bp_spectral_uses_left or 5}
    }

    local cause = G.localization.descriptions.ExperimentCauses[G.GAME.bp_experiment_cause or 'none'].text
    local effect = G.localization.descriptions.ExperimentEffects[G.GAME.bp_experiment_effect or 'none'].text

    local parsed_cause = {}
    for i = 1, #cause do
        table.insert(parsed_cause, loc_parse_string(cause[i]))
    end

    local parsed_effect = {}
    for i = 1, #effect do
        table.insert(parsed_effect, loc_parse_string(effect[i]))
    end

    localalize_with_direct({text = cause, text_parsed = parsed_cause}, target)
    localalize_with_direct({text = effect, text_parsed = parsed_effect}, target2)

    local cause_texts = {}
    for k = 1, #target.nodes do
        local t = {}
        for i, j in ipairs(target.nodes[k]) do
            table.insert(t, {n=G.UIT.T, config={ref_table = {j.config.text}, ref_value = 1, scale = 0.4, colour = (j.config.colour == G.C.UI.TEXT_DARK) and G.C.WHITE or j.config.colour, shadow = true}})
        end
        table.insert(cause_texts, {n=G.UIT.R, config={align = "cm", colour = G.C.CLEAR, r = 0.1, maxw=3}, nodes=t})
    end

    local effect_texts = {}
    for k = 1, #target2.nodes do
        local t = {}
        for i, j in ipairs(target2.nodes[k]) do
            table.insert(t, {n=G.UIT.T, config={ref_table = {j.config.text}, ref_value = 1, scale = 0.4, colour = (j.config.colour == G.C.UI.TEXT_DARK) and G.C.WHITE or j.config.colour, shadow = true}})
        end
        table.insert(effect_texts, {n=G.UIT.R, config={align = "cm", colour = G.C.CLEAR, r = 0.1, maxw=3}, nodes=t})
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
    shop_rate = 4,
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

local experiment_causes = { 'item_bought_lose_3', 'skip_booster', 'skip_blind', 'immediately', 'sell_joker_with_retrigger', 'next_5_spectral_use', 'destroy_enhanced_playing_card', 'randomly_each_round'}

local experiment_effects = { 'earn_5_dollars', 'upgrade_3_hands', 'create_negative_immediately_experiment', 'create_joker', 'use_wheel_of_fortune', 'add_last_used_tarot_to_pool', '2_percent_probabilities', 'reroll_tags', 'smg_special' }

SMODS.DraftJoker = SMODS.Joker:extend {
    inject = function(self)
        SMODS.Joker.inject(self)
        if self.bp_include_pools then
            for i = 1, #self.bp_include_pools do
                if not G.P_CENTER_POOLS[self.bp_include_pools[i]] then
                    G.P_CENTER_POOLS[self.bp_include_pools[i]] = {}
                end
                table.insert(G.P_CENTER_POOLS[self.bp_include_pools[i]], self)
                if not G['P_' .. string.upper(self.bp_include_pools[i]) .. '_RARITY_POOLS'] then
                    G['P_' .. string.upper(self.bp_include_pools[i]) .. '_RARITY_POOLS'] = {
                        [1] = {},
                        [2] = {},
                        [3] = {},
                        [4] = {},
                    }
                end
                table.insert(G['P_' .. string.upper(self.bp_include_pools[i]) .. '_RARITY_POOLS'][self.rarity], self)
                table.sort(G['P_' .. string.upper(self.bp_include_pools[i]) .. '_RARITY_POOLS'][self.rarity], function (a, b) return a.order < b.order end)
                local vanilla_rarities = {["Common"] = 1, ["Uncommon"] = 2, ["Rare"] = 3, ["Legendary"] = 4}
                if vanilla_rarities[self.rarity] then
                    table.insert(G['P_' .. string.upper(self.bp_include_pools[i]) .. '_RARITY_POOLS'][vanilla_rarities[self.rarity]], self)
                    table.sort(G['P_' .. string.upper(self.bp_include_pools[i]) .. '_RARITY_POOLS'][vanilla_rarities[self.rarity]], function (a, b) return a.order < b.order end)
                end
                table.sort(G.P_CENTER_POOLS[self.bp_include_pools[i]], function (a, b) return a.order < b.order end)
            end
        end
    end,
    delete = function(self)
        if self.bp_include_pools then
            for i = 1, #self.bp_include_pools do
                if not G.P_CENTER_POOLS[self.bp_include_pools[i]] then
                    G.P_CENTER_POOLS[self.bp_include_pools[i]] = {}
                end
                SMODS.remove_pool(G.P_CENTER_POOLS[self.bp_include_pools[i]], self.key)
            end
        end
        SMODS.Joker.delete(self)
        
    end,
}

SMODS.Consumable {
    set = 'Experiment',
    use = function(self, card, area, copier)
        G.GAME.bp_experiment_cause = card.ability.cause
        G.GAME.bp_experiment_effect = card.ability.effect
        if G.GAME.bp_experiment_cause == 'immediately' then
            if do_pre_experiment_effect(G.GAME.bp_experiment_effect) then
                local effect = G.GAME.bp_experiment_effect
                G.E_MANAGER:add_event(Event({
                    trigger = 'immediate',
                    func = function()
                        do_experiment_effect(effect)
                        return true
                    end
                }))
            end
        elseif G.GAME.bp_experiment_cause == 'next_5_spectral_use' then
            G.GAME.bp_spectral_uses_left = 5
        end
    end,
    can_use = function(self, card)
        return true
    end,
    set_ability = function(self, card, initial, delay_sprites)
        card.ability.cause = bp_force_immeditely and 'immediately' or pseudorandom_element(experiment_causes, pseudoseed('round'))
        card.ability.effect = pseudorandom_element(experiment_effects, pseudoseed('round'))
        bp_force_immeditely = nil
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

        local cause = G.localization.descriptions.ExperimentCauses[card.ability.cause].text
        local effect = G.localization.descriptions.ExperimentEffects[card.ability.effect].text
    
        local parsed_cause = {}
        for i = 1, #cause do
            table.insert(parsed_cause, loc_parse_string(cause[i]))
        end
    
        local parsed_effect = {}
        for i = 1, #effect do
            table.insert(parsed_effect, loc_parse_string(effect[i]))
        end

        for i = 1, #cause do
            table.insert(new_loc.text, cause[i])
            table.insert(new_loc.text_parsed, parsed_cause[i])
        end
        for i = 1, #effect do
            table.insert(new_loc.text, effect[i])
            table.insert(new_loc.text_parsed, parsed_effect[i])
        end

        if not full_UI_table.name then
            full_UI_table.name = localize { type = 'name', set = self.set, key = target.key or self.key, nodes = full_UI_table.name }
        end
        if specific_vars and specific_vars.debuffed then
            target = { type = 'other', key = 'debuffed_' ..
            (specific_vars.playing_card and 'playing_card' or 'default'), nodes = desc_nodes }
        end

        target.vars = {5}

        localalize_with_direct(new_loc, target)

        if card.ability.effect == 'use_wheel_of_fortune' then
            info_queue[#info_queue + 1] = G.P_CENTERS['c_wheel_of_fortune']
        elseif card.ability.effect == 'create_negative_immediately_experiment' then
            info_queue[#info_queue + 1] = G.P_CENTERS['e_negative']
        end

        if card.ability.effect == 'add_last_used_tarot_to_pool' then 
            local fool_c = G.GAME.last_tarot and G.P_CENTERS[G.GAME.last_tarot] or nil
            local last_tarot = fool_c and localize{type = 'name_text', key = fool_c.key, set = fool_c.set} or localize('k_none')
            local colour = (not fool_c or fool_c.name == 'The Fool') and G.C.RED or G.C.GREEN
            desc_nodes[#desc_nodes+1] = {
                {n=G.UIT.C, config={align = "bm", padding = 0.02}, nodes={
                    {n=G.UIT.C, config={align = "m", colour = colour, r = 0.05, padding = 0.05}, nodes={
                        {n=G.UIT.T, config={text = ' '..last_tarot..' ', colour = G.C.UI.TEXT_LIGHT, scale = 0.3, shadow = true}},
                    }}
                }}
            }
            if fool_c then
                info_queue[#info_queue + 1] = G.P_CENTERS[fool_c]
            end
        end
    end,
    in_pool = function()
        return true, { allow_duplicates = true }
    end
}

SMODS.DraftJoker {
    key = 'bedroom',
    name = "Bedroom",
    loc_txt = {
        name = "Bedroom",
        text = {
            "After this {C:attention}Joker{} is",
            "sold, the {C:attention}next{} Joker sold",
            "will create {C:attention}Bedroom{}", 
            "{C:inactive}({C:attention}Bedroom{C:inactive} excluded, must have room)",
        }
    },
    atlas = 'bpjokers',
    pos = {x = 0, y = 0},
    rarity = 1,
    cost = 4,
    bp_include_pools = {"Draft", "Bedroom"},
    calculate = function(self, card, context)
        if context.selling_self and not context.blueprint then
            G.GAME.bp_bedroom = (G.GAME.bp_bedroom or 0) + 1
        end
    end
}

SMODS.DraftJoker {
    key = 'conservatory',
    name = "Conservatory",
    loc_txt = {
        name = "Conservatory",
        text = {
            "After each hand, Swap the {C:attention}Rarity{}",
            "{C:attention}Pools{} of {C:attention}2{} random jokers from",
            "the {C:attention}Rarity Pools{} of the Jokers", 
            "to the {C:attention}left{} and {C:attention}right{}",
            "{C:inactive}Last Swapped: {V:1}#1#{C:inactive}, {V:2}#2#{}"
        }
    },
    atlas = 'bpjokers',
    pos = {x = 1, y = 0},
    rarity = 3,
    cost = 9,
    bp_include_pools = {"Draft", "Green"},
    calculate = function(self, card, context)
        local index = nil
        for i = 1, #G.jokers.cards do
            if G.jokers.cards[i] == card then
                index = i
            end
        end
        if ((index ~= nil) and (index ~= 1) and (index ~= #G.jokers.cards)) and context.after and not context.before and not context.blueprint then
            bp_force_showman2 = true
            local common_pool = copy_table(get_current_pool('Joker', 0, nil, 'con'))
            local uncommon_pool = copy_table(get_current_pool('Joker', 0.8, nil, 'con'))
            local rare_pool = copy_table(get_current_pool('Joker', 0.99, nil, 'con'))
            local legendary_pool = copy_table(get_current_pool('Joker', nil, true, 'con'))
            local pools = {common_pool, uncommon_pool, rare_pool, legendary_pool}
            for i, j in pairs(SMODS.Rarities) do
                if (i ~= 'Common') and (i ~= 'Uncommon') and (i ~= 'Rare') and (i ~= 'Legendary') then
                    pools[i] = copy_table(get_current_pool('Joker', i, nil, 'con'))
                end
            end
            bp_force_showman2 = nil
            local pool1, pool2 = nil, nil
            local key1, key2 = G.jokers.cards[index - 1].config.center.key, G.jokers.cards[index + 1].config.center.key
            for i, _ in pairs(pools) do
                for j = 1, #pools[i] do
                    if pools[i][j] == key1 then
                        pool1 = i
                    end
                    if pools[i][j] == key2 then
                        pool2 = i
                    end
                    if (pool1 ~= nil) and (pool2 ~= nil) then
                        break
                    end
                end
                if (pool1 ~= nil) and (pool2 ~= nil) then
                    break
                end
            end
            pool1 = pool1 or G.jokers.cards[index - 1].config.center.rarity
            pool2 = pool2 or G.jokers.cards[index + 1].config.center.rarity
            local joker1 = pseudorandom_element(pools[pool1], pseudoseed('con_com'))
            while joker1 == 'UNAVAILABLE' do
                joker1 = pseudorandom_element(pools[pool1], pseudoseed('con_com'))
            end
            local joker2 = pseudorandom_element(pools[pool2], pseudoseed('con_unc'))
            while joker2 == 'UNAVAILABLE' do
                joker2 = pseudorandom_element(pools[pool2], pseudoseed('con_com'))
            end
            card.ability.common_joker = localize{type = 'name_text', key = joker1, set = 'Joker'}
            card.ability.common_color = G.C.RARITY[pool1]
            card.ability.uncommon_joker = localize{type = 'name_text', key = joker2, set = 'Joker'}
            card.ability.uncommon_color = G.C.RARITY[pool2]
            card:juice_up()
            bp_add_to_pool(joker1, 'Joker', 1, (pool2 ~= 4) and pool2 or nil, (pool2 == 4))
            bp_add_to_pool(joker1, 'Joker', -1, (pool1 ~= 4) and pool1 or nil, (pool1 == 4))
            bp_add_to_pool(joker2, 'Joker', 1, (pool1 ~= 4) and pool1 or nil, (pool1 == 4))
            bp_add_to_pool(joker2, 'Joker', -1, (pool2 ~= 4) and pool2 or nil, (pool2 == 4))
            play_area_status_text(localize{type = 'name_text', key = joker1, set = 'Joker'} .. " and " .. localize{type = 'name_text', key = joker2, set = 'Joker'} .. " Swapped!")
        end
    end,
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.common_joker or 'None', card.ability.uncommon_joker or 'None', colours = {card.ability.common_color or G.C.FILTER, card.ability.uncommon_color or G.C.FILTER}}}
    end,
}

SMODS.DraftJoker {
    key = 'hallway',
    name = "Hallway",
    loc_txt = {
        name = "Hallway",
        text = {
            "{C:dark_edition}+#1#{} Joker Slot during",
            "blinds. When {C:attention}Blind{} is",
            "Selected, Create a {C:attention}Joker{}",
        }
    },
    atlas = 'bpjokers',
    pos = {x = 2, y = 0},
    rarity = 2,
    cost = 8,
    blueprint_compat = false,
    config = {joker_slots = 1},
    bp_include_pools = {"Draft", "Hallway"},
    calculate = function(self, card, context)
        if context.end_of_round and context.main_eval and not context.blueprint then
            G.jokers.config.card_limit = G.jokers.config.card_limit - card.ability.joker_slots
        elseif context.setting_blind and not card.getting_sliced and not context.blueprint then
            G.jokers.config.card_limit = G.jokers.config.card_limit + card.ability.joker_slots
            if G.GAME.joker_buffer + #G.jokers.cards < G.jokers.config.card_limit then
                G.GAME.joker_buffer = G.GAME.joker_buffer + 1
                G.E_MANAGER:add_event(Event({
                    trigger = 'immediate',
                    func = function()
                        local card_ = create_card('Joker', G.jokers, nil, nil, nil, nil, nil, 'hal')
                        card_:add_to_deck()
                        G.jokers:emplace(card_)
                        G.GAME.joker_buffer = 0
                        return true
                    end
                }))
                card_eval_status_text(card, 'jokers', nil, nil, nil, {colour = G.C.FILTER, message = localize('k_plus_joker')})
            end
        end
    end,
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.joker_slots}}
    end,
    add_to_deck = function(self, card)
        if G.GAME.facing_blind then
            G.jokers.config.card_limit = G.jokers.config.card_limit + card.ability.joker_slots
        end
    end,
    remove_from_deck = function(self, card)
        if G.GAME.facing_blind then
            G.jokers.config.card_limit = G.jokers.config.card_limit - card.ability.joker_slots
        end
    end,
}

SMODS.DraftJoker {
    key = 'aquarium',
    name = "bp_Aquarium",
    loc_txt = {
        name = "Aquarium",
        text = {
            "{C:attention}Copies{} all owned",
            "{C:blue}Common{} {C:attention}Jokers{}",
        }
    },
    bp_include_pools = {"Draft", "Blue", "Bedroom", "Red", "Hallway", "Shop", "Green", "Black"},
    atlas = 'bpjokers',
    pos = {x = 3, y = 0},
    rarity = 3,
    cost = 9,
    generate_ui = function(self, info_queue, card, desc_nodes, specific_vars, full_UI_table)
        if not card then
            card = self:create_fake_card()
        end
        local set = (card and card.ability and card.ability.bp_sheltered) and 'ShelteredJoker' or
        next(SMODS.find_card('j_bp_shelter')) and (card.area ~= G.jokers) and 'MidShelteredJoker' or
        'Joker'
        local target = {
            type = 'descriptions',
            key = self.key,
            set = set,
            nodes = desc_nodes,
            AUT = full_UI_table,
            vars =
                specific_vars or {}
        }
        local res = {}
        if self.loc_vars and type(self.loc_vars) == 'function' then
            res = self:loc_vars(info_queue, card) or {}
            target.vars = res.vars or target.vars
            target.key = res.key or target.key
            target.set = res.set or target.set
            target.scale = res.scale
            target.text_colour = res.text_colour
        end
        if desc_nodes == full_UI_table.main and not full_UI_table.name then
            full_UI_table.name = self.set == 'Enhanced' and 'temp_value' or localize { type = 'name', set = target.set, key = res.name_key or target.key, nodes = full_UI_table.name, vars = res.name_vars or target.vars or {} }
        elseif desc_nodes ~= full_UI_table.main and not desc_nodes.name and self.set ~= 'Enhanced' then
            desc_nodes.name = localize{type = 'name_text', key = res.name_key or target.key, set = target.set }
        end
        if specific_vars and specific_vars.debuffed and not res.replace_debuff then
            target = { type = 'other', key = 'debuffed_' ..
            (specific_vars.playing_card and 'playing_card' or 'default'), nodes = desc_nodes, AUT = full_UI_table, }
        end
        if res.main_start then
            desc_nodes[#desc_nodes + 1] = res.main_start
        end
        localize(target)
        if res.main_end then
            desc_nodes[#desc_nodes + 1] = res.main_end
        end
        desc_nodes.background_colour = res.background_colour
    end
}

SMODS.DraftJoker {
    key = 'darkroom',
    name = "Darkroom",
    loc_txt = {
        name = "Darkroom",
        text = {
            "{X:mult,C:white} X#1# {} Mult",
            "{C:attention}Jokers{} in shop",
            "are {C:attention}face down{}",
        }
    },
    config = {x_mult = 3},
    atlas = 'bpjokers',
    pos = {x = 4, y = 0},
    rarity = 2,
    cost = 6,
    bp_include_pools = {"Draft", "Red"},
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.x_mult}}
    end,
    generate_ui = function(self, info_queue, card, desc_nodes, specific_vars, full_UI_table)
        if not card then
            card = self:create_fake_card()
        end
        local set = (card and card.ability and card.ability.bp_sheltered) and 'ShelteredJoker' or
        next(SMODS.find_card('j_bp_shelter')) and (card.area ~= G.jokers) and 'MidShelteredJoker' or
        'Joker'
        local target = {
            type = 'descriptions',
            key = self.key,
            set = set,
            nodes = desc_nodes,
            AUT = full_UI_table,
            vars =
                specific_vars or {}
        }
        local res = {}
        if self.loc_vars and type(self.loc_vars) == 'function' then
            res = self:loc_vars(info_queue, card) or {}
            target.vars = res.vars or target.vars
            target.key = res.key or target.key
            target.set = res.set or target.set
            target.scale = res.scale
            target.text_colour = res.text_colour
        end
        if desc_nodes == full_UI_table.main and not full_UI_table.name then
            full_UI_table.name = self.set == 'Enhanced' and 'temp_value' or localize { type = 'name', set = target.set, key = res.name_key or target.key, nodes = full_UI_table.name, vars = res.name_vars or target.vars or {} }
        elseif desc_nodes ~= full_UI_table.main and not desc_nodes.name and self.set ~= 'Enhanced' then
            desc_nodes.name = localize{type = 'name_text', key = res.name_key or target.key, set = target.set }
        end
        if specific_vars and specific_vars.debuffed and not res.replace_debuff then
            target = { type = 'other', key = 'debuffed_' ..
            (specific_vars.playing_card and 'playing_card' or 'default'), nodes = desc_nodes, AUT = full_UI_table, }
        end
        if res.main_start then
            desc_nodes[#desc_nodes + 1] = res.main_start
        end
        localize(target)
        if res.main_end then
            desc_nodes[#desc_nodes + 1] = res.main_end
        end
        desc_nodes.background_colour = res.background_colour
    end
}

SMODS.Sticker {
    key = 'darkroomed',
    rate = 0,
    pos = { x = 10, y = 0 },
    colour = HEX '97F1EF',
    badge_colour = HEX '97F1EF',
    should_apply = function(self, card, center, area)
        local valid = false
        for i = 1, #G.jokers.cards do
            if G.jokers.cards[i] and G.jokers.cards[i].config and (G.jokers.cards[i].config.center.key == 'j_bp_darkroom') and not G.jokers.cards[i].debuff and not G.jokers.cards[i].ability.bp_sheltered then
                valid = true
                break
            end
        end
        if not valid then
            return
        end
        return (area == G.shop_jokers) and (card.ability.set == 'Joker')
    end,
    loc_txt = {
        name = "",
        text = {
            "",
        },
        label = ""
    },
}

SMODS.DraftJoker {
    key = 'gallery',
    name = "Gallery",
    loc_txt = {
        name = "Gallery",
        text = {
            "When {C:attention}Blind{} is {C:attention}selected{}, Assign",
            "{C:attention}5{} Jokers {C:attention}5{} letters. At {C:attention}end{} of",
            "{C:attention}round{}, Gains {C:red}+#1#{} Mult if letters",
            "spell {C:blue}\"THINK\"{} for all hands",
            "this round.",
            "{C:inactive}(Currently {C:red}+#2#{C:inactive} Mult)"
        }
    },
    config = {mult = 0, mod_mult = 8, all_hands = false},
    atlas = 'bpjokers',
    pos = {x = 5, y = 0},
    rarity = 2,
    cost = 6,
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.mod_mult, card.ability.mult}}
    end,
    bp_include_pools = {"Draft", "Blue"},
    calculate = function(self, card, context)
        if context.end_of_round and context.main_eval and not context.blueprint then
            for i = 1, #G.jokers.cards do
                G.jokers.cards[i].ability.bp_gallery_T = nil
                G.jokers.cards[i].ability.bp_gallery_H = nil
                G.jokers.cards[i].ability.bp_gallery_I = nil
                G.jokers.cards[i].ability.bp_gallery_N = nil
                G.jokers.cards[i].ability.bp_gallery_K = nil
            end 
            if card.ability.all_hands then
                card.ability.mult = card.ability.mult + card.ability.mod_mult
                return {
                    message = localize('k_upgrade_ex'),
                    colour = G.C.MULT
                }
            end
        elseif context.setting_blind and not card.getting_sliced and not context.blueprint then
            local pool = {}
            card.ability.all_hands = true
            for i = 1, #G.jokers.cards do
                G.jokers.cards[i].ability.bp_gallery_T = nil
                G.jokers.cards[i].ability.bp_gallery_H = nil
                G.jokers.cards[i].ability.bp_gallery_I = nil
                G.jokers.cards[i].ability.bp_gallery_N = nil
                G.jokers.cards[i].ability.bp_gallery_K = nil
                if not G.jokers.cards[i].getting_sliced then
                    table.insert(pool, G.jokers.cards[i])
                end
            end
            if #pool >= 5 then
                local selected = {}
                for i = 1, 5 do
                    local card_, key_ = pseudorandom_element(pool, pseudoseed('gal'))
                    table.insert(selected, card_)
                    table.remove(pool, key_)
                end
                selected[1].ability.bp_gallery_T = true
                selected[2].ability.bp_gallery_H = true
                selected[3].ability.bp_gallery_I = true
                selected[4].ability.bp_gallery_N = true
                selected[5].ability.bp_gallery_K = true
            else
                card_eval_status_text(card, 'jokers', nil, nil, nil, {colour = G.C.SECONDARY_SET.Tarot, message = localize('k_nope_ex')})
            end
        elseif context.before and card.ability.all_hands then
            local word = 'THINK'
            local found = ''
            local valid = false
            for i = 1, #G.jokers.cards do
                for j = 1, #word do
                    if G.jokers.cards[i].ability['bp_gallery_' .. string.sub(word, j, j)] then
                        found = found .. string.sub(word, j, j)
                    end
                end
            end
            if found ~= word then
                card_eval_status_text(card, 'jokers', nil, nil, nil, {colour = G.C.RED, message = found .. '?'})
                card.ability.all_hands = false
            end
        elseif context.joker_main then
            return {
                message = localize{type='variable',key='a_mult',vars={card.ability.mult}},
                mult_mod = card.ability.mult
            }
        end
    end,
}

SMODS.Sticker {
    key = 'gallery_T',
    rate = 0,
    pos = { x = 0, y = 0 },
    atlas = 'gallery_letters',
    colour = HEX 'FFFFFF',
    badge_colour = HEX 'FFFFFF',
    hide_badge = true,
    should_apply = function(self, card, center, area)
        return false
    end,
    loc_txt = {
        name = "T",
        text = {
            "This is",
            "a {C:attention}T{}"
        },
        label = "T"
    },
}

SMODS.Sticker {
    key = 'gallery_H',
    rate = 0,
    pos = { x = 1, y = 0 },
    atlas = 'gallery_letters',
    colour = HEX 'FFFFFF',
    badge_colour = HEX 'FFFFFF',
    hide_badge = true,
    should_apply = function(self, card, center, area)
        return false
    end,
    loc_txt = {
        name = "H",
        text = {
            "This is",
            "a {C:attention}H{}"
        },
        label = "H"
    },
}

SMODS.Sticker {
    key = 'gallery_I',
    rate = 0,
    pos = { x = 2, y = 0 },
    atlas = 'gallery_letters',
    colour = HEX 'FFFFFF',
    badge_colour = HEX 'FFFFFF',
    hide_badge = true,
    should_apply = function(self, card, center, area)
        return false
    end,
    loc_txt = {
        name = "I",
        text = {
            "This is",
            "an {C:attention}I{}"
        },
        label = "I"
    },
}

SMODS.Sticker {
    key = 'gallery_N',
    rate = 0,
    pos = { x = 3, y = 0 },
    atlas = 'gallery_letters',
    colour = HEX 'FFFFFF',
    badge_colour = HEX 'FFFFFF',
    hide_badge = true,
    should_apply = function(self, card, center, area)
        return false
    end,
    loc_txt = {
        name = "N",
        text = {
            "This is",
            "a {C:attention}N{}"
        },
        label = "N"
    },
}

SMODS.Sticker {
    key = 'gallery_K',
    rate = 0,
    pos = { x = 4, y = 0 },
    atlas = 'gallery_letters',
    colour = HEX 'FFFFFF',
    badge_colour = HEX 'FFFFFF',
    hide_badge = true,
    should_apply = function(self, card, center, area)
        return false
    end,
    loc_txt = {
        name = "K",
        text = {
            "This is",
            "a {C:attention}K{}"
        },
        label = "K"
    },
}

SMODS.DraftJoker {
    key = 'parlor',
    name = "Parlor",
    loc_txt = {
        name = "Parlor",
        text = {
            "When {C:attention}Blind{} is {C:attention}selected{}, Assign",
            "{C:attention}3{} Jokers {C:attention}3{} statements, at least",
            "{C:attention}1{} {C:green}true{}, at least {C:attention}1{} {C:red}false{}. {C:attention}1{} Joker",
            "with a {C:attention}statement{} is {C:money}prized{}. At",
            "end of {C:attention}round{}, If {C:attention}leftmost{}",
            "Joker is {C:money}prized{}, Earn {C:money}$#1#{}"
        }
    },
    atlas = 'bpjokers',
    pos = {x = 0, y = 1},
    config = {dollars = 5},
    rarity = 1,
    cost = 5,
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.dollars}}
    end,
    bp_include_pools = {"Draft", "Blue"},
    blueprint_compat = true,
    calc_dollar_bonus = function(self, card)
        for i = 1, #G.jokers.cards do
            G.jokers.cards[i].ability.bp_statement = nil
            G.jokers.cards[i].ability.bp_prize = nil
        end
        local money = nil
        if card.ability.money_hit then
            money = 5
        end
        return money
    end,
    calculate = function(self, card, context)
        if context.end_of_round and context.main_eval and not context.blueprint then
            if not G.jokers.cards[1] or not G.jokers.cards[1].ability.bp_prize then
                for i = 1, #G.jokers.cards do
                    G.jokers.cards[i].ability.bp_statement = nil
                    G.jokers.cards[i].ability.bp_prize = nil
                end
                return {
                    message = localize('k_nope_ex'),
                    colour = G.C.SECONDARY_SET.Tarot
                }
            else
                card.ability.money_hit = true
            end
        elseif context.setting_blind and not card.getting_sliced and not context.blueprint then
            local pool = {}
            card.ability.all_hands = true
            for i = 1, #G.jokers.cards do
                G.jokers.cards[i].ability.bp_statement = nil
                G.jokers.cards[i].ability.bp_prize = nil
                if not G.jokers.cards[i].getting_sliced then
                    table.insert(pool, G.jokers.cards[i])
                end
            end
            if #pool >= 3 then
                local selected = {}
                local keys = {}
                for i = 1, 3 do
                    local card_, key_ = pseudorandom_element(pool, pseudoseed('gal'))
                    table.insert(selected, card_)
                    table.remove(pool, key_)
                    table.insert(keys, card_.config.center.key)
                    card_:juice_up()
                end
                local game, answer = get_parlor_puzzle()
                selected[1].ability.bp_statement = game[1].statement
                selected[2].ability.bp_statement = game[2].statement
                selected[3].ability.bp_statement = game[3].statement
                selected[1].ability.bp_parlor_keys = keys
                selected[2].ability.bp_parlor_keys = keys
                selected[3].ability.bp_parlor_keys = keys
                selected[answer].ability.bp_prize = true
            else
                card_eval_status_text(card, 'jokers', nil, nil, nil, {colour = G.C.SECONDARY_SET.Tarot, message = localize('k_nope_ex')})
            end
        end
    end,
}

SMODS.DraftJoker {
    key = 'kitchen',
    name = "Kitchen",
    loc_txt = {
        name = "Kitchen",
        text = {
            "At {C:attention}end of round{}, Lose",
            "{C:red}$#1#{} and create a {C:attention}Food{}",
            "{C:attention}Joker{}",
        }
    },
    atlas = 'bpjokers',
    pos = {x = 1, y = 1},
    config = {dollars = 4},
    rarity = 2,
    cost = 5,
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.dollars}}
    end,
    bp_include_pools = {"Draft", "Shop"},
    blueprint_compat = true,
    calculate = function(self, card, context)
        if context.end_of_round and context.main_eval and (G.jokers.config.card_limit > (#G.jokers.cards + G.GAME.joker_buffer)) then
            G.GAME.joker_buffer = G.GAME.joker_buffer + 1
            ease_dollars(-4)
            G.E_MANAGER:add_event(Event({
                trigger = 'immediate',
                func = function()
                    local card = create_card('Food', G.jokers, nil, nil, nil, nil, nil, 'kit')
                    card:add_to_deck()
                    G.jokers:emplace(card)
                    G.GAME.joker_buffer = 0
                    return true
                end
            }))
            return {
                message = '-$' .. card.ability.dollars,
                colour = G.C.RED
            }
        end
    end,
}

SMODS.DraftJoker {
    key = 'courtyard',
    name = "Courtyard",
    loc_txt = {
        name = "Courtyard",
        text = {
            "When {C:attention}Boss Blind{} is",
            "selected, create {C:tarot}The{}",
            "{C:tarot}Emperor{}",
            "{C:inactive}(must have room){}"
        }
    },
    atlas = 'bpjokers',
    pos = {x = 2, y = 1},
    config = {},
    rarity = 1,
    cost = 4,
    blueprint_compat = true,
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS['c_emperor']
        return {vars = {}}
    end,
    bp_include_pools = {"Draft", "Green"},
    calculate = function(self, card, context)
        if context.setting_blind and not card.getting_sliced and (G.consumeables.config.card_limit > (#G.consumeables.cards + G.GAME.consumeable_buffer)) and context.blind.boss then
            G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
            G.E_MANAGER:add_event(Event({
                trigger = 'immediate',
                func = function()
                    local card_ = create_card('Tarot', G.consumeables, nil, nil, nil, nil, 'c_emperor', 'cou')
                    card_:add_to_deck()
                    G.consumeables:emplace(card_)
                    G.GAME.consumeable_buffer = 0
                    return true
                end
            }))
            card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('k_plus_tarot'), colour = G.C.PURPLE})
        end
    end,
}

SMODS.DraftJoker {
    key = 'showroom',
    name = "Showroom",
    loc_txt = {
        name = "Showroom",
        text = {
            "At end of {C:attention}shop{}, if you have",
            "{C:money}$200{} or more, create a {C:legendary,E:1}Legendary{}",
            "Joker, {C:red,E:2}self destruct{}, set money to",
            "{C:money}$0{} and {C:red}ban{} {C:attention}Showroom{} this run",
        }
    },
    atlas = 'bpjokers',
    pos = {x = 3, y = 1},
    config = {},
    rarity = 3,
    cost = 10,
    blueprint_compat = true,
    loc_vars = function(self, info_queue, card)
        return {vars = {}}
    end,
    bp_include_pools = {"Draft", "Shop"},
    calculate = function(self, card, context)
        if context.ending_shop and (to_big(G.GAME.dollars) >= to_big(200)) then
            ease_dollars(-G.GAME.dollars)
            G.E_MANAGER:add_event(Event({
                func = function()
                    G.GAME.dollars = to_big(0)
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
                            return true; end})) 
                    return true
                end
            }))
            G.E_MANAGER:add_event(Event({
                trigger = 'immediate',
                func = function()
                    local card_ = create_card('Joker', G.jokers, true, nil, nil, nil, nil, 'bp_sho')
                    card_:add_to_deck()
                    G.jokers:emplace(card_)
                    return true
                end
            }))
            G.GAME.banned_keys['j_bp_showroom'] = true
        end
    end,
}

SMODS.DraftJoker {
    key = 'lavatory',
    name = "Lavatory",
    loc_txt = {
        name = "Lavatory",
        text = {
            "Does nothing",
        }
    },
    atlas = 'bpjokers',
    pos = {x = 4, y = 1},
    config = {},
    rarity = 1,
    cost = 2,
    blueprint_compat = true,
    loc_vars = function(self, info_queue, card)
        return {vars = {}}
    end,
    bp_include_pools = {"Draft", "Red"},
    calculate = function(self, card, context)
        if card.ability.bp_sheltered and context.remove_playing_cards then
            local planets_to_create = math.min(#context.removed, G.consumeables.config.card_limit - (#G.consumeables.cards + G.GAME.consumeable_buffer))
            if planets_to_create > 0 then
                G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + planets_to_create
                G.E_MANAGER:add_event(Event({
                    func = function() 
                        for i = 1, planets_to_create do
                            local card_ = create_card('Planet', G.consumeables, nil, nil, nil, nil, nil, 'cou')
                            card_:add_to_deck()
                            G.consumeables:emplace(card_)
                            G.GAME.consumeable_buffer = 0
                            return true
                        end
                        return true
                end}))   
                card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = localize('k_plus_planet'), colour = G.C.BLUE})
            end
        end
    end,
    generate_ui = function(self, info_queue, card, desc_nodes, specific_vars, full_UI_table)
        if not card then
            card = self:create_fake_card()
        end
        local set = (card and card.ability and card.ability.bp_sheltered) and 'ShelteredJoker' or
        next(SMODS.find_card('j_bp_shelter')) and (card.area ~= G.jokers) and 'MidShelteredJoker' or
        'Joker'
        local target = {
            type = 'descriptions',
            key = self.key,
            set = set,
            nodes = desc_nodes,
            AUT = full_UI_table,
            vars =
                specific_vars or {}
        }
        local res = {}
        if self.loc_vars and type(self.loc_vars) == 'function' then
            res = self:loc_vars(info_queue, card) or {}
            target.vars = res.vars or target.vars
            target.key = res.key or target.key
            target.set = res.set or target.set
            target.scale = res.scale
            target.text_colour = res.text_colour
        end
        if desc_nodes == full_UI_table.main and not full_UI_table.name then
            full_UI_table.name = self.set == 'Enhanced' and 'temp_value' or localize { type = 'name', set = target.set, key = res.name_key or target.key, nodes = full_UI_table.name, vars = res.name_vars or target.vars or {} }
        elseif desc_nodes ~= full_UI_table.main and not desc_nodes.name and self.set ~= 'Enhanced' then
            desc_nodes.name = localize{type = 'name_text', key = res.name_key or target.key, set = target.set }
        end
        if specific_vars and specific_vars.debuffed and not res.replace_debuff then
            target = { type = 'other', key = 'debuffed_' ..
            (specific_vars.playing_card and 'playing_card' or 'default'), nodes = desc_nodes, AUT = full_UI_table, }
        end
        if res.main_start then
            desc_nodes[#desc_nodes + 1] = res.main_start
        end
        localize(target)
        if res.main_end then
            desc_nodes[#desc_nodes + 1] = res.main_end
        end
        desc_nodes.background_colour = res.background_colour
    end
}

SMODS.DraftJoker {
    key = 'shelter',
    name = "Shelter",
    loc_txt = {
        name = "Shelter",
        text = {
            "Remove {C:red}negative{} effects",
            "of the next {C:attention}#1#{} {C:redroom}Red Room{}",
            "{C:attention}Jokers{} obtained"
        }
    },
    atlas = 'bpjokers',
    pos = {x = 5, y = 1},
    config = {uses = 3},
    rarity = 2,
    cost = 6,
    blueprint_compat = true,
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.uses}}
    end,
    bp_include_pools = {"Draft", "Blue"},
    calculate = function(self, card, context)
        if context.card_added then
            if G.localization.descriptions.ShelteredJoker[context.card.config.center.key] and not context.card.ability.bp_sheltered then
                card.ability.uses = card.ability.uses - 1
                context.card.ability.bp_sheltered = true
                if context.card.config.center.key then
                    G.GAME.bp_face_down_shop = (G.GAME.bp_face_down_shop or 0) - 1
                end
                if card.ability.uses <= 0 then
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            G.GAME.dollars = to_big(0)
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
                                    return true; end})) 
                            return true
                        end
                    }))
                else
                    card_eval_status_text(card, 'extra', nil, nil, nil, {message = tostring(card.ability.uses), colour = G.C.FILTER})
                end
            end
        end
    end,
}

SMODS.DraftJoker {
    key = 'terrace',
    name = "Terrace",
    loc_txt = {
        name = "Terrace",
        text = {
            "{C:greenroom}Green Room{} Jokers",
            "in shop are {C:attention}free{}",
        }
    },
    atlas = 'bpjokers',
    pos = {x = 0, y = 2},
    config = {},
    rarity = 2,
    cost = 6,
    blueprint_compat = false,
    loc_vars = function(self, info_queue, card)
        return {vars = {}}
    end,
    bp_include_pools = {"Draft", "Green"},
}

SMODS.DraftJoker {
    key = 'corridor',
    name = "Corridor",
    loc_txt = {
        name = "Corridor",
        text = {
            "Each {C:attention}shop{} has a",
            "{C:attention}Jumbo Buffoon Pack{}",
        }
    },
    atlas = 'bpjokers',
    pos = {x = 1, y = 2},
    rarity = 1,
    cost = 4,
    blueprint_compat = false,
    config = {},
    bp_include_pools = {"Draft", "Hallway"},
    calculate = function(self, card, context)
        if context.starting_shop and not context.blueprint then
            G.GAME.force_jumbo_buffoon = true
        end
    end,
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS['p_buffoon_jumbo_1']
        return {vars = {}}
    end,
}

SMODS.DraftJoker {
    key = 'guest_bedroom',
    name = "Guest Bedroom",
    loc_txt = {
        name = "Guest Bedroom",
        text = {
            "{C:blue}+#1#{} hand for ",
            "{C:attention}#2#{} rounds",
        }
    },
    atlas = 'bpjokers',
    pos = {x = 2, y = 2},
    rarity = 1,
    cost = 4,
    blueprint_compat = false,
    config = {hands = 1, rounds = 10},
    bp_include_pools = {"Draft", "Bedroom"},
    calculate = function(self, card, context)
        if context.end_of_round and context.main_eval and not context.blueprint then
            card.ability.rounds = card.ability.rounds - 1
            if card.ability.rounds <= 0 then
                G.E_MANAGER:add_event(Event({
                    func = function()
                        G.GAME.dollars = to_big(0)
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
                                return true; end})) 
                        return true
                    end
                }))
                card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('k_evicted'), colour = G.C.FILTER})
            else
                card_eval_status_text(card, 'extra', nil, nil, nil, {message = tostring(card.ability.rounds), colour = G.C.FILTER})
            end
        end
    end,
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.hands, card.ability.rounds}}
    end,
    add_to_deck = function(self, card)
        G.GAME.round_resets.hands = G.GAME.round_resets.hands + card.ability.hands
        ease_hands_played(card.ability.hands)
    end,
    remove_from_deck = function(self, card)
        G.GAME.round_resets.hands = G.GAME.round_resets.hands - card.ability.hands
        ease_hands_played(-card.ability.hands)
    end,
}

SMODS.DraftJoker {
    key = 'archives',
    name = "Archives",
    loc_txt = {
        name = "Archives",
        text = {
            "{C:attention}+#1#{} card slot,",
            "{C:attention}+1{} card in {C:attention}shop slots{}",
            "and packs are {C:attention}face down{}"
        }
    },
    atlas = 'bpjokers',
    pos = {x = 3, y = 2},
    rarity = 2,
    cost = 6,
    blueprint_compat = false,
    config = {slots = 1},
    bp_include_pools = {"Draft", "Red"}, 
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.slots}}
    end,
    add_to_deck = function(self, card)
        change_shop_size(card.ability.slots)
        if not card.ability.bp_sheltered then
            G.GAME.bp_face_down_shop = (G.GAME.bp_face_down_shop or 0) + 1
        end
    end,
    remove_from_deck = function(self, card)
        change_shop_size(-card.ability.slots)
        if not card.ability.bp_sheltered then
            G.GAME.bp_face_down_shop = (G.GAME.bp_face_down_shop or 0) - 1
        end
    end,
    generate_ui = function(self, info_queue, card, desc_nodes, specific_vars, full_UI_table)
        if not card then
            card = self:create_fake_card()
        end
        local set = (card and card.ability and card.ability.bp_sheltered) and 'ShelteredJoker' or
        next(SMODS.find_card('j_bp_shelter')) and (card.area ~= G.jokers) and 'MidShelteredJoker' or
        'Joker'
        local target = {
            type = 'descriptions',
            key = self.key,
            set = set,
            nodes = desc_nodes,
            AUT = full_UI_table,
            vars =
                specific_vars or {}
        }
        local res = {}
        if self.loc_vars and type(self.loc_vars) == 'function' then
            res = self:loc_vars(info_queue, card) or {}
            target.vars = res.vars or target.vars
            target.key = res.key or target.key
            target.set = res.set or target.set
            target.scale = res.scale
            target.text_colour = res.text_colour
        end
        if desc_nodes == full_UI_table.main and not full_UI_table.name then
            full_UI_table.name = self.set == 'Enhanced' and 'temp_value' or localize { type = 'name', set = target.set, key = res.name_key or target.key, nodes = full_UI_table.name, vars = res.name_vars or target.vars or {} }
        elseif desc_nodes ~= full_UI_table.main and not desc_nodes.name and self.set ~= 'Enhanced' then
            desc_nodes.name = localize{type = 'name_text', key = res.name_key or target.key, set = target.set }
        end
        if specific_vars and specific_vars.debuffed and not res.replace_debuff then
            target = { type = 'other', key = 'debuffed_' ..
            (specific_vars.playing_card and 'playing_card' or 'default'), nodes = desc_nodes, AUT = full_UI_table, }
        end
        if res.main_start then
            desc_nodes[#desc_nodes + 1] = res.main_start
        end
        localize(target)
        if res.main_end then
            desc_nodes[#desc_nodes + 1] = res.main_end
        end
        desc_nodes.background_colour = res.background_colour
    end
}

SMODS.DraftJoker {
    key = 'servants_quarters',
    name = "Servant's Quarters",
    loc_txt = {
        name = "Servant's Quarters",
        text = {
            "{C:red}+1{} discard per round",
            "per owned {C:bedroom}Bedroom{}",
            "{C:inactive}({C:red}+#1#{C:inactive} Discards Currently)"
        }
    },
    atlas = 'bpjokers',
    pos = {x = 4, y = 2},
    rarity = 2,
    cost = 6,
    blueprint_compat = false,
    config = {bedroom_tally = 0},
    bp_include_pools = {"Draft", "Bedroom"}, 
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.bedroom_tally}}
    end,
}

SMODS.DraftJoker {
    key = 'commissary',
    name = "Commissary",
    loc_txt = {
        name = "Commissary",
        text = {
            "Lose {C:red}$3{} and create a {C:tarot}Tarot{}",
            "card per {C:attention}reroll{} in the shop",
            "{C:inactive}(must have room){}"
        }
    },
    atlas = 'bpjokers',
    pos = {x = 5, y = 2},
    rarity = 1,
    cost = 4,
    blueprint_compat = true,
    config = {},
    bp_include_pools = {"Draft", "Shop"}, 
    loc_vars = function(self, info_queue, card)
        return {vars = {}}
    end,
    calculate = function(self, card, context)
        if context.reroll_shop and (G.consumeables.config.card_limit > (#G.consumeables.cards + G.GAME.consumeable_buffer)) then
            G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
            ease_dollars(-3)
            G.E_MANAGER:add_event(Event({
                trigger = 'immediate',
                func = function()
                    local card_ = create_card('Tarot', G.consumeables, nil, nil, nil, nil, nil, 'cou')
                    card_:add_to_deck()
                    G.consumeables:emplace(card_)
                    G.GAME.consumeable_buffer = 0
                    return true
                end
            }))
        end
    end,
}

SMODS.DraftJoker {
    key = 'chamber_of_mirrors',
    name = "Chamber of Mirrors",
    loc_txt = {
        name = "Chamber of Mirrors",
        text = {
            "{C:attention}Jokers{} need to be present",
            "an {C:attention}additional time{} to be",
            "{C:red}removed{} from the {C:attention}pool{}",
        }
    },
    atlas = 'bpjokers',
    pos = {x = 0, y = 3},
    rarity = 2,
    cost = 6,
    blueprint_compat = false,
    config = {},
    bp_include_pools = {"Draft", "Blue"}, 
    loc_vars = function(self, info_queue, card)
        return {vars = {}}
    end,
}

SMODS.DraftJoker {
    key = 'tunnel',
    name = "Tunnel",
    loc_txt = {
        name = "Tunnel",
        text = {
            "When {C:attention}Obtained{}, Adds {C:attention}Tunnel{} to the",
            "{C:attention}Joker Pool{}, adjacent {C:attention}Tunnels{} give",
            "{X:mult,C:white} X#1# {} Mult for each {C:attention}Tunnel{}",
            "{C:inactive}(Currently {X:mult,C:white} X#2# {C:inactive} Mult)",
        }
    },
    atlas = 'bpjokers',
    pos = {x = 1, y = 3},
    rarity = 3,
    cost = 8,
    blueprint_compat = true,
    config = {mod_x_mult = 1, tunnel_tally = 0},
    bp_include_pools = {"Draft", "Hallway"}, 
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.mod_x_mult, 1 + (card.ability.mod_x_mult * card.ability.tunnel_tally)}}
    end,
    calculate = function(self, card, context)
        if context.other_joker then
            local index = nil
            for i = 1, #G.jokers.cards do
                if G.jokers.cards[i] == (context.blueprint_card) then
                    index = i
                end
            end
            if index and (card.ability.tunnel_tally >= 1) and ((context.other_joker == G.jokers.cards[index - 1]) or (context.other_joker == G.jokers.cards[index + 1])) and context.other_joker.config and (context.other_joker.config.center.key == 'j_bp_tunnel') then
                G.E_MANAGER:add_event(Event({
                    func = function()
                        context.other_joker:juice_up(0.5, 0.5)
                        return true
                    end
                })) 
                return {
                    extra = {focus = context.other_joker, message = localize{type='variable',key='a_xmult',vars={1 + (card.ability.mod_x_mult * card.ability.tunnel_tally)}}, colour = G.C.MULT, sound = 'multhit2'},
                    Xmult_mod = 1 + (card.ability.mod_x_mult * card.ability.tunnel_tally)
                }
            end
        end
    end,
    add_to_deck = function(self, card, from_debuff)
        if not from_debuff then
            bp_add_to_pool('j_bp_tunnel', 'Joker', 1, 3)
            play_area_status_text(localize{type = 'name_text', key = 'j_bp_tunnel', set = 'Joker'} .." added to Joker Pool!")
        end
    end,
}

function reset_archive_slots(shop, pack)
    if shop and ((G.GAME.bp_face_down_shop or 0) > 0) then
        G.GAME.bp_shop_face_down = {}
        local pool = {}
        for i = 1, G.GAME.shop.joker_max do
            table.insert(pool, i)
        end
        for i = 1, (G.GAME.bp_face_down_shop or 0) do
            local face_down, key = pseudorandom_element(pool, pseudoseed('arc'))
            table.remove(pool, key)
            G.GAME.bp_shop_face_down[face_down] = true
        end
    end
    if pack and ((G.GAME.bp_face_down_shop or 0) > 0) then
        G.GAME.bp_pack_face_down = {}
        local pool = {}
        for i = 1, pack do
            table.insert(pool, i)
        end
        for i = 1, (G.GAME.bp_face_down_shop or 0) do
            local face_down, key = pseudorandom_element(pool, pseudoseed('arc'))
            table.remove(pool, key)
            G.GAME.bp_pack_face_down[face_down] = true
        end
    end
    if (G.GAME.bp_face_down_shop or 0) == 0 then
        G.GAME.bp_pack_face_down = {}
        G.GAME.bp_shop_face_down = {}
    end
end

function force_face_down(card)
    if card.ability.bp_darkroomed and (card.area == G.shop_jokers) then
        return true
    end
    if G.shop_jokers and (card.area == G.shop_jokers) and G.GAME.bp_shop_face_down and (card.bp_archive_cleared == nil) then
        local index = nil
        for i = 1, #G.shop_jokers.cards do
            if G.shop_jokers.cards[i] == card then
                index = i
            end
        end
        if G.GAME.bp_shop_face_down[index] then
            card.bp_archive_cleared = true
            return true
        end
        if index then
            card.bp_archive_cleared = false
        end
    end
    if G.pack_cards and (card.area == G.pack_cards) and G.GAME.bp_pack_face_down and (card.bp_archive_cleared == nil) then
        local index = nil
        for i = 1, #G.pack_cards.cards do
            if G.pack_cards.cards[i] == card then
                index = i
            end
        end
        if G.GAME.bp_pack_face_down[index] then
            card.bp_archive_cleared = true
            return true
        end
        if index then
            card.bp_archive_cleared = false
        end
    end
end

function rand_puzzle()
    local formats = {
        'prize',
        'empty1',
        'empty2',
        'true2',
        'lie2',
        'support',
        'accuse',
    }
    local boxdata = {}
    for i = 1, 3 do
        local format_ = formats[pseudorandom(pseudoseed('bp_prize'),1, #formats)]
        if format_ == 'prize' then
            table.insert(boxdata, {
              statement = {
                main = 'prize',
                args = {pseudorandom(pseudoseed('bp_prize'),1, 3)}
              },
            })
        elseif format_ == 'empty1' then
            table.insert(boxdata, {
              statement = {
                main = 'empty',
                args = {pseudorandom(pseudoseed('bp_prize'),1, 3)}
              },
            })
        elseif format_ == 'empty2' then
            local rand = pseudorandom(pseudoseed('bp_prize'),1, 3)
            local set = {}
            for j = 1, 3 do
                if j ~= rand then
                    table.insert(set, j)
                end
            end
            table.insert(boxdata, {
              statement = {
                main = 'empty',
                args = set
              },
            })
        elseif format_ == 'true2' then
            table.insert(boxdata, {
              statement = {
                main = 'two_true',
                args = {}
              },
            })
        elseif format_ == 'lie2' then
            table.insert(boxdata, {
              statement = {
                main = 'two_false',
                args = {}
              },
            })
        elseif format_ == 'support' then
            table.insert(boxdata, {
              statement = {
                main = 'truther',
                args = {pseudorandom(pseudoseed('bp_prize'),1, 3)}
              },
            })
        elseif format_ == 'accuse' then
            table.insert(boxdata, {
              statement = {
                main = 'liar',
                args = {pseudorandom(pseudoseed('bp_prize'),1, 3)}
              },
            })
        elseif format_ == 'TRUE' then
            table.insert(boxdata, {
              statement = {
                main = 'TRUE',
                args = {}
              },
            })
        elseif format_ == 'FALSE' then
            table.insert(boxdata, {
              statement = {
                main = 'FALSE',
                args = {}
              },
            })
        end
    end
    for i = 1, 3 do
        local str = ''
        str = str .. boxdata[i].statement.main
        for j = 1, #boxdata[i].statement.args do
            if j == 1 then
                str = str .. ' '
            end
            str = str .. tostring(boxdata[i].statement.args[j]) .. ', '
        end
    end
    return boxdata
end

function verify_statement(boxdata, box, presumes)
    local statement = boxdata[box].statement
    if statement.main == 'prize' then
        return (statement.args[1] == presumes.prize)
    elseif statement.main == 'empty' then
        for i = 1, #statement.args do
            if (statement.args[i] == presumes.prize) then
                return false
            end
        end
        return true
    elseif statement.main == 'two_true' then
        local truths = 0
        for i = 1, #boxdata do
            if presumes[i] then
                truths = truths + 1
            end
        end
        return (truths == 2)
    elseif statement.main == 'two_false' then
        local lies = 0
        for i = 1, #boxdata do
            if not presumes[i] then
                lies = lies + 1
            end
        end
        return (lies == 2)
    elseif statement.main == 'truther' then
        return presumes[statement.args[1]]
    elseif statement.main == 'liar' then
        return not presumes[statement.args[1]]
    elseif statement.main == 'TRUE' then
        return true
    elseif statement.main == 'FALSE' then
        return false
    end
end

function verify_statements(boxdata)
    local states = {
        {true, true, false, prize = 1},
        {true, false, true, prize = 1},
        {false, true, true, prize = 1},
        {false, true, false, prize = 1},
        {true, false, false, prize = 1},
        {false, false, true, prize = 1},
        {true, true, false, prize = 2},
        {true, false, true, prize = 2},
        {false, true, true, prize = 2},
        {false, true, false, prize = 2},
        {true, false, false, prize = 2},
        {false, false, true, prize = 2},
        {true, true, false, prize = 3},
        {true, false, true, prize = 3},
        {false, true, true, prize = 3},
        {false, true, false, prize = 3},
        {true, false, false, prize = 3},
        {false, false, true, prize = 3},
    }
    local gem = nil
    local valids = 0
    for i = 1, #states do
        local states_next = {}
        local valid = true
        for j = 1, 3 do
            table.insert(states_next, verify_statement(boxdata, j, states[i]))
            if states_next[j] ~= states[i][j] then
                valid = false
            end
        end
        if valid then
            valids = valids + 1
            local prizes = {false, false, false}
            local duds = {false, false, false}
            for j = 1, 3 do
                if boxdata[j].statement.main == 'prize' then
                    local place = boxdata[j].statement.args[1]
                    if states[i][j] then
                        prizes[place] = true
                    else
                        duds[place] = true
                    end
                elseif (boxdata[j].statement.main == 'empty') and states[i][j] then
                    for k = 1, #boxdata[j].statement.args do
                        local place = boxdata[j].statement.args[k]
                        duds[place] = true
                    end
                elseif (boxdata[j].statement.main == 'empty') and not states[i][j] then
                    if #boxdata[j].statement.args == 1 then
                        local place = boxdata[j].statement.args[1]
                        prizes[place] = true
                    elseif #boxdata[j].statement.args == 2 then
                        local place = nil
                        for k = 1, 3 do
                            if (k ~= boxdata[j].statement.args[1]) and (k ~= boxdata[j].statement.args[2]) then
                                place = k
                                break
                            end
                        end
                        duds[place] = true
                    end
                end
            end
            local still_valid = true
            local prize_count = 0
            local dud_count = 0
            for j = 1, 3 do
                if prizes[j] and duds[j] then
                    still_valid = false
                elseif prizes[j] and not duds[j] then
                    prize_count = prize_count + 1
                elseif not prizes[j] and duds[j] then
                    dud_count = dud_count + 1
                end
            end
            if prize_count > 1 then
                still_valid = false
            end
            if dud_count >= 3 then
                still_valid = false
            end
            if still_valid then
                if (prize_count == 0) and (dud_count <= 1) then
                    return false
                end
                local local_gem = nil
                if prize_count == 1 then
                    for j = 1, 3 do
                        if prizes[j] then
                            local_gem = j
                            break
                        end
                    end
                elseif dud_count == 2 then
                    for j = 1, 3 do
                        if not duds[j] then
                            local_gem = j
                            break
                        end
                    end
                end
                if not gem then
                    gem = local_gem
                end
                if (gem ~= local_gem) or (local_gem ~= states[i].prize) then
                    return false
                end
            else
                valids = valids - 1
            end
        end
    end
    if valids == 0 then
        return false
    end
    return true, gem
end

function get_parlor_puzzle()
    local gem_ = 2
    local tries = 0
    local puzzle = nil
    while tries < 100 do
        tries = tries + 1
        puzzle = rand_puzzle()
        local valid, gem = verify_statements(puzzle)
        if valid then
            gem_ = gem
            break
        end
    end
    if not puzzle then
        puzzle = {
            {
                statement = {
                    main = 'prize',
                    args = {1}
                },
            },
            {
                statement = {
                    main = 'two_false',
                    args = {}
                },
            },
            {
                statement = {
                    main = 'prize',
                    args = {3}
                },
            },
        }
    end
    return puzzle, gem_
end

function do_pre_experiment_effect(effect)
    if effect == 'upgrade_3_hands' then
        if G.STATE == G.STATES.PLAY_TAROT then
            bp_prev_state = G.TAROT_INTERRUPT or G.STATE
        else
            bp_prev_state = G.STATE
            -- G.TAROT_INTERRUPT = G.STATE
        end
        G.STATE = (G.STATE == G.STATES.TAROT_PACK and G.STATES.TAROT_PACK) or
        (G.STATE == G.STATES.PLANET_PACK and G.STATES.PLANET_PACK) or
        (G.STATE == G.STATES.SPECTRAL_PACK and G.STATES.SPECTRAL_PACK) or
        (G.STATE == G.STATES.STANDARD_PACK and G.STATES.STANDARD_PACK) or
        (G.STATE == G.STATES.SMODS_BOOSTER_OPENED and G.STATES.SMODS_BOOSTER_OPENED) or
        (G.STATE == G.STATES.BUFFOON_PACK and G.STATES.BUFFOON_PACK) or
        G.STATES.PLAY_TAROT
        
        G.CONTROLLER.locks.use = true
    elseif effect == 'create_joker' then
        if #G.jokers.cards + G.GAME.joker_buffer < G.jokers.config.card_limit then
            G.GAME.joker_buffer = (G.GAME.joker_buffer or 0) + 1
            return true
        end
        return false
    elseif effect == 'use_wheel_of_fortune' then
        if #G.play.cards ~= 0 then
            G.GAME.bp_play_buffered = true
        end
        for i, j in ipairs(G.jokers.cards) do
            if (j.ability.set == 'Joker') and (not j.edition) then
                return true
            end
        end
        return false
    elseif effect == 'randomly_each_round' then
        if not G.GAME.current_round.random_this_round_active then
            G.GAME.current_round.random_this_round_active = true
        else
            return false
        end
    end
    return true
end

bp_force_immeditely = nil

function do_experiment_effect(effect)
    if effect == 'earn_5_dollars' then
        ease_dollars(5)
    elseif effect == 'upgrade_3_hands' then
        local pool = {}
        for i, j in pairs(G.GAME.hands) do
            if j.visible then
                table.insert(pool, i)
            end
        end
        table.sort(pool)
        for i = 1, 3 do
            local old_hand = G.GAME.current_round.current_hand.handname
            local new_hand, key = pseudorandom_element(pool, pseudoseed('exp_upgrade'))
            table.remove(pool, key)
            update_hand_text({sound = 'button', volume = 0.7, pitch = 0.8, delay = 0.3}, {handname=localize(new_hand, 'poker_hands'),chips = G.GAME.hands[new_hand].chips, mult = G.GAME.hands[new_hand].mult, level=G.GAME.hands[new_hand].level})
            level_up_hand(nil, new_hand, nil, 1)
            if G.GAME.hands[old_hand] then
                update_hand_text({sound = 'button', volume = 0.7, pitch = 1.1, delay = 0}, {handname=localize(old_hand, 'poker_hands'),chips = G.GAME.hands[old_hand].chips, mult = G.GAME.hands[old_hand].mult, level=G.GAME.hands[old_hand].level})
            else
                update_hand_text({sound = 'button', volume = 0.7, pitch = 1.1, delay = 0}, {mult = 0, chips = 0, handname = '', level = ''})
            end
        end
        G.STATE = (G.STATE == G.STATES.TAROT_PACK and G.STATES.TAROT_PACK) or
        (G.STATE == G.STATES.PLANET_PACK and G.STATES.PLANET_PACK) or
        (G.STATE == G.STATES.SPECTRAL_PACK and G.STATES.SPECTRAL_PACK) or
        (G.STATE == G.STATES.STANDARD_PACK and G.STATES.STANDARD_PACK) or
        (G.STATE == G.STATES.SMODS_BOOSTER_OPENED and G.STATES.SMODS_BOOSTER_OPENED) or
        (G.STATE == G.STATES.BUFFOON_PACK and G.STATES.BUFFOON_PACK) or
        bp_prev_state
        if G.TAROT_INTERRUPT then
            G.TAROT_INTERRUPT = bp_prev_state
        end
        G.E_MANAGER:add_event(Event({
            trigger = 'immediate',
            func = function()
                if G.TAROT_INTERRUPT then
                    G.E_MANAGER:add_event(Event({
                        trigger = 'immediate',
                        func = function()
                            G.STATE = bp_prev_state
                            bp_prev_state = nil
                            return true
                        end
                    })) 
                else
                    bp_prev_state = nil
                end
                G.TAROT_INTERRUPT = nil
                G.CONTROLLER.locks.use = nil
                return true
            end
        }))
    elseif effect == 'create_negative_immediately_experiment' then
        bp_force_immeditely = true
        local card = create_card('Experiment',G.consumeables, nil, nil, nil, nil, 'c_bp_experiment', 'exp')
        card:set_edition({negative = true}, true)
        card:add_to_deck()
        G.consumeables:emplace(card)
    elseif effect == 'create_joker' then
        local card = create_card('Joker',G.jokers, nil, nil, nil, nil, nil, 'exp')
        card:add_to_deck()
        G.jokers:emplace(card)
        G.GAME.joker_buffer = 0
    elseif effect == 'use_wheel_of_fortune' then
        G.E_MANAGER:add_event(Event({
            trigger = 'immediate',
            func = function()
                local eligible_strength_jokers = {}
                for k, v in pairs(G.jokers.cards) do
                    if v.ability.set == 'Joker' and (not v.edition) then
                        table.insert(eligible_strength_jokers, v)
                    end
                end
                if #eligible_strength_jokers == 0 then
                    return true
                end
                if not G.GAME.bp_play_buffered and (#G.play.cards == 0) then
                    local card = create_card('Tarot',G.play, nil, nil, nil, nil, 'c_wheel_of_fortune', 'exp')
                    card.eligible_strength_jokers = EMPTY(card.eligible_strength_jokers)
                    for k, v in pairs(G.jokers.cards) do
                        if v.ability.set == 'Joker' and (not v.edition) then
                            table.insert(card.eligible_strength_jokers, v)
                        end
                    end
                    G.play:emplace(card)
                    G.GAME.bp_play_buffered = nil
                    card:use_consumeable(G.play)
                    G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.2,
                        func = function()
                            card:start_dissolve()
                            return true
                        end
                    }))
                else
                    local card = create_card('Tarot',G.consumeables, nil, nil, nil, nil, 'c_wheel_of_fortune', 'exp')
                    card.eligible_strength_jokers = EMPTY(card.eligible_strength_jokers)
                    for k, v in pairs(G.jokers.cards) do
                        if v.ability.set == 'Joker' and (not v.edition) then
                            table.insert(card.eligible_strength_jokers, v)
                        end
                    end
                    G.consumeables:emplace(card)
                    card:use_consumeable(G.consumeables)
                    G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.2,
                        func = function()
                            card:start_dissolve()
                            return true
                        end
                    }))
                end
                return true
            end
        }))
    elseif effect == '2_percent_probabilities' then
        G.GAME.probabilities.normal = G.GAME.probabilities.normal * 1.02
        G.GAME.probabilities.normal = math.floor(G.GAME.probabilities.normal * 100) / 100
    elseif effect == 'add_last_used_tarot_to_pool' then
        if G.GAME.last_tarot then
            local center = G.P_CENTERS[G.GAME.last_tarot]
            bp_add_to_pool(G.GAME.last_tarot, 'Tarot', 1)
            play_area_status_text(localize{type = 'name_text', key = center.key, set = center.set} .." added to Tarot Pool!")
        end
    elseif effect == 'reroll_tags' then
        reroll_skip_tags()
    elseif effect == 'smg_special' then
        bp_add_to_pool('j_bp_aquarium', 'Joker', 3, 3)
        play_area_status_text('3 ' .. localize{type = 'name_text', key = 'j_bp_aquarium', set = 'Joker'} .."s have been added to the Joker Pool!")
    end
end

local old_calculate_context = SMODS.calculate_context
function SMODS.calculate_context(context, return_table)
    if context.remove_playing_cards then
        for i = 1, #context.removed do
            if (G.GAME.bp_experiment_cause == 'destroy_enhanced_playing_card') and context.removed[i] and context.removed[i].config.center and context.removed[i].config.center.key ~= 'c_base' then
                if do_pre_experiment_effect(G.GAME.bp_experiment_effect) then  
                    local effect = G.GAME.bp_experiment_effect
                    G.E_MANAGER:add_event(Event({
                        trigger = 'immediate',
                        func = function()
                            do_experiment_effect(effect)
                            return true
                        end
                    }))
                end
            end
        end
    end
    return old_calculate_context(context, return_table)
end

function SMODS.current_mod.reset_game_globals(run_start)
    G.GAME.current_round.random_this_round_active = false
    local pool = {}
    if run_start then
        pool = {'first_hand', 'rand_hand'}
    else
        pool = {'cash_out', 'end_shop', 'first_hand', 'rand_hand'}
    end
    G.GAME.current_round.random_activation = pseudorandom_element(pool, pseudoseed('round'))
end

bp_ignore_prescence_cards = {}
bp_pool_rarity = nil

local old_showman = SMODS.showman
function SMODS.showman(card_key)
    if bp_force_showman or bp_force_showman2 then
        return true
    end
    return old_showman(card_key)
end

local old_poll_rarity = SMODS.poll_rarity
function SMODS.poll_rarity(_pool_key, _rand_key)
    local result = old_poll_rarity(_pool_key, _rand_key)
    bp_pool_rarity = result
    return result
end

local old_indiv_effect = SMODS.calculate_individual_effect
function SMODS.calculate_individual_effect(effect, scored_card, key, amount, from_edition)
    local result_main = old_indiv_effect(effect, scored_card, key, amount, from_edition)

    if (key == 'bp_extras') and amount and (#amount > 0) then
        local result = nil
        for i = 1, #amount do
            local part = SMODS.calculate_effect(amount[i], scored_card)
            if part == true then
                result = true
            end
        end
        return result
    end

    return result_main
end

table.insert(SMODS.calculation_keys, 'bp_extras')

local old_pool = get_current_pool
function get_current_pool(_type, _rarity, _legendary, _append)
    bp_force_showman = true 
    bp_ignore_prescence_cards = {}
    bp_pool_rarity = nil
    local pool, key = old_pool(_type, _rarity, _legendary, _append)
    bp_force_showman = nil
    if (_legendary == true) and (_type == 'Joker') then
        bp_pool_rarity = nil
    end
    local pool_key = _type .. '_' .. (bp_pool_rarity or 'Common') .. (_legendary and '_leg' or '')
    if G.GAME.bp_pool_addons and G.GAME.bp_pool_addons[pool_key] then
        for i = 1, #G.GAME.bp_pool_addons[pool_key] do
            if not G.GAME.banned_keys[G.GAME.bp_pool_addons[pool_key][i]] then
                table.insert(pool, G.GAME.bp_pool_addons[pool_key][i])
            end
        end
    end
    local chambers = 0
    if G.jokers and G.jokers.cards then
        for i = 1, #G.jokers.cards do
            if G.jokers.cards[i] and G.jokers.cards[i].config and (G.jokers.cards[i].config.center.key == 'j_bp_chamber_of_mirrors') and not G.jokers.cards[i].debuff then
                chambers = chambers + 1
                break
            end
        end
    end
    if (_type ~= 'Joker') and (_type ~= 'Draft') and (_type ~= "Blue") and (_type ~= "Green") and (_type ~= "Black") and (_type ~= "Red") and (_type ~= "Bedroom") and (_type ~= "Hallway") and (_type ~= "Shop") and (_type ~= "Food") then
        chambers = 0
    end
    if (_type ~= 'Enhanced') and (_type ~= 'Edition') and (_type ~= 'Demo') and (_type ~= 'Tag') then
        local prescence = copy_table(G.GAME.bp_prescence or {})
        local removal = copy_table(G.GAME.bp_pool_removals and G.GAME.bp_pool_removals[pool_key] or {})
        for i = #pool, 1, -1 do
            if prescence[pool[i]] and (prescence[pool[i]] > chambers) and not (SMODS.showman(pool[i]) or bp_ignore_prescence_cards[pool[i]]) then
                prescence[pool[i]] = prescence[pool[i]] - 1 - chambers
                if prescence[pool[i]] <= 0 then
                    prescence[pool[i]] = nil
                end
                pool[i] = 'UNAVAILABLE'
            else
                for j = #removal, 1, -1 do
                    if removal[j] == pool[i] then
                        pool[i] = 'UNAVAILABLE'
                        table.remove(removal, j)
                        break
                    end
                end
            end
        end
    end
    local pool_size = 0
    for i = 1, #pool do
        if pool[i] ~= 'UNAVAILABLE' then
            pool_size = pool_size + 1
        end
    end
    if pool_size == 0 then
        pool = {}
        if SMODS.ObjectTypes[_type] and SMODS.ObjectTypes[_type].default and G.P_CENTERS[SMODS.ObjectTypes[_type].default] then
            pool[#pool+1] = SMODS.ObjectTypes[_type].default
        elseif _type == 'Tarot' or _type == 'Tarot_Planet' then pool[#pool + 1] = "c_strength"
        elseif _type == 'Planet' then pool[#pool + 1] = "c_pluto"
        elseif _type == 'Spectral' then pool[#pool + 1] = "c_incantation"
        elseif _type == 'Joker' then pool[#pool + 1] = "j_joker"
        elseif _type == 'Draft' then pool[#pool + 1] = "j_bp_gallery"
        elseif _type == 'Blue' then pool[#pool + 1] = "j_bp_parlor"
        elseif _type == 'Bedroom' then pool[#pool + 1] = "j_bp_bedroom"
        elseif _type == 'Red' then pool[#pool + 1] = "j_bp_lavatory"
        elseif _type == 'Hallway' then pool[#pool + 1] = "j_bp_hallway"
        elseif _type == 'Shop' then pool[#pool + 1] = "j_bp_comissary"
        elseif _type == 'Green' then pool[#pool + 1] = "j_bp_courtyard"
        elseif _type == 'Black' then pool[#pool + 1] = "j_bp_aquarium"
        elseif _type == 'Edition' then pool[#pool + 1] = "e_foil"
        elseif _type == 'Demo' then pool[#pool + 1] = "j_joker"
        elseif _type == 'Voucher' then pool[#pool + 1] = "v_blank"
        elseif _type == 'Tag' then pool[#pool + 1] = "tag_handy"
        elseif _type == 'Food' then pool[#pool + 1] = "j_gros_michel"
        else pool[#pool + 1] = "j_joker"
        end
    end
    return pool, key
end

local old_get_pack = get_pack
function get_pack(_key, _type)
    if (_key == 'shop_pack') and G.GAME.force_jumbo_buffoon and (G.GAME.first_shop_buffoon or G.GAME.banned_keys['p_buffoon_normal_1']) then
        if not G.GAME.banned_keys['p_buffoon_jumbo_1'] and ((_type == nil) or (_type == 'Joker')) then
            G.GAME.force_jumbo_buffoon = nil
            return G.P_CENTERS['p_buffoon_jumbo_1']
        end
    end
    return old_get_pack(_key, _type)
end

function bp_add_to_pool(key, type, amount, rarity, legendary)
    if (type == 'Joker') and G.P_CENTERS[key] and G.P_CENTERS[key].bp_include_pools then
        for i = 1, #G.P_CENTERS[key].bp_include_pools do
            bp_add_to_pool(key, G.P_CENTERS[key].bp_include_pools[i], amount, rarity, legendary)
        end
    end
    amount = amount or 1
    local pool_key = type .. '_' .. (rarity or 'Common') .. (legendary and '_leg' or '')
    if not G.GAME.bp_pool_addons then
        G.GAME.bp_pool_addons = {}
    end
    if not G.GAME.bp_pool_addons[pool_key] then
        G.GAME.bp_pool_addons[pool_key] = {}
    end
    if not G.GAME.bp_pool_removals then
        G.GAME.bp_pool_removals = {}
    end
    if not G.GAME.bp_pool_removals[pool_key] then
        G.GAME.bp_pool_removals[pool_key] = {}
    end
    if amount > 0 then
        if G.GAME.bp_pool_removals[pool_key] then
            local i = #G.GAME.bp_pool_removals[pool_key]
            while (i >= 1) and (amount > 0) do
                if G.GAME.bp_pool_removals[pool_key][i] == key then
                    table.remove(G.GAME.bp_pool_removals[pool_key], i)
                    amount = amount - 1
                end
                i = i - 1
            end
        end
    elseif amount < 0 then
        if G.GAME.bp_pool_addons[pool_key] then
            local i = #G.GAME.bp_pool_addons[pool_key]
            while (i >= 1) and (amount < 0) do
                if G.GAME.bp_pool_addons[pool_key][i] == key then
                    table.remove(G.GAME.bp_pool_addons[pool_key], i)
                    amount = amount + 1
                end
                i = i - 1
            end
        end
    end
    if amount > 0 then
        for i = 1, amount do
            table.insert(G.GAME.bp_pool_addons[pool_key], key)
        end
    elseif amount < 0 then
        for i = 1, -amount do
            table.insert(G.GAME.bp_pool_removals[pool_key], key)
        end
    end
end

function update_prescence(key, amount)
    if key == 'c_base' then
        return
    end
    if G.GAME and not G.GAME.bp_prescence then
        G.GAME.bp_prescence = {}
    end
    if not G.GAME then
        return
    end
    if G.GAME.bp_prescence[key] then
        G.GAME.bp_prescence[key] = G.GAME.bp_prescence[key] + amount
    else
        G.GAME.bp_prescence[key] = amount
    end
    if G.GAME.bp_prescence[key] == 0 then
        G.GAME.bp_prescence[key] = nil
    end
end

function reroll_skip_tags()
    for i, j in ipairs({'Small', 'Big'}) do
        if (G.GAME.round_resets.blind_states[j] == 'Upcoming') or (G.GAME.round_resets.blind_states[j] == 'Current') or (G.GAME.round_resets.blind_states[j] == 'Select') then
            local tag1 = get_next_tag_key()
            G.GAME.round_resets.blind_tags[j] = tag1
            if G.blind_select_opts then
                local small_tag = G.blind_select_opts[(j == 'Small') and 'small' or 'big']:get_UIE_by_ID("tag_" .. j)
                if small_tag and next(small_tag) then
                    local tag = small_tag.children[1].children[1].config.ref_table
                    local tag_sprite = small_tag.children[1].children[1].children[1].config.object
                    if tag_sprite then
                        tag.key = tag1
                        local proto = G.P_TAGS[tag1]
                        tag.config = copy_table(proto.config)
                        tag.pos = proto.pos
                        tag.name = proto.name
                        local old = tag.tag_sprite
                        local nope, tag_sprite_ui = tag:generate_UI()
                        local x, y = old.T.x, old.T.y
                        tag_sprite_ui.T.x = x
                        tag_sprite_ui.T.y = y
                        small_tag.children[1].children[1].children[1].config.object = tag_sprite_ui
                        tag_sprite_ui.states.collide.can = false
                        old:remove()
                    end
                end
            end
        end
    end
end
