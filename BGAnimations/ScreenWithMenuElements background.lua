local t = Def.ActorFrame{}

t[#t+1] = Def.Sprite {
		Texture=THEME:GetPathG("", "_ECS/pendulum.png"),
		InitCommand=function(self)
			self:xy(SCREEN_CENTER_X + 250, 0):blend("BlendMode_Add"):zoom(0.6):rotationz(-40)
		end,
		OnCommand=function(self)
			self:queuecommand("Tick")
		end,
		TickCommand=function(self)
			if SCREENMAN:GetTopScreen():GetName() == "ScreenTitleMenu" or
					SCREENMAN:GetTopScreen():GetName() == "ScreenInit" then
				SOUND:PlayOnce(THEME:GetPathG("", "_ECS/ticktock2.ogg"))
			end
			self:accelerate(0.5):rotationz(0):decelerate(0.5):rotationz(40)
			self:queuecommand("Tock")
			
		end,
		TockCommand=function(self)
			if SCREENMAN:GetTopScreen():GetName() == "ScreenTitleMenu" or
					SCREENMAN:GetTopScreen():GetName() == "ScreenInit" then
				SOUND:PlayOnce(THEME:GetPathG("", "_ECS/ticktock2.ogg"))
			end
			self:accelerate(0.5):rotationz(0):decelerate(0.5):rotationz(-40)
			self:queuecommand("Tick")
			
		end
	}

t[#t+1] = Def.Quad{
	InitCommand=function(self)
		self:Center():FullScreen():diffuse(Color.Black):diffusealpha(0.2)
	end
}

return t