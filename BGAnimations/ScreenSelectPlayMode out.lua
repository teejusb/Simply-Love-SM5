return Def.Actor{
	OffCommand=function(self)
		self:sleep(0.9)

		if ECS.Mode == "ECS8" then
			local swinging_fox = SONGMAN:FindSong("ECS8 - Upper/[18] [200] #swinging_fox")
			if swinging_fox then
				GAMESTATE:SetPreferredSong(swinging_fox)
			end
		end
	end
}