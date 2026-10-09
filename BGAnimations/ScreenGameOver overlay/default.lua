local Players = GAMESTATE:GetHumanPlayers();

local IsMarathonSong = function(song_data)
	return song_data.length >= 16
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

				local accuracy_potion = 0
				local stamina_potion = 0
				local agility_potion = 0
				local doubling_potion = 0
				local squirrel_effigy_songs = {}
				local wrench = 0
				local bape_shirt = 0
				local black_garb = 0
				local tpa_standard = 0
				local order_of_vidopnir = 0
				local memepeace_beret = 0
				local slime_badge = 0
				local nomad_cloak = 0

				local twin_lance_multipler = 1

				for i=1,7 do
					local song_played = ECS.Player.SongsPlayed[i]
					if song_played ~= nil then
						total_points = total_points + song_played.points
						-- Relics are only active if you passed the song you used them on.
						if not song_played.failed then
							local accuracy_potion_used = false
							local stamina_potion_used = false
							local agility_potion_used = false
							local doubling_potion_used = false
							local wrench_used = false
							local bape_shirt_used = false
							local black_garb_used = false
							local tpa_standard_used = false
							local order_of_vidopnir_used = false
							local memepeace_beret_used = false
							local slime_badge_used = false
							local nomad_cloak_used = false

							for relic in ivalues(song_played.relics_used) do
								if relic.name == "Accuracy Potion" then
									accuracy_potion_used = true
								end
								if relic.name == "Stamina Potion" then
									stamina_potion_used = true
								end
								if relic.name == "Agility Potion" then
									agility_potion_used = true
								end
								if relic.name == "Doubling Potion" then
									doubling_potion_used = true
								end
								if relic.name == "Squirrel Effigy" then
									if squirrel_effigy_songs[song_played.name] == nil then
										squirrel_effigy_songs[song_played.name] = {pass_count = 0, pre_bp_points = 0}
									end
								end
								if relic.name == "Wrench" then
									wrench_used = true
								end
								if relic.name == "Bape Shirt" then
									bape_shirt_used = true
								end
								if relic.name == "Black Garb" then
									black_garb_used = true
								end
								if relic.name == "TPA Standard" then
									tpa_standard_used = true
								end
								if relic.name == "Order of Vidopnir" then
									order_of_vidopnir_used = true
								end
								if relic.name == "Memepeace Beret" then
									memepeace_beret_used = true
								end
								if relic.name == "Slime Badge" then
									slime_badge_used = true
								end
								if relic.name == "Nomad Cloak" then
									nomad_cloak_used = true
								end

								if relic.name == "Twin Lance" then
									twin_lance_multipler = 2
								end
							end

							accuracy_potion = accuracy_potion + (accuracy_potion_used and 1 or 0) * twin_lance_multipler
							stamina_potion = stamina_potion + (stamina_potion_used and 1 or 0) * twin_lance_multipler
							agility_potion = agility_potion + (agility_potion_used and 1 or 0) * twin_lance_multipler
							doubling_potion = doubling_potion + (doubling_potion_used and 1 or 0) * twin_lance_multipler
							wrench = wrench + (wrench_used and 1 or 0) * twin_lance_multipler
							bape_shirt = bape_shirt + (bape_shirt_used and 1 or 0) * twin_lance_multipler
							black_garb = black_garb + (black_garb_used and 1 or 0) * twin_lance_multipler
							tpa_standard = tpa_standard + (tpa_standard_used and 1 or 0) * twin_lance_multipler
							order_of_vidopnir = order_of_vidopnir + (order_of_vidopnir_used and 1 or 0) * twin_lance_multipler
							memepeace_beret = memepeace_beret + (memepeace_beret_used and 1 or 0) * twin_lance_multipler
							slime_badge = slime_badge + (slime_badge_used and 1 or 0) * twin_lance_multipler
							nomad_cloak = nomad_cloak + (nomad_cloak_used and 1 or 0) * twin_lance_multipler
						end
					end
				end

				-- Add additional BP from the end of set relics
				local songs_passed = 0
				local total_bpm = 0
				local tiers = {}
				local total_steps = 0
				local total_score = 0
				local total_over_95 = 0
				local marathons_played = 0

				for song_played in ivalues(ECS.Player.SongsPlayed) do
					if not song_played.failed then
						total_bpm = total_bpm + song_played.bpm
						if tiers[song_played.bpm_tier] == nil then
							tiers[song_played.bpm_tier] = 0
						end
						tiers[song_played.bpm_tier] = tiers[song_played.bpm_tier] + 1
						total_steps = total_steps + song_played.steps
						songs_passed = songs_passed + 1
						total_score = total_score + song_played.score
						if song_played.score >= 0.95 then
							total_over_95 = total_over_95 + 1
						end

						for song_name, data in pairs(squirrel_effigy_songs) do
							if squirrel_effigy_songs[song_name] ~= nil and song_played.name == song_name then
								data.pass_count = math.max(data.pass_count, song_played.pass_count)
								data.pre_bp_points = math.max(data.pre_bp_points, song_played.pre_bp_points)
							end
						end

						if IsMarathonSong(song_played) then
							marathons_played = marathons_played + 1
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

				if accuracy_potion > 0 then total_points = total_points + (math.max(math.floor(1000^(total_score / songs_passed)-50), 0)) * accuracy_potion end
				if stamina_potion > 0 then total_points = total_points + (math.floor(total_steps / 45)) * stamina_potion end
				if agility_potion > 0 then total_points = total_points + (math.floor((math.floor(total_bpm / songs_passed) - 120)^1.3)) * agility_potion end
				if doubling_potion > 0 then total_points = total_points + (math.floor(40 * math.pow(2, doubling_potion - 1))) * doubling_potion end
				
				for song_name, data in pairs(squirrel_effigy_songs) do
					local pre_bp_point_total = 0
					if data.pass_count >= 2 then
						pre_bp_point_total = pre_bp_point_total + data.pre_bp_points
					end
					total_points = total_points + (math.floor(pre_bp_point_total / 7.5)) * twin_lance_multipler
				end

				if wrench > 0 then total_points = total_points + (250 * marathons_played) * wrench end
				
				if bape_shirt > 0 then total_points = total_points + (songs_passed * 5) * bape_shirt end
				if black_garb > 0 then total_points = total_points + math.floor(songs_passed^2.2) * black_garb end
				if tpa_standard > 0 then total_points = total_points + (100 * total_over_95) * tpa_standard end

				if order_of_vidopnir > 0 then
					local top_7_ap = 0
					for i=1,7 do
						local song_played = ECS.Player.SongsPlayed[i]
						if song_played then
							top_7_ap = top_7_ap + math.ceil(song_played.score ^ 4 * 1000)
						end
					end
					total_points = total_points + math.floor(top_7_ap / 3) * order_of_vidopnir
				end

				if memepeace_beret > 0 then total_points = total_points + (100 * beret_tiers) * memepeace_beret end
				if slime_badge > 0 then total_points = total_points + (100 * slime_tiers) * slime_badge end
				
				if nomad_cloak > 0 then
					total_points = total_points + math.min(math.floor(songs_passed / 2) * 225, 900) * nomad_cloak
				end

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
