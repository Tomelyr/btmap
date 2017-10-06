-- This function initializes the game mode and is called before anyone loads into the game
-- It can be used to pre-initialize any values/tables that will be needed later
function BTMap:_InitBTMap()
  if BTMap._reentrantCheck then
    return
  end

  -- Setup rules
  GameRules:SetHeroRespawnEnabled( ENABLE_HERO_RESPAWN )
  GameRules:SetUseUniversalShopMode( UNIVERSAL_SHOP_MODE )
  GameRules:SetSameHeroSelectionEnabled( ALLOW_SAME_HERO_SELECTION )
  GameRules:SetHeroSelectionTime( HERO_SELECTION_TIME )
  GameRules:SetPreGameTime( PRE_GAME_TIME)
  GameRules:SetPostGameTime( POST_GAME_TIME )
  GameRules:SetTreeRegrowTime( TREE_REGROW_TIME )
  GameRules:SetUseCustomHeroXPValues ( USE_CUSTOM_XP_VALUES )
  GameRules:SetGoldPerTick(GOLD_PER_TICK)
  GameRules:SetGoldTickTime(GOLD_TICK_TIME)
  GameRules:SetRuneSpawnTime(RUNE_SPAWN_TIME)
  GameRules:SetUseBaseGoldBountyOnHeroes(USE_STANDARD_HERO_GOLD_BOUNTY)
  GameRules:SetHeroMinimapIconScale( MINIMAP_ICON_SIZE )
  GameRules:SetCreepMinimapIconScale( MINIMAP_CREEP_ICON_SIZE )
  GameRules:SetRuneMinimapIconScale( MINIMAP_RUNE_ICON_SIZE )

  GameRules:SetFirstBloodActive( ENABLE_FIRST_BLOOD )
  GameRules:SetHideKillMessageHeaders( HIDE_KILL_BANNERS )

  GameRules:SetCustomGameEndDelay( GAME_END_DELAY )
  GameRules:SetCustomVictoryMessageDuration( VICTORY_MESSAGE_DURATION )
  GameRules:SetStartingGold( STARTING_GOLD )

  if SKIP_TEAM_SETUP then
    GameRules:SetCustomGameSetupAutoLaunchDelay( 0 )
    GameRules:LockCustomGameSetupTeamAssignment( true )
    GameRules:EnableCustomGameSetupAutoLaunch( true )
  else
    GameRules:SetCustomGameSetupAutoLaunchDelay( AUTO_LAUNCH_DELAY )
    GameRules:LockCustomGameSetupTeamAssignment( LOCK_TEAM_SETUP )
    GameRules:EnableCustomGameSetupAutoLaunch( ENABLE_AUTO_LAUNCH )
  end


  -- This is multiteam configuration stuff
  if USE_AUTOMATIC_PLAYERS_PER_TEAM then
    local num = math.floor(10 / MAX_NUMBER_OF_TEAMS)
    local count = 0
    for team,number in pairs(TEAM_COLORS) do
      if count >= MAX_NUMBER_OF_TEAMS then
        GameRules:SetCustomGameTeamMaxPlayers(team, 0)
      else
        GameRules:SetCustomGameTeamMaxPlayers(team, num)
      end
      count = count + 1
    end
  else
    local count = 0
    for team,number in pairs(CUSTOM_TEAM_PLAYER_COUNT) do
      if count >= MAX_NUMBER_OF_TEAMS then
        GameRules:SetCustomGameTeamMaxPlayers(team, 0)
      else
        GameRules:SetCustomGameTeamMaxPlayers(team, number)
      end
      count = count + 1
    end
  end

  if USE_CUSTOM_TEAM_COLORS then
    for team,color in pairs(TEAM_COLORS) do
      SetTeamCustomHealthbarColor(team, color[1], color[2], color[3])
    end
  end
  DebugPrint('[BTMAP] GameRules set')

  --InitLogFile( "log/btmap.txt","")

  -- Event Hooks
  -- All of these events can potentially be fired by the game, though only the uncommented ones have had
  -- Functions supplied for them.  If you are interested in the other events, you can uncomment the
  -- ListenToGameEvent line and add a function to handle the event
  ListenToGameEvent('dota_player_gained_level', Dynamic_Wrap(BTMap, 'OnPlayerLevelUp'), self)
  ListenToGameEvent('dota_ability_channel_finished', Dynamic_Wrap(BTMap, 'OnAbilityChannelFinished'), self)
  ListenToGameEvent('dota_player_learned_ability', Dynamic_Wrap(BTMap, 'OnPlayerLearnedAbility'), self)
  ListenToGameEvent('entity_killed', Dynamic_Wrap(BTMap, '_OnEntityKilled'), self)
  ListenToGameEvent('player_connect_full', Dynamic_Wrap(BTMap, '_OnConnectFull'), self)
  ListenToGameEvent('player_disconnect', Dynamic_Wrap(BTMap, 'OnDisconnect'), self)
  ListenToGameEvent('dota_item_purchased', Dynamic_Wrap(BTMap, 'OnItemPurchased'), self)
  ListenToGameEvent('dota_item_picked_up', Dynamic_Wrap(BTMap, 'OnItemPickedUp'), self)
  ListenToGameEvent('last_hit', Dynamic_Wrap(BTMap, 'OnLastHit'), self)
  ListenToGameEvent('dota_non_player_used_ability', Dynamic_Wrap(BTMap, 'OnNonPlayerUsedAbility'), self)
  ListenToGameEvent('player_changename', Dynamic_Wrap(BTMap, 'OnPlayerChangedName'), self)
  ListenToGameEvent('dota_rune_activated_server', Dynamic_Wrap(BTMap, 'OnRuneActivated'), self)
  ListenToGameEvent('dota_player_take_tower_damage', Dynamic_Wrap(BTMap, 'OnPlayerTakeTowerDamage'), self)
  ListenToGameEvent('tree_cut', Dynamic_Wrap(BTMap, 'OnTreeCut'), self)
  ListenToGameEvent('entity_hurt', Dynamic_Wrap(BTMap, 'OnEntityHurt'), self)
  ListenToGameEvent('player_connect', Dynamic_Wrap(BTMap, 'PlayerConnect'), self)
  ListenToGameEvent('dota_player_used_ability', Dynamic_Wrap(BTMap, 'OnAbilityUsed'), self)
  ListenToGameEvent('game_rules_state_change', Dynamic_Wrap(BTMap, '_OnGameRulesStateChange'), self)
  ListenToGameEvent('npc_spawned', Dynamic_Wrap(BTMap, '_OnNPCSpawned'), self)
  ListenToGameEvent('dota_player_pick_hero', Dynamic_Wrap(BTMap, 'OnPlayerPickHero'), self)
  ListenToGameEvent('dota_team_kill_credit', Dynamic_Wrap(BTMap, 'OnTeamKillCredit'), self)
  ListenToGameEvent("player_reconnected", Dynamic_Wrap(BTMap, 'OnPlayerReconnect'), self)

  ListenToGameEvent("dota_illusions_created", Dynamic_Wrap(BTMap, 'OnIllusionsCreated'), self)
  ListenToGameEvent("dota_item_combined", Dynamic_Wrap(BTMap, 'OnItemCombined'), self)
  ListenToGameEvent("dota_player_begin_cast", Dynamic_Wrap(BTMap, 'OnAbilityCastBegins'), self)
  ListenToGameEvent("dota_tower_kill", Dynamic_Wrap(BTMap, 'OnTowerKill'), self)
  ListenToGameEvent("dota_player_selected_custom_team", Dynamic_Wrap(BTMap, 'OnPlayerSelectedCustomTeam'), self)
  ListenToGameEvent("dota_npc_goal_reached", Dynamic_Wrap(BTMap, 'OnNPCGoalReached'), self)

  ListenToGameEvent("player_chat", Dynamic_Wrap(BTMap, 'OnPlayerChat'), self)
  
  --ListenToGameEvent("dota_tutorial_shop_toggled", Dynamic_Wrap(BTMap, 'OnShopToggled'), self)

  --ListenToGameEvent('player_spawn', Dynamic_Wrap(BTMap, 'OnPlayerSpawn'), self)
  --ListenToGameEvent('dota_unit_event', Dynamic_Wrap(BTMap, 'OnDotaUnitEvent'), self)
  --ListenToGameEvent('nommed_tree', Dynamic_Wrap(BTMap, 'OnPlayerAteTree'), self)
  --ListenToGameEvent('player_completed_game', Dynamic_Wrap(BTMap, 'OnPlayerCompletedGame'), self)
  --ListenToGameEvent('dota_match_done', Dynamic_Wrap(BTMap, 'OnDotaMatchDone'), self)
  --ListenToGameEvent('dota_combatlog', Dynamic_Wrap(BTMap, 'OnCombatLogEvent'), self)
  --ListenToGameEvent('dota_player_killed', Dynamic_Wrap(BTMap, 'OnPlayerKilled'), self)
  --ListenToGameEvent('player_team', Dynamic_Wrap(BTMap, 'OnPlayerTeam'), self)

  --[[This block is only used for testing events handling in the event that Valve adds more in the future
  Convars:RegisterCommand('events_test', function()
      BTMap:StartEventTest()
    end, "events test", 0)]]

  local spew = 0
  if BTMAP_DEBUG_SPEW then
    spew = 1
  end
  Convars:RegisterConvar('btmap_spew', tostring(spew), 'Set to 1 to start spewing btmap debug info.  Set to 0 to disable.', 0)

  -- Change random seed
  local timeTxt = string.gsub(string.gsub(GetSystemTime(), ':', ''), '^0+','')
  math.randomseed(tonumber(timeTxt))

  -- Initialized tables for tracking state
  self.bSeenWaitForPlayers = false
  self.vUserIds = {}

  DebugPrint('[BTMAP] Done loading BTMap btmap!\n\n')
  BTMap._reentrantCheck = true
  BTMap:InitBTMap()
  BTMap._reentrantCheck = false
