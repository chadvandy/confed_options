local mct = get_mct()

local confed_options = mct:register_mod("confederation_options")

--[[confed_options:set_title("Confederation Options")
confed_options:set_author("Vandy")
confed_options:set_description("The following are the settings for the mod you're looking at right now. Try it out!")]]

local options_list = {
    "wh_dlc05_sc_wef_wood_elves",
    "wh_main_sc_brt_bretonnia",
    "wh_main_sc_dwf_dwarfs",
    "wh_main_sc_emp_empire",
    "wh_main_sc_grn_greenskins",
    "wh_main_sc_grn_savage_orcs",
    "wh_main_sc_ksl_kislev",
    "wh_main_sc_nor_norsca",
    "wh_main_sc_teb_teb",
    "wh_main_sc_vmp_vampire_counts",
    "wh2_dlc09_sc_tmb_tomb_kings",
    "wh2_dlc11_sc_cst_vampire_coast",
    "wh2_main_sc_def_dark_elves",
    "wh2_main_sc_hef_high_elves",
    "wh2_main_sc_lzd_lizardmen",
    "wh2_main_sc_skv_skaven",
}

--- TODO remove presets? Change how they work?
local presets_section = confed_options:add_new_section("aaa_presets_section", "Presets")

local preset = confed_options:add_new_option("preset", "dropdown")
preset:set_text("Preset Option")
preset:set_tooltip_text("Use this preset to apply a setting to every other subculture.")
preset:add_dropdown_value("no_preset", "No Preset", "Don't set other subcultures to anything in particular.")
preset:add_dropdown_value("no_tweak", "No Tweak", "Set all subcultures to 'no tweak'.")
preset:add_dropdown_value("player_only", "Player Only", "Set all subcultures to 'player only' confederation.")
preset:add_dropdown_value("free_confed", "Free Confederation", "Set all subcultures to 'free confederation'.")
preset:add_dropdown_value("disabled", "Disabled", "Set all subcultures to 'disabled'.")

preset:set_default_value("no_preset")

preset:add_option_set_callback(
    function(context)
        local option = context:option()
        local setting = context:setting()
        local mct_mod = option:get_mod()

        if setting == "no_preset" then
            -- do nothing
        else
            for i = 1, #options_list do
                local option_key = options_list[i]
                local option_obj = mct_mod:get_option_by_key(option_key)
                if not option_obj then
                    -- errmsg
                else
                    -- apply the preset setting to the options
                    option_obj:set_finalized_setting(setting)
                end
            end
        end

        -- idk if this is needed
        --[[if context:is_creation() then

        else

        end]]
    end,
    true
)

local all_section = confed_options:add_new_section("zzz_per_subculture", "Per-Subculture Options")

local subcult_loc_prefix = "cultures_subcultures_name_"

local dropdown_options = {
    {
        key = "no_tweak",
        text = "confederation_options_no_tweak_text",
        tt = "confederation_options_no_tweak_tooltip",
        default = true
    },
    {
        key = "player_only", 
        text = "confederation_options_player_only_text",
        tt = "confederation_options_player_only_tooltip"
    },
    {
        key = "free_confed",
        text = "confederation_options_free_confed_text",
        tt = "confederation_options_free_confed_tooltip"
    },
    {
        key = "disabled",
        text = "confederation_options_disabled_text",
        tt = "confederation_options_disabled_tooltip"
    }
}

-- TODO add in modded subcultures

-- run through the options list and apply them all
for i = 1, #options_list do
    local option_key = options_list[i]
    local option_obj = confed_options:add_new_option(option_key, "dropdown")

    local text = subcult_loc_prefix..option_key

    -- set the text for the option, displays on the left of the dropdown
    -- mct:log(text)
    option_obj:set_text(text, true)
    option_obj:set_tooltip_text("")

    option_obj:set_uic_visibility(true)

    -- add the above table as dropdown values, providing "no_tweak" as the default
    option_obj:add_dropdown_values(dropdown_options)
end

-- replace the old option keys (the culture ones) with the new subculture ones, keeping the settings!
core:add_listener(
    "bloopityboopboopdocachedsettingsstuff",
    "MctInitialized",
    true,
    function(context)
        local mct = context:mct()
        local mct_mod = mct:get_mod_by_key("confederation_options")

        local cached_settings = mct.settings:get_cached_settings("confederation_options")
        if cached_settings then

            --[[
            "wh_main_sc_grn_savage_orcs",
            "wh_main_sc_ksl_kislev",
            "wh_main_sc_teb_teb",
            ]]
            local old_to_new_options = {
                wh_main_emp_empire = "wh_main_sc_emp_empire",
                wh_main_dwf_dwarfs = "wh_main_sc_dwf_dwarfs",
                wh_main_grn_greenskins = "wh_main_sc_grn_greenskins",
                wh_main_vmp_vampire_counts = "wh_main_sc_vmp_vampire_counts",
                wh2_main_hef_high_elves = "wh2_main_sc_hef_high_elves",
                wh2_main_def_dark_elves = "wh2_main_sc_def_dark_elves",
                wh2_main_skv_skaven = "wh2_main_sc_skv_skaven",
                wh2_main_lzd_lizardmen = "wh2_main_sc_lzd_lizardmen",
                wh_main_brt_bretonnia = "wh_main_sc_brt_bretonnia",
                wh_dlc05_wef_wood_elves = "wh_dlc05_sc_wef_wood_elves",
                wh_main_sc_nor_norsca = "wh_main_sc_nor_norsca",
                wh2_dlc09_tmb_tomb_kings = "wh2_dlc09_sc_tmb_tomb_kings",
                wh2_dlc11_cst_vampire_coast = "wh2_dlc11_sc_cst_vampire_coast",
            }

            for option_key, option_data in pairs(cached_settings) do
                local new_option = old_to_new_options[option_key]
                if new_option then
                    local option_obj = mct_mod:get_option_by_key(new_option)
                    if option_obj then
                        local setting = option_data._setting
                        option_obj:set_finalized_setting(setting)
                    end
                end
            end


            mct.settings:remove_cached_setting("confederation_options")
        end
    end,
    true
)

-- set the preset option back to "no preset" every time the mod is finalized, to prevent any and all nonsense
core:add_listener(
    "blooperboopitydoop_preset_thing",
    "MctFinalized",
    true,
    function(context)
        local mct = context:mct()
        local mct_mod = mct:get_mod_by_key("confederation_options")
        local preset = mct_mod:get_option_by_key("preset")
        preset:set_finalized_setting("no_preset")
    end,
    true
)