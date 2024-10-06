local player = ...

local af = Def.ActorFrame{
	InitCommand=function(self) end,
	OnCommand=function(self)
		local song = GAMESTATE:GetCurrentSong()
		local ecs_player = ECS.Players[PROFILEMAN:GetPlayerName(player)]

		local song_name = song:GetDisplayFullTitle()

		local stats = STATSMAN:GetCurStageStats():GetPlayerStageStats(player)
		local PercentDP = stats:GetPercentDancePoints()
		local percent = FormatPercentScore(PercentDP)
		-- Format the Percentage string, removing the % symbol
		percent = percent:gsub("%%", "")
		local score = tonumber(percent)/100

		local failed = stats:GetFailed()

		if ECS.Mode == "ECS" or ECS.Mode == "Speed" then
			AddPlayedSong(ecs_player, song_name, score, ECS.Player.Relics, failed)
		elseif ECS.Mode == "Marathon" and IsPlayingMarathon() then	
			ECS.Player.MarathonRateMod = SL.Global.ActiveModifiers.MusicRate	
			ECS.Player.TotalMarathonPoints = 35000 * score

			if ECS.Player.UsedHeroCape then
				ECS.Player.TotalMarathonPoints = ECS.Player.TotalMarathonPoints + 100
			end

			if not failed then
				ECS.Player.TotalMarathonPoints = ECS.Player.TotalMarathonPoints + 10000
			end
			-- Relics for marathons are always applied regardless of pass/fail.
			for relic in ivalues(ECS.Player.Relics) do
				if relic.name ~= "(nothing)" then
					ECS.Player.TotalMarathonPoints = (ECS.Player.TotalMarathonPoints +
						relic.score(ecs_player, --[[song_info=]]nil, --[[song_data=]]nil, ECS.Player.Relics, --[[ap=]]nil, score))
				end
			end
			ECS.Player.TotalMarathonPoints = math.floor(ECS.Player.TotalMarathonPoints)
		end
	end,
}

return af