local t = Def.ActorFrame{}

t[#t+1] = Def.Sprite {
		Texture=THEME:GetPathG("", "_ECS/bg (doubleres).png"),
		InitCommand=function(self)
			self:Center():zoom(0.9)
		end,
	}

t[#t+1] = Def.Quad{
	InitCommand=function(self)
		self:Center():FullScreen():diffuse(Color.Black):diffusealpha(0.2)
	end
}

return t