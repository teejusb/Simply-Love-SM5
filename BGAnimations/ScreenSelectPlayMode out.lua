return Def.Actor{
	OffCommand=function(self)
		self:sleep(0.9)
		if GetDivision() == nil then return end

		if ECS.Mode == "ECS" then
			if GetDivision() == "upper" then
				local default = SONGMAN:FindSong("ECS13 - Upper/[24] [240] Opasnyje Jadjernaja")
				if default then
					GAMESTATE:SetPreferredSong(default)
				end
			elseif GetDivision() == "mid" then
				local default = SONGMAN:FindSong("ECS13 - Mid/[18] [180] Fractal Glitch Works (Part 3)")
				if default then
					GAMESTATE:SetPreferredSong(default)
				end
			else
				local default = SONGMAN:FindSong("ECS13 - Lower/[12] [120] Adventure")
				if default then
					GAMESTATE:SetPreferredSong(default)
				end
			end
		elseif ECS.Mode == "Speed" then
			local default = SONGMAN:FindSong("ECS13 - Upper Marathon/HIGHER TEMPO")
			if default then
				GAMESTATE:SetPreferredSong(default)
			end
		elseif ECS.Mode == "Marathon" then
			if GetDivision() == "upper" then
				local default = SONGMAN:FindSong("ECS13 - Lower Marathon/TIMELESS BEATZ")
				if default then
					GAMESTATE:SetPreferredSong(default)
				end
			elseif GetDivision() == "mid" then
				local default = SONGMAN:FindSong("ECS13 - Mid Marathon/NO MORE GAMES")
				if default then
					GAMESTATE:SetPreferredSong(default)
				end
			else
				local default = SONGMAN:FindSong("ECS13 - Speed/[24] [240] Satanic Static")
				if default then
					GAMESTATE:SetPreferredSong(default)
				end
			end
		end
	end
}