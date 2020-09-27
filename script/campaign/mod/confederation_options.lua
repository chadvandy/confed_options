local confed_option_settings = {
    --["setting key"] = value
    ["wh_dlc05_sc_wef_wood_elves"] = "no_tweak",
    ["wh_main_sc_brt_bretonnia"] = "no_tweak",
    ["wh_main_sc_dwf_dwarfs"] = "no_tweak",
    ["wh_main_sc_emp_empire"] = "no_tweak",
    ["wh_main_sc_grn_greenskins"] = "no_tweak",
    ['wh_main_sc_grn_savage_orcs'] = "no_tweak",
    ["wh_main_sc_ksl_kislev"] = "no_tweak",
    ['wh_main_sc_nor_norsca'] = "no_tweak",
    ['wh_main_sc_teb_teb'] = "no_tweak",
    ['wh_main_sc_vmp_vampire_counts'] = "no_tweak",
    ['wh2_dlc11_sc_cst_vampire_coast'] = "no_tweak",
    ['wh2_dlc09_sc_tmb_tomb_kings'] = "no_tweak",
    ['wh2_main_sc_def_dark_elves'] = "no_tweak",
    ['wh2_main_sc_hef_high_elves'] = "no_tweak",
    ['wh2_main_sc_lzd_lizardmen'] = "no_tweak",
    ['wh2_main_sc_skv_skaven'] = "no_tweak",
}

core:add_listener(
    "ConfedOptionsMctCreated",
    "MctInitialized",
    true,
    function(context)
        local mct = context:mct()
        
        local confed_options_mod = mct:get_mod_by_key("confederation_options")

        local settings_table = confed_options_mod:get_settings()

        -- overrides the settings table above, only if MCT exists
        confed_option_settings = settings_table

    end,
    false
)

local function do_other_function(culture, option)
    -- welf stuff
    if culture == "wh_dlc05_sc_wef_wood_elves" then
        if option == "free_confed" then
            core:remove_listener("WoodElves_BuildingCompleted")
            cm:force_diplomacy("culture:wh_dlc05_wef_wood_elves", "culture:wh_dlc05_wef_wood_elves", "form confederation", true, false, false);
        elseif option == "player_only" then

            cm:force_diplomacy("subculture:"..culture, "subculture:"..culture, "form confederation", false, true, false)

            core:remove_listener("WoodElves_BuildingCompleted")

            local human_factions = cm:get_human_factions()
            for i = 1, #human_factions do
                local faction = cm:get_faction(human_factions[i])

                if faction:culture() == "wh_dlc05_wef_wood_elves" then

                    cm:force_diplomacy("faction:"..faction:name(), "culture:wh_dlc05_wef_wood_elves", "form confederation", true, false, false);
                end
            end
        elseif option == "disabled" then
            core:remove_listener("WoodElves_BuildingCompleted")
        elseif option == "no_tweak" then
            -- do literally nothing!
        end

    -- brt stuff
    elseif culture == "wh_main_sc_brt_bretonnia" then
        if option == "free_confed" then
            core:remove_listener("BRT_Tech_FactionTurnStart")
            cm:force_diplomacy("culture:wh_main_brt_bretonnia", "culture:wh_main_brt_bretonnia", "form confederation", true, false, false)
        elseif option == "player_only" then
            core:remove_listener("BRT_Tech_FactionTurnStart")

            cm:force_diplomacy("subculture:"..culture, "subculture:"..culture, "form confederation", false, true, false)

            local human_factions = cm:get_human_factions()

            for i = 1, #human_factions do
                local faction = cm:get_faction(human_factions[i])

                if faction:culture() == "wh_main_brt_bretonnia" then

                    cm:force_diplomacy("faction:"..faction:name(), "culture:wh_main_brt_bretonnia", "form confederation", true, false, false)
                end
            end
        elseif option == "disabled" then
            core:remove_listener("BRT_Tech_FactionTurnStart")
            cm:force_diplomacy("culture:wh_main_brt_bretonnia", "culture:wh_main_brt_bretonnia", "form confederation", false, false, true)
        elseif option == "no_tweak" then
            -- do literally nothing
        end

    -- Norsca stuff
    elseif culture == "wh_main_sc_nor_norsca" then
        if option == "free_confed" then
            core:remove_listener("character_completed_battle_norsca_confederation_dilemma")
            core:remove_listener("VandyNorscaOverwriteListenerPartTwoForPlayerOnly")
            cm:force_diplomacy("subculture:wh_main_sc_nor_norsca", "subculture:wh_main_sc_nor_norsca", "form confederation", true, false, false)
        elseif option == "player_only" then
            core:remove_listener("character_completed_battle_norsca_confederation_dilemma")
        elseif option == "disabled" then
            core:remove_listener("character_completed_battle_norsca_confederation_dilemma")
            core:remove_listener("VandyNorscaOverwriteListenerPartTwoForPlayerOnly")
            cm:force_diplomacy("subculture:wh_main_sc_nor_norsca", "subculture:wh_main_sc_nor_norsca", "form confederation", false, false, true)
        elseif option == "no_tweak" then
            core:remove_listener("VandyNorscaOverwriteListenerPartTwoForPlayerOnly")
            -- do literally nothing!
        end

    -- Greenskins stuff
    elseif culture == "wh_main_sc_grn_greenskins" then
        if option == "free_confed" then
            core:remove_listener("character_completed_battle_greenskin_confederation_dilemma")
            core:remove_listener("greenskin_confederation_player_only")
            cm:force_diplomacy("subculture:wh_main_sc_grn_greenskins", "subculture:wh_main_sc_grn_greenskins", "form confederation", true, false, false)
        elseif option == "player_only" then
            core:remove_listener("character_completed_battle_greenskin_confederation_dilemma")
        elseif option == "disabled" then
            core:remove_listener("character_completed_battle_greenskin_confederation_dilemma")
            core:remove_listener("greenskin_confederation_player_only")
            cm:force_diplomacy("subculture:wh_main_sc_grn_greenskins", "subculture:wh_main_sc_grn_greenskins", "form confederation", false, false, true)
        elseif option == "no_tweak" then
            core:remove_listener("greenskin_confederation_player_only")
        end
    end
