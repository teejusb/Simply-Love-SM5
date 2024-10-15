local Players = GAMESTATE:GetHumanPlayers();

local BreadsUsed = function(relics_used)
	local count = 0
	for relic in ivalues(relics_used) do
		local name = relic.name
		if (name == "Baguette" or name == "Khachapuri" or name == "Pain Brioche" or name == "Fougasse" or
			name == "Faluche") then
			count = count + 1
		end
	end
	return count
end

local IsSquirrelSong = function(song_data)
	return song_data.pack:find("Squirrel Metal") or song_data.pack:find("Squirrel Singles") or song_data.pack:find("Mozee Metal")
end

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
		end,
	},

	--Player 2 Stats BG
	Def.Quad{
		InitCommand=function(self)
			self:zoomto(160,_screen.h):xy(_screen.w-80, _screen.h/2):diffuse(color("#00000099"))
		end,
	},
}

if ECS.Mode == "ECS" or ECS.Mode == "Speed" or ECS.Mode == "Marathon" then
	t[#t+1] = LoadFont("Wendy/_wendy white")..{
		InitCommand=function(self) self:xy(_screen.cx,_screen.cy-200):croptop(1):fadetop(1):zoom(0.3):shadowlength(1) end,
		OnCommand=function(self)
			self:decelerate(0.5):croptop(0):fadetop(0):glow(1,1,1,1):decelerate(1):glow(1,1,1,1)
			if ECS.Mode == "ECS" or ECS.Mode == "Speed" then
				self:settext("Final Set Points")
			elseif ECS.Mode == "Marathon" then
				self:settext("Final Marathon Points")
			end
		end,
		OffCommand=function(self) self:accelerate(0.5):fadeleft(1):cropleft(1) end
	}

	t[#t+1] = LoadFont("Wendy/_wendy white")..{
		InitCommand=function(self) self:xy(_screen.cx,_screen.cy-150):croptop(1):fadetop(1):zoom(0.8):shadowlength(1) end,
		OnCommand=function(self)
			self:decelerate(0.5):croptop(0):fadetop(0):glow(1,1,1,1):decelerate(1):glow(1,1,1,1)

			-- Speed division doesn't have any relics but we can still go through the calculation below to total up the points.
			if ECS.Mode == "ECS" or ECS.Mode == "Speed" then

				-- Add best 7 scores and also check which end of set relics were active.
				local total_points = 0
				local slime_badge = 0
				local agility_potion = 0
				local stamina_potion = 0
				local accuracy_potion = 0
				local tpa_standard = 0
				local memepeace_beret = 0
				local despots_chapeau = 0
				local hellfire = 0

				for i=1,7 do
					local song_played = ECS.Player.SongsPlayed[i]
					if song_played ~= nil then
						total_points = total_points + song_played.points
						-- Relics are only active if you passed the song you used them on.
						if not song_played.failed then
							local kraken_multiplier = 1
							local slime_badge_used = false
							local agility_potion_used = false
							local stamina_potion_used = false
							local accuracy_potion_used = false
							local tpa_standard_used = false
							local memepeace_beret_used = false
							local despots_chapeau_used = false
							local hellfire_used = false

							for relic in ivalues(song_played.relics_used) do
								if relic.name == "Slime Badge" then
									slime_badge_used = true
								end
								if relic.name == "Agility Potion" then
									agility_potion_used = true
								end
								if relic.name == "Stamina Potion" then
									stamina_potion_used = true
								end
								if relic.name == "Accuracy Potion" then
									accuracy_potion_used = true
								end
								if relic.name == "TPA Standard" then
									tpa_standard_used = true
								end
								if relic.name == "Memepeace Beret" then
									memepeace_beret_used = true
								end
								if relic.name == "Despot's Chapeau" then
									despots_chapeau_used = true
								end
								if relic.name == "Kraken Club" then
									kraken_multiplier = 2
								end
								if relic.name == "Hellfire" then
									hellfire_used = true
								end
							end

							slime_badge = slime_badge + (slime_badge_used and 1 or 0) * kraken_multiplier
							agility_potion = agility_potion + (agility_potion_used and 1 or 0) * kraken_multiplier
							stamina_potion = stamina_potion + (stamina_potion_used and 1 or 0) * kraken_multiplier
							accuracy_potion = accuracy_potion + (accuracy_potion_used and 1 or 0) * kraken_multiplier
							tpa_standard = tpa_standard + (tpa_standard_used and 1 or 0) * kraken_multiplier
							memepeace_beret = memepeace_beret + (memepeace_beret_used and 1 or 0) * kraken_multiplier
							despots_chapeau = despots_chapeau + (despots_chapeau_used and 1 or 0) * kraken_multiplier
							hellfire = hellfire + (hellfire_used and 1 or 0) * kraken_multiplier
						end
					end
				end

				-- Add additional BP from the end of set relics
				local songs_passed = 0
				local songs_passed_not_in_top_7 = 0
				local total_bread = 0
				local total_bpm = 0
				local tiers = {}
				local total_steps = 0
				local total_score = 0
				local total_over_95 = 0
				local squirrel_songs = 0

				for song_played in ivalues(ECS.Player.SongsPlayed) do
					if not song_played.failed then
						total_bread = total_bread + BreadsUsed(song_played.relics_used)
						total_bpm = total_bpm + song_played.bpm
						if tiers[song_played.bpm_tier] == nil then
							tiers[song_played.bpm_tier] = 0
						end
						tiers[song_played.bpm_tier] = tiers[song_played.bpm_tier] + 1
						total_steps = total_steps + song_played.steps
						songs_passed = songs_passed + 1
						if songs_passed > 7 then
							songs_passed_not_in_top_7 = songs_passed_not_in_top_7 + 1
						end
						total_score = total_score + song_played.score
						if song_played.score >= 0.95 then
							total_over_95 = total_over_95 + 1
						end

						if IsSquirrelSong(song_played) then
							squirrel_songs = squirrel_songs + 1
						end
					end
				end
				local slime_tiers = 0
				local beret_tiers = 0
				for tier, num in pairs(tiers) do
					-- Slime badge only considers tiers below 210 now.
					if tier < 210 then
						slime_tiers = slime_tiers + 1
					-- While the Memepeace beret only considers tiers 210 and above
					else
						beret_tiers = beret_tiers + 1
					end
				end

				if slime_badge > 0 then total_points = total_points + (100 * slime_tiers) * slime_badge end
				if agility_potion > 0 then total_points = total_points + (math.floor((math.floor(total_bpm / songs_passed) - 120)^1.3)) * agility_potion end
				if stamina_potion > 0 then total_points = total_points + (math.floor(total_steps / 45)) * stamina_potion end
				if accuracy_potion > 0 then total_points = total_points + (math.max(math.floor(1000^(total_score / songs_passed)-50), 0)) * accuracy_potion end
				if tpa_standard > 0 then total_points = total_points + (100 * total_over_95) * tpa_standard end
				if memepeace_beret > 0 then total_points = total_points + (100 * beret_tiers) * memepeace_beret end
				if despots_chapeau > 0 then total_points = total_points + (20 * songs_passed + 130 * squirrel_songs) * despots_chapeau end
				if hellfire > 0 then total_points = total_points + math.floor((songs_passed) ^ 2.25) * hellfire end

				self:settext(tostring(total_points))
			elseif ECS.Mode == "Marathon" then
				local marathon_points = ECS.Player.TotalMarathonPoints
			
				local dagger_of_time = 0

				for active_relic in ivalues(ECS.Player.Relics) do
					if active_relic.name == "Dagger of Time" then
						dagger_of_time = dagger_of_time + 1
					end
				end

				if dagger_of_time > 0 then
					local rate_mod = ECS.Player.MarathonRateMod
					-- Clamp between 0.85 and 1.15
					rate_mod = math.max(0.85, math.min(1.15, rate_mod))

					local multiplier = 1
					if rate_mod > 1 then
						multiplier = 1 + ((rate_mod - 1) * 2)
					else
						multiplier = 1 - ((1 - rate_mod) * 4)
					end

					marathon_points = marathon_points * multiplier
				end

				self:settext(tostring(math.floor(marathon_points)))
			end
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