end

mode = nil

-- This function is called as the first player loads and sets up the BTMap parameters
function BTMap:_CaptureBTMap()
  if mode == nil then
    -- Set BTMap parameters
    mode = GameRules:GetGameModeEntity()        
    mode:SetRecommendedItemsDisabled( RECOMMENDED_BUILDS_DISABLED )
    mode:SetCameraDistanceOverride( CAMERA_DISTANCE_OVERRIDE )
    mode:SetCustomBuybackCostEnabled( CUSTOM_BUYBACK_COST_ENABLED )
    mode:SetCustomBuybackCooldownEnabled( CUSTOM_BUYBACK_COOLDOWN_ENABLED )
    mode:SetBuybackEnabled( BUYBACK_ENABLED )
    mode:SetTopBarTeamValuesOverride ( USE_CUSTOM_TOP_BAR_VALUES )
    mode:SetTopBarTeamValuesVisible( TOP_BAR_VISIBLE )
    mode:SetUseCustomHeroLevels ( USE_CUSTOM_HERO_LEVELS )
    mode:SetCustomHeroMaxLevel ( MAX_LEVEL )
    mode:SetCustomXPRequiredToReachNextLevel( XP_PER_LEVEL_TABLE )

    mode:SetBotThinkingEnabled( USE_STANDARD_DOTA_BOT_THINKING )
    mode:SetTowerBackdoorProtectionEnabled( ENABLE_TOWER_BACKDOOR_PROTECTION )

    mode:SetFogOfWarDisabled(DISABLE_FOG_OF_WAR_ENTIRELY)
    mode:SetGoldSoundDisabled( DISABLE_GOLD_SOUNDS )
    mode:SetRemoveIllusionsOnDeath( REMOVE_ILLUSIONS_ON_DEATH )

    mode:SetAlwaysShowPlayerInventory( SHOW_ONLY_PLAYER_INVENTORY )
    mode:SetAnnouncerDisabled( DISABLE_ANNOUNCER )
    if FORCE_PICKED_HERO ~= nil then
      mode:SetCustomGameForceHero( FORCE_PICKED_HERO )
    end
    mode:SetFixedRespawnTime( FIXED_RESPAWN_TIME ) 
    mode:SetFountainConstantManaRegen( FOUNTAIN_CONSTANT_MANA_REGEN )
    mode:SetFountainPercentageHealthRegen( FOUNTAIN_PERCENTAGE_HEALTH_REGEN )
    mode:SetFountainPercentageManaRegen( FOUNTAIN_PERCENTAGE_MANA_REGEN )
    mode:SetLoseGoldOnDeath( LOSE_GOLD_ON_DEATH )
    mode:SetMaximumAttackSpeed( MAXIMUM_ATTACK_SPEED )
    mode:SetMinimumAttackSpeed( MINIMUM_ATTACK_SPEED )
    mode:SetStashPurchasingDisabled ( DISABLE_STASH_PURCHASING )

    for rune, spawn in pairs(ENABLED_RUNES) do
      mode:SetRuneEnabled(rune, spawn)
    end

    mode:SetUnseenFogOfWarEnabled( USE_UNSEEN_FOG_OF_WAR )

    mode:SetDaynightCycleDisabled( DISABLE_DAY_NIGHT_CYCLE )
    mode:SetKillingSpreeAnnouncerDisabled( DISABLE_KILLING_SPREE_ANNOUNCER )
    mode:SetStickyItemDisabled( DISABLE_STICKY_ITEM )

    self:OnFirstPlayerLoaded()
  end 
end