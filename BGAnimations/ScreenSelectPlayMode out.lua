return Def.Actor{
	OffCommand=function(self)
		self:sleep(0.9)

		if ECS.Mode == "ECS8" then
			if PlayerIsUpper() then 
				local extrasolar_planets = SONGMAN:FindSong("ECS8 - Upper/[18] [187] Extrasolar Planets For Business")
				if extrasolar_planets then
					GAMESTATE:SetPreferredSong(extrasolar_planets)
				end
			else
				local discovery = SONGMAN:FindSong("ECS8 - Lower/[12] [130] Discovery")
				if discovery then
					GAMESTATE:SetPreferredSong(discovery)
				end
			end
		elseif ECS.Mode == "Marathon" then

		end
	end
}