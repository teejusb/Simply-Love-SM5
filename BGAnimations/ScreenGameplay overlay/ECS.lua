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

	if not IsPlayingFromPackForDivision() and not IsPlayingMarathon() then return end

	local attempt_number = ECS.Mode == "Speed" and ECS.SpeedAttemptNumber or 0

	-- ----------------------------------------------------------
	local base_theme_path = THEME:GetCurrentThemeDirectory()
	local path = base_theme_path.."ECSData/"..day..month_string..year.."-"..seconds.."-"..ECS.Players[profile_name].id.."-".."SCORE-"..ECS.Mode.."-"..attempt_number..".txt"

	local data = ""
	data = data..percent_score .."\n"
	data = data..passed_song.."\n"
	data = data..group_name.."\n"
	data = data..song_name.."\n"
	data = data..day.." "..month_string.." "..year.."\n"
	data = data..hour..":"..minute..":"..second

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
		local name =  relic and relic.name or "*"

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
			if active_relic.name == relic.name and relic.quantity ~= nil then
				relic.quantity = relic.quantity - 1
			end
		end
	end
end

-- ----------------------------------------------------------

local ApplyRelicActions = function()
	for active_relic in ivalues(ECS.Player.Relics) do
		active_relic.action(ECS.Player.Relics)
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

			if ECS.Player.MixTapesRandomSong == nil then
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

local second_to_pause = {
	["lower"] = 1835.285,
	["mid"] = 1499.724243,
	["upper"] = 1843.990967,
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