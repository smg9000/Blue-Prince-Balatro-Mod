--- STEAMODDED HEADER
--- MOD_NAME: BluePrince
--- MOD_ID: BPrince
--- PREFIX: bp
--- MOD_AUTHOR: [mathguy, smg9000]
--- MOD_DESCRIPTION: hi
--- VERSION: 0.0.0

----------------------------------------------
------------MOD CODE -------------------------
function G.UIDEF.active_experiment()

    local cause = localize(G.GAME.bp_experiment_cause, 'causes')
    local effect = localize(G.GAME.bp_experiment_effect, 'effects')

    local t = {n=G.UIT.ROOT, config={align = "cm", padding = 0.1, colour = G.C.CLEAR, minh = 8, minw = 7}, nodes={
        {n=G.UIT.R, config={align = "cm", colour = G.C.CLEAR, padding = 0.3}, nodes = {
            {n=G.UIT.R, config={align = "cm", padding = 0.3, colour = G.C.BLACK, r = 0.1, maxw=3}, nodes={
                {n=G.UIT.T, config={ref_table = {cause}, ref_value = 1, scale = 0.4, colour = G.C.UI.TEXT_LIGHT, shadow = true}},
            }},
            {n=G.UIT.R, config={align = "cm", padding = 0.3, colour = G.C.BLACK, r = 0.1, maxw=3}, nodes={
                {n=G.UIT.T, config={ref_table = {effect}, ref_value = 1, scale = 0.4, colour = G.C.UI.TEXT_LIGHT, shadow = true}},
            }},
        }}}
    }

    return t
end


----------------------------------------------
------------MOD CODE END----------------------