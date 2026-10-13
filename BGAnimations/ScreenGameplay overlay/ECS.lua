local player = ...
local profile_name = PROFILEMAN:GetPlayerName(player)
local pss = STATSMAN:GetCurStageStats():GetPlayerStageStats(player)

local CreateScoreFile = function(day, month_string, year, seconds, hour, minute, second)
	-- Don't write any files in a practice set.
	if ECS.IsPractice then return end

	local passed_song = pss:GetFailed() and "Failed" or "Passed"

	local dance_points = pss:GetPercentDancePoints()
	local percent_score = FormatPercentScore( dance_points ):sub(1,-2):gsub(" ", "")

	local song = GAMESTATE:GetCurrentSong()
	local group_name = song:GetGroupName()
	local song_name = song:GetMainTitle()
	local music_rate = GAMESTATE:GetSongOptionsObject("ModsLevel_Preferred"):MusicRate() or 1
	music_rate = string.format("%.2f", music_rate)

	if not IsPlayingFromPackForDivision() and not IsPlayingMarathon() then return end

	local attempt_number = ECS.Mode == "Speed" and ECS.SpeedAttemptNumber or 0

	-- ----------------------------------------------------------
	local base_theme_path = THEME:GetCurrentThemeDirectory()
	local path = base_theme_path.."ECSData/"..day..month_string..year.."-"..seconds.."-"..ECS.Players[profile_name].id.."-".."SCORE-"..ECS.Mode.."-"..attempt_number..".txt"

	local game = GAMESTATE:GetCurrentGame():GetName()
	local style = GAMESTATE:GetCurrentStyle():GetName()

	local data = ""
	data = data..percent_score .."\n"
	data = data..passed_song.."\n"
	data = data..group_name.."\n"
	data = data..song_name.."\n"
	data = data..day.." "..month_string.." "..year.."\n"
	data = data..hour..":"..minute..":"..second.."\n"
	data = data..music_rate.."\n"
	data = data..(game == "dance" and "itg" or game).."\n"
	data = data..style.."\n"

	-- Handle special "theme" points.
	local theme_points = 0
	local score = tonumber(percent_score) / 100
	local song_info = GetDivision() == "upper" and ECS.SongInfo.Upper
		or GetDivision() == "mid" and ECS.SongInfo.Mid or ECS.SongInfo.Lower
	local song_data = FindEcsSong(song:GetDisplayFullTitle(), song_info)
	local ecs_player = ECS.Players[profile_name]
	local ap = math.ceil(score ^ 4 * 1000)
	local has_twin_lance = false

	for relic in ivalues(ECS.Player.Relics) do
		local name = relic.name

		-- NOTE: relic.score() usually requires arguments but the ones defined below
		-- doesn't use any of them so rel.score() is safe.
		if name == "Core Drill" then
			theme_points = theme_points + relic.score()
		end
		if name == "Extensionless File" then
			-- Subtract 75 since we only want to consider the theme specific
			-- bonus and not the +75 base.
			theme_points = theme_points + relic.score() - 75
		end
		if name == "Les Paul" then
			theme_points = theme_points + relic.score()
		end
		if name == "Dry Bones Plush" then
			theme_points = theme_points + relic.score(ecs_player, song_info, song_data, ECS.Player.Relics, ap, score)
		end
		if name == "eric's iron slab" then
			theme_points = theme_points + relic.score()
		end
		if name == "Kraken Club" and song_data then
			local points = relic.score(ecs_player, song_info, song_data, ECS.Player.Relics, ap, score)
			-- The first hit is the relic's normal bonus; only extra hits count as theme points.
			theme_points = theme_points + points - (math.floor(song_data.dp * 0.2) + 100)
		end
		if name == "Contrakt" and song_data then
			theme_points = theme_points + relic.score(ecs_player, song_info, song_data, ECS.Player.Relics, ap, score)
		end
		if name == "Twin Lance" then
			has_twin_lance = true
		end
	end
	if has_twin_lance then theme_points = theme_points * 2 end
	data = data .. theme_points .. "\n"


	local f = RageFileUtil.CreateRageFile()

	if f:Open(path, 2) then
		f:Write( data )
	else
		local fError = f:GetError()
		SM("There was some kind of error writing your score to disk.  You should let Archi know.")
		Trace( "[FileUtils] Error writing to ".. path ..": ".. fError )
		f:ClearError()
	end

	f:destroy()
end

local CreateRelicFile = function(day, month_string, year, seconds)
	-- Don't write any files in a practice set.
	if ECS.IsPractice then return end

	local song = GAMESTATE:GetCurrentSong()
	local group_name = song:GetGroupName()

	if not IsPlayingFromPackForDivision() and not IsPlayingMarathon() then return end

	local attempt_number = ECS.Mode == "Speed" and ECS.SpeedAttemptNumber or 0

	local base_theme_path = THEME:GetCurrentThemeDirectory()
	local path = base_theme_path.."ECSData/"..day..month_string..year.."-"..seconds.."-"..ECS.Players[profile_name].id.."-".."RELIC-"..ECS.Mode.."-"..attempt_number..".txt"
	local data = ""

	for i=1, 5 do
		local relic = ECS.Player.Relics[i]
		local name = relic and relic.name or "*"
		data = data .. name .. "\n"
	end

	local f = RageFileUtil.CreateRageFile()

	if f:Open(path, 2) then
		f:Write( data )
	else
		local fError = f:GetError()
		SM("There was some kind of error writing your score to disk.  You should let Archi know.")
		Trace( "[FileUtils] Error writing to ".. path ..": ".. fError )
		f:ClearError()
	end

	f:destroy()
end

-- ----------------------------------------------------------
local WriteRelicDataToDisk = function()
	-- Don't write any files in a practice set.
	if ECS.IsPractice then return end

	-- Speed doesn't use relics so nothing to write.
	if ECS.Mode == "Speed" then return end

	local p = PlayerNumber:Reverse()[GAMESTATE:GetMasterPlayerNumber()] + 1
	local profile_dir = PROFILEMAN:GetProfileDir("ProfileSlot_Player"..p)

	if profile_dir then

		local s = "return {\n"
		for relic in ivalues(ECS.Players[profile_name].relics) do
			if relic.quantity then
				s = s .. "\t{name=\"" .. relic.name .. "\", quantity=" .. relic.quantity .."},\n"
			else
				s = s .. "\t{name=\"" .. relic.name .. "\"},\n"
			end
		end
		s = s .. "}"


		local f = RageFileUtil.CreateRageFile()
		local path = profile_dir .. THEME:GetThemeDisplayName() .. "_Player_Relic_Data.lua"

		if f:Open(path, 2) then
			f:Write( s )
		else
			local fError = f:GetError()
			Trace( "[FileUtils] Error writing to ".. path ..": ".. fError )
			f:ClearError()
		end

		f:destroy()
	end
