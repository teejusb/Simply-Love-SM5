function OptionRowEditorNoteskin()
	local skins = NOTESKIN:GetNoteSkinNames()
	return {
		Name = "Editor Noteskin",
		LayoutType = "ShowOneInRow",
		SelectType = "SelectOne",
		OneChoiceForAllPlayers = true,
		ExportOnChange = false,
		Choices = skins,
		LoadSelections = function(self, list, pn)
			local skin = PREFSMAN:GetPreference("EditorNoteSkinP1") or
				PREFSMAN:GetPreference("EditorNoteSkinP2") or
				THEME:GetMetric("Common", "DefaultNoteSkinName")
			if not skin then return end

			local i = FindInTable(skin, skins) or 1
			list[i] = true
		end,
		SaveSelections = function(self, list, pn)
			for i = 1, #skins do
				if list[i] then
					PREFSMAN:SetPreference("EditorNoteSkinP1", skins[i])
					PREFSMAN:SetPreference("EditorNoteSkinP2", skins[i])
					break
				end
			end
		end,
	}
end

function OptionRowLongAndMarathonTime( str )
	local choices = {
		Long={Choices=SecondsToMMSS_range(150, 300, 15), Values=range(150, 300, 15)},
		Marathon={Choices=SecondsToMMSS_range(300, 600, 15), Values=range(300, 600, 15)}
	}

	choices.Long.Choices[#choices.Long.Choices+1] = THEME:GetString("ThemePrefs", "Off")
	choices.Long.Values[#choices.Long.Values+1] = 999999
	choices.Marathon.Choices[#choices.Marathon.Choices+1] = THEME:GetString("ThemePrefs", "Off")
	choices.Marathon.Values[#choices.Marathon.Values+1] = 999999

	return {
		Name = str .. " Time",
		LayoutType = "ShowOneInRow",
		SelectType = "SelectOne",
		OneChoiceForAllPlayers = true,
		ExportOnChange = false,
		Choices = choices[str].Choices,
		LoadSelections = function(self, list, pn)
			if PREFSMAN:GetPreference(str.."VerSongSeconds") == 999999 then
				list[#list] = true
			else
				local time = SecondsToMMSS(PREFSMAN:GetPreference(str.."VerSongSeconds")):gsub("^0*", "")
				local i = FindInTable(time, choices[str].Choices) or 1
				list[i] = true
			end
		end,
		SaveSelections = function(self, list, pn)
			for i = 1, #choices[str].Choices do
				if list[i] then
					PREFSMAN:SetPreference(str.."VerSongSeconds", choices[str].Values[i])
					break
				end
			end
		end,
	}
end

function OptionRowMusicWheelSpeed()

	local choices = { "Slow", "Normal", "Fast", "Faster", "Ridiculous", "Ludicrous", "Plaid" }
	local values = { 5, 10, 15, 25, 30, 45, 100 }
	local localized_choices = {}

	for i=1, #choices do
		localized_choices[i] = THEME:GetString("MusicWheelSpeed", choices[i] )
	end

	-- it's possible the user has manually edited Preferences.ini and set an arbitrary value
	-- try to accommodate, rather than obliterating that custom setting
	local user_setting = PREFSMAN:GetPreference("MusicWheelSwitchSpeed") or 15
	if not FindInTable(user_setting, values) then
		values[#values+1] = user_setting
		choices[ #choices+1 ] = THEME:GetString("MusicWheelSpeed", "Custom")
	end

	return {
		Name = "MusicWheelSpeed",
		LayoutType = "ShowAllInRow",
		SelectType = "SelectOne",
		OneChoiceForAllPlayers = true,
		ExportOnChange = false,
		Choices = localized_choices,
		LoadSelections = function(self, list, pn)
			local i = FindInTable(user_setting, values) or 1
			list[i] = true
		end,
		SaveSelections = function(self, list, pn)
			for i = 1, #values do
				if list[i] then
					PREFSMAN:SetPreference("MusicWheelSwitchSpeed", values[i] )
					break
				end
			end
		end
	}
end

function OptionRowTheme()
	return {
		Name = "Theme",
		Choices = THEME:GetSelectableThemeNames(),
		LayoutType = "ShowAllInRow",
		SelectType = "SelectOne",
		OneChoiceForAllPlayers = true,
		ExportOnChange = false,
		LoadSelections = function(self, list, pn)
			local theme = THEME:GetCurThemeName()
			if not theme then return end

			local i = FindInTable(theme, self.Choices) or 1
			list[i] = true
		end,
		SaveSelections = function(self, list, pn)
			for i=1, #list do
				if list[i] then
					if self.Choices[i] ~= THEME:GetCurThemeName() then
						-- if the user is switching to some other version of SL they have installed
						-- don't bother them with the ResetPreferences prompt; just switch to that theme
						-- try a simple check first
						if self.Choices[i]:match("Simply Love")	then
							THEME:SetTheme( self.Choices[i] )
							return
						end

						-- if not, attempt a more roundabout check by peeking into the new theme's ThemeInfo.ini
						if FILEMAN:DoesFileExist("/Themes/"..self.Choices[i].."/ThemeInfo.ini") then
							local info = IniFile.ReadFile("/Themes/"..self.Choices[i].."/ThemeInfo.ini")
							if info and info.ThemeInfo and info.ThemeInfo.DisplayName and info.ThemeInfo.DisplayName:match("Simply Love") then
								THEME:SetTheme( self.Choices[i] )
								return
							end
						end

						-- if not, we'll assume the new theme is different enough to warrant prompting the user
						SL.NextTheme = self.Choices[i]
						SCREENMAN:GetTopScreen():SetNextScreenName("ScreenPromptToResetPreferencesToStock")
					end
				end
			end
		end,
	}
end


-- the OptionRow for changing the VideoRenderer should only appear in Windows
-- (see [ScreenOptionsGraphicsSound] in Metrics.ini), but we'll make an effort
-- to present valid choices in macOS and Linux, Just In Case.
function OptionRowVideoRendererWindows()

	-- opengl is a valid VideoRenderer for all architectures, so start
	-- by assuming it is the only choice.
	local choices = { "opengl" }
	local values  = { "opengl" }

	-- Windows also has d3d as a VideoRenderer, and the convention(?)
	-- there is to list both in Preferences.ini, but only use the first
	local architecture = HOOKS:GetArchName():lower()
	if architecture:match("windows") then
		table.insert(choices, "d3d")
		values = { "opengl,d3d", "d3d,opengl" }
	end

	return {
		Name = "VideoRenderer",
		Choices = choices,
		LayoutType = "ShowAllInRow",
		SelectType = "SelectOne",
		OneChoiceForAllPlayers = true,
		ExportOnChange = false,
		LoadSelections = function(self, list, pn)
			local pref = PREFSMAN:GetPreference("VideoRenderers")

			-- Multiple comma-delimited VideoRenderers may be listed, but
			-- we only want the first because that's the one actually in use.
			-- Split the string on commas, get the first match found, and
			-- immediately break from the loop.
			for renderer in pref:gmatch("(%w+),?") do
				pref = renderer
				break
			end

			if not pref then return end

			local i = FindInTable(pref, self.Choices) or 1
			list[i] = true
		end,
		SaveSelections = function(self, list, pn)
			for i=1, #list do
				if list[i] then
					PREFSMAN:SetPreference("VideoRenderers", values[i])
					break
				end
			end
		end,
	}
end