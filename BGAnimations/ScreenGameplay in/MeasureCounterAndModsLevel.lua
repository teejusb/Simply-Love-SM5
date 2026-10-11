return function(SongNumberInCourse)
	for player in ivalues(GAMESTATE:GetHumanPlayers()) do

		-- get the PlayerOptions string for any human players and store it now
		-- we'll retrieve it the next time ScreenSelectMusic loads and re-apply those same mods
		-- in this way, we can override the effects of songs that forced modifiers during gameplay
		-- the old-school (ie. ITG) way of GAMESTATE:ApplyGameCommand()
		local pn = ToEnumShortString(player)
		SL[pn].PlayerOptionsString = GAMESTATE:GetPlayerState(player):GetPlayerOptionsString("ModsLevel_Preferred")

		local has_les_paul = false
		for relic in ivalues(ECS.Player.Relics) do
			if relic.name == "Les Paul" then
				has_les_paul = true
				break
			end
		end

		has_les_paul = true

		if has_les_paul then
			local mods = SL[pn].ActiveModifiers
			local player_options = GAMESTATE:GetPlayerState(player):GetPlayerOptions("ModsLevel_Song")
			local original = ECS.Player.LesPaulOriginalSettings[pn] or {}
			original.Mini = original.Mini or mods.Mini
			original.BackgroundFilter = original.BackgroundFilter or mods.BackgroundFilter
			original.NoteFieldOffsetX = original.NoteFieldOffsetX or mods.NoteFieldOffsetX
			original.NoteFieldOffsetY = original.NoteFieldOffsetY or mods.NoteFieldOffsetY
			original.DataVisualizations = original.DataVisualizations or mods.DataVisualizations
			original.MeasureLines = original.MeasureLines or mods.MeasureLines
			original.PlayerMini = original.PlayerMini or player_options:Mini()
			original.Reverse = original.Reverse or player_options:Reverse()
			ECS.Player.LesPaulOriginalSettings[pn] = original

			mods.Mini = "0%"
			mods.BackgroundFilter = "Off"
			mods.NoteFieldOffsetX = 0
			mods.NoteFieldOffsetY = 0
			mods.DataVisualizations = "None"
			mods.MeasureLines = "Quarter"
			player_options:Mini(0)
			player_options:Reverse(1)
		end

		-- Check if MeasureCounter are turned on.
		-- We may need to parse the chart
		local mods = SL[pn].ActiveModifiers
		if mods.MeasureCounter and mods.MeasureCounter ~= "None" then

			local steps = nil

			if GAMESTATE:IsCourseMode() then
				local trail = GAMESTATE:GetCurrentTrail(player):GetTrailEntries()[SongNumberInCourse+1]
				steps = trail:GetSteps()
			else
				steps = GAMESTATE:GetCurrentSteps(player)
			end

			-- This will parse out and set all the required info for the chart in the SL.Streams cache,
			-- The function will only do work iff we're parsing a chart different than what's in the cache.
			ParseChartInfo(steps, pn)

			if (mods.MeasureCounter and mods.MeasureCounter ~= "None") then
				-- Set the actual stream information for the player based on their selected notes threshold.
				local notesThreshold = tonumber(mods.MeasureCounter:match("%d+"))
				SL[pn].Streams.Measures = GetStreamSequences(SL[pn].Streams.NotesPerMeasure, notesThreshold)
			end
		end
	end
end
