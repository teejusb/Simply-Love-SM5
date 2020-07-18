-- tables of rgba values
local dark  = {0,0,0,0.9}
local light = {0.65,0.65,0.65,1}

local settimer_seconds = 60 * 60


local ArvinsGambitIsActive = function()
	for active_relic in ivalues(ECS.Player.Relics) do
		if active_relic.name == "Arvin's Gambit" then
			return true
		end
	end
	return false
end

if ArvinsGambitIsActive() then
	settimer_seconds = 20 * 60
end

local endgame_warning_has_been_issued = false

local breaktimer_at_screen_start
local seconds_at_screen_start

local deduct_from_breaktimer = false
local add_to_sessiontimer = false

local sessiontimer_actor
local breaktimer_actor

-- roll our own SecondsToMMSS() because SM's bundled
-- helper doesn't handle negative time correctly :)
local SecondsToMMSS = function(seconds)
	local minutes
	if seconds >= 0 then
		minutes = string.format("%02d", math.floor(seconds / 60))
	else
		minutes = string.format("%02d", math.ceil(seconds / 60))
	end

	local seconds = string.format("%02d", math.floor(math.abs(seconds) % 60))
	return minutes..":"..seconds
end

local SessionHasEnded = function()
	if ECS.Mode == "ECS8" and ECS.BreakTimer < 0 then return true end

	if SL.Global.TimeAtSessionStart
	and (GetTimeSinceStart() - SL.Global.TimeAtSessionStart > settimer_seconds)
	and (ECS.Mode == "Warmup" or (ECS.Mode == "ECS8" and SL.Global.Stages.PlayedThisGame >= 7) or ArvinsGambitIsActive())
	then
		return true
	end

	return false
end

local InputHandler = function(event)
	if not event.PlayerNumber or not event.button then return false end

	if event.type == "InputEventType_FirstPress" and event.GameButton == "Start" then
		MESSAGEMAN:Broadcast("FadeOutWarning")
	end

	return false
end

local Update = function(af, dt)
	if SL.Global.TimeAtSessionStart ~= nil then
		local session_seconds = GetTimeSinceStart() - SL.Global.TimeAtSessionStart

		-- if this game session is less than 1 hour in duration so far
		if session_seconds < settimer_seconds then
			sessiontimer_actor:settext( SecondsToMMSS(session_seconds) )
		else
			sessiontimer_actor:settext( SecondsToHHMMSS(session_seconds) ):diffuse(1,0,0,1)
		end

		if deduct_from_breaktimer then
			ECS.BreakTimer = breaktimer_at_screen_start - (GetTimeSinceStart() - seconds_at_screen_start)
		end

		if breaktimer_actor then
			breaktimer_actor:settext( SecondsToMMSS(ECS.BreakTimer) )

			-- BREAK'S OVER
			if ECS.BreakTimer < 0 then
				breaktimer_actor:diffuse(1,0,0,1)
			end
		end

		if SessionHasEnded() and (not endgame_warning_has_been_issued) then
			if SCREENMAN:GetTopScreen():GetName() == "ScreenGameplay" then
				if ECS.Mode == "Warmup" then
					-- Force users out of screen gameplay if their set timer has ended.
					SCREENMAN:GetTopScreen():PostScreenMessage("SM_BeginFailed", 0)
				end
			elseif SCREENMAN:GetTopScreen():GetName() == "ScreenSelectMusic" then
				endgame_warning_has_been_issued = true
				af:queuecommand("SessionHasEnded")
			end
		end
	end
end

local DeductFromBreakTimer = function()
	if ECS.Mode == "Warmup" then return false end

	local screen_name = SCREENMAN:GetTopScreen():GetName()

	if screen_name == "ScreenSelectMusic"
	or screen_name == "ScreenPlayerOptions"
	or screen_name == "ScreenPlayerOptions2"
	or screen_name == "ScreenEvaluationStage" then
		return true
	end

	return false
end

local af = Def.ActorFrame{
	Name="Header",

	Def.Quad{
		InitCommand=function(self)
			self:zoomto(_screen.w, 32):vertalign(top):x(_screen.cx)
			if DarkUI() then
				self:diffuse(dark)
			else
				self:diffuse(light)
			end
		end,
		ScreenChangedMessageCommand=function(self)
			local topscreen = SCREENMAN:GetTopScreen():GetName()
			if SL.Global.GameMode == "Casual" and (topscreen == "ScreenEvaluationStage" or topscreen == "ScreenEvaluationSummary") then
				self:diffuse(dark)
			end
		end,
	},

	LoadFont("Common Header")..{
		Name="HeaderText",
		Text=ScreenString("HeaderText"),
		InitCommand=function(self) self:diffusealpha(0):horizalign(left):xy(10, 15):zoom( SL_WideScale(0.5,0.6) ) end,
		OnCommand=function(self) self:sleep(0.1):decelerate(0.33):diffusealpha(1) end,
		OffCommand=function(self) self:accelerate(0.33):diffusealpha(0) end
	},

	-- Freeplay | Warmup | ECS8 | Marathon
	Def.BitmapText{
		Name="GameModeText",
		Font="_wendy small",
		InitCommand=function(self)
			self:diffusealpha(0):zoom( WideScale(0.5,0.6)):xy(_screen.w-70, 15):halign(1)
			if not PREFSMAN:GetPreference("MenuTimer") then
				self:x(_screen.w-10)
			end
		end,
		OnCommand=function(self)
			local screen_name = SCREENMAN:GetTopScreen():GetName()

			if screen_name == "ScreenSelectMusic"
			or screen_name == "ScreenEquipRelics"
			or screen_name == "ScreenPlayerOptions"
			or screen_name == "ScreenPlayerOptions2"
			or screen_name == "ScreenEvaluationStage"
			or screen_name == "ScreenEvaluationSummary"
			then
				self:settext(THEME:GetString("ScreenSelectPlayMode", ECS.Mode))
				self:sleep(0.1):decelerate(0.33):diffusealpha(1)
			end
		end,
		UpdateHeaderTextCommand=function(self)
			self:settext(THEME:GetString("ScreenSelectPlayMode", ECS.Mode))
		end
	}
}
