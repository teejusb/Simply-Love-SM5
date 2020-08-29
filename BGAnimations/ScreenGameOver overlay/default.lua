local Players = GAMESTATE:GetHumanPlayers();

local t = Def.ActorFrame{
	LoadFont("Wendy/_wendy white")..{
		Text="GAME",
		InitCommand=function(self) self:xy(_screen.cx,_screen.cy-40):croptop(1):fadetop(1):zoom(1.2):shadowlength(1) end,
		OnCommand=function(self) self:decelerate(0.5):croptop(0):fadetop(0):glow(1,1,1,1):decelerate(1):glow(1,1,1,1) end,
		OffCommand=function(self) self:accelerate(0.5):fadeleft(1):cropleft(1) end
	},
	LoadFont("Wendy/_wendy white")..{
		Text="OVER",
		InitCommand=function(self) self:xy(_screen.cx,_screen.cy+40):croptop(1):fadetop(1):zoom(1.2):shadowlength(1) end,
		OnCommand=function(self) self:decelerate(0.5):croptop(0):fadetop(0):glow(1,1,1,1):decelerate(1):glow(1,1,1,1) end,
		OffCommand=function(self) self:accelerate(0.5):fadeleft(1):cropleft(1) end
	},

	--Player 1 Stats BG
	Def.Quad{
		InitCommand=function(self)
			self:zoomto(160,_screen.h):xy(80, _screen.h/2):diffuse(color("#00000099"))
			if ThemePrefs.Get("RainbowMode") then self:diffuse(color("#000000dd")) end
		end,
	},

	--Player 2 Stats BG
	Def.Quad{
		InitCommand=function(self)
			self:zoomto(160,_screen.h):xy(_screen.w-80, _screen.h/2):diffuse(color("#00000099"))
			if ThemePrefs.Get("RainbowMode") then self:diffuse(color("#000000dd")) end
		end,
	},
}

if ECS.Mode == "ECS" or ECS.Mode == "Marathon" then
	t[#t+1] = LoadFont("Wendy/_wendy white")..{
		Text="Final Set Points",
		InitCommand=function(self) self:xy(_screen.cx,_screen.cy-200):croptop(1):fadetop(1):zoom(0.3):shadowlength(1) end,
		OnCommand=function(self) self:decelerate(0.5):croptop(0):fadetop(0):glow(1,1,1,1):decelerate(1):glow(1,1,1,1) end,
		OffCommand=function(self) self:accelerate(0.5):fadeleft(1):cropleft(1) end
	}

	t[#t+1] = LoadFont("Wendy/_wendy white")..{
		InitCommand=function(self) self:xy(_screen.cx,_screen.cy-150):croptop(1):fadetop(1):zoom(0.8):shadowlength(1) end,
		OnCommand=function(self)
			self:decelerate(0.5):croptop(0):fadetop(0):glow(1,1,1,1):decelerate(1):glow(1,1,1,1)

			-- NOTE(teejusb): The code below also works for marathons. The SongsPlayed table would only
			-- contain the marathon, and any MP giving relics are alread accounted for. The End-of-set
			-- relics won't be active as they're not selectable during the marathon.

			-- First add best 7 scores
			local total_points = 0
			for i=1,7 do
				if ECS.Player.SongsPlayed[i] ~= nil then
					total_points = total_points + ECS.Player.SongsPlayed[i].points
				end
			end

			-- Then handle end of set relics
			-- First check which end of set relics were active.
			local slime_badge, agility_potion, stamina_potion = false, false, false
			for song_played in ivalues(ECS.Player.SongsPlayed) do
				if not song_played.failed then
					for relic in song_played.relics_used do
						if relic.name == "Slime Badge" then
							slime_badge = true
						end
						if relic.name == "Agility Potion" then
							agility_potion = true
						end
						if relic.name == "Stamina Potion" then
							stamina_potion = true
						end
					end
				end
			end

			-- Then add in the additional BPM from them
			local songs_passed = 0
			local total_bpm = 0
			local tiers = {}
			local total_steps = 0
			for song_played in ivalues(ECS.Player.SongsPlayed) do
				if not song_played.failed then
					total_bpm = total_bpm + song_played.bpm
					tiers[song_played.bpm_tier] = tiers[song_played.bpm_tier] + 1
					total_steps = total_steps + song_played.steps
					songs_passed = songs_passed + 1
				end
			end

			if slime_badge then total_points = total_points + 100 * #tiers end
			if agility_potion then total_points = total_points + math.floor(((total_bpm / songs_passed) - 120)^1.3) end
			if stamina_potion then total_points = total_points + math.floor(total_steps / 75) end

			self:settext(tostring(total_points))
		end,
		OffCommand=function(self) self:accelerate(0.5):fadeleft(1):cropleft(1) end
	}
end

local line_height = 58
local profilestats_y = 138
local horiz_line_y   = 288
local normalstats_y  = 268

for player in ivalues(Players) do

	local stats
	local x_pos = player==PLAYER_1 and 80 or _screen.w-80
	local PlayerStatsAF = Def.ActorFrame{ Name="PlayerStatsAF_"..ToEnumShortString(player) }


	-- first, check if this player is using a profile (local or MemoryCard)
	if PROFILEMAN:IsPersistentProfile(player) then

		-- if a profile is in use, grab gameplay stats for this session that are pertinent
		-- to this specific player's profile (highscore name, calories burned, total songs played)
		local profile_stats = LoadActor("PlayerStatsWithProfile.lua", player)

		-- loop through those stats, adding them to the ActorFrame for this player as BitmapText actors
		for i,stat in ipairs(profile_stats) do
			PlayerStatsAF[#PlayerStatsAF+1] = LoadFont("Common Normal")..{
				Text=stat,
				InitCommand=function(self)
					self:diffuse(PlayerColor(player)):zoom(0.95)
						:xy(x_pos, (line_height*(i-1)) + profilestats_y)
						:maxwidth(150):vertspacing(-1)

					DiffuseEmojis(self)
				end
			}
		end

		PlayerStatsAF[#PlayerStatsAF+1] = LoadActor("./ProfileAvatar", {player, x_pos})
	end

	-- horizontal line separating upper stats (profile) from the lower stats (general)
	PlayerStatsAF[#PlayerStatsAF+1] = Def.Quad{
		InitCommand=function(self)
			self:zoomto(120,1):xy(x_pos, horiz_line_y)
				:diffuse( PlayerColor(player) )
		end
	}

	-- retrieve general gameplay session stats for which a profile is not needed
	stats = LoadActor("PlayerStatsWithoutProfile.lua", player)

	-- loop through those stats, adding them to the ActorFrame for this player as BitmapText actors
	for i,stat in ipairs(stats) do
		PlayerStatsAF[#PlayerStatsAF+1] = LoadFont("Common Normal")..{
			Text=stat,
			InitCommand=function(self)
				self:diffuse(PlayerColor(player)):zoom(0.95)
					:xy(x_pos, (line_height*i) + normalstats_y)
					:maxwidth(150):vertspacing(-1)
			end
		}
	end

	t[#t+1] = PlayerStatsAF
end

return t