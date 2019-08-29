local dark = {0,0,0,0.9}
local light = {0.65,0.65,0.65,1}

local settimer_seconds = 3600

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
	and (ECS.Mode == "Warmup" or (ECS.Mode == "ECS8" and SL.Global.Stages.PlayedThisGame >= 7))
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
	SM("updating")
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
	InitCommand=function(self) self:queuecommand("PostInit") end,
	PostInitCommand=function(self)
		if PREFSMAN:GetPreference("EventMode") and ECS.Mode ~= "Marathon" then
			-- TimeAtSessionStart will be reset to nil between game sesssions
			-- thus, if it's currently nil, we're loading ScreenSelectMusic
			-- for the first time this particular game session
			if SCREENMAN:GetTopScreen():GetName() == "ScreenSelectMusic" and SL.Global.TimeAtSessionStart == nil then
				SL.Global.TimeAtSessionStart = GetTimeSinceStart()
			end

			breaktimer_at_screen_start = ECS.BreakTimer
			seconds_at_screen_start = GetTimeSinceStart()

			if SL.Global.TimeAtSessionStart ~= nil then
				self:SetUpdateFunction( Update )
			end

			deduct_from_breaktimer = DeductFromBreakTimer()
		end
	end,

	Def.Quad{
		InitCommand=function(self)
			self:zoomto(_screen.w, 32):vertalign(top):x(_screen.cx)
			if ThemePrefs.Get("RainbowMode") then
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

	-- Screen Name
	Def.BitmapText{
		Name="HeaderText",
		Font="_wendy small",
		Text=ScreenString("HeaderText"),
		InitCommand=cmd(diffusealpha,0; zoom,WideScale(0.5,0.6); horizalign, left; xy, 10, 15 ),
		OnCommand=cmd(sleep, 0.1; decelerate,0.33; diffusealpha,1),
		OffCommand=cmd(accelerate,0.33; diffusealpha,0)
	},

	-- Warmup | ECS8 | Marathon
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

if ECS.Mode ~= "Marathon" then
	af[#af+1] = Def.ActorFrame{
		OnCommand=function(self)
			local screen_name = SCREENMAN:GetTopScreen():GetName()
			if screen_name == "ScreenEvaluationSummary"	then
				self:visible(false)
			end
		end,

		-- Session Timer
		Def.BitmapText{
			Font="_wendy small",
			Name="SessionTimer",
			InitCommand=function(self)
				sessiontimer_actor = self
				self:diffusealpha(0):zoom( WideScale(0.5,0.6) ):xy(_screen.cx-100, 15):halign(0)
			end,
			OnCommand=function(self)
				if not PREFSMAN:GetPreference("EventMode") then
					self:settext( SSM_Header_StageText() )
				end

				self:sleep(0.1):decelerate(0.33):diffusealpha(1)
			end,
		},
	}

	-- Only add BreakTimer in ECS8 Mode
	if ECS.Mode == "ECS8" then
		-- Break Timer
		af[#af+1] = Def.BitmapText{
			Font="_wendy small",
			Name="BreakTimer",
			InitCommand=function(self)
				breaktimer_actor = self
				self:diffusealpha(0):zoom( WideScale(0.5,0.6) ):xy(_screen.cx+50, 15):halign(0)
			end,
			OnCommand=function(self)
				if not PREFSMAN:GetPreference("EventMode") then
					self:settext( SSM_Header_StageText() )
				end

				self:sleep(0.1):decelerate(0.33):diffusealpha(1)
			end,
		}
	end

	-- SessionHasEnded warning
	af[#af+1] = Def.ActorFrame{
		InitCommand=function(self) self:visible(false):diffusealpha(0) end,
		SessionHasEndedCommand=function(self)
			for player in ivalues(GAMESTATE:GetHumanPlayers()) do
				SCREENMAN:set_input_redirected(player, true)
			end
			SCREENMAN:GetTopScreen():AddInputCallback( InputHandler )
			self:visible(true):linear(0.15):diffusealpha(1)
		end,
		FadeOutWarningMessageCommand=function(self) self:linear(0.15):diffusealpha(0):queuecommand("Hide") end,
		HideCommand=function(self)
			SCREENMAN:GetTopScreen():RemoveInputCallback(InputHandler)
			for player in ivalues(GAMESTATE:GetHumanPlayers()) do
				SCREENMAN:set_input_redirected(player, false)
			end
			self:visible(false)
		end,

		Def.Quad{
			InitCommand=function(self) self:diffuse(0,0,0,0.925):FullScreen():Center() end
		},

		Def.BitmapText{
			Font="_miso",
			InitCommand=function(self) self:xy(_screen.cx, 200):wrapwidthpixels(380/1.5):zoom(1.5) end,
			SessionHasEndedCommand=function(self)
				local s = "Your " .. ECS.Mode .. " session has ended because you"
				if ECS.Mode == "ECS8" then
					if ECS.BreakTimer < 0 then
						s = s .. " used up all your break time!\n\n"
					else
						s = s .. " played more than 7 songs and your set has lasted longer than 1 hour!\n\n"
					end
				elseif ECS.Mode == "Warmup" then
					s = s .. "'ve played longer than 1 hour!\n\n"
				end

				s = s .. "Unless there are some extenuating circumstances that Ian has approved, it looks like your finished, bud.\n\n"
				s = s .. "Please press &START; to dismiss this message, then exit your set."

				self:settext(s)
			end
		}
	}
end

return af