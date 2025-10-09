local t = Def.ActorFrame{
	OffCommand=function(self)
		local topscreen = SCREENMAN:GetTopScreen()
		if topscreen then
			self:linear(0.1)
			self:diffusealpha(0)
		end
	end,

	LoadActor( THEME:GetPathG("", "_header.lua") ),
}

return t