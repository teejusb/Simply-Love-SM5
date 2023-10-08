local t = Def.ActorFrame{}

t[#t+1] = Def.Sprite {
		Texture=THEME:GetPathG("", "_ECS/bg.jpg"),
		InitCommand=function(self)
			self:xy(SCREEN_CENTER_X, SCREEN_CENTER_Y):zoom(SCREEN_HEIGHT/	self:GetHeight())
		end,
	}

t[#t+1] = Def.Quad{
	InitCommand=function(self)
		self:Center():FullScreen():diffuse(Color.Black):diffusealpha(0.2)
	end
}

return t