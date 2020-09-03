local InputHandler = function(event)
	if not event then return false end
	if event.type == "InputEventType_FirstPress" and event.GameButton == "Back" then
		 if CurrentGameIsSupported() and StepManiaVersionIsSupported() then
			 SCREENMAN:GetTopScreen():Cancel()
		 end
	end
	return false
end

local a = Def.Actor{}

a.OnCommand=function(self) SCREENMAN:GetTopScreen():AddInputCallback( InputHandler ) end
a.BeginCommand=function(self)
	-- we might have just backed out of ScreenThemeOptions ("Simply Love Options")
	-- in which case we'll want to call ThemePrefs.Save() now
	ThemePrefs.Save()

	-- but, we might have also just backed out of ScreenSelectGame ("System Options")
	-- where we might have just changed the language, in which case the ThemePrefsRows table
	-- needs to update its text to use that language.
	SL_CustomPrefs.Init()
end

-- OffCommand() will be called if the player tries to leave the operator menu by choosing an OptionRow
-- it will not be called if the player presses the "Back" MenuButton (typically Esc on a keyboard),
-- so we handle that case using a Lua InputCallback function
a.OffCommand=function(self)
	if SCREENMAN:GetTopScreen():AllAreOnLastRow() then
		if not CurrentGameIsSupported() then
			SM( THEME:GetString("ScreenInit", "UnsupportedGame"):format(GAMESTATE:GetCurrentGame():GetName()) )
			SCREENMAN:SetNewScreen("ScreenSystemOptions")
		end

		if not StepManiaVersionIsSupported() then
			SM( THEME:GetString("ScreenInit", "UnsupportedSMVersion"):format(ProductVersion()) )
			SCREENMAN:SetNewScreen("ScreenSystemOptions")
		end
	end
end

return a