end

local function set_confed_option(culture, option)
    if option == "free_confed" then
        -- enable confederation for this culture
        cm:force_diplomacy("subculture:"..culture, "subculture:"..culture, "form confederation", true, true, true)

    elseif option == "player_only" then
        -- enable accepting for AI
        cm:force_diplomacy("subculture:"..culture, "subculture:"..culture, "form confederation", false, true, false)

        cm:callback(function()
            local human_factions = cm:get_human_factions()
            for i = 1, #human_factions do
                local faction_key = human_factions[i]
                local faction_obj = cm:get_faction(faction_key)
                if faction_obj:is_human() and faction_obj:subculture() == culture then

                    -- enable offer for human only
                    cm:force_diplomacy("faction:"..faction_obj:name(), "subculture:"..culture, "form confederation", true, true, false)
                end
            end
        end, 0.1)
    
    elseif option == "disabled" then
        -- disable confederation for this culture
        cm:force_diplomacy("subculture:"..culture, "subculture:"..culture, "form confederation", false, false, true)
    elseif option == "no_tweak" then
        --do nothing!
    end
end

local function do_stuff(culture_key, setting)
    local do_other = {
        ["wh_dlc05_sc_wef_wood_elves"] = true,
        ["wh_main_sc_brt_bretonnia"] = true,
        ["wh_main_sc_nor_norsca"] = true,
        ["wh_main_sc_grn_greenskins"] = true,
    }

    if not is_nil(confed_option_settings[culture_key]) then
        if not do_other[culture_key] then
            set_confed_option(culture_key, setting)
        else
            do_other_function(culture_key, setting)
        end
    end
end

local function main()

    for culture_key, setting in pairs(confed_option_settings) do
        do_stuff(culture_key, setting)
    end
end

-- allows settings to be changed mid-game!
core:add_listener(
    "confed_option_changed",
    "MctOptionSettingFinalized",
    function(context)
        return context:mod():get_key() == "confederation_options"
    end,
    function(context)
        local option = context:option()
        local setting = context:setting()

        do_stuff(option:get_key(), setting)
    end,
    true
)

cm:add_first_tick_callback(function()
    -- trigger main() immediately, and re-run it on every new round
    main() 
    
    core:add_listener(
        "confed_options_faction_round_start",
        "FactionTurnStart",
        function(context)
            return context:faction():is_human()
        end,
        function(context)
            main()
        end,
        true
    )

end)

