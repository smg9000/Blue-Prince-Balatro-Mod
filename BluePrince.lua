
SMODS.Atlas({ key = "experiments", atlas_table = "ASSET_ATLAS", path = "Exp.png", px = 71, py = 95})

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

local experiment_effects = { 'earn_5_dollars', 'upgrade_3_hands', 'create_negative_immediately_experiment', 'create_joker', 'use_wheel_of_fortune', 'add_last_used_tarot_to_pool', '2_percent_probabilities', 'reroll_tags' }

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

bp_force_showman = nil
bp_ignore_prescence_cards = {}
bp_pool_rarity = nil

local old_showman = SMODS.showman
function SMODS.showman(card_key)
    if bp_force_showman then
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

local old_pool = get_current_pool
function get_current_pool(_type, _rarity, _legendary, _append)
    bp_force_showman = true 
    bp_ignore_prescence_cards = {}
    bp_pool_rarity = nil
    local pool, key = old_pool(_type, _rarity, _legendary, _append)
    bp_force_showman = nil
    local pool_key = _type .. '_' .. (bp_pool_rarity or 'Common') .. (_legendary and '_leg' or '')
    if G.GAME.bp_pool_addons and G.GAME.bp_pool_addons[pool_key] then
        for i = 1, #G.GAME.bp_pool_addons[pool_key] do
            table.insert(pool, G.GAME.bp_pool_addons[pool_key][i])
        end
    end
    if (_type ~= 'Enhanced') and (_type ~= 'Edition') and (_type ~= 'Demo') and (_type ~= 'Tag') then
        local prescence = copy_table(G.GAME.bp_prescence or {})
        local removal = copy_table(G.GAME.bp_pool_removals and G.GAME.bp_pool_removals[pool_key] or {})
        for i = #pool, 1, -1 do
            if prescence[pool[i]] and (prescence[pool[i]] > 0) and not (SMODS.showman(pool[i]) or bp_ignore_prescence_cards[pool[i]]) then
                prescence[pool[i]] = prescence[pool[i]] - 1
                if prescence[pool[i]] == 0 then
                    prescence[pool[i]] = nil
                end
                table.remove(pool, i)
            else
                for j = #removal, 1, -1 do
                    if removal[j] == pool[i] then
                        table.remove(pool, i)
                        table.remove(removal, j)
                        break
                    end
                end
            end
        end
    end
    if #pool == 0 then
        pool = {}
        if SMODS.ObjectTypes[_type] and SMODS.ObjectTypes[_type].default and G.P_CENTERS[SMODS.ObjectTypes[_type].default] then
            pool[#pool+1] = SMODS.ObjectTypes[_type].default
        elseif _type == 'Tarot' or _type == 'Tarot_Planet' then pool[#pool + 1] = "c_strength"
        elseif _type == 'Planet' then pool[#pool + 1] = "c_pluto"
        elseif _type == 'Spectral' then pool[#pool + 1] = "c_incantation"
        elseif _type == 'Joker' then pool[#pool + 1] = "j_joker"
        elseif _type == 'Demo' then pool[#pool + 1] = "j_joker"
        elseif _type == 'Voucher' then pool[#pool + 1] = "v_blank"
        elseif _type == 'Tag' then pool[#pool + 1] = "tag_handy"
        elseif _type == 'Edition' then pool[#pool + 1] = "e_foil"
        else pool[#pool + 1] = "j_joker"
        end
    end
    return pool, key
end

function bp_add_to_pool(key, type, amount, rarity, legendary)
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