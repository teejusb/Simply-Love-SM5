local t = Def.ActorFrame{}

t[#t+1] = Def.Sprite {
		Texture=THEME:GetPathG("", "_ECS/bg 2x2 (doubleres).png"),
		Frame0000="0",
		Delay0000="0.1",
		Frame0001="1",
		Delay0001="0.1",
		Frame0002="2",
		Delay0002="0.1",
		Frame0003="3",
		Delay0003="0.1",
		InitCommand=function(self)
			self:Center():addy(-70):zoom(0.65)
		end,
	}

t[#t+1] = Def.Quad{
	InitCommand=function(self)
		self:Center():FullScreen():diffuse(Color.Black):diffusealpha(0.2)
	end
}

return t