local NORSCA_SUBCULTURE = "wh_main_sc_nor_norsca"
local NORSCA_CONFEDERATION_DILEMMA = "wh2_dlc08_confederate_";
local norsca_info_text_confederation = {"war.camp.prelude.nor.confederation.info_001", "war.camp.prelude.nor.confederation.info_002", "war.camp.prelude.nor.confederation.info_003"};


-- the Norsca confed listener for player only
core:add_listener(
    "VandyNorscaOverwriteListenerPartTwoForPlayerOnly",
    "CharacterCompletedBattle",
    function(context)
        local character = context:character()
        return character:won_battle() == true and character:faction():subculture() == NORSCA_SUBCULTURE
    end,
    function(context)
        local character = context:character()
        local enemies = cm:pending_battle_cache_get_enemies_of_char(character);
		local enemy_count = #enemies;
		
		if context:pending_battle():night_battle() == true or context:pending_battle():ambush_battle() == true then
			enemy_count = 1;
		end
		
		for i = 1, enemy_count do
			local enemy = enemies[i];
			
			if enemy ~= nil and enemy:is_null_interface() == false and enemy:is_faction_leader() == true and enemy:faction():subculture() == NORSCA_SUBCULTURE then
				if enemy:has_military_force() == true and enemy:military_force():is_armed_citizenry() == false then
					if character:faction():is_human() == true and enemy:faction():is_human() == false and enemy:faction():is_dead() == false then
						-- Trigger dilemma to offer confederation
						local NORSCA_CONFEDERATION_PLAYER = character:faction():name();
						cm:trigger_dilemma(NORSCA_CONFEDERATION_PLAYER, NORSCA_CONFEDERATION_DILEMMA..enemy:faction():name(), true);
						Play_Norsca_Advice("dlc08.camp.advice.nor.confederation.001", norsca_info_text_confederation);
					--[[elseif character:faction():is_human() == false and enemy:faction():is_human() == false then
						-- AI confederation
						cm:force_confederation(character:faction():name(), enemy:faction():name());]]
					end
				end
			end
        end
    end,
    true
)

core:add_listener(
    "greenskin_confederation_player_only",
    "CharacterCompletedBattle",
    true,
    function(context)
        local character = context:character();
        
        if character:won_battle() == true and character:faction():subculture() == "wh_main_sc_grn_greenskins" then
            local enemies = cm:pending_battle_cache_get_enemies_of_char(character);
            local enemy_count = #enemies;
            
            if context:pending_battle():night_battle() == true or context:pending_battle():ambush_battle() == true then
                enemy_count = 1;
            end

            local character_cqi = character:command_queue_index();
            local attacker_cqi, attacker_force_cqi, attacker_name = cm:pending_battle_cache_get_attacker(1);
            local defender_cqi, defender_force_cqi, defender_name = cm:pending_battle_cache_get_defender(1);
            
            if character_cqi == attacker_cqi or character_cqi == defender_cqi then
                for i = 1, enemy_count do
                    local enemy = enemies[i];
                    
                    if enemy ~= nil and enemy:is_null_interface() == false and enemy:is_faction_leader() == true and enemy:faction():subculture() == "wh_main_sc_grn_greenskins" then
                        if enemy:has_military_force() == true and enemy:military_force():is_armed_citizenry() == false then
                            if character:faction():is_human() == true and enemy:faction():is_human() == false and enemy:faction():is_dead() == false then
                                -- Trigger dilemma to offer confederation
                                GREENSKIN_CONFEDERATION_PLAYER = character:faction():name();
                                cm:trigger_dilemma(GREENSKIN_CONFEDERATION_PLAYER, GREENSKIN_CONFEDERATION_DILEMMA..enemy:faction():name());
                                --Play_Norsca_Advice("dlc08.camp.advice.nor.confederation.001", norsca_info_text_confederation);
                            elseif character:faction():is_human() == false and enemy:faction():is_human() == false then
                                -- AI confederation
                                --[[cm:force_confederation(character:faction():name(), enemy:faction():name());
                                out.design("###### AI GREENSKIN CONFEDERATION");
                                out.design("Faction: "..character:faction():name().." is confederating "..enemy:faction():name());]]
                            end
                        end
                    end
                end
            end
        end
    end,
    true
);