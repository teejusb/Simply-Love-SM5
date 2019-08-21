-- assume that all human players failed
local img = "failed text.png"

local ApplyRelicActions = function()
	for active_relic in ivalues(ECS.Player.Relics) do
		active_relic.action()
	end
end

-- loop through all available human players
for player in ivalues(GAMESTATE:GetHumanPlayers()) do
	-- if any of them passed, we want to display the "cleared" graphic
	if not STATSMAN:GetCurStageStats():GetPlayerStageStats(player):GetFailed() then
		img = "cleared text.png"
	end
end

return Def.ActorFrame {
	OnCommand=function(self) ApplyRelicActions() end,
	OffCommand=function(self)
		-- always undo the effects of Astral Ring/Astral Earring when leaving ScreenEval, even if they weren't active
		SL.Global.ActiveModifiers.WorstTimingWindow = 5
		PREFSMAN:SetPreference("TimingWindowSecondsW4", SL.Preferences.ITG.TimingWindowSecondsW4)
		PREFSMAN:SetPreference("TimingWindowSecondsW5", SL.Preferences.ITG.TimingWindowSecondsW5)

		-- Protect ring functions differently for ECS8, but no reason not to always set fail type appropriately.
		local player_state = GAMESTATE:GetPlayerState(GAMESTATE:GetMasterPlayerNumber())
		if player_state then
			local po = player_state:GetPlayerOptions("ModsLevel_Preferred")
			if po then
				po:FailSetting('FailType_ImmediateContinue')
			end
		end

		-- always undo the effects of any relics that change LifeDifficulty when leaving ScreenEval, even if they weren't active
		PREFSMAN:SetPreference("LifeDifficultyScale", 1)
	end,

	Def.Quad{
		InitCommand=cmd(FullScreen; diffuse, Color.Black),
		OnCommand=cmd(sleep,0.2; linear,0.5; diffusealpha,0),
	},

	LoadActor(img)..{
		InitCommand=cmd(Center; zoom,0.8; diffusealpha,0),
		OnCommand=cmd(accelerate,0.4; diffusealpha,1; sleep,0.6; decelerate,0.4; diffusealpha,0)
	}
}