end

-- ----------------------------------------------------------

local ExpendChargesOnActiveRelics = function()
	for relic in ivalues(ECS.Players[profile_name].relics) do
		for active_relic in ivalues(ECS.Player.Relics) do
			local name = active_relic.name
			if name:match("^Dragonball") then
				name = "Dragonball"
			end

			if name == relic.name and active_relic.is_consumable and relic.quantity > 0 then
				relic.quantity = relic.quantity - 1
			end
		end
	end
end

-- ----------------------------------------------------------

local ApplyRelicActions = function()
	for active_relic in ivalues(ECS.Player.Relics) do
		if active_relic.name == "Xynn's Mix Tape" and GetQuantityForRelic(active_relic.name) > 0 then
			-- Don't want to run into an infinite loop so use the MixTapesUsed flag.
			-- Handle this first so that we can reload immediately before applying any
			-- other relics.
			if ECS.Player.MixTapesRandomSong == nil then
				local song = GAMESTATE:GetCurrentSong()
				local group = song:GetGroupName()
				local all_songs = SONGMAN:GetSongsInGroup(group)
				local random_song = all_songs[math.random(#all_songs)]

				ECS.Player.MixTapesRandomSong = random_song

				SCREENMAN:GetTopScreen():SetNextScreenName("ScreenSelectMusic")
				SCREENMAN:GetTopScreen():StartTransitioningScreen("SM_GoToNextScreen")
			else
				ECS.Player.MixTapesRandomSong = nil
			end
		end
	end

	for active_relic in ivalues(ECS.Player.Relics) do
		if not active_relic.is_consumable or GetQuantityForRelic(active_relic.name) > 0 then
			active_relic.action(ECS.Player.Relics)
		end
	end
end

-- ----------------------------------------------------------
-- actually hook into the screen so that we can do thing at screen's OnCommand and OffCommand
local af = Def.ActorFrame{}
af[#af+1] = Def.Actor{
	OnCommand=function(self)
		-- Speed mode doesn't have relics, but the functions are still safe to call.
		if ECS.Mode == "ECS" or ECS.Mode == "Speed" or ECS.Mode == "Marathon" then
			-- relic actions depend on the current screen,
			-- so ApplyRelicActions() must be called from OnCommand
			
			ApplyRelicActions()
			
			if ECS.Player.MixTapesRandomSong == nil then
				ExpendChargesOnActiveRelics()
			end
		end
	end,
	OffCommand=function(self)
		-- Speed mode doesn't have relics, but the functions are still safe to call.
		if ECS.Mode == "ECS" or ECS.Mode == "Speed" or ECS.Mode == "Marathon" then
			local year, month, day = Year(), MonthOfYear() + 1, DayOfMonth()
			local hour, minute, second = Hour(), Minute(), Second()
			local seconds = (hour*60*60) + (minute*60) + second
			local month_string = THEME:GetString("Months", "Month"..month)

			-- Check if player has failed.
			local failed = pss:GetFailed()

			-- The cases where we don't want to write a score file are:
			-- 1. The player is about to play a random song from a mixtape OR
			if not (ECS.Player.MixTapesRandomSong ~= nil) then
				CreateScoreFile(day, month_string, year, seconds, hour, minute, second)
				CreateRelicFile(day, month_string, year, seconds)
				WriteRelicDataToDisk()
			end
		end
	end
}

-- -----------------------------------------------------------------------
local mmss = "%d:%02d"

local SecondsToMMSS = function(s)
	-- native floor division sounds nice but isn't available in Lua 5.1
	local mins  = math.floor((s % 3600) / 60)
	local secs  = s - (mins * 60)
	return mmss:format(mins, secs)
end

local FaustsScalpelIsActive = function()
	for active_relic in ivalues(ECS.Player.Relics) do
		if active_relic.name == "Faust's Scalpel" then
			return true
		end
	end
	return false
end

local SeaRingIsActive = function()
	for active_relic in ivalues(ECS.Player.Relics) do
		if active_relic.name == "Sea Ring" then
			return true
		end
	end
	return false
end

local DaggerOfTimeIsActive = function()
	for active_relic in ivalues(ECS.Player.Relics) do
		if active_relic.name == "Dagger of Time" then
			return true
		end
	end
	return false
end

local KappaPlushIsActive = function()
	for active_relic in ivalues(ECS.Player.Relics) do
		if active_relic.name == "Kappa Plush" then
			return true
		end
	end
	return false
end

local ExtensionlessFileIsActive = function()
	for active_relic in ivalues(ECS.Player.Relics) do
		if active_relic.name == "Extensionless File" then
			return true
		end
	end
	return false
end

local GoldDustIsActive = function()
	for active_relic in ivalues(ECS.Player.Relics) do
		if active_relic.name == "Gold Dust" then
			return true
		end
	end
	return false
end

local WrenchIsActive = function()
	for active_relic in ivalues(ECS.Player.Relics) do
		if active_relic.name == "Wrench" then
			return true
		end
	end
	return false
end

local IVBagIsActive = function()
	for active_relic in ivalues(ECS.Player.Relics) do
		if active_relic.name == "IV Bag" then
			return true
		end
	end
	return false
end

local TwoUpIsActive = function()
	for active_relic in ivalues(ECS.Player.Relics) do
		if active_relic.name == "2UP" then
			return true
		end
	end
	return false
end

local CoreDrillIsActive = function()
	for active_relic in ivalues(ECS.Player.Relics) do
		if active_relic.name == "Core Drill" then
			return true
		end
	end
	return false
end

local EricsIronSlabIsActive = function()
	for active_relic in ivalues(ECS.Player.Relics) do
		if active_relic.name == "eric's iron slab" then
			return true
		end
	end
	return false
end

local FutonIsActive = function()
	for active_relic in ivalues(ECS.Player.Relics) do
		if active_relic.name == "Futon" then
			return true
		end
	end
	return false
end

local DryBonesPlushIsActive = function()
	for active_relic in ivalues(ECS.Player.Relics) do
		if active_relic.name == "Dry Bones Plush" then
			return true
		end
	end
	return false
end


if ExtensionlessFileIsActive() then
	local ExtensionlessCallback = function(event)
		if not event.PlayerNumber or not event.button then return false end

		if event.type == "InputEventType_FirstPress" and event.GameButton == "Start" then
			MESSAGEMAN:Broadcast("DismissError")
		end

		return false
	end

	local pause_time = -1
	local unpause_time = -1

	local UpdateText = function(self, delta)
		if pause_time == -1 and unpause_time == -1 then return end

		if unpause_time == -1 then
			local elapsed = GetTimeSinceStart() - pause_time
			-- Player has 10 seconds to dismiss the message.
			local max_time = 5
			local time_remaining = max_time - elapsed
			if time_remaining <= 0 then
				STATSMAN:GetCurStageStats():GetPlayerStageStats(player):FailPlayer()
				if not SCREENMAN:GetTopScreen():IsTransitioning() then
					SCREENMAN:GetTopScreen():StartTransitioningScreen("SM_DoNextScreen")
				end
			else
				local text = ("%.1f"):format(time_remaining)
				self:GetChild("Timer"):settext("Must dismiss in "..text.." seconds or will fail!")
			end
		else
			local elapsed = GetTimeSinceStart() - unpause_time
			-- Give the player a short moment to unpause to get back to the pad.
			local max_time = 2
			local time_remaining = max_time - elapsed
			if time_remaining <= 0 then
				pause_time = -1
				unpause_time = -1
				self:queuecommand("Hide")
			else
				local text = ("%.1f"):format(time_remaining)
				self:GetChild("Timer"):settext("Starting in "..text.." seconds")
			end
		end
	end

	af[#af+1] = Def.ActorFrame{
		InitCommand=function(self) self:Center() self:SetUpdateFunction( UpdateText ) self:visible(false) end,
		OnCommand=function(self) SCREENMAN:GetTopScreen():AddInputCallback( ExtensionlessCallback ) self:queuecommand("Sleep") end,
		SleepCommand=function(self)
			local totalseconds = GAMESTATE:GetCurrentSong():MusicLengthSeconds() / SL.Global.ActiveModifiers.MusicRate
			local random_time = math.random(1, math.floor(totalseconds))
			self:sleep(random_time):queuecommand("Pause")
		end,
		PauseCommand=function(self)
			pause_time = GetTimeSinceStart()
			self:visible(true)
			SCREENMAN:GetTopScreen():PauseGame(true)
		end,
		DismissErrorMessageCommand=function(self)
			if pause_time ~= -1 then
				pause_time = -1
				unpause_time = GetTimeSinceStart()
				SCREENMAN:GetTopScreen():PauseGame(true)
			end
		end,
		HideCommand=function(self)
			self:visible(false)
			SCREENMAN:GetTopScreen():PauseGame(false)
		end,

		-- slightly darken the entire screen
		Def.Quad {
			InitCommand=function(self) self:FullScreen():diffuse(Color.Black):diffusealpha(0.6) end
		},

		Def.Sprite{
			Texture=THEME:GetPathG("","_ECS/extensionless.png"),
		},

		LoadFont("Common Normal")..{
			Name="Timer",
			InitCommand=function(self)
				self:y(100)
			end,
		},

		LoadFont("Common Normal")..{
			Text="Press &START; to Dismiss",
			InitCommand=function(self)
				self:y(200)
			end,
		},
	}
end

if WrenchIsActive() then
	-- The audio is 4 measures of 214 BPM
	local bpm = 214
	local player_state = GAMESTATE:GetPlayerState(GAMESTATE:GetMasterPlayerNumber())
	local prev_measure = -1
	local first_step_passed = false
	local Update = function(self, delta)
		local cur_measure = (math.floor(player_state:GetSongPosition():GetSongBeatVisible()))/4

		if cur_measure % 4 == 0 and cur_measure > prev_measure then
			prev_measure = cur_measure
			self:GetChild("Wrench"):queuecommand("Play")
		end
	end


	af[#af+1] = Def.ActorFrame{
		InitCommand=function(self)
			self:queuecommand("SetUpdate")
		end,
		SetUpdateCommand=function(self) self:SetUpdateFunction( Update ) end,

		Def.Sound{
			Name="Wrench",
			File=THEME:GetPathG("","_ECS/darkpsy.ogg"),
			SupportRateChanging=true,
			PlayCommand=function(self)
				self:stop()
				local ragesound = self:get()
				local song_position = player_state:GetSongPosition()
				local so = GAMESTATE:GetSongOptionsObject("ModsLevel_Song")
				local music_rate = so:MusicRate()
				local cur_bpm = song_position:GetCurBPS() * 60 * music_rate

				ragesound:speed(cur_bpm / bpm)
				self:play()
			end,
		}
	}
end

if IVBagIsActive() then
	local songLength = GAMESTATE:GetCurrentSong():MusicLengthSeconds()
	local interval = 20

	af[#af+1] = Def.ActorFrame{
		OnCommand=function(self)
			self:queuecommand("Loop")
		end,
		LoopCommand=function(self)
			local cur_second = GAMESTATE:GetPlayerState(player):GetSongPosition():GetMusicSeconds()
			local percentage = cur_second / songLength * 100
			
			if percentage >= interval and interval < 100 then
				interval = interval + 20
				local playerAf = GetPlayerAF(ToEnumShortString(player))
				playerAf:SetLife(1.0)
				SM("Set Life to 100%")
			end

			if interval < 100 then
				self:sleep(1):queuecommand("Loop")
			end
		end,
	}
end

if TwoUpIsActive() then
	local lives = 2

	af[#af+1] = Def.ActorFrame{
		LifeChangedMessageCommand=function(self,params)
			if params.Player == player then
				local top_screen = SCREENMAN:GetTopScreen()
				if top_screen ~= nil then
					local lifemeter = top_screen:GetLifeMeter(player)
					local cur_life = lifemeter:GetLife()
					if cur_life <= 0.10 and lives > 0 then
						self:queuecommand("SetTwoUpLife")
					end
				end
			end
		end,
		SetTwoUpLifeCommand=function(self)
			local playerAf = GetPlayerAF(ToEnumShortString(player))
			playerAf:SetLife(1.0)
			lives = lives - 1
			SM("Set Life to 100%")
		end
	}
end

if CoreDrillIsActive() then
	local style_type = GAMESTATE:GetCurrentStyle():GetStyleType()
	local is_double = style_type == "StyleType_OnePlayerTwoSides" or style_type == "StyleType_TwoPlayersSharedSides"
	local core_drill_x = is_double and (player == PLAYER_1 and SCREEN_LEFT + 170 or SCREEN_RIGHT - 170) or SCREEN_CENTER_X
	local panelsPerGame = {
		["dance"] = {
			"Left", "Down", "Up", "Right"
		},
		["pump"] = {
			"DownLeft", "Upleft", "Center", "UpRight", "DownRight",
		}
	}

	local game = GAMESTATE:GetCurrentGame():GetName()
	local panels = panelsPerGame[game]
	local panel1 = nil
	local panel2 = nil
	local panel1name = nil
	local panel2name = nil

	local CoreDrillInputHandler = function(event)
		if event.PlayerNumber ~= player then return end

		if event.type == "InputEventType_FirstPress" then
			if (panel1name ~= nil and event.button == panel1name) or (panel2name ~= nil and event.button == panel2name) then
				ECS.Player.CoreDrillCount = ECS.Player.CoreDrillCount + 1
			end
		end
	end

	af[#af+1] = Def.ActorFrame{
		OnCommand=function(self)
			ECS.Player.CoreDrillCount = 0
			self:SetUpdateFunction(function(actor)
				actor:GetChild("CoreDrillPoints"):settext("Core Drill: "..math.min(ECS.Player.CoreDrillCount, 475).." BP")
			end)
			panel1 = math.random(1, #panels)
			panel2 = math.random(1, #panels)
			while panel1 == panel2 do
				panel2 = math.random(1, #panels)
			end
			panel1name = panelsPerGame[game][panel1]
			panel2name = panelsPerGame[game][panel2]
			SM("Core Drill Panels are: "..panel1name.." and "..panel2name)
			SCREENMAN:GetTopScreen():AddInputCallback(CoreDrillInputHandler)
		end,
		JudgmentMessageCommand=function(self, params)
			if params.Player == player then
				if params.Notes then
					for i, col in pairs(params.Notes) do
						if (i == panel1 or i == panel2 or i == panel1 + #panels or i == panel2 + #panels) then
							ECS.Player.CoreDrillCount = math.max(0, ECS.Player.CoreDrillCount - 1)
						end
					end
				end
			end
		end,
		Def.Quad{
			InitCommand=function(self)
				self:xy(core_drill_x, 80):zoomto(220, 30):diffuse(Color.Black):diffusealpha(0.7)
			end,
		},
		LoadFont("Common Normal")..{
			Name="CoreDrillPoints",
			InitCommand=function(self)
				self:xy(core_drill_x, 80):zoom(0.8):shadowlength(1):settext("Core Drill: 0 BP")
			end,
		},
	}
end

if EricsIronSlabIsActive() then
	local side = 64
	local step = side / 2
	local spawn_x = GetNotefieldX(player)
	local spawn_y = side / 2
	local bottom_y = SCREEN_HEIGHT - side / 2
	local placed = {}
	local current_block = 1
	local current_x, current_y = spawn_x, spawn_y
	local has_hit_arrow = false
	local slab_actor
	local directions = {
		Up={0, -step},
		Down={0, step},
		Left={-step, 0},
		Right={step, 0},
		DownLeft={-step, step},
		UpLeft={-step, -step},
		Center={0, 0},
		UpRight={step, -step},
		DownRight={step, step},
	}

	local EricsIronSlabInputHandler = function(event)
		if event.PlayerNumber ~= player then return end
		if event.type ~= "InputEventType_FirstPress" or current_block > 4 then return false end
		if not has_hit_arrow then return false end

		local direction = directions[event.button]
		if not direction then return false end

		local block = slab_actor:GetChild("Block"..current_block)
		local x, y = current_x + direction[1], current_y + direction[2]
		if direction[2] > 0 and y > bottom_y then y = bottom_y end
		if x < side / 2 or x > SCREEN_WIDTH - side / 2 or y < side / 2 or y > bottom_y then return false end

		for _, position in ipairs(placed) do
			if math.abs(x - position.x) < side and math.abs(y - position.y) < side then return false end
		end

		block:xy(x, y)
		current_x, current_y = x, y
		if y == bottom_y then
			placed[#placed + 1] = {x=x, y=y}
			ECS.Player.EricsIronSlabCount = #placed
			current_block = current_block + 1
			if current_block <= 4 then
				current_x, current_y = spawn_x, spawn_y
				slab_actor:GetChild("Block"..current_block):xy(spawn_x, spawn_y):visible(true)
			end
		end
		return false
	end

	local iron_slabs = Def.ActorFrame{
		Name="IronSlabs",
		OnCommand=function(self)
			slab_actor = self
			ECS.Player.EricsIronSlabCount = 0
			SCREENMAN:GetTopScreen():AddInputCallback(EricsIronSlabInputHandler)
		end,
		JudgmentMessageCommand=function(self, params)
			if params.Player ~= player or not params.TapNoteScore then return end
			local score = ToEnumShortString(params.TapNoteScore)
			if score ~= "HitMine" and score ~= "AvoidMine" then
				has_hit_arrow = true
			end
		end,
	}

	for i=1,4 do
		local block_index = i
		iron_slabs[#iron_slabs+1] = Def.Sprite{
			Texture=THEME:GetPathG("","_ECS/slab.png"),
			Name="Block"..block_index,
			InitCommand=function(self)
				self:xy(spawn_x, spawn_y):zoom(0.25):visible(block_index == 1)
			end,
		}
	end
	af[#af+1] = iron_slabs
end

if FutonIsActive() then
	local is_paused = false
	local has_paused_once = false
	local is_unpausing = false
	local pause_timeout_at = 0
	local pause_timeout_seconds = 5 * 60
	local unpause_at = 0
	local unpause_countdown_seconds = 3
	local pause_delay_seconds = 1
	local style_type = GAMESTATE:GetCurrentStyle():GetStyleType()
	local is_double = style_type == "StyleType_OnePlayerTwoSides" or style_type == "StyleType_TwoPlayersSharedSides"
	local prompt_x = is_double and (player == PLAYER_1 and SCREEN_LEFT + 170 or SCREEN_RIGHT - 170) or SCREEN_CENTER_X
	local prompt_y = SCREEN_CENTER_Y

	local CanPauseFuton = function()
		local music_rate = tonumber(SL.Global.ActiveModifiers.MusicRate) or 1
		local music_seconds = GAMESTATE:GetPlayerState(player):GetSongPosition():GetMusicSeconds()
		return not has_paused_once and music_seconds > 0 and music_seconds / music_rate >= pause_delay_seconds
	end

	local BeginFutonUnpause = function()
		if is_paused and not is_unpausing then
			is_unpausing = true
			unpause_at = GetTimeSinceStart() + unpause_countdown_seconds
			MESSAGEMAN:Broadcast("FutonUnpausing")
		end
	end

	local ResumeFuton = function()
		if not is_paused or not is_unpausing or GetTimeSinceStart() < unpause_at then return end
		MESSAGEMAN:Broadcast("FutonUnpaused")
	end

	local UpdateFuton = function(self)
		local can_pause = not is_paused and CanPauseFuton()
		self:GetChild("FutonPausePromptBackdrop"):visible(can_pause)
		self:GetChild("FutonPausePromptText"):visible(can_pause)
		if not is_paused then return end

		local pause_overlay = self:GetChild("FutonPauseOverlay")
		local now = GetTimeSinceStart()
		if is_unpausing then
			local remaining_seconds = math.max(0, math.ceil(unpause_at - now))
			pause_overlay:GetChild("FutonPauseTimer"):settext(SecondsToMMSS(remaining_seconds))
			if now >= unpause_at then ResumeFuton() end
		else
			local remaining_seconds = math.max(0, math.ceil(pause_timeout_at - now))
			pause_overlay:GetChild("FutonPauseTimer"):settext(SecondsToMMSS(remaining_seconds))
			if now >= pause_timeout_at then BeginFutonUnpause() end
		end
	end

	local FutonInputHandler = function(event)
		if event.PlayerNumber and event.PlayerNumber ~= player then return false end
		if event.type ~= "InputEventType_FirstPress" or event.GameButton ~= "Start" then return false end

		if is_paused then
			BeginFutonUnpause()
		elseif CanPauseFuton() then
			is_paused = true
			has_paused_once = true
			pause_timeout_at = GetTimeSinceStart() + pause_timeout_seconds
			SCREENMAN:set_input_redirected(player, true)
			SCREENMAN:GetTopScreen():PauseGame(true)
			MESSAGEMAN:Broadcast("FutonPaused")
		end
		return true
	end

	af[#af+1] = Def.ActorFrame{
		OnCommand=function(self)
			SCREENMAN:GetTopScreen():AddInputCallback(FutonInputHandler)
			self:SetUpdateFunction(UpdateFuton)
		end,
		FutonUnpausedMessageCommand=function(self)
			if not is_paused or not is_unpausing or GetTimeSinceStart() < unpause_at then return end
			SCREENMAN:GetTopScreen():PauseGame(false)
			SCREENMAN:set_input_redirected(player, false)
			is_paused = false
			is_unpausing = false
			pause_timeout_at = 0
			unpause_at = 0
		end,

		Def.ActorFrame{
			Name="FutonPauseOverlay",
			InitCommand=function(self) self:xy(SCREEN_CENTER_X, SCREEN_CENTER_Y-70):visible(false) end,
			FutonPausedMessageCommand=function(self)
				self:visible(true)
				self:GetChild("FutonPauseLabel"):settext("Auto-unpausing in:")
				self:GetChild("FutonPauseTimer"):settext(SecondsToMMSS(pause_timeout_seconds))
			end,
			FutonUnpausingMessageCommand=function(self)
				self:GetChild("FutonPauseLabel"):settext("Unpausing in:")
				self:GetChild("FutonPauseTimer"):settext(SecondsToMMSS(unpause_countdown_seconds))
			end,
			FutonUnpausedMessageCommand=function(self) self:visible(false) end,
			Def.Quad{
				InitCommand=function(self) self:FullScreen():diffuse(Color.Black):diffusealpha(0.4) end,
			},
			Def.Quad{
				InitCommand=function(self) self:diffuse(Color.White):zoomto(202, 202) end,
			},
			Def.Quad{
				InitCommand=function(self) self:diffuse(Color.Black):zoomto(200, 200) end,
			},
			LoadFont("Common Normal")..{
				Name="FutonPauseLabel",
				InitCommand=function(self)
					self:y(-52):settext("Auto-unpausing in:")
				end,
			},
			LoadFont("Common Normal")..{
				Name="FutonPauseTimer",
				InitCommand=function(self)
					self:y(-27):settext(SecondsToMMSS(pause_timeout_seconds))
				end,
			},
			LoadFont("Common Normal")..{
				InitCommand=function(self)
					self:y(40):wrapwidthpixels(200):settext("Press &START; to Resume!")
				end,
			},
			LoadActor(THEME:GetPathB("", "_modules/TestInput Pad/default.lua"), {Player=player, ShowMenuButtons=false, ShowPlayerLabel=false})..{
				InitCommand=function(self) self:zoom(0.8):y(260) end,
			},
		},

		Def.Quad{
			Name="FutonPausePromptBackdrop",
			InitCommand=function(self)
				self:xy(prompt_x, prompt_y):zoomto(160, 34):diffuse(Color.Black):diffusealpha(0.85):visible(false)
			end,
		},
		LoadFont("Common Normal")..{
			Name="FutonPausePromptText",
			InitCommand=function(self)
				self:xy(prompt_x, prompt_y):shadowlength(1):settext("&START; to Pause"):visible(false)
			end,
		},
	}
end

if DryBonesPlushIsActive() then
	local quiz_questions = {
		{rating=11, bpm=122, breakdown="15 15 16 (4) 2 13 15 15"},
		{rating=12, bpm=145, breakdown="4 (2) 6 (2) 2 1 (2) 3 13 2 (2) 12 3 1 (2) 3 13 10 (3) 6 13 2 (4) 1"},
		{rating=12, bpm=150, breakdown="7 7 4 (2) 1 8 (4) 7 (5) 3 4 (2) 1 8 (4) 7 (7) 1 4 (2) 1 (9) 8 (4) 7"},
		{rating=13, bpm=140, breakdown="7 8 (6) 1 79 (19) 47"},
		{rating=13, bpm=140, breakdown="34 (8) 24 (7) 1 (7) 5 (2) 5 (3) 65 67"},
		{rating=13, bpm=150, breakdown="3 7 15 15 23 15 8 (16) 15 16"},
		{rating=14, bpm=165, breakdown="15 15 15 32 (3) 16 (17) 36"},
		{rating=16, bpm=174, breakdown="15 (7) 2 (8) 16 13 (8) 2 (8) 15 (17) 7 8 (6) 2 (8) 32 (6) 2 (8) 15"},
		{rating=16, bpm=183, breakdown="119 (11) 58"},
		{rating=16, bpm=203, breakdown="1 16 (22) 1 32 (22) 1 64"},
		{rating=17, bpm=190, breakdown="23 8 18 8 7 3 12 (2) 31 (4) 1 1 (9) 8 (4) 40 (13) 14 (4) 13 (3) 6 6 8 1 (2) 2 2 (16) 79"},
		{rating=18, bpm=205, breakdown="39 16 (8) 55 32"},
		{rating=18, bpm=210, breakdown="144 (24) 32 (2) 12"},
		{rating=19, bpm=216, breakdown="37 96"},
		{rating=19, bpm=215, breakdown="7 7 3 26 24 10 19 7 21 4 (3) 1 (15) 7 31 19 5 1 19 3 15 23 20 (2) 19 2 2 (2) 2 4"},
		{rating=19, bpm=228, breakdown="40 (8) 8 (2) 40 (7) 1 (7) 1 (8) 32 (4) 28"},
		{rating=20, bpm=208, breakdown="129 28 (2) 2 (24) 3 7 4 114 119"},
		{rating=20, bpm=214, breakdown="15 15 7 7 38 (2) 23 6 (2) 7 7 15 31 15 95 23 23 47 32"},
		{rating=20, bpm=230, breakdown="7 60 (4) 8 (8) 40 (16) 64 (4) 28"},
		{rating=21, bpm=220, breakdown="7 39 32 (24) 7 15 16 (8) 9 23 8 (8) 39 16 (3) 1 2 15 78 (2) 18 (2) 3 14 (2) 7 14 (2) 6 (2) 6 (2) 7 17 1 18 (2) 14 (2) 14 (2) 48 (10) 49 32"},
		{rating=21, bpm=230, breakdown="13 (11) 4 (8) 12 (2) 25 (3) 5 (3) 32 (2) 14 (2) 46 (22) 8 (2) 14 (4) 13 5 (3) 20 (24) 14 (4) 32 (32) 32 (16) 16 (8) 21 (3) 64 (20) 30 (2) 8 (10) 13 (11) 4 (8) 12 (2) 25 (3) 5"},
		{rating=21, bpm=240, breakdown="16 (16) 14 (2) 31 (10) 63 (3) 16 (8) 27 16"},
		{rating=21, bpm=250, breakdown="32 (16) 36 (17) 1 (2) 32 (16) 36 (17) 1 (2) 6"},
		{rating=22, bpm=244, breakdown="71 64 (32) 72"},
		{rating=23, bpm=240, breakdown="15 80 (16) 15 16 (15) 16 (17) 145 23 8 (16) 31 16 (18) 7 7 11 3 (17) 48 (15) 29 (2) 34"},
		{rating=23, bpm=250, breakdown="62 (2) 78 (2) 44"},
		{rating=24, bpm=262, breakdown="19 15 11 (5) 15 (5) 16 (6) 9 (5) 7 (11) 7 8 1 5 3 1 1 1 (3) 3 7 (5) 5 (3) 7 (7) 1 13 (3) 13 (4) 2 3 (2) 2 (3) 9 (2) 2 (2) 1 15 1 5 1 1 8 (4) 16 (2) 14"},
		{rating=24, bpm=261, breakdown="/16/ (14) 1 /49/ (4) /64/ (18) /34/"},
		{rating=26, bpm=299, breakdown="/16/ (16) /21/ 1 (24) /22/ (28) /35/"},
		{rating=27, bpm=290, breakdown="64 (17) 32 (17) 32 (2) 32 (17) 32 (17) 72"},
		{rating=28, bpm=290, breakdown="32 (36) 64 (2) 64 (2) 60 (2) 18 (2) 96 (4) 36"},
	}
	local question = nil
	local options = {}
	local selected = 1
	local answered = false
	local quiz_actor = nil
	local quiz_break_time = 0

	local UpdateChoices = function()
		for i=1,#options do
			local choice = quiz_actor:GetChild("QuizChoices"):GetChild("Choice"..i)
			choice:settext((i == selected and "> " or "  ")..options[i])
			choice:diffuse(answered and i == selected and (ECS.Player.DryBonesPlushCorrect and color("#00ff00") or color("#ff3030")) or color("#ffffff"))
		end
	end

	local DryBonesInputHandler = function(event)
		if not event.PlayerNumber or not event.button or event.PlayerNumber ~= player then return false end
		if event.type ~= "InputEventType_FirstPress" then return false end

		local button = event.GameButton or event.button
		if button == "Left" or button == "MenuLeft" then
			if answered then return false end
			selected = (selected - 2) % #options + 1
			UpdateChoices()
		elseif button == "Right" or button == "MenuRight" then
			if answered then return false end
			selected = selected % #options + 1
			UpdateChoices()
		elseif button == "Start" and not answered then
			answered = true
			ECS.Player.DryBonesPlushCorrect = options[selected] == question.rating
			UpdateChoices()
			quiz_actor:GetChild("QuizPrompt"):settext(ECS.Player.DryBonesPlushCorrect and "Correct!" or "Incorrect!")
			quiz_actor:queuecommand("CountdownThree")
		end
		return false
	end

	af[#af+1] = Def.ActorFrame{
		Name="DryBonesQuiz",
		InitCommand=function(self) self:visible(false) end,
		OnCommand=function(self)
			quiz_actor = self
			self:SetUpdateFunction(function(actor, delta)
				if not ECS.Player.DryBonesPlushQuizActive or answered then return end
				quiz_break_time = math.max(0, quiz_break_time - delta)
				actor:GetChild("QuizCountdown"):settext("Break time left: "..SecondsToMMSS(quiz_break_time))
			end)
			self:queuecommand("StartQuiz")
		end,
		StartQuizCommand=function(self)
			answered = false
			quiz_break_time = math.max(0, ECS.BreakTimer)
			ECS.Player.DryBonesPlushQuizActive = true
			ECS.Player.DryBonesPlushCorrect = false
			question = quiz_questions[math.random(#quiz_questions)]
			local triple_step = math.random(0, 1) == 0 and -1 or 1
			local single_step = -triple_step
			options = {
				question.rating,
				question.rating + single_step,
				question.rating + triple_step * 2,
				question.rating + triple_step * 3,
			}
			for i=#options,2,-1 do
				local j = math.random(i)
				options[i], options[j] = options[j], options[i]
			end
			selected = 1
			self:GetChild("QuizDetails"):settext(question.bpm.." BPM\n"..question.breakdown)
			self:GetChild("QuizCountdown"):settext("")
			UpdateChoices()
			self:visible(true)
			SCREENMAN:GetTopScreen():PauseGame(true)
			SCREENMAN:GetTopScreen():AddInputCallback(DryBonesInputHandler)
		end,
		CountdownThreeCommand=function(self)
			self:GetChild("QuizCountdown"):settext("Song will start in 3 seconds")
			self:sleep(1):queuecommand("CountdownTwo")
		end,
		CountdownTwoCommand=function(self)
			self:GetChild("QuizCountdown"):settext("Song will start in 2 seconds")
			self:sleep(1):queuecommand("CountdownOne")
		end,
		CountdownOneCommand=function(self)
			self:GetChild("QuizCountdown"):settext("Song will start in 1 second")
			self:sleep(1):queuecommand("ResumeSong")
		end,
		ResumeSongCommand=function(self)
			ECS.Player.DryBonesPlushQuizActive = false
			self:visible(false)
			SCREENMAN:GetTopScreen():PauseGame(false)
		end,

		Def.Quad{
			InitCommand=function(self) self:FullScreen():diffuse(Color.Black):diffusealpha(0.85) end,
		},
		Def.Quad{
			InitCommand=function(self) self:xy(SCREEN_CENTER_X, SCREEN_CENTER_Y):zoomto(600, 390):diffuse(Color.Black) end,
		},
		LoadFont("Common Normal")..{
			InitCommand=function(self) self:xy(SCREEN_CENTER_X, SCREEN_CENTER_Y-165):zoom(1.3):settext("Ratings Quiz") end,
		},
		LoadFont("Common Normal")..{
			Name="QuizDetails",
			InitCommand=function(self) self:xy(SCREEN_CENTER_X, SCREEN_CENTER_Y-100):wrapwidthpixels(560):settext("") end,
		},
		LoadFont("Common Normal")..{
			Name="QuizPrompt",
			InitCommand=function(self) self:xy(SCREEN_CENTER_X, SCREEN_CENTER_Y+15):settext("What is the chart rating?") end,
		},
		(function()
			local choices = Def.ActorFrame{Name="QuizChoices"}
			for i=1,4 do
				local choice_index = i
				choices[#choices+1] = LoadFont("Common Normal")..{
					Name="Choice"..choice_index,
					InitCommand=function(self) self:xy(SCREEN_CENTER_X-210 + (choice_index-1)*140, SCREEN_CENTER_Y+70):zoom(1.2) end,
				}
			end
			return choices
		end)(),
		LoadFont("Common Normal")..{
			InitCommand=function(self)
				self:xy(SCREEN_CENTER_X, SCREEN_CENTER_Y+140):zoom(0.8):settext("&LEFT; / &RIGHT; to choose, &START; to answer")
			end,
		},
		LoadFont("Common Normal")..{
			Name="QuizCountdown",
			InitCommand=function(self) self:xy(SCREEN_CENTER_X, SCREEN_CENTER_Y+175):zoom(0.8):settext("") end,
		},
	}
end

if GoldDustIsActive() then
	local songLength = GAMESTATE:GetCurrentSong():MusicLengthSeconds() / SL.Global.ActiveModifiers.MusicRate
	local gravity = 98.1
	local height = SCREEN_HEIGHT -- Should be 480


	af[#af+1] = Def.ActorFrame{
		Def.Quad{
			InitCommand=function(self)
				self:SetWidth(10):SetHeight(height):diffuse(color("#ffbb00")):x(SCREEN_CENTER_X):y(-height/2)
			end,
			OnCommand=function(self)
				self:accelerate(height / gravity):y(height/2)
				self:queuecommand("Wait")
			end,
			WaitCommand=function(self)
				self:sleep(songLength - height/gravity):queuecommand("Finish")
			end,
			FinishCommand=function(self)
				self:decelerate(height / gravity):y(SCREEN_HEIGHT + height/2)
			end,
		},

		Def.Sprite{
			Texture=THEME:GetPathG("","_ECS/sand.png"),
			InitCommand=function(self)
				self:Center():y(height):zoom(height/1080)
			end,
			OnCommand=function(self)
				self:linear(songLength):y(height/2+70)
			end,
		}
	}

end

if SeaRingIsActive() then
	local dirTime = 2

	local textureWidth = 1280
	local textureHeight = 96
	local zoom = 0.5
	local bodyHeight = SCREEN_HEIGHT / zoom

	local numTextures = 3

	local songLength = GAMESTATE:GetCurrentSong():MusicLengthSeconds() / SL.Global.ActiveModifiers.MusicRate
	local loops = math.ceil(songLength / dirTime)
	
	local totalHeight = SCREEN_HEIGHT + textureHeight / 2

	-- We want to go up and down, but down shouldn't go as far as up since we
	-- want the level to rise throughout the chart.
	-- It should scale totalHeight with the number of loops.
	local upChange = -totalHeight / (loops / 4)
	local downChange = -upChange / 2

	local maxShift = 3
	local curShift = 0
	local shiftOffset = 25

	local seaLevels = Def.ActorFrame{
		InitCommand=function(self)
			self:xy(SCREEN_CENTER_X, totalHeight):zoom(zoom)
		end,

		OnCommand=function(self)
			self:queuecommand("GoUp")
		end,

		GoUpCommand=function(self)
			local x = curShift
			if x == -1 * maxShift then
				x = x + 1
			elseif x == maxShift then
				x = x - 1
			else
				local rand = math.random(0, 1)
				if rand == 0 then rand = -1 end
				x = rand + x
			end
			curShift = x

			self:spring(dirTime):x(shiftOffset * x):addy(upChange):queuecommand("GoDown")
		end,

		GoDownCommand=function(self)
			local x = curShift
			if x == -1 * maxShift then
				x = x + 1
			elseif x == maxShift then
				x = x - 1
			else
				local rand = math.random(0, 1)
				if rand == 0 then rand = -1 end
				x = rand + x
			end
			curShift = x


			self:spring(dirTime):x(shiftOffset * x):addy(downChange):queuecommand("GoUp")
		end,
		
		Def.Quad{
			InitCommand=function(self)
				-- Take me out of heeeerrreeeee
				local waterColour = "#0072FF"
				local alpha = 0.6

				self:SetWidth(textureWidth*numTextures)
						:SetHeight(bodyHeight)
						:diffusetopedge(0, 0.445313, 1, alpha)
						:diffusebottomedge(0, 0.445313, 1, 1)
						:y(textureHeight/2 + bodyHeight/2 + 1)
			end,
		},

		-- Add some padding at the end.
		Def.Quad{
			InitCommand=function(self)
				self:SetWidth(textureWidth*numTextures)
						:SetHeight(bodyHeight)
						:diffuse(color("0,0.445313,1"))
						:y(textureHeight/2 + bodyHeight/2 + bodyHeight + 1)
			end,
		},
	}

	for i=1,numTextures do
		local offset = ((numTextures - 1) / 2 + (i - numTextures)) * textureWidth

		seaLevels[#seaLevels+1] = Def.Sprite{
			Texture=THEME:GetPathG("","_ECS/sealevel.png"),
			InitCommand=function(self)
				self:x(offset)
			end,
		}
	end

	af[#af+1] = seaLevels
end

if IsPlayingMarathon() then
	af[#af+1] = Def.ActorFrame{
		OnCommand=function(self)
			-- Force 1.0x unless a relic explicitly changes Marathon rate.
			if not DaggerOfTimeIsActive() and not KappaPlushIsActive() then
				GAMESTATE:ApplyGameCommand("mod,1.0xmusic")
				SL.Global.ActiveModifiers.MusicRate = 1
			end

			ECS.Player.MarathonRateMod = SL.Global.ActiveModifiers.MusicRate
		end
	}
end

local second_to_pause = {
	["lower"] = 1725.251099,
	["mid"] = 1847.469482,
	["upper"] = 2046.740967,
}

local pause_duration_seconds = 300
local elapsed_seconds = 0

local InputHandler = function(event)
	if not event.PlayerNumber or not event.button then return false end

	MESSAGEMAN:Broadcast("TestInputEvent", event)

	if event.type == "InputEventType_FirstPress" and event.GameButton == "Start" then
		MESSAGEMAN:Broadcast("UnpauseMarathon")
	end

	return false
end

if ECS.Mode == "Marathon" and FaustsScalpelIsActive() and IsPlayingMarathon() then
	af[#af+1] = Def.ActorFrame{
		InitCommand=function(self) end,
		OnCommand=function(self) SCREENMAN:GetTopScreen():AddInputCallback( InputHandler ) self:queuecommand("Loop") end,
		LoopCommand=function(self)
			if GAMESTATE:GetNumPlayersEnabled() == 1 then
				-- We don't need to divide by rate since we always want the break to happen in the same spot regardless.
				local cur_second = GAMESTATE:GetPlayerState(player):GetSongPosition():GetMusicSeconds()
				if cur_second >= second_to_pause[GetDivision()] then
					self:queuecommand("PauseMarathon")
				else
					self:sleep(0.1):queuecommand("Loop")
				end
			end
		end,
		PauseMarathonCommand=function(self)
			SCREENMAN:GetTopScreen():PauseGame(true)
			self:queuecommand("Wait")
		end,
		WaitCommand=function(self)
			if SCREENMAN:GetTopScreen():IsPaused() then
				elapsed_seconds = elapsed_seconds + 1
				if elapsed_seconds < pause_duration_seconds then
					self:sleep(1):queuecommand("Wait")
				else
					MESSAGEMAN:Broadcast("UnpauseMarathon")
				end
			end
		end,
		UnpauseMarathonMessageCommand=function(self)
			if SCREENMAN:GetTopScreen():IsPaused() then
				SCREENMAN:GetTopScreen():PauseGame(false)
			end
		end,

		Def.ActorFrame {
			InitCommand=function(self) self:xy(SCREEN_CENTER_X, SCREEN_CENTER_Y-70):visible(false) end,
			WaitCommand=function(self)
				if SCREENMAN:GetTopScreen():IsPaused() then
					self:visible(true)
				end
			end,
			UnpauseCommand=function(self) self:visible(false) end,
			-- slightly darken the entire screen
			Def.Quad {
				InitCommand=function(self) self:FullScreen():diffuse(Color.Black):diffusealpha(0.4) end
			},
			Def.Quad {
				InitCommand=function(self) self:diffuse(Color.White):zoomto(202, 202) end
			},
			Def.Quad {
				InitCommand=function(self) self:diffuse(Color.Black):zoomto(200, 200) end
			},
			LoadFont("Common Normal")..{
				InitCommand=function(self)
					local text = "You may end your break time early by pressing the &START; button"
					self:y(40):wrapwidthpixels(200):settext(text)
				end,
			},
			LoadActor( THEME:GetPathB("", "_modules/TestInput Pad/default.lua"), {Player=player, ShowMenuButtons=false, ShowPlayerLabel=false})..{
				InitCommand=function(self)
					self:zoom(0.8):y(260)
				end,
			}
		},

		LoadFont("Common Normal")..{
			InitCommand=function(self)
				local w = SL_WideScale(310, 417)
				self:horizalign(left):xy(_screen.cx + w/2 + 105, 20)
			end,
			LoopCommand=function(self)
				local cur_second = GAMESTATE:GetPlayerState(player):GetSongPosition():GetMusicSeconds()
				if cur_second > 0 then
					if cur_second < second_to_pause[GetDivision()] then
						self:settext(SecondsToMMSS((second_to_pause[GetDivision()] - cur_second + 1)/SL.Global.ActiveModifiers.MusicRate))
					end
				end
			end,
			WaitCommand=function(self)
				local remaining_pause_duration = pause_duration_seconds - elapsed_seconds + 1
				self:horizalign(center):xy(SCREEN_CENTER_X, SCREEN_CENTER_Y-95)
				if remaining_pause_duration >= 0 then
					if remaining_pause_duration <= 5 then
						self:diffuse(color("#ff3030"))
					end
					self:settext(SecondsToMMSS(remaining_pause_duration))
				end
			end,
			UnpauseMarathonMessageCommand=function(self)
				self:visible(false)
			end,
		},
		LoadFont("Common Normal")..{
			InitCommand=function(self)
				local w = SL_WideScale(310, 417)
				self:horizalign(right):xy(_screen.cx + w/2 + 95, 20):settext("Pausing in:"):visible(true)
			end,
			WaitCommand=function(self)
				self:horizalign(center):xy(SCREEN_CENTER_X, SCREEN_CENTER_Y-120)
				self:settext("Unpausing in:")
			end,
			UnpauseMarathonMessageCommand=function(self)
				self:visible(false)
			end,
		},
	}
end

return af
